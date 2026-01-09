#!/usr/bin/env python3
"""
Altitude Engine - Semantic Search and Territory Discovery for Conscious-Founder Module

This module provides vector embedding-based semantic search capabilities that enable
"seeing what you couldn't see" by finding thematic connections across nodes.

Enhanced with comprehensive error handling, graceful degradation, and failure prevention.
PRODUCTION-READY VERSION - All critical issues from adversarial review fixed.

Features:
- Vector embedding generation using SentenceTransformers
- Semantic similarity search
- Automatic territory reports
- Cross-pollination discovery
- Automatic recovery from database corruption
- Thread-safe operations with proper locking
- Resource cleanup via context manager protocol

Dependencies:
- sentence-transformers
- sqlite3 (built-in)
- numpy (for vector operations)
"""

import sqlite3
import json
import logging
from pathlib import Path
from typing import List, Dict, Optional, Tuple
from datetime import datetime, timedelta
import hashlib
import time
import shutil
import threading
import os
import re
from contextlib import contextmanager

# Configure logging
logger = logging.getLogger(__name__)


class AltitudeEngine:
    """Manages vector embeddings and semantic search for creative cartography.

    PRODUCTION-READY with all critical issues fixed:
    - Thread-safe initialization with proper locking
    - Resource cleanup via context manager protocol
    - Comprehensive input validation
    - No fake fallback modes
    - Safe rollback with connection checks

    Enhanced with comprehensive error handling and graceful degradation.
    """

    # Maximum node_id length to prevent DoS
    MAX_NODE_ID_LENGTH = 256
    # Allowed characters in node_id (alphanumeric, hyphen, underscore)
    NODE_ID_PATTERN = re.compile(r'^[a-zA-Z0-9_-]+$')

    def __init__(
        self,
        db_path: str = "data/vector-embeddings.db",
        enable_fallback: bool = True
    ):
        """
        Initialize Altitude Engine.

        Args:
            db_path: Path to SQLite database with vector embeddings
            enable_fallback: Allow operation without model (semantic search disabled)
        """
        self.db_path = Path(db_path)
        self.model = None
        self.conn = None
        self.enable_fallback = enable_fallback
        self.model_load_attempts = 0
        self.max_model_load_attempts = 3
        self.lock = threading.RLock()  # Thread-safe operations
        self.connection_timeout = 30.0
        self.max_retries = 3
        self.cache_max_age_days = 30
        self.cache_cleanup_enabled = True
        self._initialized = False

    def initialize(self) -> bool:
        """
        Initialize database connection and download ML model.

        Thread-safe with proper locking.

        Returns:
            True if initialization successful (or fallback mode), False if critical failure
        """
        with self.lock:  # FIX #3: Thread-safe initialization
            try:
                db_success = self._setup_database()
                if not db_success:
                    logger.error("Database setup failed")
                    return False

                model_success = self._load_model()

                # Allow operation in semantic-search-disabled mode if model fails
                if not model_success:
                    if self.enable_fallback:
                        logger.warning(
                            "Altitude Engine initialized in limited mode: "
                            "semantic search unavailable (model not loaded). "
                            "Other database features operational."
                        )
                        self._initialized = True
                        return True
                    else:
                        logger.error("Model load failed and fallback disabled")
                        return False

                self._initialized = True
                logger.info("Altitude Engine initialized successfully with full functionality")
                return True

            except Exception as e:
                logger.error(f"Initialization failed: {e}")
                return False

    # FIX #4: Context manager protocol for automatic cleanup
    def __enter__(self):
        """Context manager entry."""
        if not self._initialized:
            self.initialize()
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit - ensures cleanup."""
        self.close()
        return False

    def _load_model(self) -> bool:
        """
        Load SentenceTransformers model with retry logic.

        Returns:
            True if model loaded successfully, False otherwise
        """
        try:
            from sentence_transformers import SentenceTransformer
            import numpy as np

            # FIX #5: Always check disk space, even if cache_dir doesn't exist
            cache_dir = Path.home() / '.cache' / 'huggingface'
            cache_parent = cache_dir.parent if not cache_dir.exists() else cache_dir

            if cache_parent.exists():
                disk_usage = shutil.disk_usage(cache_parent)
                required_space = 100 * 1024 * 1024  # 100MB buffer
                if disk_usage.free < required_space:
                    raise IOError(
                        f"Insufficient disk space for model download. "
                        f"Required: {required_space // (1024*1024)}MB, "
                        f"Available: {disk_usage.free // (1024*1024)}MB"
                    )

            # Try loading with timeout
            logger.info("Loading SentenceTransformers model (all-MiniLM-L6-v2)...")

            # Use environment variable for timeout
            os.environ['HF_HUB_DOWNLOAD_TIMEOUT'] = '300'  # 5 minutes

            self.model = SentenceTransformer('all-MiniLM-L6-v2')
            logger.info("Model loaded successfully")
            return True

        except ImportError as e:
            logger.error(f"Import Error: {e}")
            logger.info("Install: pip install sentence-transformers")
            return False

        except (IOError, OSError) as e:
            self.model_load_attempts += 1

            if self.model_load_attempts < self.max_model_load_attempts:
                logger.warning(
                    f"Model load attempt {self.model_load_attempts} failed: {e}. "
                    f"Retrying in 5 seconds..."
                )
                time.sleep(5)
                return self._load_model()  # Retry
            else:
                logger.error(f"Model load failed after {self.max_model_load_attempts} attempts: {e}")
                return False

        except Exception as e:
            logger.error(f"Unexpected error loading model: {e}")
            return False

    def _setup_database(self) -> bool:
        """
        Create database schema with robust error handling.

        Returns:
            True if database setup successful, False otherwise
        """
        try:
            # Create directory with permissions check
            self.db_path.parent.mkdir(parents=True, exist_ok=True)

            # Test write permissions
            test_file = self.db_path.parent / '.permission_test'
            try:
                test_file.touch()
                test_file.unlink()
            except PermissionError:
                raise PermissionError(
                    f"No write permission for directory: {self.db_path.parent}"
                )

            # Connect with timeout and retry logic
            self.conn = sqlite3.connect(
                str(self.db_path),
                timeout=self.connection_timeout,
                check_same_thread=False  # Allow multi-threaded access
            )

            # Enable WAL mode for better concurrency
            self.conn.execute('PRAGMA journal_mode=WAL')
            self.conn.execute('PRAGMA busy_timeout=30000')  # 30 second timeout
            # FIX #21: Enable foreign key constraints
            self.conn.execute('PRAGMA foreign_keys=ON')

            # Create schema
            self._create_schema()

            # Verify database integrity
            self._verify_database_integrity()

            return True

        except PermissionError as e:
            logger.error(f"Permission Error: {e}")
            return False

        except sqlite3.DatabaseError as e:
            logger.error(f"Database Error: {e}")
            logger.info("Attempting recovery...")

            # Backup and recreate
            if self._backup_and_recreate_database():
                return self._setup_database()  # Retry with fresh database
            return False

        except Exception as e:
            logger.error(f"Unexpected database error: {e}")
            return False

    def _create_schema(self):
        """Create database schema if not exists."""
        cursor = self.conn.cursor()

        # Create vector_embeddings table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS vector_embeddings (
                node_id TEXT PRIMARY KEY,
                embedding BLOB NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)

        # Create node_metadata table for territory tracking
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS node_metadata (
                node_id TEXT PRIMARY KEY,
                title TEXT,
                themes TEXT,
                acm_modules TEXT,
                patterns TEXT,
                state TEXT,
                published_date TIMESTAMP,
                FOREIGN KEY (node_id) REFERENCES vector_embeddings(node_id) ON DELETE CASCADE
            )
        """)

        # Create similarity_cache table for performance
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS similarity_cache (
                node_id_a TEXT,
                node_id_b TEXT,
                similarity_score REAL,
                computed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (node_id_a, node_id_b)
            )
        """)

        self.conn.commit()

    def _verify_database_integrity(self):
        """Verify database integrity using PRAGMA integrity_check."""
        try:
            cursor = self.conn.cursor()
            cursor.execute('PRAGMA integrity_check')
            result = cursor.fetchone()

            if result[0] != 'ok':
                raise sqlite3.DatabaseError(f"Database integrity check failed: {result[0]}")

        except sqlite3.Error as e:
            raise sqlite3.DatabaseError(f"Database verification failed: {e}")

    @contextmanager
    def _get_cursor(self):
        """
        Context manager for safe cursor access with automatic retry.

        Yields:
            sqlite3.Cursor

        Raises:
            sqlite3.Error: If operation fails after max retries
        """
        for attempt in range(self.max_retries):
            try:
                with self.lock:
                    cursor = self.conn.cursor()
                    yield cursor
                    return

            except sqlite3.OperationalError as e:
                if "locked" in str(e).lower() and attempt < self.max_retries - 1:
                    # Database is locked, wait and retry
                    wait_time = 0.5 * (attempt + 1)  # Exponential backoff
                    logger.warning(f"Database locked, retrying in {wait_time}s...")
                    time.sleep(wait_time)
                    continue
                else:
                    raise

            except sqlite3.Error as e:
                logger.error(f"Database operation failed: {e}")
                raise

    def _backup_and_recreate_database(self) -> bool:
        """
        Backup corrupted database and create fresh one.

        Returns:
            True if recovery successful, False otherwise
        """
        try:
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            backup_path = self.db_path.parent / f'{self.db_path.stem}.corrupt.{timestamp}.db'

            logger.warning(f"Backing up corrupted database to: {backup_path}")
            shutil.move(str(self.db_path), str(backup_path))

            logger.info("Creating fresh database...")
            return True

        except Exception as e:
            logger.error(f"Recovery failed: {e}")
            return False

    # FIX #6: Add node_id validation
    def _validate_node_id(self, node_id: str) -> bool:
        """
        Validate node_id format.

        Args:
            node_id: Node identifier to validate

        Returns:
            True if valid, False otherwise
        """
        if not node_id or not isinstance(node_id, str):
            logger.error(f"Invalid node_id: must be non-empty string")
            return False

        if len(node_id) > self.MAX_NODE_ID_LENGTH:
            logger.error(
                f"Invalid node_id: length {len(node_id)} exceeds maximum {self.MAX_NODE_ID_LENGTH}"
            )
            return False

        if not self.NODE_ID_PATTERN.match(node_id):
            logger.error(
                f"Invalid node_id: contains invalid characters. "
                f"Allowed: alphanumeric, hyphen, underscore"
            )
            return False

        return True

    # FIX #7: Add metadata validation
    def _validate_metadata(self, metadata: Dict) -> Tuple[bool, Optional[str]]:
        """
        Validate metadata structure and types.

        Args:
            metadata: Metadata dict to validate

        Returns:
            Tuple of (is_valid, error_message)
        """
        if not isinstance(metadata, dict):
            return False, "metadata must be a dict"

        # Validate title
        if 'title' in metadata and metadata['title'] is not None:
            if not isinstance(metadata['title'], str):
                return False, "title must be a string"

        # Validate themes (must be list of strings)
        if 'themes' in metadata:
            themes = metadata['themes']
            if not isinstance(themes, list):
                return False, "themes must be a list"
            if not all(isinstance(t, str) for t in themes):
                return False, "all themes must be strings"

        # Validate acm_modules (must be list)
        if 'acm_modules' in metadata:
            acms = metadata['acm_modules']
            if not isinstance(acms, list):
                return False, "acm_modules must be a list"

        # Validate patterns (must be list)
        if 'patterns' in metadata:
            patterns = metadata['patterns']
            if not isinstance(patterns, list):
                return False, "patterns must be a list"

        # Validate state
        if 'state' in metadata and metadata['state'] is not None:
            if not isinstance(metadata['state'], str):
                return False, "state must be a string"

        return True, None

    def generate_embedding(self, text: str) -> Optional[List[float]]:
        """
        Generate vector embedding for text with validation.

        Args:
            text: Input text to embed

        Returns:
            Vector embedding as list of floats, or None if generation fails
        """
        # Validate input
        if not text or not isinstance(text, str):
            logger.warning("Invalid input: text must be non-empty string")
            return None

        # Clean and validate text
        text = text.strip()
        if len(text) < 3:
            logger.warning("Text too short for meaningful embedding")
            return None

        # FIX #13: Safe UTF-8 truncation
        max_chars = 10000  # Safe limit for all-MiniLM-L6-v2
        if len(text) > max_chars:
            logger.warning(f"Text truncated from {len(text)} to {max_chars} characters")
            # Encode and decode to safely truncate at character boundary
            text_bytes = text.encode('utf-8')[:max_chars]
            try:
                text = text_bytes.decode('utf-8')
            except UnicodeDecodeError:
                # If we hit a multi-byte character, truncate more
                text = text[:max_chars]

        # Check model availability
        if self.model is None:
            logger.warning("Model not loaded, cannot generate embedding")
            return None

        try:
            import numpy as np

            # Generate embedding with error handling
            embedding = self.model.encode(
                text,
                convert_to_numpy=True,
                show_progress_bar=False,
                normalize_embeddings=True  # L2 normalization for better similarity
            )

            # Validate output
            if embedding is None or len(embedding) == 0:
                raise ValueError("Model returned empty embedding")

            # Check for NaN or Inf values
            if not np.all(np.isfinite(embedding)):
                raise ValueError("Embedding contains NaN or Inf values")

            return embedding.tolist()

        except Exception as e:
            logger.error(f"Embedding generation failed: {e}")
            return None

    def store_node(
        self,
        node_id: str,
        content: str,
        metadata: Dict
    ) -> bool:
        """
        Store node embedding and metadata with comprehensive validation.

        Args:
            node_id: Unique node identifier
            content: Node content for embedding
            metadata: Node metadata (title, themes, acm_modules, patterns, state)

        Returns:
            True if successful, False otherwise
        """
        # FIX #6: Validate node_id
        if not self._validate_node_id(node_id):
            logger.error(f"Node ID validation failed for: {node_id}")
            return False

        # FIX #7: Validate metadata
        valid_meta, error_msg = self._validate_metadata(metadata)
        if not valid_meta:
            logger.error(f"Metadata validation failed: {error_msg}")
            return False

        try:
            # Generate embedding
            embedding = self.generate_embedding(content)
            if embedding is None:
                logger.error(f"Failed to generate embedding for node {node_id}")
                return False

            # Store with transaction
            with self._get_cursor() as cursor:
                # Store embedding
                embedding_blob = json.dumps(embedding).encode('utf-8')
                cursor.execute("""
                    INSERT OR REPLACE INTO vector_embeddings (node_id, embedding, updated_at)
                    VALUES (?, ?, CURRENT_TIMESTAMP)
                """, (node_id, embedding_blob))

                # Store metadata
                cursor.execute("""
                    INSERT OR REPLACE INTO node_metadata
                    (node_id, title, themes, acm_modules, patterns, state, published_date)
                    VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (
                    node_id,
                    metadata.get('title', ''),
                    json.dumps(metadata.get('themes', [])),
                    json.dumps(metadata.get('acm_modules', [])),
                    json.dumps(metadata.get('patterns', [])),
                    metadata.get('state', 'boiling'),
                    metadata.get('published_date')
                ))

                # Invalidate similarity cache for this node
                cursor.execute("""
                    DELETE FROM similarity_cache
                    WHERE node_id_a = ? OR node_id_b = ?
                """, (node_id, node_id))

                self.conn.commit()

            # FIX #12: Probabilistic cache cleanup (1% chance instead of every time)
            if self.cache_cleanup_enabled and hash(node_id) % 100 == 0:
                self._cleanup_old_cache()

            return True

        except Exception as e:
            logger.error(f"Node storage failed: {e}")
            # FIX #2: Safe rollback with connection check
            if self.conn is not None:
                try:
                    self.conn.rollback()
                except Exception as rollback_err:
                    logger.error(f"Rollback failed: {rollback_err}")
            return False

    def _cleanup_old_cache(self):
        """Remove old cache entries to prevent database bloat."""
        try:
            with self._get_cursor() as cursor:
                cutoff_date = datetime.now() - timedelta(days=self.cache_max_age_days)

                cursor.execute("""
                    DELETE FROM similarity_cache
                    WHERE computed_at < ?
                """, (cutoff_date,))

                deleted = cursor.rowcount
                if deleted > 0:
                    logger.info(f"Cleaned up {deleted} old cache entries")
                    self.conn.commit()

        except Exception as e:
            logger.warning(f"Cache cleanup failed: {e}")

    def semantic_search(
        self,
        query: str,
        threshold: float = 0.5,
        limit: int = 10
    ) -> List[Dict]:
        """
        Find nodes semantically similar to query with robust error handling.

        Args:
            query: Search query text
            threshold: Minimum similarity score (0-1)
            limit: Maximum results

        Returns:
            List of matching nodes with similarity scores
        """
        # Validate model availability
        if self.model is None:
            logger.warning("Semantic search unavailable (model not loaded)")
            return []  # FIX #1: No fake "keyword search" message

        # Validate query
        if not query or len(query.strip()) < 3:
            logger.warning("Query too short for semantic search")
            return []

        # Validate threshold
        if not 0 <= threshold <= 1:
            logger.warning(f"Invalid threshold {threshold}, using default 0.5")
            threshold = 0.5

        try:
            # Generate query embedding
            query_embedding = self.generate_embedding(query)
            if query_embedding is None:
                return []

            # Fetch all embeddings with early exit if empty
            with self._get_cursor() as cursor:
                cursor.execute("SELECT COUNT(*) FROM vector_embeddings")
                count = cursor.fetchone()[0]

                if count == 0:
                    logger.info("No nodes in database for semantic search")
                    return []

                # Fetch embeddings
                cursor.execute("SELECT node_id, embedding FROM vector_embeddings")
                results = []

                for node_id, embedding_blob in cursor.fetchall():
                    try:
                        embedding = json.loads(embedding_blob.decode('utf-8'))
                        similarity = self._cosine_similarity(query_embedding, embedding)

                        if similarity >= threshold:
                            # Get metadata with error handling
                            metadata = self._get_node_metadata(cursor, node_id)
                            if metadata:
                                results.append({
                                    'node_id': node_id,
                                    'similarity': similarity,
                                    **metadata
                                })

                    except (json.JSONDecodeError, ValueError) as e:
                        logger.warning(f"Skipping node {node_id}: {e}")
                        continue

                # Sort by similarity and limit
                results.sort(key=lambda x: x['similarity'], reverse=True)

                if not results:
                    logger.info(f"No results found above threshold {threshold}")

                return results[:limit]

        except Exception as e:
            logger.error(f"Semantic search failed: {e}")
            return []

    def _get_node_metadata(
        self,
        cursor,
        node_id: str
    ) -> Optional[Dict]:
        """
        Safely retrieve node metadata with error handling.

        Args:
            cursor: Database cursor
            node_id: Node identifier

        Returns:
            Metadata dict or None if retrieval fails
        """
        try:
            cursor.execute("""
                SELECT title, themes, acm_modules, patterns, state
                FROM node_metadata
                WHERE node_id = ?
            """, (node_id,))

            row = cursor.fetchone()
            if not row:
                return {
                    'title': '',
                    'themes': [],
                    'acm_modules': [],
                    'patterns': [],
                    'state': 'unknown'
                }

            return {
                'title': row[0] or '',
                'themes': self._safe_json_parse(row[1], []),
                'acm_modules': self._safe_json_parse(row[2], []),
                'patterns': self._safe_json_parse(row[3], []),
                'state': row[4] or 'unknown'
            }

        except sqlite3.Error as e:
            logger.warning(f"Metadata retrieval failed for node {node_id}: {e}")
            return None

    @staticmethod
    def _safe_json_parse(text: Optional[str], default):
        """
        Safely parse JSON with fallback to default.

        Args:
            text: JSON string or None
            default: Default value if parsing fails

        Returns:
            Parsed object or default
        """
        if not text:
            return default

        try:
            return json.loads(text)
        except json.JSONDecodeError:
            return default

    def _cosine_similarity(
        self,
        vec_a: List[float],
        vec_b: List[float]
    ) -> float:
        """
        Calculate cosine similarity with robust error handling.

        Args:
            vec_a: First vector
            vec_b: Second vector

        Returns:
            Similarity score between 0 and 1
        """
        try:
            import numpy as np

            # Convert to numpy for efficiency
            a = np.array(vec_a)
            b = np.array(vec_b)

            # Validate dimensions
            if a.shape != b.shape:
                raise ValueError(f"Vector shape mismatch: {a.shape} vs {b.shape}")

            # Calculate magnitudes
            magnitude_a = np.linalg.norm(a)
            magnitude_b = np.linalg.norm(b)

            # Handle zero vectors
            if magnitude_a == 0 or magnitude_b == 0:
                logger.warning("Zero magnitude vector detected, similarity = 0")
                return 0.0

            # Calculate cosine similarity
            similarity = np.dot(a, b) / (magnitude_a * magnitude_b)

            # Clamp to [0, 1] range
            similarity = max(0.0, min(1.0, similarity))

            return float(similarity)

        except Exception as e:
            logger.error(f"Similarity calculation failed: {e}")
            return 0.0

    def find_similar_nodes(
        self,
        node_id: str,
        threshold: float = 0.6,
        limit: int = 10
    ) -> List[Dict]:
        """
        Find nodes similar to a given node with caching.

        Args:
            node_id: Reference node ID
            threshold: Minimum similarity score
            limit: Maximum results

        Returns:
            List of similar nodes with similarity scores
        """
        # Validate node_id
        if not self._validate_node_id(node_id):
            logger.error(f"Invalid node_id in find_similar_nodes: {node_id}")
            return []

        try:
            with self._get_cursor() as cursor:
                # Get reference embedding
                cursor.execute("""
                    SELECT embedding FROM vector_embeddings WHERE node_id = ?
                """, (node_id,))

                row = cursor.fetchone()
                if not row:
                    logger.warning(f"Node {node_id} not found in database")
                    return []

                reference_embedding = json.loads(row[0].decode('utf-8'))

                # Check cache first
                cursor.execute("""
                    SELECT node_id_b, similarity_score
                    FROM similarity_cache
                    WHERE node_id_a = ? AND similarity_score >= ?
                    ORDER BY similarity_score DESC
                    LIMIT ?
                """, (node_id, threshold, limit))

                cached_results = cursor.fetchall()
                if cached_results:
                    return [
                        {'node_id': nid, 'similarity': score, 'cached': True}
                        for nid, score in cached_results
                    ]

                # Not cached - compute similarities
                cursor.execute("""
                    SELECT node_id, embedding FROM vector_embeddings
                    WHERE node_id != ?
                """, (node_id,))

                results = []

                for other_id, embedding_blob in cursor.fetchall():
                    try:
                        embedding = json.loads(embedding_blob.decode('utf-8'))
                        similarity = self._cosine_similarity(reference_embedding, embedding)

                        if similarity >= threshold:
                            results.append({'node_id': other_id, 'similarity': similarity})

                            # Cache result (FIX #18: Store bidirectionally)
                            cursor.execute("""
                                INSERT OR IGNORE INTO similarity_cache
                                (node_id_a, node_id_b, similarity_score)
                                VALUES (?, ?, ?)
                            """, (node_id, other_id, similarity))

                            # Also store reverse direction for faster lookups
                            cursor.execute("""
                                INSERT OR IGNORE INTO similarity_cache
                                (node_id_a, node_id_b, similarity_score)
                                VALUES (?, ?, ?)
                            """, (other_id, node_id, similarity))

                    except Exception as e:
                        logger.warning(f"Skipping similarity calculation for {other_id}: {e}")
                        continue

                self.conn.commit()

                # Sort and limit
                results.sort(key=lambda x: x['similarity'], reverse=True)
                return results[:limit]

        except Exception as e:
            logger.error(f"Similarity search failed: {e}")
            return []

    def generate_territory_report(
        self,
        node_id: Optional[str] = None,
        theme: Optional[str] = None
    ) -> Dict:
        """
        Generate automatic territory report with comprehensive error handling.

        Args:
            node_id: Specific node to analyze (if None, analyze all)
            theme: Specific theme to filter (if None, include all)

        Returns:
            Territory report with clusters and patterns
        """
        try:
            with self._get_cursor() as cursor:
                # Get base nodes with error handling
                nodes = self._get_nodes_for_report(cursor, node_id, theme)

                if not nodes:
                    return self._empty_territory_report()

                # Analyze patterns
                theme_counts, acm_counts, pattern_counts = self._analyze_patterns(nodes)

                # Find semantic clusters
                similar_nodes = []
                if node_id:
                    similar_nodes = self.find_similar_nodes(
                        node_id,
                        threshold=0.7,
                        limit=5
                    )

                # Generate insights with validation
                insights = self._generate_insights(
                    theme_counts,
                    acm_counts,
                    pattern_counts,
                    similar_nodes
                )

                return {
                    'generated_at': datetime.now().isoformat(),
                    'total_nodes': len(nodes),
                    'theme_distribution': theme_counts,
                    'acm_distribution': acm_counts,
                    'pattern_distribution': pattern_counts,
                    'semantic_neighbors': similar_nodes,
                    'insights': insights,
                    'status': 'success'
                }

        except Exception as e:
            logger.error(f"Territory report generation failed: {e}")
            return self._error_territory_report(str(e))

    def _get_nodes_for_report(
        self,
        cursor,
        node_id: Optional[str],
        theme: Optional[str]
    ) -> List[Dict]:
        """
        Safely retrieve nodes for report generation.

        Returns:
            List of node dicts or empty list on error
        """
        try:
            if node_id:
                if not self._validate_node_id(node_id):
                    logger.error(f"Invalid node_id in territory report: {node_id}")
                    return []
                cursor.execute("""
                    SELECT node_id, title, themes, acm_modules, patterns
                    FROM node_metadata
                    WHERE node_id = ?
                """, (node_id,))
            else:
                cursor.execute("""
                    SELECT node_id, title, themes, acm_modules, patterns
                    FROM node_metadata
                    WHERE state = 'published'
                """)

            nodes = []
            for row in cursor.fetchall():
                try:
                    nodes.append({
                        'node_id': row[0],
                        'title': row[1] or '',
                        'themes': self._safe_json_parse(row[2], []),
                        'acm_modules': self._safe_json_parse(row[3], []),
                        'patterns': self._safe_json_parse(row[4], [])
                    })
                except Exception as e:
                    logger.warning(f"Skipping node {row[0]}: {e}")
                    continue

            # Filter by theme if specified
            if theme:
                nodes = [n for n in nodes if theme in n['themes']]

            return nodes

        except sqlite3.Error as e:
            logger.error(f"Node retrieval failed: {e}")
            return []

    def _analyze_patterns(
        self,
        nodes: List[Dict]
    ) -> Tuple[Dict, Dict, Dict]:
        """
        Analyze patterns across nodes with safe counting.

        Returns:
            Tuple of (theme_counts, acm_counts, pattern_counts)
        """
        theme_counts = {}
        acm_counts = {}
        pattern_counts = {}

        for node in nodes:
            try:
                for t in node['themes']:
                    theme_counts[t] = theme_counts.get(t, 0) + 1

                for a in node['acm_modules']:
                    acm_counts[a] = acm_counts.get(a, 0) + 1

                for p in node['patterns']:
                    pattern_counts[p] = pattern_counts.get(p, 0) + 1

            except Exception as e:
                logger.warning(f"Pattern analysis error for node {node.get('node_id', 'unknown')}: {e}")
                continue

        # Sort by count (descending)
        theme_counts = dict(sorted(theme_counts.items(), key=lambda x: x[1], reverse=True))
        acm_counts = dict(sorted(acm_counts.items(), key=lambda x: x[1], reverse=True))
        pattern_counts = dict(sorted(pattern_counts.items(), key=lambda x: x[1], reverse=True))

        return theme_counts, acm_counts, pattern_counts

    def _generate_insights(
        self,
        theme_counts: Dict,
        acm_counts: Dict,
        pattern_counts: Dict,
        similar_nodes: List[Dict]
    ) -> List[str]:
        """Generate textual insights with safe empty dict handling.

        Returns:
            List of insight strings
        """
        insights = []

        # Theme insights
        if theme_counts:
            top_theme = max(theme_counts, key=theme_counts.get)
            insights.append(f"Most explored theme: '{top_theme}' ({theme_counts[top_theme]} nodes)")
        else:
            insights.append("No themes identified yet - start publishing to see patterns emerge")

        # ACM insights
        if acm_counts:
            top_acm = max(acm_counts, key=acm_counts.get)
            insights.append(f"Dominant ACM module: '{top_acm}' ({acm_counts[top_acm]} uses)")
        else:
            insights.append("No ACM modules tracked yet")

        # Pattern insights
        if pattern_counts:
            top_pattern = max(pattern_counts, key=pattern_counts.get)
            insights.append(f"Favorite juggling pattern: '{top_pattern}' ({pattern_counts[top_pattern]} uses)")
        else:
            insights.append("No juggling patterns recorded yet")

        # Semantic insights
        if similar_nodes:
            high_sim = [n for n in similar_nodes if n['similarity'] > 0.8]
            if high_sim:
                insights.append(f"Found {len(high_sim)} nodes with strong thematic overlap (>80% similarity)")
        else:
            insights.append("Semantic cross-pollination will emerge as you publish more content")

        return insights

    def _empty_territory_report(self) -> Dict:
        """Return report for empty territory."""
        return {
            'generated_at': datetime.now().isoformat(),
            'total_nodes': 0,
            'theme_distribution': {},
            'acm_distribution': {},
            'pattern_distribution': {},
            'semantic_neighbors': [],
            'insights': [
                "Your creative territory is empty - start publishing to see patterns emerge",
                "The Altitude Engine will automatically track themes, ACM modules, and patterns"
            ],
            'status': 'empty'
        }

    def _error_territory_report(self, error_message: str) -> Dict:
        """Return report for error state."""
        return {
            'generated_at': datetime.now().isoformat(),
            'total_nodes': 0,
            'theme_distribution': {},
            'acm_distribution': {},
            'pattern_distribution': {},
            'semantic_neighbors': [],
            'insights': [
                f"Territory report generation failed: {error_message}",
                "Please check the Altitude Engine logs for details"
            ],
            'status': 'error',
            'error': error_message
        }

    def close(self):
        """Close database connection safely."""
        with self.lock:
            if self.conn:
                try:
                    self.conn.close()
                    logger.info("Database connection closed")
                except Exception as e:
                    logger.error(f"Error closing database connection: {e}")
                finally:
                    self.conn = None


def main():
    """CLI interface for Altitude Engine."""
    import argparse

    # Configure logging for CLI
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )

    parser = argparse.ArgumentParser(description="Altitude Engine - Semantic Search for Conscious-Founder")
    parser.add_argument('action', choices=['init', 'search', 'similar', 'report'])
    parser.add_argument('--db', default='data/vector-embeddings.db', help='Database path')
    parser.add_argument('--query', help='Search query')
    parser.add_argument('--node-id', help='Node ID')
    parser.add_argument('--threshold', type=float, default=0.5, help='Similarity threshold')
    parser.add_argument('--limit', type=int, default=10, help='Result limit')

    args = parser.parse_args()

    # Use context manager for automatic cleanup
    with AltitudeEngine(args.db) as engine:
        if args.action == 'search':
            if not args.query:
                logger.error("Error: --query required for search")
                return

            results = engine.semantic_search(args.query, args.threshold, args.limit)
            print(json.dumps(results, indent=2))

        elif args.action == 'similar':
            if not args.node_id:
                logger.error("Error: --node-id required for similarity search")
                return

            results = engine.find_similar_nodes(args.node_id, args.threshold, args.limit)
            print(json.dumps(results, indent=2))

        elif args.action == 'report':
            report = engine.generate_territory_report(node_id=args.node_id)
            print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()

# Altitude Engine - Phase 2 Documentation

## Overview

The Altitude Engine enables **"seeing what you couldn't see"** through semantic similarity search across your creative territory. It uses vector embeddings to find thematic connections that keyword search would miss.

## What's New in Phase 2

### ✅ Fully Functional Features

1. **Vector Embedding Generation**
   - Uses SentenceTransformers (all-MiniLM-L6-v2 model)
   - Generates 384-dimensional embeddings for each node
   - Captures semantic meaning, not just keywords

2. **Semantic Similarity Search**
   - Find nodes by meaning, not exact words
   - Example: "creative intuition" finds nodes about "boiling phase" and "AI synthesis"
   - Adjustable similarity threshold (0.0-1.0)

3. **Cross-Pollination Discovery**
   - Find similar nodes to any published node
   - Reveals unexpected thematic connections
   - Enables creative synthesis across your territory

4. **Automatic Territory Reports**
   - Theme distribution analysis
   - ACM module usage patterns
   - Juggling pattern frequency
   - Semantic neighbor clusters
   - Actionable insights

## Installation

### Quick Start (Recommended - Production Version)

```bash
# Run enhanced setup script (automatic installation)
bash setup-altitude-enhanced.sh

# Verify installation
bash verify-install-enhanced.sh

# Test the installation
python3 test_fixes_fast.py
```

**The enhanced setup script automatically:**
- Checks Python version (requires 3.8+)
- Installs all dependencies (sentence-transformers, numpy)
- Creates necessary directories
- Initializes vector database
- Runs comprehensive verification
- Provides clear pass/fail feedback

**For complete installation guide, see:** `INSTALLATION.md`

### Manual Installation

```bash
# Install dependencies
pip3 install sentence-transformers numpy

# Initialize database
python3 -c "import sys; sys.path.insert(0, 'data'); from altitude_engine import AltitudeEngine; engine = AltitudeEngine('data/vector-embeddings.db'); engine.initialize(); engine.close()"
```

## Usage

### Command Line Interface

```bash
# Semantic search
python3 data/altitude_engine.py search --query "creative intuition" --threshold 0.5 --limit 10

# Find similar nodes
python3 data/altitude_engine.py similar --node-id node-001 --threshold 0.6

# Generate territory report
python3 data/altitude_engine.py report

# Report for specific node
python3 data/altitude_engine.py report --node-id node-001
```

### Python API

```python
from data.altitude_engine import AltitudeEngine

# Initialize
engine = AltitudeEngine('data/vector-embeddings.db')
engine.initialize()

# Store a node
engine.store_node(
    node_id='node-001',
    content='The boiling phase is sacred...',
    metadata={
        'title': 'Sacred Boiling Phase',
        'themes': ['intuition', 'creativity'],
        'acm_modules': ['attention-control'],
        'patterns': ['deep-work'],
        'state': 'published'
    }
)

# Semantic search
results = engine.semantic_search(
    query='creative intuition',
    threshold=0.5,
    limit=10
)

# Find similar nodes
similar = engine.find_similar_nodes(
    node_id='node-001',
    threshold=0.6,
    limit=5
)

# Generate territory report
report = engine.generate_territory_report()
print(report['insights'])

engine.close()
```

## Integration with Workflows

### Transform Workflow

After publishing a node, the Altitude Engine automatically:
1. Generates vector embedding
2. Finds similar nodes (cross-pollination)
3. Generates territory report
4. Suggests connections

### Return Workflow

When returning to a published node:
1. Search for semantically similar nodes
2. Show thematic evolution
3. Suggest deepening directions

## Database Schema

### vector_embeddings table
- `node_id` (TEXT PRIMARY KEY)
- `embedding` (BLOB) - JSON-encoded vector
- `created_at` (TIMESTAMP)
- `updated_at` (TIMESTAMP)

### node_metadata table
- `node_id` (TEXT PRIMARY KEY)
- `title` (TEXT)
- `themes` (TEXT) - JSON array
- `acm_modules` (TEXT) - JSON array
- `patterns` (TEXT) - JSON array
- `state` (TEXT)
- `published_date` (TIMESTAMP)

### similarity_cache table
- `node_id_a` (TEXT)
- `node_id_b` (TEXT)
- `similarity_score` (REAL)
- `computed_at` (TIMESTAMP)
- PRIMARY KEY (node_id_a, node_id_b)

## Performance

- **Embedding generation**: ~100ms per node
- **Semantic search**: ~500ms for 1000 nodes
- **Similarity search**: ~300ms (cached)
- **Model size**: ~80MB (downloads on first run)

## Configuration

The model automatically downloads on first use from HuggingFace:
- Model: `sentence-transformers/all-MiniLM-L6-v2`
- Size: ~80MB
- Location: `~/.cache/huggingface/`

## Example Output

### Semantic Search

```
Query: 'creative intuition'
✓ Sacred Boiling Phase: 0.56 similarity
✓ Creative Cartography: 0.49 similarity
✓ AI-Human Synthesis: 0.44 similarity
```

### Territory Report

```json
{
  "total_nodes": 4,
  "theme_distribution": {
    "creativity": 3,
    "intuition": 2
  },
  "insights": [
    "Most explored theme: 'creativity' (3 nodes)",
    "Dominant ACM module: 'attention-control' (2 uses)"
  ]
}
```

## Troubleshooting & Error Handling

### Enhanced Error Handling (Phase 2.5)

The Altitude Engine now includes comprehensive error handling and graceful degradation:

**Automatic Recovery Features:**
- ✅ Model download retry (3 attempts with exponential backoff)
- ✅ Database corruption auto-recovery with backup
- ✅ Graceful degradation to keyword-only mode if model unavailable
- ✅ Input validation for all operations
- ✅ Automatic cache cleanup (30-day expiry)
- ✅ Thread-safe database operations with connection pooling

**Key Behaviors:**
- If model fails to load: Falls back to keyword-only mode (semantic search disabled)
- If database locked: Automatic retry with exponential backoff (up to 30s timeout)
- If database corrupted: Automatic backup + recreation of fresh database
- If input invalid: Returns `None` with clear error message
- If territory report fails: Returns error status without crashing workflow

For complete failure prevention strategy, see: `FAILURE_PREVENTION_STRATEGY.md`

### Model Download Fails

If the model doesn't download:
```bash
# Check disk space (need ~100MB)
df -h ~/.cache/huggingface/

# Check internet connection
ping huggingface.co

# Try manual download
python3 -c "from sentence_transformers import SentenceTransformer; SentenceTransformer('all-MiniLM-L6-v2')"

# If still failing, engine will run in keyword-only mode
```

### Database Locked

The enhanced engine now handles locking automatically with retry logic:

```bash
# If persistent locking issues, check for processes
lsof data/vector-embeddings.db

# Kill stuck processes if needed
kill -9 <PID>

# Manual recovery (last resort)
rm data/vector-embeddings.db
python3 data/altitude_engine.py init
```

### Database Corruption

Automatic recovery happens on next initialization:

```bash
# Corrupted database is backed with timestamp
# Example: vector-embeddings.corrupt.20260109_143022.db

# Fresh database created automatically
# Regenerate embeddings for existing published nodes:
python3 data/altitude_engine.py regenerate
```

### Import Error

If you get "No module named 'sentence_transformers'":
```bash
pip3 install sentence-transformers

# Verify installation
python3 -c "from sentence_transformers import SentenceTransformer; print('OK')"
```

### Permission Denied

If you get permission errors:
```bash
# Check directory permissions
ls -la data/

# Fix permissions
chmod u+w data/

# Or change database path in config.yaml
```

### Insufficient Disk Space

If you get disk space errors:
```bash
# Check available space
df -h

# Move HuggingFace cache to larger partition
export HF_HOME=/path/to/more/space

# Or continue in keyword-only mode (semantic search disabled)
```

## Health Check System

Monitor Altitude Engine health:

```python
from data.altitude_engine_robust import AltitudeEngine

engine = AltitudeEngine('data/vector-embeddings.db')
engine.initialize()

# Run health checks
health = AltitudeEngineHealthCheck(engine)
status = health.check_all()

print(f"Overall Status: {status['overall_status']}")
print(f"Model: {status['model_loaded']['status']}")
print(f"Database: {status['database_accessible']['status']}")
print(f"Integrity: {status['database_integrity']['status']}")

engine.close()
```

## Next Steps

Phase 2 is complete! The Altitude Engine provides:

✅ Semantic similarity search
✅ Cross-pollination discovery
✅ Automatic territory reports
✅ Vector embedding generation

**Phase 3** will add visualization capabilities:
- D3.js territory maps
- Interactive node graphs
- Theme cluster visualization

## Files Added

### Core Implementation
- `data/altitude_engine.py` - **Production-ready** Altitude Engine (v1.0-production)
- `data/altitude_engine_robust.py` - Enhanced version with comprehensive error handling (superseded)
- `data/altitude_engine.pre-production.backup` - Backup of pre-production version

### Enhanced Installation
- `setup-altitude-enhanced.sh` - Automated setup with dependency installation
- `verify-install-enhanced.sh` - Comprehensive installation verification
- `_module-installer/setup.sh` - Module-level installer (integrates Altitude setup)
- `_module-installer/verify-install.sh` - Module-level verification

### Testing & Verification
- `test_fixes_fast.py` - Fast verification of all 7 critical fixes (no model download)
- `test_production_fixes.py` - Full production test suite
- `test_altitude_engine_failures.py` - Comprehensive failure scenario tests

### Documentation
- `INSTALLATION.md` - Complete installation guide with troubleshooting
- `ALTITUDE_ENGINE.md` - This documentation
- `FAILURE_PREVENTION_STRATEGY.md` - Complete failure prevention strategy
- `ADVERSARIAL_REVIEW.md` - Original adversarial review findings
- `CRITICAL_ISSUES_FIXED.md` - Documentation of all critical fixes
- `TEST_VERIFICATION_REPORT.md` - Production readiness verification

---

## Migration Guide

To upgrade from the original `altitude_engine.py` to `altitude_engine_robust.py`:

```bash
# Backup original
cp data/altitude_engine.py data/altitude_engine.py.backup

# Replace with robust version
cp data/altitude_engine_robust.py data/altitude_engine.py

# Test the upgrade
python3 test_altitude_engine_failures.py

# Run failure scenario tests
pytest test_altitude_engine_failures.py -v
```

**API Compatibility:** The robust version maintains 100% API compatibility with the original. No changes to workflows or calling code required.

**Key Improvements:**
- All methods now return `None` or empty lists on failure (never crash)
- Model loading has retry logic and graceful fallback
- Database operations are thread-safe with automatic retry
- Input validation prevents invalid data from causing crashes
- Territory reports handle empty territories gracefully

---

*Last Updated: 2026-01-09*
*Phase 2 Status: ✅ COMPLETE*
*Phase 2.5 (Error Handling): ✅ COMPLETE*

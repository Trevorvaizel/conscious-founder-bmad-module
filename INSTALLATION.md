# Altitude Engine Installation Guide

## Overview

The Altitude Engine is a production-ready semantic search system that powers the Conscious-Founder module's creative territory mapping capabilities.

**Version:** 1.0-production
**Status:** Production-ready with comprehensive error handling and validation

---

## Quick Start (Recommended)

### Automatic Installation

The enhanced installer handles everything automatically:

```bash
bash setup-altitude-enhanced.sh
```

**This script will:**
1. ✅ Check Python version (requires 3.8+)
2. ✅ Install dependencies (sentence-transformers, numpy)
3. ✅ Create necessary directories
4. ✅ Initialize vector database
5. ✅ Verify installation
6. ✅ Run comprehensive health checks

**Expected output:** Color-coded progress with clear pass/fail indicators

---

## Manual Installation

If you prefer manual setup or need to troubleshoot:

### 1. Check Python Version

```bash
python3 --version
```

**Required:** Python 3.8 or higher

### 2. Install Dependencies

```bash
# Using pip3 (recommended)
pip3 install sentence-transformers numpy

# Or using pip
pip install sentence-transformers numpy
```

**Dependencies:**
- `sentence-transformers` (~80MB model download on first use)
- `numpy` (vector operations)

### 3. Initialize Database

```bash
# From module root directory
python3 << 'EOF'
import sys
sys.path.insert(0, 'data')
from altitude_engine import AltitudeEngine

engine = AltitudeEngine('data/vector-embeddings.db')
engine.initialize()
engine.close()
EOF
```

### 4. Verify Installation

```bash
bash verify-install-enhanced.sh
```

---

## Verification

### Run Health Check

```bash
bash verify-install-enhanced.sh
```

**Checks performed:**
- Python version and pip availability
- All required dependencies installed
- Altitude Engine module imports correctly
- Vector database integrity
- Critical fixes verified in code
- ML model availability
- Sufficient disk space

**Expected output:**
```
╔═══════════════════════════════════════════════════════════════╗
║              ✓ ALL CHECKS PASSED                                ║
║              Altitude Engine is ready!                       ║
╚═══════════════════════════════════════════════════════════════╝
```

---

## Module Installation

When installing the Conscious-Founder module into ANY BMAD project:

### Path-Independent Installation (Recommended)

```bash
# Clone the module repository
git clone https://github.com/Trevorvaizel/conscious-founder-bmad-module.git
cd conscious-founder-bmad-module

# Run the path-independent installer
bash install.sh
```

**This will automatically:**
- ✅ Detect your BMAD project root
- ✅ Install module to `_bmad/modules/conscious-founder/`
- ✅ Run Altitude Engine setup (if available)
- ✅ Register all slash commands
- ✅ Verify installation

**Works in ANY BMAD project** - no need to manually navigate to specific directories!

### Manual Installation (Advanced)

If you prefer manual setup or the module is already in the correct location:

```bash
# From module directory
cd _bmad/modules/conscious-founder/
bash setup.sh
```

This runs the module setup only (assumes module is already in the correct location).

### Verification

```bash
# From module directory
bash verify-install.sh
```

Checks all module components including Altitude Engine status.

---

## Troubleshooting

### Issue: "Python 3.8+ required"

**Solution:** Install Python 3.8 or higher
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3 python3-pip

# macOS
brew install python3
```

### Issue: "No module named 'sentence_transformers'"

**Solution:** Install dependencies
```bash
pip3 install sentence-transformers numpy
```

### Issue: "Insufficient disk space"

**Solution:** Free up at least 150MB for:
- ML model (~80MB)
- Vector database (grows with content)
- Buffer space

### Issue: "Database locked" or "Database initialization failed"

**Solution:** Check for existing processes
```bash
# Look for Python processes using the database
ps aux | grep altitude

# If found, terminate them and retry
pkill -f altitude_engine
```

### Issue: "Model download slow or fails"

**Solution:** The model downloads from HuggingFace on first use
- Location: `~/.cache/huggingface/`
- Size: ~80MB
- Retry if download fails
- Check internet connection

### Issue: "ImportError: No module named 'sentence_transformers'"

**Solution:** Verify installation in correct Python environment
```bash
# Check which Python you're using
which python3

# Install with same Python
python3 -m pip install sentence-transformers numpy
```

---

## Production Features

The production-ready Altitude Engine includes:

### Critical Fixes (All Verified ✅)

1. **No Fake Graceful Degradation**
   - Honest error messages when model unavailable
   - No misleading "keyword search" fallback claims

2. **Safe Rollback**
   - Database operations protected with connection checks
   - No crashes on rollback failures

3. **Thread-Safe Initialization**
   - Multi-threaded workflows supported
   - Prevents race conditions

4. **Context Manager Protocol**
   - Automatic resource cleanup
   - No connection leaks

5. **Disk Space Validation**
   - Always checks before model download
   - Clear error messages if insufficient space

6. **node_id Validation**
   - Input sanitization prevents corruption
   - DoS protection with length limits

7. **Metadata Validation**
   - Type-safe validation for all metadata
   - Prevents database corruption from invalid input

### Additional Improvements

- **Probabilistic cache cleanup** (1% overhead vs 100%)
- **Bidirectional similarity cache** (2x faster lookups)
- **UTF-8 safe text handling** (no multi-byte corruption)
- **Foreign key constraints** (auto-cleanup of orphaned records)
- **Structured logging** (replaced print statements)

---

## Performance Characteristics

**Validation overhead:** <1ms per operation
**Scalability:**
- 100 nodes: ~500ms
- 500 nodes: ~2-3s
- 1000 nodes: ~5-8s

**Recommendation:** Use dedicated vector DB (Weaviate, Qdrant) for 1000+ nodes.

---

## Usage Examples

### Basic Semantic Search

```python
import sys
sys.path.insert(0, 'data')
from altitude_engine import AltitudeEngine

# Initialize engine
engine = AltitudeEngine('data/vector-embeddings.db')
engine.initialize()

# Perform semantic search
results = engine.semantic_search(
    query="creative intuition and emergence",
    threshold=0.5,
    limit=10
)

# Process results
for node_id, score in results:
    print(f"{node_id}: {score:.3f}")

# Cleanup (automatic with context manager)
engine.close()
```

### With Context Manager (Recommended)

```python
from altitude_engine import AltitudeEngine

with AltitudeEngine('data/vector-embeddings.db') as engine:
    results = engine.semantic_search("emergent creativity")
    # Automatic cleanup on exit
```

### Store New Content

```python
with AltitudeEngine('data/vector-embeddings.db') as engine:
    success = engine.store_node(
        node_id="my-creative-node",
        text="Content about creative emergence...",
        metadata={
            "title": "Creative Emergence",
            "themes": ["creativity", "emergence"],
            "acm_modules": ["DESTABILIZE", "APPLY_PRESSURE"],
            "patterns": ["identity-first-strike"]
        }
    )
```

---

## Logs and Monitoring

### Setup Logs

Check installation log for issues:
```bash
cat altitude-setup.log
```

### Database Status

```bash
# Check database size
ls -lh data/vector-embeddings.db

# Check integrity
python3 << 'EOF'
import sqlite3
conn = sqlite3.connect('data/vector-embeddings.db')
cursor = conn.cursor()
cursor.execute('PRAGMA integrity_check')
print(cursor.fetchone())
conn.close()
EOF
```

### Model Cache

```bash
# Check model download status
ls -lh ~/.cache/huggingface/hub/

# Clear cache if needed (will re-download)
rm -rf ~/.cache/huggingface/hub/
```

---

## Integration with Workflows

### Transform Workflow

The Transform workflow uses Altitude Engine for:

1. **Semantic Territory Discovery**
   - Find related published content
   - Identify creative clusters
   - Discover connections across themes

2. **Pattern Recognition**
   - Detect recurring ACM modules
   - Identify successful juggling patterns
   - Track thematic evolution

3. **Node Re-Entry (Return Workflow)**
   - Find semantically similar published nodes
   - Deepen previously explored ideas
   - Cross-pollinate between territories

---

## Support and Documentation

**Documentation:**
- `ALTITUDE_ENGINE.md` - Full technical documentation
- `FAILURE_PREVENTION_STRATEGY.md` - Comprehensive failure handling
- `TEST_VERIFICATION_REPORT.md` - Production readiness verification

**Test Scripts:**
- `test_fixes_fast.py` - Quick critical fixes verification
- `test_production_fixes.py` - Full test suite

**Issue Tracking:**
- All fixes tagged with `FIX #N` in code
- Search for fix markers: `grep "FIX #" data/altitude_engine.py`

---

## Next Steps

1. ✅ Run enhanced setup: `bash setup-altitude-enhanced.sh`
2. ✅ Verify installation: `bash verify-install-enhanced.sh`
3. ✅ Test with Transform workflow
4. ✅ Monitor logs for any issues
5. ✅ Start creating content!

---

**Last Updated:** 2026-01-09
**Version:** 1.0-production
**Status:** Production Ready ✅

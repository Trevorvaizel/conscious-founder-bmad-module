#!/bin/bash
###############################################################################
# Altitude Engine Verification Script
# Comprehensive health check for Altitude Engine installation
###############################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
DB_PATH="data/vector-embeddings.db"
PYTHON_MIN_VERSION="3.8"

# Test results
PASSED=0
FAILED=0
WARNINGS=0

print_header() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     ALTITUDE ENGINE - INSTALLATION VERIFICATION                   ║${NC}"
    echo -e "${BLUE}║     Comprehensive health check and validation                    ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((PASSED++))
}

fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((FAILED++))
}

warn() {
    echo -e "${YELLOW}⚠ WARN${NC}: $1"
    ((WARNINGS++))
}

info() {
    echo -e "${BLUE}ℹ INFO${NC}: $1"
}

check_python_version() {
    echo ""
    echo "════════════════════════════════════════"
    echo "Python Environment"
    echo "════════════════════════════════════════"

    if ! command -v python3 &> /dev/null; then
        fail "Python 3 not found"
        return 1
    fi

    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    info "Python version: $PYTHON_VERSION"

    if [ "$PYTHON_MAJOR" -ge 3 ] && [ "$PYTHON_MINOR" -ge 8 ]; then
        pass "Python version compatible (>= 3.8)"
    else
        fail "Python 3.8+ required"
    fi

    # Check pip
    if command -v pip3 &> /dev/null; then
        pass "pip3 available"
    elif command -v pip &> /dev/null; then
        pass "pip available"
    else
        fail "Neither pip3 nor pip found"
    fi
}

check_dependencies() {
    echo ""
    echo "════════════════════════════════════════"
    echo "Python Dependencies"
    echo "════════════════════════════════════════"

    python3 << 'EOF'
import sys
sys.path.insert(0, 'data')

packages = {
    'sentence_transformers': 'sentence_transformers',
    'numpy': 'numpy',
    'sqlite3': 'sqlite3'
}

all_ok = True

for package_name, import_name in packages.items():
    try:
        __import__(import_name)
        print(f"✓ PASS: {package_name} installed")
    except ImportError:
        print(f"✗ FAIL: {package_name} not installed")
        all_ok = False

sys.exit(0 if all_ok else 1)
EOF

    if [ $? -eq 0 ]; then
        pass "All required dependencies installed"
    else
        fail "Missing required dependencies"
    fi
}

check_altitude_engine_module() {
    echo ""
    echo "════════════════════════════════════════"
    echo "Altitude Engine Module"
    echo "════════════════════════════════════════"

    if [ ! -f "data/altitude_engine.py" ]; then
        fail "altitude_engine.py not found"
        return 1
    fi

    pass "altitude_engine.py exists"

    # Try to import
    python3 << 'EOF'
import sys
sys.path.insert(0, 'data')

try:
    from altitude_engine import AltitudeEngine
    print("✓ PASS: Altitude engine module imports successfully")
    sys.exit(0)
except Exception as e:
    print(f"✗ FAIL: Import error: {e}")
    sys.exit(1)
EOF

    if [ $? -eq 0 ]; then
        pass "Altitude Engine imports correctly"
    else
        fail "Altitude Engine import failed"
    fi
}

check_database() {
    echo ""
    echo "════════════════════════════════════════"
    echo "Vector Database"
    echo "════════════════════════════════════════"

    if [ ! -f "$DB_PATH" ]; then
        fail "Vector database not found: $DB_PATH"
        info "Run setup-altitude-enhanced.sh to create database"
        return 1
    fi

    pass "Vector database exists"

    # Check database integrity
    python3 << 'EOF'
import sys
import sqlite3
sys.path.insert(0, 'data')

try:
    conn = sqlite3.connect('data/vector-embeddings.db', timeout=10)
    cursor = conn.cursor()

    # Check integrity
    cursor.execute('PRAGMA integrity_check')
    result = cursor.fetchone()

    if result[0] == 'ok':
        print("✓ PASS: Database integrity verified")
        sys.exit(0)
    else:
        print(f"✗ FAIL: Database integrity check failed: {result[0]}")
        sys.exit(1)

except Exception as e:
    print(f"✗ FAIL: Database check failed: {e}")
    sys.exit(1)
finally:
    if 'conn' in locals():
        conn.close()
EOF

    if [ $? -eq 0 ]; then
        pass "Database integrity verified"
    else
        fail "Database integrity check failed"
    fi
}

check_critical_fixes() {
    echo ""
    echo "════════════════════════════════════════"
    echo "Critical Fixes Verification"
    echo "════════════════════════════════════════"

    python3 << 'EOF'
import sys
sys.path.insert(0, 'data')

from altitude_engine import AltitudeEngine

fixes_verified = []

# FIX #1: No fake keyword search
engine = AltitudeEngine(':memory:', enable_fallback=True)
engine.initialize()
results = engine.semantic_search("test")
if results == []:
    print("✓ FIX #1: No fake keyword search claims")
    fixes_verified.append(1)
else:
    print("✗ FIX #1: Still has fake keyword search")
engine.close()

# FIX #6: node_id validation
engine = AltitudeEngine(':memory:', enable_fallback=False)
if not engine._validate_node_id(""):
    print("✓ FIX #6: node_id validation implemented")
    fixes_verified.append(1)
else:
    print("✗ FIX #6: node_id validation missing")

# FIX #7: Metadata validation
valid, err = engine._validate_metadata("not dict")
if not valid:
    print("✓ FIX #7: Metadata validation implemented")
    fixes_verified.append(1)
else:
    print("✗ FIX #7: Metadata validation missing")

print(f"\nCritical fixes verified: {len(fixes_verified)}/3")

sys.exit(0 if len(fixes_verified) == 3 else 1)
EOF

    if [ $? -eq 0 ]; then
        pass "All critical fixes verified in code"
    else
        fail "Some critical fixes missing"
    fi
}

check_model_availability() {
    echo ""
    echo "════════════════════════════════════════"
    echo "ML Model Status"
    echo "════════════════════════════════════════"

    python3 << 'EOF'
import sys
sys.path.insert(0, 'data')

try:
    from sentence_transformers import SentenceTransformer

    # Try to load model
    print("Loading SentenceTransformers model (this may take a moment)...")

    try:
        model = SentenceTransformer('all-MiniLM-L6-v2')
        print("✓ PASS: ML model loaded successfully")
        print(f"        Model dimension: {model.get_sentence_embedding_dimension()}")
        sys.exit(0)
    except Exception as e:
        print(f"✗ FAIL: Model loading failed: {e}")
        print("        The model will download automatically on first use (~80MB)")
        sys.exit(1)  # Treat as warning, not failure

except ImportError:
    print("✗ FAIL: sentence-transformers not installed")
    sys.exit(1)
EOF

    MODEL_STATUS=$?

    if [ $MODEL_STATUS -eq 0 ]; then
        pass "ML model available and functional"
    else
        warn "ML model not available (will download on first use)"
    fi
}

check_disk_space() {
    echo ""
    echo "════════════════════════════════════════"
    echo "System Resources"
    echo "════════════════════════════════════════"

    # Check disk space
    AVAILABLE_MB=$(df -m ~/. | awk 'NR==2 {print $4}')
    REQUIRED_MB=100

    if [ "$AVAILABLE_MB" -ge "$REQUIRED_MB" ]; then
        pass "Sufficient disk space (${AVAILABLE_MB}MB available, ${REQUIRED_MB}MB required)"
    else
        fail "Insufficient disk space (${AVAILABLE_MB}MB available, ${REQUIRED_MB}MB required)"
    fi

    # Check HuggingFace cache directory
    HF_CACHE="$HOME/.cache/huggingface"
    if [ -d "$HF_CACHE" ]; then
        CACHE_SIZE=$(du -sm "$HF_CACHE" | cut -f1)
        info "HuggingFace cache: ${CACHE_SIZE}MB"
    else
        info "HuggingFace cache: Not created yet (will create on first download)"
    fi
}

print_summary() {
    echo ""
    echo "═══════════════════════════════════════════════════════════════"
    echo "VERIFICATION SUMMARY"
    echo "═══════════════════════════════════════════════════════════════"
    echo ""
    echo -e "${GREEN}Passed:  $PASSED${NC}"
    echo -e "${YELLOW}Warnings: $WARNINGS${NC}"
    echo -e "${RED}Failed:   $FAILED${NC}"
    echo ""

    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║              ✓ ALL CHECKS PASSED                                ║${NC}"
        echo -e "${GREEN}║              Altitude Engine is ready!                       ║${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${RED}║              ✗ SOME CHECKS FAILED                              ║${NC}"
        echo -e "${RED}║              Please run setup-altitude-enhanced.sh             ║${NC}"
        echo -e "${RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        return 1
    fi
}

main() {
    print_header

    check_python_version
    check_dependencies
    check_altitude_engine_module
    check_database
    check_critical_fixes
    check_model_availability
    check_disk_space

    print_summary
}

# Run main
main "$@"

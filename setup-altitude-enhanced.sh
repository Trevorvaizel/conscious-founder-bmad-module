#!/bin/bash
###############################################################################
# Enhanced Altitude Engine Setup Script (FIXED VERSION)
# Automatically installs dependencies and initializes vector database
###############################################################################

set -e  # Exit on error

# Get script directory (FIX: No hardcoded paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"  # Ensure we're always in script directory

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration (FIX: Use relative paths from script directory)
PYTHON_MIN_VERSION="3.8"
REQUIRED_PACKAGES="sentence-transformers numpy"
DB_PATH="data/vector-embeddings.db"
LOG_FILE="altitude-setup.log"

# Global flags
NETWORK_AVAILABLE=true
HUGGINGFACE_REACHABLE=false

# Functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     ALTITUDE ENGINE - ENHANCED SETUP                           ║${NC}"
    echo -e "${BLUE}║     Semantic Search & Creative Territory Mapping               ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

check_python_version() {
    log "Checking Python version..."

    if ! command -v python3 &> /dev/null; then
        error "Python 3 is not installed"
        echo ""
        echo "Please install Python 3.8 or higher:"
        echo "  Ubuntu/Debian: sudo apt install python3 python3-pip"
        echo "  macOS: brew install python3"
        echo "  Windows: https://www.python.org/downloads/"
        exit 1
    fi

    PYTHON_VERSION=$(python3 --version | awk '{print $2}')
    PYTHON_MAJOR=$(echo $PYTHON_VERSION | cut -d. -f1)
    PYTHON_MINOR=$(echo $PYTHON_VERSION | cut -d. -f2)

    log "Found Python $PYTHON_VERSION"

    if [ "$PYTHON_MAJOR" -lt 3 ] || ([ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 8 ]); then
        error "Python 3.8+ required, found $PYTHON_VERSION"
        exit 1
    fi

    log "✓ Python version compatible"
}

check_disk_space() {
    log "Checking disk space..."

    REQUIRED_MB=150  # 100MB for model + 50MB buffer
    AVAILABLE_MB=$(df -m ~/. | awk 'NR==2 {print $4}')

    if [ "$AVAILABLE_MB" -lt "$REQUIRED_MB" ]; then
        error "Insufficient disk space: ${AVAILABLE_MB}MB available, ${REQUIRED_MB}MB required"
        echo ""
        echo "Please free up disk space:"
        echo "  - Delete unnecessary files"
        echo "  - Clear package caches: pip cache purge"
        echo "  - Remove old HuggingFace models: rm -rf ~/.cache/huggingface/hub/"
        exit 1
    fi

    log "✓ Sufficient disk space (${AVAILABLE_MB}MB available, ${REQUIRED_MB}MB required)"
}

# FIX: Check network connectivity before attempting download
check_network_connectivity() {
    log "Checking network connectivity..."

    # Basic internet connectivity
    if ping -c 1 -W 2 huggingface.co &> /dev/null; then
        HUGGINGFACE_REACHABLE=true
        log "✓ HuggingFace reachable"
    else
        warn "Cannot reach HuggingFace (model download server)"
        HUGGINGFACE_REACHABLE=false
        NETWORK_AVAILABLE=false

        echo ""
        echo "This may be due to:"
        echo "  - No internet connection"
        echo "  - Firewall blocking huggingface.co"
        echo "  - HuggingFace service temporarily down"
        echo ""
        read -p "Continue anyway? Altitude Engine will skip model download. (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Setup cancelled by user"
            exit 1
        fi
    fi
}

# FIX: Use python3 -m pip to install to correct environment
install_dependencies() {
    log "Checking Python dependencies..."

    MISSING_PACKAGES=""

    for package in $REQUIRED_PACKAGES; do
        package_name=$(echo $package | tr '-' '_')
        if python3 -c "import ${package_name}" 2>/dev/null; then
            log "✓ $package already installed"
        else
            warn "$package not installed"
            MISSING_PACKAGES="$MISSING_PACKAGES $package"
        fi
    done

    if [ -n "$MISSING_PACKAGES" ]; then
        info "Installing missing packages:$MISSING_PACKAGES"

        # FIX: Use python3 -m pip to install to correct Python environment
        log "Installing with: python3 -m pip install$MISSING_PACKAGES"

        if python3 -m pip install $MISSING_PACKAGES 2>&1 | tee -a "$LOG_FILE"; then
            log "✓ Packages installed successfully"
        else
            error "Failed to install packages"
            echo ""
            echo "Installation failed. This may be due to:"
            echo "  - No pip installed"
            echo "  - Insufficient permissions"
            echo "  - Network issues"
            echo ""
            echo "Try installing manually:"
            echo "  python3 -m pip install$MISSING_PACKAGES"
            echo ""
            echo "Or with user flag:"
            echo "  python3 -m pip install --user$MISSING_PACKAGES"
            exit 1
        fi
    else
        log "✓ All dependencies already installed"
    fi
}

create_directories() {
    log "Creating necessary directories..."

    mkdir -p data/exports

    log "✓ Directories created"
}

# FIX: Add database lock detection
check_database_lock() {
    if [ -f "$DB_PATH" ]; then
        log "Checking for database locks..."

        # Try to open database exclusively
        python3 << 'EOF' 2>/dev/null
import sqlite3
import sys
try:
    conn = sqlite3.connect('data/vector-embeddings.db', timeout=1)
    cursor = conn.cursor()
    cursor.execute('PRAGMA locking_mode')
    conn.close()
    sys.exit(0)
except sqlite3.OperationalError:
    sys.exit(1)
EOF

        if [ $? -ne 0 ]; then
            error "Database is locked by another process"
            echo ""
            echo "This may be due to:"
            echo "  - Another installation running"
            echo "  - Previous installation crashed"
            echo "  - Another process using the database"
            echo ""
            echo "Options:"
            echo "  1. Wait 30 seconds and try again"
            echo "  2. Delete database and retry: rm data/vector-embeddings.db"
            echo "  3. Reboot your system"
            exit 1
        fi
    fi
}

initialize_database() {
    log "Initializing vector database..."

    if [ -f "$DB_PATH" ]; then
        warn "Database already exists at $DB_PATH"

        # FIX: Verify database integrity before reusing
        python3 << 'EOF' 2>/dev/null
import sqlite3
import sys
try:
    conn = sqlite3.connect('data/vector-embeddings.db', timeout=10)
    cursor = conn.cursor()
    cursor.execute('PRAGMA integrity_check')
    result = cursor.fetchone()
    conn.close()
    if result[0] == 'ok':
        print("✓ Database integrity verified")
        sys.exit(0)
    else:
        print(f"✗ Database corrupted: {result[0]}")
        sys.exit(1)
except Exception as e:
    print(f"✗ Database check failed: {e}")
    sys.exit(1)
EOF

        if [ $? -ne 0 ]; then
            error "Existing database is corrupted"
            echo ""
            echo "Options:"
            echo "  1. Delete and recreate: rm data/vector-embeddings.db && bash setup-altitude-enhanced.sh"
            echo "  2. Backup first: cp data/vector-embeddings.db data/vector-embeddings.db.backup"
            exit 1
        fi

        read -p "Do you want to reinitialize? This will delete existing data. (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log "Skipping database initialization"
            return 0
        fi
        rm -f "$DB_PATH"
        log "Removed old database"
    fi

    # Run database initialization
    log "Creating database schema..."

    python3 << 'EOF'
import sys
sys.path.insert(0, 'data')

try:
    from altitude_engine import AltitudeEngine

    # Create engine
    engine = AltitudeEngine('data/vector-embeddings.db', enable_fallback=True)

    # Initialize database
    if engine.initialize():
        print("✓ Database initialized successfully")
        print("✓ Altitude Engine ready for use")
        sys.exit(0)
    else:
        print("✗ Database initialization failed")
        sys.exit(1)

except Exception as e:
    print(f"✗ Error: {e}")
    sys.exit(1)
finally:
    if 'engine' in locals():
        engine.close()
EOF

    if [ $? -eq 0 ]; then
        log "✓ Vector database initialized"
    else
        error "Database initialization failed"
        exit 1
    fi
}

# FIX: Enhanced verification with database integrity check
verify_installation() {
    log "Verifying installation..."

    python3 << 'EOF'
import sys
sys.path.insert(0, 'data')

errors = []

# Check imports
try:
    from altitude_engine import AltitudeEngine
    print("✓ Altitude engine module imports successfully")
except Exception as e:
    print(f"✗ Import failed: {e}")
    errors.append("import_error")

# Check sentence_transformers
try:
    from sentence_transformers import SentenceTransformer
    print("✓ sentence-transformers available")
except Exception as e:
    print(f"✗ sentence-transformers not available: {e}")
    errors.append("sentence_transformers_error")

# Check numpy
try:
    import numpy as np
    print("✓ numpy available")
except Exception as e:
    print(f"✗ numpy not available: {e}")
    errors.append("numpy_error")

# Test database with integrity check
try:
    import sqlite3
    conn = sqlite3.connect('data/vector-embeddings.db', timeout=10)
    cursor = conn.cursor()

    # Integrity check
    cursor.execute('PRAGMA integrity_check')
    result = cursor.fetchone()

    if result[0] == 'ok':
        print("✓ Database integrity verified")
    else:
        print(f"✗ Database integrity check failed: {result[0]}")
        errors.append("database_corruption")

    # Test Altitude Engine
    from altitude_engine import AltitudeEngine
    engine = AltitudeEngine('data/vector-embeddings.db', enable_fallback=True)
    engine.initialize()
    print("✓ Database connection successful")
    engine.close()

    conn.close()

except Exception as e:
    print(f"✗ Database test failed: {e}")
    errors.append("database_error")

if errors:
    print(f"\n✗ Verification failed with {len(errors)} error(s)")
    for err in errors:
        print(f"  - {err}")
    sys.exit(1)
else:
    print("\n✓ All verification checks passed")
    sys.exit(0)
EOF

    if [ $? -eq 0 ]; then
        log "✓ Installation verified successfully"
        return 0
    else
        error "Installation verification failed"
        return 1
    fi
}

print_usage_hint() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    SETUP COMPLETE!                              ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo ""
    echo "1. Test the Altitude Engine:"
    echo "   python3 -c 'import sys; sys.path.insert(0, \"data\"); from altitude_engine import AltitudeEngine; print(\"✓ Altitude Engine working\")'"
    echo ""
    echo "2. Use in your workflows:"
    echo "   from data.altitude_engine import AltitudeEngine"
    echo "   engine = AltitudeEngine('data/vector-embeddings.db')"
    echo "   engine.initialize()"
    echo ""
    echo "3. View documentation:"
    echo "   cat ALTITUDE_ENGINE.md"
    echo "   cat INSTALLATION.md"
    echo ""
    echo -e "${YELLOW}Note:${NC} The ML model (~80MB) will download on first use"
    echo "       Location: ~/.cache/huggingface/"
    echo ""
    echo "For troubleshooting, check the log file:"
    echo "   cat $LOG_FILE"
}

main() {
    print_header

    log "Starting Altitude Engine setup..."
    log "Log file: $LOG_FILE"
    log "Working directory: $SCRIPT_DIR"

    check_python_version
    check_disk_space
    check_network_connectivity  # FIX: Added network check
    install_dependencies
    create_directories
    check_database_lock         # FIX: Added lock check
    initialize_database

    if verify_installation; then
        print_usage_hint
        echo ""
        log "Setup completed successfully!"
        exit 0
    else
        error "Setup completed with errors"
        echo "Check $LOG_FILE for details"
        exit 1
    fi
}

# Run main function
main "$@"

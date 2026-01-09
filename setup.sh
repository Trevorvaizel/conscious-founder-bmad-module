#!/bin/bash
###############################################################################
# Conscious-Founder Module Installation Script (FIXED VERSION)
# One-command clean installation of all dependencies and features
###############################################################################

set -e

# Get script directory (FIX: No hardcoded paths)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     CONSCIOUS-FOUNDER MODULE INSTALLATION                    ║${NC}"
echo -e "${BLUE}║     AI-Human Co-Creative Newsletter Synthesis                ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# FIX: Pre-flight validation - check we're in right directory
if [ ! -f "config.yaml" ]; then
    echo -e "${RED}Error: config.yaml not found${NC}"
    echo ""
    echo "Please run this script from the conscious-founder module directory:"
    echo "  cd conscious-founder/_bmad/modules/conscious-founder"
    echo "  bash setup.sh"
    exit 1
fi

echo -e "${YELLOW}Pre-flight checks...${NC}"
echo ""

# FIX: Check if Altitude Engine setup script exists
if [ ! -f "setup-altitude-enhanced.sh" ]; then
    echo -e "${YELLOW}⚠ Altitude Engine setup script not found${NC}"
    echo ""
    echo "The module will work without Altitude Engine, but semantic search"
    echo "features will be unavailable."
    echo ""
    ALTITUDE_AVAILABLE=false
else
    echo -e "${GREEN}✓${NC} Altitude Engine setup script found"
    chmod +x setup-altitude-enhanced.sh
    ALTITUDE_AVAILABLE=true
fi

# FIX: Check critical files
CRITICAL_MISSING=0

if [ ! -d "agents" ]; then
    echo -e "${RED}✗${NC} Agents directory not found"
    CRITICAL_MISSING=1
fi

if [ ! -d "workflows" ]; then
    echo -e "${RED}✗${NC} Workflows directory not found"
    CRITICAL_MISSING=1
fi

if [ ! -d "knowledge" ]; then
    echo -e "${RED}✗${NC} Knowledge directory not found"
    CRITICAL_MISSING=1
fi

if [ $CRITICAL_MISSING -eq 1 ]; then
    echo ""
    echo -e "${RED}Error: Critical module components missing${NC}"
    echo "This appears to be a corrupted installation."
    exit 1
fi

echo -e "${GREEN}✓${NC} All critical module files present"
echo ""

# Main installation
echo -e "${YELLOW}Installing module components...${NC}"
echo ""

# 1. Altitude Engine Setup (if available)
if [ "$ALTITUDE_AVAILABLE" = true ]; then
    echo -e "${BLUE}[1/2]${NC} Setting up Altitude Engine (semantic search)..."

    # Run setup (non-blocking if it fails)
    if bash setup-altitude-enhanced.sh 2>&1 | tee altitude-setup.log; then
        echo -e "${GREEN}✓${NC} Altitude Engine installed successfully"
        ALTITUDE_SUCCESS=true
    else
        echo ""
        echo -e "${YELLOW}⚠ Altitude Engine setup had issues${NC}"
        echo -e "${YELLOW}  Module will work, but semantic search may be unavailable${NC}"
        echo -e "${YELLOW}  Check altitude-setup.log for details${NC}"
        echo ""
        ALTITUDE_SUCCESS=false
    fi
else
    echo -e "${YELLOW}[1/2]${NC} Skipping Altitude Engine (setup script not found)"
    ALTITUDE_SUCCESS=false
fi

echo ""

# 2. Module Configuration
echo -e "${BLUE}[2/2]${NC} Configuring module..."

# Create necessary directories
mkdir -p nodes/injected
mkdir -p nodes/transformed
mkdir -p nodes/published
mkdir -p nodes/deepening

echo -e "${GREEN}✓${NC} Module structure created"
echo ""

# Summary
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     INSTALLATION COMPLETE                                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Available Workflows:${NC}"
echo "  • /bmad:cis:workflows:inject  - Pre-Write Emphasis Capture"
echo "  • /bmad:cis:workflows:transform - 4-Agent Co-Creation Synthesis"
echo "  • /bmad:cis:workflows:repurpose - Social Post Extraction"
echo "  • /bmad:cis:workflows:return  - Node Re-Entry and Deepening"
echo ""
echo -e "${BLUE}Altitude Engine Status:${NC}"
if [ "$ALTITUDE_SUCCESS" = true ]; then
    echo -e "  ${GREEN}✓${NC} Vector database initialized"
    echo -e "  ${GREEN}✓${NC} Semantic search operational"
elif [ "$ALTITUDE_AVAILABLE" = true ]; then
    echo -e "  ${YELLOW}⚠${NC} Altitude Engine setup had issues"
    echo -e "  ${YELLOW}⚠${NC} Check altitude-setup.log for details"
    echo -e "  ${YELLOW}⚠${NC} Run again: bash setup-altitude-enhanced.sh"
else
    echo -e "  ${YELLOW}⚠${NC} Altitude Engine not available (setup script missing)"
fi
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Read documentation: cat USAGE_GUIDE.md"
echo "  2. Verify installation: bash verify-install.sh"
echo "  3. Start creating: /bmad:cis:workflows:inject"
echo ""

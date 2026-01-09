#!/bin/bash
###############################################################################
# Conscious-Founder Module Installation Script
# One-command clean installation of all dependencies and features
###############################################################################

set -e

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

# Check if we're in the right directory
if [ ! -f "config.yaml" ]; then
    echo -e "${RED}Error: config.yaml not found${NC}"
    echo "Please run this script from the conscious-founder module directory"
    exit 1
fi

echo -e "${YELLOW}Installing module components...${NC}"
echo ""

# 1. Altitude Engine Setup
if [ -f "setup-altitude-enhanced.sh" ]; then
    echo -e "${BLUE}[1/2]${NC} Setting up Altitude Engine (semantic search)..."

    # Make executable
    chmod +x setup-altitude-enhanced.sh

    # Run setup (non-blocking if it fails)
    if bash setup-altitude-enhanced.sh 2>&1 | tee altitude-setup.log; then
        echo -e "${GREEN}✓${NC} Altitude Engine installed successfully"
    else
        echo ""
        echo -e "${YELLOW}⚠ Altitude Engine setup had issues${NC}"
        echo -e "${YELLOW}  Module will work, but semantic search may be unavailable${NC}"
        echo -e "${YELLOW}  Check altitude-setup.log for details${NC}"
        echo ""
    fi
else
    echo -e "${YELLOW}⚠ Altitude Engine setup script not found${NC}"
    echo "Semantic search features may not work"
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
if [ -f "data/vector-embeddings.db" ]; then
    echo -e "  ${GREEN}✓${NC} Vector database initialized"
    echo -e "  ${GREEN}✓${NC} Semantic search operational"
else
    echo -e "  ${YELLOW}⚠${NC} Vector database not initialized"
    echo -e "  ${YELLOW}⚠${NC} Run: bash setup-altitude-enhanced.sh"
fi
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo "  1. Read documentation: cat USAGE_GUIDE.md"
echo "  2. Verify installation: bash verify-install.sh"
echo "  3. Start creating: /bmad:cis:workflows:inject"
echo ""

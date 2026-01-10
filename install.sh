#!/bin/bash

###############################################################################
# Master Module Installer - Path-Independent Installation
# Can be run from ANY directory - automatically installs to correct location
# Author: Rabbit (BMAD agent assistance)
# Version: 1.0.0
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
echo -e "${BLUE}║     CONSCIOUS-FOUNDER MODULE INSTALLER                      ║${NC}"
echo -e "${BLUE}║     Path-Independent Installation                            ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_NAME="conscious-founder"

echo -e "${YELLOW}Step 1: Finding project root...${NC}"
echo ""

# Find project root by looking for .claude directory
# Start from script directory and go up until we find .claude
SEARCH_DIR="$SCRIPT_DIR"
PROJECT_ROOT=""

while [ "$SEARCH_DIR" != "/" ]; do
    if [ -d "$SEARCH_DIR/.claude" ]; then
        PROJECT_ROOT="$SEARCH_DIR"
        break
    fi
    SEARCH_DIR="$(dirname "$SEARCH_DIR")"
done

if [ -z "$PROJECT_ROOT" ]; then
    echo -e "${RED}Error: Could not find project root${NC}"
    echo ""
    echo "Looking for .claude directory but couldn't find it."
    echo "Are you in a BMAD project?"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓${NC} Project root found: $PROJECT_ROOT"
echo ""

# Determine target installation path
TARGET_DIR="$PROJECT_ROOT/_bmad/modules/$MODULE_NAME"

echo -e "${YELLOW}Step 2: Determining installation path...${NC}"
echo ""
echo "Current location: $SCRIPT_DIR"
echo "Target location:  $TARGET_DIR"
echo ""

# Check if we're already in the right place
if [ "$SCRIPT_DIR" = "$TARGET_DIR" ]; then
    echo -e "${GREEN}✓${NC} Module is already in the correct location"
    echo ""
    echo -e "${YELLOW}Step 3: Running module setup...${NC}"
    echo ""

    # Just run setup.sh
    bash "$SCRIPT_DIR/setup.sh"
    exit $?
fi

# Check if target directory already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${YELLOW}⚠${NC} Target directory already exists: $TARGET_DIR"
    echo ""
    echo "This module appears to be installed already."
    echo ""
    read -p "Replace existing installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    fi

    echo ""
    echo -e "${YELLOW}Removing existing installation...${NC}"
    rm -rf "$TARGET_DIR"
    echo -e "${GREEN}✓${NC} Removed"
fi

echo -e "${YELLOW}Step 3: Installing module to correct location...${NC}"
echo ""

# Create target directory structure
mkdir -p "$(dirname "$TARGET_DIR")"

# Move module to target location
echo "Installing module files..."
echo -e "${BLUE}  → Copying files to: $TARGET_DIR${NC}"
cp -r "$SCRIPT_DIR" "$TARGET_DIR"
echo -e "${GREEN}✓${NC} Files copied successfully"

echo ""
echo -e "${YELLOW}Step 4: Running module setup...${NC}"
echo ""

# Change to target directory and run setup
cd "$TARGET_DIR"
bash setup.sh

SETUP_EXIT_CODE=$?

echo ""
if [ $SETUP_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     INSTALLATION SUCCESSFUL                                  ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Module Location:${NC} $TARGET_DIR"
    echo ""
    echo -e "${BLUE}Quick Start:${NC}"
    echo "  1. Read documentation: cat $TARGET_DIR/README.md"
    echo "  2. Start creating: /bmad:k2m-analyst"
    echo ""
else
    echo -e "${RED}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║     INSTALLATION INCOMPLETE                                   ║${NC}"
    echo -e "${RED}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}The module files were copied to:${NC} $TARGET_DIR"
    echo -e "${YELLOW}But setup.sh exited with code:${NC} $SETUP_EXIT_CODE"
    echo ""
    echo -e "${YELLOW}You can try running setup manually:${NC}"
    echo "  cd $TARGET_DIR"
    echo "  bash setup.sh"
    echo ""
fi

exit $SETUP_EXIT_CODE

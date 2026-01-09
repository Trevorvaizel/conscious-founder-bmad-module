#!/bin/bash

###############################################################################
# Dual-Repo Commit Script
# Commits changes to both main project repo AND module repo
# Author: Rabbit
# Version: 1.0.0
###############################################################################

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_ROOT="$SCRIPT_DIR"
MAIN_PROJECT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Dual-Repo Commit Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

###############################################################################
# CHECK IF MESSAGES PROVIDED
###############################################################################

if [ -z "$1" ]; then
    echo -e "${RED}Error: Commit message required${NC}"
    echo ""
    echo "Usage: ./publish.sh \"your commit message\""
    echo ""
    echo "Example:"
    echo "  ./publish.sh \"feat: improved analyst agent pattern detection\""
    echo ""
    exit 1
fi

COMMIT_MSG="$1"

###############################################################################
# SHOW WHAT WILL BE COMMITTED
###############################################################################

echo -e "${YELLOW}Checking for changes...${NC}"
echo ""

# Check main project
echo -e "${BLUE}Main Project Changes:${NC}"
cd "$MAIN_PROJECT"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${GREEN}✓ Changes detected in main project${NC}"
    git status --short
    MAIN_HAS_CHANGES=true
else
    echo -e "${YELLOW}⚠ No changes in main project${NC}"
    MAIN_HAS_CHANGES=false
fi
echo ""

# Check module
echo -e "${BLUE}Module Changes:${NC}"
cd "$MODULE_ROOT"
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${GREEN}✓ Changes detected in module${NC}"
    git status --short
    MODULE_HAS_CHANGES=true
else
    echo -e "${YELLOW}⚠ No changes in module${NC}"
    MODULE_HAS_CHANGES=false
fi
echo ""

###############################################################################
# CONFIRM
###############################################################################

if [ "$MAIN_HAS_CHANGES" = false ] && [ "$MODULE_HAS_CHANGES" = false ]; then
    echo -e "${YELLOW}No changes to commit in either repo${NC}"
    exit 0
fi

echo -e "${BLUE}Commit message:${NC} \"$COMMIT_MSG\""
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cancelled${NC}"
    exit 0
fi
echo ""

###############################################################################
# COMMIT TO MAIN PROJECT
###############################################################################

if [ "$MAIN_HAS_CHANGES" = true ]; then
    echo -e "${BLUE}=== Committing to Main Project ===${NC}"
    cd "$MAIN_PROJECT"

    echo -e "${YELLOW}Adding files...${NC}"
    git add .

    echo -e "${YELLOW}Committing...${NC}"
    git commit -m "$COMMIT_MSG"

    echo -e "${YELLOW}Pushing...${NC}"
    git push origin main

    echo -e "${GREEN}✓ Main project updated${NC}"
    echo ""
else
    echo -e "${YELLOW}⊘ Skipping main project (no changes)${NC}"
    echo ""
fi

###############################################################################
# COMMIT TO MODULE
###############################################################################

if [ "$MODULE_HAS_CHANGES" = true ]; then
    echo -e "${BLUE}=== Committing to Module ===${NC}"
    cd "$MODULE_ROOT"

    echo -e "${YELLOW}Adding files...${NC}"
    git add .

    echo -e "${YELLOW}Committing...${NC}"
    git commit -m "$COMMIT_MSG"

    echo -e "${YELLOW}Pushing...${NC}"
    git push origin main

    echo -e "${GREEN}✓ Module updated${NC}"
    echo ""
else
    echo -e "${YELLOW}⊘ Skipping module (no changes)${NC}"
    echo ""
fi

###############################################################################
# SUMMARY
###############################################################################

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

if [ "$MAIN_HAS_CHANGES" = true ]; then
    echo -e "${GREEN}✓ Main project:${NC} https://github.com/Trevorvaizel/conscious-founder"
fi

if [ "$MODULE_HAS_CHANGES" = true ]; then
    echo -e "${GREEN}✓ Module:${NC} https://github.com/Trevorvaizel/conscious-founder-bmad-module"
fi

echo ""
echo -e "${GREEN}✓ All changes committed and pushed!${NC}"
echo ""

#!/bin/bash

###############################################################################
# Smart Submodule Commit Script
# Intelligently handles commits for main repo + submodule setup
# Author: Rabbit (with BMAD agent assistance)
# Version: 2.1.0 - Fixed error handling
###############################################################################

# DO NOT exit on error - we handle failures gracefully
# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Auto-detect project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
MODULE_PATH="${MODULE_PATH:-.}"  # Running from within submodule

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Smart Submodule Commit${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

###############################################################################
# CHECK IF MESSAGE PROVIDED
###############################################################################

if [ -z "$1" ]; then
    echo -e "${RED}Error: Commit message required${NC}"
    echo ""
    echo "Usage: ./smart-commit.sh \"your commit message\""
    echo ""
    echo "Example:"
    echo "  ./smart-commit.sh \"feat: improved analyst agent\""
    echo ""
    exit 1
fi

COMMIT_MSG="$1"

###############################################################################
# VERIFY WE'RE IN THE RIGHT PLACE
###############################################################################

if [ ! -d "$PROJECT_ROOT/agents" ] || [ ! -d "$PROJECT_ROOT/workflows" ]; then
    echo -e "${RED}Error: Not in a BMAD module${NC}"
    echo "Please run from module root (where agents/ and workflows/ folders exist)"
    exit 1
fi

echo -e "${GREEN}✓ Module: $PROJECT_ROOT${NC}"
echo ""

###############################################################################
# CHECK FOR CHANGES
###############################################################################

echo -e "${YELLOW}Scanning for changes...${NC}"
echo ""

# Check module
echo -e "${BLUE}Module:${NC}"
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    MODULE_CHANGES=$(git status --short)
    echo -e "${GREEN}✓ Changes detected${NC}"
    echo "$MODULE_CHANGES"
    MODULE_HAS_CHANGES=true
else
    echo -e "${YELLOW}⚠ No changes${NC}"
    MODULE_HAS_CHANGES=false
fi
echo ""

###############################################################################
# CONFIRMATION
###############################################################################

if [ "$MODULE_HAS_CHANGES" = false ]; then
    echo -e "${YELLOW}No changes to commit${NC}"
    exit 0
fi

echo -e "${BLUE}Summary:${NC}"
echo -e "  ${GREEN}☑ Module has changes${NC}"
echo ""
echo -e "${BLUE}Message:${NC} \"$COMMIT_MSG\""
echo ""
read -p "Commit these changes? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Cancelled${NC}"
    exit 0
fi
echo ""

###############################################################################
# COMMIT MODULE CHANGES
###############################################################################

echo -e "${YELLOW}[1/1] Committing module changes...${NC}"

echo -e "${BLUE}  → Adding files...${NC}"
git add .

echo -e "${BLUE}  → Committing...${NC}"
git commit -m "$COMMIT_MSG"

echo -e "${GREEN}✓ Module committed${NC}"
echo ""

# Try to push, but don't fail if authentication issues
echo -e "${BLUE}  → Pushing to GitHub...${NC}"
if git push origin main 2>&1; then
    echo -e "${GREEN}✓ Module pushed to GitHub${NC}"
    echo -e "   Repo: https://github.com/Trevorvaizel/conscious-founder-bmad-module${NC}"
else
    echo -e "${YELLOW}⚠ Push failed${NC}"
    echo -e "${YELLOW}  Module committed locally but not pushed${NC}"
    echo -e "${YELLOW}  You'll need to push manually:${NC}"
    echo -e "${YELLOW}    git push${NC}"
fi
echo ""

###############################################################################
# DONE
############################################################################///

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Changes committed!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

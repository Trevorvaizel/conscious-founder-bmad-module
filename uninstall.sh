#!/bin/bash

###############################################################################
# Conscious-Founder Module Uninstallation Script
# Author: Rabbit
# Version: 1.0.0
# Date: 2026-01-09
#
# This script cleanly removes the Conscious-Founder BMAD module
###############################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Module paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
MODULE_NAME="conscious-founder"
MODULE_ROOT="$PROJECT_ROOT/_bmad/modules/$MODULE_NAME"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Conscious-Founder Module Uninstallation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Confirm uninstallation
echo -e "${YELLOW}This will remove the Conscious-Founder module from your system.${NC}"
echo -e "${YELLOW}Your data in _bmad-output/$MODULE_NAME will be preserved.${NC}"
echo ""
read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstallation cancelled${NC}"
    exit 0
fi

# Step 1: Remove agent configs
echo -e "${YELLOW}[1/5] Removing agent configurations...${NC}"
AGENT_CONFIG_DIR="$PROJECT_ROOT/_bmad/_config/agents"
REMOVED_AGENTS=0

for agent in analyst architect copywriter editor; do
    AGENT_CONFIG="$AGENT_CONFIG_DIR/k2m-${agent}.customize.yaml"
    if [ -f "$AGENT_CONFIG" ]; then
        rm "$AGENT_CONFIG"
        echo -e "${GREEN}✓ Removed: k2m-${agent}${NC}"
        REMOVED_AGENTS=$((REMOVED_AGENTS + 1))
    fi
done

if [ $REMOVED_AGENTS -eq 0 ]; then
    echo -e "${YELLOW}⚠ No agent configs found to remove${NC}"
fi
echo ""

# Step 2: Remove knowledge symlink
echo -e "${YELLOW}[2/6] Removing knowledge base symlink...${NC}"
KNOWLEDGE_DST="$MODULE_ROOT/knowledge"

if [ -L "$KNOWLEDGE_DST" ]; then
    rm "$KNOWLEDGE_DST"
    echo -e "${GREEN}✓ Knowledge base symlink removed${NC}"
else
    echo -e "${YELLOW}⚠ No knowledge base symlink found${NC}"
fi
echo ""

# Step 3: Remove slash commands
echo -e "${YELLOW}[3/6] Removing slash commands...${NC}"
COMMANDS_DIR="$PROJECT_ROOT/.claude/commands/bmad/$MODULE_NAME"

if [ -d "$COMMANDS_DIR" ]; then
    rm -rf "$COMMANDS_DIR"
    echo -e "${GREEN}✓ Slash commands removed${NC}"
    echo -e "  ${GREEN}✓${NC} Removed 4 agent commands"
    echo -e "  ${GREEN}✓${NC} Removed 4 workflow commands"
else
    echo -e "${YELLOW}⚠ No slash commands found${NC}"
fi
echo ""

# Step 4: Ask about data preservation
echo -e "${YELLOW}[4/6] Checking output data...${NC}"
OUTPUT_BASE="$PROJECT_ROOT/_bmad-output/$MODULE_NAME"

if [ -d "$OUTPUT_BASE" ]; then
    echo -e "${YELLOW}⚠ Output data found at: $OUTPUT_BASE${NC}"
    read -p "Remove output data? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$OUTPUT_BASE"
        echo -e "${GREEN}✓ Output data removed${NC}"
    else
        echo -e "${YELLOW}⚠ Output data preserved${NC}"
    fi
else
    echo -e "${YELLOW}⚠ No output data found${NC}"
fi
echo ""

# Step 5: Remove module directory
echo -e "${YELLOW}[5/6] Removing module directory...${NC}"
if [ -d "$MODULE_ROOT" ]; then
    # Remove everything except the uninstall script itself
    find "$MODULE_ROOT" -mindepth 1 ! -name "uninstall.sh" -delete
    echo -e "${GREEN}✓ Module directory cleaned${NC}"
else
    echo -e "${YELLOW}⚠ Module directory not found${NC}"
fi
echo ""

# Step 6: Final cleanup
echo -e "${YELLOW}[6/6] Final cleanup...${NC}"
# Remove uninstall script itself
rm "$SCRIPT_DIR/uninstall.sh"
echo -e "${GREEN}✓ Uninstallation complete${NC}"
echo ""

echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}✓ Conscious-Founder module successfully uninstalled${NC}"
echo ""
echo -e "${YELLOW}Note: BMAD configuration may need to be reloaded${NC}"
echo -e "${BLUE}========================================${NC}"

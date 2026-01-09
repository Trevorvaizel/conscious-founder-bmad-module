#!/bin/bash

###############################################################################
# Conscious-Founder Module Installation Script
# Author: Rabbit
# Version: 1.0.0
# Date: 2026-01-09
#
# This script installs the Conscious-Founder BMAD module
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
echo -e "${BLUE}Conscious-Founder Module Installation${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Verify BMAD installation
echo -e "${YELLOW}[1/6] Verifying BMAD installation...${NC}"
if [ ! -d "$PROJECT_ROOT/_bmad" ]; then
    echo -e "${RED}✗ BMAD directory not found at $PROJECT_ROOT/_bmad${NC}"
    echo -e "${RED}✗ Please ensure BMAD is properly installed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ BMAD installation found${NC}"
echo ""

# Step 2: Check BMAD version compatibility
echo -e "${YELLOW}[2/6] Checking BMAD version compatibility...${NC}"
BMAD_CONFIG="$PROJECT_ROOT/_bmad/bmb/config.yaml"
if [ -f "$BMAD_CONFIG" ]; then
    BMAD_VERSION=$(grep "Version:" "$BMAD_CONFIG" | head -1 | awk '{print $3}')
    echo -e "${GREEN}✓ BMAD version: $BMAD_VERSION${NC}"
else
    echo -e "${YELLOW}⚠ Unable to detect BMAD version${NC}"
fi
echo ""

# Step 3: Create output directories
echo -e "${YELLOW}[3/6] Creating output directories...${NC}"
OUTPUT_BASE="$PROJECT_ROOT/_bmad-output/$MODULE_NAME"
mkdir -p "$OUTPUT_BASE/analysis"
mkdir -p "$OUTPUT_BASE/structure"
mkdir -p "$OUTPUT_BASE/drafts"
mkdir -p "$OUTPUT_BASE/published"
mkdir -p "$OUTPUT_BASE/emphasis"
mkdir -p "$OUTPUT_BASE/nodes"
echo -e "${GREEN}✓ Output directories created at $OUTPUT_BASE${NC}"
echo ""

# Step 4: Register agent configs
echo -e "${YELLOW}[4/6] Registering agent configurations...${NC}"
AGENT_CONFIG_DIR="$PROJECT_ROOT/_bmad/_config/agents"
mkdir -p "$AGENT_CONFIG_DIR"

for agent in analyst architect copywriter editor; do
    AGENT_CONFIG="$AGENT_CONFIG_DIR/k2m-${agent}.customize.yaml"
    if [ ! -f "$AGENT_CONFIG" ]; then
        echo -e "${YELLOW}⚠ Agent config not found: $AGENT_CONFIG${NC}"
        echo -e "${YELLOW}  (This may already exist from previous installation)${NC}"
    else
        echo -e "${GREEN}✓ Agent config registered: k2m-${agent}${NC}"
    fi
done
echo ""

# Step 5: Verify knowledge base (now included in module)
echo -e "${YELLOW}[5/6] Verifying knowledge base...${NC}"
KNOWLEDGE_DST="$MODULE_ROOT/knowledge"

if [ -d "$KNOWLEDGE_DST" ]; then
    KNOWLEDGE_COUNT=$(ls -1 "$KNOWLEDGE_DST"/*.md 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ Knowledge base included ($KNOWLEDGE_COUNT files)${NC}"
else
    echo -e "${RED}✗ Knowledge base not found${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Step 6: Verification
echo -e "${YELLOW}[6/6] Verifying installation...${NC}"
ERRORS=0

# Check agents
if [ ! -d "$MODULE_ROOT/agents" ]; then
    echo -e "${RED}✗ Agents directory not found${NC}"
    ERRORS=$((ERRORS + 1))
else
    AGENT_COUNT=$(ls -1 "$MODULE_ROOT/agents"/*.md 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ Found $AGENT_COUNT agent files${NC}"
fi

# Check workflows
if [ ! -d "$MODULE_ROOT/workflows" ]; then
    echo -e "${RED}✗ Workflows directory not found${NC}"
    ERRORS=$((ERRORS + 1))
else
    WORKFLOW_COUNT=$(ls -1 "$MODULE_ROOT/workflows"/*.yaml 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ Found $WORKFLOW_COUNT workflow files${NC}"
fi

# Check knowledge
if [ ! -d "$KNOWLEDGE_SRC" ]; then
    echo -e "${RED}✗ Knowledge base not found at $KNOWLEDGE_SRC${NC}"
    ERRORS=$((ERRORS + 1))
else
    KNOWLEDGE_COUNT=$(ls -1 "$KNOWLEDGE_SRC"/*.md 2>/dev/null | wc -l)
    echo -e "${GREEN}✓ Found $KNOWLEDGE_COUNT knowledge files${NC}"
fi

# Check config files
if [ ! -f "$MODULE_ROOT/config.yaml" ]; then
    echo -e "${RED}✗ Module config.yaml not found${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✓ Module config.yaml found${NC}"
fi

if [ ! -f "$MODULE_ROOT/manifest.yaml" ]; then
    echo -e "${RED}✗ Module manifest.yaml not found${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✓ Module manifest.yaml found${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✓ Installation completed successfully!${NC}"
    echo ""
    echo -e "${BLUE}Next Steps:${NC}"
    echo -e "1. Run verify-install.sh to test agent invocation"
    echo -e "2. Use agents via: /bmad:k2m-analyst, /bmad:k2m-architect, etc."
    echo -e "3. Check workflows: /bmad:conscious-founder:inject, etc."
    echo ""
    echo -e "${GREEN}Module installed at: $MODULE_ROOT${NC}"
else
    echo -e "${RED}✗ Installation completed with $ERRORS error(s)${NC}"
    echo -e "${YELLOW}Please review the errors above and fix manually${NC}"
    exit 1
fi

echo -e "${BLUE}========================================${NC}"

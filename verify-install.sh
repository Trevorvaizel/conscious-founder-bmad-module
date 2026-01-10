#!/bin/bash

###############################################################################
# Conscious-Founder Module Verification Script
# Author: Rabbit
# Version: 1.0.0
# Date: 2026-01-09
#
# This script verifies the Conscious-Founder module installation
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
echo -e "${BLUE}Conscious-Founder Module Verification${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Test function
run_test() {
    local test_name="$1"
    local test_command="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo -e "${YELLOW}Testing: $test_name${NC}"

    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

echo -e "${BLUE}=== Module Structure Tests ===${NC}"
echo ""

run_test "Module directory exists" "[ -d '$MODULE_ROOT' ]"
run_test "Agents directory exists" "[ -d '$MODULE_ROOT/agents' ]"
run_test "Workflows directory exists" "[ -d '$MODULE_ROOT/workflows' ]"
run_test "Knowledge directory exists" "[ -d '$MODULE_ROOT/knowledge' ]"

echo ""
echo -e "${BLUE}=== Configuration File Tests ===${NC}"
echo ""

run_test "config.yaml exists" "[ -f '$MODULE_ROOT/config.yaml' ]"
run_test "manifest.yaml exists" "[ -f '$MODULE_ROOT/manifest.yaml' ]"
run_test "setup.sh is executable" "[ -x '$MODULE_ROOT/setup.sh' ]"
run_test "uninstall.sh is executable" "[ -x '$MODULE_ROOT/uninstall.sh' ]"

echo ""
echo -e "${BLUE}=== Agent File Tests ===${NC}"
echo ""

run_test "Analyst agent exists" "[ -f '$MODULE_ROOT/agents/analyst.md' ]"
run_test "Architect agent exists" "[ -f '$MODULE_ROOT/agents/architect.md' ]"
run_test "Copywriter agent exists" "[ -f '$MODULE_ROOT/agents/copywriter.md' ]"
run_test "Editor agent exists" "[ -f '$MODULE_ROOT/agents/editor.md' ]"

echo ""
echo -e "${BLUE}=== Agent Config Tests ===${NC}"
echo ""

run_test "Analyst config registered" "[ -f '$PROJECT_ROOT/_bmad/_config/agents/k2m-analyst.customize.yaml' ]"
run_test "Architect config registered" "[ -f '$PROJECT_ROOT/_bmad/_config/agents/k2m-architect.customize.yaml' ]"
run_test "Copywriter config registered" "[ -f '$PROJECT_ROOT/_bmad/_config/agents/k2m-copywriter.customize.yaml' ]"
run_test "Editor config registered" "[ -f '$PROJECT_ROOT/_bmad/_config/agents/k2m-editor.customize.yaml' ]"

echo ""
echo -e "${BLUE}=== Knowledge Base Tests ===${NC}"
echo ""

run_test "ACM framework exists" "[ -f '$MODULE_ROOT/knowledge/acm-framework.md' ]"
run_test "Module execution exists" "[ -f '$MODULE_ROOT/knowledge/module-execution.md' ]"
run_test "Juggling patterns exists" "[ -f '$MODULE_ROOT/knowledge/juggling-patterns.md' ]"
run_test "Voice constants exists" "[ -f '$MODULE_ROOT/knowledge/voice-constants.md' ]"
run_test "Quality gates exists" "[ -f '$MODULE_ROOT/knowledge/quality-gates.md' ]"
run_test "Pattern selection exists" "[ -f '$MODULE_ROOT/knowledge/pattern-selection.md' ]"
run_test "Checkpoint philosophy exists" "[ -f '$MODULE_ROOT/knowledge/checkpoint-philosophy.md' ]"
run_test "CTA placement exists" "[ -f '$MODULE_ROOT/knowledge/cta-placement.md' ]"

echo ""
echo -e "${BLUE}=== Output Directory Tests ===${NC}"
echo ""

OUTPUT_BASE="$PROJECT_ROOT/_bmad-output/$MODULE_NAME"
run_test "Output base directory exists" "[ -d '$OUTPUT_BASE' ]"
run_test "Analysis directory exists" "[ -d '$OUTPUT_BASE/analysis' ]"
run_test "Structure directory exists" "[ -d '$OUTPUT_BASE/structure' ]"
run_test "Drafts directory exists" "[ -d '$OUTPUT_BASE/drafts' ]"
run_test "Published directory exists" "[ -d '$OUTPUT_BASE/published' ]"
run_test "Emphasis directory exists" "[ -d '$OUTPUT_BASE/emphasis' ]"
run_test "Nodes directory exists" "[ -d '$OUTPUT_BASE/nodes' ]"

echo ""
echo -e "${BLUE}=== Workflow File Tests ===${NC}"
echo ""

run_test "Inject workflow exists" "[ -f '$MODULE_ROOT/workflows/inject.yaml' ]"
run_test "Transform workflow exists" "[ -f '$MODULE_ROOT/workflows/transform.yaml' ]"
run_test "Return workflow exists" "[ -f '$MODULE_ROOT/workflows/return.yaml' ]"
run_test "Repurpose workflow exists" "[ -f '$MODULE_ROOT/workflows/repurpose.yaml' ]"

echo ""
echo -e "${BLUE}=== Altitude Engine Tests ===${NC}"
echo ""

# Change to module directory for Altitude Engine tests
cd "$SCRIPT_DIR"

run_test "Altitude Engine module exists" "[ -f 'data/altitude_engine.py' ]"

# Test Python imports
echo -e "${YELLOW}Testing Python dependencies...${NC}"
TOTAL_TESTS=$((TOTAL_TESTS + 1))

if python3 -c "import sys; sys.path.insert(0, 'data'); import sentence_transformers" 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}: sentence-transformers installed"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}✗ FAIL${NC}: sentence-transformers not installed"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi

TOTAL_TESTS=$((TOTAL_TESTS + 1))
if python3 -c "import numpy" 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}: numpy installed"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}✗ FAIL${NC}: numpy not installed"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi

TOTAL_TESTS=$((TOTAL_TESTS + 1))
if python3 -c "import sys; sys.path.insert(0, 'data'); from altitude_engine import AltitudeEngine" 2>/dev/null; then
    echo -e "${GREEN}✓ PASS${NC}: Altitude Engine module imports"
    PASSED_TESTS=$((PASSED_TESTS + 1))
else
    echo -e "${RED}✗ FAIL${NC}: Altitude Engine import failed"
    FAILED_TESTS=$((FAILED_TESTS + 1))
fi

# Test database if it exists
if [ -f "data/vector-embeddings.db" ]; then
    echo ""
    echo -e "${YELLOW}Testing vector database...${NC}"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if python3 << 'EOF' 2>/dev/null
import sys
import sqlite3
sys.path.insert(0, 'data')

try:
    # Database integrity
    conn = sqlite3.connect('data/vector-embeddings.db', timeout=10)
    cursor = conn.cursor()
    cursor.execute('PRAGMA integrity_check')
    result = cursor.fetchone()

    if result[0] == 'ok':
        print("✓ PASS: Database integrity verified")
        sys.exit(0)
    else:
        print(f"✗ FAIL: Database corrupted: {result[0]}")
        sys.exit(1)
except Exception as e:
    print(f"✗ FAIL: Database check failed: {e}")
    sys.exit(1)
finally:
    if 'conn' in locals():
        conn.close()
EOF
    then
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
else
    echo -e "${YELLOW}⚠ INFO: Vector database not yet created (normal before first installation)${NC}"
fi

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Test Results Summary${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Total Tests: $TOTAL_TESTS"
echo -e "${GREEN}Passed: $PASSED_TESTS${NC}"
echo -e "${RED}Failed: $FAILED_TESTS${NC}"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed! Module is ready to use.${NC}"
    echo ""
    echo -e "${BLUE}Quick Test Commands:${NC}"
    echo -e "  Test agent invocation: /bmad:k2m-analyst"
    echo -e "  Test analyst workflow: cat <transcript> | /bmad:k2m-analyst AN"
    echo ""
    exit 0
else
    echo -e "${RED}✗ Some tests failed. Please review the failures above.${NC}"
    echo ""
    echo -e "${YELLOW}Common fixes:${NC}"
    echo -e "  1. Re-run setup.sh: cd $MODULE_ROOT && ./setup.sh"
    echo -e "  2. Check file permissions: chmod +x $MODULE_ROOT/*.sh"
    echo -e "  3. Verify knowledge base: ls -la $MODULE_ROOT/knowledge/"
    echo ""
    exit 1
fi

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
echo -e "${BLUE}[2/3]${NC} Configuring module..."

# Create necessary directories
mkdir -p nodes/injected
mkdir -p nodes/transformed
mkdir -p nodes/published
mkdir -p nodes/deepening

echo -e "${GREEN}✓${NC} Module structure created"
echo ""

# 3. Register Slash Commands with BMAD
echo -e "${BLUE}[3/3]${NC} Registering slash commands..."

# Find project root by searching upward for .claude directory
# This works regardless of where the module is installed
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
    echo -e "${YELLOW}⚠ Could not find .claude directory${NC}"
    echo "Slash commands will not be registered."
    echo "You can manually run setup.sh from a BMAD project to register commands."
else
    COMMANDS_DIR="$PROJECT_ROOT/.claude/commands/bmad/conscious-founder"

# Create command directory structure
mkdir -p "$COMMANDS_DIR/agents"
mkdir -p "$COMMANDS_DIR/workflows"

# Create agent command files
cat > "$COMMANDS_DIR/agents/k2m-analyst.md" << 'EOF'
---
name: 'k2m-analyst'
description: 'K2M Content Analyst - Extract insights from transcripts'
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @_bmad/modules/conscious-founder/agents/analyst.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>
EOF

cat > "$COMMANDS_DIR/agents/k2m-architect.md" << 'EOF'
---
name: 'k2m-architect'
description: 'K2M Content Architect - Structure content using ACM framework'
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @_bmad/modules/conscious-founder/agents/architect.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>
EOF

cat > "$COMMANDS_DIR/agents/k2m-copywriter.md" << 'EOF'
---
name: 'k2m-copywriter'
description: 'K2M Copywriter - Generate content with calibrated voice'
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @_bmad/modules/conscious-founder/agents/copywriter.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>
EOF

cat > "$COMMANDS_DIR/agents/k2m-editor.md" << 'EOF'
---
name: 'k2m-editor'
description: 'K2M Editor - Review content against quality gates'
---

You must fully embody this agent's persona and follow all activation instructions exactly as specified. NEVER break character until given an exit command.

<agent-activation CRITICAL="TRUE">
1. LOAD the FULL agent file from @_bmad/modules/conscious-founder/agents/editor.md
2. READ its entire contents - this contains the complete agent persona, menu, and instructions
3. Execute ALL activation steps exactly as written in the agent file
4. Follow the agent's persona and menu system precisely
5. Stay in character throughout the session
</agent-activation>
EOF

# Create workflow command files
cat > "$COMMANDS_DIR/workflows/inject.md" << 'EOF'
---
name: 'conscious-founder:inject'
description: 'Capture creative emphasis/angle before boiling phase completes'
---

Execute the Inject workflow from the Conscious-Founder module.

This workflow captures your creative emphasis and angle before the boiling phase completes, ensuring you don't lose 80% of the nuance.

<workflow-activation>
1. LOAD the workflow file from @_bmad/modules/conscious-founder/workflows/inject.yaml
2. READ and execute all workflow steps
3. Follow the workflow prompts and save output to designated location
</workflow-activation>
EOF

cat > "$COMMANDS_DIR/workflows/transform.md" << 'EOF'
---
name: 'conscious-founder:transform'
description: 'Execute full K2M pipeline with 4 human-judgment checkpoints'
---

Execute the Transform workflow from the Conscious-Founder module.

This workflow runs the complete K2M newsletter pipeline through all 4 agents (Analyst → Architect → Copywriter → Editor) with human judgment checkpoints at critical decision points.

<workflow-activation>
1. LOAD the workflow file from @_bmad/modules/conscious-founder/workflows/transform.yaml
2. READ and execute all workflow steps
3. Follow the workflow prompts and sequence through all 4 agents
4. Ensure checkpoints pause for user input at each critical decision point
</workflow-activation>
EOF

cat > "$COMMANDS_DIR/workflows/return.md" << 'EOF'
---
name: 'conscious-founder:return'
description: 'Re-enter published nodes with full context for deepening insights'
---

Execute the Return workflow from the Conscious-Founder module.

This workflow enables you to re-enter previously published newsletters with full context, allowing you to deepen insights and cross-pollinate ideas across your body of work.

<workflow-activation>
1. LOAD the workflow file from @_bmad/modules/conscious-founder/workflows/return.yaml
2. READ and execute all workflow steps
3. Display full node context including ACM modules, frameworks, and themes
4. Enable deepening and cross-pollination of insights
</workflow-activation>
EOF

cat > "$COMMANDS_DIR/workflows/repurpose.md" << 'EOF'
---
name: 'conscious-founder:repurpose'
description: 'Generate Type A/B/C social posts using ACM framework'
---

Execute the Repurpose workflow from the Conscious-Founder module.

This workflow extracts Type A, B, and C social posts from published newsletters using the ACM framework, generating 3-5 ready-to-post social media updates in under 5 minutes.

<workflow-activation>
1. LOAD the workflow file from @_bmad/modules/conscious-founder/workflows/repurpose.yaml
2. READ and execute all workflow steps
3. Apply ACM framework to generate social posts
4. Output posts in ready-to-post format
</workflow-activation>
EOF

echo -e "${GREEN}✓${NC} Slash commands registered: 8 commands created"
echo -e "  ${GREEN}✓${NC} 4 agent commands: /bmad:k2m-analyst, /bmad:k2m-architect, /bmad:k2m-copywriter, /bmad:k2m-editor"
echo -e "  ${GREEN}✓${NC} 4 workflow commands: /bmad:conscious-founder:inject, transform, return, repurpose"
fi  # End of PROJECT_ROOT check
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}                        SUMMARY                                  ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Available Agents:${NC}"
echo "  • /bmad:k2m-analyst    - K2M Content Analyst"
echo "  • /bmad:k2m-architect  - K2M Content Architect"
echo "  • /bmad:k2m-copywriter - K2M Copywriter"
echo "  • /bmad:k2m-editor     - K2M Editor"
echo ""
echo -e "${BLUE}Available Workflows:${NC}"
echo "  • /bmad:conscious-founder:inject    - Pre-Write Emphasis Capture"
echo "  • /bmad:conscious-founder:transform - 4-Agent Co-Creation Synthesis"
echo "  • /bmad:conscious-founder:repurpose - Social Post Extraction"
echo "  • /bmad:conscious-founder:return    - Node Re-Entry and Deepening"
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
echo "  1. Read documentation: cat README.md"
echo "  2. Start creating: /bmad:k2m-analyst"
echo ""

# 4. Automatic Installation Verification
echo ""
echo -e "${BLUE}[4/4]${NC} Running installation verification..."
echo ""

if bash verify-install.sh; then
    VERIFICATION_STATUS=0
    echo ""
    echo -e "${GREEN}✓${NC} Module verification completed successfully"
else
    VERIFICATION_STATUS=$?
    echo ""
    echo -e "${YELLOW}⚠${NC} Verification completed with warnings"
    echo -e "${YELLOW}⚠${NC} Your module should still work, but some components may need attention"
    echo ""
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     INSTALLATION COMPLETE                                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"

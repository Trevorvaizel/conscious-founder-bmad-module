# Reusable Patterns from Conscious-Founder Module

**Purpose:** Document architectural and workflow patterns that other creators can adapt for their own agent systems.

---

## Pattern 1: Knowledge Base as Single-Source-of-Truth

### Problem

When frameworks and shared knowledge are duplicated across multiple agents:
- Updates must be made in multiple places
- Agents diverge over time
- Inconsistencies creep in
- Maintenance becomes error-prone

### Solution

Store shared frameworks once in a `/knowledge/` directory. Have agents reference these files at runtime using `{knowledge}/file.md` syntax.

### Implementation

**Directory Structure:**
```
your-module/
├── agents/
│   ├── agent1.md
│   ├── agent2.md
│   └── agent3.md
└── knowledge/
    ├── shared-framework.md
    ├── quality-standards.md
    └── voice-guidelines.md
```

**Knowledge File (`knowledge/shared-framework.md`):**
```markdown
# Shared Framework

## Module 1: First Concept
Description...

## Module 2: Second Concept
Description...

## Module 3: Third Concept
Description...
```

**Agent Reference (`agents/agent1.md`):**
```markdown
## Required Knowledge

Before executing tasks, ensure access to:
- **{knowledge}/shared-framework.md** - Complete framework reference
- **{knowledge}/quality-standards.md** - Quality criteria

## Your Task

When analyzing content, apply the shared framework:
- Use Module 1 for [purpose]
- Use Module 2 for [purpose]
- Use Module 3 for [purpose]
```

**Agent 2 Reference (`agents/agent2.md`):**
```markdown
## Required Knowledge

Before executing tasks, ensure access to:
- **{knowledge}/shared-framework.md** - Complete framework reference
- **{knowledge}/voice-guidelines.md** - Tone and style

## Your Task

When structuring content, apply the shared framework:
- Select appropriate module based on [criteria]
- Ensure all modules execute in sequence
- Verify framework compliance
```

### Benefits

✅ **Update Once, Propagate Everywhere** - Change framework in one file, all agents see updates
✅ **Consistency Guaranteed** - All agents use identical framework definitions
✅ **Maintenance Simplified** - No need to update multiple agent files
✅ **Version Control Friendly** - Framework changes tracked in one file

### Real Example: Conscious-Founder

**ACM Framework in One Place:**
- `knowledge/acm-framework.md` (250+ lines of complete framework)

**Referenced by 4 Agents:**
- Analyst: `{knowledge}/acm-framework.md` - For preliminary module mapping
- Architect: `{knowledge}/acm-framework.md` - For structure design
- Copywriter: `{knowledge}/acm-framework.md` - For execution tactics
- Editor: `{knowledge}/acm-framework.md` - For quality verification

**Update Example:**
When you discover a better way to execute Module 3 (Pressure):
1. Update `knowledge/module-execution.md` once
2. All 4 agents automatically use improved approach on next run
3. No agent files need modification

### Adapting This Pattern

**For Your Module:**

1. **Identify Shared Knowledge**
   - What frameworks do multiple agents use?
   - What quality standards apply across agents?
   - What voice/tone guidelines are shared?

2. **Extract to Knowledge Files**
   - Create `/knowledge/` directory
   - Create one file per shared framework
   - Document completely and clearly

3. **Update Agents to Reference**
   - Add `## Required Knowledge` section to each agent
   - Use `{knowledge}/file.md` syntax
   - Reference relevant files for each agent

4. **Test Propagation**
   - Make a change to knowledge file
   - Run agents
   - Verify they all use updated framework

---

## Pattern 2: Checkpoint Philosophy

### Problem

Most AI writing assistance turns humans into reviewers of AI-generated content. The AI makes all decisions, then the human edits. This loses the human's creative voice and judgment.

### Solution

Preserve human judgment at critical decision points through structured checkpoints. The AI provides craft expertise; the human provides creative direction.

**The Formula:**
> YOUR insights + My pattern recognition + Your judgment + My execution = YOUR voice at scale

### Implementation

**Checkpoint in Workflow (`workflows/transform.yaml`):**
```yaml
steps:
  - id: step_01
    name: Analyst Agent
    type: agent
    agent: your-analyst
    command: ANALYZE

    checkpoint:
      id: checkpoint_1
      name: Creative Direction
      wait_for_user: true

      prompt:
        - "What's YOUR thesis from this content?"
        - "Which insights resonated most with YOU?"
        - "What's your angle on this?"

    output:
      path: "{output}/analysis/{timestamp}-analysis.md"
```

**Agent Output Precedes Checkpoint:**
```markdown
## Analysis Results

### Core Tension
[Agent provides analysis]

### Key Insights
1. [Insight A]
2. [Insight B]
3. [Insight C]

---

## Checkpoint Questions for Creator

After presenting my analysis, I need YOUR input:

1. **What's YOUR thesis from this content?**
   - What insight do YOU want to emphasize?

2. **Which insights resonated most with YOU?**
   - Did I miss anything that struck you?

3. **What's your angle on this?**
   - How does this connect to your expertise?
```

**Workflow Pauses:**
- Agent completes analysis
- Workflow pauses (`wait_for_user: true`)
- System displays checkpoint questions
- System **WAITS** for human input
- Human provides direction
- Workflow incorporates human input
- Workflow proceeds to next step

### Checkpoint Types

**Type 1: Thesis & Direction (After Analysis)**
- Purpose: Ensure AI extracts insights, not decides what matters
- Questions: What's your thesis? What resonated? What's your angle?
- Human provides: Creative direction, emphasis, personal connection

**Type 2: Structure & Pattern Approval (After Architecture)**
- Purpose: Ensure AI designs structure, not decides creative choices
- Questions: Does this serve your thesis? Pattern approval? Title preference?
- Human provides: Structural approval, pattern fit confirmation, naming

**Type 3: Final Approval (After Editing)**
- Purpose: Ensure human maintains final quality gate
- Questions: Does this pass your litmus test? Ready to publish?
- Human provides: Final approval, publish decision

### Real Example: Conscious-Founder

**4 Checkpoints in Transform Workflow:**

**Checkpoint 1 (after Analyst):**
- AI extracts all insights from transcript
- Human selects: "This is my thesis"
- Human identifies: "These 3 insights resonate most"
- Human specifies: "This is my angle"

**Checkpoint 2 (after Architect):**
- AI designs newsletter structure
- Human approves: "Yes, Systemic Trap pattern works"
- Human confirms: "Use this title"
- Human adjusts: "Add this section I care about"

**Checkpoint 4 (after Editor):**
- AI reviews against quality gates
- Human validates: "This passes my litmus test"
- Human decides: "Ready to publish"

### Benefits

✅ **Creative Control Maintained** - Human directs, AI executes
✅ **Voice Preserved** - Output is human's voice amplified, not AI's interpretation
✅ **Insight Augmentation** - AI pattern recognition + human judgment
✅ **Collaboration Not Replacement** - AI as skilled collaborator, not replacement

### Adapting This Pattern

**For Your Workflow:**

1. **Identify Critical Decision Points**
   - Where does human judgment matter most?
   - What decisions can AI not make for you?
   - Where would AI choice reduce creative control?

2. **Design Checkpoint Questions**
   - What input do you need from the human?
   - What creative direction must the human provide?
   - What approval points are essential?

3. **Implement in Workflow**
   - Add `checkpoint:` section to workflow steps
   - Set `wait_for_user: true`
   - Define `prompt:` with your questions

4. **Verify Pauses Work**
   - Run workflow
   - Confirm it actually pauses at checkpoints
   - Ensure it waits for human input
   - Verify human input flows to next steps

---

## Pattern 3: State Persistence Across Workflows

### Problem

Creative workflows often span multiple sessions or phases. Captured context in one phase needs to flow into subsequent phases.

**Example:**
- Session 1: Capture creative emphasis before "boiling phase"
- Session 2: Run full K2M pipeline after boiling completes
- Need: Emphasis from Session 1 flows into Session 2

### Solution

Use file-based state persistence with standardized paths and timestamps.

**Inject Workflow (Capture Emphasis):**
```yaml
steps:
  - id: inject_01
    name: Capture Creative Emphasis
    description: Record emphasis before boiling phase

    input:
      type: user_input
      prompt: "What angle do you want to emphasize?"

    output:
      path: "{output}/emphasis/latest-emphasis.md"
```

**Transform Workflow (Load Emphasis):**
```yaml
steps:
  - id: transform_01
    name: Load Emphasis (if available)
    description: Load previously captured emphasis

    input:
      type: file
      path: "{output}/emphasis/latest-emphasis.md"
      optional: true

    action:
      if_found: "Load and display emphasis"
      if_not_found: "Continue without emphasis (user can provide at Checkpoint 1)"
```

### Implementation Patterns

**Pattern A: Latest State**
```yaml
output:
  path: "{output}/emphasis/latest-emphasis.md"
```
- Use for: Most recent state
- Overwrites: Previous file
- Example: Current creative emphasis

**Pattern B: Timestamped State**
```yaml
output:
  path: "{output}/analysis/{timestamp}-analysis.md"
```
- Use for: Historical record
- Creates: New file each run
- Example: Analysis outputs, drafts

**Pattern C: Aggregated State**
```yaml
output:
  path: "{output}/nodes/registry.json"
  mode: append
```
- Use for: Accumulating data
- Appends: To existing file
- Example: Node registry, territory mapping

### Real Example: Conscious-Founder

**Inject → Transform Flow:**

**Session 1 (Inject):**
```bash
# User captures emphasis
/bmad:conscious-founder:inject

# Saves to:
output/emphasis/latest-emphasis.md
```

**Session 2 (3 days later, Transform):**
```bash
# User runs full pipeline
/bmad:conscious-founder:transform

# Workflow loads:
output/emphasis/latest-emphasis.md

# Displays:
"Found saved emphasis from [date]: [emphasis text]"
```

**State Types:**
- `emphasis/` - Creative emphasis files (latest)
- `analysis/` - Analyst outputs (timestamped)
- `structure/` - Architect outputs (timestamped)
- `drafts/` - Copywriter outputs (timestamped)
- `published/` - Final published pieces (timestamped)
- `nodes/` - Node registry data (aggregated)

### Benefits

✅ **Asynchronous Workflows** - Capture now, process later
✅ **Context Preservation** - No loss of creative intent
✅ **Session Independence** - Each workflow is standalone
✅ **Historical Record** - Timestamped files provide audit trail

### Adapting This Pattern

**For Your Module:**

1. **Identify State to Persist**
   - What context needs to flow between workflows?
   - What data accumulates over time?
   - What's the workflow sequence?

2. **Design Directory Structure**
   ```bash
   output/
   ├── current/     # Latest state files
   ├── history/     # Timestamped records
   └── registry/    # Accumulated data
   ```

3. **Standardize Paths**
   - Use `{output}` variable for base path
   - Use descriptive subdirectories
   - Use consistent naming conventions

4. **Implement Load/Save**
   - Workflow 1: Save state to file
   - Workflow 2: Load state from file
   - Handle missing files gracefully (optional: true)

---

## Pattern 4: Multi-Agent Pipeline with Checkpoints

### Problem

Complex workflows require multiple specialized agents working in sequence. Each agent needs input from previous agents, and human judgment needs to be preserved at critical points.

### Solution

Orchestrate agents through workflow YAML with:
- Sequential agent execution
- State handoff between agents
- Checkpoint pauses for human input
- Output path management

### Implementation

**Workflow Architecture:**
```yaml
name: multi-agent-pipeline
description: Execute 4-agent pipeline with checkpoints

steps:
  # Agent 1: Analyst
  - id: step_01
    name: Analyst Agent
    type: agent
    agent: content-analyst
    command: ANALYZE

    input:
      - transcript.md

    checkpoint:
      id: checkpoint_1
      name: Thesis & Direction
      wait_for_user: true
      prompt:
        - "What's YOUR thesis?"
        - "What resonated most?"

    output:
      path: "{output}/analysis/{timestamp}-analysis.md"

  # Agent 2: Architect (uses Analyst output + human input)
  - id: step_02
    name: Architect Agent
    type: agent
    agent: content-architect
    command: STRUCTURE

    input:
      - "{output}/analysis/{timestamp}-analysis.md"
      - user_checkpoint_1_input

    checkpoint:
      id: checkpoint_2
      name: Structure Approval
      wait_for_user: true
      prompt:
        - "Does this structure serve your thesis?"
        - "Approve pattern?"

    output:
      path: "{output}/structure/{timestamp}-structure.md"

  # Agent 3: Copywriter (uses Architect output + human approval)
  - id: step_03
    name: Copywriter Agent
    type: agent
    agent: content-writer
    command: WRITE

    input:
      - "{output}/structure/{timestamp}-structure.md"
      - user_checkpoint_2_input

    output:
      path: "{output}/drafts/{timestamp}-draft.md"

  # Agent 4: Editor (uses Copywriter output)
  - id: step_04
    name: Editor Agent
    type: agent
    agent: content-editor
    command: REVIEW

    input:
      - "{output}/drafts/{timestamp}-draft.md"

    checkpoint:
      id: checkpoint_4
      name: Final Approval
      wait_for_user: true
      prompt:
        - "Does this pass your litmus test?"
        - "Ready to publish?"

    output:
      path: "{output}/published/{timestamp}-final.md"
```

### Data Flow

```
Transcript
    ↓
[Agent 1: Analyst]
    ↓ (produces analysis)
[Checkpoint 1: Human provides thesis, resonances, angle]
    ↓ (analysis + human input)
[Agent 2: Architect]
    ↓ (produces structure)
[Checkpoint 2: Human approves pattern, title, structure]
    ↓ (structure + human approval)
[Agent 3: Copywriter]
    ↓ (produces draft)
[Agent 4: Editor]
    ↓ (produces reviewed draft)
[Checkpoint 4: Human gives final approval]
    ↓ (final piece)
Published
```

### Real Example: Conscious-Founder

**Transform Workflow:**
- Analyst extracts insights → Human provides thesis
- Architect designs structure → Human approves pattern
- Copywriter writes draft → (optional checkpoint)
- Editor reviews quality → Human approves final

**Each Agent:**
- Receives output from previous agent
- Receives human input from most recent checkpoint
- Produces output for next agent (or final output)

### Benefits

✅ **Specialization** - Each agent excels at one task
✅ **Human Control** - Checkpoints preserve creative direction
✅ **State Handoff** - Clean data flow between agents
✅ **Modularity** - Agents can be swapped or upgraded

### Adapting This Pattern

**For Your Workflow:**

1. **Decompose Your Process**
   - What are the natural stages?
   - Where does specialized expertise help?
   - Where does human judgment matter?

2. **Design Agent Sequence**
   - Order agents by dependency
   - Identify checkpoint locations
   - Map data flow between agents

3. **Define Inputs/Outputs**
   - What does each agent need?
   - What does each agent produce?
   - Where are files stored?

4. **Test End-to-End**
   - Verify each agent works independently
   - Test handoffs between agents
   - Confirm checkpoints pause correctly
   - Validate final output quality

---

## Pattern 5: Fuzzy Command Matching

### Problem

Users shouldn't have to remember exact command shortcuts. Natural language commands should work.

### Solution

Implement fuzzy matching in agent menu system. Accept variations and synonyms.

### Implementation

**Agent Menu Definition:**
```xml
<menu>
  <item cmd="MH or fuzzy match on menu or help">[MH] Redisplay Menu Help</item>
  <item cmd="AN or fuzzy match on analyze">[AN] Analyze Content</item>
  <item cmd="CH or fuzzy match on chat">[CH] Chat with Agent</item>
  <item cmd="DA or fuzzy match on exit">[DA] Dismiss Agent</item>
</menu>
```

**User Input Variations All Work:**
- "1" or "MH" or "menu" or "help" → Show menu
- "2" or "AN" or "analyze" or "analyze this" → Run analysis
- "3" or "CH" or "chat" or "talk" → Enter chat mode
- "4" or "DA" or "exit" or "bye" or "dismiss" → Dismiss agent

**Agent Activation Logic:**
```xml
<step n="6">STOP and WAIT for user input</step>
<step n="7">On user input:
  Number → execute menu item[n]
  Text → case-insensitive substring match
  Multiple matches → ask user to clarify
  No match → show "Not recognized"
</step>
```

### Benefits

✅ **Natural Interaction** - Users speak naturally, not memorize commands
✅ **Error Reduction** - Typos and variations still work
✅ **Accessibility** - Easier for new users
✅ **Flexibility** - Multiple ways to invoke same action

### Adapting This Pattern

**For Your Agents:**

1. **Define Command Shortcuts**
   - 2-3 letter abbreviations for common actions
   - Use descriptive letters (e.g., "AN" for Analyze)

2. **Define Fuzzy Matches**
   - List synonyms and variations
   - Include common misspellings
   - Think about natural language

3. **Document in Menu**
   - Show both shortcut and fuzzy match
   - Example: `[AN] Analyze Content`

4. **Test Variations**
   - Test shortcut works
   - Test full word works
   - Test variations work
   - Test typos handled gracefully

---

## Summary: Pattern Catalog

| Pattern | Purpose | Use When |
|---------|---------|----------|
| **Single-Source-of-Truth** | Shared frameworks, easy updates | Multiple agents use same knowledge |
| **Checkpoint Philosophy** | Preserve human judgment | Creative control matters most |
| **State Persistence** | Asynchronous workflows | Context spans multiple sessions |
| **Multi-Agent Pipeline** | Complex workflows | Task requires multiple specialists |
| **Fuzzy Matching** | Natural commands | Usability and accessibility |

---

## Using These Patterns

**As Template:**
1. Identify which patterns match your use case
2. Copy the implementation structure
3. Adapt to your specific domain
4. Test thoroughly

**As Inspiration:**
1. Understand the problem each pattern solves
2. Think about your analogous problems
3. Design your own solution inspired by these
4. Document your new pattern

**Contributing Back:**
If you create new patterns based on these, consider:
- Documenting them clearly
- Sharing with the community
- Citing the conscious-founder module as inspiration

---

*These patterns emerged from building the conscious-founder module. They're reusable architectural solutions for common agent system challenges.*

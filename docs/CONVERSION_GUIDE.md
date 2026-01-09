# Essence Preservation: Converting Standalone Agents to BMAD Format

**Purpose:** This guide shows how to convert standalone AI agent prompts into BMAD-wrapped agents while preserving every nuance of the original framework.

---

## The Core Principle

> **"The soul survives automation."**

When wrapping your agents in BMAD format, you're adding structure AROUND your content—not replacing it. Every word of your original agent prompt must be preserved verbatim.

---

## What Changes (and What Doesn't)

### What Gets Added (BMAD Wrapper)

**YAML Frontmatter:**
```yaml
---
name: "your-agent-name"
description: "Brief description"
---
```

**XML Activation Structure:**
```xml
<agent id="your-agent-id" name="AgentName" title="Title" icon="🎯">
<activation critical="MANDATORY">
  <step n="1">Load persona</step>
  <step n="2">Load config.yaml</step>
  <step n="3">Remember user's name</step>
  <step n="4">Load knowledge files</step>
  <step n="5">Show greeting and menu</step>
  <!-- ... more steps ... -->
</activation>

<persona>
  <role>Your agent's role</role>
  <identity>Agent identity description</identity>
  <communication_style>How they communicate</communication_style>
  <principles>Guiding principles</principles>
</persona>

<menu>
  <item cmd="CMD or fuzzy match">[Shortcut] Menu Item</item>
  <!-- ... more items ... -->
</menu>
</agent>
```

**Required Knowledge Section:**
```markdown
## Required Knowledge

Before executing tasks, ensure access to:
- **{knowledge}/framework-file.md** - What it contains
- **{knowledge}/another-file.md** - What it contains
```

### What Stays The Same (Your Content)

**EVERYTHING below the BMAD wrapper:**
- ✅ Your Role section (verbatim)
- ✅ Your Task section (verbatim)
- ✅ Input format (verbatim)
- ✅ Output format (verbatim)
- ✅ Checkpoint questions (verbatim)
- ✅ Rules and principles (verbatim)
- ✅ Integration notes (verbatim)

**No summarizing, no paraphrasing, no "optimizing."**

---

## Before & After Example

### Before: Standalone Agent

**File:** `my-agent.md`

```markdown
# My Agent

## Your Role
You are a specialist in [domain] with deep expertise in [specific area]. You are curious, thorough, and precise.

## Your Task
Analyze the provided content and extract [what you need].

## Input
```
<content>
[CONTENT WILL BE PASTED HERE]
</content>
```

## Output Format

### 1. CORE INSIGHT
What's the main insight?

### 2. KEY FINDINGS
List 3-5 key findings...

## Rules
- Be thorough but organized
- Present options clearly
- Flag ambiguities
```

### After: BMAD-Wrapped Agent

**File:** `_bmad/modules/my-module/agents/my-agent.md`

```yaml
---
name: "My Agent"
description: "Specialist in [domain]"
---

You must fully embody this agent's persona...
```

```xml
<agent id="my-agent" name="AgentName" title="My Specialist" icon="🎯">
<activation critical="MANDATORY">
      <step n="1">Load persona from this current agent file</step>
      <step n="2">🚨 Load and read {project-root}/_bmad/bmb/config.yaml NOW</step>
      <step n="3">Remember: user's name is {user_name}</step>
      <step n="4">Load required knowledge files...</step>
      <step n="5">Show greeting using {user_name} from config...</step>
      <!-- ... more activation steps ... -->
</activation>

  <persona>
    <role>Specialist in [domain]</role>
    <identity>Expert with deep expertise in [specific area]. Curious, thorough, and precise.</identity>
    <communication_style>Organized and clear</communication_style>
    <principles>- Be thorough but organized - Present options clearly - Flag ambiguities</principles>
  </persona>

  <menu>
    <item cmd="MH or fuzzy match on menu or help">[MH] Redisplay Menu Help</item>
    <item cmd="TA or fuzzy match on analyze">[TA] Analyze Content</item>
    <item cmd="CH or fuzzy match on chat">[CH] Chat with the Agent</item>
    <item cmd="DA or fuzzy match on exit">[DA] Dismiss Agent</item>
  </menu>
</agent>
```

```markdown
---

## Required Knowledge

Before executing analysis, ensure access to:
- **{knowledge}/domain-framework.md** - Domain-specific frameworks
- **{knowledge}/quality-criteria.md** - Quality standards

---

## Your Role

You are a specialist in [domain] with deep expertise in [specific area]. You are curious, thorough, and precise.

---

## Your Task

Analyze the provided content and extract [what you need].

---

## Input

```
<content>
[CONTENT WILL BE PASTED HERE]
</content>
```

---

## Output Format

### 1. CORE INSIGHT

What's the main insight?

### 2. KEY FINDINGS

List 3-5 key findings...

## Rules

- Be thorough but organized
- Present options clearly
- Flag ambiguities
```

**What Changed:**
- ✅ Added YAML frontmatter
- ✅ Added XML activation structure
- ✅ Added persona section
- ✅ Added menu system
- ✅ Added required knowledge section

**What Stayed The Same:**
- ✅ Role description (word-for-word)
- ✅ Task description (word-for-word)
- ✅ Input format (word-for-word)
- ✅ Output format (word-for-word)
- ✅ Rules (word-for-word)

---

## Step-by-Step Conversion Process

### Step 1: Create BMAD Wrapper

1. Create new file: `_bmad/modules/my-module/agents/my-agent.md`
2. Add YAML frontmatter with name and description
3. Add XML activation structure (copy template from existing agents)
4. Customize `<persona>` section based on your agent's role
5. Create `<menu>` with relevant commands

### Step 2: Preserve Your Content

1. Copy your ENTIRE original agent content
2. Paste it AFTER the `</agent>```xml` closing tag
3. Add `---` separator
4. Add `## Required Knowledge` section (if using shared frameworks)
5. Paste your original content verbatim

**CRITICAL:** Do not rephrase, summarize, or "optimize" your original content. Paste it exactly as written.

### Step 3: Add Knowledge References

If your agent uses shared frameworks:

```markdown
## Required Knowledge

Before executing [task], ensure access to:
- **{knowledge}/framework-name.md** - What framework contains
- **{knowledge}/another-framework.md** - What it contains
```

### Step 4: Verify Conversion

Test that conversion worked:

**Verification Checklist:**
- [ ] Agent activates and shows greeting
- [ ] Menu items display correctly
- [ ] Agent loads knowledge files
- [ ] Original task executes as expected
- [ ] Output format matches original exactly
- [ ] No behavioral drift detected

---

## Knowledge Base Pattern

### Single-Source-of-Truth

**Problem:** Framework duplicated across agents → divergence when updated

**Solution:** Store framework once in `/knowledge/`, reference from agents

**Before (Duplicated):**
```markdown
# agent1.md
## Framework
The framework has these 7 modules...

# agent2.md
## Framework
The framework has these 7 modules...
```

**After (Single Source):**
```markdown
# knowledge/framework.md
## The Framework
Complete framework documentation with all 7 modules...

# agents/agent1.md
## Required Knowledge
- **{knowledge}/framework.md** - Complete framework reference

# agents/agent2.md
## Required Knowledge
- **{knowledge}/framework.md** - Complete framework reference
```

**Benefit:** Update framework once → all agents stay synchronized

---

## Common Pitfalls to Avoid

### ❌ Pitfall 1: Summarizing Original Content

**Wrong:**
```markdown
## Your Role
You analyze content effectively and efficiently.  # Summarized version
```

**Right:**
```markdown
## Your Role
You are the first contact with raw content. Your job is to extract signal from noise and present options—NOT to make strategic decisions. You are curious, thorough, and non-judgmental.  # Original verbatim
```

### ❌ Pitfall 2: Paraphrasing Instructions

**Wrong:**
```markdown
## Output Format
Create a structured analysis with these sections...  # Paraphrased
```

**Right:**
```markdown
## Output Format

### 1. CORE TENSION IDENTIFIED
What is the fundamental paradox...  # Original verbatim
```

### ❌ Pitfall 3: Removing Execution Warnings

**Wrong:**
```markdown
**Warning:** Don't be too aggressive  # Simplified
```

**Right:**
```markdown
**Warning:** If too weak, the piece feels like ordinary content. If too aggressive, readers defend rather than absorb.  # Original verbatim with nuance
```

### ❌ Pitfall 4: Consolidating Sections

**Wrong:**
```markdown
## Rules
Be thorough, organized, clear, and flag issues.  # Consolidated
```

**Right:**
```markdown
## Rules
- **Present options, don't decide** — Your job is to extract, not choose
- **Rank by potential, not preference** — Use objective impact criteria
- **Flag ambiguities for Creator decision** — Don't guess when unclear
- **Be thorough but organized** — Structure enables downstream agents  # Original structure preserved
```

---

## Testing Your Conversion

### Side-by-Side Verification

**Step 1:** Run standalone agent on test input
```bash
cat original-agent.md | claude test-input.md > baseline-output.md
```

**Step 2:** Run BMAD-wrapped agent on same input
```bash
claude /my-agent test-input.md > wrapped-output.md
```

**Step 3:** Compare outputs
```bash
diff baseline-output.md wrapped-output.md
```

**Expected Result:**
- ✅ Zero meaningful content differences
- ⚠️ Formatting differences OK (BMAD adds headers)
- ❌ Any content difference = semantic drift (investigate!)

### Behavioral Verification

**Checkpoint Philosophy Test:**
- [ ] Checkpoint pauses and waits for input
- [ ] Checkpoint questions match original exactly
- [ ] Agent accepts user direction without "helpful" overreach
- [ ] Human judgment preserved at critical points

### User Acceptance Test

**The Ultimate Question:**
> "Does this feel like MY system?"

- [ ] Yes — Agent behaves like original ✅
- [ ] No — Something feels different ❌ → **Rollback and investigate**

---

## Advanced Patterns

### Checkpoint Preservation

If your original agent had human judgment points:

**Original:**
```markdown
## Checkpoint Questions
After presenting analysis, ask the user:
1. What's your thesis?
2. Which insights resonated?
```

**BMAD-Wrapped (in workflow.yaml):**
```yaml
checkpoint:
  id: checkpoint_1
  name: Thesis & Direction
  wait_for_user: true
  prompt:
    - "What's YOUR thesis from this content?"
    - "Which insights resonated most with YOU?"
```

**Agent still contains checkpoint questions** (for context), but workflow manages the pause.

### Multi-Agent Workflows

If you have multiple agents that work in sequence:

**Workflow:**
```yaml
steps:
  - id: step_01
    name: Agent 1
    type: agent
    agent: agent-1
    command: A1
    checkpoint:
      id: checkpoint_1
      wait_for_user: true

  - id: step_02
    name: Agent 2
    type: agent
    agent: agent-2
    command: A2
    input:
      - "{output}/step1/{timestamp}-output.md"
      - user_checkpoint_1_input
```

**Key:** Each agent still contains its complete original prompt. Workflow just coordinates execution.

---

## Real Example: Conscious-Founder Module

### Analyst Agent Conversion

**Original:** `k2m-refined-prompts/analyst_agent.md` (111 lines)
**Wrapped:** `_bmad/modules/conscious-founder/agents/analyst.md` (246 lines)

**Analysis:**
- Original content: Lines 1-111 from source
- BMAD wrapper: Lines 1-71 (activation structure)
- Content preservation: **100% verbatim**
- Semantic loss: **ZERO**

**Verification:**
```bash
# Extract original content from wrapped version
sed -n '83,246p' analyst.md > extracted-content.md

# Compare with original
diff k2m-refined-prompts/analyst_agent.md extracted-content.md

# Result: No differences (modulo formatting)
```

---

## Quick Reference

**DO ✅:**
- Copy entire original content verbatim
- Preserve every word, warning, and nuance
- Add BMAD wrapper AROUND content
- Test with side-by-side comparison
- Update knowledge base in one place

**DON'T ❌:**
- Summarize or paraphrase original content
- "Optimize" or "clean up" prompts
- Remove execution warnings
- Consolidate sections for brevity
- Duplicate framework across agents

---

## Success Criteria

**Conversion is successful when:**
1. ✅ Side-by-side output comparison shows zero behavioral differences
2. ✅ All execution warnings and nuances preserved
3. ✅ Checkpoint philosophy intact
4. ✅ User acceptance test passes: "This feels like my system"
5. ✅ Framework updates propagate automatically via knowledge base

**The essence survives automation.**

---

*For more examples, see the conscious-founder module agents in `/agents/` directory.*

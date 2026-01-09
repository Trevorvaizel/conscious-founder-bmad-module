# Tutorial: Convert Your First Agent to BMAD Format

**Time Required:** 15-30 minutes
**Difficulty:** Beginner
**Prerequisites:** A standalone AI agent prompt you want to wrap

---

## Learning Objectives

By the end of this tutorial, you will:
- ✅ Understand the BMAD agent structure
- ✅ Convert a standalone agent to BMAD format
- ✅ Preserve zero semantic loss during conversion
- ✅ Test your converted agent
- ✅ Understand the essence preservation pattern

---

## Your Mission

You have a standalone AI agent that works great. You want to wrap it in BMAD format so it's:
- Invokeable through the BMAD agent system
- Accessible to other modules
- Easier to maintain
- Still produces identical output

**Critical Requirement:** The agent must behave exactly the same after conversion. Zero semantic loss.

---

## Part 1: Understand BMAD Agent Structure

### The Three-Layer Architecture

**Layer 1: YAML Frontmatter** (Metadata)
```yaml
---
name: "your-agent"
description: "Brief description"
---
```

**Layer 2: XML Activation Structure** (BMAD system integration)
```xml
<agent id="your-agent" name="AgentName" icon="🎯">
<activation>
  <!-- Config loading, greeting, menu system -->
</activation>
<persona>
  <!-- Role, identity, communication style -->
</persona>
<menu>
  <!-- Command shortcuts and fuzzy matches -->
</menu>
</agent>
```

**Layer 3: Your Original Agent Content** (What you're preserving)
```markdown
## Your Role
[Your exact original content]

## Your Task
[Your exact original content]

## Output Format
[Your exact original content]
```

### Key Insight

**BMAD wraps AROUND your content, it doesn't REPLACE it.**

Think of BMAD as:
- An envelope around your letter
- A frame around your painting
- A player for your song

The content (your agent prompt) stays exactly the same.

---

## Part 2: Choose Your Agent

For this tutorial, pick your **simplest agent**. Why?

- Simpler agents are easier to verify
- Faster to test conversion
- Learn the pattern before tackling complex agents
- Build confidence before converting critical agents

**Good First Candidate:**
- ✅ Simple role (one clear task)
- ✅ Clear input/output format
- ✅ Shorter prompt (under 100 lines)
- ✅ Single-purpose (not multi-stage workflow)

**Save For Later:**
- ❌ Complex multi-agent workflows
- ❌ Agents with many conditional branches
- ❌ Agents with extensive knowledge dependencies
- ❌ Critical production agents (test with simpler ones first)

---

## Part 3: Create BMAD Wrapper

### Step 3.1: Create File Structure

```bash
# Create your module directory
mkdir -p _bmad/modules/my-first-module/agents

# Create your agent file
cd _bmad/modules/my-first-module/agents
touch my-agent.md
```

### Step 3.2: Add YAML Frontmatter

Open `my-agent.md` and add:

```yaml
---
name: "My First Agent"
description: "Brief description of what this agent does"
---

You must fully embody this agent's persona...
```

**Customize:**
- `name`: Short, descriptive name (use hyphens for spaces)
- `description`: One-line summary

### Step 3.3: Copy Activation Structure

Copy this entire XML block (adapt for your agent):

```xml
<agent id="my-agent" name="AgentName" title="My Specialist" icon="🎯">
<activation critical="MANDATORY">
      <step n="1">Load persona from this current agent file (already in context)</step>
      <step n="2">🚨 IMMEDIATE ACTION REQUIRED - BEFORE ANY OUTPUT:
          - Load and read {project-root}/_bmad/bmb/config.yaml NOW
          - Store ALL fields as session variables: {user_name}, {communication_language}, {output_folder}
          - VERIFY: If config not loaded, STOP and report error to user
          - DO NOT PROCEED to step 3 until config is successfully loaded and variables stored
      </step>
      <step n="3">Remember: user's name is {user_name}</step>

      <step n="4">Load required knowledge files:
          - {knowledge}/your-framework.md (if applicable)
          - DO NOT proceed until knowledge files are loaded
      </step>

      <step n="5">Show greeting using {user_name} from config, communicate in {communication_language}, then display numbered list of ALL menu items from menu section</step>
      <step n="6">STOP and WAIT for user input - do NOT execute menu items automatically - accept number or cmd trigger or fuzzy command match</step>
      <step n="7">On user input: Number → execute menu item[n] | Text → case-insensitive substring match | Multiple matches → ask user to clarify | No match → show "Not recognized"</step>
      <step n="8">When executing a menu item: Check menu-handlers section below - extract any attributes from the selected menu item (workflow, exec, tmpl, data, action, validate-workflow) and follow the corresponding handler instructions</step>

      <menu-handlers>
              <handlers>
          <handler type="exec">
        When menu item or handler has: exec="path/to/file.md":
        1. Actually LOAD and read the entire file and EXECUTE the file at that path - do not improvise
        2. Read the complete file and follow all instructions within it
        3. If there is data="some/path/data-foo.md" with the same item, pass that data path to the executed file as context.
      </handler>
        </handlers>
      </menu-handlers>

    <rules>
      <r>ALWAYS communicate in {communication_language} UNLESS contradicted by communication_style.</r>
      <r> Stay in character until exit selected</r>
      <r> Display Menu items as the item dictates and in the order given.</r>
      <r> Load files ONLY when executing a user chosen workflow or a command requires it, EXCEPTION: agent activation step 2 config.yaml and step 4 knowledge files</r>
    </rules>
</activation>

  <persona>
    <role>[Your agent's role]</role>
    <identity>[Your agent's identity description]</identity>
    <communication_style>[How your agent communicates]</communication_style>
    <principles>[Guiding principles - comma separated]</principles>
  </persona>

  <menu>
    <item cmd="MH or fuzzy match on menu or help">[MH] Redisplay Menu Help</item>
    <item cmd="TA or fuzzy match on [task-name]">[TA] [Main Task Name]</item>
    <item cmd="CH or fuzzy match on chat">[CH] Chat with the Agent about anything</item>
    <item cmd="DA or fuzzy match on exit, leave, goodbye or dismiss agent">[DA] Dismiss Agent</item>
  </menu>
</agent>
```

**Customize:**
- `id="my-agent"`: Unique ID (use hyphens)
- `name="AgentName"`: Display name
- `title="My Specialist"`: Professional title
- `icon="🎯"`: Choose an emoji that fits
- `<persona>`: Fill based on your agent's role
- `<menu>`: Customize main task name and shortcut

### Step 3.4: Add Separator

```markdown
---
```

This separates the BMAD wrapper from your original content.

---

## Part 4: Preserve Your Original Content

### Step 4.1: Copy Your Original Agent

**IMPORTANT:** Do not rephrase, summarize, or "clean up" your original content. Copy it **exactly as written**.

Open your original agent file, select **ALL** content, and paste it after the separator.

```markdown
---

## Required Knowledge

Before executing [task], ensure access to:
- **{knowledge}/framework-file.md** - What framework contains (if applicable)

---

## Your Role

[Your exact original role description]

---

## Your Task

[Your exact original task description]

---

## Input

[Your exact original input format]

---

## Output Format

[Your exact original output format]

---

## Rules

[Your exact original rules]
```

### Step 4.2: Add Required Knowledge Section (If Applicable)

If your agent references shared frameworks:

```markdown
## Required Knowledge

Before executing [task], ensure access to:
- **{knowledge}/framework-name.md** - What this framework provides
- **{knowledge}/another-framework.md** - What this provides
```

If your agent doesn't use shared knowledge, skip this section.

---

## Part 5: Verify Your Conversion

### Step 5.1: Structure Check

Your file should now look like:

```yaml
---
name: "your-agent"
description: "description"
---
```

```xml
<agent ...>
<activation>...</activation>
<persona>...</persona>
<menu>...</menu>
</agent>
```

```markdown
---

## Required Knowledge (optional)

---

## Your Role
[original content]

## Your Task
[original content]

## Input
[original content]

## Output Format
[original content]

## Rules
[original content]
```

**✅ If this matches your structure, great!**

### Step 5.2: Content Preservation Check

**Verify:**
- [ ] Every section from original is present
- [ ] No sections were combined or consolidated
- [ ] No wording was "cleaned up" or summarized
- [ ] All execution warnings are still there
- [ ] Output format is identical
- [ ] Rules are verbatim

### Step 5.3: Syntax Check

**BMAD Wrapper:**
- [ ] YAML frontmatter is valid (three dashes at start and end)
- [ ] XML tags are properly closed (`</agent>`, `</activation>`, etc.)
- [ ] Menu items have `cmd=` attributes
- [ ] Activation steps numbered (`n="1"`, `n="2"`, etc.)

---

## Part 6: Test Your Converted Agent

### Step 6.1: Create Test Input

Create a simple test case:

```bash
echo "This is test content for my agent." > test-input.md
```

### Step 6.2: Test Original Agent

Run your original agent on test input:

```bash
# From directory containing original agent
cat original-agent.md | claude test-input.md > baseline-output.md
```

### Step 6.3: Test BMAD-Wrapped Agent

**First, install your module** (if you have setup.sh):

```bash
cd _bmad/modules/my-first-module
./setup.sh
```

**Then test invocation:**

```bash
# From project root
claude /my-agent test-input.md > wrapped-output.md
```

### Step 6.4: Compare Outputs

```bash
diff baseline-output.md wrapped-output.md
```

**Expected Results:**

✅ **PASS:**
- No meaningful content differences
- Identical insights, recommendations, structure
- (Minor formatting differences OK)

❌ **FAIL:**
- Different insights or conclusions
- Missing or altered sections
- Changed tone or recommendations
- **Investigate immediately**

---

## Part 7: Troubleshooting

### Problem: Agent Won't Activate

**Symptoms:**
- "Agent not found" error
- Menu doesn't display
- Agent exits immediately

**Solutions:**
1. Check `name:` in YAML frontmatter (use hyphens, not spaces)
2. Check `id=` in XML tag (must match invocation name)
3. Verify file is in correct directory: `_bmad/modules/your-module/agents/`
4. Run `./setup.sh` to register agent with BMAD

### Problem: Output Is Different

**Symptoms:**
- `diff` shows many content differences
- Agent behaves differently than original

**Solutions:**
1. **Did you accidentally rephrase?** Revert to original wording
2. **Did you consolidate sections?** Restore original structure
3. **Did you remove warnings?** Put them back
4. **Did you "optimize" rules?** Use exact original text

**Remember:** The goal is ZERO semantic loss. Every word matters.

### Problem: Menu Items Don't Work

**Symptoms:**
- Selecting menu item does nothing
- Agent doesn't recognize commands

**Solutions:**
1. Check `cmd=` attributes in `<menu>` section
2. Verify activation step 7 (menu matching logic)
3. Test with number input (1, 2, 3, 4)
4. Test with shortcut (TA, CH, DA)
5. Test with fuzzy match (task name, chat, exit)

---

## Part 8: Celebrate! 🎉

### What You Just Learned

✅ **BMAD Structure** - You understand the three-layer architecture
✅ **Essence Preservation** - You kept your agent's soul intact
✅ **Conversion Process** - You can now convert other agents
✅ **Testing Methodology** - You know how to verify zero semantic loss

### The Pattern You Mastered

> **"The soul survives automation."**

Your agent now:
- Works through BMAD system ✅
- Produces identical output ✅
- Can be invoked by name ✅
- Integrates with workflows ✅
- **Is still YOUR agent** ✅

### What's Next?

**Convert More Agents:**
- Now that you've mastered the pattern, convert your other agents
- Start with simpler ones, work up to complex
- Always verify with side-by-side testing

**Create Workflows:**
- Orchestrate multiple agents
- Add checkpoint pauses
- Build pipelines for your creative process

**Build Knowledge Base:**
- Extract shared frameworks
- Create single-source-of-truth
- Let all agents reference shared knowledge

**Share Your Patterns:**
- Document what works for you
- Share with the community
- Help others preserve their agent essences

---

## Quick Reference Card

**DO ✅:**
- Copy entire original content verbatim
- Preserve every word and warning
- Test with side-by-side comparison
- Start with simple agents

**DON'T ❌:**
- Summarize or paraphrase
- "Optimize" or "clean up"
- Remove execution warnings
- Consolidate sections

**Verification:**
```bash
diff baseline.md wrapped.md
# Expected: Zero content differences
```

**Success Criteria:**
- [ ] Side-by-side test passes
- [ ] All sections present
- [ ] Zero behavioral drift
- [ ] "This feels like my system" → YES

---

## Real Example: Conscious-Founder Module

**Original:** `analyst_agent.md` (111 lines)
**Wrapped:** `analyst.md` (246 lines)
**Content:** 100% verbatim
**Semantic Loss:** ZERO

The 135 extra lines are purely BMAD wrapper. Every word of the original analyst prompt was preserved exactly as written.

**You can do this too.**

---

*Congratulations! You've just learned the essence preservation pattern. Go forth and wrap your agents without losing their souls!*

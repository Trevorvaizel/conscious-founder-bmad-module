# Essence Preservation Testing Checklist

**Purpose:** Systematic verification that your BMAD-wrapped agents produce identical output to standalone agents.

---

## Test 1: Side-by-Side Output Comparison

**The Gold Standard for Semantic Loss Detection**

### Setup

**Required:**
- Original standalone agent file
- BMAD-wrapped agent file
- Test input (transcript, content, or data)

### Procedure

**Step 1: Run Standalone Agent**
```bash
# Method 1: Direct pipe
cat /path/to/original-agent.md | claude test-input.md > baseline-output.md

# Method 2: File reference
claude --file original-agent.md test-input.md > baseline-output.md
```

**Step 2: Run BMAD-Wrapped Agent**
```bash
# Invoke through BMAD agent system
claude /your-agent-name test-input.md > wrapped-output.md
```

**Step 3: Compare Outputs**
```bash
# Line-by-line comparison
diff baseline-output.md wrapped-output.md

# Side-by-side comparison
sdiff baseline-output.md wrapped-output.md

# Word-level differences
wdiff baseline-output.md wrapped-output.md
```

### Expected Results

**✅ PASS Criteria:**
- Zero meaningful content differences
- Identical insights, structure, and recommendations
- Same tone, voice, and style
- Output sections match exactly

**⚠️ ACCEPTABLE Differences:**
- BMAD metadata headers (agent activation messages)
- Minor formatting variations (spacing, line breaks)
- Timestamp differences in output paths

**❌ FAIL Criteria:**
- Different insights or conclusions
- Missing or altered sections
- Changed tone or voice
- Different recommendations or rankings
- Altered checkpoint questions
- Missing execution warnings

### Example

**Baseline Output:**
```markdown
## Core Tension
The fundamental conflict is between X and Y because...

## Key Insights
1. Insight A (Rank 1) - This matters because...
2. Insight B (Rank 2) - This matters because...
```

**Wrapped Output:**
```markdown
## Core Tension
The fundamental conflict is between X and Y because...

## Key Insights
1. Insight A (Rank 1) - This matters because...
2. Insight B (Rank 2) - This matters because...
```

**Verdict:** ✅ IDENTICAL (zero semantic loss)

---

## Test 2: Framework Compliance Check

**Verifying All Prompt Sections Survived**

### Checklist by Agent Type

### For Analyst-Type Agents

- [ ] **Role Definition** - Present and unchanged
  - "Extract signal from noise, present options, don't decide"
  - "Curious, thorough, non-judgmental"

- [ ] **Output Format Sections** - All present and complete
  - [ ] Core Tension Identified
  - [ ] Key Insights (ranked by impact)
  - [ ] Potential Frameworks Detected
  - [ ] Memorable Examples & Stories
  - [ ] Quotable Moments
  - [ ] Content Gaps & Weaknesses
  - [ ] Audience Signals
  - [ ] Suggested Module Mapping

- [ ] **Checkpoint Questions** - All present and unchanged
  - [ ] Question 1: What's YOUR thesis?
  - [ ] Question 2: Which insights resonated?
  - [ ] Question 3: Who should read this?
  - [ ] Question 4: What's your angle?
  - [ ] Question 5: Any frameworks you're seeing?
  - [ ] Question 6: What tone feels right?

- [ ] **Rules/Principles** - All preserved
  - [ ] Present options, don't decide
  - [ ] Rank by potential, not preference
  - [ ] Flag ambiguities for decision
  - [ ] Be thorough but organized
  - [ ] Enable downstream agents

### For Architect-Type Agents

- [ ] **Pattern Selection Logic** - Complete and unchanged
  - [ ] All 5 juggling patterns documented
  - [ ] Psychological feel descriptions present
  - [ ] Pattern → audience matching intact
  - [ ] Risk factors documented

- [ ] **Structure Output** - All sections present
  - [ ] Pattern recommendation with rationale
  - [ ] 3 title/subtitle options
  - [ ] Module-by-module content mapping
  - [ ] Section structure with word counts
  - [ ] Framework placement recommendations
  - [ ] Subscribe CTA placement rationale

- [ ] **Checkpoint Questions** - All present
  - [ ] Pattern approval question
  - [ ] Structure serves thesis question
  - [ ] Examples featured question
  - [ ] Title preference question
  - [ ] Framework lexicon match question
  - [ ] Missing elements question

### For Copywriter-Type Agents

- [ ] **Voice Constants** - All preserved
  - [ ] Second person where creates intimacy
  - [ ] Short paragraphs for pacing
  - [ ] Strategic one-sentence paragraphs
  - [ ] Questions that land (not filler)
  - [ ] Specific over vague
  - [ ] No emoji, no excessive formatting
  - [ ] Confidence without arrogance

- [ ] **Execution Tactics** - Module-specific guidance intact
  - [ ] Module 1 execution tactics
  - [ ] Module 2 execution tactics
  - [ ] ... (all 7 modules)

- [ ] **Tone Calibration** - "Pressure with Dignity"
  - [ ] No moral superiority (Module 2)
  - [ ] No emotional bullying (Module 3)
  - [ ] No rescuing (Module 6)

### For Editor-Type Agents

- [ ] **Quality Gates** - All present
  - [ ] All 7 modules executed
  - [ ] Non-negotiables satisfied
  - [ ] No rescue/solutions provided
  - [ ] Weight stays with reader
  - [ ] Unresolved exit achieved

- [ ] **Litmus Test** - Present and clear
  - [ ] "Can't unsee what you pointed at"
  - [ ] Not just "interesting"

- [ ] **Module Execution Checklist** - All 7 modules
  - [ ] Module execution scores (1-10)
  - [ ] Specific feedback per module
  - [ ] Pass/fail criteria

- [ ] **Checkpoint Questions** - All present
  - [ ] Litmus test validation
  - [ ] Title/subtitle approval
  - [ ] Sections that feel off
  - [ ] Visual placement confirmation
  - [ ] Ready to publish decision

### General Framework Checks

- [ ] **ACM Framework** - Complete and accurate
  - [ ] All 7 modules with descriptions
  - [ ] 3 non-negotiables
  - [ ] Litmus test
  - [ ] Tone calibration (pressure with dignity)

- [ ] **Juggling Patterns** - All 5 present
  - [ ] Soft Infiltration (4→2→1→3→5→6→7)
  - [ ] Identity First (1→5→2→3→4→6→7)
  - [ ] Systemic Trap (2→1→3→4→5→6→7)
  - [ ] Late Identity (1→2→3→4→5→6→7, delay 5)
  - [ ] Agency Weight (strong 6, extended 7)

- [ ] **Execution Warnings** - All preserved
  - [ ] "If too weak..." consequences
  - [ ] "If too aggressive..." consequences
  - [ ] Module-specific risk factors

---

## Test 3: Behavioral Verification

**Checkpoint Philosophy in Action**

### Checkpoint Functionality Test

**Purpose:** Verify human judgment points are preserved

**Test Procedure:**

1. **Activate Agent**
   ```bash
   claude /your-agent
   ```

2. **Select Main Task from Menu**
   - Agent should show menu with numbered options
   - Select the primary task (e.g., "[AN] Analyze Transcript")

3. **Provide Test Input**
   - Paste test transcript or content
   - Hit enter

4. **Verify Checkpoint Behavior**

**Expected at Checkpoint:**
- [ ] Agent **PAUSES** after completing analysis
- [ ] Agent displays checkpoint questions
- [ ] Agent **WAITS** for user input (doesn't proceed automatically)
- [ ] Questions match original agent exactly
- [ ] No "helpful" overreach (agent doesn't answer its own questions)

**Checkpoint 1 Questions (Analyst Example):**
- [ ] "What's YOUR thesis from this content?"
- [ ] "Which insights resonated most with YOU?"
- [ ] "Who specifically should read this?"
- [ ] "What's your angle/connection to this?"
- [ ] "Any frameworks you're already seeing?"
- [ ] "What tone feels right for this piece?"

**User Response Test:**
- [ ] Type your thesis
- [ ] Hit enter
- [ ] Agent **ACKNOWLEDGES** your input
- [ ] Agent **INCORPORATES** your input into next step
- [ ] Agent proceeds to next agent/workflow step

**Failure Indicators:**
- ❌ Agent doesn't pause (proceeds automatically)
- ❌ Agent answers its own questions
- ❌ Agent summarizes or "helps" by providing answers
- ❌ Questions are different from original
- ❌ Agent ignores user input

### Workflow Integration Test

**For Multi-Agent Workflows:**

**Test Flow:**
```
Inject (capture emphasis)
  → should save to file
  → should display confirmation

Transform (run K2M pipeline)
  → should load saved emphasis
  → should run Analyst
  → should PAUSE at Checkpoint 1
  → should wait for user input
  → should run Architect
  → should PAUSE at Checkpoint 2
  → should run Copywriter
  → should run Editor
  → should PAUSE at Checkpoint 4
  → should wait for final approval

Return (re-enter published node)
  → should load node metadata
  → should display full context
  → should allow adding new insights

Repurpose (extract social posts)
  → should load published newsletter
  → should generate Type A posts
  → should generate Type B carousels
  → should generate Type C image posts
```

**Verification:**
- [ ] Each workflow step executes in order
- [ ] State persists between steps (emphasis flows from Inject to Transform)
- [ ] Checkpoints actually pause and wait
- [ ] User input incorporated into next steps
- [ ] Output files created in correct locations

---

## Test 4: User Acceptance Test

**The Ultimate Validation**

### The Question

> **"Does this feel like MY system?"**

After running your BMAD-wrapped agent, ask yourself:

**Qualitative Assessment:**
- [ ] Agent behaves like my original agent
- [ ] Output feels like my voice/tone
- [ ] Checkpoint experience matches original workflow
- [ ] No "AI helping too much" feeling
- [ ] Creative control stays with me

**Quantitative Assessment:**

| Aspect | Score (1-10) | Notes |
|--------|--------------|-------|
| Output quality | ___/10 | Same as original? |
| Tone accuracy | ___/10 | Voice preserved? |
| Checkpoint naturalness | ___/10 | Pauses feel right? |
| Creative control | ___/10 | I stay in charge? |
| Overall feel | ___/10 | "My system"? |

**Pass Criteria:** All scores ≥ 8/10

### A/B Testing (Optional)

If you have access to both versions:

**Blind Test:**
1. Have a colleague run both versions (don't label which is which)
2. Ask them to identify which is "original"
3. If they can't reliably tell → **SUCCESS** (zero behavioral drift)

---

## Test 5: Knowledge Base Verification

**Single-Source-of-Truth Pattern**

### Framework Access Test

**Purpose:** Verify agents can access shared knowledge

**Test Procedure:**

1. **Check Knowledge Files Exist**
   ```bash
   ls -la _bmad/modules/your-module/knowledge/
   ```
   - [ ] framework.md exists
   - [ ] patterns.md exists
   - [ ] All required knowledge files present

2. **Verify Agent References**
   ```bash
   grep -n "{knowledge}/" agents/your-agent.md
   ```
   - [ ] Knowledge references use correct path syntax
   - [ ] All referenced files exist

3. **Test Knowledge Loading**
   - Activate agent
   - Check agent activation logs (or agent greeting)
   - [ ] Agent confirms loading knowledge files
   - [ ] No "file not found" errors

4. **Test Framework Update Propagation**

   **Step 1:** Modify a framework in knowledge base
   ```bash
   # Add a new pattern to juggling-patterns.md
   echo "## New Pattern
   Description..." >> knowledge/juggling-patterns.md
   ```

   **Step 2:** Run agent that references that pattern
   ```bash
   claude /your-agent
   ```

   **Step 3:** Verify agent uses updated framework
   - [ ] Agent references new pattern
   - [ ] No need to modify agent file
   - [ ] Change propagated automatically

**Success:** Single update in knowledge base → all agents see the change

---

## Test 6: BMAD Platform Integration

**Installation and Invocation**

### Installation Test

```bash
# Run setup script
cd _bmad/modules/your-module
./setup.sh
```

**Verify:**
- [ ] Script completes without errors
- [ ] Agents registered in BMAD manifest
- [ ] Workflows registered in BMAD system
- [ ] Config.yaml updated correctly
- [ ] Knowledge base directories created
- [ ] Verification tests pass

### Invocation Test

```bash
# Test agent invocation from project root
claude /your-agent-name
```

**Verify:**
- [ ] Agent activates within 2 seconds
- [ ] Agent displays greeting with your name from config
- [ ] Agent displays menu options
- [ ] Agent responds to menu selections
- [ ] Agent responds to fuzzy command matching

**Test Commands:**
```bash
# Test number selection
echo "1" | claude /your-agent-name

# Test command shortcut
echo "AN" | claude /your-agent-name

# Test fuzzy match
echo "analyze this" | claude /your-agent-name
```

**Verify:**
- [ ] All three methods work
- [ ] Agent executes same task regardless of input method

### Workflow Invocation Test

```bash
# Test workflow execution
/bmad:your-module:transform
```

**Verify:**
- [ ] Workflow loads without errors
- [ ] Workflow displays progress
- [ ] Checkpoints pause correctly
- [ ] Output files created
- [ ] Workflow completes successfully

---

## Test 7: Performance Validation

**Non-Functional Requirements**

### Response Time Tests

**Agent Invocation:**
- [ ] Agent activates in < 2 seconds
- [ ] From command to greeting displayed
- [ ] Test multiple times (average should be < 2s)

**Workflow Execution:**
- [ ] Inject workflow: < 30 seconds to capture emphasis
- [ ] Transform workflow: Should be faster than manual execution (50%+ time savings target)
- [ ] Return workflow: < 60 seconds to load node context
- [ ] Repurpose workflow: < 5 minutes to generate 3-5 posts

### Resource Usage

**Monitor during execution:**
- [ ] Memory usage reasonable (no memory leaks)
- [ ] CPU usage spikes only during agent invocation
- [ ] No runaway processes
- [ ] Clean shutdown on agent dismissal

---

## Failure Diagnostics

### When Tests Fail

**Symptom: Output Differences**

**Diagnostic Steps:**
1. **Identify What Changed**
   ```bash
   diff -u baseline-output.md wrapped-output.md > changes.diff
   cat changes.diff
   ```

2. **Categorize the Change**
   - Formatting difference? → May be acceptable
   - Content difference? → Semantic loss detected
   - Missing section? → Content drop detected
   - Altered recommendation? → Behavioral drift

3. **Locate Source of Drift**
   - Check agent file: Did you accidentally summarize during conversion?
   - Check knowledge base: Did framework get simplified?
   - Check workflow: Did checkpoint get removed?

4. **Fix Strategy**
   - If content was changed: Revert to original wording
   - If section was dropped: Restore from original
   - If warning was removed: Put it back
   - Re-run test

**Symptom: Checkpoint Doesn't Pause**

**Diagnostic:**
- Check workflow.yaml: Is `wait_for_user: true` set?
- Check agent: Are checkpoint questions present?
- Check BMAD version: Checkpoint support requires BMAD v1.0+

**Symptom: Agent Can't Load Knowledge**

**Diagnostic:**
- Check path syntax: `{knowledge}/file.md` not `{project-root}/...`
- Check file existence: Does knowledge file actually exist?
- Check permissions: Is file readable?
- Check agent activation: Does agent load knowledge files at startup?

---

## Test Automation Script

**Optional: Automate the Testing Process**

```bash
#!/bin/bash
# test-essence-preservation.sh

AGENT="your-agent"
ORIGINAL="path/to/original-agent.md"
TEST_INPUT="test-input.md"

echo "Testing essence preservation for $AGENT..."

# Run baseline
cat "$ORIGINAL" | claude "$TEST_INPUT" > baseline.md

# Run wrapped version
claude "/$AGENT" "$TEST_INPUT" > wrapped.md

# Compare
if diff -q baseline.md wrapped.md > /dev/null; then
  echo "✅ PASS: Zero semantic loss detected"
  exit 0
else
  echo "❌ FAIL: Differences detected"
  echo "Showing differences:"
  diff baseline.md wrapped.md
  exit 1
fi
```

**Usage:**
```bash
chmod +x test-essence-preservation.sh
./test-essence-preservation.sh
```

---

## Master Testing Checklist

**Before Declaring Your Module Ready:**

### Content Preservation
- [ ] Side-by-side comparison shows zero content differences
- [ ] All prompt sections present and unchanged
- [ ] All execution warnings preserved
- [ ] All checkpoint questions intact

### Behavioral Equivalence
- [ ] Checkpoint pauses work correctly
- [ ] Agent waits for user input
- [ ] No "helpful" overreach detected
- [ ] User acceptance test passes

### Framework Integrity
- [ ] ACM framework complete (7 modules)
- [ ] Juggling patterns present (5 patterns)
- [ ] Quality gates intact
- [ ] Voice constants preserved

### Integration
- [ ] BMAD installation successful
- [ ] Agent invocation works (< 2 seconds)
- [ ] Workflow execution successful
- [ ] Knowledge base accessible

### Performance
- [ ] Response times meet requirements
- [ ] Resource usage acceptable
- [ ] No memory leaks or runaway processes

### User Validation
- [ ] "This feels like my system" → YES
- [ ] Creative control preserved → YES
- [ ] Checkpoint naturalness → GOOD

**✅ ALL CHECKS PASS → Your module is ready!**

---

*This checklist ensures your BMAD-wrapped agents preserve the essence of your original system. The soul survives automation.*

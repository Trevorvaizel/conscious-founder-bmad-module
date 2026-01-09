# K2M Knowledge Base - Single Source of Truth

**VERSION:** 1.0
**MODULE:** Conscious Founder (K2M Newsletter Transformation System)
**LAST UPDATED:** 2026-01-08

---

## What This Is

This knowledge base is the **canonical reference** for all K2M framework elements. Every agent, workflow, and tool in the K2M module references these files as the single source of truth.

**Purpose:** Prevent semantic drift and ensure consistency across all agents and workflows.

---

## KNOWLEDGE BASE STRUCTURE

```
knowledge/
├── README.md                      # This file - overview and navigation
├── acm-framework.md               # Core ACM framework (7 modules, 3 non-negotiables)
├── juggling-patterns.md           # 5 patterns with psychological feel
├── module-execution.md            # Tactics, warnings, calibration per module
├── pattern-selection.md           # Decision tree for choosing patterns
├── cta-placement.md               # Subscribe CTA strategy and timing
├── voice-constants.md             # K2M voice rules (all tones)
├── quality-gates.md               # Must-pass and should-pass criteria
└── checkpoint-philosophy.md       # Human judgment moments philosophy
```

---

## QUICK NAVIGATION

### I Need to Know...

**"What are the 7 ACM modules?"**
→ See `acm-framework.md`

**"Which juggling pattern should I use?"**
→ See `pattern-selection.md` for decision tree
→ See `juggling-patterns.md` for pattern details

**"How do I execute Module X correctly?"**
→ See `module-execution.md` for tactics and warnings

**"Where do I place the Subscribe CTA?"**
→ See `cta-placement.md`

**"What makes something sound like K2M?"**
→ See `voice-constants.md`

**"What are the quality standards?"**
→ See `quality-gates.md` for must-pass and should-pass criteria

**"Why do we need checkpoints?"**
→ See `checkpoint-philosophy.md`

---

## KNOWLEDGE BASE FILES OVERVIEW

### 1. acm-framework.md
**Purpose:** Core ACM framework reference
**Contains:**
- All 7 modules with functions and execution tactics
- Three non-negotiables
- Tone calibration rules ("pressure with dignity")
- Litmus test
- Application checklist
**Used by:** All agents (foundational reference)

---

### 2. juggling-patterns.md
**Purpose:** Pattern psychology and feel
**Contains:**
- All 5 juggling patterns with psychological signatures
- Best-for scenarios and risks
- Pattern → audience matching
- Tone pairing recommendations
- CTA placement shifts by pattern
**Used by:** Architect (pattern recommendation), Copywriter (execution), Editor (validation)

---

### 3. module-execution.md
**Purpose:** Tactics, warnings, quality scoring
**Contains:**
- Execution tactics per module
- Warning signs (too weak / too aggressive)
- Quality check questions per module
- Tone calibration ("pressure with dignity")
- Cross-module validation
- Quality scoring rubric (1-10 scale)
**Used by:** Copywriter (drafting), Editor (quality review)

---

### 4. pattern-selection.md
**Purpose:** Decision tree and logic
**Contains:**
- Decision tree starting with audience assessment
- Detailed pattern selection guide (when to use each)
- Audience state assessment (defensiveness, relationship, content type)
- Pattern comparison matrix
- Pattern selection checklist
**Used by:** Architect (pattern recommendation), Analyst (audience signals)

---

### 5. cta-placement.md
**Purpose:** Subscribe CTA strategy
**Contains:**
- Core principle (after identity, before agency)
- Psychological mechanism (why it works)
- Pattern-specific CTA placement
- CTA copy and context
- Placement validation checklist
- Bridge Strategy integration
**Used by:** Architect (placement decision), Copywriter (marking CTA), Editor (validation)

---

### 6. voice-constants.md
**Purpose:** K2M voice rules (all tones)
**Contains:**
- Four tone options
- K2M voice constants (apply to all tones)
- K2M "avoid" list (listicles, generic advice, rescue, etc.)
- Voice calibration checklist
- Voice quality scoring
- Voice examples
**Used by:** Copywriter (drafting), Editor (voice consistency check)

---

### 7. quality-gates.md
**Purpose:** Pass/fail criteria
**Contains:**
- Two-tier quality system (must-pass vs should-pass)
- 7 must-pass gates (blockers)
- 5 should-pass gates (warnings)
- Quality gate workflow
- Quality decision tree
**Used by:** Editor (quality review), Copywriter (self-check during drafting)

---

### 8. checkpoint-philosophy.md
**Purpose:** Human judgment philosophy
**Contains:**
- Core insight (checkpoints are the point, not agents)
- Collaboration equation (Your insights + My execution)
- Problem: Why AI writing fails (decisions made without you)
- Solution: 4 checkpoints with questions and timing
- Boiling phase sacredness alignment
**Used by:** All agents (honoring checkpoints), Creator (understanding value)

---

## HOW TO USE THIS KNOWLEDGE BASE

### For Agent Wrapping

When wrapping agents, reference these files instead of duplicating content:

**DO THIS:**
```markdown
## Required Knowledge
See {knowledge}/acm-framework.md for complete 7-module framework
See {knowledge}/module-execution.md for tactics and warnings
See {knowledge}/voice-constants.md for K2M voice rules
```

**NOT THIS:**
```markdown
## The 7 ACM Modules
Module 1: Destabilize... [duplicate 200 lines]
Module 2: Expose... [duplicate 200 lines]
[etc]
```

**Benefits:**
- ✅ Update once, all agents benefit
- ✅ Prevents divergence if framework evolves
- ✅ Keeps agent files concise
- ✅ Single source of truth

---

### For Framework Updates

When K2M framework evolves:

1. Update the relevant knowledge base file
2. Increment VERSION number at top of file
3. All agents automatically use updated version

**Example:**
```markdown
# Juggling Patterns - Complete Reference

**VERSION:** 1.1  # Updated from 1.0
**CHANGE:** Added "Agency First" pattern variation
**LAST UPDATED:** 2026-02-15
```

---

### For Validation

When validating agents:

1. Check agent references correct knowledge files
2. Verify agent doesn't duplicate knowledge content
3. Test agent loads and references knowledge correctly

**Validation script:**
```bash
# Check agents reference knowledge, don't duplicate
grep -r "See {knowledge}/" _bmad/k2m-agents/
grep -r "## The 7 ACM Modules" _bmad/k2m-agents/  # Should return nothing
```

---

## VERSION TRACKING

Each knowledge file has version metadata at the top:

```markdown
**VERSION:** X.Y
**SOURCE:** [original source document]
**LAST UPDATED:** YYYY-MM-DD
```

**Versioning scheme:**
- **X.0** = Initial version
- **X.1** = Minor updates (clarifications, examples)
- **X.2** = Moderate updates (new tactics, refined guidance)
- **2.0** = Major framework changes (new modules, pattern changes)

---

## INTEGRATION WITH AGENTS

### Agent Files Reference Knowledge

**Example: Architect Agent**

```markdown
## Required Knowledge

Before executing, ensure access to:
- {knowledge}/acm-framework.md (complete framework)
- {knowledge}/juggling-patterns.md (pattern options)
- {knowledge}/pattern-selection.md (decision tree)
- {knowledge}/cta-placement.md (placement strategy)

## Pattern Selection Logic

Use {knowledge}/pattern-selection.md decision tree to recommend pattern based on:
- Audience defensiveness level
- Audience relationship to topic
- Content type
```

---

## QUALITY ASSURANCE

### Knowledge Base Health Checks

**Before wrapping agents:**
- [ ] All 9 knowledge files created and validated
- [ ] Each file has VERSION metadata
- [ ] Each file has SOURCE attribution
- [ ] Cross-references between files work
- [ ] No duplication of content across files

**After wrapping agents:**
- [ ] All agents reference knowledge files correctly
- [ ] No agents duplicate knowledge content
- [ ] Agents work when knowledge files are present
- [ ] Test run passes with all agents

---

## TROUBLESHOOTING

**Problem:** Agent can't find knowledge file
**Solution:** Check agent references correct path: `{knowledge}/filename.md`

**Problem:** Framework inconsistency between agents
**Solution:** Update knowledge base file, all agents benefit automatically

**Problem:** Which knowledge file do I update?
**Solution:** Use QUICK NAVIGATION section above to find correct file

**Problem:** Knowledge file getting too large
**Solution:** Split into sub-files (e.g., `module-execution-m1.md`, `module-execution-m2.md`)

---

## FUTURE EXPANSION

This knowledge base will expand as K2M module grows:

**Planned additions:**
- `repurposing-framework.md` - Social media repurposing tactics
- `bridge-strategy.md` - Business application integration
- `psychological-foundations.md` - Cognitive mechanisms per module
- `framework-extraction.md` - How to identify and name frameworks
- `visual-strategy.md` - Visual element selection and placement

**Principle:** If it's reusable across agents/workflows, it belongs in knowledge base.

---

## SUMMARY

**This knowledge base is the single source of truth for K2M framework.**

- All agents reference it
- All workflows use it
- Updates propagate automatically
- Prevents divergence and drift
- Maintains semantic consistency

**Rule:** If framework content lives in multiple places, move it to knowledge base and reference it instead.

---

*For questions about knowledge base structure or usage, refer to BMAD Module Builder documentation or contact module architect.*

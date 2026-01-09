# Quality Gates - Complete Reference

**VERSION:** 1.0
**SOURCE:** k2m_workflow_config.json, editor agent specification
**LAST UPDATED:** 2026-01-08

---

## Overview

Quality gates are **non-negotiable pass/fail criteria** that separate K2M content from generic writing. These are the standards that must be met before publication.

---

## TWO-TIER QUALITY SYSTEM

### Must-Pass Gates (BLOCKERS)
**If failed:** Content cannot publish. Must fix before proceeding.

### Should-Pass Gates (WARNINGS)
**If failed:** Content should be improved. Publishable but not K2M-standard.

---

## MUST-PASS GATES (Blockers)

### 1. All 7 ACM Modules Present

**Gate:** Every piece must contain all 7 modules in the selected pattern order.

**Check:**
- [ ] Module 1: Destabilize executed
- [ ] Module 2: Expose executed
- [ ] Module 3: Pressure executed
- [ ] Module 4: Reframe executed
- [ ] Module 5: Identity touched
- [ ] Module 6: Agency returned
- [ ] Module 7: Unresolved exit executed

**If ANY module missing:** **FAIL BLOCKER** — Cannot publish

---

### 2. Three Non-Negotiables Met

**Gate:** The three ACM invariants MUST be satisfied:

**Check:**
- [ ] Frame interrupt (M1) comes BEFORE explanation (M2+)
- [ ] Agency transfer (M6) comes AFTER identity pressure (M5)
- [ ] Unresolved exit (M7) is LAST (no closure near end)

**If ANY non-negotiable violated:** **FAIL BLOCKER** — Cannot publish

---

### 3. Litmus Test Passed

**Gate:** Reader response must be "I can't unsee what you pointed at," NOT "That was interesting."

**Self-Test:**
After reading, would target reader say:
- ✓ "I don't agree, but I can't unsee what you pointed at" → **PASS**
- ✗ "That was interesting" (and move on unchanged) → **FAIL BLOCKER**

**If litmus test failed:** **FAIL BLOCKER** — Piece creates no cognitive shift

---

### 4. Zero Rescue Violations

**Gate:** No step-by-step solutions, action plans, or escape hatches provided.

**Check:**
- [ ] No "5 steps to X" listicles
- [ ] No "here's what to do next" sections
- [ ] No frameworks that let reader externalize responsibility
- [ ] No how-to instructions before Module 6

**If ANY rescue provided:** **FAIL BLOCKER** — Undermines agency module

---

### 5. Zero Closure Violations

**Gate:** No tidy conclusions, summaries, or closure before final line.

**Check:**
- [ ] No "In conclusion..." anywhere
- [ ] No "To sum up..." sections
- [ ] No wrapping up or tying bows
- [ ] Final line leaves tension active

**If ANY closure provided:** **FAIL BLOCKER** — Kills after-effect

---

### 6. Pressure With Dignity Maintained

**Gate:** No tone violations that create defensiveness.

**Check:**
- [ ] No moral superiority (no "enlightened leaders know better")
- [ ] No emotional bullying (no fear-mongering or catastrophizing)
- [ ] No accusation (tone is observational, not judgmental)

**If ANY tone violation:** **FAIL BLOCKER** — Triggers defensiveness, piece fails

---

### 7. CTA Placement Correct

**Gate:** Subscribe CTA must appear after Module 5, before Module 6.

**Check:**
- [ ] CTA appears after identity pressure
- [ ] CTA appears before agency return
- [ ] Pattern-specific timing considered (early M5 vs delayed M5)

**If CTA misplaced:** **FAIL BLOCKER** — Disrupts psychological flow

---

## SHOULD-PASS GATES (Warnings)

### 1. Module Quality Scores (7+ Average)

**Gate:** Each module should score 7+ on 10-point quality scale.

**Scoring Rubric:**

| Module | 7-8 (Strong) | 9-10 (Excellent) | <7 (Weak) |
|--------|--------------|------------------|-----------|
| M1 | Noticeable crack | "Wait, what?" moment | Fails to disrupt |
| M2 | Recognizable pattern | "That's me" without shame | Generic or accusatory |
| M3 | Discomfort felt | Inevitable weight | Cost too weak or dramatic |
| M4 | Dissolves question | Can't go back to old frame | Just another perspective |
| M5 | Personal implication | Identity shifted | Too early/late or generic |
| M6 | Clear responsibility | Weight sticks, no escape | Ambiguous or provides rescue |
| M7 | Open loop | Echoes for days | Closure provided |

**If any module <7:** **SHOULD FIX** — Weakens overall piece

---

### 2. Voice Consistency Score (8+)

**Gate:** Piece should score 8+ on voice adherence.

**Check:**
- [ ] Second person used for intimacy
- [ ] Short paragraphs for pacing
- [ ] Strategic single-sentence paragraphs (2-4 per piece)
- [ ] Questions earn their place
- [ ] Specific over vague throughout
- [ ] No emoji
- [ ] No excessive formatting
- [ ] Confident without arrogant

**If voice score <8:** **SHOULD FIX** — Doesn't sound like K2M

---

### 3. Framework Clarity

**Gate:** Any frameworks presented should be clear and actionable.

**Check (for each framework):**
- [ ] Core insight stated clearly
- [ ] Equation or model visible
- [ ] Application obvious to reader
- [ ] Trap/consequence of ignoring explained

**If framework unclear:** **SHOULD FIX** — Reader can't extract value

---

### 4. Pull Quote Candidates

**Gate:** 2-3 lines strong enough to be visual pull quotes.

**Check:**
- [ ] At least 2 quotable moments identified
- [ ] Lines are memorable and shareable
- [ ] Placement suggestions make sense

**If no pull quotes:** **SHOULD IMPROVE** — Missed social amplification

---

### 5. Title/Subtitle Quality

**Gate:** Title and subtitle should create cognitive tension.

**Check:**
- [ ] Title disrupts default frame
- [ ] Subtitle deepens the hook
- [ ] Combined effect is intriguing
- [ ] Not generic or clickbait

**If title weak:** **SHOULD IMPROVE** — Weak entry reduces readership

---

## QUALITY GATE WORKFLOW

### Editor Agent Process

```
1. Check Must-Pass Gates (Blockers)
   ├─ All 7 modules present?
   ├─ Three non-negotiables met?
   ├─ Litmus test passed?
   ├─ Zero rescue violations?
   ├─ Zero closure violations?
   ├─ Pressure with dignity maintained?
   └─ CTA placement correct?
   │
   IF ANY FAIL → BLOCKER → Must fix before publication
   │
2. Check Should-Pass Gates (Warnings)
   ├─ Module quality scores (7+ average?)
   ├─ Voice consistency (8+?)
   ├─ Framework clarity?
   ├─ Pull quote candidates?
   └─ Title/subtitle quality?
   │
   IF ANY FAIL → SHOULD FIX → Improves quality but not blocking
   │
3. Final Verdict
   ├─ All Must-Pass = YES
   ├─ Most Should-Pass = YES
   └─ Ready for publication: YES
```

---

## QUALITY DECISION TREE

```
START: Editor reviews draft
│
├─ MUST-PASS: All 7 modules present?
│  ├─ NO → BLOCKER → Fix missing modules
│  └─ YES → Continue
│
├─ MUST-PASS: Three non-negotiables met?
│  ├─ NO → BLOCKER → Fix violations
│  └─ YES → Continue
│
├─ MUST-PASS: Litmus test passed?
│  ├─ NO → BLOCKER → Piece creates no shift
│  └─ YES → Continue
│
├─ MUST-PASS: Zero rescue/closure violations?
│  ├─ NO → BLOCKER → Remove escape hatches
│  └─ YES → Continue
│
├─ MUST-PASS: Pressure with dignity?
│  ├─ NO → BLOCKER → Fix tone violations
│  └─ YES → Continue
│
├─ SHOULD-PASS: Module quality 7+?
│  ├─ NO → Should improve weak modules
│  └─ YES → Continue
│
├─ SHOULD-PASS: Voice consistency 8+?
│  ├─ NO → Should fix voice drift
│  └─ YES → Continue
│
└─ FINAL VERDICT: Ready for publication?
   └─ YES → Publish
```

---

## INTEGRATION WITH AGENTS

**Editor Agent:** Uses this file as quality gate checklist. Scores each module, flags violations, provides MUST FIX vs SHOULD FIX recommendations.

**Architect Agent:** Considers quality gates during structure planning. Designs pieces that can pass gates.

**Copywriter Agent:** Self-checks against quality gates during drafting. Flags potential issues early.

---

## QUALITY GATE SUMMARY

**MUST-PASS (7 Gates):**
1. All 7 ACM modules present
2. Three non-negotiables met
3. Litmus test passed
4. Zero rescue violations
5. Zero closure violations
6. Pressure with dignity maintained
7. CTA placement correct

**SHOULD-PASS (5 Gates):**
1. Module quality scores 7+
2. Voice consistency 8+
3. Framework clarity
4. Pull quote candidates
5. Title/subtitle quality

---

*Quality gates are what separates K2M content from generic writing. They're not optional—they're the definition of K2M standard. Every piece must clear the must-pass gates. Every piece should clear the should-pass gates.*

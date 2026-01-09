# Module Dependency Analysis

## Current State: NOT Standalone ❌

Your module has **ONE CRITICAL DEPENDENCY**:

### Knowledge Base Files

The module requires these knowledge files to exist in the parent project:

```
{project-root}/_bmad/knowledge/
├── acm-framework.md
├── module-execution.md
├── juggling-patterns.md
├── voice-constants.md
├── quality-gates.md
├── pattern-selection.md
├── checkpoint-philosophy.md
└── cta-placement.md
```

**Current setup:**
- Module has a **symlink**: `knowledge -> ../../../knowledge`
- Config references: `{project-root}/_bmad/knowledge`
- Agents expect: `{knowledge}/acm-framework.md` etc.

---

## What This Means

### ✅ For YOU (in your main project)
- Works perfectly
- Knowledge files already exist at `_bmad/knowledge/`
- Symlink works correctly

### ❌ For OTHERS (installing in fresh project)
- **MODULE WON'T WORK** without knowledge files
- They need to manually copy knowledge files
- Or you need to make module truly standalone

---

## Two Solutions

### Option 1: Make Module Standalone (Recommended)

**Copy knowledge files INTO the module:**

```bash
cd _bmad/modules/conscious-founder
rm knowledge  # Remove symlink
mkdir knowledge
cp ../../../knowledge/*.md knowledge/
git add knowledge/
git commit -m "feat: include knowledge base in module for standalone distribution"
git push
```

**Pros:**
- ✅ Module is truly standalone
- ✅ Others can install and it just works
- ✅ No external dependencies

**Cons:**
- ❌ Knowledge files duplicated (in module + main project)
- ❌ Update knowledge in two places

---

### Option 2: Keep as Dependency (Current)

**Document that knowledge files are required:**

Add to README.md:

```markdown
## Requirements

This module requires knowledge files. Before installing:

1. Ensure BMAD is installed
2. Copy knowledge files to project:
   ```bash
   mkdir -p _bmad/knowledge
   cp conscious-founder-bmad-module/knowledge/*.md _bmad/knowledge/
   ```
```

**Pros:**
- ✅ No duplication
- ✅ Knowledge files stay in one place

**Cons:**
- ❌ Not truly standalone
- ❌ Extra installation step for users
- ❌ Symlink might break

---

## Option 3: Hybrid (Best of Both)

**Include knowledge in module, but use submodule:**

```bash
# Convert knowledge to its own git repo
cd _bmad/knowledge
git init
git add .
git commit -m "Initial knowledge base"
git push origin main

# In module, use git submodule instead of symlink
cd _bmad/modules/conscious-founder
git rm knowledge
git submodule add https://github.com/Trevorvaizel/k2m-knowledge-base.git knowledge
```

**Pros:**
- ✅ Module is standalone
- ✅ Knowledge base can be updated independently
- ✅ Others can contribute to knowledge

**Cons:**
- ❌ More complex setup
- ❌ Requires understanding git submodules

---

## My Recommendation

**Use Option 1: Make Module Standalone**

For a first version, just copy the knowledge files into the module. It's simple and works.

When you want to improve it later, you can:
1. Extract knowledge to separate repo
2. Use git submodule
3. Keep versioning separate

---

## Quick Fix: Make Standalone Now

```bash
cd _bmad/modules/conscious-founder

# Remove symlink
rm knowledge

# Copy knowledge files
mkdir knowledge
cp ../../../knowledge/*.md knowledge/

# Update config to use module's knowledge
# (Already correct: agents reference {knowledge} which resolves to module's knowledge/)

# Commit
git add knowledge/
git commit -m "feat: include knowledge base for standalone distribution"
git push origin main

# Update setup.sh to remove symlink creation
# (The setup script already handles both cases)
```

After this, your module is **TRULY STANDALONE** and can be installed anywhere! ✅

---

## Summary

**Current state:** Module depends on external knowledge files
**Recommended fix:** Copy knowledge into module (Option 1)
**Result:** Module is 100% standalone and portable

Want me to implement Option 1 for you?

# How to Improve Your Module

## The Right Way ✅

### Step 1: Edit in Your MAIN Project

```bash
# You're here:
cd /mnt/c/Users/OMEN/Documents/K2M/conscious-founder

# Edit module files:
_bmad/modules/conscious-founder/agents/analyst.md
_bmad/modules/conscious-founder/workflows/transform.yaml
_bmad/modules/conscious-founder/knowledge/acm-framework.md
```

**Why here?**
- ✅ BMAD is already installed
- ✅ Your whole project context is available
- ✅ You can test immediately with /bmad:k2m-analyst
- ✅ All dependencies are in place

---

### Step 2: Test in Your Main Project

```bash
# Still in your main project
cd _bmad/modules/conscious-founder

# Verify installation
./verify-install.sh

# Test the changes
/bmad:k2m-analyst
# or
/bmad:k2m-architect
```

**Why here?**
- ✅ Testing in actual environment
- ✅ BMAD framework available
- ✅ Can verify everything works

---

### Step 3: Commit to Module's SEPARATE Git Repo

```bash
# Still in your main project, but now:
cd _bmad/modules/conscious-founder

# This folder has its OWN git repo!
git status  # Shows module's files, not main project's

# Commit changes
git add agents/analyst.md
git commit -m "feat: improved analyst agent"
git push origin main
```

**Important:**
- This commits to the MODULE repo only
- Does NOT affect your main project repo
- Pushes to: https://github.com/Trevorvaizel/conscious-founder-bmad-module.git

---

### Step 4: Others Get Updates

```bash
# In THEIR projects
cd _bmad/modules/conscious-founder
git pull  # Gets your improvements!
```

---

## Visual: Your File System Structure

```
/mnt/c/.../conscious-founder/                    ← Your MAIN PROJECT
│
├── .git/                                         ← Main project's git repo
│   (Points to: github.com/Trevorvaizel/conscious-founder)
│
├── _bmad/
│   └── modules/
│       └── conscious-founder/                    ← MODULE FOLDER
│           │
│           ├── .git/                             ← MODULE's git repo (SEPARATE!)
│           │   (Points to: github.com/.../conscious-founder-bmad-module)
│           │
│           ├── agents/
│           ├── workflows/
│           ├── knowledge/
│           └── config files
│
└── _bmad-output/
```

**Key Point:** The `conscious-founder` folder contains TWO git repos:
1. Main project repo (in root)
2. Module repo (in `_bmad/modules/conscious-founder/`)

---

## Example: Improving the Analyst Agent

```bash
# 1. Edit the file (in your main project)
cd /mnt/c/Users/OMEN/Documents/K2M/conscious-founder
nano _bmad/modules/conscious-founder/agents/analyst.md
# Make your improvements...

# 2. Test it (still in main project)
cd _bmad/modules/conscious-founder
./verify-install.sh
/bmad:k2m-analyst
# Test the new functionality...

# 3. Commit to MODULE repo (nested git repo)
git status  # Shows only module files
git add agents/analyst.md
git commit -m "feat: add pattern detection to analyst"
git push origin main  # Pushes to module's GitHub repo

# ✅ Done! Module improved and distributed
```

---

## What NOT To Do ❌

```bash
# DON'T do this:
cd /some/other/location
git clone https://github.com/Trevorvaizel/conscious-founder-bmad-module.git
cd conscious-founder-bmad-module
# Install BMAD here...
# Edit files...

# Why wrong?
- ❌ Creating duplicate BMAD installation
- ❌ Testing in isolated environment
- ❌ Hard to sync back to main project
- ❌ Duplicate knowledge, dependencies, etc.
```

---

## Summary

**Your development workflow:**

1. **Edit** in: `/mnt/c/.../conscious-founder/_bmad/modules/conscious-founder/`
2. **Test** in: Your main project (BMAD already installed)
3. **Commit** to: Module's nested git repo
4. **Push** to: Module's GitHub repo

**Key concept:**
- Main project = Where you work and test
- Module repo = Where you commit module changes
- These are TWO git repos in ONE file system

**The module folder is part of your main project, but has its own git repo for distribution!**

# Conscious-Founder BMAD Module - Distribution Guide

## Two Repo Setup

You now have **two separate GitHub repositories**:

### 1. Main Project Repo
**URL:** https://github.com/Trevorvaizel/conscious-founder
**Contains:** Your complete K2M newsletter system
- Source documents
- Agent prompts
- BMAD framework integration
- PRD and documentation
- **Everything about your project**

### 2. Distributable Module Repo (This One)
**URL:** https://github.com/Trevorvaizel/conscious-founder-bmad-module (create this)
**Contains:** ONLY the BMAD module
- 4 agents (Analyst, Architect, Copywriter, Editor)
- 4 workflows (Inject, Transform, Return, Repurpose)
- Installation scripts
- Module configuration

**Purpose:** Others can install this in THEIR BMAD projects

---

## How to Set Up the Module Repo

### Step 1: Create New GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `conscious-founder-bmad-module`
3. Description: `BMAD module wrapping K2M newsletter workflow with zero semantic loss`
4. **DO NOT** initialize with README (we already have one)
5. Click "Create repository"

### Step 2: Push Module to GitHub

```bash
# You're already in the module directory
# Add GitHub remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/conscious-founder-bmad-module.git

# Push to GitHub
git push -u origin main
```

### Step 3: Verify

Visit: `https://github.com/YOUR_USERNAME/conscious-founder-bmad-module`

You should see ONLY the module files, not your entire project.

---

## How Others Will Use Your Module

### Installation (for ANY BMAD project)

```bash
# In any BMAD project (after installing BMAD)
cd _bmad/modules
git clone https://github.com/YOUR_USERNAME/conscious-founder-bmad-module.git
cd conscious-founder-bmad-module
./setup.sh
```

### They Get

- ✅ 4 K2M agents ready to invoke
- ✅ 4 workflows ready to use
- ✅ Knowledge base integration
- ✅ Zero setup beyond running setup.sh

---

## Your Development Workflow

### When You Want to Improve the Module

1. **Edit files in your main project:**
   ```bash
   # In your main project
   cd _bmad/modules/conscious-founder
   # Edit agents, workflows, etc.
   ```

2. **Test changes:**
   ```bash
   ./verify-install.sh
   /bmad:k2m-analyst  # Test the changes
   ```

3. **Update the module repo:**
   ```bash
   cd _bmad/modules/conscious-founder
   git add .
   git commit -m "feat: improved X, added Y"
   git push
   ```

4. **Others get updates:**
   ```bash
   # In their projects
   cd _bmad/modules/conscious-founder
   git pull
   ```

### When You Want to Update Your Main Project

Normal git workflow in your main project repo:
```bash
# In your main project root
git add .
git commit -m "update: improved K2M system"
git push
```

---

## Version Management

### Release Strategy

When you make significant improvements to the module:

```bash
# In module directory
cd _bmad/modules/conscious-founder

# Tag version
git tag v1.1.0

# Push tag
git push origin v1.1.0

# Create GitHub release with notes
```

### Others Install Specific Version

```bash
git clone --branch v1.1.0 https://github.com/YOUR_USERNAME/conscious-founder-bmad-module.git
```

---

## File Organization

```
Your GitHub:
├── Trevorvaizel/conscious-founder           # Main project
│   ├── k2m-newsletter foundation/
│   ├── k2m-refined-prompts/
│   ├── _bmad/
│   │   └── modules/
│   │       └── conscious-founder/           # Module source (development)
│   └── _bmad-output/
│
└── Trevorvaizel/conscious-founder-bmad-module  # Module distribution
    ├── agents/
    ├── workflows/
    ├── config.yaml
    ├── setup.sh
    └── README.md
```

---

## Benefits of Two Repos

✅ **Separation of concerns:** Project code vs. distributable module
✅ **Independent versioning:** Module can evolve separately from project
✅ **Clean distribution:** Others get ONLY the module, not your entire project
✅ **Reusability:** Module can be installed in ANY BMAD project
✅ **Maintenance:** Update module once, all projects benefit

---

## Example Use Cases

### Use Case 1: You Improve the Module

```bash
# In your main project
cd _bmad/modules/conscious-founder/agents
# Edit analyst.md to add new feature
cd ..
git add agents/analyst.md
git commit -m "feat: add new analysis feature to analyst"
git push

# In someone else's project using your module
cd _bmad/modules/conscious-founder
git pull
# They now have your improvement!
```

### Use Case 2: Someone Installs in Fresh Project

```bash
# Fresh BMAD installation
cd ~/projects/my-newsletter-system
# Install BMAD first...
# Then install your module:
cd _bmad/modules
git clone https://github.com/Trevorvaizel/conscious-founder-bmad-module.git
cd conscious-founder-bmad-module
./setup.sh

# Ready to use!
/bmad:k2m-analyst
```

---

## Summary

**You have TWO repos for TWO purposes:**

1. **Main Project (conscious-founder):**
   - Your complete K2M system
   - All your documents, prompts, outputs
   - Everything specific to your workflow

2. **Module Distribution (conscious-founder-bmad-module):**
   - Just the BMAD module
   - Others can install in THEIR projects
   - Maintained separately
   - Versioned independently

**This is the RIGHT way to distribute a BMAD module!** ✅

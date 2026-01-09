# Dual-Repo Publishing Script

## Quick Start

After making changes to EITHER your main project OR the module (or both):

```bash
cd _bmad/modules/conscious-founder
./publish.sh "your commit message here"
```

That's it! The script will:
1. ✅ Check for changes in both repos
2. ✅ Show you what will be committed
3. ✅ Ask for confirmation
4. ✅ Commit to main project repo (if changes)
5. ✅ Commit to module repo (if changes)
6. ✅ Push both to GitHub

---

## Examples

### Example 1: Module Improvement

```bash
# Edit module files
cd _bmad/modules/conscious-founder
nano agents/analyst.md

# Test it
/bmad:k2m-analyst

# Publish both repos
./publish.sh "feat: improved analyst pattern detection"

# Result:
# - Main project: Skipped (no changes)
# - Module: Committed and pushed
```

---

### Example 2: Both Project and Module Changes

```bash
# Edit main project files
nano SPRINT_STATUS.md

# Edit module files
nano _bmad/modules/conscious-founder/agents/analyst.md

# Publish both
cd _bmad/modules/conscious-founder
./publish.sh "feat: improved analyst and updated sprint status"

# Result:
# - Main project: Committed sprint status
# - Module: Committed analyst improvements
```

---

### Example 3: Documentation Updates

```bash
# Update docs
nano _bmad/modules/conscious-founder/README.md
nano _bmad/modules/conscious-founder/INSTALL.md

# Publish
./publish.sh "docs: improved installation guide"

# Result:
# - Module: Documentation updated
```

---

## What Gets Committed Where

### Main Project Repo Gets:
- Changes outside `_bmad/modules/conscious-founder/`
- Examples:
  - `SPRINT_STATUS.md`
  - `README.md` (project root)
  - `k2m-newsletter foundation/`
  - `k2m-refined-prompts/`

### Module Repo Gets:
- Changes inside `_bmad/modules/conscious-founder/`
- Examples:
  - `agents/analyst.md`
  - `workflows/transform.yaml`
  - `knowledge/acm-framework.md`
  - `config.yaml`
  - `setup.sh`

---

## Script Features

✅ **Smart detection** - Only commits repos that have changes
✅ **Preview** - Shows you what will be committed before asking confirmation
✅ **Single command** - No need to cd between directories
✅ **Same message** - Uses same commit message for both repos
✅ **Safe** - Asks for confirmation before pushing

---

## Troubleshooting

### "No changes to commit"

Means you haven't modified any files. Make changes first!

### "Authentication failed"

You need a GitHub Personal Access Token. See GITHUB_AUTH_GUIDE.md

### "Cannot push to main"

Check your internet connection and GitHub token.

---

## Advanced Usage

### Force Message with Spaces

```bash
./publish.sh "feat: add new feature with detailed description"
```

### Multi-line Message

```bash
./publish.sh "feat: add new feature

- Added X capability
- Improved Y performance
- Fixed Z bug"
```

---

## Summary

**Before script:**
```bash
# Had to do this:
cd /path/to/main/project
git add .
git commit -m "message"
git push

cd _bmad/modules/conscious-founder
git add .
git commit -m "message"
git push
```

**After script:**
```bash
# Just this:
cd _bmad/modules/conscious-founder
./publish.sh "message"
```

**Much simpler!** 🎉

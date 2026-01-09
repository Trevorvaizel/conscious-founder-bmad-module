# Quick Start: Dual-Repo Publishing

## The Easy Way! 🚀

After making any changes (to main project OR module):

```bash
cd _bmad/modules/conscious-founder
./publish.sh "your commit message"
```

## Examples

### Improve the Module
```bash
# Edit agent
nano agents/analyst.md

# Test it
/bmad:k2m-analyst

# Publish
./publish.sh "feat: improved analyst pattern detection"

# ✅ Done! Module updated on GitHub
```

### Update Both
```bash
# Edit main project
nano SPRINT_STATUS.md

# Edit module
nano agents/architect.md

# Publish both
./publish.sh "feat: updated sprint status and improved architect"

# ✅ Both repos updated!
```

## What the Script Does

1. ✅ Checks for changes in both repos
2. ✅ Shows you what will be committed
3. ✅ Asks for confirmation
4. ✅ Commits main project (if changes)
5. ✅ Commits module (if changes)
6. ✅ Pushes both to GitHub

## One Command vs Old Way

**Old way:**
```bash
cd /path/to/main
git add .
git commit -m "msg"
git push

cd _bmad/modules/conscious-founder
git add .
git commit -m "msg"
git push
```

**New way:**
```bash
cd _bmad/modules/conscious-founder
./publish.sh "msg"
```

**Much easier!** ✨

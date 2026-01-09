# Troubleshooting Guide - Conscious-Founder Module

**Purpose:** Solutions to common issues when installing, using, or extending the conscious-founder module.

---

## Installation Issues

### Problem: Setup Script Fails

**Symptoms:**
```bash
./setup.sh
# bash: ./setup.sh: Permission denied
```

**Solution:**
```bash
chmod +x setup.sh
./setup.sh
```

---

### Problem: "Module Not Found" Error

**Symptoms:**
```bash
/bmad:conscious-founder:transform
# Error: Module 'conscious-founder' not found
```

**Solutions:**

**1. Verify Installation:**
```bash
ls -la _bmad/modules/conscious-founder/
# Should show: agents/, workflows/, knowledge/, etc.
```

**2. Check Module Registration:**
```bash
cat _bmad/modules/conscious-founder/manifest.yaml
# Should contain module metadata
```

**3. Re-run Setup:**
```bash
cd _bmad/modules/conscious-founder
./setup.sh --force
```

---

### Problem: Config.yaml Not Found

**Symptoms:**
```bash
# Agent activation fails with:
Error: Cannot load {project-root}/_bmad/bmb/config.yaml
```

**Solutions:**

**1. Check Config Path:**
```bash
ls -la _bmad/bmb/config.yaml
# Must exist for BMAD to work
```

**2. Create Config If Missing:**
```bash
mkdir -p _bmad/bmb
cat > _bmad/bmb/config.yaml << 'EOF'
# BMB Core Configuration
user_name: YourName
communication_language: English
output_folder: "{project-root}/_bmad-output"
EOF
```

---

## Agent Issues

### Problem: Agent Won't Activate

**Symptoms:**
```bash
claude /k2m-analyst
# Error: Agent activation failed
```

**Solutions:**

**1. Check Agent File Syntax:**
```bash
# Verify YAML frontmatter
head -5 _bmad/modules/conscious-founder/agents/analyst.md
# Should show:
---
name: "K2M Analyst"
description: "..."
---
```

**2. Check XML Structure:**
```bash
# Verify XML tags are closed
grep -c "</agent>" _bmad/modules/conscious-founder/agents/analyst.md
# Should return: 1

grep -c "<activation" _bmad/modules/conscious-founder/agents/analyst.md
# Should return: 1

grep -c "</activation>" _bmad/modules/conscious-founder/agents/analyst.md
# Should return: 1
```

**3. Verify Agent ID:**
```bash
# Check agent ID matches filename
grep "agent id=" _bmad/modules/conscious-founder/agents/analyst.md
# Should be: id="k2m-analyst" (matches filename analyst.md)
```

---

### Problem: Agent Shows Menu But Doesn't Respond

**Symptoms:**
- Agent displays menu options
- Typing number or command does nothing
- Agent seems "stuck"

**Solutions:**

**1. Test Number Input:**
```bash
# Try simple number
echo "1" | claude /k2m-analyst
```

**2. Test Command Shortcut:**
```bash
# Try shortcut code
echo "AN" | claude /k2m-analyst
```

**3. Test Fuzzy Match:**
```bash
# Try full command name
echo "analyze" | claude /k2m-analyst
```

**4. Check Activation Step 7:**
Agent should have this logic:
```xml
<step n="7">On user input: Number → execute menu item[n] | Text → case-insensitive substring match</step>
```

---

### Problem: Agent Output Different from Original

**Symptoms:**
- Side-by-side comparison shows differences
- Agent behavior changed after wrapping

**Diagnosis:**

**1. Check for Accidental Summarization:**
```bash
# Search for consolidated or shortened sections
grep -n "## " agents/your-agent.md
# Verify all original sections present
```

**2. Check for Missing Content:**
```bash
# Compare line counts
wc -l original-agent.md wrapped-agent.md
# Wrapped should be longer (BMAD wrapper adds ~135 lines)
```

**3. Check Knowledge Base References:**
```bash
# Verify agent can access knowledge
grep "{knowledge}/" agents/your-agent.md
# All referenced files should exist in knowledge/
```

**Solution:**
- Revert to original wording
- Restore missing sections
- Put back removed warnings
- See `docs/CONVERSION_GUIDE.md` for proper conversion method

---

## Workflow Issues

### Problem: Workflow Won't Execute

**Symptoms:**
```bash
/bmad:conscious-founder:transform
# Error: Workflow not found
```

**Solutions:**

**1. Check Workflow File:**
```bash
ls -la _bmad/modules/conscious-founder/workflows/transform.yaml
# Should exist
```

**2. Check Workflow Syntax:**
```bash
# Verify YAML is valid
python3 -c "import yaml; yaml.safe_load(open('workflows/transform.yaml'))"
# Should return no errors
```

**3. Check Workflow Registration:**
```bash
# Verify setup registered workflow
grep -r "transform" _bmad/bmb/manifest.yaml
```

---

### Problem: Checkpoint Doesn't Pause

**Symptoms:**
- Workflow runs straight through
- No opportunity to provide input
- Checkpoint questions displayed but no pause

**Solutions:**

**1. Check Checkpoint Definition:**
```yaml
checkpoint:
  id: checkpoint_1
  name: Thesis & Direction
  wait_for_user: true  # <-- MUST be true
  prompt:
    - "Question 1?"
    - "Question 2?"
```

**2. Verify BMAD Version:**
```bash
# Checkpoints require BMAD v1.0+
claude --version
```

**3. Test Checkpoint Manually:**
```bash
# Run workflow and observe behavior
/bmad:conscious-founder:transform
# Should see "Waiting for user input..." at checkpoint
```

---

### Problem: State Not Persisting Between Workflows

**Symptoms:**
- Inject workflow saves emphasis
- Transform workflow doesn't load it
- "No saved emphasis found" message

**Solutions:**

**1. Check Output Paths:**
```yaml
# Inject workflow:
output:
  path: "{output}/emphasis/latest-emphasis.md"

# Transform workflow:
input:
  type: file
  path: "{output}/emphasis/latest-emphasis.md"
  optional: true
```

**2. Verify File Created:**
```bash
ls -la _bmad-output/emphasis/
# Should contain latest-emphasis.md
```

**3. Check File Permissions:**
```bash
# Verify file is readable
cat _bmad-output/emphasis/latest-emphasis.md
```

---

## Knowledge Base Issues

### Problem: Agent Can't Load Knowledge

**Symptoms:**
```
Error: Cannot load {knowledge}/acm-framework.md
```

**Solutions:**

**1. Check File Path Syntax:**
```markdown
## Required Knowledge
- **{knowledge}/acm-framework.md** - Correct
- **knowledge/acm-framework.md** - Wrong (missing braces)
- **_bmad/modules/conscious-founder/knowledge/acm-framework.md** - Wrong (hardcoded path)
```

**2. Verify File Exists:**
```bash
ls -la _bmad/modules/conscious-founder/knowledge/
# Should contain: acm-framework.md, juggling-patterns.md, etc.
```

**3. Check Agent Activation:**
Agent activation step 4 should load knowledge:
```xml
<step n="4">Load required knowledge files:
    - {knowledge}/acm-framework.md
    - DO NOT proceed until knowledge files are loaded
</step>
```

---

### Problem: Framework Updates Not Propagating

**Symptoms:**
- Updated knowledge file
- Agents still use old version
- Had to restart agent

**Solutions:**

**1. Verify Agent References Knowledge:**
```bash
grep "{knowledge}/" agents/your-agent.md
# Should show references
```

**2. Check Agent Loads Knowledge at Startup:**
```xml
<step n="4">Load required knowledge files:
    - {knowledge}/acm-framework.md
    - DO NOT proceed until knowledge files are loaded
</step>
```

**3. Test Reload:**
```bash
# Dismiss agent
echo "DA" | claude /your-agent

# Reactivate (should reload knowledge)
claude /your-agent
```

**Note:** Some BMAD versions cache knowledge. If updates don't appear, restart BMAD session.

---

## Performance Issues

### Problem: Agent Invocation Slow (> 2 seconds)

**Symptoms:**
- Agent takes 5+ seconds to activate
- Noticeable delay before menu displays

**Solutions:**

**1. Check Knowledge File Size:**
```bash
du -h knowledge/*.md
# Large files (>1MB) slow down loading
```

**2. Optimize Knowledge Loading:**
- Only load essential knowledge at activation
- Lazy-load reference knowledge during task execution

**3. Check System Resources:**
```bash
# Check CPU/memory usage
top | grep claude
```

---

### Problem: Workflow Execution Slow

**Symptoms:**
- Transform workflow takes much longer than expected
- Each agent invocation seems delayed

**Solutions:**

**1. Check Model Settings:**
```yaml
# Verify using appropriate model
# Fast models: claude-3-haiku
# Balanced models: claude-3-5-sonnet
# Quality models: claude-3-opus
```

**2. Check Token Usage:**
```bash
# Monitor workflow tokens
/bmad:conscious-founder:transform --verbose
```

**3. Optimize Context:**
- Trim large transcripts if possible
- Use focused prompts
- Cache intermediate results

---

## Integration Issues

### Problem: Slash Commands Not Registered

**Symptoms:**
```bash
/bmad:conscious-founder:inject
# Error: Unknown command
```

**Solutions:**

**1. Check Workflow Registration:**
```bash
# Verify setup registered workflows
./setup.sh
```

**2. Check BMAD CLI:**
```bash
# Verify BMAD CLI is available
which bmad
```

**3. Test Direct Workflow Execution:**
```bash
# Try running workflow file directly
claude _bmad/modules/conscious-founder/workflows/inject.yaml
```

---

### Problem: Git Submodule Issues

**Symptoms:**
```bash
cd _bmad/modules/conscious-founder
#fatal: not a git repository
```

**Solutions:**

**1. Initialize Submodule:**
```bash
cd _bmad/modules
git submodule add https://github.com/your-repo/conscious-founder.git conscious-founder
```

**2. Update Submodule:**
```bash
git submodule update --init --recursive
```

**3. Clone as Submodule:**
```bash
git clone https://github.com/your-repo/conscious-founder.git _bmad/modules/conscious-founder
```

---

## Validation Issues

### Problem: Side-by-Side Test Fails

**Symptoms:**
```bash
diff baseline.md wrapped.md
# Shows many differences
```

**Solutions:**

**1. Categorize Differences:**
- **Formatting differences?** May be acceptable (BMAD adds headers)
- **Content differences?** Not acceptable - semantic loss detected
- **Missing sections?** Not acceptable - content dropped

**2. Investigate Content Changes:**
```bash
# See what changed
sdiff baseline.md wrapped.md
```

**3. Revert to Original:**
```bash
# Copy original content again
cat original-agent.md >> wrapped-agent.md
```

**4. See Conversion Guide:**
Reference `docs/CONVERSION_GUIDE.md` for proper conversion method.

---

## Debugging Tips

### Enable Verbose Mode

```bash
# Run workflows with verbose output
/bmad:conscious-founder:transform --verbose
```

### Check Agent Logs

```bash
# Agent activation may create logs
ls -la ~/.bmad/logs/
```

### Test Components Individually

```bash
# Test each agent separately
claude /k2m-analyst
claude /k2m-architect
claude /k2m-copywriter
claude /k2m-editor
```

### Verify File Permissions

```bash
# Make sure scripts are executable
chmod +x setup.sh uninstall.sh verify-install.sh
```

### Reset and Reinstall

```bash
# Clean slate
cd _bmad/modules/conscious-founder
./uninstall.sh
./setup.sh
./verify-install.sh
```

---

## Getting Help

### Check Documentation

- `README.md` - Overview and quick start
- `docs/CONVERSION_GUIDE.md` - How to wrap agents
- `docs/TESTING_CHECKLIST.md` - Verification procedures
- `docs/TUTORIAL.md` - Learn by doing
- `docs/PATTERNS.md` - Reusable patterns

### Run Verification

```bash
./verify-install.sh
# Tests all components and reports issues
```

### Check Examples

- `agents/` - Working agent examples
- `workflows/` - Working workflow examples
- `knowledge/` - Framework examples

### Community

- GitHub Issues: Report bugs
- Documentation: Improve guides
- Patterns: Share what works

---

## Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| `Agent not found` | Not installed or wrong path | Run `./setup.sh` |
| `Cannot load config.yaml` | Missing BMAD config | Create `_bmad/bmb/config.yaml` |
| `Knowledge file not found` | Wrong path syntax | Use `{knowledge}/file.md` |
| `Workflow failed` | YAML syntax error | Validate YAML with linter |
| `Checkpoint not pausing` | Missing `wait_for_user: true` | Add to checkpoint definition |
| `Semantic drift detected` | Content changed during conversion | Revert to original wording |

---

## Prevention

### Best Practices

1. **Always Test After Changes**
   - Run side-by-side comparison
   - Verify agent behavior
   - Test workflow execution

2. **Use Version Control**
   - Commit working versions
   - Tag releases
   - Easy rollback if needed

3. **Document Customizations**
   - Note what you changed
   - Why you changed it
   - How to verify it works

4. **Backup Before Updates**
   ```bash
   cp -r _bmad/modules/conscious-founder _bmad/modules/conscious-founder.backup
   ```

### Regular Maintenance

```bash
# Monthly checks
./verify-install.sh
git pull origin main  # if using git
```

---

*This guide covers the most common issues. If you encounter something not documented here, please check the main documentation or open a GitHub issue.*

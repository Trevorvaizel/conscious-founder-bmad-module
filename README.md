# Conscious-Founder Module

AI-human co-creative newsletter synthesis through ACM framework and juggling patterns.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/Trevorvaizel/conscious-founder.git
cd conscious-founder/_bmad/modules/conscious-founder

# Run one-command installation
bash setup.sh
```

That's it! The installer will:
- ✅ Set up Altitude Engine (semantic search)
- ✅ Install all Python dependencies
- ✅ Initialize vector database
- ✅ Configure module structure
- ✅ Verify everything works

---

## 🎯 Features

### Core Agents

1. **Alex (Analyst)** - Extract insights from transcripts without making strategic decisions
2. **Sam (Architect)** - Structure content using ACM framework and pattern selection
3. **Casey (Copywriter)** - Generate content with calibrated voice
4. **Eve (Editor)** - Review content against quality gates and ACM litmus test

### Structured Workflows

1. **Inject** - Capture emphasis/angle before boiling phase completes (< 30 seconds)
2. **Transform** - Execute full K2M pipeline with 4 human-judgment checkpoints
3. **Return** - Re-enter published nodes with full context for deepening insights
4. **Repurpose** - Generate Type A/B/C social posts using ACM framework

### Knowledge Base

- ACM Framework (7 modules, 3 non-negotiables, litmus test)
- Juggling Patterns (5 patterns with psychological descriptions)
- Voice Constants and Quality Gates
- Pattern Selection and Checkpoint Philosophy

---

## 📦 Installation

### System Requirements

- **Python 3.8 or higher** - Required for Altitude Engine
- **pip** (Python package installer)
- **Bash shell** - For installation scripts (Linux/macOS/WSL/Git Bash)
- **150MB disk space** - For ML model and vector database
- **Internet connection** - For initial model download (~80MB)

### Quick Start (Linux/macOS/WSL)

```bash
# Clone the repository
git clone https://github.com/Trevorvaizel/conscious-founder.git
cd conscious-founder/_bmad/modules/conscious-founder

# Run one-command installation
bash setup.sh
```

That's it! The installer will:
- ✅ Set up Altitude Engine (semantic search)
- ✅ Install all Python dependencies (sentence-transformers, numpy)
- ✅ Initialize vector database
- ✅ Configure module structure
- ✅ Verify everything works

### Windows Installation

**Option 1: WSL (Windows Subsystem for Linux)**
```bash
# Enable WSL and Ubuntu
wsl

# In WSL terminal:
git clone https://github.com/Trevorvaizel/conscious-founder.git
cd conscious-founder/_bmad/modules/conscious-founder
bash setup.sh
```

**Option 2: Git Bash**
```bash
# In Git Bash:
git clone https://github.com/Trevorvaizel/conscious-founder.git
cd conscious-founder/_bmad/modules/conscious-founder
./setup.sh
```

**Option 3: Manual Installation**
```powershell
# In PowerShell:
python -m pip install sentence-transformers numpy
python -c "import sys; sys.path.insert(0, 'data'); from altitude_engine import AltitudeEngine; engine = AltitudeEngine('data/vector-embeddings.db'); engine.initialize(); print('✓ Altitude Engine ready')"
```

### Verify Installation

```bash
bash verify-install.sh
```

Expected output: All checks passed ✅

### Troubleshooting

**Installation fails?**
- Check `altitude-setup.log` for details
- Verify Python version: `python3 --version`
- Verify pip: `python3 -m pip --version`

**Need help?**
- See `INSTALLATION.md` for detailed troubleshooting
- Check `ALTITUDE_ENGINE.md` for technical documentation
- Open a GitHub issue

---

## 🚀 Usage

### Invoke Agents

```bash
/bmad:k2m-analyst      # Start Alex (Analyst)
/bmad:k2m-architect    # Start Sam (Architect)
/bmad:k2m-copywriter   # Start Casey (Copywriter)
/bmad:k2m-editor       # Start Eve (Editor)
```

### Run Workflows

```bash
/bmad:conscious-founder:inject      # Capture emphasis
/bmad:conscious-founder:transform   # Run full pipeline
/bmad:conscious-founder:return      # Re-enter published nodes
/bmad:conscious-founder:repurpose   # Generate social posts
```

### Example: Complete K2M Pipeline

```bash
# Step 1: Capture your emphasis (before boiling phase completes)
/bmad:conscious-founder:inject

# Step 2: Run the full pipeline
/bmad:k2m-analyst
# → Select [AN] to analyze transcript
# → Provide thesis at Checkpoint 1

/bmad:k2m-architect
# → Select [AS] to structure content
# → Approve pattern at Checkpoint 2

/bmad:k2m-copywriter
# → Select [CW] to write draft

/bmad:k2m-editor
# → Select [ED] to review and finalize
# → Approve at Checkpoint 4

# Step 3: After publishing, re-enter to deepen
/bmad:conscious-founder:return

# Step 4: Generate social posts
/bmad:conscious-founder:repurpose
```

---

## 🧪 Testing

### Test Agent Invocation

```bash
/bmad:k2m-analyst
# When Alex loads, select [CH] to chat
# Ask: "Hello! Can you tell me what you do?"
```

### Test Full Workflow

1. Prepare a transcript
2. Run Inject workflow to capture emphasis
3. Run Transform workflow (all 4 agents)
4. Review outputs in `_bmad-output/conscious-founder/`

---

## 📁 Module Structure

```
conscious-founder/
├── agents/                 # 4 BMAD-wrapped agents
│   ├── analyst.md         # Alex - K2M Content Analyst
│   ├── architect.md       # Sam - K2M Content Architect
│   ├── copywriter.md      # Casey - K2M Copywriter
│   └── editor.md          # Eve - K2M Editor
├── workflows/              # 4 workflow YAML files
│   ├── inject.yaml        # Capture emphasis
│   ├── transform.yaml     # Full K2M pipeline
│   ├── return.yaml        # Re-enter published nodes
│   └── repurpose.yaml     # Generate social posts
├── knowledge -> ../../knowledge  # Symlink to knowledge base
├── config.yaml            # Module configuration
├── manifest.yaml          # Module metadata
├── setup.sh               # Installation script
├── uninstall.sh           # Uninstallation script
├── verify-install.sh      # Verification script
└── README.md              # This file
```

---

## 🎨 Key Innovations

### 1. Essence Preservation Pattern
- **Zero semantic loss conversion** - Every prompt nuance preserved verbatim
- **Side-by-side verification** - Test that BMAD agents = standalone agents
- **Knowledge base as single-source-of-truth** - Prevents framework divergence

### 2. Creative Cartography (Altitude Engine)
- **Semantic similarity detection** across all published nodes
- **Territory reports** after each publish
- **Pattern recognition** across body of work
- **Evolution mapping** showing thinking phases over time

### 3. Atelier Collaboration Model
- **"Yes, and" collaboration** - Agents build on ideas, don't replace them
- **Checkpoint philosophy** - Human judgment at critical decision points
- **Flow state preservation** - Structure AROUND creative process, not replacing it

---

## 📚 Documentation

- **INSTALL.md** - Detailed installation guide
- **CONVERSION_GUIDE.md** - Essence preservation pattern with before/after examples
- **TESTING_CHECKLIST.md** - Side-by-side verification procedures
- **TUTORIAL.md** - Learn by doing: convert your first agent
- **PATTERNS.md** - Reusable patterns (knowledge base, checkpoints, state persistence)
- **TROUBLESHOOTING.md** - Common issues and fixes

---

## 🤝 Contributing

This is Rabbit's personal creative tool, but the module serves as a **reference implementation** for other creators wanting to wrap their agent systems in BMAD format with essence preservation.

**Essence Preservation Pattern:** Teachable, reusable, and documented for the community.

---

## 📊 Module Stats

- **Agents:** 4 (Analyst, Architect, Copywriter, Editor)
- **Workflows:** 4 (Inject, Transform, Return, Repurpose)
- **Knowledge Files:** 8 (ACM framework, patterns, voice constants, etc.)
- **Installation Tests:** 35/35 PASSING ✅
- **Version:** 1.0.0
- **BMAD Compatibility:** v1.0+
- **Tested On:** BMAD v6.0.0-alpha.22

---

## 🎯 Success Metrics

**User Success:**
- Zero-friction emphasis capture (< 30 seconds)
- Full K2M pipeline execution (4 checkpoints, 50%+ time savings)
- Altitude perspective: "10,000-foot view" of creative territory

**Technical Success:**
- Agent invocation: < 2 seconds
- Zero behavioral drift (side-by-side verification passes)
- Altitude analysis: < 10 seconds for entire corpus

**Innovation Validation:**
- Essence preservation pattern proven (side-by-side testing)
- Creative cartography reveals patterns (altitude moments)
- Atelier model feels like collaborative partnership

---

## 📝 License

[Your License Here]

---

## 🙏 Acknowledgments

- **K2M System:** Rabbit's newsletter workflow framework
- **ACM Framework:** Attention Control Mode with 7 modules
- **BMAD Platform:** Base module system and workflow orchestration

---

## 📧 Support

For issues or questions:
- Open a GitHub issue
- Check TROUBLESHOOTING.md
- Review verification: `./verify-install.sh`

---

**Last Updated:** 2026-01-09
**Status:** Production Ready ✅
**Maintainer:** Rabbit

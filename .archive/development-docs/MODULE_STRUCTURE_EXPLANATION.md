# How Your Conscious-Founder Project Works

## Your Existing Repo
**GitHub:** https://github.com/Trevorvaizel/conscious-founder

This is your MAIN project repo containing:
- K2M newsletter system
- Source documents  
- Agent prompts
- **BMAD framework** (_bmad/)
- **Conscious-Founder module** (_bmad/modules/conscious-founder/)

## Structure

```
conscious-founder/                    # YOUR MAIN REPO
├── k2m-newsletter foundation/        # Your source documents
├── k2m-refined-prompts/              # Your agent prompts
├── _bmad/                            # BMAD framework
│   ├── modules/
│   │   └── conscious-founder/        # ← YOUR MODULE (part of this repo)
│   ├── bmb/                          # BMAD Module Builder
│   ├── bmm/                          # BMAD Methods
│   ├── cis/                          # Creative Innovation Suite
│   ├── core/                         # BMAD Core
│   └── knowledge/                    # Your frameworks
└── _bmad-output/                     # Generated outputs

```

## The Module is PART of Your Repo

The `conscious-founder` module at `_bmad/modules/conscious-founder/` is:
- ✅ **Part of your existing repo** - commit it together
- ✅ **Installed in your project** - run setup.sh once
- ✅ **Ready to use** - invoke agents with /bmad:k2m-analyst

## When Would You Need a Separate Repo?

ONLY if you want to:
1. **Distribute the module** for OTHER people to use in THEIR projects
2. **Share it as a standalone package** separate from your K2M system

In that case, you'd create:
- https://github.com/Trevorvaizel/conscious-founder-bmad-module (separate repo)

But for YOUR use? **Keep it in your main repo!**

## Next Steps

1. Add the module to your existing repo:
   ```bash
   git add _bmad/modules/conscious-founder/
   git commit -m "Add Conscious-Founder BMAD module"
   git push
   ```

2. Install it (if not already):
   ```bash
   cd _bmad/modules/conscious-founder
   ./setup.sh
   ```

3. Use it:
   ```bash
   /bmad:k2m-analyst
   ```

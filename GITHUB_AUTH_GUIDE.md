# GitHub Authentication for Git Push

## Problem
GitHub no longer supports password authentication. You need a Personal Access Token.

## Solution: Create Personal Access Token

### Step 1: Generate Token

1. Go to: https://github.com/settings/tokens
2. Click: **"Generate new token"** (or "Generate new token (classic)")
3. Give it a name: "Conscious-Founder Module Push"
4. Select scopes (check these boxes):
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (if you want GitHub Actions)
5. Click: **"Generate token"** at bottom
6. **IMPORTANT:** Copy the token NOW (it starts with `ghp_...`)
   - You won't see it again! Save it somewhere safe.

### Step 2: Push Using Token

Run this command in your terminal:

```bash
cd /mnt/c/Users/OMEN/Documents/K2M/conscious-founder/_bmad/modules/conscious-founder
git push -u origin main
```

When prompted:
- **Username:** Trevorvaizel
- **Password:** <paste your token here, NOT your password>

The token will look like: `ghp_1234567890abcdefgh...`

---

## Alternative: Use SSH (Recommended for Long-term)

### Step 1: Check if you have SSH keys

```bash
ls ~/.ssh/id_rsa.pub
```

If it exists, skip to Step 3.

### Step 2: Generate SSH key (if needed)

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter for all defaults
```

### Step 3: Add SSH key to GitHub

1. Copy your public key:
```bash
cat ~/.ssh/id_ed25519.pub
```

2. Go to: https://github.com/settings/keys
3. Click: **"New SSH key"**
4. Title: "Conscious-Founder Module"
5. Paste the key you copied
6. Click: **"Add SSH key"**

### Step 4: Change Remote to SSH

```bash
cd /mnt/c/Users/OMEN/Documents/K2M/conscious-founder/_bmad/modules/conscious-founder
git remote set-url origin git@github.com:Trevorvaizel/conscious-founder-bmad-module.git
git push -u origin main
```

No password needed with SSH! ✅

---

## Quick Fix: Use GitHub CLI (if installed)

```bash
gh auth login
# Follow the prompts (browser authentication)

cd /mnt/c/Users/OMEN/Documents/K2M/conscious-founder/_bmad/modules/conscious-founder
git push -u origin main
```

---

## Which Method Should You Use?

**For one-time push:** Use Personal Access Token (Method 1)
**For long-term:** Use SSH (Method 2) - most convenient
**If you have gh CLI:** Use GitHub CLI (Method 3) - easiest

---

## After Successful Push

Visit: https://github.com/Trevorvaizel/conscious-founder-bmad-module

You should see your module files! 🎉

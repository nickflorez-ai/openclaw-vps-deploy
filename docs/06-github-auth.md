# GitHub Authentication

Set up GitHub access for your OpenClaw AI assistant with a dedicated AI account.

---

## Overview

**Recommended workflow:**
1. Create a dedicated GitHub account for the AI (e.g., `firstname-ai`)
2. AI creates pull requests from its account
3. Human reviews and merges PRs

This creates a clear audit trail and prevents the AI from pushing directly to main.

---

## Step 1: Create AI GitHub Account

1. Go to [github.com/signup](https://github.com/signup)
2. Create account with naming convention: `firstname-ai` or `firstname-assistant`
   - Example: `jane-ai`, `john-assistant`
3. Complete email verification
4. Set up a profile picture (helps identify AI commits)

---

## Step 2: Install GitHub CLI

SSH into your VPS:

```bash
# Install gh CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Or via npm
npm install -g gh
```

---

## Step 3: Authenticate GitHub CLI

```bash
gh auth login --web
```

This will:
1. Display a one-time code
2. Open a URL (or display it for manual opening)
3. You enter the code on github.com
4. Authorization completes

For headless VPS, copy the URL and complete auth in your local browser.

---

## Step 4: Verify Authentication

```bash
# Check logged-in user
gh api user --jq '.login'

# Should output: firstname-ai

# Check auth status
gh auth status
```

---

## Step 5: Add AI as Collaborator

The repo owner adds the AI account as a collaborator:

1. Go to repo → **Settings** → **Collaborators**
2. Click **Add people**
3. Enter the AI account username (e.g., `jane-ai`)
4. Select permission level:
   - **Write** — Can push branches, create PRs
   - **Maintain** — Can also manage issues/PRs (not needed usually)

The AI account needs to accept the invitation (check email or github.com/notifications).

---

## PR Workflow

### AI Creates PR

```bash
# Create feature branch
git checkout -b feature/add-documentation

# Make changes
# ...

# Commit and push
git add .
git commit -m "Add documentation for X"
git push -u origin feature/add-documentation

# Create PR
gh pr create --title "Add documentation for X" --body "Description of changes"
```

### Human Reviews

1. Human receives notification
2. Reviews changes, leaves comments
3. Requests changes if needed
4. AI addresses feedback and pushes updates
5. Human approves and merges

---

## Multiple GitHub Accounts

If the VPS needs access to multiple accounts:

```bash
# Add another account
gh auth login --web

# Switch between accounts
gh auth switch --user jane-ai
gh auth switch --user company-bot

# List all accounts
gh auth status
```

---

## Git Configuration

Configure git for the AI account:

```bash
git config --global user.name "Jane AI"
git config --global user.email "jane-ai@users.noreply.github.com"
```

Use the GitHub noreply email to keep the real email private.

---

## SSH Keys (Alternative to HTTPS)

If you prefer SSH authentication:

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "jane-ai@users.noreply.github.com"

# Add to ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Copy public key
cat ~/.ssh/id_ed25519.pub

# Add to GitHub: Settings → SSH and GPG keys → New SSH key
```

---

## Troubleshooting

### "Permission denied"
- Check collaborator invitation was accepted
- Verify correct account is active: `gh api user --jq '.login'`
- Switch accounts if needed: `gh auth switch`

### "Authentication failed"
- Re-run `gh auth login --web`
- Check token hasn't been revoked

### Wrong account pushing
- Check: `gh api user --jq '.login'`
- Switch: `gh auth switch --user correct-username`

---

## Security Best Practices

- Use a dedicated AI account (not your personal account)
- Require PR reviews for main branch
- Enable branch protection rules
- Review AI commits before merging
- Rotate tokens periodically

# Asana Integration

Connect OpenClaw to Asana for task and project management.

---

## Overview

OpenClaw can integrate with Asana to:
- View and create tasks
- Manage projects
- Track goals
- Search across workspaces

---

## Step 1: Create Asana Developer App

1. Go to [Asana Developer Console](https://app.asana.com/0/developer-console)
2. Click **Create new app**
3. Fill in:
   - **App name:** "OpenClaw Assistant"
   - **What's it for:** Select appropriate option
4. Click **Create app**

---

## Step 2: Generate Personal Access Token (Recommended)

For single-user setups, a Personal Access Token (PAT) is simplest:

1. In the Asana Developer Console, go to your app
2. Navigate to **Personal access tokens** section
3. Click **Create new token**
4. Name it (e.g., "OpenClaw VPS")
5. Copy the token immediately (shown only once)

---

## Step 3: Configure OpenClaw

### Store the token

SSH into your VPS:

```bash
# Create secrets directory
mkdir -p ~/clawd/.secrets

# Save the token
echo "ASANA_PAT=your_token_here" > ~/clawd/.secrets/asana.env
chmod 600 ~/clawd/.secrets/asana.env
```

### Add to OpenClaw config

In the OpenClaw web interface:

1. Go to **Settings** → **Config** → **RAW**
2. Add:

```json
{
  "integrations": {
    "asana": {
      "enabled": true,
      "tokenPath": "/root/clawd/.secrets/asana.env"
    }
  }
}
```

3. Click **Apply** → **Update**
4. Restart Gateway

---

## Step 4: Verify Integration

SSH into your VPS and test:

```bash
# Set the token
export ASANA_PAT=$(cat ~/clawd/.secrets/asana.env | cut -d= -f2)

# Test API access
curl -H "Authorization: Bearer $ASANA_PAT" \
  https://app.asana.com/api/1.0/users/me
```

You should see your Asana user info.

---

## OAuth Flow (Alternative)

For multi-user or more secure setups, use OAuth:

### Configure OAuth App

1. In Asana Developer Console → your app
2. Go to **OAuth** section
3. Add redirect URI: `http://localhost:8080/callback`
4. Note your **Client ID** and **Client Secret**

### OAuth Configuration

```json
{
  "integrations": {
    "asana": {
      "enabled": true,
      "oauth": {
        "clientId": "YOUR_CLIENT_ID",
        "clientSecret": "YOUR_CLIENT_SECRET",
        "redirectUri": "http://localhost:8080/callback"
      }
    }
  }
}
```

---

## Common Operations

Once integrated, OpenClaw can perform these Asana operations:

### Tasks
- List tasks in a project
- Create new tasks
- Update task status
- Add comments

### Projects
- List projects in workspace
- Create projects
- View project details

### Search
- Search tasks across workspaces
- Filter by assignee, due date, etc.

---

## Workspace Configuration

If you have multiple Asana workspaces, specify the default:

```json
{
  "integrations": {
    "asana": {
      "enabled": true,
      "defaultWorkspace": "1234567890123"
    }
  }
}
```

Get workspace IDs:
```bash
curl -H "Authorization: Bearer $ASANA_PAT" \
  https://app.asana.com/api/1.0/workspaces
```

---

## Troubleshooting

### "Not authorized"
- Verify the PAT is correct and not expired
- Check token has access to the workspace

### "Workspace not found"
- Ensure the user has access to the workspace
- Try listing workspaces to get correct ID

### Token expiration
- PATs don't expire unless revoked
- OAuth tokens may need refresh — check OAuth setup

---

## Security Notes

- Never commit tokens to git
- Use environment files with restricted permissions
- Rotate tokens periodically
- Consider using a dedicated Asana user for the AI assistant

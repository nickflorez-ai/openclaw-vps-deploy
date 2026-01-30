# Google Chat Setup (OAuth Flow)

This guide sets up Google Chat as a messaging channel for OpenClaw using OAuth (not service account).

**Requires:** Google Workspace Admin access + GCP Console access

---

## Part 1: GCP Setup (Workspace Admin / CISO)

### Step 1: Enable the Google Chat API

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select or create a project for Cardinal AI
3. Navigate to **APIs & Services** → **Library**
4. Search for **Google Chat API**
5. Click **Enable**

### Step 2: Create OAuth 2.0 Credentials

1. Go to **APIs & Services** → **Credentials**
2. Click **+ Create Credentials** → **OAuth client ID**
3. Application type: **Web application**
4. Name: `OpenClaw Google Chat` (or executive's name)
5. **Authorized redirect URIs** — add ONE of these depending on deployment:

   **For local/dev (Mac mini):**
   ```
   http://localhost:18789/oauth/callback/googlechat
   ```

   **For VPS with Tailscale:**
   ```
   https://<tailscale-hostname>/oauth/callback/googlechat
   ```

   **For VPS with public domain:**
   ```
   https://<your-domain>/oauth/callback/googlechat
   ```

6. Click **Create**
7. **Copy and securely store:**
   - Client ID (ends in `.apps.googleusercontent.com`)
   - Client Secret

### Step 3: Configure the Chat App

1. In GCP Console, go to **Google Chat API** → **Configuration**
2. Fill in:

   | Field | Value |
   |-------|-------|
   | App name | `OpenClaw` (or exec name + "AI") |
   | Avatar URL | *(optional)* |
   | Description | `AI Collaborator for Cardinal Financial` |
   | Interactive features | ✅ **Enabled** |
   | App URL | *(leave blank — HTTP push mode)* |

3. Under **Functionality**:
   - ✅ Receive 1:1 messages
   - ✅ Join spaces and group conversations

4. Click **Save**

### Step 4: Configure OAuth Consent Screen

1. Go to **APIs & Services** → **OAuth consent screen**
2. User type: **Internal** (Cardinal Workspace only)
3. App name: `OpenClaw`
4. Support email: your email
5. **Scopes** — click **Add or Remove Scopes** and add:
   ```
   https://www.googleapis.com/auth/chat.bot
   https://www.googleapis.com/auth/chat.messages
   https://www.googleapis.com/auth/chat.spaces.readonly
   ```
6. Click **Save and Continue**
7. **Publish** the app (Internal only — no review needed)

### Step 5: Send Credentials to IT

Securely share with IT/Nick:
- Client ID
- Client Secret
- Redirect URI you configured

---

## Part 2: OpenClaw Configuration (IT / Nick)

### Step 1: Install the Google Chat Plugin

```bash
openclaw plugins install @openclaw/googlechat
```

### Step 2: Add Configuration

Edit your OpenClaw config (`~/.openclaw/openclaw.json` or via Control UI → Config → RAW):

```json
{
  "plugins": {
    "entries": {
      "googlechat": {
        "enabled": true,
        "config": {
          "clientId": "YOUR_CLIENT_ID.apps.googleusercontent.com",
          "clientSecret": "YOUR_CLIENT_SECRET",
          "redirectUri": "http://localhost:18789/oauth/callback/googlechat",
          "dmPolicy": "allowlist",
          "allowFrom": ["nick.florez@cardinalfinancial.com"]
        }
      }
    }
  }
}
```

**Config options:**

| Field | Description |
|-------|-------------|
| `clientId` | OAuth Client ID from GCP |
| `clientSecret` | OAuth Client Secret from GCP |
| `redirectUri` | Must match GCP exactly |
| `dmPolicy` | `"allowlist"` (recommended) or `"pairing"` or `"open"` |
| `allowFrom` | Array of allowed email addresses |

### Step 3: Restart Gateway

```bash
openclaw gateway restart
```

### Step 4: Complete OAuth Consent

1. Check OpenClaw logs or Control UI for an OAuth URL
2. Open the URL in your browser
3. Sign in with your Cardinal Google account
4. Grant the requested permissions
5. You'll be redirected back — tokens are now cached

### Step 5: Test

1. Open **Google Chat** (Gmail sidebar or chat.google.com)
2. Click **+ Start a chat**
3. Search for your app name (e.g., "OpenClaw")
4. Start a conversation
5. Send: `hello`

If it responds — you're live! ✅

---

## Troubleshooting

### "App not found in Chat"
- Ensure the Chat App is published (Step 3)
- Ensure you're signed into the correct Workspace account
- Wait 1-2 minutes for propagation

### OAuth fails / redirect error
- Verify redirect URI matches **exactly** (including trailing slashes)
- Check that OAuth consent screen is published
- Verify Internal user type is set

### "Insufficient permissions"
- Add the required scopes to OAuth consent screen
- Re-authenticate (tokens may be stale)

### Bot doesn't respond
- Check `openclaw logs --follow` for errors
- Verify `googlechat` plugin is enabled in config
- Ensure `allowFrom` includes your email

---

## Security Notes

- **Internal only:** Only Cardinal Workspace users can access
- **OAuth tokens:** Stored locally in `~/.openclaw/` — treat as sensitive
- **No service account:** Uses user-delegated OAuth — more secure, requires consent

---

## Next Steps

Once working for Nick:
1. Create additional Chat Apps for other executives (or reuse one)
2. Add executive emails to `allowFrom`
3. Each exec completes OAuth consent once
4. Done — they message via Google Chat

---

## Quick Reference

| Item | Value |
|------|-------|
| GCP Console | https://console.cloud.google.com |
| Chat API | https://console.cloud.google.com/apis/library/chat.googleapis.com |
| OAuth Credentials | https://console.cloud.google.com/apis/credentials |
| Chat App Config | https://console.cloud.google.com/apis/api/chat.googleapis.com/hangouts-chat |

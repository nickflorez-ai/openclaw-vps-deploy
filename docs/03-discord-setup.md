# Discord Setup — Executive Flow

This guide covers the recommended workflow for setting up Discord with OpenClaw, where the executive (end user) creates the bot and server, and IT configures the integration.

---

## Overview

**Who does what:**

| Step | Who | Action |
|------|-----|--------|
| 1 | Executive | Creates their own Discord server |
| 2 | Executive | Creates a bot in Discord Developer Portal |
| 3 | Executive | Shares bot token with IT (securely) |
| 4 | IT/Admin | Configures OpenClaw with the token |
| 5 | IT/Admin | Provides invite link to executive |
| 6 | Executive | Adds bot to their server |

This keeps the executive in control of their Discord server while IT handles the technical configuration.

---

## Step 1: Executive Creates Discord Server

The executive creates a new Discord server for their AI assistant:

1. Open Discord
2. Click **+** (Add a Server) → **Create My Own**
3. Choose **For me and my friends**
4. Name it (e.g., "My Assistant")
5. Create a channel for the bot (e.g., `#ai-assistant`)

---

## Step 2: Executive Creates Bot Application

1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click **New Application**
3. Name it (e.g., "My AI Assistant") → **Create**
4. Go to **Bot** tab in sidebar
5. Click **Reset Token** → **Copy** the token
6. **Enable Privileged Gateway Intents:**
   - ✅ Presence Intent
   - ✅ Server Members Intent
   - ✅ Message Content Intent
7. Save changes

⚠️ **Security:** The executive should send the bot token to IT via a secure channel (1Password, encrypted message, etc.) — never plain email.

---

## Step 3: IT Configures OpenClaw

### Add Discord Configuration

In OpenClaw web interface:

1. Go to **Settings** → **Config**
2. Click **RAW** button
3. Add the Discord configuration:

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "token": "BOT_TOKEN_FROM_EXECUTIVE",
      "channelIds": ["CHANNEL_ID"],
      "dm": {
        "policy": "pairing"
      }
    }
  }
}
```

4. Click **Apply** → **Update**
5. Go to **Overview** → **Restart Gateway**

### Configuration Options

| Option | Description |
|--------|-------------|
| `token` | Discord bot token |
| `channelIds` | Array of channel IDs the bot responds in |
| `dm.policy` | `"pairing"`, `"allowlist"`, or `"disabled"` |

### DM Policies

- **`pairing`** — Users must pair their Discord account to DM the bot
- **`allowlist`** — Only whitelisted user IDs can DM
- **`disabled`** — No DMs allowed

---

## Step 4: Generate Bot Invite Link

Create an invite URL for the executive:

1. In Developer Portal → **OAuth2** → **URL Generator**
2. Select scopes:
   - ✅ `bot`
3. Select bot permissions:
   - ✅ Send Messages
   - ✅ Read Message History
   - ✅ Add Reactions
   - ✅ Embed Links
   - ✅ Attach Files
   - ✅ Use Slash Commands (optional)
4. Copy the generated URL
5. Send to executive

---

## Step 5: Executive Adds Bot to Server

1. Executive opens the invite link in browser
2. Selects their server from dropdown
3. Clicks **Authorize**
4. Completes CAPTCHA
5. Bot appears in server member list

---

## Step 6: Get Channel ID (for config)

The executive needs to provide the channel ID:

1. In Discord: **User Settings** → **App Settings** → **Advanced**
2. Enable **Developer Mode**
3. Right-click the channel → **Copy Channel ID**
4. Send to IT

IT updates the `channelIds` in the config.

---

## Verification

After setup, verify the bot is working:

1. Check **Channels** page in OpenClaw — Discord should show "Running: Yes"
2. Send a message in the configured channel
3. Bot should respond

---

## Troubleshooting

### Bot doesn't respond
- Verify the token is correct
- Check that Privileged Intents are enabled
- Confirm the channel ID is in `channelIds`
- Make sure bot has permissions in the channel

### "Bot is offline"
- Restart Gateway in OpenClaw
- Check Docker Manager for container status

### "Missing permissions"
- Re-invite bot with correct permissions
- Check channel-specific permission overrides

---

## Multiple Channels

To allow the bot in multiple channels:

```json
{
  "channels": {
    "discord": {
      "channelIds": ["123456789", "987654321", "456789123"]
    }
  }
}
```

---

## Multiple Servers

For multiple Discord servers, each server's channels go in the same `channelIds` array. The bot must be invited to each server.

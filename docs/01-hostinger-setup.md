# Hostinger OpenClaw Setup Guide

Complete guide for deploying OpenClaw on Hostinger VPS using their one-click Docker template.

> **Note:** Hostinger's catalog still uses the "Moltbot" name. Moltbot = OpenClaw.

## Prerequisites

- Hostinger VPS (any plan with Docker Manager support)
- Anthropic API key from [console.anthropic.com](https://console.anthropic.com)
- Discord bot token (optional) from [Discord Developer Portal](https://discord.com/developers/applications)

---

## Step 1: Deploy OpenClaw

### New VPS Purchase

1. Visit [hostinger.com/vps/docker/moltbot](https://www.hostinger.com/vps/docker/moltbot)
2. Select your plan:
   - **KVM 1** ($5.99/mo) — Good for personal use
   - **KVM 2** ($8.99/mo) — Better for multiple channels
3. Click **Deploy**
4. Complete purchase and wait for VPS provisioning

### Existing VPS

1. Log into [hPanel](https://hpanel.hostinger.com)
2. Select your VPS
3. Click **Docker Manager** in sidebar
4. If not installed, click **Install Docker Manager** (takes 2-3 min)
5. Go to **Catalog** tab
6. Search for "Moltbot"
7. Click the Moltbot card → **Deploy**

---

## Step 2: Configure Environment Variables

During deployment, you'll see a configuration screen:

| Variable | Required | Description |
|----------|----------|-------------|
| `MOLTBOT_GATEWAY_TOKEN` | Auto | Auto-generated. **Save this!** |
| `ANTHROPIC_API_KEY` | Yes | Your Claude API key |
| `OPENAI_API_KEY` | No | Optional OpenAI key |
| `DISCORD_BOT_TOKEN` | No | Discord bot token |
| `TELEGRAM_BOT_TOKEN` | No | Telegram bot token |

⚠️ **Important:** Copy the `MOLTBOT_GATEWAY_TOKEN` immediately. You'll need it to access the web interface.

Click **Deploy** to start the container.

---

## Step 3: Access OpenClaw Web Interface

1. In Docker Manager, go to your project
2. Note the **port number** (usually 18789)
3. Access: `http://YOUR_VPS_IP:PORT`
4. Enter your gateway token
5. Click **Connect**

You should see "Health: OK" in the top right.

---

## Next Steps

Once OpenClaw is running:
- [Discord Setup](03-discord-setup.md) — Connect your Discord bot
- [Google OAuth Setup](04-google-oauth.md) — Gmail, Calendar, Drive access
- [Enable Memory](07-memory-enable.md) — Persistent agent memory

---

## Troubleshooting

### "Container service disconnected"
- Wait 1-2 minutes for cold start
- Click **Restart Gateway** in Overview
- Check Docker Manager for container status

### Config changes not saving
- Click **Apply** first, then **Update**
- Restart Gateway after config changes

---

## Updating OpenClaw

1. Go to Docker Manager → Your project
2. Click **Rebuild** or **Update**
3. Docker pulls the latest image
4. Container restarts automatically

---

## Useful Links

- [OpenClaw Website](https://openclaw.ai)
- [Hostinger Moltbot Page](https://www.hostinger.com/vps/docker/moltbot)
- [Anthropic Console](https://console.anthropic.com)

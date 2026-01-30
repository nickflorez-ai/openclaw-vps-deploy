# OpenClaw VPS Deploy

Deploy [OpenClaw](https://openclaw.ai) personal AI assistant on Hostinger VPS in minutes.

> **📢 Important:** Hostinger's catalog lists this as **"Moltbot"** — Moltbot and OpenClaw are the same product. The name was recently changed, but Hostinger's marketplace still uses the original name.

---

## Quick Start

### 1. Get a Hostinger VPS

1. Go to [Hostinger Moltbot VPS](https://www.hostinger.com/vps/docker/moltbot)
2. Select a plan ($5-6/mo)
3. Click **Deploy**
4. Complete purchase

### 2. Configure

During setup, you'll enter:

| Variable | Description |
|----------|-------------|
| `MOLTBOT_GATEWAY_TOKEN` | Auto-generated — **save this!** |
| `ANTHROPIC_API_KEY` | Your Claude API key from [console.anthropic.com](https://console.anthropic.com) |

### 3. Access OpenClaw

1. In hPanel → **Docker Manager** → note the port
2. Visit `http://your-vps-ip:port`
3. Enter your gateway token → **Connect**

You're in! Look for **"Health: OK"** in the top-right corner.

---

## Documentation

Follow these guides in order for a complete setup:

| # | Guide | Description |
|---|-------|-------------|
| 01 | [Hostinger Setup](docs/01-hostinger-setup.md) | Initial VPS deployment |
| 02 | [Security](docs/02-security.md) | Firewall, Tailscale, access control |
| 03 | [Discord Setup](docs/03-discord-setup.md) | Connect Discord bot (executive flow) |
| 04 | [Google OAuth](docs/04-google-oauth.md) | Gmail, Calendar, Drive integration |
| 05 | [Asana Integration](docs/05-asana-oauth.md) | Task and project management |
| 06 | [GitHub Auth](docs/06-github-auth.md) | AI GitHub account and PR workflow |
| 07 | [Enable Memory](docs/07-memory-enable.md) | Persistent agent memory |
| 08 | [Plugins](docs/08-plugins.md) | Installing skills from ClawdHub |
| 10 | [Verification](docs/10-verification.md) | Post-deployment checklist |

---

## Quick Config Examples

### Discord

```json
{
  "channels": {
    "discord": {
      "enabled": true,
      "token": "YOUR_DISCORD_BOT_TOKEN",
      "channelIds": ["YOUR_CHANNEL_ID"],
      "dm": { "policy": "pairing" }
    }
  }
}
```

### WhatsApp

```json
{
  "channels": {
    "whatsapp": {
      "dmPolicy": "allowlist",
      "allowFrom": ["+1234567890"]
    }
  }
}
```

### Enable Memory

```json
{
  "agents": {
    "defaults": {
      "memory": {
        "enabled": true
      }
    }
  }
}
```

---

## Customize Your Agent

Edit workspace files:
- `SOUL.md` — Personality and voice
- `USER.md` — User information  
- `AGENTS.md` — Behavior and rules
- `MEMORY.md` — Long-term memory

---

## Update OpenClaw

Docker Manager → Your project → **Rebuild**

---

## Resources

- [OpenClaw](https://openclaw.ai)
- [ClawdHub](https://clawdhub.com) — Plugins and skills
- [Hostinger Support](https://www.hostinger.com/support)
- [Security Guide](https://www.hostinger.com/support/how-to-secure-and-harden-moltbot-security/)

---

## License

MIT

# Post-Deployment Verification Checklist

Verify your OpenClaw deployment is working correctly after setup.

---

## Quick Health Check

### 1. Web Interface

- [ ] Visit `http://YOUR_VPS_IP:PORT`
- [ ] Enter gateway token
- [ ] Connect successfully
- [ ] See **"Health: OK"** in the top-right corner

If health shows issues, check **Settings** → **Logs** for errors.

---

## Channel Verification

### 2. Discord

- [ ] **Channels** page shows Discord as "Running: Yes"
- [ ] Bot appears online in Discord server
- [ ] Send a test message in configured channel
- [ ] Bot responds appropriately

**Test command:**
```
@YourBot hello, are you there?
```

### 3. WhatsApp (if configured)

- [ ] **Channels** page shows WhatsApp connected
- [ ] QR code successfully scanned
- [ ] Send test message from whitelisted number
- [ ] Bot responds

---

## Integration Verification

### 4. Google Workspace (gog)

SSH into VPS and verify:

```bash
# Check authenticated accounts
gog auth list
```

Expected output:
```
Authenticated accounts:
  ✓ user@company.com (gmail, calendar, drive)
```

Test access:
```bash
# Test Gmail
gog gmail threads --account user@company.com --max 3

# Test Calendar
gog calendar events --account user@company.com --max 3
```

### 5. Asana

```bash
# Set token
export ASANA_PAT=$(cat ~/clawd/.secrets/asana.env | cut -d= -f2)

# Test API
curl -s -H "Authorization: Bearer $ASANA_PAT" \
  https://app.asana.com/api/1.0/users/me | jq '.data.name'
```

Should output the Asana user's name.

### 6. GitHub

```bash
# Check authenticated user
gh api user --jq '.login'
```

Should output the AI account username (e.g., `jane-ai`).

```bash
# Verify auth status
gh auth status
```

---

## Memory Verification

### 7. Workspace & Memory

```bash
# Check workspace exists
ls -la /root/clawd/

# Check MEMORY.md exists
cat /root/clawd/MEMORY.md

# Check memory directory
ls -la /root/clawd/memory/
```

**Test memory persistence:**

1. Tell the bot: "Please remember that my favorite color is blue"
2. Verify the info was written:
   ```bash
   cat /root/clawd/memory/$(date +%Y-%m-%d).md
   ```
3. In a new session, ask: "What's my favorite color?"

---

## System Health

### 8. Container Status

In Hostinger hPanel:

- [ ] Docker Manager shows container as "Running"
- [ ] No restart loops (check uptime)
- [ ] Resource usage is normal

### 9. Logs Check

In OpenClaw web interface → **Settings** → **Logs**:

- [ ] No critical errors
- [ ] Channels show successful connections
- [ ] No authentication failures

---

## Complete Checklist

| Component | Check | Status |
|-----------|-------|--------|
| Web UI | Health: OK | ☐ |
| Discord | Running: Yes | ☐ |
| Discord | Bot responds | ☐ |
| WhatsApp | Connected (if used) | ☐ |
| Google | `gog auth list` shows account | ☐ |
| Asana | API returns user info | ☐ |
| GitHub | `gh api user` shows AI account | ☐ |
| Memory | MEMORY.md exists | ☐ |
| Memory | Daily notes created | ☐ |
| Container | Running, no restarts | ☐ |
| Logs | No critical errors | ☐ |

---

## Troubleshooting Quick Reference

| Issue | Solution |
|-------|----------|
| Health not OK | Restart Gateway, check logs |
| Discord not connecting | Verify token, check intents |
| WhatsApp QR not showing | Restart Gateway |
| gog auth fails | Re-run with `--manual --force-consent` |
| GitHub wrong user | `gh auth switch --user correct-name` |
| Memory not saving | Check workspace path in config |

---

## Next Steps

Once verification is complete:

1. **Customize the agent** — Edit SOUL.md, USER.md, AGENTS.md
2. **Add more integrations** — See [Plugins](08-plugins.md)
3. **Set up security** — See [Security](02-security.md)
4. **Train your users** — Share the bot with intended users

---

## Getting Help

- [OpenClaw Documentation](https://openclaw.ai/docs)
- [Hostinger Support](https://www.hostinger.com/support)
- [ClawdHub Community](https://clawdhub.com/community)

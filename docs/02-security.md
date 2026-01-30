# Security Configuration

Essential security practices for your OpenClaw VPS deployment.

---

## Firewall Rules

### UFW (Recommended)

```bash
# Enable UFW
sudo ufw enable

# Allow SSH
sudo ufw allow 22/tcp

# Allow OpenClaw web interface (adjust port as needed)
sudo ufw allow 18789/tcp

# Check status
sudo ufw status
```

### Restrict Access by IP

For production, limit web UI access to specific IPs:

```bash
# Allow only your IP
sudo ufw allow from YOUR_IP to any port 18789
sudo ufw deny 18789/tcp
```

---

## Tailscale (Recommended)

Use Tailscale to access your VPS without exposing ports publicly.

### Install Tailscale

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

### Access via Tailscale

1. Install Tailscale on your local machine
2. Connect to your VPS via its Tailscale IP (100.x.x.x)
3. Block public access to the web UI port

```bash
# Only allow Tailscale subnet
sudo ufw allow from 100.64.0.0/10 to any port 18789
sudo ufw deny 18789/tcp
```

---

## Channel Security

### Discord

- Use `channelIds` to restrict which channels the bot responds in
- Set `dm.policy` to `"pairing"` or `"disabled"` to control DM access

```json
{
  "channels": {
    "discord": {
      "channelIds": ["123456789"],
      "dm": { "policy": "pairing" }
    }
  }
}
```

### WhatsApp

- Use `allowFrom` to whitelist phone numbers
- Set `dmPolicy` to `"allowlist"`

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

---

## Gateway Token

- Store your `MOLTBOT_GATEWAY_TOKEN` securely
- Never share it publicly
- Rotate it if compromised (requires container rebuild)

---

## SSH Hardening

```bash
# Disable password auth (after setting up keys)
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Use SSH keys only
ssh-copy-id -i ~/.ssh/id_rsa.pub root@your-vps-ip
```

---

## Additional Resources

- [Hostinger Security Guide](https://www.hostinger.com/support/how-to-secure-and-harden-moltbot-security/)
- [Tailscale Documentation](https://tailscale.com/kb/)

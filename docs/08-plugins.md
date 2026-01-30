# Installing Plugins (Skills)

Extend OpenClaw's capabilities with plugins from ClawdHub.

---

## Overview

OpenClaw uses **plugins** (also called **skills**) to add new capabilities:
- Google Workspace integration (`gog`)
- GitHub access (`github`)
- Weather information (`weather`)
- And many more

Plugins are managed through [ClawdHub](https://clawdhub.com).

---

## Step 1: Access ClawdHub

Visit [clawdhub.com](https://clawdhub.com) to browse available plugins.

Or use the CLI:

```bash
# Search for plugins
clawdhub search gmail

# Search by category
clawdhub search --category productivity
```

---

## Step 2: Install a Plugin

### Via CLI

```bash
# Install a plugin
clawdhub install gog

# Install specific version
clawdhub install gog@1.2.0

# Install multiple plugins
clawdhub install gog github weather
```

### Via Web Interface

1. In OpenClaw, go to **Settings** → **Plugins**
2. Browse or search for plugins
3. Click **Install**

---

## Step 3: Configure Plugin

Most plugins require configuration. Check the plugin's documentation:

```bash
# View plugin info
clawdhub info gog

# View plugin README
clawdhub readme gog
```

Configuration is usually added to your OpenClaw config:

```json
{
  "plugins": {
    "gog": {
      "enabled": true,
      "config": {
        "defaultAccount": "user@company.com"
      }
    }
  }
}
```

---

## Popular Plugins

### gog (Google Workspace)
Gmail, Calendar, Drive integration.
```bash
clawdhub install gog
```
See: [Google OAuth Setup](04-google-oauth.md)

### github
GitHub repository access, PR management.
```bash
clawdhub install github
```
See: [GitHub Authentication](06-github-auth.md)

### weather
Current weather and forecasts.
```bash
clawdhub install weather
```

### asana
Asana task and project management.
```bash
clawdhub install asana
```
See: [Asana Integration](05-asana-oauth.md)

### web
Web browsing and search capabilities.
```bash
clawdhub install web
```

### calendar
Enhanced calendar features.
```bash
clawdhub install calendar
```

---

## Managing Plugins

### List Installed Plugins

```bash
clawdhub list
```

### Update Plugins

```bash
# Update specific plugin
clawdhub update gog

# Update all plugins
clawdhub update --all
```

### Remove Plugin

```bash
clawdhub uninstall weather
```

---

## Plugin Configuration in Config

Full example with multiple plugins:

```json
{
  "plugins": {
    "gog": {
      "enabled": true,
      "config": {
        "defaultAccount": "user@company.com"
      }
    },
    "github": {
      "enabled": true,
      "config": {
        "defaultUser": "jane-ai"
      }
    },
    "weather": {
      "enabled": true,
      "config": {
        "defaultLocation": "San Francisco, CA",
        "units": "imperial"
      }
    }
  }
}
```

---

## Creating Custom Plugins

Advanced users can create their own plugins. See the [ClawdHub Developer Guide](https://clawdhub.com/docs/developers).

Basic structure:
```
my-plugin/
├── SKILL.md        # Documentation
├── package.json    # Dependencies
└── index.js        # Plugin code
```

---

## Troubleshooting

### Plugin not working
- Check plugin is enabled in config
- Verify required configuration is present
- Check logs for errors: **Settings** → **Logs**

### "Plugin not found"
- Check spelling
- Search ClawdHub: `clawdhub search pluginname`
- Plugin may not exist or may have different name

### Version conflicts
- Check plugin compatibility with OpenClaw version
- Try latest version: `clawdhub update pluginname`

---

## Security Notes

- Only install plugins from trusted sources
- Review plugin permissions before installing
- Some plugins require API keys or credentials
- Keep plugins updated for security patches

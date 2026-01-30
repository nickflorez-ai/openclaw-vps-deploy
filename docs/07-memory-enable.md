# Enable Memory

Configure persistent memory for your OpenClaw agent so it remembers context across sessions.

---

## Overview

Memory is **DISABLED by default** in OpenClaw. When enabled, the agent:
- Maintains daily notes (`memory/YYYY-MM-DD.md`)
- Builds long-term memory (`MEMORY.md`)
- Remembers conversations, preferences, and context
- Persists information across restarts

---

## Step 1: Enable Memory in Config

In the OpenClaw web interface:

1. Go to **Settings** → **Config** → **RAW**
2. Add to your configuration:

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

3. Click **Apply** → **Update**
4. Restart Gateway

---

## Step 2: Set Up Workspace

SSH into your VPS and create the workspace structure:

```bash
# Create workspace directory (if not exists)
mkdir -p /root/clawd

# Create memory directory
mkdir -p /root/clawd/memory

# Create initial memory file
touch /root/clawd/MEMORY.md

# Create agent instructions file
cat > /root/clawd/AGENTS.md << 'EOF'
# Agent Instructions

This is your workspace. Start each session by reading:
1. MEMORY.md - Your long-term memory
2. memory/YYYY-MM-DD.md - Recent daily notes

Write important information to these files to remember it.
EOF
```

---

## Memory Files

### MEMORY.md (Long-term)

This is the agent's curated long-term memory:
- Key facts about the user
- Important decisions
- Learned preferences
- Ongoing projects

Example:
```markdown
# Memory

## User
- Name: Jane Smith
- Role: VP of Engineering
- Prefers concise responses

## Projects
- Q1 roadmap planning in progress
- Weekly 1:1s on Tuesdays

## Preferences
- Morning coffee order: oat milk latte
- Prefers Slack over email for quick questions
```

### memory/YYYY-MM-DD.md (Daily Notes)

Raw daily logs of what happened:
- Conversations
- Tasks completed
- Decisions made

Example (`memory/2025-01-30.md`):
```markdown
# 2025-01-30

## Morning
- Reviewed Q1 roadmap with Jane
- Sent summary to engineering leads

## Afternoon
- Drafted proposal for new feature
- Jane approved the approach

## Notes
- Remember: Jane prefers bullet points over paragraphs
```

---

## Memory Configuration Options

```json
{
  "agents": {
    "defaults": {
      "memory": {
        "enabled": true
      },
      "workspace": "/root/clawd"
    }
  }
}
```

| Option | Description |
|--------|-------------|
| `memory.enabled` | Enable/disable memory (`true`/`false`) |
| `workspace` | Path to workspace directory |

---

## How Memory Works

1. **Session Start:** Agent reads MEMORY.md and recent daily notes
2. **During Session:** Agent writes important info to daily notes
3. **Over Time:** Agent distills daily notes into long-term MEMORY.md
4. **Persistence:** Files survive container restarts

---

## Workspace Files

Standard workspace structure:

```
/root/clawd/
├── AGENTS.md      # How the agent should behave
├── MEMORY.md      # Long-term memory
├── SOUL.md        # Agent personality
├── USER.md        # User info
├── TOOLS.md       # Tool-specific notes
└── memory/
    ├── 2025-01-28.md
    ├── 2025-01-29.md
    └── 2025-01-30.md
```

---

## Verifying Memory is Working

1. **Check workspace exists:**
   ```bash
   ls -la /root/clawd/
   ```

2. **Check memory file exists:**
   ```bash
   cat /root/clawd/MEMORY.md
   ```

3. **Test with the agent:**
   - Tell it something to remember: "Remember that I prefer morning meetings"
   - In a new session, ask: "What do you remember about my meeting preferences?"

---

## Troubleshooting

### Memory not persisting
- Verify `memory.enabled: true` in config
- Check workspace path is correct
- Ensure directory has write permissions

### Agent not reading memory
- Check AGENTS.md includes memory instructions
- Verify files exist in workspace

### Container restart loses memory
- Workspace should be in a mounted volume
- Check Docker volume configuration in hPanel

---

## Security Considerations

- Memory files may contain sensitive information
- Restrict VPS access appropriately
- Consider what information should/shouldn't be stored
- Implement cleanup procedures for old daily notes if needed

#!/usr/bin/env bash

VAULT_NAME="ObsidianVault"

mkdir -p "$VAULT_NAME"
cd "$VAULT_NAME" || exit 1

# =========================================================
# CORE STRUCTURE
# =========================================================

mkdir -p Inbox

mkdir -p Projects/Active
mkdir -p Projects/On\ Hold
mkdir -p Projects/Archive

mkdir -p Areas/Family
mkdir -p Areas/Work
mkdir -p Areas/Home
mkdir -p Areas/Music
mkdir -p Areas/Personal\ Development

mkdir -p Resources/Programming
mkdir -p Resources/AI
mkdir -p Resources/Music
mkdir -p Resources/DnD
mkdir -p Resources/Work

mkdir -p Incubator/Developer\ Tools
mkdir -p Incubator/Neovim\ Plugins
mkdir -p Incubator/Open\ Source\ Projects
mkdir -p Incubator/AI\ Ideas
mkdir -p Incubator/Home Assistant Ideas
mkdir -p Incubator/Books
mkdir -p Incubator/Movies
mkdir -p Incubator/TV\ Shows
mkdir -p Incubator/Music
mkdir -p Incubator/Games
mkdir -p Incubator/Project\ Ideas

mkdir -p Daily
mkdir -p Archive
mkdir -p Templates

# =========================================================
# ROOT DASHBOARD (Obsidian-friendly, Neovim-safe)
# =========================================================

cat > Dashboard.md << 'EOF'
# Dashboard

This is the control center of the vault.

NOTE:
- Works in both Obsidian and Neovim
- Dataview is optional (do not rely on it as source of truth)

---

## 🟢 Active Projects

(Use ripgrep in Neovim: Status:: Active)

- Backup Verification System
- Espresso Telemetry Tool

---

## 🟡 Next Up (On Hold)

- AI Knowledge Assistant
- Homelab Monitoring System

---

## 📥 Inbox

- Capture everything here first
- Process weekly

---

## 💡 Incubator (Backlog)

- CLI tools to investigate
- Books to read
- Neovim plugins to test
- Game backlog

---

## 📅 Daily Notes

See /Daily for execution logs.

---

## 🔎 Quick Search Rules

In Neovim:
- Active projects → `rg "Status:: Active"`
- Incubator → `rg "Type:: Incubator"`
- Daily → `rg "Type:: Daily"`
EOF

# =========================================================
# INBOX
# =========================================================

cat > Inbox/README.md << 'EOF'
# Inbox

This is the capture buffer.

Rules:
- Everything lands here first (or via Neovim capture)
- No structure required
- Must be processed weekly
- Items move to:
  - Projects (if real work)
  - Incubator (if ideas)
  - Resources (if knowledge)
EOF

cat > Inbox/Capture.md << 'EOF'
# Inbox Capture

Quick capture file for Neovim + Obsidian.

Append-only list:
EOF

# =========================================================
# PROJECTS
# =========================================================

cat > Projects/README.md << 'EOF'
# Projects

A project is something you actively work on.

## Lifecycle

- Active → currently worked on
- On Hold → paused
- Archive → finished

## Required fields in every project note:

Status:: Active|On Hold|Done
Area:: Work|Home|Personal
Updated:: YYYY-MM-DD
Next Action:: must exist
EOF

# Project template (Neovim-friendly metadata-first)
cat > Templates/Project.md << 'EOF'
# Project Name

Status:: Active
Area:: Work
Updated:: {{date}}

---

## 🎯 Goal
What is the outcome?

---

## 🧭 Next Action
- [ ] Define next concrete step

---

## 📌 Tasks
- [ ] Task

---

## ⛔ Blockers
- None

---

## 🧠 Notes
Freeform context.

---

## 🕒 Work Log
- {{date}} Initial entry
EOF

# =========================================================
# AREAS
# =========================================================

cat > Areas/README.md << 'EOF'
# Areas

Long-term responsibilities.

These never finish.

Examples:
- Family
- Work
- Home
- Music
- Personal Development
EOF

# =========================================================
# RESOURCES
# =========================================================

cat > Resources/README.md << 'EOF'
# Resources

Knowledge base.

This is:
- what you learn
- not what you do

Examples:
- Kubernetes patterns
- .NET concepts
- AI techniques
EOF

# =========================================================
# INCUBATOR (IMPORTANT BACKLOG SYSTEM)
# =========================================================

cat > Incubator/README.md << 'EOF'
# Incubator

Your idea backlog.

Nothing here is committed work.

Includes:
- Tools to evaluate
- Books to read
- Games to try
- Plugins to test
- Project ideas

Rule:
If it's interesting but not active → it goes here.
EOF

# =========================================================
# DAILY SYSTEM
# =========================================================

cat > Daily/README.md << 'EOF'
# Daily Notes

Execution layer of the system.

Each day:
- Plan work
- Capture thoughts
- Track progress
- Log decisions

This is your “what actually happened” record.
EOF

cat > Templates/Daily.md << 'EOF'
# {{date}}

---

## 🎯 Today’s Focus
- 

---

## 📌 Active Tasks
- 

---

## 🧠 Notes / Thinking
- 

---

## 📥 Quick Capture
- 

---

## 🚧 Blocked / Waiting
- 

---

## 📅 Work Log
- 
EOF

# =========================================================
# WORKFLOW GUIDE
# =========================================================

cat > WORKFLOW.md << 'EOF'
# Workflow

## 1. Capture
Everything goes to Inbox (or via Neovim capture system)

## 2. Decide (weekly)
- Projects → active work
- Incubator → ideas
- Resources → knowledge

## 3. Execute
Work happens in:
- Projects
- Daily notes

## 4. Track reality
Daily notes = actual execution log

## 5. Review weekly
Keep system clean

## 6. Archive
Finished work is moved out
EOF

# =========================================================
# INCUBATOR DEFAULT FILES
# =========================================================

cat > Incubator/Project\ Ideas.md << 'EOF'
# Project Ideas

## AI
- Personal coding assistant
- GitHub + docs knowledge bot

## Dev Tools
- Neovim workflow tools
- CLI productivity tools

## Homelab
- Backup monitoring system
- Infrastructure dashboard
EOF



# =========================================================

# TEMPLATES

# =========================================================

cat > Templates/Project.md <<'EOF'

# Project Name

Type:: Project
Status:: Active
Area:: Work
Updated:: {{date}}

---

## 🎯 Goal

What outcome are you trying to achieve?

---

## 🧭 Next Action

* [ ] Define next concrete step

---

## 📌 Tasks

* [ ] Task

---

## 🚧 Blockers

None

---

## 🔗 Related Notes

*

---

## 🧠 Notes

Freeform context, decisions, links, thoughts.

---

## 🕒 Work Log

* {{date}} Created project
  EOF

cat > Templates/Daily.md <<'EOF'

# {{date}}

Type:: Daily
Updated:: {{date}}

---

## 🎯 Today's Focus

*

---

## 📌 Active Tasks

*

---

## 🧠 Notes / Thinking

*

---

## 📥 Quick Capture

*

---

## 🚧 Waiting / Blocked

*

---

## 🔗 Related Projects

*

---

## 🕒 Work Log

*

EOF

cat > Templates/Incubator-Item.md <<'EOF'

# Item Name

Type:: Incubator
Category:: Developer Tools
Status:: Idea
Added:: {{date}}

---

## Why Interesting

*

---

## Links

*

---

## Next Step

* [ ] Evaluate

---

## Notes

*

EOF

cat > Templates/Knowledge-Note.md <<'EOF'

# Topic

Type:: Knowledge
Domain:: Programming
Updated:: {{date}}

---

## Summary

*

---

## Key Points

*

---

## References

*

---

## Related Notes

*

EOF

cat > Templates/Person.md <<'EOF'

# Name

Type:: Person

Birthday::
Relationship::

---

## Important Dates

*

---

## Gift Ideas

*

---

## Notes

*

EOF

cat > Templates/Area.md <<'EOF'

# Area Name

Type:: Area
Updated:: {{date}}

---

## Responsibilities

*

---

## Current Focus

*

---

## Related Projects

*

---

## Notes

*

EOF

echo ""
echo "✅ Vault created: $(pwd)"
echo ""
echo "Recommended next steps:"
echo "1. Install fzf-lua"
echo "2. Install ripgrep"
echo "3. Configure the Neovim vault module"
echo "4. Create your first Daily note"
echo ""


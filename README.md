# Claude Dev Kit

A comprehensive, Claude-native developer environment toolkit.

Optimizes your machine for Claude Code development: shell, editor, git, templates, quality gates, and more.

## Two Ways to Install

| Method | Best For | Experience |
|--------|----------|------------|
| **Claude Code Plugin** | Claude Code users | Interactive, conversational setup |
| **Standalone Script** | Anyone | Traditional CLI installer |

Both methods configure the same things - choose based on your preference.

---

## Option 1: Claude Code Plugin (Interactive)

If you have Claude Code, install as a plugin for the full interactive experience:

```bash
# Add the marketplace (run inside Claude Code)
/add-marketplace auge2u/claude-dev-kit
```

Then start a conversation:

```bash
# Ask Claude to set up your environment
claude "Set up my dev environment"

# Or be specific
claude "Setup shell with powerlevel10k"
claude "Configure VS Code for Claude development"
```

**What you get:**
- Claude walks you through options
- Asks about your preferences
- Adapts to your existing setup
- Explains what it's doing

---

## Option 2: Standalone Script (No Claude Required)

Run directly without Claude Code:

```bash
# One-liner (interactive)
curl -fsSL https://raw.githubusercontent.com/auge2u/claude-dev-kit/main/install.sh | bash

# Or clone first
git clone https://github.com/auge2u/claude-dev-kit.git
cd claude-dev-kit
./install.sh
```

**Fastest install** - no prompts, smart defaults:

```bash
./install.sh --feeling-lucky
```

### Script Options

| Flag | Description |
|------|-------------|
| `--feeling-lucky` | Auto-configure everything with smart defaults |
| `--bundle <name>` | Choose bundle: `minimal`, `standard`, `full` |
| `--non-interactive` | Skip all prompts, use defaults |
| `--help` | Show help |

---

## What Gets Installed

### Bundles

| Bundle | Components | Use Case |
|--------|------------|----------|
| **minimal** | shell | Quick setup, just the essentials |
| **standard** | shell, editor, git, templates | Most developers (default) |
| **full** | all components | Complete optimization |

### Components

| Component | What it does |
|-----------|--------------|
| **Shell** | Zsh, Oh My Zsh, Powerlevel10k, MesloLGS fonts, aliases |
| **Editor** | VS Code/Cursor settings, extensions (GitLens, Error Lens, Prettier) |
| **Git** | Pre-commit hooks, commit templates, PR templates, conventions |
| **Templates** | CLAUDE.md templates, `.claude/` directory scaffolds |
| **Quality** | Linting setup, CI workflows, code review checklists |
| **Memory** | Context management, session export, project memory |

## Installation Modes

The installer detects your environment and adapts:

| Mode | When | Behavior |
|------|------|----------|
| **Greenfield** | Fresh machine, minimal config | Opinionated defaults, fast setup |
| **Adaptation** | Existing setup detected | Respects your config, backs up before changes |

## Updating

```bash
# With Claude Code
claude "update-claude-dev-kit"

# Or re-run install script (idempotent - safe to run multiple times)
./install.sh
```

## Documentation

- [Skills Reference](skills/README.md) - All available skills
- [Testing Guide](docs/TESTING.md) - How to test components
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and fixes
- [Contributing](CONTRIBUTING.md) - How to contribute
- [Changelog](CHANGELOG.md) - Version history

## Requirements

**Required:**
- macOS 12+ or Ubuntu 22.04+
- git, curl

**Optional:**
- [Claude Code](https://claude.ai/code) - For the interactive plugin experience
- VS Code or Cursor - For editor component

## License

MIT

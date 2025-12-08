# Claude Dev Kit

A comprehensive, Claude-native developer environment toolkit.

**Claude installs itself** - the installer is a skill that Claude runs interactively.

## Quick Start

### With Claude Code

```bash
# In Claude Code, simply say:
"Set up my dev environment for Claude"

# Or invoke the skill directly:
Skill: setup-claude-dev-kit
```

### Without Claude Code

```bash
# One-liner installation
curl -fsSL https://raw.githubusercontent.com/claude-dev-kit/claude-dev-kit/main/install.sh | bash

# Or clone and run
git clone https://github.com/claude-dev-kit/claude-dev-kit.git
cd claude-dev-kit
./install.sh
```

## Bundles

| Bundle | Components | Use Case |
|--------|------------|----------|
| **minimal** | shell | Quick setup, just the essentials |
| **standard** | shell, editor, git, templates | Most developers |
| **full** | all components | Complete optimization |

## Components

| Component | Skill | Description |
|-----------|-------|-------------|
| Shell | [`setup-cdk-shell`](skills/shell/SKILL.md) | Zsh, Powerlevel10k, completions, aliases |
| Editor | [`setup-cdk-editor`](skills/editor/SKILL.md) | VS Code/Cursor settings, extensions |
| Git | [`setup-cdk-git`](skills/git/SKILL.md) | Hooks, commit templates, PR workflows |
| Templates | [`setup-cdk-templates`](skills/templates/SKILL.md) | CLAUDE.md templates, project scaffolds |
| Quality | [`setup-cdk-quality`](skills/quality/SKILL.md) | Linting, CI workflows, review automation |
| Memory | [`setup-cdk-memory`](skills/memory/SKILL.md) | Context management, session export |

## Installation Modes

### Greenfield (Fresh Machine)
Opinionated defaults, fast setup, minimal questions.

### Adaptation (Existing Setup)
Respects your config, shows diffs, backs up before changes.

## Install Script Options

```bash
./install.sh [options]
```

| Flag | Description |
|------|-------------|
| `--feeling-lucky` | Auto-configure everything with smart defaults |
| `--bundle <name>` | Choose bundle: minimal, standard, full |
| `--non-interactive` | Skip all prompts, use defaults |
| `--help` | Show help |

**Fastest install:**
```bash
./install.sh --feeling-lucky
```

## Updating

```bash
# With Claude Code
claude "update-claude-dev-kit"

# Or re-run install script (safe to run multiple times)
./install.sh
```

## Documentation

- [Skills Reference](skills/README.md) - All available skills
- [Testing Guide](docs/TESTING.md) - How to test components
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and fixes
- [Contributing](CONTRIBUTING.md) - How to contribute
- [Changelog](CHANGELOG.md) - Version history

## Requirements

- macOS 12+ or Ubuntu 22.04+
- git
- curl

Optional:
- [Claude Code](https://claude.ai/code) - For the full interactive experience
- VS Code or Cursor - For editor component

## License

MIT

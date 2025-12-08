# Claude Dev Kit

A comprehensive, Claude-native developer environment toolkit.

**Claude installs itself** - the installer is a skill that Claude runs interactively.

## Quick Start

```
# In Claude Code, simply say:
"Set up my dev environment for Claude"

# Or invoke the skill directly:
Skill: setup-claude-dev-kit
```

## Bundles

| Bundle | Components | Use Case |
|--------|------------|----------|
| **minimal** | shell | Quick setup, just the essentials |
| **standard** | shell, editor, git, templates | Most developers |
| **full** | all components | Complete optimization |

## Components

| Component | Description |
|-----------|-------------|
| [cdk-shell](https://github.com/claude-dev-kit/cdk-shell) | Zsh, Powerlevel10k, completions, aliases |
| [cdk-editor](https://github.com/claude-dev-kit/cdk-editor) | VS Code/Cursor settings, extensions |
| [cdk-git](https://github.com/claude-dev-kit/cdk-git) | Hooks, commit templates, PR workflows |
| [cdk-templates](https://github.com/claude-dev-kit/cdk-templates) | CLAUDE.md templates, project scaffolds |
| [cdk-quality](https://github.com/claude-dev-kit/cdk-quality) | Linting, testing, review automation |
| [cdk-memory](https://github.com/claude-dev-kit/cdk-memory) | Context/conversation management |

## Installation Modes

### Greenfield (Fresh Machine)
Opinionated defaults, fast setup, minimal questions.

### Adaptation (Existing Setup)
Respects your config, shows diffs, backs up before changes.

## Manual Installation

If you prefer not to use Claude Code:

```bash
# Interactive installation
curl -fsSL https://raw.githubusercontent.com/claude-dev-kit/claude-dev-kit/main/install.sh | bash

# Or with options
./install.sh --bundle standard           # Skip prompts, use standard bundle
./install.sh --bundle minimal --non-interactive   # Fully automated
```

### Options

| Flag | Description |
|------|-------------|
| `--bundle <name>` | Choose bundle: minimal, standard, full |
| `--non-interactive` | Skip all prompts, use defaults |
| `--help` | Show help |

## License

MIT

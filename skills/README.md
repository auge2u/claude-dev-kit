# Claude Dev Kit Skills

This directory contains all CDK skills that Claude Code can use to set up your development environment.

## Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| [Main Installer](SKILL.md) | `setup-claude-dev-kit` | Interactive installer with bundle selection |
| [Shell](shell/SKILL.md) | `setup-cdk-shell` | Zsh, Oh My Zsh, Powerlevel10k, fonts, aliases |
| [Editor](editor/SKILL.md) | `setup-cdk-editor` | VS Code/Cursor settings, extensions, keybindings |
| [Git](git/SKILL.md) | `setup-cdk-git` | Hooks, commit templates, PR templates |
| [Templates](templates/SKILL.md) | `setup-cdk-templates` | CLAUDE.md templates, .claude/ scaffolds |
| [Quality](quality/SKILL.md) | `setup-cdk-quality` | Linting, CI workflows, review checklists |
| [Memory](memory/SKILL.md) | `setup-cdk-memory` | Context management, session export |
| [Update](update/SKILL.md) | `update-claude-dev-kit` | Version checking, component updates |

## Usage

### With Claude Code

```bash
# Full interactive setup
claude "setup-claude-dev-kit"

# Individual components
claude "setup-cdk-shell"
claude "setup-cdk-editor"

# Check for updates
claude "update-claude-dev-kit"
```

### Bundles

| Bundle | Components |
|--------|------------|
| **minimal** | shell |
| **standard** | shell, editor, git, templates |
| **full** | all components |

## Skill Structure

Each skill follows this format:

```markdown
---
name: skill-name
description: One-line description
---

# Title

## Overview
## When to Use
## Quick Reference
## Installation Steps
## Verification
## Adaptation Mode
## Common Issues
```

## Creating New Skills

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on adding new skills.

Key requirements:
- YAML frontmatter with `name` and `description`
- Idempotent commands (safe to run twice)
- Verification steps
- Adaptation mode for existing setups

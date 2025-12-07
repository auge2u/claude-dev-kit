# Claude Dev Kit - Design Document

**Date:** 2025-12-07
**Status:** Approved
**Audience:** Open source community

## Overview

Claude Dev Kit (CDK) is a comprehensive, Claude-native developer environment toolkit. It optimizes development machines for working with Claude Code through an interactive, conversational installation experience.

**Core principle:** Claude installs itself - the installer is a skill that Claude runs interactively.

## Goals

- Get any dev machine Claude-ready fast
- Respect existing developer setups (adaptation mode)
- Modular - use only what you need
- Community-driven with independent component ownership
- Configurable enforcement levels

## Repository Structure

### Meta-repo: `claude-dev-kit`

Orchestrates installation of focused component repos:

```
claude-dev-kit/                    # Meta-repo (orchestrator)
├── SKILL.md                       # Main installer skill
├── install.sh                     # Fallback non-Claude installer
├── registry.json                  # Component repos + versions
└── docs/
    └── plans/
```

### Component Repos

| Repo | Purpose |
|------|---------|
| `cdk-shell` | Shell environment (zsh, p10k, completions, aliases) |
| `cdk-editor` | VS Code/Cursor settings, extensions, keybindings |
| `cdk-git` | Hooks, commit templates, PR templates, CI workflows |
| `cdk-templates` | CLAUDE.md templates, project scaffolds |
| `cdk-quality` | Linting, testing, review automation |
| `cdk-memory` | Context/conversation management tools |

## Component Details

### cdk-shell
- Zsh + Oh My Zsh installation
- Powerlevel10k + MesloLGS NF fonts
- Claude-friendly aliases (`cc`, `ccp`)
- Shell completions for claude CLI
- Optimized `.zshrc` snippets

### cdk-editor
- VS Code/Cursor settings.json optimized for Claude
- Extension pack: GitLens, Error Lens, formatters
- Keybindings for common Claude workflows
- Workspace templates with `.vscode/` pre-configured

### cdk-git
- Pre-commit hooks (lint, format, conventional commits)
- Commit message templates with Claude attribution
- PR templates with test plan sections
- Branch naming conventions
- GitHub Actions for Claude-assisted review

### cdk-templates
- CLAUDE.md templates by project type (web, CLI, library, API, monorepo)
- `.claude/` directory scaffolds with commands/hooks
- Project-type detection and auto-suggestion
- Memory/context optimization patterns

### cdk-quality
- Configurable enforcement levels (advisory/soft/hard)
- Pre-commit hook collection
- CI workflow templates
- Code review checklists as skills

### cdk-memory
- Conversation search/export tools
- Context summarization helpers
- Project memory persistence patterns

## Installation Modes

### Greenfield Mode (Fresh Machine)

**Detection signals:**
- Default shell prompt (no p10k/starship/oh-my-zsh)
- No ~/.gitconfig or minimal config
- VS Code with <5 extensions
- No ~/.claude directory

**Behavior:**
- Opinionated, installs "golden path" defaults
- Fewer questions, faster setup
- Fully configured environment matching best practices

### Adaptation Mode (Existing Setup)

**Detection signals:**
- Custom shell theme/prompt
- Extensive git aliases
- Editor heavily customized
- Existing dotfiles repo

**Behavior:**
- Respectful, merges rather than replaces
- More questions about conflicts
- Enhanced environment preserving user preferences

**Adaptation-specific features:**
1. **Diff before apply** - Show what would change, get approval
2. **Backup everything** - `~/.claude-dev-kit/backups/{date}/`
3. **Merge configs** - Append to `.zshrc` rather than replace
4. **Respect existing** - Don't override working git hooks, extend them
5. **Conflict resolution** - User chooses: keep theirs / try ours / skip

### Adoption Scoring

```
Your environment score: 6/10 Claude-optimized

Missing:
- Shell completions for claude CLI (+1)
- CLAUDE.md in current project (+2)
- Pre-commit hooks (+1)

Already great:
- Fast terminal ✓
- Git configured ✓
```

## Installer Skill Flow

1. **Detect environment** - OS, shell, editor, existing tools
2. **Determine mode** - Greenfield vs Adaptation
3. **Ask bundle preference** - minimal/standard/full or custom
4. **Check dependencies** - Homebrew, git, etc. - offer to install
5. **Install components** - Clone repos, run each component's setup skill
6. **Configure enforcement** - Ask quality gate level per project
7. **Verify installation** - Run checks, show summary
8. **Generate report** - What was installed, next steps

**Key behaviors:**
- Idempotent - safe to re-run, updates rather than duplicates
- Rollback-aware - tracks changes, can undo on failure
- Progress visible - uses TodoWrite for status
- Non-destructive - backs up existing configs

## Registry & Updates

### registry.json

```json
{
  "schema_version": "1.0",
  "components": {
    "shell": {
      "repo": "claude-dev-kit/cdk-shell",
      "version": "1.0.0",
      "min_claude_version": "1.0.0",
      "platforms": ["darwin", "linux"],
      "dependencies": ["git"]
    },
    "editor": {
      "repo": "claude-dev-kit/cdk-editor",
      "version": "1.0.0",
      "platforms": ["darwin", "linux", "win32"],
      "dependencies": []
    },
    "git": {
      "repo": "claude-dev-kit/cdk-git",
      "version": "1.0.0",
      "platforms": ["darwin", "linux", "win32"],
      "dependencies": ["git"]
    },
    "templates": {
      "repo": "claude-dev-kit/cdk-templates",
      "version": "1.0.0",
      "platforms": ["darwin", "linux", "win32"],
      "dependencies": []
    },
    "quality": {
      "repo": "claude-dev-kit/cdk-quality",
      "version": "1.0.0",
      "platforms": ["darwin", "linux", "win32"],
      "dependencies": ["git"]
    },
    "memory": {
      "repo": "claude-dev-kit/cdk-memory",
      "version": "1.0.0",
      "platforms": ["darwin", "linux", "win32"],
      "dependencies": []
    }
  },
  "bundles": {
    "minimal": ["shell"],
    "standard": ["shell", "editor", "git", "templates"],
    "full": ["shell", "editor", "git", "templates", "quality", "memory"]
  },
  "compatibility": {
    "macos": { "min": "12.0" },
    "ubuntu": { "min": "22.04" },
    "windows": { "min": "10" }
  }
}
```

### Update Flow

- `update-claude-dev-kit` skill checks registry for new versions
- Shows changelog summary, asks before updating
- Updates components independently
- Rollback available if update breaks something

## Community Model

- Each component repo accepts PRs independently
- Component maintainers own their domain
- Meta-repo maintainer curates registry versions
- "Verified" vs "Community" component tiers possible

## Next Steps

1. ~~Document design~~ (this document)
2. Scaffold meta-repo and component repos
3. Build core `setup-claude-dev-kit` installer skill
4. Port `setup-powerlevel10k` into `cdk-shell`
5. Build remaining components iteratively

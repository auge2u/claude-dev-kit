# Testing Guide

This document describes how to test Claude Dev Kit components.

## Quick Validation

Run these checks before any release:

```bash
# Validate JSON
python3 -m json.tool registry.json

# Validate shell script
bash -n install.sh

# Check skill frontmatter
for f in skills/*/SKILL.md; do head -5 "$f"; echo "---"; done
```

## Test Environments

### macOS Testing

#### Fresh macOS VM Checklist

- [ ] Clean macOS 12+ installation
- [ ] Default Terminal.app
- [ ] No Homebrew installed
- [ ] Default zsh shell
- [ ] No VS Code installed

#### Test Steps (Greenfield)

1. **Clone repository**
   ```bash
   git clone https://github.com/claude-dev-kit/claude-dev-kit.git
   cd claude-dev-kit
   ```

2. **Run installer**
   ```bash
   ./install.sh --bundle standard
   ```

3. **Verify each component**

   Shell:
   ```bash
   [ -d ~/.oh-my-zsh ] && echo "PASS: Oh My Zsh"
   [ -d ~/.oh-my-zsh/custom/themes/powerlevel10k ] && echo "PASS: p10k"
   ls ~/Library/Fonts/MesloLGS* && echo "PASS: Fonts"
   source ~/.zshrc && echo "PASS: zshrc loads"
   ```

   Git:
   ```bash
   [ -f ~/.gitmessage ] && echo "PASS: Commit template"
   [ -f ~/.gitignore_global ] && echo "PASS: Global gitignore"
   git config --global commit.template && echo "PASS: Template configured"
   ```

4. **Test Claude Code integration** (if installed)
   ```bash
   claude "What skills are available?"
   claude "setup-cdk-shell"  # Should recognize skill
   ```

### Ubuntu Testing

#### Fresh Ubuntu VM Checklist

- [ ] Ubuntu 22.04+ minimal installation
- [ ] Default bash shell
- [ ] git and curl installed
- [ ] No zsh installed
- [ ] No VS Code installed

#### Test Steps (Greenfield)

1. **Install prerequisites**
   ```bash
   sudo apt update
   sudo apt install -y git curl zsh
   ```

2. **Run installer**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/.../install.sh | bash
   ```

3. **Verify installation**
   ```bash
   # Same checks as macOS, adjusted paths
   [ -d ~/.oh-my-zsh ] && echo "PASS: Oh My Zsh"
   ls ~/.local/share/fonts/MesloLGS* && echo "PASS: Fonts"
   ```

## Adaptation Mode Testing

### Existing Shell Setup

Test with pre-existing configurations:

1. **Setup existing config**
   ```bash
   # Install starship prompt
   curl -sS https://starship.rs/install.sh | sh

   # Add custom aliases
   echo 'alias ll="ls -la"' >> ~/.zshrc
   ```

2. **Run installer**
   ```bash
   ./install.sh --bundle minimal
   ```

3. **Verify**
   - [ ] Backup created in `~/.claude-dev-kit/backups/`
   - [ ] Existing aliases preserved
   - [ ] Prompt conflict detected and handled
   - [ ] Can rollback if needed

### Existing Git Setup

1. **Setup existing config**
   ```bash
   git config --global alias.co checkout
   git config --global commit.template ~/.my-template
   ```

2. **Run installer**
   ```bash
   ./install.sh --bundle standard
   ```

3. **Verify**
   - [ ] Existing aliases preserved
   - [ ] Backup of old template made
   - [ ] New template includes Claude attribution

### Existing VS Code Setup

1. **Install extensions manually**
   ```bash
   code --install-extension ms-python.python
   code --install-extension esbenp.prettier-vscode
   ```

2. **Run installer**
   ```bash
   ./install.sh --bundle standard
   ```

3. **Verify**
   - [ ] Existing extensions still installed
   - [ ] New extensions added
   - [ ] Settings merged, not replaced

## Component-Specific Tests

### Shell Component

| Test | Command | Expected |
|------|---------|----------|
| Oh My Zsh installed | `[ -d ~/.oh-my-zsh ]` | Exit 0 |
| p10k theme | `grep powerlevel10k ~/.zshrc` | Match found |
| Fonts installed | `ls ~/Library/Fonts/MesloLGS*` | Files listed |
| Plugins work | `source ~/.zshrc` | No errors |
| Aliases work | `type cc` | Shows alias |

### Editor Component

| Test | Command | Expected |
|------|---------|----------|
| Extensions installed | `code --list-extensions \| grep gitlens` | Match found |
| Settings exist | `[ -f ~/Library/Application\ Support/Code/User/settings.json ]` | Exit 0 |
| Font configured | `grep MesloLGS .../settings.json` | Match found |

### Git Component

| Test | Command | Expected |
|------|---------|----------|
| Template set | `git config --global commit.template` | Path returned |
| Hooks path | `git config --global core.hooksPath` | Path returned |
| Commit validation | `echo "bad" \| git commit --dry-run -F -` | Error |
| Good commit | `echo "feat: test" \| git commit --dry-run -F -` | Success |

### Templates Component

| Test | Command | Expected |
|------|---------|----------|
| Templates exist | `ls ~/.claude-dev-kit/templates/` | Files listed |
| CLAUDE.md template | `[ -f ~/.claude-dev-kit/templates/CLAUDE.md ]` | Exit 0 |
| Commands directory | `[ -d ~/.claude-dev-kit/templates/.claude/commands ]` | Exit 0 |

### Quality Component

| Test | Command | Expected |
|------|---------|----------|
| Config created | `[ -f .cdk-quality.json ]` | Exit 0 |
| Hooks installed | `[ -f .husky/pre-commit ]` | Exit 0 |
| CI workflow | `[ -f .github/workflows/quality.yml ]` | Exit 0 |

### Memory Component

| Test | Command | Expected |
|------|---------|----------|
| Directories created | `[ -d .claude/memory ]` | Exit 0 |
| Export utility | `command -v claude-export` | Path returned |
| Project memory | `[ -f .claude/memory/project.md ]` | Exit 0 |

## Rollback Testing

1. **Create backup state**
   ```bash
   ./install.sh --bundle standard
   # Note backup directory
   ```

2. **Make changes**
   ```bash
   echo "test change" >> ~/.zshrc
   ```

3. **Rollback**
   ```bash
   # Using update skill's rollback function
   # Or manually restore from backup
   cp ~/.claude-dev-kit/backups/YYYY-MM-DD/.zshrc.bak ~/.zshrc
   ```

4. **Verify**
   - [ ] Original config restored
   - [ ] "test change" removed

## CI Testing

The GitHub Actions workflow tests:

1. **JSON validation** - registry.json is valid
2. **Shell syntax** - install.sh has no syntax errors
3. **Skill format** - All skills have proper frontmatter
4. **Cross-platform** - install.sh runs on Ubuntu and macOS

## Edge Cases

### Test These Scenarios

- [ ] Running installer twice (idempotency)
- [ ] Interrupted installation (Ctrl+C mid-install)
- [ ] Missing dependencies (no git, no curl)
- [ ] Read-only filesystem areas
- [ ] Non-standard home directory
- [ ] Corporate proxy environment
- [ ] Slow network (timeout handling)

## Reporting Issues

When reporting test failures, include:

1. OS and version
2. Shell and version
3. Exact command run
4. Full error output
5. Contents of relevant config files
6. Whether this is greenfield or adaptation mode

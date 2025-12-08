# Troubleshooting Guide

Common issues and solutions for Claude Dev Kit.

## Quick Fixes

### "Command not found: claude"

Claude Code CLI is not installed or not in PATH.

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Or check PATH
which claude
echo $PATH
```

### "Icons show as boxes/squares"

Terminal is not using the MesloLGS NF font.

**Fix:**
1. Open terminal preferences
2. Set font to "MesloLGS NF"
3. Restart terminal

**Verify fonts installed:**
```bash
# macOS
ls ~/Library/Fonts/MesloLGS*

# Linux
ls ~/.local/share/fonts/MesloLGS*
fc-list | grep MesloLGS
```

### "Theme not loading"

Powerlevel10k theme not configured in .zshrc.

```bash
# Check current theme
grep ZSH_THEME ~/.zshrc

# Should show:
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Fix:
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
source ~/.zshrc
```

### "Slow terminal startup"

Missing instant prompt configuration.

**Fix:** Add to top of `~/.zshrc`:

```bash
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

### "Git hooks not running"

Hooks path not configured or hooks not executable.

```bash
# Check hooks path
git config --global core.hooksPath

# Make hooks executable
chmod +x ~/.config/git/hooks/*

# Or for project hooks
chmod +x .husky/*
chmod +x .git/hooks/*
```

### "Commit rejected: doesn't follow conventional format"

Commit message doesn't match expected pattern.

**Expected format:**
```
type(scope): subject

body (optional)

footer (optional)
```

**Valid types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `build`, `ci`

**Examples:**
```bash
# Good
git commit -m "feat: add user authentication"
git commit -m "fix(api): handle null response"
git commit -m "docs: update README"

# Bad
git commit -m "updated stuff"
git commit -m "Fix bug"  # Capital letter
git commit -m "feat add feature"  # Missing colon
```

**Bypass (if needed):**
```bash
git commit -m "message" --no-verify
```

### "VS Code extensions not installing"

`code` command not in PATH.

**Fix (macOS):**
1. Open VS Code
2. Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
3. Restart terminal

**Fix (Linux):**
```bash
# Add to PATH
export PATH="$PATH:/usr/share/code/bin"
```

### "Settings not applying in VS Code"

Settings file may have syntax errors.

```bash
# Validate JSON
cat ~/Library/Application\ Support/Code/User/settings.json | python3 -m json.tool

# If error, fix the JSON or restore from backup
cp ~/.claude-dev-kit/backups/*/vscode-settings.json.bak \
   ~/Library/Application\ Support/Code/User/settings.json
```

## Component-Specific Issues

### Shell

| Issue | Cause | Solution |
|-------|-------|----------|
| Oh My Zsh install hangs | Network issue | Check internet, retry |
| Plugins not loading | Not in plugins list | Add to `plugins=(...)` in .zshrc |
| Completions not working | fpath not set | Add `fpath=(~/.zsh/completions $fpath)` |
| p10k configure not found | Theme not sourced | `source ~/.zshrc` first |

### Editor

| Issue | Cause | Solution |
|-------|-------|----------|
| Cursor settings different | Different config path | Check `~/Library/Application Support/Cursor/` |
| Extensions conflict | Incompatible versions | Disable conflicting extension |
| Format on save not working | No formatter configured | Set `editor.defaultFormatter` |

### Git

| Issue | Cause | Solution |
|-------|-------|----------|
| Template not showing | Editor issue | Check `git config core.editor` |
| Hooks in wrong place | Multiple hooks paths | Use one: global OR .husky OR .git/hooks |
| pre-commit too slow | Running too many checks | Adjust `.cdk-quality.json` rules |

### Templates

| Issue | Cause | Solution |
|-------|-------|----------|
| Wrong project type detected | Ambiguous signals | Manually specify or edit generated template |
| CLAUDE.md too long | Too much context | Summarize, focus on essentials |
| Commands not recognized | Wrong directory | Ensure `.claude/commands/` exists |

### Quality

| Issue | Cause | Solution |
|-------|-------|----------|
| Too many lint errors | Strict config | Start with `enforcement: advisory` |
| CI fails but local passes | Different versions | Match Node/Python versions |
| Husky not running | Not initialized | `npx husky install` |

### Memory

| Issue | Cause | Solution |
|-------|-------|----------|
| Export utility not found | Not in PATH | Add `~/.claude-dev-kit/bin` to PATH |
| Memory files getting large | Too much history | Archive old entries |

## Rollback

If something goes wrong, restore from backup:

```bash
# Find latest backup
ls -la ~/.claude-dev-kit/backups/

# Restore specific file
cp ~/.claude-dev-kit/backups/YYYY-MM-DD/.zshrc.bak ~/.zshrc

# Restore all
BACKUP=~/.claude-dev-kit/backups/YYYY-MM-DD
cp "$BACKUP/.zshrc.bak" ~/.zshrc
cp "$BACKUP/.gitconfig.bak" ~/.gitconfig
cp "$BACKUP/vscode-settings.json.bak" ~/Library/Application\ Support/Code/User/settings.json
```

## Clean Reinstall

If all else fails, remove and reinstall:

```bash
# Remove CDK artifacts
rm -rf ~/.claude-dev-kit
rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k

# Restore original configs from backup
# Then re-run installer
./install.sh
```

## Getting Help

1. **Check existing issues:** [GitHub Issues](https://github.com/claude-dev-kit/claude-dev-kit/issues)

2. **Open new issue with:**
   - OS and version
   - Shell and version (`echo $SHELL && $SHELL --version`)
   - Error message (full output)
   - Steps to reproduce
   - Relevant config files

3. **Quick diagnostics:**
   ```bash
   # Collect system info
   uname -a
   echo $SHELL
   $SHELL --version
   code --version 2>/dev/null || echo "VS Code not found"
   git --version
   ls ~/.claude-dev-kit/
   ```

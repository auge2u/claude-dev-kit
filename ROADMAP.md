# Claude Dev Kit - Roadmap

## Current Status

**Phase 1: Foundation** - COMPLETE
- [x] Design document (`docs/plans/2025-12-07-claude-dev-kit-design.md`)
- [x] Repository structure
- [x] Registry with component definitions
- [x] Main installer skill (`skills/SKILL.md`)
- [x] Shell component skill (`skills/shell/SKILL.md`)

## Phase 2: Core Components

### 2.1 Editor Component
**Location:** `skills/editor/SKILL.md`

Build `setup-cdk-editor` skill:
- [ ] VS Code settings.json optimized for Claude
- [ ] Cursor-specific settings variant
- [ ] Extension recommendations (GitLens, Error Lens, etc.)
- [ ] Keybindings for Claude workflows
- [ ] Workspace template with `.vscode/` pre-configured

### 2.2 Git Component
**Location:** `skills/git/SKILL.md`

Build `setup-cdk-git` skill:
- [ ] Pre-commit hooks (lint, format, conventional commits)
- [ ] Commit message template with Claude attribution
- [ ] PR template with test plan section
- [ ] Branch naming convention helper
- [ ] `.gitignore` additions for Claude artifacts

### 2.3 Templates Component
**Location:** `skills/templates/SKILL.md`

Build `setup-cdk-templates` skill:
- [ ] CLAUDE.md templates by project type:
  - [ ] web-app (React, Next.js, Vue)
  - [ ] api (REST, GraphQL)
  - [ ] cli (Node, Python)
  - [ ] library (npm, pip package)
  - [ ] monorepo
- [ ] `.claude/` directory scaffold (commands, hooks)
- [ ] Project type detection logic
- [ ] `create-claude-md` skill for existing projects

## Phase 3: Advanced Components

### 3.1 Quality Component
**Location:** `skills/quality/SKILL.md`

Build `setup-cdk-quality` skill:
- [ ] Enforcement level config (advisory/soft/hard)
- [ ] Pre-commit hook collection
- [ ] CI workflow templates (GitHub Actions)
- [ ] Code review checklist skill
- [ ] Per-project `.cdk-quality.json` config

### 3.2 Memory Component
**Location:** `skills/memory/SKILL.md`

Build `setup-cdk-memory` skill:
- [ ] Conversation search tool
- [ ] Context summarization helper
- [ ] Session export utility
- [ ] Project memory patterns

## Phase 4: Distribution

### 4.1 Fallback Installer
**Location:** `install.sh`

- [ ] Non-Claude installation script
- [ ] Interactive prompts for bundle selection
- [ ] Dependency checking (brew, git, etc.)
- [ ] Cross-platform support (macOS, Linux)

### 4.2 Update Mechanism
**Location:** `skills/update/SKILL.md`

- [ ] `update-claude-dev-kit` skill
- [ ] Version checking against registry
- [ ] Component-level updates
- [ ] Changelog display

### 4.3 GitHub Release
- [ ] Initial commit and push
- [ ] GitHub Actions for releases
- [ ] Documentation site (optional)
- [ ] Community contribution guidelines

## Phase 5: Polish

### 5.1 Testing
- [ ] Test on fresh macOS VM
- [ ] Test on fresh Ubuntu VM
- [ ] Test adaptation mode with existing configs
- [ ] Document edge cases

### 5.2 Documentation
- [ ] Component-specific READMEs
- [ ] Troubleshooting guide
- [ ] Contributing guide
- [ ] Video walkthrough (optional)

---

## Quick Start for Contributors

```bash
cd ~/github/claude-dev-kit-skills

# Read the design first
cat docs/plans/2025-12-07-claude-dev-kit-design.md

# See existing skills
cat skills/SKILL.md          # Main installer
cat skills/shell/SKILL.md    # Shell component

# Build next component
# Pick from Phase 2 above
```

## Priority Order

1. **Editor** - High value, straightforward
2. **Git** - High value, commonly needed
3. **Templates** - Medium value, enables project setup
4. **Quality** - Medium value, team-focused
5. **Memory** - Lower priority, can defer
6. **install.sh** - Needed for non-Claude users
7. **Update mechanism** - Needed before v1.0 release

## Notes

- Each skill should follow the pattern in `skills/shell/SKILL.md`
- Include adaptation mode handling (detect existing, backup, merge)
- Add verification steps at the end
- Keep skills under 500 words where possible

# Claude Dev Kit - Roadmap

## Current Status

**All core phases complete! Ready for release.**

**Phase 1: Foundation** - COMPLETE
- [x] Design document (`docs/plans/2025-12-07-claude-dev-kit-design.md`)
- [x] Repository structure
- [x] Registry with component definitions
- [x] Main installer skill (`skills/SKILL.md`)
- [x] Shell component skill (`skills/shell/SKILL.md`)

## Phase 2: Core Components - COMPLETE

### 2.1 Editor Component
**Location:** `skills/editor/SKILL.md`

Build `setup-cdk-editor` skill:
- [x] VS Code settings.json optimized for Claude
- [x] Cursor-specific settings variant
- [x] Extension recommendations (GitLens, Error Lens, etc.)
- [x] Keybindings for Claude workflows
- [x] Workspace template with `.vscode/` pre-configured

### 2.2 Git Component
**Location:** `skills/git/SKILL.md`

Build `setup-cdk-git` skill:
- [x] Pre-commit hooks (lint, format, conventional commits)
- [x] Commit message template with Claude attribution
- [x] PR template with test plan section
- [x] Branch naming convention helper
- [x] `.gitignore` additions for Claude artifacts

### 2.3 Templates Component
**Location:** `skills/templates/SKILL.md`

Build `setup-cdk-templates` skill:
- [x] CLAUDE.md templates by project type:
  - [x] web-app (React, Next.js, Vue)
  - [x] api (REST, GraphQL)
  - [x] cli (Node, Python)
  - [x] library (npm, pip package)
  - [x] monorepo
- [x] `.claude/` directory scaffold (commands, hooks)
- [x] Project type detection logic
- [x] `create-claude-md` skill for existing projects

## Phase 3: Advanced Components - COMPLETE

### 3.1 Quality Component
**Location:** `skills/quality/SKILL.md`

Build `setup-cdk-quality` skill:
- [x] Enforcement level config (advisory/soft/hard)
- [x] Pre-commit hook collection
- [x] CI workflow templates (GitHub Actions)
- [x] Code review checklist skill
- [x] Per-project `.cdk-quality.json` config

### 3.2 Memory Component
**Location:** `skills/memory/SKILL.md`

Build `setup-cdk-memory` skill:
- [x] Conversation search tool
- [x] Context summarization helper
- [x] Session export utility
- [x] Project memory patterns

## Phase 4: Distribution

### 4.1 Fallback Installer - COMPLETE
**Location:** `install.sh`

- [x] Non-Claude installation script
- [x] Interactive prompts for bundle selection
- [x] Dependency checking (brew, git, etc.)
- [x] Cross-platform support (macOS, Linux)

### 4.2 Update Mechanism - COMPLETE
**Location:** `skills/update/SKILL.md`

- [x] `update-claude-dev-kit` skill
- [x] Version checking against registry
- [x] Component-level updates
- [x] Changelog display
- [x] Rollback support
- [x] Backup before update

### 4.3 GitHub Release - COMPLETE
- [x] GitHub Actions for releases (`.github/workflows/release.yml`)
- [x] CI workflow for validation (`.github/workflows/ci.yml`)
- [x] PR template (`.github/pull_request_template.md`)
- [x] Community contribution guidelines (`CONTRIBUTING.md`)
- [x] Changelog (`CHANGELOG.md`)
- [ ] Initial commit and push (manual step)
- [ ] Documentation site (optional, deferred)

## Phase 5: Polish - COMPLETE

### 5.1 Testing
- [x] Test documentation and checklists (`docs/TESTING.md`)
- [x] CI validation for all components
- [ ] Test on fresh macOS VM (manual step)
- [ ] Test on fresh Ubuntu VM (manual step)

### 5.2 Documentation
- [x] Component-specific READMEs (`skills/README.md`)
- [x] Troubleshooting guide (`docs/TROUBLESHOOTING.md`)
- [x] Contributing guide (`CONTRIBUTING.md`)
- [ ] Video walkthrough (optional, deferred)

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

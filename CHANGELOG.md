# Changelog

All notable changes to Claude Dev Kit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-XX-XX

### Added

#### Core Components
- **Shell** (`setup-cdk-shell`): Zsh, Oh My Zsh, Powerlevel10k, MesloLGS NF fonts, Claude aliases
- **Editor** (`setup-cdk-editor`): VS Code/Cursor settings, extensions, keybindings
- **Git** (`setup-cdk-git`): Pre-commit hooks, commit templates, PR templates, branch helpers
- **Templates** (`setup-cdk-templates`): CLAUDE.md templates for 6 project types, .claude/ scaffolds

#### Advanced Components
- **Quality** (`setup-cdk-quality`): Enforcement levels, CI workflows, review checklists
- **Memory** (`setup-cdk-memory`): Context management, session export, project memory patterns

#### Distribution
- **Main installer** (`setup-claude-dev-kit`): Bundle selection, environment detection
- **Fallback installer** (`install.sh`): Non-Claude installation script
- **Update mechanism** (`update-claude-dev-kit`): Version checking, rollback support

#### Infrastructure
- GitHub Actions CI/CD workflows
- Contributing guidelines
- Comprehensive documentation

### Installation Modes
- **Greenfield**: Opinionated defaults for fresh systems
- **Adaptation**: Respectful merging for existing setups

### Bundles
- **minimal**: Shell only
- **standard**: Shell, Editor, Git, Templates
- **full**: All components including Quality and Memory

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| 1.0.0 | TBD | Initial release with all core components |

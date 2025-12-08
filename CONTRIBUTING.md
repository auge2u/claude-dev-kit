# Contributing to Claude Dev Kit

Thank you for your interest in contributing to Claude Dev Kit!

## Ways to Contribute

### 1. Report Issues

- Bug reports with reproduction steps
- Feature requests with use cases
- Documentation improvements

### 2. Improve Existing Skills

- Fix bugs in skill instructions
- Add missing edge cases
- Improve clarity and conciseness

### 3. Add New Components

- Propose via issue first
- Follow existing skill patterns
- Include tests and documentation

## Skill File Format

Every skill must follow this structure:

```markdown
---
name: skill-name
description: One-line description for skill discovery
---

# Skill Title

## Overview
Brief description (2-3 sentences)

## When to Use
- Bullet list of use cases

## Quick Reference
| Component | Location |
|-----------|----------|
| ... | ... |

## Installation Steps

### 1. Step Title
```bash
# Commands with comments
```

### 2. Next Step
...

## Verification
```bash
# How to verify installation worked
```

## Adaptation Mode
How to handle existing setups

## Common Issues
| Issue | Fix |
|-------|-----|
| ... | ... |
```

## Guidelines

### Keep Skills Concise

- Target under 500 lines
- Focus on essential steps
- Link to external docs for deep dives

### Make Skills Idempotent

- Safe to run multiple times
- Check before creating/modifying
- Use `mkdir -p`, `|| true`, etc.

### Support Adaptation Mode

- Detect existing configurations
- Backup before modifying
- Merge, don't replace

### Include Verification

- Every skill needs verification steps
- User should be able to confirm success
- Provide troubleshooting for failures

## Pull Request Process

1. **Fork and branch**
   ```bash
   git checkout -b feature/my-improvement
   ```

2. **Make changes**
   - Follow the skill format
   - Test on fresh system if possible
   - Update CHANGELOG.md

3. **Validate locally**
   ```bash
   # Check JSON
   python3 -m json.tool registry.json

   # Check bash syntax
   bash -n install.sh

   # Check skill frontmatter
   head -10 skills/*/SKILL.md
   ```

4. **Submit PR**
   - Clear description of changes
   - Reference any related issues
   - Note testing performed

## Commit Messages

Follow conventional commits:

```
feat(shell): add fish shell support
fix(git): handle merge commit messages
docs(memory): clarify session handoff pattern
chore: update dependencies
```

## Testing

### Manual Testing Checklist

Before submitting:

- [ ] Tested on macOS (if applicable)
- [ ] Tested on Linux (if applicable)
- [ ] Tested greenfield mode (fresh system)
- [ ] Tested adaptation mode (existing setup)
- [ ] Verified rollback works
- [ ] Updated documentation

### CI Checks

PRs must pass:

- JSON validation
- Skill frontmatter validation
- Shell script syntax check
- Cross-platform install.sh test

## Code of Conduct

- Be respectful and constructive
- Focus on the work, not the person
- Help newcomers learn

## Questions?

- Open an issue for discussion
- Tag maintainers for urgent items

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---
name: commit
description: Create a well-formatted git commit with conventional commit format. Use when the user asks to commit, write a commit message, stage changes, or create a git commit.
---

Create a git commit following conventional commit format.

## Steps

1. Run `git status` and `git diff --staged` to see changes
2. Analyze what changed (feat/fix/refactor/docs/chore/style/test)
3. Write commit message:

```
<type>(<scope>): <description>

[optional body with details]
```

## Types

- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation
- `chore`: Maintenance
- `style`: Formatting
- `test`: Tests

## Rules

- Description: imperative mood, lowercase, no period
- Scope: feature/module name (customers, auth, api)
- Body: what and why, not how
- Only commit when the user explicitly asks

Run `git add` for unstaged files if needed, then commit.

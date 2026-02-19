---
name: markdownlint
description: "Checks markdown files for style/formatting issues and consistency."
---

# Markdownlint Skill

Run markdownlint to catch style issues and formatting inconsistencies
in markdown files.

## What This Skill Does

- **Linting**: Checks for common markdown issues like header levels, list indentation,
  trailing spaces, etc.
- **Diagnostics by File**: Report errors with file:line format.

## When to Use

- Before committing documentation changes.
- To verify correct markdown syntax.

## How to Use

### Check specific file

```bash
Run markdownlint on README.md
```

### Check entire directory

```bash
Run markdownlint on docs/
```

## Example Output

```text
README.md:1 MD002/first-header-h1 First header should be a top-level header
docs/api.md:5 MD009/no-trailing-spaces Trailing spaces
```

## Integration with Project

This skill uses `npx markdownlint-cli`.

## Typical Workflow

1. **After writing docs**: Ask "Check markdownlint on [file]"
2. **Fix issues**: addressing reported errors.

## Asking the Agent

Use natural language:

- "Check README.md for markdown issues"
- "Run markdownlint on docs/"

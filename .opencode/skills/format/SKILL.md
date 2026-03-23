---
name: format
description: Code formatting with Biome — auto-fix style issues using biome check --write --unsafe (always unsafe, no limits).
---

## What I do

- Format all project files to Biome's defined style
- Auto-fix code style issues (quotes, semicolons, whitespace, sorting)
- Use `--unsafe` flag to apply all aggressive transformations
- Invoked via `bun run fix` — no safety limits, applies all fixes

## When to use me

Use this skill when:

- Before committing code (always run after `bun run lint` fixes)
- After making significant changes to normalize formatting
- When code style looks inconsistent across files
- New files added that need formatting

## Command Reference

```bash
bun run fix                          # Auto-fix all Biome issues (always --unsafe)
biome check --write --unsafe .      # Standalone equivalent
biome check --write --unsafe --dry-run .  # Preview changes without writing
```

## What Gets Fixed

- Quote style (double quotes in TypeScript)
- Semicolon insertion or removal
- Import sorting (alphabetical, must-then-type)
- Whitespace consistency
- Annotation sorting (decorator order, etc.)
- All rules covered by `--unsafe` transformations

## Why --unsafe Always

The `--unsafe` flag enables "all unsafe fixes" — transformations that may change code behavior but are safe style fixes. Always use it here because:

- We want complete normalization, not partial fixes
- Lefthook pre-commit runs this anyway on all files
- Manual intervention for style is not needed — let Biome do it

## Format then Lint Workflow

1. Run `bun run fix` to apply all formatting
2. Run `bun run lint` to verify no remaining issues
3. If lint reports new issues, run `bun run fix` again
4. If issues remain, fix manually or suppress with biome-ignore

## Config Files

- `biome.json` — defines rules, file extensions, and formatter preferences

## Best Practices

- Run `bun run fix` before every commit (or let lefthook handle it)
- Do not manually fight Biome's formatting choices
- If Biome's output looks wrong, check `biome.json` before overriding
- Use `biome-ignore` inline suppressions sparingly and with justification

## Official Docs

https://biomejs.dev/formatter
https://biomejs.dev/linter
https://biomejs.dev/guides/integrate-in-language-repositories/

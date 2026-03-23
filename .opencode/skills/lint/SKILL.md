---
name: lint
description: Code quality validation — run Biome linter and Astro TypeScript checks before commit or CI.
---

## What I do

- Run Biome linter (`biome lint .`) to catch code quality issues
- Run Astro TypeScript checking (`astro check`) for Astro-specific type errors
- Combined into a single `bun run lint` command
- Used for pre-commit validation and CI pipelines

## When to use me

Use this skill when:

- Before committing code (run `bun run lint`)
- During CI/CD validation
- After making changes to verify code quality
- When an agent reports linting or type errors

## Command Reference

```bash
bun run lint             # Run both biome lint + astro check
biome lint .            # Run Biome linter standalone
biome lint --write .    # Auto-fix Biome issues (does not write to files)
astro check             # Run Astro TypeScript checker standalone
```

## What Gets Checked

**Biome lint** catches:

- Unused variables and imports
- Missing accessibility attributes
- Reactivity misuse in SolidJS (proper effect dependencies)
- TypeScript type safety issues
- Code style violations (quotes, semicolons, etc.)
- Security vulnerabilities (eval, innerHTML, etc.)

**Astro check** validates:

- TypeScript types in `.astro` files
- Astro component prop types
- Frontmatter expression types
- Integration configuration types

## Lint then Fix Workflow

1. Run `bun run lint` to discover issues
2. Run `bun run fix` to auto-fix Biome issues (always uses `--unsafe`)
3. Re-run `bun run lint` to verify
4. Manually fix any remaining issues that require attention

## Ignoring Issues

Use inline suppression sparingly — prefer fixing the root cause:

```typescript
// biome-ignore <rule>: <justification>
const x = something; // lint-disable-line equivalent
```

For files that need to opt out entirely, add to `biome.json` `overrides`.

## Config Files

- `biome.json` — Biome linter/formatter configuration
- `astro.config.ts` — Astro adapter and integration settings

## Official Docs

https://biomejs.dev/linter
https://biomejs.dev/configuration
https://docs.astro.build/en/reference/cli-reference/#astro-check

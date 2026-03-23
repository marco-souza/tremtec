---
name: bun
description: Bun package manager and runtime — install deps, run scripts, execute tests, and invoke wrangler for Cloudflare Workers.
---

## What I do

- Install and manage project dependencies
- Run npm-equivalent scripts via `bun run`
- Execute test suites with `bun test`
- Invoke wrangler for Cloudflare Workers development and deployment
- Interact with mise for tool version management

## When to use me

Use this skill when:

- Installing new dependencies (`bun install <package>`)
- Running project scripts (`bun run dev`, `bun run build`, `bun run lint`, etc.)
- Running the test suite (`bun test`, `bun run test:ui`)
- Starting local Cloudflare Worker development (`bun w dev`)
- Building Worker for deployment (`bun w build`)
- Managing tools via mise (`mise install`, `mise use`)

## Commands Reference

### Dependency Management

```bash
bun install              # Install all dependencies
bun add <package>       # Add a dependency
bun remove <package>    # Remove a dependency
bun update              # Update all dependencies
```

### Running Scripts

```bash
bun run <script>        # Run a package.json script (dev, build, lint, test, etc.)
bun run dev             # Start Astro dev server
bun run build           # Build for production
bun run lint            # Run Biome linter + Astro check
bun run fix             # Auto-fix linting issues (biome --write --unsafe)
bun test                # Run Vitest unit tests
bun run test:ui         # Run Vitest with UI dashboard
```

### Wrangler Shortcuts

```bash
bun w dev               # wrangler dev — start local Worker
bun w build             # wrangler build — build Worker for deployment
bun w <cmd>             # Run any wrangler command via bun
```

### Mise Integration

```bash
mise install            # Install tool versions from .mise.toml
mise use <tool>@<ver>  # Set active tool version
mise decrypt            # Decrypt .env files
mise encrypt            # Encrypt .env files
```

## npm Equivalence

| npm                | Bun                |
| ------------------ | ------------------ |
| `npm install`      | `bun install`      |
| `npm run <script>` | `bun run <script>` |
| `npm test`         | `bun test`         |
| `npx <command>`    | `bunx <command>`   |

## Official Docs

https://bun.sh/docs

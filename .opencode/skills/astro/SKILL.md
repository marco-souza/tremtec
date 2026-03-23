---
name: astro
description: Astro v6 web framework — SSR pages, SolidJS islands, Cloudflare adapter, and page routing.
---

## What I do

- Build server-rendered pages with `.astro` files
- Compose SolidJS interactive islands within static/server content
- Configure SSR with Cloudflare Workers adapter
- Handle routing via file-based page conventions
- Run type checking and build validation

## When to use me

Use this skill when:

- Creating or modifying pages in `src/pages/`
- Configuring `astro.config.ts` (SSR, adapters, integrations)
- Adding SolidJS components as interactive islands
- Understanding Astro's rendering modes (static, SSR, hybrid)
- Running dev server, build, or type checks

## Commands Reference

```bash
bun run dev              # Start Astro dev server (localhost:4321)
bun run build            # Build for production
astro preview            # Preview production build locally
astro check             # Run TypeScript type checking
astro add <integration> # Add an integration (solid, tailwind, etc.)
```

## File Conventions

```
src/
├── pages/               # File-based routing (index.astro, about.astro, etc.)
│   └── [slug].astro    # Dynamic route with params
├── ui/                  # SolidJS components (islands)
├── layouts/             # Shared page layouts
└── components/           # Astro components (.astro files)
```

## Rendering Modes

- **Static** (`output: 'static'`) — pre-rendered at build time, no server
- **SSR** (`output: 'server'`) — rendered on request, uses adapter (Cloudflare)
- **Hybrid** (`output: 'hybrid'`) — static by default, SSR opt-in per page

## Cloudflare Adapter

This project uses `@astrojs/cloudflare` for SSR on Cloudflare Workers.

Key config in `astro.config.ts`:

```typescript
import cloudflare from "@astrojs/cloudflare";
export default defineConfig({
  output: "server",
  adapter: cloudflare(),
});
```

## Islands Architecture

SolidJS components are "islands" — interactive components hydrated client-side within static Astro pages.

```astro
---
import Counter from '../ui/Counter.tsx'
---
<Counter client:load />
```

`client:load` hydrates immediately. Use `client:idle` for deferred hydration.

## Project Page Routing

Pages in `src/pages/` map to URL routes:

- `src/pages/index.astro` → `/`
- `src/pages/about.astro` → `/about`
- `src/pages/blog/[slug].astro` → `/blog/:slug`

## Official Docs

https://astro.build
https://docs.astro.build/en/guides/server-side-rendering/
https://developers.cloudflare.com/pages/framework-guides/deploy-an-astro-site/

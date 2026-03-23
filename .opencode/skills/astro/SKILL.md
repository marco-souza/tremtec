---
name: astro
description: Astro v6 web framework — SSR pages, HTMX, Cloudflare adapter, and page routing.
---

## What I do

- Build server-rendered pages with `.astro` files
- Compose HTMX-powered interactive components within static/server content
- Configure SSR with Cloudflare Workers adapter
- Handle routing via file-based page conventions
- Run type checking and build validation

## When to use me

Use this skill when:

- Creating or modifying pages in `src/pages/`
- Configuring `astro.config.ts` (SSR, adapters, integrations)
- Adding HTMX-powered interactive components
- Understanding Astro's rendering modes (static, SSR, hybrid)
- Running dev server, build, or type checks

## Commands Reference

```bash
bun run dev              # Start Astro dev server (localhost:4321)
bun run build            # Build for production
astro preview            # Preview production build locally
astro check             # Run TypeScript type checking
astro add <integration> # Add an integration (tailwind, etc.)
```

## File Conventions

```
src/
├── pages/               # File-based routing (index.astro, about.astro, etc.)
│   └── [slug].astro    # Dynamic route with params
├── ui/                  # Astro components and HTMX elements
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

## HTMX Integration

HTMX is used for progressive enhancement of forms and interactive elements.

```astro
<form hx-post="/api/contact" hx-target="#form-response" hx-swap="innerHTML">
  <input name="email" type="email" />
  <button type="submit">Send</button>
</form>
<div id="form-response"></div>
```

HTMX attributes:

- `hx-post`, `hx-get`, `hx-put`, `hx-delete` — HTTP method
- `hx-target` — CSS selector for target element
- `hx-swap` — swap strategy (innerHTML, outerHTML, etc.)
- `hx-indicator` — element to show during request

## Project Page Routing

Pages in `src/pages/` map to URL routes:

- `src/pages/index.astro` → `/`
- `src/pages/about.astro` → `/about`
- `src/pages/blog/[slug].astro` → `/blog/:slug`

## Official Docs

https://astro.build
https://docs.astro.build/en/guides/server-side-rendering/
https://developers.cloudflare.com/pages/framework-guides/deploy-an-astro-site/
https://htmx.org/docs/

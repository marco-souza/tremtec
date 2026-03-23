---
name: hono
description: Hono v4 backend API framework — routes, middleware, Zod validation, and Cloudflare Workers binding.
---

## What I do

- Define typed API routes with method handlers (GET, POST, PUT, DELETE)
- Compose middleware chains for auth, CORS, logging, and request parsing
- Validate request data with Zod schemas via @hono/zod-validator
- Bind to Cloudflare Workers environment and context
- Serve as the HTTP layer between Astro pages and domain services

## When to use me

Use this skill when:

- Creating or modifying API routes in `src/server/`
- Adding new middleware (auth, cors, error handling)
- Defining request/response schemas with Zod
- Accessing Cloudflare environment variables or context
- Setting up route validation for incoming requests

## Route Pattern

Routes are registered in `src/server/index.ts` using Hono's fluent API:

```typescript
import { Hono } from "hono";
import { cors } from "hono/cors";
import { bearerAuth } from "hono/bearer-auth";
import type { Variables } from "./types";

const app = new Hono<{ Variables: Variables }>();

app.use("*", cors());
app.use("/api/*", bearerAuth());

app.get("/api/resource", (c) => c.json({ ok: true }));
app.post("/api/resource", async (c) => {
  const body = await c.req.json();
  return c.json({ received: body }, 201);
});

export default app;
```

## Zod Validation

Use `@hono/zod-validator` to validate request data:

```typescript
import { zValidator } from "@hono/zod-validator";
import { z } from "zod";

const schema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});

app.post("/api/users", zValidator("json", schema), async (c) => {
  const { email, name } = c.req.valid("json");
  // types are inferred from schema
});
```

## Cloudflare Workers Binding

Hono runs on Cloudflare Workers. Access env and ctx:

```typescript
app.get("/api/data", (c) => {
  const env = c.env as { DB: D1Database; KV: KVNamespace };
  const ctx = c.executionCtx;
  return c.json({ workerName: ctx.runtime });
});
```

## Project Middleware Example

This project's middleware is defined in `src/middleware.ts`:

- OAuth providers setup (GitHub, Google)
- Session cookie handling
- Request logging and error handling

## Request/Response Pattern

- Read body: `await c.req.json()` or `await c.req.parseBody()`
- Read headers: `c.req.header('Authorization')`
- Read query: `c.req.query('key')`
- Return JSON: `c.json(data, statusCode)`
- Return empty: `c.body(null, 204)`

## Official Docs

https://hono.dev
https://hono.dev/docs/middleware/builtin/cors
https://hono.dev/docs/middleware/builtin/bearer-auth
https://hono.dev/docs/validators/zod-validator

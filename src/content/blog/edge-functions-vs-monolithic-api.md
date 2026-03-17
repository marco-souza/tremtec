---
title: "Edge Functions: The Death of the Monolithic API?"
description: "Exploring the shift from monolithic APIs to edge functions, the trade-offs involved, and when each architecture makes sense."
date: 2026-03-12
author: "TremTec Team"
tags: ["Edge Computing", "Architecture", "API Design"]
---

For the past decade, the default architecture for web applications has been clear: a monolithic API server—usually REST or GraphQL—handling all backend logic. Deploy it to AWS, put a load balancer in front, scale horizontally when traffic grows.

That model is being disrupted. Edge functions—lightweight compute units running in hundreds of data centers worldwide—are challenging the monolith's dominance. After building with both approaches extensively, here's our analysis of when to use what.

## The Traditional Monolith

First, let's acknowledge what the monolithic API gets right.

### Monolith Architecture

```
User Request
  → CDN (Static Assets)
  → Load Balancer
  → API Server (us-east-1)
    → Business Logic
    → Database Query
    → External API Call
  ← Response (50-200ms + latency)
```

**The monolith excels at:**

- Complex transactions across multiple entities
- Heavy computational work
- Long-running processes
- Stateful operations
- When you need a debugger and stack traces

### When Monoliths Shine

**Complex Business Logic:**
An e-commerce checkout flow involving inventory, payments, shipping, and notifications is easier to reason about in one codebase.

**Team Familiarity:**
Most engineers understand request/response cycles. The mental model is straightforward.

**Tooling Maturity:**
Debuggers, profilers, APM tools—everything assumes a long-running server process.

**Stateful Operations:**
WebSockets, server-sent events, and session management are simpler with persistent connections.

<div class="callout callout-info">
  <div class="callout-title">The Monolith Isn't Dead</div>
  <p>We're not saying monoliths are obsolete. For many applications, they're still the right choice. The goal is to understand the trade-offs, not to chase the newest shiny technology.</p>
</div>

## Enter Edge Functions

Edge functions (also called edge workers, cloud functions at the edge) run on lightweight isolates in data centers close to users. Instead of one server in Virginia, you have code running in 300+ locations worldwide.

### Edge Function Architecture

```
User in São Paulo
  → Cloudflare Edge (GRU - 5ms away)
    → Edge Function executes
      → Cache hit? Return immediately
      → Cache miss? Fetch from origin
    → Response (< 50ms total)
```

**Key characteristics:**

- **Cold start:** Effectively zero ( isolates spin up in <1ms)
- **Runtime limits:** Usually 50ms - 30 seconds
- **Memory limits:** 128MB - 512MB typically
- **No persistent connections:** Request/response only
- **Global by default:** Code runs at the edge, everywhere

### The Performance Difference

We migrated a client's API from a traditional Node.js server on EC2 to Cloudflare Workers. Here's what changed:

| Metric             | EC2 (us-east-1) | Cloudflare Workers | Improvement     |
| ------------------ | --------------- | ------------------ | --------------- |
| Global p50 latency | 120ms           | 25ms               | **80% faster**  |
| Global p99 latency | 450ms           | 85ms               | **81% faster**  |
| Cold start         | 2-5 seconds     | <1ms               | **~instant**    |
| Availability       | 99.9%           | 99.99%             | **10x better**  |
| Monthly cost       | $450            | $45                | **90% cheaper** |

_Note: Latency measured from 10 global locations using Pingdom_

## The Trade-Off Matrix

Neither architecture is universally better. Here's our decision framework:

| Factor                  | Monolith                    | Edge Functions             |
| ----------------------- | --------------------------- | -------------------------- |
| **Latency**             | Higher (single region)      | Lower (global edge)        |
| **Complexity ceiling**  | High (unlimited)            | Medium (limited runtime)   |
| **Cold starts**         | Seconds                     | Milliseconds               |
| **Stateful operations** | Native                      | Requires external store    |
| **Debugging**           | Excellent (attach debugger) | Limited (logs only)        |
| **Vendor lock-in**      | Lower (can migrate)         | Higher (platform-specific) |
| **Operational cost**    | Higher (servers, scaling)   | Lower (pay per request)    |
| **Local development**   | Easy                        | Requires emulation         |
| **Ecosystem**           | Mature                      | Growing rapidly            |

### When to Choose Edge Functions

**1. Globally Distributed Users**

If your users are worldwide, edge functions eliminate the "speed of light tax." A request from Sydney to Virginia takes 200ms just for the round trip. To Sydney's edge node: 20ms.

**2. High-Volume, Low-Complexity Operations**

Authentication, A/B testing, personalization, geolocation—these are perfect for the edge. They're read-heavy, stateless, and latency-sensitive.

**3. JAMstack/Static Sites with Dynamic Needs**

Static sites are fast and cheap. Edge functions let you add dynamic elements (auth, forms, APIs) without managing servers.

**4. Cost Sensitivity at Scale**

At high request volumes, edge functions often cost less than maintaining servers—even accounting for the database queries that still hit your origin.

### When to Stick with Monoliths

**1. Complex Transactions**

Multi-step operations that must succeed or fail atomically are harder to implement reliably at the edge.

**2. Heavy Computation**

Image processing, video transcoding, ML inference—these exceed edge function limits or would be prohibitively expensive.

**3. Stateful Real-Time Features**

WebSockets, collaborative editing, live gaming—these need persistent connections that edge functions don't support.

**4. Existing Team Expertise**

If your team knows Express.js inside and out, the productivity hit of learning edge function patterns might not be worth it.

## Real-World Architecture Patterns

### Pattern 1: Edge-First with Origin Fallback

Use edge functions for everything possible. Fall back to origin only when necessary.

```ts
// Cloudflare Worker example
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    // Handle auth at the edge
    if (url.pathname.startsWith("/api/auth/")) {
      return handleAuth(request, env);
    }

    // Handle personalization at the edge
    if (url.pathname === "/api/user/preferences") {
      return getUserPreferences(request, env);
    }

    // Everything else goes to origin
    return fetch(request);
  },
};

async function handleAuth(request: Request, env: Env): Promise<Response> {
  const token = request.headers.get("Authorization")?.replace("Bearer ", "");

  if (!token) {
    return new Response("Unauthorized", { status: 401 });
  }

  // Validate JWT at the edge
  const isValid = await validateJWT(token, env.JWT_SECRET);

  if (!isValid) {
    return new Response("Invalid token", { status: 401 });
  }

  return new Response("OK", { status: 200 });
}
```

**Pros:**

- Auth is fast (no origin round-trip)
- Reduced load on origin server
- Global performance

**Cons:**

- Split logic between edge and origin
- Debugging across boundaries

### Pattern 2: API Routes on the Edge

Move your entire API to edge functions. Use external services for state.

```ts
// Hono on Cloudflare Workers
import { Hono } from "hono";
import { authMiddleware } from "./middleware/auth";

const app = new Hono<{ Bindings: Env }>();

app.use("/api/*", authMiddleware);

app.get("/api/users/:id", async (c) => {
  const userId = c.req.param("id");

  // Query D1 (Cloudflare's edge database)
  const user = await c.env.DB.prepare("SELECT * FROM users WHERE id = ?")
    .bind(userId)
    .first();

  if (!user) {
    return c.json({ error: "Not found" }, 404);
  }

  return c.json(user);
});

app.post("/api/orders", async (c) => {
  const body = await c.req.json();

  // Validate
  const result = OrderSchema.safeParse(body);
  if (!result.success) {
    return c.json({ error: result.error }, 400);
  }

  // Write to database
  const order = await createOrder(c.env.DB, result.data);

  // Queue background job
  await c.env.ORDER_QUEUE.send({
    orderId: order.id,
    action: "process-payment",
  });

  return c.json(order, 201);
});

export default app;
```

**Pros:**

- Single codebase
- Type safety end-to-end
- No cold starts

**Cons:**

- Runtime limits constrain complexity
- Database must be edge-compatible

### Pattern 3: Hybrid Monolith with Edge Layer

Keep your monolith, but add an edge layer for specific use cases.

```
┌─────────────────────────────────────────┐
│           Edge Layer                    │
│  - Authentication                       │
│  - Rate limiting                        │
│  - A/B testing                          │
│  - Personalization                      │
└─────────────────┬───────────────────────┘
                  │
        ┌─────────┴──────────┐
        │   Monolith API     │
        │  - Business logic  │
        │  - Complex queries │
        │  - Transactions    │
        └─────────┬──────────┘
                  │
        ┌─────────┴──────────┐
        │    Database        │
        └────────────────────┘
```

**When this works:**

- Existing monolith you can't rewrite
- Specific latency-sensitive operations to optimize
- Gradual migration strategy

## The State Problem

The biggest challenge with edge functions is state. By design, they're stateless and ephemeral. So where does your data live?

### Option 1: Edge Databases

Services like Cloudflare D1, Turso, and PlanetScale offer databases at the edge:

| Service       | Type     | Latency | Best For                        |
| ------------- | -------- | ------- | ------------------------------- |
| Cloudflare D1 | SQLite   | <50ms   | Read-heavy, small data          |
| Turso         | SQLite   | <100ms  | Global apps, offline-first      |
| PlanetScale   | MySQL    | <20ms   | Large datasets, complex queries |
| Fauna         | Document | <50ms   | Global consistency needs        |

```ts
// Using Cloudflare D1
const user = await env.DB.prepare("SELECT * FROM users WHERE email = ?")
  .bind(email)
  .first();
```

**Pros:**

- Query at the edge
- Low latency
- No connection pooling needed

**Cons:**

- Limited to supported databases
- Migration complexity
- Vendor lock-in

### Option 2: Cache-First with Origin Fallback

Use KV stores (Redis, Cloudflare KV) for reads. Fall back to origin for writes.

```ts
export async function getUser(userId: string, env: Env): Promise<User> {
  // Try cache first
  const cached = await env.USER_CACHE.get(`user:${userId}`);
  if (cached) {
    return JSON.parse(cached);
  }

  // Cache miss - fetch from origin
  const user = await fetch(`${env.ORIGIN_API}/users/${userId}`).then((r) =>
    r.json(),
  );

  // Populate cache
  await env.USER_CACHE.put(`user:${userId}`, JSON.stringify(user), {
    expirationTtl: 3600, // 1 hour
  });

  return user;
}
```

**Pros:**

- Works with existing databases
- Reduced load on origin
- Fast reads

**Cons:**

- Stale data possible
- Cache invalidation complexity
- Writes still hit origin

### Option 3: Regional Databases with Smart Routing

Use traditional databases, but route requests to the nearest region.

```ts
// Route to nearest database replica
const regions = ["us-east", "eu-west", "ap-south"];
const nearest = getNearestRegion(request.cf?.colo);
const db = getDatabaseForRegion(nearest);
```

**Pros:**

- Use any database
- Full SQL capabilities
- Read replicas for scale

**Cons:**

- Complexity of multi-region setup
- Write latency to primary region
- Conflict resolution for writes

<div class="callout callout-warning">
  <div class="callout-title">The CAP Theorem Still Applies</div>
  <p>Edge computing doesn't eliminate distributed systems challenges. You still trade off between consistency and availability. Choose your state strategy based on your actual requirements, not what's theoretically elegant.</p>
</div>

## Our Recommendation

After building with both approaches, here's our current thinking:

### Start with the Edge When:

- You're building a new application
- Your users are globally distributed
- Your API surface is primarily CRUD operations
- You want to minimize operational overhead

### Start with a Monolith When:

- You're migrating an existing application
- You have complex business logic
- Your team is new to distributed systems
- You need debugging and observability maturity

### The Hybrid Path

Most applications we build use both:

```
┌─────────────────────────────────────────┐
│  Static Site (Astro)                    │
│  - Marketing pages                      │
│  - Documentation                        │
│  - Blog                                 │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Edge Functions (Cloudflare Workers)    │
│  - Authentication                       │
│  - API routes                           │
│  - Personalization                      │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  Database (D1 / PostgreSQL)             │
│  - User data                            │
│  - Application state                    │
└─────────────────────────────────────────┘
```

This gives us:

- **Global performance** from the edge
- **Simplicity** from a unified codebase
- **Cost efficiency** from serverless scaling
- **Developer experience** from modern tooling

## The Future

We're watching several trends that will shape this space:

1. **WebAssembly at the Edge:** Run any language, not just JavaScript
2. **Edge-First Databases:** SQLite-based solutions maturing rapidly
3. **Framework Integration:** Next.js, Remix, SvelteKit all adding edge primitives
4. **Standardization:** WinterCG working to standardize edge runtime APIs

The line between "edge" and "origin" will blur. What matters is choosing the right tool for your specific constraints—latency requirements, team expertise, and operational capacity.

## Final Thoughts

Edge functions aren't the death of the monolithic API. They're an expansion of the architectural toolkit. The monolith remains valid for many use cases. But for globally distributed, latency-sensitive applications, edge functions offer compelling advantages.

The best architects don't pick winners—they understand trade-offs and choose appropriately.

---

_Need help architecting your next application? [Contact us](/contact) to discuss edge vs. monolith strategies._

---
title: "LLMs Detach You From Your Code — And That's Dangerous"
description: "AI code generation is powerful, but it creates a subtle problem: engineers stop understanding what they ship. Here's how to stay in control."
date: 2026-03-07
author: "TremTec Team"
tags: ["AI", "Engineering Culture", "Code Quality"]
---

Here's a pattern we've seen in every team that adopts AI-assisted coding without guardrails: velocity goes up, understanding goes down. Six months later, nobody can explain why the system works the way it does.

We call it **the detachment problem**.

## The Illusion of Productivity

An engineer prompts an LLM: _"Create an authentication middleware with JWT validation and session refresh."_ Thirty seconds later, they have 80 lines of working code:

```ts
// LLM-generated — looks clean, passes tests
export async function authMiddleware(c: Context, next: Next) {
  const token = c.req.header("Authorization")?.replace("Bearer ", "");

  if (!token) {
    return c.json({ error: "Unauthorized" }, 401);
  }

  try {
    const payload = await verify(token, c.env.JWT_SECRET);

    if (payload.exp && payload.exp < Date.now() / 1000) {
      const newToken = await sign(
        { sub: payload.sub, exp: Math.floor(Date.now() / 1000) + 3600 },
        c.env.JWT_SECRET,
      );
      c.header("X-Refreshed-Token", newToken);
    }

    c.set("user", { id: payload.sub, email: payload.email });
    await next();
  } catch {
    return c.json({ error: "Invalid token" }, 401);
  }
}
```

Looks reasonable. Ships to production. But ask the engineer:

- _Why refresh tokens in middleware instead of a dedicated endpoint?_
- _What happens if `JWT_SECRET` rotates?_
- _Is the 1-hour expiry a security decision or an arbitrary default?_

Silence. The code works. Nobody knows _why_ it works this way.

## The Three Stages of Detachment

### Stage 1: Copy-Paste Confidence

Engineers accept LLM output with minor tweaks. Tests pass, PR gets merged. The dangerous part: the code _looks_ like something the team wrote, so reviewers treat it as understood.

### Stage 2: Architecture Drift

Each LLM session makes locally optimal decisions without awareness of the broader system. Over weeks, the codebase accumulates contradictory patterns:

```ts
// File A — LLM session 1 chose this pattern
const user = await db.query.users.findFirst({
  where: eq(users.id, userId),
});

// File B — LLM session 2 chose a different pattern
const user = await db.select().from(users).where(eq(users.id, userId)).get();

// File C — LLM session 3 introduced a repository layer
const user = await userRepository.findById(userId);
```

Three patterns for the same operation. Each works. None was a deliberate decision.

### Stage 3: Learned Helplessness

Engineers stop trying to understand generated code. Bug reports turn into new LLM prompts instead of debugging sessions. The team loses the skill of reading and reasoning about code — the very skill that makes them engineers.

## How to Stay in Control

### 1. Treat LLM Output as a Draft, Not a Solution

The LLM writes the first version. The engineer rewrites it to match the team's patterns and conventions:

```ts
// Before: LLM-generated (generic, unfamiliar patterns)
export async function authMiddleware(c: Context, next: Next) {
  const token = c.req.header("Authorization")?.replace("Bearer ", "");
  // ... 30 lines of inline logic
}

// After: Engineer-refined (follows team conventions)
export const authMiddleware = createMiddleware(async (c, next) => {
  const token = extractBearerToken(c.req);
  const session = await validateSession(token, c.env);

  if (!session.valid) {
    return unauthorized(c, session.reason);
  }

  c.set("session", session);
  await next();
});
```

The second version uses the team's `createMiddleware` helper, domain functions, and error patterns. An engineer wrote it _with understanding_.

### 2. Mandate "Explain Before You Merge"

Add a simple rule to code reviews: if you can't explain _why_ a piece of code works the way it does, it doesn't get merged. Not the _what_ — the _why_.

```md
## PR Checklist

- [ ] Tests pass
- [ ] Linter clean
- [ ] **I can explain every non-obvious decision in this diff**
```

### 3. Use LLMs for Exploration, Not Production

LLMs are exceptional for:

- Exploring unfamiliar APIs quickly
- Generating test data and fixtures
- Prototyping approaches before committing to one
- Explaining existing code you didn't write

They're dangerous for:

- Writing production code you haven't reviewed line-by-line
- Making architectural decisions
- Choosing between implementation patterns

### 4. Enforce Consistency With Tooling, Not Discipline

Don't rely on engineers to manually match patterns. Encode decisions in linters, generators, and templates:

```ts
// biome.json — enforce consistent import patterns
{
  "linter": {
    "rules": {
      "style": {
        "useImportType": "error"
      }
    }
  }
}
```

```ts
// Domain template — new services follow this shape
export function createDomainService<T extends z.ZodType>(config: {
  schema: T;
  validate: (input: z.infer<T>) => Promise<Result>;
}) {
  return {
    execute: async (input: unknown) => {
      const parsed = config.schema.safeParse(input);
      if (!parsed.success) return err(parsed.error);
      return config.validate(parsed.data);
    },
  };
}
```

When the pattern is encoded in a function, LLM-generated code that doesn't use it fails review automatically.

## The Bottom Line

LLMs are the most powerful productivity tool engineers have ever had. But productivity without understanding is technical debt with a delayed fuse.

The teams that win aren't the ones that generate the most code. They're the ones that **understand every line they ship**.

Use AI to move faster. But never let it think for you.

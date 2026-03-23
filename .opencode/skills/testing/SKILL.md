---
name: testing
description: Vitest unit testing — write tests for domain services and Astro components.
---

## What I do

- Run unit tests for domain services (pure business logic)
- Write tests for Astro components
- Mock external dependencies (DB, HTTP, modules)
- Verify test coverage and pass/fail status
- Provide an interactive UI dashboard for test exploration

## When to use me

Use this skill when:

- Writing unit tests for domain services in `src/domain/*/service.ts`
- Writing tests for Astro components in `src/ui/components/`
- Running the test suite during development or CI
- Debugging test failures with the Vitest UI
- Mocking modules or functions for isolated testing

## Commands Reference

```bash
bun test                # Run all tests in watch mode (default)
bun test run           # Run tests once (CI mode)
bun run test:ui        # Open Vitest UI dashboard
vitest run --coverage  # Run with coverage report
```

## Test File Naming

Test files are co-located with source files using `.test.ts` suffix:

```
src/domain/auth/service.ts
src/domain/auth/service.test.ts    ← unit test
src/ui/components/Button.astro
src/ui/components/Button.test.ts   ← component test
```

## Vitest API

```typescript
import { describe, it, expect, beforeEach, vi } from "vitest";

describe("UserService", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it("creates a user with valid data", async () => {
    const result = await createUser({ email: "test@example.com" });
    expect(result.email).toBe("test@example.com");
  });

  it("throws on invalid email", async () => {
    await expect(createUser({ email: "invalid" })).rejects.toThrow(
      "Invalid email",
    );
  });
});
```

## Common Queries

```typescript
screen.getByText("label"); // Find by text content
screen.getByRole("button", { name: /ok/i }); // Find by role + accessible name
screen.getByLabelText("Email"); // Find by label association
screen.queryByText("loading"); // Returns null if not found (not throws)
screen.findByText("loaded"); // Async, waits for element
container.querySelector(".class"); // Raw DOM query
```

## Mocking

```typescript
import { vi } from "vitest";

// Mock a module
vi.mock("./api-client", () => ({
  fetchUser: vi.fn().mockResolvedValue({ id: 1, name: "Alice" }),
}));

// Mock a single function
vi.spyOn(window, "fetch").mockResolvedValue(new Response("ok"));

// Mock timers
vi.useFakeTimers();
vi.advanceTimersByTime(1000);
vi.useRealTimers();
```

## Best Practices

- Test behavior, not implementation (test outputs, not internals)
- Use `queryBy*` for assertions on absent elements
- Use `findBy*` for async elements that appear after data loads
- Keep tests focused — one assertion concept per test
- Mock at the boundary (external services, not internal modules)

## Official Docs

https://vitest.dev
https://vitest.dev/api/expect
https://vitest.dev/api/vi

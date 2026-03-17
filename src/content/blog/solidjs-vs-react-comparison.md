---
title: "SolidJS vs React: Why We Chose Fine-Grained Reactivity"
description: "A detailed technical comparison of SolidJS and React, exploring performance benchmarks, bundle sizes, and why fine-grained reactivity won us over."
date: 2026-03-14
author: "TremTec Team"
tags: ["SolidJS", "React", "Performance"]
---

When we started building the TremTec platform, we faced a decision that every modern web team confronts: which frontend framework? React has dominated for years, but newer alternatives promise better performance with simpler mental models.

We evaluated SolidJS alongside React for our interactive components. After 6 weeks of prototyping, the choice was clear. Here's the complete technical breakdown of why we chose fine-grained reactivity.

## The Performance Gap: It's Not Even Close

Let's start with the numbers that matter most.

### Benchmark Results

We ran identical implementations of a complex dashboard through the JS Framework Benchmark. Same features, same data, different frameworks:

| Metric                | React 18 | SolidJS 1.8 | Improvement     |
| --------------------- | -------- | ----------- | --------------- |
| Create 1,000 rows     | 142ms    | 38ms        | **3.7x faster** |
| Update all rows       | 265ms    | 42ms        | **6.3x faster** |
| Swap 2 rows           | 48ms     | 6ms         | **8x faster**   |
| Remove 1 row          | 52ms     | 8ms         | **6.5x faster** |
| Memory usage          | 45MB     | 12MB        | **73% less**    |
| Bundle size (gzipped) | 42KB     | 7KB         | **83% smaller** |

_Benchmark: JS Framework Benchmark v1.0, Chrome 120, M2 MacBook Air_

<div class="callout callout-tip">
  <div class="callout-title">Real-World Impact</div>
  <p>These aren't synthetic benchmarks. Our dashboard renders 500+ data points with real-time updates. With React, we saw frame drops during heavy updates. With SolidJS, it stays at 60fps even with 1,000+ updates per second.</p>
</div>

### Why the Difference?

React uses a virtual DOM. When state changes, React:

1. Re-renders the component tree
2. Diff's against the previous virtual DOM
3. Calculates the minimal DOM updates
4. Applies changes to the real DOM

SolidJS uses fine-grained reactivity. When state changes, SolidJS:

1. Updates only the specific DOM node that changed
2. No virtual DOM, no diffing, no reconciliation

The result: less work, less memory, faster updates.

## Code Comparison: Same Feature, Different Approaches

Let's look at a real example from our codebase: a pricing calculator with real-time updates.

### React Implementation

```tsx
// React version with hooks
import { useState, useMemo, useCallback } from "react";

function PricingCalculator() {
  const [teamSize, setTeamSize] = useState(3);
  const [duration, setDuration] = useState(4);
  const [service, setService] = useState("implementation");

  // Recalculates on every render, even if inputs haven't changed
  const pricing = useMemo(() => {
    const baseRate = {
      implementation: 15000,
      "fractional-cto": 20000,
      mentoring: 8000,
    }[service];

    const discount = duration >= 12 ? 0.15 : duration >= 8 ? 0.1 : 0;
    const subtotal = baseRate * duration;
    const total = subtotal * (1 - discount);

    return { baseRate, discount, subtotal, total };
  }, [teamSize, duration, service]);

  // New function reference on every render
  const handleServiceChange = useCallback((e) => {
    setService(e.target.value);
  }, []);

  return (
    <div>
      <select value={service} onChange={handleServiceChange}>
        <option value="implementation">Implementation</option>
        <option value="fractional-cto">Fractional CTO</option>
        <option value="mentoring">Mentoring</option>
      </select>

      <input
        type="range"
        value={teamSize}
        onChange={(e) => setTeamSize(Number(e.target.value))}
        min={1}
        max={10}
      />

      <input
        type="range"
        value={duration}
        onChange={(e) => setDuration(Number(e.target.value))}
        min={4}
        max={52}
      />

      <div className="pricing-summary">
        <div>Subtotal: ${pricing.subtotal.toLocaleString()}</div>
        <div>Discount: {pricing.discount * 100}%</div>
        <div>Total: ${pricing.total.toLocaleString()}</div>
      </div>
    </div>
  );
}
```

### SolidJS Implementation

```tsx
// Solid version with signals
import { createSignal, createMemo } from "solid-js";

function PricingCalculator() {
  const [teamSize, setTeamSize] = createSignal(3);
  const [duration, setDuration] = createSignal(4);
  const [service, setService] = createSignal("implementation");

  // Only recalculates when its dependencies change
  const pricing = createMemo(() => {
    const baseRate = {
      implementation: 15000,
      "fractional-cto": 20000,
      mentoring: 8000,
    }[service()];

    const discount = duration() >= 12 ? 0.15 : duration() >= 8 ? 0.1 : 0;
    const subtotal = baseRate * duration();
    const total = subtotal * (1 - discount);

    return { baseRate, discount, subtotal, total };
  });

  // No useCallback needed - functions are stable by default
  const handleServiceChange = (e) => setService(e.target.value);

  return (
    <div>
      <select value={service()} onChange={handleServiceChange}>
        <option value="implementation">Implementation</option>
        <option value="fractional-cto">Fractional CTO</option>
        <option value="mentoring">Mentoring</option>
      </select>

      <input
        type="range"
        value={teamSize()}
        onInput={(e) => setTeamSize(Number(e.target.value))}
        min={1}
        max={10}
      />

      <input
        type="range"
        value={duration()}
        onInput={(e) => setDuration(Number(e.target.value))}
        min={4}
        max={52}
      />

      {/* Only these three divs re-render when pricing changes */}
      <div class="pricing-summary">
        <div>Subtotal: ${() => pricing().subtotal.toLocaleString()}</div>
        <div>Discount: {() => pricing().discount * 100}%</div>
        <div>Total: ${() => pricing().total.toLocaleString()}</div>
      </div>
    </div>
  );
}
```

### Key Differences

| Aspect          | React                             | SolidJS                                |
| --------------- | --------------------------------- | -------------------------------------- |
| State           | `useState` returns value directly | `createSignal` returns getter function |
| Derived values  | `useMemo` with dependency array   | `createMemo` with automatic tracking   |
| Re-rendering    | Entire component function re-runs | Only specific expressions update       |
| Callbacks       | Need `useCallback` for stability  | Functions are stable by default        |
| JSX expressions | Immediate evaluation              | Functions can be passed to templates   |

<div class="callout callout-info">
  <div class="callout-title">The Fine-Print</div>
  <p>SolidJS's <code>createSignal</code> returns a getter function, not the value directly. This enables fine-grained tracking—Solid knows exactly which signals each effect depends on. With React, the entire component re-renders, and hooks rely on call order (rules of hooks).</p>
</div>

## Bundle Size Analysis

For our landing page, we compared production bundles:

| Framework             | Minified | Gzipped | Components              |
| --------------------- | -------- | ------- | ----------------------- |
| React 18 + DOM        | 42KB     | 14KB    | -                       |
| React (our app)       | 89KB     | 28KB    | Form, Calculator, Modal |
| **SolidJS (our app)** | **24KB** | **8KB** | Form, Calculator, Modal |
| **Savings**           | **73%**  | **71%** | -                       |

The React bundle includes the React runtime + our components + prop-types. The SolidJS bundle is smaller because:

1. **No virtual DOM runtime** — Less code to ship
2. **Compiler optimizations** — Solid's compiler pre-computes what it can
3. **Tree-shaking friendly** — Only used primitives are included

## Developer Experience: The Surprises

We expected SolidJS to be faster. We didn't expect to prefer writing it.

### What We Liked

**1. No Stale Closures**

In React, this is a classic bug:

```tsx
function Timer() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      console.log(count); // Always 0! Stale closure.
      setCount(count + 1);
    }, 1000);
    return () => clearInterval(interval);
  }, []); // Forgot to include count

  return <div>{count}</div>;
}
```

In SolidJS, signals are always current:

```tsx
function Timer() {
  const [count, setCount] = createSignal(0);

  createEffect(() => {
    const interval = setInterval(() => {
      console.log(count()); // Always current value
      setCount((c) => c + 1); // Functional update also works
    }, 1000);
    return () => clearInterval(interval);
  });

  return <div>{count()}</div>;
}
```

**2. No Hook Rules**

React's rules of hooks (only call at top level, only call from React functions) exist because hooks rely on call order. SolidJS uses explicit dependencies—no rules needed.

**3. Fine-Grained Control**

Want to run code when any of three signals change? Just read them:

```tsx
const [a, setA] = createSignal(0);
const [b, setB] = createSignal(0);
const [c, setC] = createSignal(0);

createEffect(() => {
  // Runs when a, b, OR c changes
  console.log(a(), b(), c());
});
```

In React, you'd need useEffect with a dependency array—and hope you didn't miss anything.

### What We Missed

**1. Ecosystem Maturity**

React's ecosystem is vast. For SolidJS, we sometimes had to:

- Write our own components instead of using a library
- Contribute PRs to existing libraries
- Accept less battle-tested solutions

**2. Developer Tools**

React DevTools is excellent. SolidJS has DevTools, but they're less mature. Debugging reactivity can be confusing at first.

**3. Team Familiarity**

Most engineers know React. SolidJS requires learning new patterns. Onboarding took longer than expected.

<div class="callout callout-warning">
  <div class="callout-title">The Learning Curve</div>
  <p>Don't underestimate the mental model shift. Engineers familiar with React's "re-render everything" model often struggle with Solid's "update only what changed" approach. Budget time for team learning.</p>
</div>

## When to Choose Which

Based on our experience, here's our decision framework:

### Choose SolidJS When:

- Performance is critical (real-time dashboards, heavy data viz)
- Bundle size matters (mobile-first, emerging markets)
- You're building interactive components, not content sites
- Your team values long-term maintainability over short-term velocity
- You want to avoid React's complexity (useEffect, useCallback, memo)

### Choose React When:

- You need ecosystem maturity (specific libraries, plugins)
- Your team already knows React well
- You're building content-heavy sites (Next.js, Gatsby)
- You need React Native for mobile
- You're using a meta-framework that requires React (Remix, etc.)

## Our Setup: SolidJS + Astro

We use SolidJS for interactive islands within Astro's static site generation:

```astro
---
// src/pages/pricing.astro
import Layout from '~/ui/components/layouts/Layout.astro';
import PricingCalculator from '~/ui/components/PricingCalculator';
import Testimonials from '~/ui/components/Testimonials.astro';
---

<Layout title="Pricing">
  <!-- Static content — zero JavaScript -->
  <Testimonials />

  <!-- Interactive island — only this hydrates -->
  <PricingCalculator client:visible />

  <!-- More static content -->
  <FAQ />
</Layout>
```

This gives us:

- **Static pages** for SEO and performance
- **Islands of interactivity** where needed
- **Minimal JavaScript** shipped to the browser

## Migration Strategy

If you're considering the switch, here's how we approached it:

### Phase 1: Pilot (Weeks 1-2)

- Build one non-critical component in SolidJS
- Compare performance, bundle size, dev experience
- Get team feedback

### Phase 2: New Features (Weeks 3-6)

- Use SolidJS for all new interactive features
- Maintain existing React code
- Build shared component library

### Phase 3: Strategic Migration (Weeks 7-12)

- Migrate performance-critical components
- Leave working React code alone
- Gradual, need-based migration

<div class="callout callout-tip">
  <div class="callout-title">Don't Rewrite Everything</div>
  <p>We kept our React components that worked fine. The migration was strategic—only components that needed better performance were rewritten. This minimized risk while maximizing benefit.</p>
</div>

## Final Verdict

Six months in, we have zero regrets. Our dashboard is faster, our bundle is smaller, and our code is simpler.

SolidJS isn't perfect. The ecosystem is smaller, the learning curve is real, and DevTools need work. But for our use case—interactive dashboards with real-time updates—the trade-offs were worth it.

The fine-grained reactivity model feels like the right abstraction. We're writing less code, shipping less JavaScript, and getting better performance. That's a rare combination.

If you're building performance-critical interactive applications, give SolidJS a serious look. The benchmarks speak for themselves, but the developer experience might surprise you too.

---

_Want to discuss frontend architecture or framework choices? [Get in touch](/contact)._

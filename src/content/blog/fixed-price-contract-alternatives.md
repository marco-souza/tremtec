---
title: "Why We Don't Do Fixed-Price Contracts (And What We Do Instead)"
description: "The hidden costs of fixed-price contracts in consulting, and how our time-and-materials approach with capped budgets builds better client relationships."
date: 2026-03-11
author: "TremTec Team"
tags: ["Business", "Pricing", "Client Relations"]
---

We get this question a lot: "Can you give us a fixed price for this project?"

Our answer is always the same: "No, but let us explain why—and what we do instead."

This isn't stubbornness or a pricing gimmick. After years of consulting, we've learned that fixed-price contracts create misaligned incentives, hide real costs, and often result in worse outcomes for everyone. Here's our reasoning.

## The Fixed-Price Fantasy

Fixed-price contracts seem appealing on the surface:

- **Predictable budget:** You know exactly what you'll pay
- **Risk transfer:** The vendor bears cost overruns
- **Easy procurement:** Simple comparison shopping

But this predictability is an illusion. The real costs don't disappear—they just get buried, deferred, or externalized.

### The Hidden Costs of Fixed Pricing

**1. The Contingency Tax**

Vendors aren't stupid. They know fixed-price means risk, so they add 20-40% contingency to cover unknowns. You're paying for risk that may never materialize.

**2. Scope Rigidity**

Fixed-price locks scope upfront. But requirements always change as you learn. This leads to:

- Change orders (expensive, adversarial)
- Deferred features (technical debt)
- "Out of scope" arguments (relationship strain)

**3. Quality Trade-offs**

When a vendor realizes they're over budget, they have three options:

- Absorb the loss (rare)
- Negotiate a change order (adversarial)
- Cut corners silently (common)

Guess which one happens most often?

**4. Discovery Theater**

Fixed-price requires detailed specs upfront. So vendors spend weeks in "discovery" writing documents that will be wrong anyway. That's billable time not spent building.

<div class="callout callout-warning">
  <div class="callout-title">The Fixed-Price Paradox</div>
  <p>The more uncertainty in a project, the more you want a fixed price. But uncertainty is exactly when fixed pricing fails—you can't accurately estimate what you don't understand. You're paying a premium for false certainty.</p>
</div>

## Our Alternative: Time-and-Materials with Guardrails

We use a time-and-materials model with three key guardrails:

1. **Weekly budget caps** — Never surprise invoices
2. **Detailed time tracking** — Complete transparency
3. **Regular scope negotiation** — Flexibility without chaos

### How It Works

**Week 1: Planning & Estimates**

We don't give you a single number. We give you a range:

| Feature             | Optimistic | Realistic   | Pessimistic |
| ------------------- | ---------- | ----------- | ----------- |
| User authentication | 16 hrs     | 24 hrs      | 40 hrs      |
| Payment integration | 24 hrs     | 40 hrs      | 80 hrs      |
| Admin dashboard     | 40 hrs     | 60 hrs      | 100 hrs     |
| **Total project**   | **80 hrs** | **124 hrs** | **220 hrs** |

You decide your risk tolerance. Want to budget for optimistic? Fine, but know you might need additional budget. Prefer pessimistic? You'll likely come in under budget.

**Ongoing: Weekly Invoices**

Every Monday, you get:

- Hours worked last week (detailed by task)
- Budget remaining
- Scope completed
- Forecast to completion

```
Week 3 Invoice
==============
Budget: $50,000
Week 3 Hours: 38 hrs @ $250/hr = $9,500
Running Total: $28,500 (57% of budget)
Remaining Budget: $21,500

Tasks Completed:
✓ User authentication (24 hrs)
✓ Payment integration (40 hrs, 4 hrs over estimate)
✓ Database schema (16 hrs, 2 hrs under estimate)

Scope Changes This Week:
+ Added OAuth provider integration (+8 hrs)
- Removed custom user roles (-12 hrs)
Net change: -4 hrs

Forecast:
Current pace: On track for $48,000 final cost
If scope grows as projected: $52,000 (slightly over)
```

**Transparency Builds Trust**

You see exactly where time goes. If we're struggling with a feature, you know immediately. No surprises at the end.

## The Pricing Model Comparison

Let's compare models side-by-side:

| Aspect                   | Fixed-Price                     | Time-and-Materials (Ours)            |
| ------------------------ | ------------------------------- | ------------------------------------ |
| **Predictability**       | Illusory (hidden contingency)   | Real (weekly visibility)             |
| **Scope flexibility**    | Rigid (change orders required)  | Flexible (negotiate weekly)          |
| **Cost transparency**    | Opaque (all-in-one number)      | High (detailed breakdown)            |
| **Vendor incentive**     | Finish fast (cut corners)       | Deliver value (ongoing relationship) |
| **Risk allocation**      | Vendor (priced in)              | Shared (visible and discussed)       |
| **Discovery time**       | Extensive (need detailed specs) | Minimal (learn as we build)          |
| **Relationship dynamic** | Transactional                   | Partnership                          |

### Real Example: The E-Commerce Project

**Client needed:** New checkout flow with payments, inventory, and shipping.

**Fixed-Price Bid (Competitor):** $120,000, 12 weeks

**Our Approach:**

- Initial estimate: 400 hours ($100,000)
- Week 4 discovery: Payment processor integration more complex than expected (+40 hrs)
- Client decision: Simplify shipping integration to stay on budget
- Final cost: $110,000
- Time saved vs. fixed-price: 3 weeks (no lengthy discovery phase)

**The difference:**

- Fixed-price vendor would have eaten the cost (unhappy) or pushed back on "scope creep" (adversarial)
- We had an honest conversation about trade-offs (partnership)

<div class="callout callout-tip">
  <div class="callout-title">The Scope Negotiation</div>
  <p>In Week 4, we presented three options: (1) Increase budget by $10K, (2) Simplify shipping to stay on budget, (3) Phase shipping to a follow-on project. The client chose option 2—an informed trade-off, not a surprise.</p>
</div>

## When Fixed-Price Makes Sense

We don't hate fixed-price universally. It works when:

**1. Scope is Truly Fixed**

You need exactly this feature, built exactly this way, with no changes. Rare, but it happens.

**2. You've Done It Before**

This is your 50th e-commerce site with the same stack. You know the work intimately.

**3. Risk Transfer is Worth the Premium**

You'd rather overpay by 30% than risk budget uncertainty. Some procurement departments require this.

**4. The Project is Small and Well-Defined**

"Integrate this API endpoint and transform the data." Simple, bounded, low uncertainty.

## Our Engagement Models

We offer three structures depending on client needs:

### 1. Weekly Sprints (Most Common)

**Best for:** Ongoing development, evolving requirements

- **Structure:** Fixed weekly capacity (e.g., 2 engineers, 40 hrs/week each)
- **Billing:** Weekly based on actual hours
- **Commitment:** Minimum 4 weeks, month-to-month after
- **Scope:** Flexible, negotiated each week

**Example:**

```
Sprint Rate: $20,000/week (2 engineers @ $250/hr)
Minimum: 4 weeks ($80,000)
Typical engagement: 8-12 weeks
```

### 2. Capped Budget with Milestones

**Best for:** Defined projects with some flexibility

- **Structure:** Agreed-upon budget cap with milestone payments
- **Billing:** Monthly against hours worked
- **Commitment:** Full project duration
- **Scope:** Defined at high level, details flexible within budget

**Example:**

```
Budget Cap: $100,000
Milestones:
- Week 2: Foundation complete (20% = $20,000)
- Week 4: Core features (40% = $40,000)
- Week 6: Integration & polish (30% = $30,000)
- Week 8: Final delivery (10% = $10,000)

If we finish early: You pay less
If scope grows: We discuss before exceeding cap
```

### 3. Retainer for Advisory

**Best for:** Ongoing access to expertise without full-time commitment

- **Structure:** Monthly retainer for set hours of availability
- **Billing:** Monthly in advance
- **Commitment:** 3-month minimum
- **Scope:** Architecture reviews, code audits, team mentoring

**Example:**

```
Retainer: $15,000/month
Includes: 40 hours of advisory time
Rollover: Up to 20 hours to next month
Additional hours: $400/hr
```

## The Decision Framework

Not sure which model fits? Here's how to decide:

### Choose Weekly Sprints If:

- [ ] Requirements will evolve as we build
- [ ] You want maximum flexibility
- [ ] You're comfortable with some budget uncertainty
- [ ] You value speed over detailed planning

### Choose Capped Budget If:

- [ ] You have a defined scope with acceptable flexibility
- [ ] You need budget predictability (with a ceiling)
- [ ] You want milestone-based payments
- [ ] You can tolerate some scope negotiation

### Choose Fixed-Price (Elsewhere) If:

- [ ] Scope is completely locked
- [ ] You've done this exact project before
- [ ] Budget certainty is worth 30%+ premium
- [ ] You can't tolerate any budget variance

<div class="callout callout-info">
  <div class="callout-title">The Honesty Test</div>
  <p>If a vendor gives you a fixed price without asking detailed questions, they're either naive or padding heavily. Either way, be skeptical. Good vendors probe to understand uncertainty before quoting.</p>
</div>

## Building Trust Through Transparency

Our pricing model reflects our broader philosophy: transparency builds trust, and trust enables better outcomes.

**What you get with our approach:**

1. **Daily standups** — Know exactly what's happening
2. **Weekly demos** — See working software every week
3. **Detailed time tracking** — Every hour accounted for
4. **Honest communication** — Bad news early, not at deadline
5. **Collaborative scope** — We solve problems together

**What we get:**

1. **Fair compensation** — Paid for work done, not work guessed
2. **Reasonable clients** — Clients who value partnership over blame
3. **Sustainable pace** — No corner-cutting to meet arbitrary deadlines
4. **Ongoing relationships** — Most clients work with us multiple times

## Common Objections

### "But my CFO needs a fixed number."

Give them a range with probabilities:

> "This project will cost between $80,000 and $120,000. Based on similar projects, we're 70% confident it will come in under $100,000. We'll know more after Week 2 and can tighten the estimate then."

This is more honest than a false precision of exactly $98,500.

### "How do I know you won't pad hours?"

Three ways:

1. **Detailed time tracking** — Every entry tied to a specific task
2. **Weekly demos** — Working software proves progress
3. **Scope negotiation** — If we're slow on a feature, we discuss it

Also: Our reputation. We survive on repeat business and referrals. Padding hours is short-term thinking.

### "What if we run over budget?"

We stop and discuss:

> "We're at 80% of budget with 60% of scope complete. Here are our options:
>
> 1. Increase budget by $X to complete full scope
> 2. Prioritize remaining scope and descope lower-priority items
> 3. Simplify some features to fit current budget
>
> What's your preference?"

No surprises. No hidden overruns. Just honest conversation about trade-offs.

<div class="callout callout-danger">
  <div class="callout-title">The Budget Wall</div>
  <p>We never work beyond an agreed budget without explicit approval. If we hit the ceiling, we stop. This protects both of us—you don't get surprise invoices, we don't work for free.</p>
</div>

## Our Promise

When you work with TremTec:

1. **No hidden fees** — Ever
2. **Weekly transparency** — Detailed invoices every Monday
3. **Honest estimates** — Ranges, not false precision
4. **Scope flexibility** — Change your mind (with budget implications)
5. **Quality first** — We don't cut corners to meet estimates

## Ready to Talk?

If this approach resonates with you, [let's discuss your project](/contact). We'll give you an honest assessment of complexity, an estimated range, and a timeline that respects both your goals and reality.

And if you truly need a fixed price? We'll recommend other vendors who work that way. We're not the right fit for everyone, and we'd rather be honest about that than force a bad match.

---

_Questions about our pricing model? [Email us](mailto:hello@tremtec.com). We're happy to explain our reasoning in more detail._

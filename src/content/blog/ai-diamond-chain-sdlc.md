---
title: "From Double Diamond to Diamond Chain: How AI is Reshaping the SDLC"
description: "Bridging classic UX design thinking with autonomous AI workflows to create a new paradigm for software development"
date: 2026-04-13
author: Marco Souza
tags: ["AI", "SDLC", "Design Thinking", "OpenCode", "Maestro", "Agentic AI"]
---

In 2005, the British Design Council introduced the **Double Diamond**—a visual representation of the design process that would become the universal language of innovation. For two decades, it has guided teams through the essential rhythm of creative work: diverge to explore, converge to decide, repeat.

Today, we stand at an inflection point. Large Language Models (LLMs) aren't just tools; they're autonomous agents capable of planning, reasoning, and executing complex tasks. These agents follow their own patterns—workflows, routing, parallelization, optimization loops—but beneath the surface, they echo the same fundamental rhythm as the Double Diamond.

This convergence isn't coincidental. It reveals something profound: **the Double Diamond isn't just a design process; it's the fundamental pattern of intelligent problem-solving.** And when we embed this pattern into autonomous AI workflows across the entire Software Development Lifecycle (SDLC), we get something new: the **AI Diamond Chain**.

<!-- more -->

---

## The UX Double Diamond—A Timeless Foundation

Before we talk about AI, let's revisit the original framework that started it all.

### The Four Phases

The Double Diamond consists of two diamonds, each with a divergent and convergent phase:

#### Diamond 1: Problem Space

- **DISCOVER** (Diverge): Understand rather than assume. Speak to users, gather observations, research broadly.
- **DEFINE** (Converge): Synthesize insights into a clear problem statement.

#### Diamond 2: Solution Space

- **DEVELOP** (Diverge): Generate multiple solutions. Brainstorm, co-design, seek inspiration.
- **DELIVER** (Converge): Test and refine. Build prototypes, validate, improve what works.

### Why It Works

The genius of the Double Diamond lies in its structure:

1. **Separation of concerns**: Problem understanding and solution generation are distinct phases
2. **Forced divergence**: Teams must explore broadly before committing to a direction
3. **Natural iteration**: The framework invites looping back when new information emerges
4. **User-centricity**: Every diamond starts with human needs and ends with human validation

But here's the thing: this pattern isn't just for designers. It's how intelligent agents—human or artificial—solve problems.

---

## The AI Autonomous Workflow

Fast forward to today. AI agents have evolved from simple chatbots to sophisticated systems that can plan, use tools, and maintain state across long-running tasks.

### Agentic Patterns

Based on research from Anthropic, OpenAI, and LangChain, autonomous AI workflows follow several core patterns:

**1. Prompt Chaining**: Decompose a task into sequential steps, where each LLM call processes the output of the previous one.

**2. Routing**: Classify input and direct it to specialized handlers.

**3. Parallelization**: Run multiple subtasks simultaneously through sectioning or voting.

**4. Orchestrator-Workers**: A central agent breaks down tasks and delegates to specialized workers, then synthesizes results.

**5. Evaluator-Optimizer**: One agent generates, another evaluates, in an iterative loop until quality criteria are met.

**6. Full Autonomous Agents**: The agent operates in a loop: plan → execute tool → observe result → adapt plan.

### The Autonomous Loop

At the heart of every agentic system is a simple loop:

```
Autonomous Loop:  User Request --> Agent Plans --> Executes Tool --> Matches User Request?
                                       ^                            |
                                       |___________________________/ no
                                                          (iterate if needed)
```

---

## The Hidden Connection—Why AI Agents Think Like Designers

Here's the insight that bridges these two worlds: **AI agents naturally follow a Double Diamond pattern within each task cycle.**

Let's trace how a coding agent solves a bug:

**Discover Phase**: Reads the issue description, explores the codebase, identifies related files.

**Define Phase**: Identifies the root cause, defines what needs to change, sets success criteria.

**Develop Phase**: Generates multiple potential fixes, considers different implementation approaches.

**Deliver Phase**: Selects the best approach, implements the fix, runs tests to validate.

**The key difference**: AI agents do this at machine speed (seconds to minutes), with perfect recall, and continuously.

---

## Introducing the AI Diamond Chain

If the Double Diamond is the atomic unit of problem-solving, the **AI Diamond Chain** is what happens when you link these units together to tackle complex, multi-phase workflows—like the entire Software Development Lifecycle.

```
Linear Diamond Chain:

  Diamond 1:  Discover --> Define  ---->  Diamond 2: Discover --> Define
                 <           >     ---->  Diamond 3: Discover --> Define
                                   ---->  Diamond n: Discover --> Define
```

Each diamond has:

- **Input context** (from previous diamond)
- **Divergent phase** (AI explores possibilities)
- **Convergent phase** (AI narrows to a decision)
- **Output/handoff** (to next diamond)

### Chain Types

- **Linear Chain**: Sequential dniamonds, one after another
- **Nested Hierarchy**: A diamond contains sub-diamonds
- **Parallel Chain**: Multiple diamonds run simultaneously
- **Recursive Chain**: Output feeds back for refinement

---

## The AI Diamond Chain Meets SDLC

Traditional SDLC has well-defined phases, but they often suffer from context loss, handoff friction, and human bottlenecks. The Diamond Chain model solves this by making each phase a self-contained diamond with clear inputs, outputs, and quality gates.

### The Diamond Chain SDLC

```
SDLC Diamond Chain:

  Requirements  --> Architecture --> Implementation --> Quality --> Deployment
  (Discover+      (Discover+      (Discover+         (Discover+    (Discover+
   Define)         Define+         Develop+           Define+       Develop+
                   Design)         Deliver)           Develop+      Deliver)
                                                      Report)
```

Each SDLC phase follows the diamond pattern:

```

**Requirements Diamond**: Discover user needs, competitive analysis → Define PRD, user stories, success criteria

**Architecture Diamond**: Discover tech landscape, POC explorations → Define system design, tech stack, API contracts

**Implementation Diamond**: Discover codebase, patterns → Define module breakdown → Develop code → Deliver working feature

**Quality Diamond**: Discover test cases, edge cases → Define acceptance criteria → Develop fixes → Deliver validated code

**Deployment Diamond**: Discover infrastructure options → Define deployment plan → Develop CI/CD → Deliver live system

### Why This Changes Everything

**1. Continuous Context Flow**: Each diamond's output becomes the next diamond's structured input. No more "telephone game."

**2. Parallel Execution**: Multiple features can run through independent diamond chains simultaneously.

**3. Iterative Within Phases**: Each SDLC phase is itself iterative. If implementation doesn't converge, the diamond loops back.

**4. Objective Quality Gates**: Each diamond has clear exit criteria. You can't leave a phase without meeting them.

---

## Implementation with OpenCode and Maestro

Theory is great, but how do we actually build this? Enter **OpenCode** and **Maestro**.

### The Tools

**OpenCode** is a terminal-based AI coding agent that supports multiple LLM providers (Claude, OpenAI, Gemini, Copilot). It can read/write files, execute bash commands, search codebases, fetch web content, and integrate with LSP for code intelligence.

**Maestro** is an LLM orchestrator that coordinates specialist sub-agents through a structured workflow. It's built on OpenCode as the runtime and implements a 4-phase workflow that maps perfectly to the Diamond Chain model.

### Maestro's Diamond Chain Architecture

Maestro's workflow is itself a Diamond Chain:

```

MAESTRO DIAMOND CHAIN:

```
Maesto Workflow:  Discovery --> Synthesis --> Build --> Quality Gate
                 (Report)       (Specs)      (Code)      (QA Report)
```

**Discovery Phase**: Architect explores requirements, researches solutions, produces Discovery Report.

**Synthesis Phase**: Specialists analyze discovery, propose implementations, produce Technical Specification.

**Build Phase**: Agents generate code in parallel (Frontend, Backend, Infrastructure).

**Quality Gate Phase**: QA validates, tests, produces final QA Report.

### Getting Started

#### Step 1: Install the Tools

```bash
# Install OpenCode (the agent runtime)
go install github.com/anomalyco/opencode@latest

# Install Maestro (the orchestrator)
go install github.com/tremtec/maestro@latest
```

#### Step 2: Initialize Your Project

```bash
cd /path/to/your/project
maestro init
```

#### Step 3: Configure Your Squad

The `maestro init` command creates a squad configuration:

```yaml
squad:
  architect:
    role: "System Architect"
    responsibilities:
      - "Design system architecture"
      - "Choose tech stack"
      - "Define API contracts"
    model: "anthropic-opus" # Most capable for complex design decisions

  frontend:
    role: "Frontend Engineer"
    responsibilities:
      - "Implement UI components"
      - "Build user interactions"
    model: "anthropic-sonnet" # Balanced for code generation

  backend:
    role: "Backend Engineer"
    responsibilities:
      - "Implement API endpoints"
      - "Database schema design"
    model: "anthropic-sonnet"

  devops:
    role: "DevOps Engineer"
    responsibilities:
      - "CI/CD pipelines"
      - "Infrastructure as Code"
    model: "anthropic-sonnet"

  qa:
    role: "QA Engineer"
    responsibilities:
      - "Test plan creation"
      - "Quality validation"
    model: "anthropic-sonnet"
```

### Running a Diamond Chain

#### Basic Usage

```bash
maestro run "Build a user authentication system with OAuth2 support"
```

#### What Happens Behind the Scenes

1. **Discovery Phase**: Maestro prompts the Architect agent via OpenCode to explore requirements, research solutions, and produce a Discovery Report.

2. **Synthesis Phase**: With the Discovery Report as context, specialist agents create specifications for Backend, Frontend, and DevOps.

3. **Build Phase**: Agents implement in parallel, each following the diamond pattern within their domain.

4. **Quality Gate Phase**: QA agent validates everything, produces a QA Report with pass/fail decisions.

### The State Directory (`.maestro/`)

Maestro uses markdown files as its state database, creating a transparent, auditable chain:

```text
.maestro/
├── discovery.md              # Discovery Phase output
├── spec-architecture.md      # Architecture spec
├── spec-frontend.md         # Frontend spec
├── spec-backend.md          # Backend spec
├── spec-devops.md           # DevOps spec
├── build-report.md          # Build phase summary
├── qa-report.md             # Quality gate results
└── handoffs/
    ├── d1-to-d2.md         # Context transfer D1→D2
    ├── d2-to-d3.md         # Context transfer D2→D3
    └── d3-to-d4.md         # Context transfer D3→D4
```

### Advanced Diamond Chain Patterns

#### Parallel Diamond Execution

```bash
# Multiple independent features in parallel
maestro run --parallel \
  "Implement dark mode toggle" \
  "Add pagination to user list" \
  "Create email notification service"
```

#### Continuous Diamond Chain (CI/CD)

```yaml
# .github/workflows/diamond-chain.yml
name: Diamond Chain CI

on:
  push:
    branches: [main]

jobs:
  diamond-chain:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Maestro
        run: go install github.com/tremtec/maestro@latest
      - name: Run Diamond Chain
        run: |
          maestro init
          maestro run "Auto-fix from CI: ${{ github.event.head_commit.message }}"
```

#### Human-in-the-Loop with Approval Gates

```bash
maestro run "Implement payment integration" \
  --approval-points discovery,synthesis,build \
  --notify slack://payments-team
```

### Real-World Example

Let's walk through building a **"Forgot Password" flow**:

#### Phase 1: Discovery (D1) — 15 minutes

```markdown
# .maestro/discovery.md

## Objective

Add forgot password functionality

## Explored Approaches

### Option 1: Token-based Email Reset (Selected)

- Generate cryptographically secure token
- Send email with link
- Token expires after 1 hour
- Hash before storage

### Option 2: Temporary Password

- Less secure (password in email)
- Rejected

### Option 3: SMS Reset

- No SMS infrastructure
- Rejected

## Security Considerations

- 32-byte cryptographically secure tokens
- Hash tokens before storage
- Rate limiting: 3 requests/hour
- No user enumeration (always return 200)
```

#### Phase 2: Synthesis (D2) — 12 minutes

```markdown
# .maestro/spec-backend.md

## API Endpoints

### POST /api/auth/forgot-password

- Body: { email: string }
- Response: 200 OK (always, for security)
- Rate limited: 3 attempts/hour

### POST /api/auth/reset-password

- Body: { token: string, newPassword: string }
- Validates token + password strength
```

#### Phase 3: Build (D3) — 28 minutes

Files created by specialist agents:

```bash
# file list
src/components/auth/ForgotPasswordForm.tsx
src/components/auth/ResetPasswordForm.tsx
src/pages/forgot-password.astro
src/pages/reset-password.astro
src/server/auth/forgot-password.ts
src/server/auth/reset-password.ts
tests/integration/auth/password-reset.test.ts
```

#### Phase 4: Quality Gate (D4) — 8 minutes

```markdown
# .maestro/qa-report.md

## Test Results

- Unit tests: 23/23 passed ✅
- Integration tests: 10/10 passed ✅
- Security tests: 8/8 passed ✅

## Security Audit

✅ 32-byte secure tokens
✅ SHA-256 hashing
✅ Rate limiting
✅ No user enumeration
✅ HTTPS enforced

## Status: ✅ APPROVED FOR DEPLOYMENT
```

#### Final Result

```
Timeline:  0min------15min----27min--------55min-----63min
           |          |        |           |         |
           | Discovery|  Syn-  |   Build   | Quality |
           |<-------->|<------>|<--------->|<------->|
```

| Phase        | Duration | Status  |
| ------------ | -------- | ------- |
| Discovery    | 15 min   | ✅ PASS |
| Synthesis    | 12 min   | ✅ PASS |
| Build        | 28 min   | ✅ PASS |
| Quality Gate | 8 min    | ✅ PASS |

**Total Time:** 63 minutes  
**Status:** READY FOR DEPLOYMENT

---

## The Future—Living Diamond Chains

As AI capabilities advance, Diamond Chains will evolve from discrete, request-triggered workflows to **continuous, always-on processes**.

### The Vision

**Continuous Discovery**: Agents monitor user behavior, error logs, and support tickets. Automatically identify patterns and opportunities.

**Continuous Architecture**: Agents track tech debt, security advisories, and performance metrics. Propose and execute approved refactorings.

**Continuous Implementation**: Agents implement approved features end-to-end through full diamond chains.

**Continuous Quality**: Agents maintain comprehensive test suites, monitor production for regressions, automatically fix bugs.

**Continuous Deployment**: Agents manage deployment pipelines, execute canary releases, monitor and rollback if needed.

### Self-Improving Chains

The ultimate Diamond Chain learns from past iterations—which convergence criteria produce better outcomes, which prompts are most effective, how to optimize for different task types.

---

## Key Takeaways

1. **The Double Diamond is the atomic unit of problem-solving**—not just for designers, but for any intelligent agent.

2. **AI agents naturally follow this pattern**—they diverge to explore, converge to decide, and iterate.

3. **The AI Diamond Chain extends this to complex workflows**—linking multiple diamonds to tackle multi-phase processes like the SDLC.

4. **Maestro orchestrates this architecture**—its 4-phase workflow (Discovery → Synthesis → Build → Quality Gate) is a Diamond Chain.

5. **OpenCode powers the specialist agents**—each agent uses OpenCode to execute their phase.

6. **Quality is built into the structure**—each diamond has explicit exit criteria, preventing premature convergence.

7. **The future is continuous**—Diamond Chains will evolve from discrete workflows to always-on, self-improving processes.

---

## Getting Started

Ready to implement Diamond Chains in your workflow?

```bash
# 1. Install the tools
go install github.com/anomalyco/opencode@latest
go install github.com/tremtec/maestro@latest

# 2. Initialize your first project
cd your-project
maestro init

# 3. Run your first diamond chain
maestro run "Your feature description here"

# 4. Review the outputs
ls -la .maestro/
```

---

## Conclusion

The Double Diamond has served us well for twenty years because it captures something fundamental about how intelligent agents solve problems. Now, as AI agents become capable of autonomous execution, we have the opportunity to embed this pattern into our entire development workflow.

The AI Diamond Chain isn't just a theoretical framework—it's a practical architecture you can implement today using OpenCode and Maestro. By making each SDLC phase a self-contained diamond with clear inputs, outputs, and quality gates, we can automate the tedious parts of development while preserving the creative, human-centric approach that makes great software.

The future of software development isn't humans vs. AI—it's humans **orchestrating** AI through proven patterns like the Diamond Chain. The tools are here. The pattern is proven. The only question is: what will you build?

---

## Resources

- [Maestro](https://github.com/tremtec/maestro)
- [OpenCode](https://github.com/anomalyco/opencode)
- [Design Council Double Diamond](https://www.designcouncil.org.uk/our-resources/the-double-diamond/)
- [Anthropic on Building Effective Agents](https://www.anthropic.com/research/building-effective-agents)
- [LangChain on Agentic Workflows](https://blog.langchain.dev/what-is-an-agent/)

# New Product Workflow (Zero to One 🚀)

**Objective**: Convert a raw idea into a deployed MVP.
**Trigger**: User submits a new idea via the Platform.

## Workflow Diagram

```mermaid
sequenceDiagram
    participant U as User (PodCodar)
    participant P as Platform (Astro)
    participant B as Brain (TS/LangGraph.js)
    participant CPO as CPO Agent
    participant TL as Tech Lead Agent
    participant DEV as Dev Agents

    Note over U, P: Phase 1: Initiation
    U->>P: Submit "New Idea"
    P->>B: POST /workflow/start (Idea)
    B->>CPO: Analyze Market & Competitors
    CPO->>CPO: Generate PRD & MVP Scope
    CPO->>B: Return PRD (Draft)
    B->>P: Webhook: PRD Ready
    P->>U: Display PRD for Approval

    Note over U, P: Phase 2: Execution
    U->>P: Approve PRD
    P->>B: POST /workflow/approve
    B->>TL: Review Requirements
    TL->>TL: Design Architecture (D1 Schema, Astro Structure)
    TL->>B: Architecture Plan Ready

    par Parallel Build
        B->>DEV: Frontend (SolidJS Components)
        B->>DEV: Backend (Hono API)
        B->>CMO: Generate Copy & Branding
        B->>DESIGN: Create Logo & Assets
    end

    DEV->>P: Push Code (GitHub)
    P->>U: Notify "Deployment Ready"
```

## Phases

### Phase 1: Initiation

1. User submits idea with initial context
2. CPO Agent analyzes market fit and competitors
3. CPO generates PRD (Product Requirements Document) with MVP scope
4. User reviews and approves PRD

### Phase 2: Execution

1. Tech Lead designs architecture and schema
2. Dev Agents, CMO, and Designer work in parallel:
   - Frontend components (SolidJS)
   - Backend API (Hono)
   - Marketing copy & branding
   - Logo & visual assets
3. Code pushed to GitHub triggers deployment

## Agents Involved

- **CPO Agent**: Market analysis, PRD generation, MVP scope definition
- **Tech Lead Agent**: Architecture design, schema planning, technical review
- **Dev Agents**: Frontend and backend implementation
- **CMO Agent**: Copy generation, brand voice, messaging
- **Designer Agent**: Logo and visual asset creation

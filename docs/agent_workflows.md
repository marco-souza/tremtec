# AI Agent Workflows

This document visualizes the operational workflows of the TremTec Accelerator, showing how the AI Agents collaborate to build and maintain products.

## 1. New Product Workflow (Zero to One 🚀)

**Objective**: Convert a raw idea into a deployed MVP.
**Trigger**: User submits a new idea via the Platform.

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
    CPO->>CPO: Return PRD (Draft)
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

## 2. New Feature Workflow (Iteration 🔄)

**Objective**: Add functionality to an existing codebase safely.
**Trigger**: User request for a new feature.

```mermaid
flowchart TD
    Start["User Request: 'Add Dark Mode'"] --> P["Platform: Context Fetch"]
    P --> |Current Codebase + Request| B["Brain: Router"]
    
    B --> CPO[CPO Agent]
    CPO --> |Validate Fit| Spec[Feature Spec]
    
    Spec --> TL[Tech Lead Agent]
    TL --> |Analyze Impact| Plan[Implementation Plan]
    
    Plan --> |Schema Changes?| DB["Tech Lead: Update D1 Schema"]
    Plan --> |UI Changes?| FE["Dev Agent: SolidJS Component"]
    Plan --> |API Changes?| BE["Dev Agent: Hono Endpoint"]
    
    DB & FE & BE --> Merge[Merge Request]
    Merge --> Test["Automated Tests (Vitest)"]
    Test --> |Pass| Deploy[Deploy Trigger]
    Test --> |Fail| Debug["Dev Agent: Fix"]
    Debug --> Test
```

## 3. Bug Fix Workflow (Maintenance 🛠️)

**Objective**: Resolve errors or bugs reported by users or monitoring.
**Trigger**: Error log or user report.

```mermaid
stateDiagram-v2
    [*] --> IssueReported
    IssueReported --> Triage: Tech Lead Agent
    
    state Triage {
        AnalyzeLogs --> LocateFile
        LocateFile --> CreateReproduction
    }
    
    Triage --> FixImplementation: Dev Agent
    
    state FixImplementation {
        WriteTest --> FailTest
        FailTest --> WriteFix
        WriteFix --> PassTest
    }
    
    FixImplementation --> CodeReview: Tech Lead Agent
    CodeReview --> Deploy: Approved
    CodeReview --> FixImplementation: Rejected
    Deploy --> [*]
```

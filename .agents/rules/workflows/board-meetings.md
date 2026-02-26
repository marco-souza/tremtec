# Board Meeting Workflow (Strategic Sync 📊)

**Objective**: Facilitate structured conversations between board members to discuss strategy, progress, and decisions.
**Trigger**: Scheduled meeting or user-initiated board sync request.

## Workflow Diagram

```mermaid
sequenceDiagram
    participant UM as User/Moderator
    participant P as Platform (Astro)
    participant B as Brain (TS/LangGraph.js)
    participant CPO as CPO Agent
    participant CMO as CMO Agent
    participant TL as Tech Lead Agent
    participant DEV as Full-Stack Dev Agent

    Note over UM, P: Phase 1: Meeting Setup
    UM->>P: Schedule Board Meeting
    P->>B: POST /workflow/board-meeting (Agenda, Topics)
    B->>B: Prepare Meeting Context
    B->>P: Notify Board Members
    P->>UM: Meeting Ready to Begin

    Note over UM, P: Phase 2: Opening & Agenda Review
    UM->>B: START meeting session
    B->>B: Load Prior Meeting Notes & Action Items
    B->>CPO: Review Strategic Objectives
    B->>CMO: Review Market Positioning
    B->>TL: Review Technical Health
    B->>DEV: Review Delivery Status

    Note over UM, P: Phase 3: Rotating Topic Discussion
    loop For Each Agenda Item
        B->>B: Set Topic Context
        B->>CPO: CPO Perspective (Product, Revenue Impact)
        B->>CMO: CMO Perspective (Go-to-Market, Customer Feedback)
        B->>TL: TL Perspective (Technical Feasibility, Architecture)
        B->>DEV: DEV Perspective (Implementation Timeline, Risks)
        B->>UM: Synthesized Discussion & Recommendations
        UM->>B: User Input / Decision
    end

    Note over UM, P: Phase 4: Action Items & Close
    B->>B: Synthesize Decisions
    B->>B: Generate Action Items with Owners & Deadlines
    B->>P: Create Follow-up Tasks
    P->>UM: Display Meeting Summary & Action Items
    UM->>P: Approve & Archive Meeting Notes
```

## Phases

### Phase 1: Meeting Setup

1. User schedules board meeting with agenda and topics
2. Platform prepares meeting context (prior notes, action items)
3. Brain notifies all board members
4. Meeting is ready to begin

### Phase 2: Opening & Status Review

1. Moderator starts meeting session
2. Brain loads prior meeting notes and action items
3. Each agent provides status update in their domain:
   - **CPO**: Strategic objectives and product progress
   - **CMO**: Market positioning and customer feedback
   - **Tech Lead**: Technical health and architecture
   - **Dev Agent**: Delivery status and timeline

### Phase 3: Topic Discussion (Rotating Perspectives)

For each agenda item:

1. Brain sets topic context
2. Each agent provides their perspective:
   - **CPO Agent**: Product viability, revenue impact, market fit
   - **CMO Agent**: Go-to-market strategy, customer perception, brand alignment
   - **Tech Lead Agent**: Technical feasibility, architecture implications, risk assessment
   - **Dev Agent**: Implementation timeline, technical debt, resource requirements
3. Brain synthesizes discussion into recommendations
4. Moderator makes decision or defers for further analysis

### Phase 4: Action Items & Close

1. Brain synthesizes all decisions
2. Generates action items with:
   - Clear ownership (assigned agent/person)
   - Specific deadline
   - Success criteria
3. Follow-up tasks created in platform
4. Meeting notes and decisions archived

## Participants & Roles

- **CPO Agent**: Drives product vision, market fit, revenue strategy
- **CMO Agent**: Focuses on brand, messaging, customer perception, go-to-market
- **Tech Lead Agent**: Ensures technical feasibility, architecture alignment, risk assessment
- **Full-Stack Dev Agent**: Provides implementation insights, delivery timelines, technical debt
- **User/Moderator**: Facilitates discussion, makes final decisions, provides business context

## Key Features

1. **Contextual Discussion**: Each agent provides perspective based on their domain expertise
2. **Decision Synthesis**: Brain synthesizes viewpoints into actionable recommendations
3. **Action Item Tracking**: Automatic generation of follow-up tasks with owners and deadlines
4. **Meeting Archive**: Full notes saved for audit trail and future reference
5. **Pattern Recognition**: System learns from past decisions to inform future meetings

## Meeting Agenda Template

When scheduling a board meeting, include:

- **Meeting Date & Time**
- **Attendees** (which agents)
- **Agenda Items** (topics to discuss)
- **Context Documents** (PRD, metrics, feedback, etc.)
- **Decisions Needed** (what decisions must be made)
- **Success Criteria** (how we'll measure success)

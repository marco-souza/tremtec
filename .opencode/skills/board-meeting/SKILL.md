---
name: board-meeting
description: >-
  Facilitate and manage board meetings for executive decision-making. Orchestrates
  CEO, CTO, CFO, CMO, and CPO agents to discuss strategic topics, analyze options,
  and reach consensus on high-level business decisions. Manages meeting workflow
  from agenda creation through action items.
---

## What I Do

- **Meeting Facilitation**: Guide structured board meetings with clear agendas and outcomes
- **Executive Orchestration**: Coordinate CEO, CTO, CFO, CMO, and CPO agents in parallel discussions
- **Decision Documentation**: Capture decisions, rationale, and dissenting views
- **Action Item Tracking**: Convert decisions into assigned tasks with owners and deadlines
- **Strategic Analysis**: Present topics from multiple executive perspectives
- **Consensus Building**: Identify alignment and surface areas of disagreement

## When to Use Me

Use this skill when:

- Making major strategic decisions requiring multiple executive perspectives
- Setting company direction, priorities, or significant pivots
- Allocating substantial resources or budget
- Evaluating new markets, partnerships, or acquisitions
- Reviewing quarterly/annual performance and planning
- Resolving cross-functional strategic conflicts

## Meeting Workflow

### Phase 1: Agenda Preparation

1. **Define Topics**: User provides 1-3 strategic topics for discussion
2. **Context Gathering**: Collect relevant data, reports, and background
3. **Agenda Distribution**: Share agenda with timing and desired outcomes
4. **Pre-Read Materials**: Prepare executive summaries for review

### Phase 2: Executive Input (Parallel)

For each agenda item, gather perspectives from all relevant executives in parallel:

**CEO**: Strategic alignment, vision, stakeholder impact
**CTO**: Technical feasibility, architecture, engineering capacity
**CFO**: Financial implications, ROI, resource allocation
**CMO**: Market fit, customer impact, go-to-market considerations
**CPO**: User value, product strategy, roadmap implications

### Phase 3: Synthesis & Discussion

1. **Present Perspectives**: Summarize executive viewpoints
2. **Identify Alignment**: Areas of consensus
3. **Surface Tensions**: Areas of disagreement or tradeoffs
4. **Facilitate Tradeoffs**: Guide discussion toward resolution

### Phase 4: Decision & Documentation

1. **Document Decision**: Clear decision statement
2. **Capture Rationale**: Why this decision was made
3. **Note Dissent**: Any significant disagreements (without attribution)
4. **Define Success**: How to measure if this was the right call

### Phase 5: Action Items

1. **Assign Owners**: Who does what
2. **Set Deadlines**: When each action is due
3. **Define Deliverables**: What completion looks like
4. **Schedule Follow-up**: When to review progress

## Output Structure

### Board Meeting Minutes

```markdown
# Board Meeting - [Date]

## Attendees

- CEO
- CTO
- CFO
- CMO
- CPO

## Agenda

### Topic 1: [Title]

#### Executive Perspectives

**CEO**: [Strategic view]
**CTO**: [Technical view]
**CFO**: [Financial view]
**CMO**: [Marketing view]
**CPO**: [Product view]

#### Discussion Summary

[Key points raised, tradeoffs considered]

#### Decision

[Clear decision statement]

#### Rationale

[Why this decision was made]

#### Action Items

| Task   | Owner   | Due    | Status |
| ------ | ------- | ------ | ------ |
| [Task] | [Owner] | [Date] | `todo` |

### Topic 2: [Title]

...

## Summary

- Decisions made: [N]
- Action items created: [N]
- Follow-up meeting: [Date/Trigger]
```

## Best Practices

- **Limited Agenda**: Maximum 3 topics per meeting for depth
- **Preparation Required**: Executives review materials before meeting
- **Parallel Input**: Gather all perspectives simultaneously for efficiency
- **Clear Decisions**: Every topic ends with a decision or explicit deferral
- **Dissent Recorded**: Note significant disagreements without attribution
- **Action-Oriented**: Every decision spawns concrete next steps
- **Follow-Through**: Schedule progress review within 30 days

## Communication Style

- **Neutral Facilitation**: Present all views fairly without bias
- **Structured Output**: Consistent format for easy reference
- **Concise Summaries**: Executive time is valuable — be brief
- **Action-Focused**: Emphasize what happens next
- **Professional Tone**: Board meetings are formal but collaborative

## Decision Types

**Consensus**: All executives agree — proceed with confidence
**Majority**: Most agree, some dissent — document concerns, proceed with caution
**Split**: Significant disagreement — escalate to tie-breaker or gather more data
**Deferred**: Not enough information or wrong timing — schedule follow-up

## Integration Points

- Output feeds into `.opencode/backlog.md` for product priorities
- Action items feed into project management tools
- Decisions inform `.opencode/strategy.md` for strategic direction
- Financial decisions update financial models (CFO domain)
- Technical decisions update architecture docs (CTO domain)
- Marketing decisions update GTM plans (CMO domain)
- Product decisions update roadmap (CPO domain)

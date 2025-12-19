---
trigger: manual
---

# AI Development Workflow: SRPI (Spec → Research → Plan → Implement)

This is the standard workflow for all new features. Follow this process to ensure quality, clarity, and thorough understanding before implementation.

## Overview

**SRPI** is a four-phase structured approach to feature development:

> **Tip**: Use the workflow command `/feature` to guide you through this process automatically.

1. **Spec** (Specification): Define requirements and acceptance criteria
2. **Research** (Technical Research): Investigate technology, versions, APIs, and best practices
3. **Plan** (Implementation Plan): Create detailed step-by-step execution tasks
4. **Implement** (Implementation): Execute the plan with code changes

## When to Use SRPI

- ✅ Any new feature or significant change
- ✅ Third-party integrations (APIs, SDKs, libraries)
- ✅ Architectural decisions
- ✅ Features with external dependencies
- ✅ Complex user flows or business logic

## When SRPI is Optional

- ⚠️ Minor bug fixes (direct to implementation)
- ⚠️ Simple refactoring (direct to implementation)
- ⚠️ Documentation updates (direct to implementation)

---

## Phase 1: Specification (S)

**Purpose**: Define what needs to be built, not how.

**File Location**: `specs/NNN-feature-name.md` (replace NNN with sequential number)

**Template**: Use `specs/000-spec-template.md` as reference

**Must Include**:

- Feature Name (clear, descriptive)
- Objective (1-2 sentences explaining purpose and goals)
- User Story (As a [role], I want [goal] so that [reason])
- Functional Requirements (clear, testable requirements)
- Success Criteria (measurable indicators)
- Notes (constraints, assumptions, additional context)

**Example Headers**:

```markdown
# Feature Specification: [Feature Name]

## Feature Name

[Concise, descriptive name]

## Objective

[Purpose and goals in 1-2 sentences]

## User Story

As a [user role], I want to [goal] so that [reason].

## Functional Requirements

- [Requirement 1]
- [Requirement 2]

## Success Criteria

- [Criterion 1]
- [Criterion 2]

## Notes

[Optional: constraints, assumptions, context]
```

**Agent Responsibility**:

1. Create spec file from template
2. Fill in all sections with user input
3. Ask for clarification if needed
4. Ensure spec is complete before proceeding to Research

---

## Phase 2: Technical Research (R)

**Purpose**: Investigate technology, versions, dependencies, and best practices. Document findings for implementation clarity.

**File Location**: `specs/NNN-feature-name.research.md` (same number as spec)

**Must Include**:

- Current versions of relevant technologies
- Dependency analysis (new packages, existing tools)
- API/Service specifications
- Technical architecture recommendations
- Implementation options with pros/cons
- Security considerations
- Performance constraints
- Integration patterns used in similar features
- Task breakdown (human vs. agent work)

**Example Sections**:

```markdown
# Technical Research: [Feature Name]

## Executive Summary

[Brief overview of findings and recommendations]

## 1. Technology Versions & Current State

- Library versions
- API versions
- Compatibility information

## 2. Technical Architecture

- Client-side details
- Server-side details
- Integration points

## 3. Project Requirements Analysis

- Configuration needs
- Environment variables
- Dependencies

## 4. Dependency Analysis

- New packages to add
- Existing tools to leverage
- Optional libraries

## 5. Key Technical Constraints

- Security considerations
- Performance limits
- Compatibility issues

## 6. Implementation Options

- Option A: Recommended
- Option B: Alternative
- Pros/cons of each

## 7. Implementation Tasks

### Phase 1: Setup (HUMAN/AGENT)

- [ ] Task 1
- [ ] Task 2

### Phase 2: Development (AGENT)

- [ ] Task 3
- [ ] Task 4

## 8. References

[Links to documentation, examples, resources]

## Summary of Recommendations

[Key takeaways for planning phase]
```

**Agent Responsibility**:

1. Search for latest versions and documentation
2. Investigate existing project patterns
3. Document API specifications
4. Identify potential risks and mitigations
5. Recommend technology choices with justification
6. Break down into human and agent tasks
7. Provide implementation guidance
8. **Format `.md` files with Prettier before saving**

---

## Phase 3: Implementation Plan (P)

**Purpose**: Create a detailed, step-by-step execution roadmap with code examples and verification steps.

**File Location**: `specs/NNN-feature-name.plan.md` (same number as spec)

**Must Include**:

- Overview & execution strategy
- Prerequisites & dependencies (what must be done first)
- Detailed task list with:
  - Owner (HUMAN or AGENT)
  - Duration estimate
  - Blocking dependencies
  - Step-by-step instructions
  - Code examples
  - Verification checklist
- Implementation sequence (recommended order)
- Critical path diagram
- Testing strategy
- Rollback plan
- Success criteria
- Estimated timeline
- Risk mitigation matrix

**Example Task Format**:

````markdown
### [TASK N-X] Task Name

**Owner**: HUMAN/AGENT  
**Duration**: 15 minutes  
**Depends On**: Task M-Y  
**Blocks**: Task O-Z  
**Status**: `todo`

#### Steps

1. First step with details
2. Code example:
   ```elixir
   # Code here
   ```

3. Verification steps

#### Verification

- [ ] Checklist item 1
- [ ] Checklist item 2

````

**Agent Responsibility**:
1. Create detailed, actionable steps
2. Include actual code examples
3. Specify exact file paths and commands
4. Provide verification steps for each task
5. Order tasks logically with clear dependencies
6. Estimate durations based on complexity
7. Create visual sequence diagram
8. Document risks and mitigations
9. Define success criteria

**Formatting**:
- **Markdown Files**: Always format `.md` files with Prettier before saving
  - Run `npx prettier --write path/to/file.md` or use editor integration
  - Ensures consistent formatting across all documentation

---

## Phase 4: Implementation (I)

**Purpose**: Execute the plan and implement the feature.

**Guidelines**:
- Follow the plan strictly; deviate only for good reasons
- Update plan if tasks change; document why
- Test as you go (don't wait for the end)
- Keep commits atomic and well-messaged
- Run `mix precommit` before each commit
- Update documentation alongside code
- **Format all `.md` files with Prettier before saving** (run `npx prettier --write file.md` or use editor integration)
- Reference spec/research/plan in commit messages

**Agent Responsibility**:
1. Execute each task in order (respecting dependencies)
2. Follow verification checklist for each task
3. Write tests for new code
4. Update documentation (format `.md` files with Prettier)
5. Commit changes with clear messages
6. Mark completed tasks in plan
7. Report blockers early

---

## SRPI Workflow Summary

| Phase | Owner | Input | Output | Duration |
|-------|-------|-------|--------|----------|
| **S** (Spec) | Human + Agent | Ideas, requirements | `NNN-feature.md` | 15-30 min |
| **R** (Research) | Agent | Research questions | `NNN-feature.research.md` | 30-60 min |
| **P** (Plan) | Agent | Research findings | `NNN-feature.plan.md` | 30-45 min |
| **I** (Implement) | Agent | Implementation plan | Code + tests + docs | Varies |

**Total Pre-Implementation**: ~2-3 hours
**ROI**: Eliminates rework, clarifies scope, reduces implementation time

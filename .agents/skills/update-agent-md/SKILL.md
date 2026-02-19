---
name: update-agent-md
description: "Updates AGENTS.md with new technical guidelines and architectural patterns. Use whenever establishing new architectural patterns, domain layer approaches, or development conventions."
---

# Update AGENTS.md Skill

Keeps AGENTS.md in sync with evolving technical standards and architectural decisions.

## Purpose

AGENTS.md is the single source of truth for project conventions. When you establish new patterns, this skill ensures they're documented.

## When to Update AGENTS.md

Update when:

- **Establishing new architectural patterns** (e.g., DDD, state management approaches)
- **Creating new domain layers or abstractions**
- **Defining feature-wide conventions**
- **Changing code style or structure rules**
- **Adding reusable patterns others should follow**

DO NOT add:

- Feature-specific implementation details (goes in `docs/wip/PHASE_IMPLEMENTATION.md`)
- Phase or sprint references
- Temporary decisions or experiments
- Code examples (unless they're patterns)

## Update Workflow

1. **Identify the change**:
   - What new pattern or convention exists?
   - Is it project-wide or feature-specific?
   - Will other features benefit from it?

2. **Find the right section** in AGENTS.md:
   - **Code Style & Conventions**: Formatting, naming, imports
   - **Domain Layer Patterns**: Zod, services, state management
   - **Architecture & Structure**: File organization, module boundaries
   - Create new section if needed (but be selective)

3. **Write concise guidelines**:
   - Start with principle, not implementation
   - Use bullet points (not paragraphs)
   - Example: "Define domain types with Zod (value objects, entities, DTOs)"
   - Link to feature docs for deep dives: `See docs/wip/PHASE1_IMPLEMENTATION.md for Kanban`

4. **Keep it general**:
   - Don't mention specific files/features unless truly shared
   - Focus on the pattern (not the project)
   - Other developers should understand the principle

## AGENTS.md Structure

```
# AGENTS.md

- Build, Lint & Test Commands
- Architecture & Structure
- Code Style & Conventions
- Domain Layer Patterns        ← Add here for DDD/services/testing
- [Other sections as needed]
```

## Example: Good Addition

**Pattern identified**: Optimistic updates in state management

**Good AGENTS.md entry**:

```
- **State Management**: Use SolidJS signals for reactive updates
  - Support optimistic updates: update UI immediately, sync asynchronously
  - Separate UI state (drag, loading, error) from domain state
```

**Bad entry** (too specific):

```
- **Kanban Store**: Create single Board aggregate with card/lane arrays
  - Use withOptimisticUpdate() helper function
  - Store file: src/stores/kanban.ts
```

## Related Skills

- **quality-gateway**: Ensures code quality (run after writing code)
- **building-skills**: Create new skills when needed
- **code-review**: Review code changes for adherence to AGENTS.md guidelines

## Checklist

Before updating AGENTS.md:

- [ ] Is this a reusable pattern (not feature-specific)?
- [ ] Will multiple features benefit from knowing this?
- [ ] Is it general enough for new projects?
- [ ] Does it fit an existing section or need a new one?
- [ ] Is the language principle-focused, not implementation-focused?

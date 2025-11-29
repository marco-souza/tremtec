# SDD Implementation Rule

## Overview

When implementing features, follow the **Spec-Driven Development (SDD)** three-phase workflow. Each phase requires explicit human approval before proceeding.

## Workflow Phases

### Phase 1: High Level Spec ✅

- **Status**: Must be completed and approved before proceeding
- **File**: `specs/XXX-feature-name.md`
- **Purpose**: Define "what" and "why"
- **Check**: Verify spec exists and is approved

### Phase 2: Detailed Implementation Plan ✅

- **Status**: Must be completed and approved before proceeding
- **File**: `specs/XXX-feature-name.plan.md`
- **Purpose**: Define "how" to implement
- **Check**: Verify plan exists and is approved

### Phase 3: Implementation 🚀

- **Status**: Current phase - implement code
- **Follow**: The approved implementation plan step-by-step

## Implementation Rules

### Before Starting Implementation

1. **Verify Prerequisites**:
   - [ ] Phase 1 spec exists and is approved
   - [ ] Phase 2 implementation plan exists and is approved
   - [ ] Read both documents thoroughly

2. **Confirm Approval**:
   - Ask user: "I see the spec and plan. Do you approve proceeding with implementation?"
   - Wait for explicit approval before coding

### During Implementation

1. **Follow the Plan**:
   - Implement step-by-step as outlined in the plan
   - Don't skip steps or jump ahead
   - Reference the plan file frequently

2. **File Changes**:
   - Create/modify files exactly as specified in the plan
   - If deviations are needed, ask for approval first
   - Document any changes from the plan

3. **Testing**:
   - Write tests as specified in the plan
   - Run tests after each major step
   - Ensure all tests pass before moving to next step

4. **Code Quality**:
   - Follow project guidelines (see `AGENTS.md`)
   - Run `mix precommit` before completing
   - Ensure code is formatted and linted

### Implementation Checklist

- [ ] All files from plan are created/modified
- [ ] All database migrations are created and run
- [ ] All configuration changes are applied
- [ ] All tests are written and passing
- [ ] Code follows project guidelines
- [ ] `mix precommit` passes
- [ ] Success criteria from spec are met
- [ ] Documentation is updated (if needed)

### When Stuck or Deviating

1. **If blocked**: Stop and ask for clarification
2. **If plan needs changes**: Propose changes and get approval
3. **If unexpected issues**: Document and ask how to proceed
4. **Never**: Skip steps or make assumptions without approval

## Example Usage

```markdown
User: "Implement the auth system refactoring"

AI Response:
"I see spec `specs/003-auth-system-refactoring.md` exists. 
Do you have an approved implementation plan (`specs/003-auth-system-refactoring.plan.md`)? 
If yes, I'll proceed with implementation following the plan step-by-step."
```

## Success Criteria

Implementation is complete when:

- ✅ All steps from the plan are implemented
- ✅ All tests pass
- ✅ All success criteria from the spec are met
- ✅ Code review is ready
- ✅ `mix precommit` passes

## Important Notes

- **Never skip phases**: Always ensure Phase 1 and Phase 2 are approved
- **Follow the plan**: Don't improvise - stick to the approved plan
- **Ask for approval**: When in doubt, ask before proceeding
- **Document deviations**: If plan changes are needed, document them
- **Test frequently**: Don't wait until the end to test

## Reference Documents

- `docs/SPEC_DRIVEN_DEVELOPMENT.md` - Full SDD workflow documentation
- `specs/000-implementation-plan-template.md` - Plan template
- `specs/000-spec-template.md` - Spec template
- `AGENTS.md` - Project guidelines and code patterns

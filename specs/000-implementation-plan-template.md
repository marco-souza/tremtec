# Implementation Plan Template

**Feature**: [Feature Name from Spec]

**Spec Reference**: `specs/XXX-feature-name.md`

**Status**: [ ] Draft | [ ] Ready for Review | [ ] Approved | [ ] In Progress | [ ] Complete

## Overview

[Brief summary of what will be implemented, referencing the approved spec]

## Technical Research & Discovery

### Research Conducted

- [ ] Reviewed relevant documentation
- [ ] Examined existing codebase patterns
- [ ] Researched dependencies and integrations
- [ ] Identified potential technical challenges

### Key Findings

[Document important discoveries, gotchas, or decisions made during research]

### Open Questions

[Any questions that need clarification before implementation]

## Dependencies

### New Dependencies to Add

- [ ] `package_name` - Reason for adding

### Existing Dependencies Used

- [ ] `package_name` - How it will be used

## File Changes

### New Files to Create

- [ ] `path/to/new_file.ex` - Purpose/description
- [ ] `path/to/new_file.heex` - Purpose/description

### Existing Files to Modify

- [ ] `path/to/existing_file.ex` - Changes needed
- [ ] `path/to/existing_file.ex` - Changes needed

### Files to Delete

- [ ] `path/to/file_to_delete.ex` - Reason for deletion

## Database Changes

### Migrations Needed

- [ ] `YYYYMMDDHHMMSS_description.exs` - What it does
- [ ] `YYYYMMDDHHMMSS_description.exs` - What it does

### Schema Changes

- [ ] `SchemaName` - Fields to add/modify/remove

## Configuration Changes

### Runtime Config (`config/runtime.exs`)

- [ ] Add `ENV_VAR_NAME` - Purpose
- [ ] Remove `ENV_VAR_NAME` - Reason

### Application Config (`config/config.exs`)

- [ ] Add/modify config for `:app_name` - Purpose

## Implementation Steps

### Step 1: [Step Name]

**Description**: [What this step accomplishes]

**Files**:

- Create: `path/to/file.ex`
- Modify: `path/to/file.ex`

**Dependencies**: [Any prerequisites]

**Testing**: [How to verify this step]

### Step 2: [Step Name]

[Repeat structure for each step]

## Testing Strategy

### Unit Tests

- [ ] Test `Module.function/arity` - What it tests
- [ ] Test `Module.function/arity` - What it tests

### Integration Tests

- [ ] Test [feature/flow] - What it tests
- [ ] Test [feature/flow] - What it tests

### Manual Testing Checklist

- [ ] [Test scenario 1]
- [ ] [Test scenario 2]
- [ ] [Test scenario 3]

## Risk Assessment

### Technical Risks

- **Risk**: [Description]
  - **Mitigation**: [How to address]

### Dependencies Risks

- **Risk**: [Description]
  - **Mitigation**: [How to address]

## Rollback Plan

[If something goes wrong, how to rollback]

## Success Verification

- [ ] All functional requirements from spec are met
- [ ] All success criteria from spec are met
- [ ] All tests pass
- [ ] Code follows project guidelines
- [ ] `mix precommit` passes
- [ ] Documentation updated

## Notes

[Any additional notes, considerations, or context]

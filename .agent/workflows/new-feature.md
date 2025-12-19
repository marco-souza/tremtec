---
description: Start a new feature using the SRPI (Spec -> Research -> Plan -> Implement) process
---

# New Feature Workflow (SRPI)

Follow this workflow to implement a new feature using the Spec-Driven Development process.

## 1. Feature Definition

1.  **Ask the user**: "What is the name of the feature you want to build? (e.g., `user-profile`, `payment-integration`)"
2.  **Ask the user**: "Briefly describe the objective and goal of this feature."

## 2. Specification (Phase S)

1.  **Find the next sequential number** for specs by listing files in `specs/`.
2.  **Create the Spec File**:
    -   Create `specs/NNN-feature-name.md` using the template below.
    -   Fill in the `Feature Name`, `Objective` (from user input), and skeleton sections.

    <details>
    <summary>Spec Template</summary>

    ```markdown
    # Feature Specification: [Feature Name]

    ## Feature Name
    [Feature Name]

    ## Objective
    [Objective provided by user]

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
    </details>

3.  **Refine the Spec**:
    -   Ask the user for specific functional requirements, user stories, and success criteria to fill in the gaps.
    -   **Loop**: Update the file and ask for confirmation until the user approves the Spec.

## 3. Technical Research (Phase R) (Optional but Recommended)

1.  **Ask the user**: "Do we need a technical research phase for this feature? (Recommended for complex features, integrations, or new tech)"
2.  **If YES**:
    -   Create `specs/NNN-feature-name.research.md`.
    -   Investigate necessary libraries, APIs, or patterns.
    -   Document findings in the research file.
    -   **Loop**: Present findings and get user approval.

## 4. Implementation Plan (Phase P)

1.  **Create the Plan File**:
    -   Create `specs/NNN-feature-name.plan.md`.
    -   Break down the implementation into granular tasks (Setup, Core Logic, UI, Testing).
    -   Estimate duration for each task.
    -   Define verification steps.

    <details>
    <summary>Plan Template</summary>

    ```markdown
    # Implementation Plan - [Feature Name]

    ## Proposed Changes

    ### Configuration
    - [ ] Add config x
    - [ ] Add env var y

    ### Database
    - [ ] Migration: add table z

    ### Core Logic
    - [ ] Create context module
    - [ ] Implement function a

    ### UI
    - [ ] Create LiveView b
    - [ ] Add component c

    ## Verification Plan
    ### Automated Tests
    - [ ] Test module A
    - [ ] Test flow B

    ### Manual Verification
    - [ ] Verify scenario X
    ```
    </details>

2.  **Refine the Plan**:
    -   **Loop**: Present the plan to the user and ask for feedback/approval. Do not proceed until approved.

## 5. Implementation (Phase I)

1.  **Execute**: Start implementing the changes following the approved plan.
2.  **Check**: Mark tasks as completed in the plan file as you go.
3.  **Verify**: Run tests and manual verification steps.

---
name: cpo-agent
description: Strategic product leader responsible for defining the "What" and "Why" of the product.
---

# CPO Agent Skills

The CPO Agent validates ideas, defines the MVP scope, and creates comprehensive Product Requirements Documents (PRDs).

## Tools

### `analyze-market-trends`

* **Description**: Searches for current trends related to the idea to validate demand.
* **Inputs**: `query` (string)
* **Outputs**: `report` (string - summary of trends)

### `analyze-competitors`

* **Description**: Identifies potential competitors and their feature sets.
* **Inputs**: `niche` (string)
* **Outputs**: `competitor_list` (List[Dict] - competitor names and features)

### `generate-prd`

* **Description**: Creates a structured Product Requirements Document based on the idea and research.
* **Inputs**:
  * `idea` (string)
  * `research` (string - context from analysis)
* **Outputs**: `prd_markdown` (string - markdown formatted PRD)

### `prioritize-mvp-features`

* **Description**: Selects the critical features for the MVP, effectively cutting scope creep.
* **Inputs**: `feature_list` (List[string])
* **Outputs**: `mvp_features` (List[string])

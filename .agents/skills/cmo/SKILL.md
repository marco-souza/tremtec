---
name: cmo-agent
description: Marketing strategist responsible for defining the "Who" and "How to Sell" the product.
---

# CMO Agent Skills

The CMO Agent defines the Go-to-Market strategy, identifies the target audience, and establishes the brand voice.

## Tools

### `generate-user-persona`

* **Description**: Creates detailed profiles of target users (pain points, demographics, behaviors).
* **Inputs**: `product_description` (string)
* **Outputs**: `persona` (Dict - structured persona data)

### `create-gtm-strategy`

* **Description**: Outlines the Go-to-Market plan, including channels, launch tactics, and pricing strategies.
* **Inputs**:
  * `prd` (string - product context)
  * `persona` (Dict - target audience)
* **Outputs**: `marketing_plan` (string - markdown formatted plan)

### `generate-brand-voice`

* **Description**: Defines the tone of voice for the brand (e.g., "Professional", "Playful", "Inspirational").
* **Inputs**: `target_audience` (string)
* **Outputs**: `brand_guidelines` (string - textual guidelines)

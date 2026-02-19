---
name: visual-designer-agent
description: Creative designer responsible for the visual identity and UI concepts.
---

# Visual Designer Agent Skills

The Visual Designer Agent creates visual assets plans and prompts for generative image tools to create logos and UI mockups.

## Tools

### `generate-logo-prompt`

* **Description**: Creates a highly detailed prompt for an image generator (DALL-E 3/Midjourney) to create a logo.
* **Inputs**:
  * `brand_name` (string)
  * `style` (string - e.g., "Minimalist", "Cyberpunk")
* **Outputs**: `prompt` (string - ready-to-use prompt)

### `generate-ui-wireframe`

* **Description**: Generates a text-based description or simple HTML structure for a UI layout.
* **Inputs**: `page_type` (string - e.g., "Landing Page", "Dashboard")
* **Outputs**: `wireframe_code` (string - HTML/Tailwind snippet or description)

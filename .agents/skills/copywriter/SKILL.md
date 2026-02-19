---
name: copywriter-agent
description: Creative writer responsible for converting visitors into users through persuasive text.
---

# Copywriter Agent Skills

The Copywriter Agent generates high-quality text for landing pages, emails, and social media, adhering to the defined brand voice.

## Tools

### `write-landing-page-copy`

* **Description**: Generates persuasive text for the landing page sections (Hero, Features, Testimonials, CTA).
* **Inputs**:
  * `product_info` (string)
  * `tone` (string - brand voice)
* **Outputs**: `copy_json` (Dict - structured copy for each section)

### `write-email-sequence`

* **Description**: Creates a welcome email series for new signups or a nurture sequence.
* **Inputs**:
  * `product_name` (string)
  * `value_prop` (string)
* **Outputs**: `emails` (List[string] - list of email bodies)

### `generate-social-posts`

* **Description**: Creates a batch of tweets, LinkedIn posts, or other social content for the launch.
* **Inputs**:
  * `platform` (string - e.g., "Twitter", "LinkedIn")
  * `topic` (string)
* **Outputs**: `posts` (List[string])

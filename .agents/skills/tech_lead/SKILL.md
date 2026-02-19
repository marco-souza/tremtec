---
name: tech-lead-agent
description: Technical architect responsible for the system structure, database design, and cloud infrastructure.
---

# Tech Lead Agent Skills

The Tech Lead Agent designs the database schema (Cloudflare D1), plans the directory structure for new features in Astro, and manages infrastructure configuration (Wrangler).

## Tools

### `design-d1-schema`

* **Description**: Generates SQL schema for Cloudflare D1 (SQLite) based on requirements.
* **Inputs**: `data_requirements` (List[string] - description of data models needed)
* **Outputs**: `sql_code` (string - valid SQL CREATE TABLE statements)

### `scaffold-astro-feature`

* **Description**: Generates the comprehensive folder structure plan for a new feature within the `src/` directory.
* **Inputs**: `feature_name` (string)
* **Outputs**: `structure_plan` (string - description of files and folders to create)

### `configure-wrangler`

* **Description**: Generates or updates `wrangler.jsonc` configurations for resources like KV, D1, or Queues.
* **Inputs**: `resource_needs` (List[string] - e.g., "KV namespace for session", "D1 database for users")
* **Outputs**: `config_snippet` (string - JSONC snippet for wrangler configuration)

### `review-code-architecture`

* **Description**: Reviews proposed code snippets for adherence to patterns, security, and scalability.
* **Inputs**: `code_snippet` (string)
* **Outputs**: `review_comments` (string)

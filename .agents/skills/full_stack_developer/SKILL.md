---
name: full-stack-developer-agent
description: Implementation specialist responsible for writing the actual code for frontend and backend.
---

# Full-Stack Developer Agent Skills

The Full-Stack Developer Agent implements the features using TypeScript, SolidJS, Hono, and Tailwind CSS.

## Tools

### `generate-hono-api`

* **Description**: Generates a Hono API route handler (REST or RPC) for the backend logic.
* **Inputs**:
  * `route_path` (string)
  * `logic` (string - description of what the endpoint does)
* **Outputs**: `ts_code` (string - TypeScript code for the Hono handler)

### `generate-solid-component`

* **Description**: Generates a functional SolidJS component formatted with Tailwind CSS.
* **Inputs**:
  * `component_name` (string)
  * `requirements` (string - props, state, UI description)
* **Outputs**: `tsx_code` (string - SolidJS component code)

### `generate-zod-schema`

* **Description**: Creates a Zod schema for data validation (API inputs or form validation).
* **Inputs**: `data_structure` (Dict - fields and types needed)
* **Outputs**: `ts_code` (string - Zod schema definition)

### `write-vitest-test`

* **Description**: Generates unit tests for a specific component or API endpoint using Vitest.
* **Inputs**: `file_path` (string - path to the file to be tested)
* **Outputs**: `test_code` (string - Vitest test suite)

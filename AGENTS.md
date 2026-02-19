# TremTec AI Agents

This repository defines the AI Agent workforce for the TremTec Accelerator.

## 🤖 Agent Roles & Skills
The specific capabilities (tools) for each agent are defined in `.agents/skills`:

*   **[CPO Agent](.agents/skills/cpo/SKILL.md)**: Product Strategy, Market Analysis, PRD Generation.
*   **[CMO Agent](.agents/skills/cmo/SKILL.md)**: Marketing Strategy, User Personas.
*   **[Tech Lead Agent](.agents/skills/tech_lead/SKILL.md)**: Architecture, DB Schema, Code Review.
*   **[Copywriter Agent](.agents/skills/copywriter/SKILL.md)**: Content Generation.
*   **[Visual Designer Agent](.agents/skills/visual_designer/SKILL.md)**: UI/UX Concepts.
*   **[Full-Stack Developer Agent](.agents/skills/full_stack_developer/SKILL.md)**: Coding (Astro, SolidJS, Hono).

## 📜 Operation Rules
The standard operating procedures for agents are defined in `.agents/rules`:

*   **[Agent Workflows](.agents/rules/workflows.md)**: Defines the state machines for "New Product", "New Feature", and "Bug Fix" processes.

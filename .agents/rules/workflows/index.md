# TremTec Agent Workflows

This directory contains the standard operational workflows for AI Agents within the TremTec ecosystem. All agent interactions and state transitions must adhere to these flows.

## Available Workflows

Choose the workflow that matches your use case:

1. **[New Product](new-product.md)** (Zero to One 🚀)
   - Convert a raw idea into a deployed MVP
   - Trigger: User submits a new idea via the Platform
   - Involves: CPO Agent, Tech Lead, Dev Agents, CMO, Designer

2. **[New Feature](new-feature.md)** (Iteration 🔄)
   - Add functionality to an existing codebase safely
   - Trigger: User request for a new feature
   - Involves: CPO Agent, Tech Lead, Dev Agents, Automated Testing

3. **[Bug Fix](bug-fix.md)** (Maintenance 🛠️)
   - Resolve errors or bugs reported by users or monitoring
   - Trigger: Error log or user report
   - Involves: Tech Lead, Dev Agents, Code Review

4. **[Board Meeting](board-meetings.md)** (Strategic Sync 📊)
   - Facilitate structured conversations between board members to discuss strategy, progress, and decisions
   - Trigger: Scheduled meeting or user-initiated board sync request
   - Involves: CPO Agent, CMO Agent, Tech Lead, Full-Stack Dev Agent

## How LLMs Should Use These

Load the specific workflow file that matches your task:

```bash
# For a new product
Load: new-product.md

# For adding a feature to existing product
Load: new-feature.md

# For fixing a reported bug
Load: bug-fix.md

# For board/strategic discussions
Load: board-meetings.md
```

Each workflow contains:

- **Objective**: What the workflow accomplishes
- **Trigger**: When to use it
- **Diagram**: Visual representation of the process (Mermaid)
- **Details**: Specific roles, responsibilities, and decision points

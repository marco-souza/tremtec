---
name: opencode
description: OpenCode AI coding agent — tools, agents, skills, permissions, and platform conventions.
---

## What I do

- Provide structured access to project files (read, write, edit, search)
- Execute shell commands and scripts
- Invoke specialized subagents for specific tasks
- Load reusable skill definitions
- Enforce permission boundaries (allow/ask/deny per tool)

## When to use me

Use this skill whenever an agent needs to understand the OpenCode platform:

- Choosing the right tool for a task (read vs write vs bash)
- Deciding when to invoke a subagent vs handling directly
- Loading a specialized skill for domain knowledge
- Understanding permission boundaries (what requires user approval)
- Switching between primary agents (Tab key)

## Tools Reference

| Tool        | Purpose                             | Default |
| ----------- | ----------------------------------- | ------- |
| `read`      | Read file contents                  | allow   |
| `write`     | Create/overwrite files              | allow   |
| `edit`      | Exact string replacement in files   | allow   |
| `bash`      | Execute shell commands              | allow   |
| `grep`      | Search file contents by regex       | allow   |
| `glob`      | Find files by pattern               | allow   |
| `list`      | List directory contents             | allow   |
| `webfetch`  | Fetch web content (URL to markdown) | allow   |
| `question`  | Ask user for input/choices          | allow   |
| `todowrite` | Create and update task lists        | allow   |
| `skill`     | Load a SKILL.md definition          | allow   |

## Agent Modes

**Primary agents**: Switchable via Tab key. Handle main conversation.

- `build` — default, all tools enabled
- `plan` — read-only analysis, all edits/bashes set to ask

**Subagents**: Invoked via Task tool or @mention for specialized work.

- `general` — research, multi-step tasks, full tool access
- `explore` — read-only codebase exploration
- Plus custom agents (code-reviewer, qa-engineer, architect, etc.)

## Invoking Subagents

Use the Task tool to invoke a subagent:

```
task({ description: "...", prompt: "...", subagent_type: "code-reviewer" })
```

Or via @ mention in a message:

```
@code-reviewer analyze this code for API misuse
```

## Loading Skills

Use the skill tool to load domain knowledge:

```
skill({ name: "astro" })
skill({ name: "hono" })
skill({ name: "testing" })
```

Skills are defined in `.opencode/skills/<name>/SKILL.md`.

## Permission System

- `allow` — executes without prompting
- `ask` — prompts user for approval
- `deny` — tool is disabled

Override per-agent in agent markdown files or opencode.json.

## Official Docs

https://opencode.ai/docs/agents
https://opencode.ai/docs/tools
https://opencode.ai/docs/skills

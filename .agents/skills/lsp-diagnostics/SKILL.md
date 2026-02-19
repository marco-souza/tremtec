---
name: lsp-diagnostics
description: "Checks TypeScript syntax errors, linting issues, and type problems across files or directories. Use when you need to identify code quality issues, verify compilation, or catch errors before committing."
---

# LSP Diagnostics Skill

Run TypeScript compiler and linting diagnostics to catch syntax errors, type issues, and code quality problems.

## What This Skill Does

- **TypeScript Compilation**: Checks for syntax errors, type mismatches, unused variables
- **Linting**: Runs Biome linter to catch style and logic issues
- **Diagnostics by File**: Report errors with file:line:column format
- **Severity Levels**: Groups issues by CRITICAL (errors), HIGH (warnings), MEDIUM (deprecations/hints), LOW (info)
- **Treats warnings and deprecations as errors**: All severity levels (hints, warnings, errors) are reported and must be addressed

## When to Use

- Before committing code
- After making large refactors
- When you see "red squiggles" in the editor
- To verify no syntax errors in a file or directory
- To catch unused imports or variables

## How to Use

### Check specific file

```
Run diagnostics on src/stores/kanban.ts to find all errors
```

### Check entire directory

```
Run diagnostics on src/lib/domain/ to verify all domain files
```

### Check project after changes

```
Run diagnostics on src/ to ensure no regressions after refactoring
```

## Example Output

```
CRITICAL: src/stores/kanban.ts:45:12
  Missing type annotation on 'board' variable

HIGH: src/lib/domain/services.ts:78:1
  Unused variable 'oldCard' - remove or use it

MEDIUM: src/components/kanban/Card.tsx:12:5
  Unused import: 'useState' (import { useState } from 'solid-js')
```

## Integration with Project

This skill works with:

- **TypeScript Strict Mode** (enabled in tsconfig.json)
- **Biome Linter** (configured in biome.json)
- **AGENTS.md Conventions** (detects violations)

## Typical Workflow

1. **After writing code**: Ask "Can you check diagnostics on [path]?" to find errors
2. **Before committing**: Ask "Verify no syntax errors in src/" to ensure clean code
3. **During refactoring**: Ask "Run diagnostics on src/lib/domain/" to ensure no regressions
4. **Fix issues**: Review diagnostics output, fix ALL issues including hints and deprecations, ask to re-check
5. **Green build**: When diagnostics show NO issues (including hints), code is ready

## Asking the Agent

Use natural language:

- "Check for any syntax errors in the domain layer"
- "Run diagnostics on src/stores/kanban.ts"
- "Verify src/lib/domain/ has no type issues"
- "Are there any linting errors I should know about?"

The agent will use `get_diagnostics` tool to find and report issues.

## Critical Protocol

When fixing diagnostics issues:

1. **Research first**: Always search online or check documentation BEFORE attempting any fix
2. **No suppression**: Never suppress warnings, deprecations, or hints - they must be fixed properly
3. **Find root cause**: Understand WHY the diagnostic appears, not just how to hide it
4. **Proper fix**: Apply the correct solution from official docs/research, not workarounds
5. **Verify**: Re-run diagnostics to confirm all issues are resolved

## Notes

- This skill respects `.gitignore` and skips node_modules
- Works with `.ts`, `.tsx`, `.js` files
- Reports organized by severity (CRITICAL > HIGH > MEDIUM > LOW)
- **All issues must be fixed**: errors, warnings, hints, and deprecations are all treated as blocking issues
- Returns zero exit code only when ALL diagnostics (including hints) are resolved

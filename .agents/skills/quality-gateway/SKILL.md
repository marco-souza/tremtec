---
name: quality-gateway
description: "Automatically runs linting and formatting on code. Use whenever creating or modifying TypeScript/JavaScript files to ensure code quality and consistency."
---

# Quality Gateway Skill

Ensures all code meets project quality standards by running linting and formatting checks.

## Triggers

Run this skill whenever you:

- Create new TypeScript/JavaScript files
- Modify existing code files
- Generate domain services, components, or stores
- Write test files

## Standard Workflow

After creating or modifying code:

1. **Run linter/formatter**:

   ```bash
   bun run lint
   ```

2. **Check results**:
   - ✅ Zero issues: Code is clean
   - ⚠️ Warnings: Review but may be acceptable
   - ❌ Errors: Must fix before proceeding

3. **Common fixes**:
   - Unused imports: Remove them
   - Unused variables: Prefix with `_` if intentional
   - Import protocol: Change `"crypto"` → `"node:crypto"`
   - Formatting: Auto-applied

4. **Verify tests still pass** (if applicable):
   ```bash
   bun run test -- path/to/file.test.ts
   ```

## Code Quality Standards (from AGENTS.md)

- **Format**: Double quotes, 2-space indent
- **Imports**: Organize by groups (packages, then aliases)
- **No unused**: Remove unused imports, variables, parameters
- **Node.js imports**: Use `node:` protocol (e.g., `node:crypto`)
- **Naming**: Prefix unused params with underscore: `_boardId`
- **Linter**: Biome (strict mode)

## Integration with Development

Always run quality-gateway:

- After implementing domain services
- After writing tests
- Before committing code
- After generating components
- When updating store logic

## Related

- See AGENTS.md for project code style conventions
- See AGENTS.md > Domain Layer Patterns for architectural guidelines
- Use update-agent-md skill to keep AGENTS.md in sync with new patterns

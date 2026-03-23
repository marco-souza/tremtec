# TremTec AI Agents

TremTec is a **strategic engineering consulting and outsourcing platform** for high-growth companies. This document defines the agent roles, technical standards, and development conventions for the TremTec platform.

## 📖 Overview

**Platform**: Web application (Astro + SolidJS) + Backend API (Hono) deployed on Cloudflare Workers
**Purpose**: Accelerate development processes and scale high-performance technical teams
**Key Workflows**: Service workflows for Implementation, Diagnostics, and Mentoring

See [README.md](README.md) for project overview and setup instructions.

## 🤖 Agent Roles & Skills

The specific capabilities for each agent are defined in `.agents/skills`:

- **[CPO Agent](.agents/skills/cpo/SKILL.md)**: Product Strategy, Market Analysis, PRD Generation, MVP Scoping.
- **[CMO Agent](.agents/skills/cmo/SKILL.md)**: Marketing Strategy, Copy Generation, User Personas, Brand Voice.
- **[Tech Lead Agent](.agents/skills/tech_lead/SKILL.md)**: System Architecture, Database Design, Code Review, Technical Planning.
- **[Copywriter Agent](.agents/skills/copywriter/SKILL.md)**: Marketing Copy, Landing Pages, User Documentation.
- **[Visual Designer Agent](.agents/skills/visual_designer/SKILL.md)**: UI/UX Design, Logo & Branding, Visual Systems.
- **[Full-Stack Developer Agent](.agents/skills/full_stack_developer/SKILL.md)**: Frontend (SolidJS), Backend (Hono), Infrastructure (Pulumi).

## 📜 Operation Rules

The standard operating procedures for agents are defined in `.agents/rules`:

- **[Agent Workflows](.agents/rules/workflows.md)**: Defines state machines for "New Product", "New Feature", and "Bug Fix" processes, including all decision gates and transitions.

## 🏛️ Architecture & Structure

### Clean Architecture

Simplified layered architecture (no DDD boilerplate):

- **Domain Layer** (`src/domain/*/schema.ts`): Entities and business rules
  - Pure data structures with Zod validation
  - No dependencies on frameworks or external services
- **Service Layer** (`src/domain/*/service.ts`): Use cases and business logic
  - Stateless functions that operate on entities
  - Dependencies injected (no direct DB/HTTP calls)
  - Tests co-located with services
- **Controller Layer** (`src/server/`): HTTP handlers
  - Routes, middleware, request/response handling
  - Delegates to services, no business logic
- **Server Layer** (`src/server/`): Hono backend
  - Routes, handlers, middleware
  - Request/response validation with Zod
  - OAuth integration (GitHub, Google)
- **UI Layer** (`src/ui/`): SolidJS components
  - Reactive, fine-grained components
  - Tailwind + DaisyUI for styling
  - Form handling via server actions
- **Infrastructure** (`infra/`): Pulumi IaC
  - Cloudflare Worker deployment
  - Custom domains, redirects, observability
  - Auto-deployment on git commits

### File Organization

```
src/
├── domain/              # Entities & services
│   ├── auth/           # Authentication
│   ├── user/           # User management
│   └── shared/         # Shared types/constants
├── server/             # Backend API (Hono)
├── pages/              # Astro page routes
├── ui/                 # SolidJS components
├── lib/                # Utilities, API clients
├── middleware.ts       # Request handlers
└── config.ts           # Environment setup
```

## 🛠️ Build, Lint & Test Commands

```bash
bun run dev              # Start dev server (Astro)
bun run build            # Build for production
bun run lint             # Run Biome + Astro type check
bun run fix              # Auto-fix linting issues
bun run test             # Run Vitest unit tests
bun run test:ui          # Vitest with UI dashboard
bun w build              # Build Cloudflare Worker
bun w dev                # Test Worker locally
```

## 📝 Code Style & Conventions

### TypeScript

- **Strict Mode**: `tsconfig.json` has `strict: true`
- **No `any`**: Always specify types explicitly
- **Naming**: PascalCase for classes/types, camelCase for functions/variables, kebab-case for files
- **Imports**: Use absolute imports from `src/` (configured in `tsconfig.json`)
- **Testing**: `.test.ts` suffix, co-located with source files

### Code Formatting

- **Linter**: Biome (configured in `biome.json`)
- **Auto-format**: Run `bun run fix` before commit (enforced by lefthook)
- **Line Width**: 100 characters
- **Quotes**: Double quotes in TypeScript

### Component Structure (SolidJS)

- **Naming**: PascalCase, descriptive names (e.g., `LoginForm`, `UserCard`)
- **Props**: Define typed interface for each component
- **Reactivity**: Use SolidJS signals (`createSignal`) for state
- **Styling**: TailwindCSS classes + DaisyUI components
- **Testing**: Use Solid Testing Library for component tests

### Server Routes (Hono)

- **RESTful Design**: GET/POST/PUT/DELETE for resources
- **Validation**: Zod validators on all endpoints
- **Error Handling**: Consistent error response format
- **Middleware**: Global middleware in `src/middleware.ts`

## 🔐 Domain Layer Patterns

### Type Definition with Zod

- Define domain types using Zod schemas (`zod` package)
- Schemas serve as documentation and runtime validation
- Export both type and schema:

  ```ts
  export const UserSchema = z.object({
    id: z.string(),
    email: z.string().email(),
  });
  export type User = z.infer<typeof UserSchema>;
  ```

### Authentication & Authorization

- OAuth 2.0 with GitHub and Google providers (`@hono/oauth-providers`)
- Session-based auth with HTTP-only cookies
- Session name: `tremtec_session` (see `src/domain/auth/constants.ts`)
- Protected routes use middleware authentication

### State Management

- **Server State**: Database + session cookies
- **UI State**: SolidJS signals for reactive updates
- **Form Submission**: Use Astro form actions or Hono routes
- **Data Fetching**: Fetch from Hono API via `src/lib/api-client.ts`

### Testing Domain Logic

- Test files co-located: `src/domain/auth/auth.test.ts`
- Use Vitest for unit tests
- Test domain services in isolation
- Mock external dependencies (DB, OAuth providers)

## 🚀 Deployment

### Infrastructure as Code (Pulumi)

```bash
cd infra
bun run pulumi up --stack prod    # Deploy to production
bun run pulumi up --stack staging # Deploy to staging
```

**Features**:

- Auto-builds Astro + Worker on deploy
- Cloudflare Worker with asset serving
- Custom domain (tremtec.com)
- WWW → apex domain redirect
- Full observability (tracing, logging)

**Requirements**:

- Cloudflare account with API token
- GitHub OAuth credentials
- Google OAuth credentials
- `PULUMI_CONFIG_PASSPHRASE` environment variable

## 📋 Development Workflow

### When Starting a Task

1. **Read the PRD**: Understand what, why, and success criteria
2. **Review Architecture**: Check `AGENTS.md` and service layer patterns
3. **Plan Implementation**: Tech lead reviews design before coding
4. **Write Tests**: Test-first for domain logic
5. **Implement**: Follow code style conventions
6. **Lint & Test**: `bun run lint` then `bun run test`
7. **Commit & Push**: Git push triggers CI/CD deployment

### When Adding New Features

1. Create directory in `src/domain/feature-name/`
2. Define entity schemas (`schema.ts`) with Zod
3. Implement service logic (`service.ts`) with use cases
4. Add controller routes in `src/server/router.ts`
5. Create UI components in `src/ui/`
6. Add tests for service layer
7. Update AGENTS.md if establishing new patterns

### Before Committing

- [ ] `bun run lint` passes (Biome + Astro check)
- [ ] `bun run test` passes (all tests green)
- [ ] TypeScript strict mode: no `any` types
- [ ] New services documented in code comments
- [ ] Updated AGENTS.md if new patterns established

## 🔗 Related Documentation

- **[README.md](README.md)**: Project overview, tech stack, getting started
- **[docs/agent_workflows.md](docs/agent_workflows.md)**: Detailed workflow diagrams (CPO → TL → Dev)
- **[.agents/rules/workflows.md](.agents/rules/workflows.md)**: State machines for all workflows

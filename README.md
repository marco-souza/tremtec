# TremTec

TremTec is a strategic engineering consulting and outsourcing platform that helps high-growth companies accelerate their development process and scale high-performance technical teams.

## 🎯 What is TremTec?

TremTec offers three core services:

1. **Implementation**: We implement best practices and tools to streamline your development process and accelerate delivery
2. **Diagnostics**: We analyze your current development process, tools, and team dynamics to identify bottlenecks
3. **Mentoring**: We provide ongoing mentorship and support to ensure your team continues to improve and adapt to changing needs

Our mission is to liberate engineering teams from the chaos of disorganized processes and technical debt, empowering them to build world-class products with confidence and speed.

## 🏗️ Project Structure

```
tremtec/
├── src/                    # Frontend & Backend Application
│   ├── domain/             # Business logic (DDD pattern)
│   │   ├── auth/           # Authentication domain
│   │   ├── user/           # User domain
│   │   └── shared/         # Shared types & services
│   ├── server/             # Hono backend routes & handlers
│   ├── pages/              # Astro pages (SSR)
│   ├── ui/                 # SolidJS components
│   ├── lib/                # Utilities, API clients
│   ├── middleware.ts       # Request middleware
│   └── config.ts           # Environment configuration
├── .agents/                # AI Agent Definitions
│   ├── skills/             # Agent capabilities (CPO, Tech Lead, Dev, etc.)
│   └── rules/              # Workflow definitions (new product, feature, bug)
├── infra/                  # Pulumi IaC (Cloudflare Workers deployment)
├── docs/                   # Project documentation
│   └── agent_workflows.md  # Detailed workflow diagrams
└── package.json            # Dependencies
```

## 🚀 Tech Stack

- **Frontend**: Astro + SolidJS + TailwindCSS + DaisyUI
- **Backend**: Hono + Zod + TypeScript
- **Infrastructure**: Pulumi + Cloudflare Workers
- **Testing**: Vitest + Solid Testing Library
- **Code Quality**: Biome (lint/format)
- **Auth**: GitHub OAuth, Google OAuth

## 🏃 Getting Started

### Prerequisites

- Bun (package manager)
- Node.js 18+
- Cloudflare account (for deployment)

### Installation

```bash
# Install dependencies
mise install
bun install

# Set up environment variables
cp .env.example .env

# you can also use mise decrypt/encrypt to manage .env
mise decrypt

# Start development server
bun run dev
```

### Available Commands

```bash
bun run dev        # Start Astro dev server (localhost:3000)
bun run build      # Build production assets
bun run lint       # Run Biome linter + Astro type check
bun run fix        # Auto-fix linting issues
bun run test       # Run Vitest unit tests
bun run test:ui    # Run Vitest with UI dashboard
bun w build        # Build Cloudflare Worker (wrangler)
bun w dev          # Test Worker locally
```

## 🤖 AI Agents & Workflows

### Core Workflows

1. **New Product** (Zero to One)
   - CPO generates PRD and MVP scope
   - Tech Lead designs architecture
   - Dev agents build frontend/backend in parallel
   - Infrastructure deployed to Cloudflare

2. **New Feature** (Iteration)
   - Requirement analysis
   - Architecture review
   - Implementation with code review
   - Automated deployment

3. **Bug Fix** (Maintenance)
   - Root cause analysis
   - Fix implementation
   - Regression testing
   - Hotfix deployment

See [docs/agent_workflows.md](docs/agent_workflows.md) for detailed sequence diagrams.

## 🏛️ Architecture Patterns

### Domain-Driven Design (DDD)

- `src/domain/` contains business logic
- Types defined with Zod for runtime validation
- Services encapsulate domain operations
- Tests co-located with domain modules

### Full-Stack TypeScript

- Type-safe end-to-end: database → API → frontend
- Zod schemas shared between server & client
- TypeScript strict mode enabled

### Authentication

- OAuth 2.0 with GitHub & Google providers
- Session-based auth with HTTP-only cookies
- Protected routes via middleware

## 🚀 Deployment

Infrastructure is managed via Pulumi IaC:

```bash
# Deploy to production (requires Cloudflare credentials)
cd infra
bun run pulumi up --stack prod
```

Features:

- Auto-deploys on git commits
- Custom domain support (tremtec.com)
- WWW → apex domain redirect
- Observability enabled (tracing, logging)

## 📝 Contributing

### Code Style

- Follow Biome formatting rules (`bun run fix`)
- Use TypeScript strict mode
- Write tests for domain logic
- Use kebab-case for files, PascalCase for components

### Adding Features

1. Start with domain layer (`src/domain/`)
2. Add server routes (`src/server/`)
3. Create UI components (`src/ui/`)
4. Add tests and run `bun run lint`
5. Push to GitHub (auto-deploys)

### Documentation

- Update AGENTS.md for architectural patterns
- Add inline comments for non-obvious logic
- Reference feature docs in commits

## 📚 Key Documentation

- [AGENTS.md](AGENTS.md) - Agent definitions & technical guidelines
- [docs/agent_workflows.md](docs/agent_workflows.md) - Workflow diagrams
- [.agents/rules/workflows.md](.agents/rules/workflows.md) - Workflow state machines

## 🔐 Environment Variables

Required for development:

- `GITHUB_ID` - GitHub OAuth app ID
- `GITHUB_SECRET` - GitHub OAuth secret
- `GOOGLE_ID` - Google OAuth client ID
- `GOOGLE_SECRET` - Google OAuth secret
- `BASE_URL` - Application URL (auto-set in infra)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

Built with AI Agents orchestrated by TremTec

---

**Questions?** Check the docs or open an issue on GitHub.

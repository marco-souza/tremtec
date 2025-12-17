# Technical Research: Umbrella Project Migration

## Executive Summary

Migrating the Tremtec project from a standalone Phoenix application to an umbrella project will allow managing multiple Phoenix applications and shared components (TremtecShared) in a single monorepo. This is a standard architectural decision in Elixir for projects with multiple related applications. Future projects will be generated using `mix phx.new` within the umbrella.

---

## 1. Technology Versions & Current State

### Elixir/Phoenix Versions

- **Elixir**: ~> 1.15 (current in project)
- **Phoenix**: ~> 1.8.1 (current in project)
- **Mix**: Supports umbrella projects natively since early versions
- **Status**: Umbrella projects are a stable and well-documented Mix feature

**Version Note**: The current project versions (Elixir 1.15, Phoenix 1.8.1) are adequate for migration. If there is a need to update to newer Elixir or Phoenix versions after migration, this will be handled in a separate specification (007-upgrade-versions.md or similar).

### Current Project Structure

- Standalone Phoenix application in `lib/`
- Assets in `assets/`
- Configuration in `config/`
- Tests in `test/`
- Priv in `priv/`
- Root Mix.exs with complete configuration
- **mise.toml** at root with tools and env configuration
- **.env** automatically loaded by mise via `[env]_.file = '.env'`

---

## 2. Technical Architecture

### Umbrella Project Structure

```text
tremtec/                    # Umbrella root
├── mix.exs                 # Umbrella configuration (apps_path: "apps")
├── apps/
│   ├── tremtec/           # Main app (migrated)
│   │   ├── mix.exs
│   │   ├── lib/
│   │   ├── test/
│   │   ├── priv/
│   │   └── assets/
│   └── tremtec_shared/    # Shared components
│       ├── mix.exs
│       └── lib/
├── config/                # Shared configurations (root)
└── deps/                  # Shared dependencies (root)
```

### Umbrella Project Characteristics

1. **Root Mix.exs**: Minimalist, umbrella configuration only
2. **Independent Apps**: Each app has its own `mix.exs` and structure
3. **Dependencies**: Can be shared (root) or specific (app)
4. **Configurations**: Can be at root (`config/`) or in each app
5. **Compilation**: `mix compile` compiles all apps

---

## 3. Project Requirements Analysis

### Configurations That Need to Be Updated

1. **Root mix.exs**:
   - Transform into umbrella configuration
   - Remove dependencies (will go to individual apps)
   - Keep aliases that delegate to specific apps

2. **apps/tremtec/mix.exs**:
   - Keep all current dependencies
   - Add dependency `{:tremtec_shared, in_umbrella: true}`
   - Keep asset and Ecto aliases

3. **config/config.exs**:
   - Update esbuild and tailwind paths to `apps/tremtec/assets`
   - Keep application configurations (tremtec)

4. **config/dev.exs and test.exs**:
   - Update database paths to `apps/tremtec/priv/`
   - Update live_reload patterns to `apps/tremtec/lib/`

5. **config/runtime.exs**:
   - Update database paths to umbrella structure

6. **Dockerfile**:
   - Update COPY paths to `apps/tremtec/`
   - Keep multi-stage structure

7. **Scripts and Aliases**:
   - Root aliases should delegate to specific apps
   - Commands like `mix phx.server` should be executed inside `apps/tremtec/`

---

## 4. Dependency Analysis

### Shared vs Specific Dependencies

**Shared (root)**:

- None initially (each app manages its own deps)

**apps/tremtec**:

- All current project dependencies
- `{:tremtec_shared, in_umbrella: true}`

**apps/tremtec_shared**:

- `{:phoenix, "~> 1.8.1}`
- `{:phoenix_html, "~> 4.1}`
- `{:phoenix_live_view, "~> 1.1.0}`
- `{:gettext, "~> 0.26}`

**Future projects**:

- Will be generated using `mix phx.new` within the umbrella when needed
- Will not be created now

---

## 5. Key Technical Constraints

### Paths

- **Assets**: Must point to `apps/tremtec/assets/`
- **Database**: Must point to `apps/tremtec/priv/repo/`
- **Static Files**: Must be in `apps/tremtec/priv/static/`
- **Gettext**: Must be in `apps/tremtec/priv/gettext/`

### Mix Commands

- Root commands: `mix compile`, `mix test` (compiles/tests all apps)
- Specific commands: `cd apps/tremtec && mix phx.server`
- Or use: `mix cmd --app tremtec mix phx.server` (if available)

### Aliases

- Root aliases can delegate to apps using `cmd`
- App aliases work normally within the app context

### .env Files and Environment Variables

**Current Situation**:

- The project uses `mise.toml` at root with configuration `[env]_.file = '.env'`
- Mise automatically loads the `.env` file from root when you enter the directory
- Phoenix uses `System.get_env()` to read environment variables from the system
- `.env` is in `.gitignore` (security standard)
- `docker-compose.yml` references `.env` and `.env.production`

**Strategy for Umbrella Project**:

1. **Keep .env at root**: The `.env` file remains at the umbrella project root
2. **Mise loads automatically**: The `mise.toml` at root with `[env]_.file = '.env'` will continue working
3. **All apps share**: Since mise loads `.env` into the system environment, all apps within the umbrella will have access to the same variables
4. **System.get_env() works normally**: Phoenix in `apps/tremtec/` will continue reading variables via `System.get_env()` without changes
5. **Docker**: `docker-compose.yml` will continue referencing `.env` at root (no changes needed)

**Advantages of this approach**:

- ✅ No changes required in Phoenix code (uses `System.get_env()`)
- ✅ Mise continues working as before
- ✅ Variables shared between apps (if needed in the future)
- ✅ Docker works without changes
- ✅ Maintains security standard (.env in .gitignore)

**Considerations**:

- If future apps need specific variables, they can use prefixes (e.g., `TREMTEC_DB_PATH`, `OTHER_APP_DB_PATH`)
- `config/runtime.exs` will continue working normally, reading from the system environment

### Mise Configuration

**Current Situation**:

```toml
[tasks]
fmt = "deno run -A npm:prettier --write **/*.md"
dotenv = "op item get $(op item list | grep .tremtec.env | awk '{ print $1 }') --fields 'notesPlain' --reveal | sed 's/\"//g' > .env"
precommit = "mix precommit"

[env]
_.file = '.env'
ENV = "production"

[tools]
deno = "latest"
elixir = "latest"
erlang = "latest"
```

**Strategy for Umbrella Project**:

1. **Keep mise.toml at root**: The `mise.toml` remains at the umbrella project root
2. **Shared tools**: Elixir and Erlang configured at root work for all apps
3. **Tasks work normally**: Tasks like `mise run precommit` continue working
4. **No changes needed**: Mise works perfectly with umbrella projects without additional configuration

**Advantages**:

- ✅ Single tool configuration for the entire project
- ✅ Tasks can be executed at root or within specific apps
- ✅ Consistent environment between apps
- ✅ No additional configuration needed

---

## 6. Fly.io Deployment Strategy

### The Challenge

When deploying multiple Phoenix apps from an umbrella project to Fly.io:

- Each app needs its own Fly.io application (separate domain, secrets, resources)
- Docker build context is limited to the directory where `fly deploy` runs
- Umbrella projects require access to root `config/`, `deps/`, and sibling apps

### Solution: Shared Dockerfile with Build Args

**Structure:**

```text
tremtec/                       # Umbrella root
├── mix.exs
├── config/
├── Dockerfile                 # Shared Dockerfile at root (accepts APP_NAME arg)
├── Dockerfile.dev             # Development Dockerfile at root
├── apps/
│   ├── tremtec/
│   │   ├── fly.toml          # Fly.io config pointing to ../../Dockerfile
│   │   ├── mix.exs
│   │   └── ...
│   ├── tremtec_shared/        # No fly.toml (shared lib, not deployed)
│   │   └── ...
│   └── future_app/            # Future Phoenix app
│       ├── fly.toml          # Its own Fly.io config
│       └── ...
```

### fly.toml Configuration (per app)

Each deployable app gets its own `fly.toml` inside its directory:

**`apps/tremtec/fly.toml`:**

```toml
app = 'tremtec'
primary_region = 'gru'

[build]
  dockerfile = "../../Dockerfile"
  [build.args]
    APP_NAME = "tremtec"

[env]
  PHX_HOST = "tremtec.com"
  PORT = "8080"
  PHX_SERVER = "true"
  DATABASE_PATH = "/data/tremtec.db"

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1

[[vm]]
  memory = '512mb'
  cpu_kind = 'shared'
  cpus = 1

[mounts]
  source = "data"
  destination = "/data"
```

### Dockerfile Configuration (at root)

The root Dockerfile accepts `APP_NAME` as a build argument:

```dockerfile
# Production Dockerfile for TremTec Umbrella
ARG ELIXIR_VERSION=1.18.4
ARG OTP_VERSION=28.0.1
ARG DEBIAN_VERSION=trixie-20250428-slim

# Build stage
FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION} AS builder

ARG APP_NAME=tremtec
ENV APP_NAME=${APP_NAME}
ENV MIX_ENV=prod

WORKDIR /app

# Copy umbrella structure
COPY mix.exs mix.lock ./
COPY config ./config
COPY apps ./apps

# Install dependencies and compile
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix deps.compile

# Build assets for the specific app (if it has assets)
RUN if [ -d "apps/${APP_NAME}/assets" ]; then \
      mix assets.deploy; \
    fi

# Create release for specific app
RUN mix release ${APP_NAME}

# Runtime stage
FROM debian:${DEBIAN_VERSION}

ARG APP_NAME=tremtec
ENV APP_NAME=${APP_NAME}

# ... runtime setup ...

COPY --from=builder /app/_build/prod/rel/${APP_NAME} /app

CMD ["/app/bin/${APP_NAME}", "start"]
```

### Deployment Workflow

**Deploy a specific app:**

```bash
cd apps/tremtec
fly deploy
```

**What happens:**

1. Fly.io reads `apps/tremtec/fly.toml`
2. Sees `dockerfile = "../../Dockerfile"` → uses root Dockerfile
3. Passes `APP_NAME = "tremtec"` as build arg
4. Dockerfile builds the entire umbrella but releases only `tremtec`
5. Image is deployed to Fly.io as app `tremtec`

### Secrets Management

Each app has its own secrets in Fly.io:

```bash
# For tremtec app
cd apps/tremtec
fly secrets set SECRET_KEY_BASE='...'
fly secrets set RESEND_API_KEY='...'

# For future_app (different secrets)
cd apps/future_app
fly secrets set SECRET_KEY_BASE='...'  # Different key
fly secrets set SOME_OTHER_SECRET='...'
```

### Shared Libraries (tremtec_shared)

- **No fly.toml needed**: `tremtec_shared` is a dependency, not a deployable app
- **Included in builds**: When `tremtec` is built, `tremtec_shared` is compiled as a dependency
- **No separate deployment**: It exists only as compiled code inside other apps

### Multiple Apps Example

If you add `apps/api/` later:

**`apps/api/fly.toml`:**

```toml
app = 'tremtec-api'
primary_region = 'gru'

[build]
  dockerfile = "../../Dockerfile"
  [build.args]
    APP_NAME = "api"

[env]
  PHX_HOST = "api.tremtec.com"
  PORT = "8080"
  # ... different env vars ...
```

**Deploy:**

```bash
cd apps/api
fly deploy
```

### Advantages

- ✅ **Single Dockerfile**: No duplication, easier maintenance
- ✅ **Independent deploys**: Each app deployed separately
- ✅ **Separate secrets**: Each app has its own Fly.io secrets
- ✅ **Separate resources**: Different memory/CPU per app
- ✅ **Separate domains**: Each app gets its own domain
- ✅ **Shared code**: `tremtec_shared` compiled into each app

### CI/CD Considerations

Update GitHub Actions to deploy specific apps:

```yaml
# .github/workflows/deploy-tremtec.yml
name: Deploy Tremtec
on:
  push:
    branches: [main]
    paths:
      - "apps/tremtec/**"
      - "apps/tremtec_shared/**"
      - "config/**"
      - "Dockerfile"

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: cd apps/tremtec && flyctl deploy --remote-only
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
```

---

## 7. Implementation Options

### Option A: Complete Migration (Recommended)

**Structure**:

- Root as pure umbrella
- Tremtec as complete app
- TremtecShared as shared lib
- Future projects will be generated with `mix phx.new` when needed

**Pros**:

- Clean and scalable structure
- Each app is independent
- Easy to add new apps
- Follows Elixir standards

**Cons**:

- Requires updating all paths
- Specific commands need to be executed inside apps

### Option B: Hybrid (Not Recommended)

Keep current structure and only create new apps.

**Pros**:

- Fewer changes

**Cons**:

- Inconsistent structure
- Makes future maintenance difficult
- Doesn't leverage umbrella benefits

---

## 8. Implementation Tasks

### Phase 1: Setup (AGENT)

- [ ] Create spec (006-umbrella-project.md) ✅
- [ ] Create research (this file) ✅
- [ ] Create detailed plan
- [ ] Revert partial changes already made (if necessary)

### Phase 2: Base Structure (AGENT)

- [ ] Transform root mix.exs into umbrella
- [ ] Create apps/tremtec/mix.exs with dependencies
- [ ] Move lib/ to apps/tremtec/lib/
- [ ] Move test/ to apps/tremtec/test/
- [ ] Move priv/ to apps/tremtec/priv/
- [ ] Move assets/ to apps/tremtec/assets/

### Phase 3: Shared Apps (AGENT)

- [ ] Create apps/tremtec_shared/ with basic structure

### Phase 4: Configurations (AGENT)

- [ ] Update config/config.exs (asset paths)
- [ ] Update config/dev.exs (database, live_reload)
- [ ] Update config/test.exs (database)
- [ ] Update config/runtime.exs (database)
- [ ] Update config/prod.exs (if exists)

### Phase 5: Docker and Fly.io (AGENT)

- [ ] Update Dockerfile to accept APP_NAME build arg
- [ ] Update Dockerfile.dev for umbrella structure
- [ ] Move fly.toml to apps/tremtec/fly.toml
- [ ] Update fly.toml to reference ../../Dockerfile with build args
- [ ] Update docker-compose.yml (verify .env references)
- [ ] Update scripts/docker_entrypoint.sh
- [ ] Verify that .env continues to be loaded correctly
- [ ] Update GitHub Actions deploy workflow for umbrella structure

### Phase 6: Aliases and Commands (AGENT)

- [ ] Update aliases in root mix.exs
- [ ] Verify command functionality
- [ ] Update documentation (README.md)

### Phase 7: Tests and Validation (AGENT)

- [ ] Run `mix compile`
- [ ] Run `mix test`
- [ ] Run `mix phx.server` (inside apps/tremtec)
- [ ] Verify assets compiling
- [ ] Verify database working

---

## 9. References

- [Mix Umbrella Projects](https://hexdocs.pm/mix/Mix.Tasks.New.html#module-umbrella-projects)
- [Phoenix Umbrella Guide](https://hexdocs.pm/phoenix/up_and_running.html#umbrella-projects)
- [Elixir School - Umbrella Projects](https://elixirschool.com/en/lessons/advanced/umbrella-projects/)
- [Fly.io Phoenix Deployment](https://hexdocs.pm/phoenix/fly.html)
- [Fly.io Multiple Applications](https://fly.io/docs/rails/advanced-guides/multiple-applications/)
- [Fly.io Community - Phoenix Umbrella Deploy](https://community.fly.io/t/how-to-deploy-a-phoenix-umbrella-project/4498)

---

## Summary of Recommendations

1. **Complete Migration**: Fully transform into umbrella project
2. **Clean Structure**: Each app independent with its own dependencies
3. **Centralized Configurations**: Keep config/ at root for shared configurations
4. **TremtecShared**: Create as shared lib for reusable components
5. **Future Projects**: Will be generated using `mix phx.new` within the umbrella when needed
6. **Documentation**: Update README.md with instructions for working with umbrella
7. **Commands**: Document that specific commands must be executed inside apps/tremtec/
8. **.env Files**: Keep at root, automatically loaded by mise, shared between apps
9. **Mise**: Keep mise.toml at root, works without changes for all apps
10. **Versions**: Current versions (Elixir 1.15, Phoenix 1.8.1) are adequate; future updates in separate spec
11. **Fly.io Deployment**: Each deployable app gets its own `fly.toml` inside its directory, pointing to shared Dockerfile at root with `APP_NAME` build arg
12. **Dockerfile Strategy**: Single Dockerfile at root accepting `APP_NAME` arg to build specific app releases
13. **Deploy Command**: Run `fly deploy` from inside each app directory (e.g., `cd apps/tremtec && fly deploy`)
14. **CI/CD**: Update GitHub Actions to deploy specific apps based on changed paths

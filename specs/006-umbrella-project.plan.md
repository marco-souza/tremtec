# Implementation Plan: Umbrella Project Migration

**Feature**: Umbrella Project Structure

**Spec Reference**: `specs/006-umbrella-project.md`

**Research Reference**: `specs/006-umbrella-project.research.md`

**Status**: [ ] Draft | [ ] Ready for Review | [ ] Approved | [ ] In Progress | [x] Complete

## Overview

Migrate the Tremtec project from a standalone Phoenix application to an umbrella project, allowing management of multiple applications (Tremtec, Faz, ShareThing) and shared components (TremtecShared) in a single monorepo. The migration will preserve all existing functionality while establishing a scalable structure for future projects.

**Migration Strategy**: Complete structural migration - all code will be moved to `apps/tremtec/`, configurations updated, and umbrella structure established at root level.

## Technical Research & Discovery

### Research Conducted

- [x] Reviewed official Mix documentation on umbrella projects
- [x] Examined current Tremtec project structure
- [x] Researched configuration patterns for assets and database in umbrella
- [x] Identified need to update all relative paths
- [x] Analyzed Dockerfile and Dockerfile.dev structure
- [x] Reviewed mise.toml and .env handling strategy

### Key Findings

- Umbrella projects are a native and stable Mix feature
- Each app needs its own mix.exs with dependencies
- Configurations can be at root or in each app
- Assets and priv must be inside each app
- Specific commands must be executed inside apps/tremtec/
- `.env` and `mise.toml` remain at root (no changes needed)
- Dockerfiles need path updates but structure remains similar

### Open Questions

None - structure is clear.

## Prerequisites & Dependencies

### What Must Be Done First

1. Ensure all current work is committed or stashed
2. Verify current project compiles and tests pass: `mix compile && mix test`
3. Backup current state (git commit recommended)

### Blocking Dependencies

- None - this is a structural migration that can start immediately

## Dependencies

### New Dependencies to Add

No new external dependencies. Only internal dependencies between apps:

- `{:tremtec_shared, in_umbrella: true}` in `apps/tremtec/mix.exs`

### Existing Dependencies Used

All current dependencies will be moved to `apps/tremtec/mix.exs` without changes:

- All Phoenix, Ecto, and other dependencies remain the same
- Dependencies move from root `mix.exs` to `apps/tremtec/mix.exs`

## File Changes

### New Files to Create

- [ ] `apps/tremtec/mix.exs` - Tremtec app configuration (copied from root)
- [ ] `apps/tremtec_shared/mix.exs` - Shared lib configuration
- [ ] `apps/tremtec_shared/lib/tremtec_shared.ex` - Main shared module
- [ ] `apps/tremtec_shared/lib/.gitkeep` - Ensure lib directory exists

### Existing Files to Modify

- [ ] `mix.exs` (root) - Transform into umbrella configuration
- [ ] `config/config.exs` - Update esbuild and tailwind paths
- [ ] `config/dev.exs` - Update database and live_reload paths
- [ ] `config/test.exs` - Update database paths
- [ ] `config/runtime.exs` - Update database paths (if needed)
- [ ] `config/prod.exs` - Verify no changes needed (paths are relative)
- [ ] `Dockerfile` - Update COPY paths and working directory
- [ ] `Dockerfile.dev` - Update COPY paths and working directory
- [ ] `docker-compose.yml` - Verify .env references (should work as-is)
- [ ] `scripts/docker_entrypoint.sh` - Verify paths (should work as-is)
- [ ] `README.md` - Update instructions for umbrella structure

### Files/Directories to Move

- [ ] `lib/` → `apps/tremtec/lib/`
- [ ] `test/` → `apps/tremtec/test/`
- [ ] `priv/` → `apps/tremtec/priv/`
- [ ] `assets/` → `apps/tremtec/assets/`

### Files to Delete

None - all files are moved, not deleted.

## Database Changes

No schema changes. Only path updates in configuration files:

- Database files remain in `apps/tremtec/priv/repo/` (moved with priv/)
- Migration files remain in `apps/tremtec/priv/repo/migrations/`
- Database paths in config files updated to point to new location

## Configuration Changes

### Runtime Config (`config/runtime.exs`)

- [ ] Verify database path references (may need updates if using absolute paths)
- [ ] Ensure all `System.get_env()` calls work (should work as-is)

### Application Config (`config/config.exs`)

- [ ] Update `config :esbuild` - `cd` path to `apps/tremtec/assets`
- [ ] Update `config :tailwind` - input/output paths to `apps/tremtec/`
- [ ] Verify all other configs remain unchanged

### Dev Config (`config/dev.exs`)

- [ ] Update `config :tremtec, Tremtec.Repo` - database path to `apps/tremtec/`
- [ ] Update `live_reload` patterns to `apps/tremtec/lib/`
- [ ] Update watchers paths if needed

### Test Config (`config/test.exs`)

- [ ] Update `config :tremtec, Tremtec.Repo` - database path to `apps/tremtec/`

### Prod Config (`config/prod.exs`)

- [ ] Verify no changes needed (uses relative paths)

## Implementation Steps

### [TASK 1] Prepare Directory Structure

**Owner**: AGENT  
**Duration**: 5 minutes  
**Depends On**: None  
**Blocks**: TASK 2  
**Status**: `todo`

#### Steps

1. Check if `apps/` directory already exists:

   ```bash
   ls -la apps/ 2>/dev/null || echo "apps/ does not exist"
   ```

2. Create directory structure:

   ```bash
   mkdir -p apps/tremtec apps/tremtec_shared
   ```

3. Verify directories were created:

   ```bash
   ls -la apps/
   ```

#### Verification

- [ ] Directory `apps/tremtec` exists
- [ ] Directory `apps/tremtec_shared` exists
- [ ] Both directories are empty (ready for content)

---

### [TASK 2] Transform Root mix.exs into Umbrella

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 1  
**Blocks**: TASK 3  
**Status**: `todo`

#### Steps

1. Read current `mix.exs` to understand structure
2. Backup current `mix.exs` (git handles this, but good practice)
3. Create new root `mix.exs` with umbrella configuration:

   ```elixir
   defmodule Tremtec.Umbrella.MixProject do
     use Mix.Project

     def project do
       [
         apps_path: "apps",
         version: "0.1.0",
         start_permanent: Mix.env() == :prod,
         deps: deps(),
         aliases: aliases(),
         preferred_cli_env: [precommit: :test]
       ]
     end

     defp deps do
       []
     end

     defp aliases do
       [
         setup: ["cmd cd apps/tremtec && mix setup"],
         "ecto.setup": ["cmd cd apps/tremtec && mix ecto.setup"],
         "ecto.reset": ["cmd cd apps/tremtec && mix ecto.reset"],
         test: ["cmd cd apps/tremtec && mix test"],
         "assets.setup": ["cmd cd apps/tremtec && mix assets.setup"],
         "assets.build": ["cmd cd apps/tremtec && mix assets.build"],
         "assets.deploy": ["cmd cd apps/tremtec && mix assets.deploy"],
         precommit: [
           "compile --warning-as-errors",
           "cmd cd apps/tremtec && mix precommit"
         ]
       ]
     end
   end
   ```

4. Verify umbrella structure:

   ```bash
   mix compile
   ```

   Should compile successfully (may be empty, but should not error)

#### Verification

- [ ] Root `mix.exs` has `apps_path: "apps"`
- [ ] Root `mix.exs` has no `app:` key (umbrella projects don't have app)
- [ ] Root `mix.exs` has empty `deps: []`
- [ ] Root `mix.exs` has aliases that delegate to `apps/tremtec`
- [ ] `mix compile` at root works without errors

---

### [TASK 3] Create apps/tremtec/mix.exs

**Owner**: AGENT  
**Duration**: 20 minutes  
**Depends On**: TASK 2  
**Blocks**: TASK 4  
**Status**: `todo`

#### Steps

1. Read current root `mix.exs` (before it was changed) to get all dependencies
2. Copy entire content to `apps/tremtec/mix.exs`
3. Update module name:

   ```elixir
   defmodule Tremtec.MixProject do
     # Keep same module name - it's fine
   ```

4. Add `tremtec_shared` dependency to deps list:

   ```elixir
   defp deps do
     [
       {:tremtec_shared, in_umbrella: true},
       # ... all other existing dependencies
     ]
   end
   ```

5. Ensure `elixirc_paths` remain correct (they reference `lib` and `test/support` which will be moved)
6. Keep all aliases, compilers, and listeners as-is

#### Verification

- [ ] `apps/tremtec/mix.exs` exists
- [ ] `apps/tremtec/mix.exs` has all original dependencies
- [ ] `{:tremtec_shared, in_umbrella: true}` is first in deps list
- [ ] Module name is `Tremtec.MixProject`
- [ ] All original configurations are preserved

---

### [TASK 4] Move Directories to apps/tremtec/

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: TASK 3  
**Blocks**: TASK 5  
**Status**: `todo`

#### Steps

1. Move `lib/` directory:

   ```bash
   mv lib apps/tremtec/lib
   ```

2. Move `test/` directory:

   ```bash
   mv test apps/tremtec/test
   ```

3. Move `priv/` directory:

   ```bash
   mv priv apps/tremtec/priv
   ```

4. Move `assets/` directory:

   ```bash
   mv assets apps/tremtec/assets
   ```

5. Verify all directories moved correctly:

   ```bash
   ls -la apps/tremtec/
   ```

6. Verify root directories are gone (or empty):

   ```bash
   ls -d lib test priv assets 2>/dev/null || echo "Directories moved successfully"
   ```

#### Verification

- [ ] `apps/tremtec/lib/` exists and contains all modules
- [ ] `apps/tremtec/test/` exists and contains all tests
- [ ] `apps/tremtec/priv/` exists and contains `repo/` and `gettext/`
- [ ] `apps/tremtec/assets/` exists and contains `css/` and `js/`
- [ ] Root `lib/`, `test/`, `priv/`, `assets/` no longer exist
- [ ] All files were moved (not copied)

---

### [TASK 5] Create apps/tremtec_shared/ Structure

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 4  
**Blocks**: TASK 6  
**Status**: `todo`

#### Steps

1. Create `apps/tremtec_shared/lib/` directory:

   ```bash
   mkdir -p apps/tremtec_shared/lib
   ```

2. Create `apps/tremtec_shared/mix.exs`:

   ```elixir
   defmodule TremtecShared.MixProject do
     use Mix.Project

     def project do
       [
         app: :tremtec_shared,
         version: "0.1.0",
         elixir: "~> 1.15",
         start_permanent: Mix.env() == :prod,
         deps: deps()
       ]
     end

     def application do
       [
         extra_applications: [:logger]
       ]
     end

     defp deps do
       [
         {:phoenix, "~> 1.8.1"},
         {:phoenix_html, "~> 4.1"},
         {:phoenix_live_view, "~> 1.1.0"},
         {:gettext, "~> 0.26"}
       ]
     end
   end
   ```

3. Create `apps/tremtec_shared/lib/tremtec_shared.ex`:

   ```elixir
   defmodule TremtecShared do
     @moduledoc """
     TremtecShared provides shared components and utilities
     for all Tremtec umbrella applications.

     This module serves as the entry point for shared functionality
     that can be used across Tremtec, Faz, ShareThing, and other
     future applications in the umbrella.
     """
   end
   ```

4. Verify compilation:

   ```bash
   cd apps/tremtec_shared && mix compile
   ```

#### Verification

- [ ] `apps/tremtec_shared/mix.exs` exists
- [ ] `apps/tremtec_shared/lib/tremtec_shared.ex` exists
- [ ] `mix compile` in `apps/tremtec_shared` works without errors
- [ ] Dependencies are correctly specified

---

### [TASK 6] Update config/config.exs

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 5  
**Blocks**: TASK 7  
**Status**: `todo`

#### Steps

1. Read current `config/config.exs`
2. Update `config :esbuild` section:

   ```elixir
   config :esbuild,
     version: "0.25.4",
     tremtec: [
       args:
         ~w(js/app.js --bundle --target=es2022 --outdir=../priv/static/assets/js --external:/fonts/* --external:/images/* --alias:@=.).,
       cd: Path.expand("../apps/tremtec/assets", __DIR__),
       env: %{"NODE_PATH" => [Path.expand("../deps", __DIR__), Mix.Project.build_path()]}
     ]
   ```

3. Update `config :tailwind` section:

   ```elixir
   config :tailwind,
     version: "4.1.7",
     tremtec: [
       args: ~w(
         --input=apps/tremtec/assets/css/app.css
         --output=apps/tremtec/priv/static/assets/css/app.css
       ),
       cd: Path.expand("..", __DIR__)
     ]
   ```

4. Verify all other configs remain unchanged (they should)

#### Verification

- [ ] esbuild `cd` path points to `apps/tremtec/assets`
- [ ] tailwind `--input` path is `apps/tremtec/assets/css/app.css`
- [ ] tailwind `--output` path is `apps/tremtec/priv/static/assets/css/app.css`
- [ ] tailwind `cd` is root directory (`Path.expand("..", __DIR__)`)
- [ ] All other configs unchanged

---

### [TASK 7] Update config/dev.exs

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 6  
**Blocks**: TASK 8  
**Status**: `todo`

#### Steps

1. Read current `config/dev.exs`
2. Update database path in `config :tremtec, Tremtec.Repo`:

   ```elixir
   config :tremtec, Tremtec.Repo,
     database: Path.expand("../apps/tremtec/tremtec_dev.db", __DIR__),
     pool_size: 5,
     stacktrace: true,
     show_sensitive_data_on_connection_error: true
   ```

3. Update `live_reload` patterns:

   ```elixir
   config :tremtec, TremtecWeb.Endpoint,
     live_reload: [
       web_console_logger: true,
       patterns: [
         ~r"apps/tremtec/priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
         ~r"apps/tremtec/priv/gettext/.*(po)$",
         ~r"apps/tremtec/lib/tremtec_web/(?:controllers|live|components|router)/?.*\.(ex|heex)$"
       ]
     ]
   ```

4. Verify watchers paths (if they reference assets):

   ```elixir
   watchers: [
     esbuild: {Esbuild, :install_and_run, [:tremtec, ~w(--sourcemap=inline --watch)]},
     tailwind: {Tailwind, :install_and_run, [:tremtec, ~w(--watch)]}
   ]
   ```

   (These should work as-is since they reference the config key `:tremtec`)

#### Verification

- [ ] Database path points to `apps/tremtec/tremtec_dev.db`
- [ ] Live reload patterns include `apps/tremtec/` paths
- [ ] All three pattern types updated (static, gettext, lib)
- [ ] Watchers remain unchanged (they use config keys)

---

### [TASK 8] Update config/test.exs

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: TASK 7  
**Blocks**: TASK 9  
**Status**: `todo`

#### Steps

1. Read current `config/test.exs`
2. Update database path in `config :tremtec, Tremtec.Repo`:

   ```elixir
   config :tremtec, Tremtec.Repo,
     database: Path.expand("../apps/tremtec/tremtec_test.db", __DIR__),
     pool_size: 1,
     # ... other test configs remain unchanged
   ```

3. Verify `elixirc_paths` if specified (should reference `test/support` which is now in `apps/tremtec/test/support`)

#### Verification

- [ ] Test database path points to `apps/tremtec/tremtec_test.db`
- [ ] All other test configs remain unchanged
- [ ] Path uses `Path.expand` for correct resolution

---

### [TASK 9] Update config/runtime.exs

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: TASK 8  
**Blocks**: TASK 10  
**Status**: `todo`

#### Steps

1. Read current `config/runtime.exs`
2. Check if database path is referenced (it uses `System.get_env("DATABASE_PATH")` so should be fine)
3. Verify no hardcoded paths need updating
4. Check if any paths reference `priv/` directly (should use environment variables)

**Note**: `runtime.exs` uses `System.get_env()` for database paths, so it should work as-is. However, verify that the default paths or any fallbacks are correct.

#### Verification

- [ ] All database paths use `System.get_env()` (no hardcoded paths)
- [ ] No paths need updating (runtime.exs is environment-based)
- [ ] Environment variable handling remains correct

---

### [TASK 10] Update Dockerfile

**Owner**: AGENT  
**Duration**: 20 minutes  
**Depends On**: TASK 9  
**Blocks**: TASK 11  
**Status**: `todo`

#### Steps

1. Read current `Dockerfile`
2. Update COPY commands in build stage:

   ```dockerfile
   # Copy mix files and config
   COPY apps/tremtec/mix.exs apps/tremtec/mix.lock ./
   COPY config ./config

   # Install dependencies (prod only - no dev/test)
   RUN mix deps.get --only prod && \
       mix deps.compile

   # Copy application source
   COPY apps/tremtec/lib ./lib
   COPY apps/tremtec/assets ./assets
   COPY apps/tremtec/priv ./priv
   ```

3. Update WORKDIR context - ensure we're in the right place for mix commands
4. Verify release path remains `_build/prod/rel/tremtec` (should be unchanged)
5. Verify entrypoint script path (should remain `scripts/docker_entrypoint.sh`)

**Important**: Mix commands run from `/app` in Docker, so paths need to account for this. The COPY commands copy files to the working directory, so structure should match what mix expects.

#### Verification

- [ ] Dockerfile copies `apps/tremtec/mix.exs` and `mix.lock`
- [ ] Dockerfile copies `apps/tremtec/lib` to `./lib`
- [ ] Dockerfile copies `apps/tremtec/assets` to `./assets`
- [ ] Dockerfile copies `apps/tremtec/priv` to `./priv`
- [ ] Release path is correct: `_build/prod/rel/tremtec`
- [ ] Entrypoint script path is correct

---

### [TASK 11] Update Dockerfile.dev

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 10  
**Blocks**: TASK 12  
**Status**: `todo`

#### Steps

1. Read current `Dockerfile.dev`
2. Update COPY commands:

   ```dockerfile
   # Copy mix files
   COPY apps/tremtec/mix.exs apps/tremtec/mix.lock ./
   COPY config ./config

   # Install dependencies (including dev and test)
   RUN mix deps.get

   # Copy entire application for development
   COPY apps/tremtec/lib ./lib
   COPY apps/tremtec/test ./test
   COPY apps/tremtec/priv ./priv
   COPY apps/tremtec/assets ./assets
   ```

3. Verify CMD remains `["mix", "phx.server"]` (should work as-is)
4. Verify DATABASE_PATH environment variable (should work as-is)

#### Verification

- [ ] Dockerfile.dev copies files from `apps/tremtec/`
- [ ] All directories copied (lib, test, priv, assets)
- [ ] CMD remains `["mix", "phx.server"]`
- [ ] Environment variables remain correct

---

### [TASK 12] Verify Docker Compose and Scripts

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: TASK 11  
**Blocks**: TASK 13  
**Status**: `todo`

#### Steps

1. Read `docker-compose.yml`
2. Verify `.env` references (should work as-is since `.env` stays at root)
3. Verify volume mounts (should work as-is)
4. Read `scripts/docker_entrypoint.sh`
5. Verify script paths (should work as-is since release structure doesn't change)

**Note**: These files should require minimal or no changes since:

- `.env` remains at root
- Docker volumes mount root directory
- Entrypoint script uses release paths which don't change

#### Verification

- [ ] `docker-compose.yml` `.env` references work (file at root)
- [ ] Volume mounts are correct
- [ ] `scripts/docker_entrypoint.sh` paths are correct
- [ ] No changes needed (or minimal changes documented)

---

### [TASK 13] Update Aliases in Root mix.exs (Finalize)

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: TASK 12  
**Blocks**: TASK 14  
**Status**: `todo`

#### Steps

1. Review root `mix.exs` aliases created in TASK 2
2. Verify all aliases delegate correctly to `apps/tremtec/`
3. Test that aliases work:

   ```bash
   mix setup --help  # Should show it delegates
   ```

4. Ensure `precommit` alias includes root compilation:

   ```elixir
   precommit: [
     "compile --warning-as-errors",  # Compiles all apps in umbrella
     "cmd cd apps/tremtec && mix precommit"  # Runs precommit in tremtec app
   ]
   ```

#### Verification

- [ ] All aliases delegate to `apps/tremtec/`
- [ ] `mix setup` works at root
- [ ] `mix test` works at root
- [ ] `mix precommit` compiles umbrella and runs precommit in app

---

### [TASK 14] Initial Compilation and Dependency Check

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 13  
**Blocks**: TASK 15  
**Status**: `todo`

#### Steps

1. Get dependencies at root:

   ```bash
   mix deps.get
   ```

2. Get dependencies in apps:

   ```bash
   cd apps/tremtec && mix deps.get
   cd ../tremtec_shared && mix deps.get
   ```

3. Compile at root:

   ```bash
   mix compile
   ```

4. Compile in apps:

   ```bash
   cd apps/tremtec && mix compile
   cd ../tremtec_shared && mix compile
   ```

5. Verify no compilation errors

#### Verification

- [ ] `mix deps.get` works at root
- [ ] `mix deps.get` works in `apps/tremtec`
- [ ] `mix deps.get` works in `apps/tremtec_shared`
- [ ] `mix compile` works at root (compiles all apps)
- [ ] `mix compile` works in `apps/tremtec`
- [ ] `mix compile` works in `apps/tremtec_shared`
- [ ] No compilation errors

---

### [TASK 15] Update Assets Configuration and Test Build

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 14  
**Blocks**: TASK 16  
**Status**: `todo`

#### Steps

1. Setup assets:

   ```bash
   cd apps/tremtec && mix assets.setup
   ```

2. Build assets:

   ```bash
   cd apps/tremtec && mix assets.build
   ```

3. Verify assets compiled correctly:

   ```bash
   ls -la apps/tremtec/priv/static/assets/
   ```

4. Check for any path errors in build output

#### Verification

- [ ] `mix assets.setup` works in `apps/tremtec`
- [ ] `mix assets.build` works in `apps/tremtec`
- [ ] Assets compiled to `apps/tremtec/priv/static/assets/`
- [ ] CSS and JS files exist in output directory
- [ ] No path-related errors in build

---

### [TASK 16] Database Migration and Test

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 15  
**Blocks**: TASK 17  
**Status**: `todo`

#### Steps

1. Setup database:

   ```bash
   cd apps/tremtec && mix ecto.setup
   ```

2. Verify database created in correct location:

   ```bash
   ls -la apps/tremtec/tremtec_dev.db
   ```

3. Run migrations:

   ```bash
   cd apps/tremtec && mix ecto.migrate
   ```

4. Verify migrations ran successfully

#### Verification

- [ ] `mix ecto.setup` works in `apps/tremtec`
- [ ] Database file created at `apps/tremtec/tremtec_dev.db`
- [ ] Migrations run successfully
- [ ] No path-related errors

---

### [TASK 17] Run Test Suite

**Owner**: AGENT  
**Duration**: 20 minutes  
**Depends On**: TASK 16  
**Blocks**: TASK 18  
**Status**: `todo`

#### Steps

1. Run tests:

   ```bash
   cd apps/tremtec && mix test
   ```

2. Verify all tests pass
3. Check for any path-related test failures
4. Fix any issues found

#### Verification

- [ ] `mix test` runs in `apps/tremtec`
- [ ] All existing tests pass
- [ ] No new test failures introduced
- [ ] Test database created correctly

---

### [TASK 18] Start Phoenix Server and Verify

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 17  
**Blocks**: TASK 19  
**Status**: `todo`

#### Steps

1. Start server:

   ```bash
   cd apps/tremtec && mix phx.server
   ```

2. Verify server starts without errors
3. Check that application loads at `http://localhost:4000`
4. Verify assets are served correctly (check browser console)
5. Test a few routes to ensure everything works
6. Stop server (Ctrl+C)

#### Verification

- [ ] Server starts without errors
- [ ] Application loads at `http://localhost:4000`
- [ ] Assets (CSS/JS) load correctly
- [ ] Routes work correctly
- [ ] No console errors in browser
- [ ] LiveView works (if applicable)

---

### [TASK 19] Update Documentation

**Owner**: AGENT  
**Duration**: 20 minutes  
**Depends On**: TASK 18  
**Blocks**: TASK 20  
**Status**: `todo`

#### Steps

1. Read current `README.md`
2. Add section about umbrella structure:

   ````markdown
   ## Project Structure

   This is an umbrella project containing multiple Phoenix applications:

   - `apps/tremtec/` - Main Tremtec application
   - `apps/tremtec_shared/` - Shared components and utilities

   ### Working with the Umbrella

   Most development commands should be run inside `apps/tremtec/`:

   ```bash
   cd apps/tremtec
   mix phx.server
   mix test
   mix ecto.migrate
   ```
   ````

   Root-level commands:

   ```bash
   mix compile  # Compiles all apps
   mix setup    # Delegates to apps/tremtec
   mix test     # Delegates to apps/tremtec
   ```

3. Update setup instructions
4. Update development instructions
5. Format with Prettier:

   ```bash
   npx prettier --write README.md
   ```

#### Verification

- [ ] README.md includes umbrella structure section
- [ ] Instructions for working with umbrella are clear
- [ ] Setup instructions updated
- [ ] Development instructions updated
- [ ] README.md formatted with Prettier

---

### [TASK 20] Final Verification and Cleanup

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: TASK 19  
**Blocks**: None  
**Status**: `todo`

#### Steps

1. Run precommit check:

   ```bash
   mix precommit
   ```

2. Verify everything compiles:

   ```bash
   mix compile --warning-as-errors
   ```

3. Verify all tests pass:

   ```bash
   cd apps/tremtec && mix test
   ```

4. Check git status for any unexpected files:

   ```bash
   git status
   ```

5. Verify no temporary files or backups left behind

#### Verification

- [ ] `mix precommit` passes
- [ ] `mix compile --warning-as-errors` passes
- [ ] All tests pass
- [ ] Git status shows expected changes only
- [ ] No temporary files or backups
- [ ] Project structure is clean

---

## Testing Strategy

### Unit Tests

- [ ] All existing tests continue passing
- [ ] No new tests needed (structural migration only)
- [ ] Test paths updated correctly

### Integration Tests

- [ ] Phoenix server starts correctly
- [ ] Assets are served correctly
- [ ] Database works correctly
- [ ] Routes work correctly
- [ ] LiveView works correctly

### Manual Testing Checklist

- [ ] `mix compile` at root compiles all apps
- [ ] `cd apps/tremtec && mix phx.server` starts server
- [ ] Application loads at `http://localhost:4000`
- [ ] Assets (CSS/JS) are loaded correctly
- [ ] Database works (create user, login, etc)
- [ ] LiveView works correctly
- [ ] `mix test` passes all tests
- [ ] `mix precommit` passes

## Risk Assessment

### Technical Risks

- **Risk**: Incorrect paths may break assets or database
  - **Mitigation**: Carefully test each path update, verify with `mix assets.build` and `mix ecto.setup`

- **Risk**: Aliases may not work correctly
  - **Mitigation**: Test each alias after update, verify delegation works

- **Risk**: Docker build may fail
  - **Mitigation**: Test Dockerfile after all changes, verify COPY paths

- **Risk**: Compilation errors due to module path issues
  - **Mitigation**: Verify `elixirc_paths` are correct, test compilation at each step

### Dependencies Risks

- **Risk**: Dependencies may not resolve correctly in umbrella
  - **Mitigation**: Verify `mix deps.get` and `mix deps.compile` after changes, check for conflicts

- **Risk**: `tremtec_shared` dependency may not resolve
  - **Mitigation**: Ensure `in_umbrella: true` is set correctly, verify compilation

### Git Risks

- **Risk**: Large file moves may cause git issues
  - **Mitigation**: Use `git mv` if needed, or ensure git tracks moves correctly

## Rollback Plan

1. **If migration fails early** (before moving files):
   - Revert root `mix.exs`: `git checkout HEAD -- mix.exs`
   - Remove `apps/` directory: `rm -rf apps/`

2. **If migration fails after moving files**:
   - Use git to restore: `git reset --hard HEAD`
   - Or manually move directories back:

     ```bash
     mv apps/tremtec/lib .
     mv apps/tremtec/test .
     mv apps/tremtec/priv .
     mv apps/tremtec/assets .
     ```

3. **If compilation fails**:
   - Check error messages for path issues
   - Verify all paths updated correctly
   - Revert specific config files if needed

## Success Verification

- [x] Spec created and approved
- [x] Research complete
- [ ] Plan created and approved
- [ ] All files moved correctly
- [ ] Configurations updated
- [ ] `mix compile` works at root
- [ ] `mix compile` works in apps/tremtec
- [ ] `mix compile` works in apps/tremtec_shared
- [ ] `mix test` passes in apps/tremtec
- [ ] `mix phx.server` works in apps/tremtec
- [ ] Assets compile correctly
- [ ] Database works correctly
- [ ] Dockerfile works
- [ ] Dockerfile.dev works
- [ ] README.md updated
- [ ] `mix precommit` passes

## Notes

- This is a structural migration, not functional
- No functionality should be changed, only organization
- Specific commands must be executed inside `apps/tremtec/`
- Future projects will be generated using `mix phx.new` within the umbrella when needed
- `.env` and `mise.toml` remain at root (no changes needed)
- Git history is preserved (files are moved, not copied)

## Estimated Timeline

- **Total Estimated Time**: 4-5 hours
- **Breakdown**:
  - Setup and structure: 30 minutes
  - File moves and configs: 1.5 hours
  - Docker updates: 45 minutes
  - Testing and verification: 1.5 hours
  - Documentation: 30 minutes

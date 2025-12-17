# Feature Specification: Umbrella Project Structure

## Feature Name

Umbrella Project Migration

## Objective

Transform the current Tremtec project into an Elixir umbrella project, allowing management of multiple Phoenix applications (Tremtec, Faz, ShareThing) and shared components (TremtecShared) in a single monorepo.

## User Story

As a Tremtec developer, I want to have a monorepo organized as an umbrella project so that I can manage multiple Phoenix projects centrally, share common components, and facilitate future development of new products.

## Functional Requirements

- The root project must be configured as an umbrella project with `apps_path: "apps"`
- The current Tremtec application must be moved to `apps/tremtec/` maintaining all existing functionality
- There must be an app `apps/tremtec_shared/` for shared components and utilities
- All configurations (config/, Dockerfile, scripts) must be updated to work with the umbrella structure
- Mix aliases must work correctly in the umbrella structure
- The project must compile and run normally after migration
- All tests must continue passing after migration

## Success Criteria

- `mix compile` works at the project root
- `mix phx.server` starts the Tremtec application correctly
- `mix test` executes all tests successfully
- The directory structure reflects the umbrella organization
- The Dockerfile works with the new structure
- Asset paths (esbuild, tailwind) are correct
- Database configurations point to the correct paths

## Notes

- Faz and ShareThing projects will be generated in the future using Phoenix scripts (`mix phx.new` within the umbrella)
- TremtecShared should contain components and utilities that can be shared between apps
- The migration must preserve all git history and existing functionality
- Environment configurations and secrets must continue working normally

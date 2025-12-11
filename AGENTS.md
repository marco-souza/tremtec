# Tremtec Project Guidelines

This is a web application written using the Phoenix web framework.

## Project Guidelines

- **Documentation**: Check `docs/` (features) and `specs/` (requirements) before starting tasks.
- **Development Workflow**: Use **SRPI** (Spec → Research → Plan → Implement) for all new features. See section below.
- **Git**: Use `mix precommit` before committing.
- **HTTP**: Use `:req`. Avoid `:httpoison`, `:tesla`, or `:httpc`.

## AI Development Workflow: SRPI (Spec → Research → Plan → Implement)

This is the standard workflow for all new features. Follow this process to ensure quality, clarity, and thorough understanding before implementation.

### Overview

**SRPI** is a four-phase structured approach to feature development:

1. **Spec** (Specification): Define requirements and acceptance criteria
2. **Research** (Technical Research): Investigate technology, versions, APIs, and best practices
3. **Plan** (Implementation Plan): Create detailed step-by-step execution tasks
4. **Implement** (Implementation): Execute the plan with code changes

### When to Use SRPI

- ✅ Any new feature or significant change
- ✅ Third-party integrations (APIs, SDKs, libraries)
- ✅ Architectural decisions
- ✅ Features with external dependencies
- ✅ Complex user flows or business logic

### When SRPI is Optional

- ⚠️ Minor bug fixes (direct to implementation)
- ⚠️ Simple refactoring (direct to implementation)
- ⚠️ Documentation updates (direct to implementation)

---

## Phase 1: Specification (S)

**Purpose**: Define what needs to be built, not how.

**File Location**: `specs/NNN-feature-name.md` (replace NNN with sequential number)

**Template**: Use `specs/000-spec-template.md` as reference

**Must Include**:
- Feature Name (clear, descriptive)
- Objective (1-2 sentences explaining purpose and goals)
- User Story (As a [role], I want [goal] so that [reason])
- Functional Requirements (clear, testable requirements)
- Success Criteria (measurable indicators)
- Notes (constraints, assumptions, additional context)

**Example Headers**:
```markdown
# Feature Specification: [Feature Name]

## Feature Name
[Concise, descriptive name]

## Objective
[Purpose and goals in 1-2 sentences]

## User Story
As a [user role], I want to [goal] so that [reason].

## Functional Requirements
- [Requirement 1]
- [Requirement 2]

## Success Criteria
- [Criterion 1]
- [Criterion 2]

## Notes
[Optional: constraints, assumptions, context]
```

**Agent Responsibility**:
1. Create spec file from template
2. Fill in all sections with user input
3. Ask for clarification if needed
4. Ensure spec is complete before proceeding to Research

---

## Phase 2: Technical Research (R)

**Purpose**: Investigate technology, versions, dependencies, and best practices. Document findings for implementation clarity.

**File Location**: `specs/NNN-feature-name.research.md` (same number as spec)

**Must Include**:
- Current versions of relevant technologies
- Dependency analysis (new packages, existing tools)
- API/Service specifications
- Technical architecture recommendations
- Implementation options with pros/cons
- Security considerations
- Performance constraints
- Integration patterns used in similar features
- Task breakdown (human vs. agent work)

**Example Sections**:
```markdown
# Technical Research: [Feature Name]

## Executive Summary
[Brief overview of findings and recommendations]

## 1. Technology Versions & Current State
- Library versions
- API versions
- Compatibility information

## 2. Technical Architecture
- Client-side details
- Server-side details
- Integration points

## 3. Project Requirements Analysis
- Configuration needs
- Environment variables
- Dependencies

## 4. Dependency Analysis
- New packages to add
- Existing tools to leverage
- Optional libraries

## 5. Key Technical Constraints
- Security considerations
- Performance limits
- Compatibility issues

## 6. Implementation Options
- Option A: Recommended
- Option B: Alternative
- Pros/cons of each

## 7. Implementation Tasks
### Phase 1: Setup (HUMAN/AGENT)
- [ ] Task 1
- [ ] Task 2

### Phase 2: Development (AGENT)
- [ ] Task 3
- [ ] Task 4

## 8. References
[Links to documentation, examples, resources]

## Summary of Recommendations
[Key takeaways for planning phase]
```

**Agent Responsibility**:
1. Search for latest versions and documentation
2. Investigate existing project patterns
3. Document API specifications
4. Identify potential risks and mitigations
5. Recommend technology choices with justification
6. Break down into human and agent tasks
7. Provide implementation guidance

---

## Phase 3: Implementation Plan (P)

**Purpose**: Create a detailed, step-by-step execution roadmap with code examples and verification steps.

**File Location**: `specs/NNN-feature-name.plan.md` (same number as spec)

**Must Include**:
- Overview & execution strategy
- Prerequisites & dependencies (what must be done first)
- Detailed task list with:
  - Owner (HUMAN or AGENT)
  - Duration estimate
  - Blocking dependencies
  - Step-by-step instructions
  - Code examples
  - Verification checklist
- Implementation sequence (recommended order)
- Critical path diagram
- Testing strategy
- Rollback plan
- Success criteria
- Estimated timeline
- Risk mitigation matrix

**Example Task Format**:
```markdown
### [TASK N-X] Task Name
**Owner**: HUMAN/AGENT  
**Duration**: 15 minutes  
**Depends On**: Task M-Y  
**Blocks**: Task O-Z  
**Status**: `todo`

#### Steps
1. First step with details
2. Code example:
   ```elixir
   # Code here
   ```
3. Verification steps

#### Verification
- [ ] Checklist item 1
- [ ] Checklist item 2
```

**Agent Responsibility**:
1. Create detailed, actionable steps
2. Include actual code examples
3. Specify exact file paths and commands
4. Provide verification steps for each task
5. Order tasks logically with clear dependencies
6. Estimate durations based on complexity
7. Create visual sequence diagram
8. Document risks and mitigations
9. Define success criteria

---

## Phase 4: Implementation (I)

**Purpose**: Execute the plan and implement the feature.

**Guidelines**:
- Follow the plan strictly; deviate only for good reasons
- Update plan if tasks change; document why
- Test as you go (don't wait for the end)
- Keep commits atomic and well-messaged
- Run `mix precommit` before each commit
- Update documentation alongside code
- Reference spec/research/plan in commit messages

**Agent Responsibility**:
1. Execute each task in order (respecting dependencies)
2. Follow verification checklist for each task
3. Write tests for new code
4. Update documentation
5. Commit changes with clear messages
6. Mark completed tasks in plan
7. Report blockers early

---

## SRPI Workflow Summary

| Phase | Owner | Input | Output | Duration |
|-------|-------|-------|--------|----------|
| **S** (Spec) | Human + Agent | Ideas, requirements | `NNN-feature.md` | 15-30 min |
| **R** (Research) | Agent | Research questions | `NNN-feature.research.md` | 30-60 min |
| **P** (Plan) | Agent | Research findings | `NNN-feature.plan.md` | 30-45 min |
| **I** (Implement) | Agent | Implementation plan | Code + tests + docs | Varies |

**Total Pre-Implementation**: ~2-3 hours  
**ROI**: Eliminates rework, clarifies scope, reduces implementation time

---

## File Naming Convention

Use sequential numbering for all feature files:

```
specs/
  000-spec-template.md
  000-implementation-plan-template.md
  001-feature-one.md
  001-feature-one.research.md
  001-feature-one.plan.md
  002-feature-two.md
  002-feature-two.research.md
  002-feature-two.plan.md
  004-turnstile-captcha.md
  004-turnstile-captcha.research.md
  004-turnstile-captcha.plan.md
```

**Rules**:
- Use 3-digit numbers (001, 002, 003, etc.)
- Increment for each new feature
- Keep NNN consistent across S/R/P files
- Use kebab-case for feature names
- Never reuse numbers

### Phoenix v1.8 & LiveView

- **Layouts**: Always wrap LV templates in `<Layouts.app flash={@flash} ...>`.
- **Components**: Use `<.icon>` (not Heroicons module) and `<.input>` (from `core_components.ex`).
- **Styling**: Override default classes completely if providing `class` attribute on components.
- **Auth**: Ensure `current_scope` is passed to `<Layouts.app>` in authenticated routes.

### JS & CSS

- **Tailwind**: Use v4 import syntax in `app.css`. No `tailwind.config.js`.
- **Custom CSS**: No `@apply`. Write custom Tailwind components in CSS or HEEx.
- **Assets**: Only `app.js`/`app.css` are supported. Import vendors there. No inline `<script>`.

### UI/UX

- **Design**: Focus on polish, micro-interactions, clean typography, and responsiveness.

<!-- phoenix-gen-auth-start -->

## Authentication

- **Always** handle authentication flow at the router level with proper redirects
- **Always** be mindful of where to place routes. `phx.gen.auth` creates multiple router plugs and `live_session` scopes:
  - A plug `:fetch_current_scope_for_user` that is included in the default browser pipeline
  - A plug `:require_authenticated_user` that redirects to the log in page when the user is not authenticated
  - A `live_session :current_user` scope - for routes that need the current user but don't require authentication, similar to `:fetch_current_scope_for_user`
  - A `live_session :require_authenticated_user` scope - for routes that require authentication, similar to the plug with the same name
  - In both cases, a `@current_scope` is assigned to the Plug connection and LiveView socket
  - A plug `redirect_if_user_is_authenticated` that redirects to a default path in case the user is authenticated - useful for a registration page that should only be shown to unauthenticated users
- **Always let the user know in which router scopes, `live_session`, and pipeline you are placing the route, AND SAY WHY**
- `phx.gen.auth` assigns the `current_scope` assign - it **does not assign a `current_user` assign**
- Always pass the assign `current_scope` to context modules as first argument. When performing queries, use `current_scope.user` to filter the query results
- To derive/access `current_user` in templates, **always use the `@current_scope.user`**, never use **`@current_user`** in templates or LiveViews
- **Never** duplicate `live_session` names. A `live_session :current_user` can only be defined **once** in the router, so all routes for the `live_session :current_user` must be grouped in a single block
- Anytime you hit `current_scope` errors or the logged in session isn't displaying the right content, **always double check the router and ensure you are using the correct plug and `live_session` as described below**

### Routes that require authentication

LiveViews that require login should **always be placed inside the **existing** `live_session :require_authenticated_user` block**:

    scope "/", AppWeb do
      pipe_through [:browser, :require_authenticated_user]

      live_session :require_authenticated_user,
        on_mount: [{TremtecWeb.UserAuth, :require_authenticated}] do
        # phx.gen.auth generated routes
        live "/admin/settings", UserLive.Settings, :edit
        live "/admin/settings/confirm-email/:token", UserLive.Settings, :confirm_email
        # our own routes that require logged in user
        live "/", MyLiveThatRequiresAuth, :index
      end
    end

Controller routes must be placed in a scope that sets the `:require_authenticated_user` plug:

    scope "/", AppWeb do
      pipe_through [:browser, :require_authenticated_user]

      get "/", MyControllerThatRequiresAuth, :index
    end

### Routes that work with or without authentication

LiveViews that can work with or without authentication, **always use the **existing** `:current_user` scope**, ie:

    scope "/", MyAppWeb do
      pipe_through [:browser]

      live_session :current_user,
        on_mount: [{TremtecWeb.UserAuth, :mount_current_scope}] do
        # our own routes that work with or without authentication
        live "/", PublicLive
      end
    end

Controllers automatically have the `current_scope` available if they use the `:browser` pipeline.

<!-- phoenix-gen-auth-end -->

<!-- usage-rules-start -->

<!-- phoenix:elixir-start -->

## Elixir Guidelines

- **Lists**: No index access (`list[i]`). Use `Enum.at/2`.
- **Modules**: One module per file.
- **Structs**: No map access (`struct[:field]`). Use `struct.field` or `Ecto.Changeset.get_field`.
- **Safety**: No `String.to_atom/1` on user input.

### Immutability & Scope

Elixir variables are immutable. You must rebind results from blocks (`if`, `case`, etc).

```elixir
# Correct
socket = if connected?(socket), do: assign(socket, :x, 1), else: socket

# Incorrect (value is lost)
if connected?(socket), do: assign(socket, :x, 1)
```

### Concurrency

Use `Task.async_stream` with infinite timeout for data processing.

```elixir
Task.async_stream(items, &process/1, timeout: :infinity)
```

<!-- phoenix:elixir-end -->

<!-- phoenix:phoenix-start -->

## Phoenix Guidelines

- **Routing**: `scope` aliases modules automatically. Don't create duplicate aliases.
- **Views**: `Phoenix.View` is removed. Don't use it.
<!-- phoenix:phoenix-end -->

<!-- phoenix:ecto-start -->

## Ecto Guidelines

- **Queries**: Preload associations used in templates.
- **Seeds**: Use `priv/repo/seeds.exs` (ensure idempotency).
- **Changesets**: Use `get_field(changeset, :field)` for access. `validate_number` implies `allow_nil: false`.
- **Security**: Set sensitive fields (like `user_id`) manually in the context, not in `cast`.
<!-- phoenix:ecto-end -->

## Infrastructure & Deployment

- **Config**: Use `config/runtime.exs` for secrets. `Application.compile_env` for static.
- **Env Vars**: `LIVE_VIEW_SIGNING_SALT`, `DATABASE_PATH`, `SECRET_KEY_BASE`, `RESEND_API_KEY`, `SMTP_FROM_EMAIL`.
- **Docker/Fly**: Multi-stage builds, non-root user, SQLite volumes. Secrets in Fly env.

<!-- phoenix:html-start -->

## Phoenix HTML (HEEx)

- **Syntax**: Always `~H`.
- **Loops**: Use `<%= for item <- @items do %>` (not `Enum.each`).
- **Conditionals**: Use `cond` for multiple conditions (No `else if`).

### Interpolation & Classes

- Tag attributes/Text: `{val}`.
- Tag Bodies (blocks): `<%= if ... %>`.
- **Class Lists**: Use list syntax for conditional classes.

```heex
<div class={[
  "base-class",
  @active && "is-active",
  if(@error, do: "text-red-500", else: "text-gray-500")
]}>
```

<!-- phoenix:html-end -->

<!-- phoenix:liveview-start -->

## LiveView Guidelines

- **Navigation**: Use `<.link navigate/patch>` and `push_navigate/push_patch`.
- **Hooks**: `phx-hook` elements must have `phx-update="ignore"`.
- **Tests**: Use `Phoenix.LiveViewTest` & `LazyHTML`. Select by ID (e.g., `#my-form`).

### Streams

- Use `stream(socket, :items, items)` in backend.
- **Template Rules**: Parent needs `phx-update="stream"` and ID. Child needs ID from stream.

```heex
<tbody id="items" phx-update="stream">
  <tr :for={{id, item} <- @streams.items} id={id}>
    <td>{item.name}</td>
  </tr>
</tbody>
```

- **Filtering**: Must reset stream: `stream(socket, :items, new_items, reset: true)`.

### Forms

- Logic: `handle_event` -> `assign(socket, form: to_form(params/changeset))`.
- Template: Use `for={@form}`. Never access changeset directly.

```heex
<.form for={@form} id="user-form" phx-change="validate" phx-submit="save">
  <.input field={@form[:email]} />
    </.form>
```

<!-- phoenix:liveview-end -->

<!-- i18n-start -->

## Internationalization (i18n)

> **Full Documentation**: See `docs/I18N.md`  
> **Audit Report**: See `I18N_AUDIT_REPORT.md` for compliance status

### Core Rules

- **All user-facing strings**: Use `gettext("...")`
- **Validation errors**: Use `dgettext("errors", "...")`
- **Pluralization**: Use `ngettext("singular", "plural", count, count: count)`
- **Company name**: "TremTec" is NOT translated (proper noun)
- **Tests**: Include `use Gettext, backend: TremtecWeb.Gettext` at module level

### String Translation Patterns

#### Templates (HEEx)
```heex
<!-- Static strings -->
<h1>{gettext("Admin Dashboard")}</h1>

<!-- In attributes -->
<.input placeholder={gettext("Enter your name")} />

<!-- With interpolation -->
<p>{gettext("Welcome back,")} {@current_scope.user.email}</p>
```

#### LiveView & Controllers
```elixir
# Basic translation
flash_msg = gettext("Success message here")

# Error messages from validation
error_msg = dgettext("errors", "can't be blank")

# Pluralization (relative time, counts, etc)
message = ngettext("%{count} item", "%{count} items", count, count: count)
```

### Workflow

1. **Add string**: Wrap in `gettext()` in template/code
2. **Extract**: Run `mix gettext.extract --merge`
3. **Translate**: Edit `priv/gettext/{locale}/LC_MESSAGES/default.po`
4. **Test**: Use `gettext()` in test assertions: `assert html =~ gettext("...")`
5. **Verify**: Render pages in different locales to test

### Current Locales

| Locale | File | Status |
|--------|------|--------|
| Portuguese | `priv/gettext/pt/` | ✅ Default + Complete |
| English | `priv/gettext/en/` | ✅ Complete |
| Spanish | `priv/gettext/es/` | ✅ Complete |

### Common Pitfalls

❌ **DON'T**: 
- Use hardcoded strings in templates without `gettext()`
- Hardcode error messages (use `dgettext("errors", ...)`)
- Compare against literal strings in tests
- Manually edit .po file msgids (use `mix gettext.extract --merge`)

✅ **DO**:
- Wrap all user-facing text in translation functions
- Use relative date formatting with `ngettext()`
- Test assertions with `gettext()` calls
- Run `mix gettext.extract --merge` after adding strings
  <!-- i18n-end -->

<!-- usage-rules-end -->

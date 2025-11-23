# Tremtec Project Guidelines

This is a web application written using the Phoenix web framework.

## Project Guidelines

- **Documentation**: Check `docs/` (features) and `specs/` (requirements) before starting tasks.
- **Git**: Use `mix precommit` before committing.
- **HTTP**: Use `:req`. Avoid `:httpoison`, `:tesla`, or `:httpc`.

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
- **Env Vars**: `ADMIN_USER`, `ADMIN_PASS`, `LIVE_VIEW_SIGNING_SALT`, `DATABASE_PATH`, `SECRET_KEY_BASE`.
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

> **Full Documentation**: See `docs/I18N.md`.

- **Rule**: All user-facing strings must use `gettext("...")`. Errors use `dgettext("errors", "...")`.
- **Workflow**:
  1. Code: `<.button>{gettext("Save")}</.button>`
  2. Extract: `mix gettext.extract --merge`
  3. Translate: Edit `priv/gettext/**/*.po`
<!-- i18n-end -->

<!-- usage-rules-end -->

# Implementation Plan: Cloudflare Turnstile CAPTCHA

> **Phase 2 of Spec-Driven Development**
>
> Reference: `specs/004-cloudflare-turnstile-captcha.md` (spec)  
> Reference: `specs/004-cloudflare-turnstile-captcha.research.md` (technical research)

---

## 1. Overview & Execution Strategy

### Execution Model

- **Parallel Tracks**: Some tasks can run in parallel
- **Blocking Sequence**: Human dashboard setup → dependency installation → implementation
- **Duration Estimate**: 2-3 days (Agent-focused: 1-2 days; Human setup: parallel)

### Task Distribution

- **HUMAN**: 2 tasks (Cloudflare setup, env var management)
- **AGENT**: 8 tasks (all development work)

---

## 2. Prerequisites & Dependencies

### Before Starting

1. Access to Cloudflare Dashboard (account created)
2. Project local environment running (`mix phx.server`)
3. Contact form LiveView already exists: `lib/tremtec_web/live/contact_live.ex` (assumed)
4. Environment file setup (`.env.local` or similar for dev)

### Required Mix Dependencies

```elixir
# Current project likely has these, verify in mix.exs:
{:phoenix_live_view, "~> 0.20"}    # for LiveView
{:req, "~> 0.4"}                    # for HTTP (already used in project)
```

### New Dependency to Add

```elixir
{:phoenix_turnstile, "~> 1.2"}
```

---

## 3. Task List & Detailed Steps

### [TASK 0-H] Cloudflare Dashboard Setup ⚠️ BLOCKING

**Owner**: HUMAN  
**Duration**: 15-30 minutes  
**Blocks**: Task 1-A  
**Status**: `todo`

#### Steps

1. Log into Cloudflare Dashboard (https://dash.cloudflare.com)
2. Navigate to **Turnstile** section (left sidebar)
3. Click **Create Site** and fill:
   - **Site Name**: `TremTec Contact Form` (or `TremTec Dev`)
   - **Domains**:
     - Development: `localhost:3000`
     - Add production domain when ready
   - **Mode**: Select **Managed** (shows checkbox if suspicious)
   - **Bot Fight Mode**: Enable if available
4. Copy displayed credentials:
   - **Site Key**: (20-char alphanumeric, public)
   - **Secret Key**: (40-char alphanumeric, private)
5. Create `.env.local` file in project root with:
   ```env
   TURNSTILE_SITE_KEY=your_site_key_here
   TURNSTILE_SECRET_KEY=your_secret_key_here
   ```
6. **DO NOT commit `.env.local` to git** (add to `.gitignore` if missing)
7. Post credentials securely to team (LastPass/1Password/secure channel, not Slack/email)

#### Verification

- [ ] Can access Turnstile dashboard
- [ ] Widget created and visible in dashboard
- [ ] Keys copied to `.env.local`
- [ ] `.env.local` not tracked by git

---

### [TASK 1-A] Dependency Installation & Configuration

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: Task 0-H  
**Status**: `todo`

#### Steps

**1. Add dependency to `mix.exs`:**

```elixir
defp deps do
  [
    # ... existing deps ...
    {:phoenix_turnstile, "~> 1.2"}
  ]
end
```

**2. Run dependency installation:**

```bash
mix deps.get
```

**3. Configure in `config/runtime.exs`:**

```elixir
# config/runtime.exs - add to existing config :phoenix_turnstile section
config :phoenix_turnstile,
  site_key: System.get_env("TURNSTILE_SITE_KEY", "1x00000000000000000000AA"),
  secret_key: System.get_env("TURNSTILE_SECRET_KEY", "1x0000000000000000000000000000000000AA")
```

**4. Update `.env.example`** (template for team):

```env
# Cloudflare Turnstile
TURNSTILE_SITE_KEY=your_site_key_here
TURNSTILE_SECRET_KEY=your_secret_key_here
```

**5. Test configuration:**

```bash
iex -S mix
# In iex:
iex> Application.fetch_env!(:phoenix_turnstile, :site_key)
```

#### Verification

- [ ] `mix deps.get` succeeds
- [ ] No compilation errors
- [ ] `config/runtime.exs` has Turnstile config
- [ ] `.env.example` updated
- [ ] iex test returns correct key

---

### [TASK 2-A] JavaScript Hook Setup

**Owner**: AGENT  
**Duration**: 10 minutes  
**Depends On**: Task 1-A  
**Status**: `todo`

#### Steps

**1. Update `assets/app.js`:**

Locate the LiveSocket initialization (around line 20-30):

```javascript
import { TurnstileHook } from "phoenix_turnstile";

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2000,
  params: { _csrf_token: csrfToken },
  hooks: {
    Turnstile: TurnstileHook, // Add this line
  },
});

liveSocket.connect();
```

**2. Verify module resolution:**

```bash
# Ensure esbuild can find phoenix_turnstile
# Check assets/config.exs has NODE_PATH configured:
```

In `assets/config.exs`, the esbuild config should include:

```javascript
const path = require("path")

module.exports = {
  inputs: {...},
  output: "...",
  esbuildOptions: {
    nodePaths: [path.join(__dirname, "../deps")],  // Important!
    alias: {}
  }
}
```

**3. Test compilation:**

```bash
cd assets && npm run deploy
# Should compile without errors
cd ..
```

#### Verification

- [ ] `assets/app.js` imports TurnstileHook
- [ ] Hook registered in LiveSocket
- [ ] `assets/config.exs` has nodePaths configured
- [ ] Asset compilation succeeds
- [ ] No browser console errors on page load

---

### [TASK 3-A] Layout Integration

**Owner**: AGENT  
**Duration**: 5 minutes  
**Depends On**: Task 2-A  
**Status**: `todo`

#### Steps

**1. Add Turnstile script to root layout:**

Edit `lib/tremtec_web/components/layouts/root.html.heex`:

```heex
<!DOCTYPE html>
<html lang={@locale || "pt"}>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="csrf-token" content={get_csrf_token()} />
    <%= live_title_tag(assigns[:page_title] || gettext("TremTec")) %>
    <link phx-track-static rel="stylesheet" href={~p"/assets/app.css"} />
    <script defer phx-track-static type="text/javascript" src={~p"/assets/app.js"}></script>

    <!-- Add Turnstile script here -->
    <Turnstile.script />
  </head>
  <body>
    <!-- rest of layout -->
  </body>
</html>
```

**2. Verify layout path:**

- LiveView v1.18+: usually `lib/tremtec_web/components/layouts/root.html.heex`
- Legacy: might be `lib/tremtec_web/templates/layout/`

#### Verification

- [ ] `<Turnstile.script />` added to `<head>`
- [ ] Page loads without 404 on Turnstile script
- [ ] Browser DevTools shows script loaded

---

### [TASK 4-A] Contact Form Template Update

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: Task 3-A  
**Status**: `todo`

#### Steps

**1. Locate contact form LiveView:**

- File: `lib/tremtec_web/live/contact_live.ex` (assumed, adjust path as needed)
- Template: `lib/tremtec_web/live/contact_live/index.html.heex`

**2. Update form template to include widget:**

```heex
<.form for={@form} id="contact-form" phx-submit="submit" phx-change="validate">
  <.input
    field={@form[:name]}
    type="text"
    label={gettext("Name")}
    placeholder={gettext("Your name")}
    required
  />

  <.input
    field={@form[:email]}
    type="email"
    label={gettext("Email")}
    placeholder={gettext("your@email.com")}
    required
  />

  <.input
    field={@form[:message]}
    type="textarea"
    label={gettext("Message")}
    placeholder={gettext("Your message here")}
    required
  />

  <!-- Add Turnstile widget here, before submit button -->
  <div class="turnstile-wrapper my-4">
    <Turnstile.widget
      theme="light"
      size="normal"
      id="contact-captcha"
    />
  </div>

  <button type="submit" class="btn btn-primary">
    {gettext("Send Message")}
  </button>
</form>

<style>
  .turnstile-wrapper {
    display: flex;
    justify-content: center;
  }
</style>
```

**3. Note on widget attributes:**

- `theme="light"` - matches light mode (use "auto" for auto-detect)
- `size="normal"` - standard widget size
- `id="contact-captcha"` - unique ID if multiple widgets on page

#### Verification

- [ ] Form renders with Turnstile widget visible
- [ ] Widget appears above submit button
- [ ] Widget is responsive on mobile (test in DevTools)
- [ ] No console errors

---

### [TASK 5-A] LiveView Event Handler Implementation

**Owner**: AGENT  
**Duration**: 30 minutes  
**Depends On**: Task 4-A  
**Status**: `todo`

#### Steps

**1. Update contact form module:**
`lib/tremtec_web/live/contact_live.ex`

```elixir
defmodule TremtecWeb.ContactLive do
  use TremtecWeb, :live_view

  alias Tremtec.Contact
  alias Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(form: to_form(Contact.change_contact_submission(%{})))
     |> assign(submit_ok: false)}
  end

  def handle_event("validate", params, socket) do
    form = Contact.change_contact_submission(params) |> to_form()
    {:noreply, assign(socket, form: form)}
  end

  def handle_event("submit", params, socket) do
    # Get visitor IP address from socket
    remote_ip = get_remote_ip(socket)

    # Extract Turnstile token
    token = params["cf-turnstile-response"]

    case validate_captcha(token, remote_ip) do
      {:ok, _response} ->
        # Token is valid, process form submission
        case Contact.create_contact_submission(
          params,
          socket.assigns.current_scope
        ) do
          {:ok, _submission} ->
            socket =
              socket
              |> put_flash(:info, gettext("Message sent successfully!"))
              |> push_navigate(to: ~p"/contact?success=true")

            {:noreply, socket}

          {:error, changeset} ->
            form = to_form(changeset)
            {:noreply, assign(socket, form: form)}
        end

      {:error, reason} ->
        # Token validation failed
        socket =
          socket
          |> put_flash(:error, gettext("Verification failed. Please try again."))
          |> Turnstile.refresh()

        {:noreply, socket}
    end
  end

  # Private helpers

  defp validate_captcha(token, remote_ip) when is_binary(token) and byte_size(token) > 0 do
    @turnstile_adapter.verify(
      %{"cf-turnstile-response" => token},
      remote_ip
    )
  end

  defp validate_captcha(nil, _remote_ip) do
    {:error, :missing_token}
  end

  defp get_remote_ip(socket) do
    # Extract IP from socket connect info
    case socket.connected? do
      true ->
        get_connect_info(socket, :peer_data)
        |> case do
          %{address: ip} -> ip
          _ -> nil
        end

      false ->
        nil
    end
  end

  # For testing: allow adapter to be configurable
  @turnstile_adapter Application.compile_env(
    :phoenix_turnstile,
    :adapter,
    Turnstile
  )
end
```

**2. Update socket configuration in `lib/tremtec_web/endpoint.ex`:**

Find the socket definition (around line 20-30):

```elixir
socket "/live", Phoenix.LiveView.Socket,
  websocket: [
    connect_info: [:peer_data, session: @session_options]
  ],
  longpoll: [
    connect_info: [:peer_data, session: @session_options]
  ]
```

Verify `:peer_data` is included (needed to get visitor IP).

**3. Create context function for submission:**

If not already exists, create `lib/tremtec/contact.ex`:

```elixir
defmodule Tremtec.Contact do
  import Ecto.Changeset

  def change_contact_submission(attrs \\ %{}) do
    %{}
    |> cast(attrs, [:name, :email, :message])
    |> validate_required([:name, :email, :message])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:message, min: 10)
  end

  def create_contact_submission(attrs, current_scope) do
    changeset = change_contact_submission(attrs)

    if changeset.valid? do
      # Send email or save to database
      # ...
      {:ok, changeset}
    else
      {:error, changeset}
    end
  end
end
```

#### Verification

- [ ] Form submits successfully with valid captcha
- [ ] Form shows flash error on failed captcha
- [ ] Widget refreshes on captcha failure
- [ ] Remote IP is extracted (check logs)
- [ ] No token means validation fails
- [ ] Expired token shows error message

---

### [TASK 6-A] Internationalization (gettext)

**Owner**: AGENT  
**Duration**: 20 minutes  
**Depends On**: Task 5-A  
**Status**: `todo`

#### Steps

**1. Extract strings:**

```bash
mix gettext.extract --merge
```

This scans all `.ex`, `.exs`, `.heex` files and updates `.po` files.

**2. Add translations to `priv/gettext/pt/LC_MESSAGES/default.po`:**

```po
#: lib/tremtec_web/live/contact_live.ex
msgid "Verification failed. Please try again."
msgstr "Verificação falhou. Tente novamente."

#: lib/tremtec_web/live/contact_live.ex
msgid "Message sent successfully!"
msgstr "Mensagem enviada com sucesso!"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "Name"
msgstr "Nome"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "Email"
msgstr "Email"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "Message"
msgstr "Mensagem"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "Send Message"
msgstr "Enviar Mensagem"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "Your name"
msgstr "Seu nome"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "your@email.com"
msgstr "seu@email.com"

#: lib/tremtec_web/live/contact_live/index.html.heex
msgid "Your message here"
msgstr "Sua mensagem aqui"
```

**3. Add same to English `priv/gettext/en/LC_MESSAGES/default.po`:**

```po
msgid "Verification failed. Please try again."
msgstr "Verification failed. Please try again."
# (same as source for English)
```

**4. Add same to Spanish `priv/gettext/es/LC_MESSAGES/default.po`:**

```po
msgid "Verification failed. Please try again."
msgstr "La verificación falló. Intente de nuevo."
# (Spanish translations)
```

**5. Compile translations:**

```bash
mix gettext.compile
```

**6. Test in different locales:**

```bash
# In IEx
iex> Gettext.put_locale(TremtecWeb.Gettext, "pt")
iex> gettext("Verification failed. Please try again.")
```

#### Verification

- [ ] `mix gettext.extract --merge` runs without errors
- [ ] `.po` files updated with new strings
- [ ] All translations added (PT, EN, ES)
- [ ] `mix gettext.compile` succeeds
- [ ] Locale switching works in test

---

### [TASK 7-A] Testing Implementation

**Owner**: AGENT  
**Duration**: 30 minutes  
**Depends On**: Task 5-A  
**Status**: `todo`

#### Steps

**1. Add mox to `mix.exs` (dev/test):**

```elixir
defp deps do
  [
    # ... existing deps ...
    {:mox, "~> 1.1", only: :test}
  ]
end
```

**2. Setup mox in `test/test_helper.exs`:**

```elixir
# test/test_helper.exs
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Tremtec.Repo, :manual)

# Define Turnstile mock
Mox.defmock(TurnstileMock, for: Turnstile.Behaviour)
```

**3. Configure test env in `config/test.exs`:**

```elixir
# config/test.exs
config :phoenix_turnstile,
  site_key: "1x00000000000000000000AA",
  secret_key: "1x0000000000000000000000000000000000AA",
  adapter: TurnstileMock
```

**4. Write LiveView tests in `test/tremtec_web/live/contact_live_test.exs`:**

```elixir
defmodule TremtecWeb.ContactLiveTest do
  use TremtecWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  import Mox

  setup do
    stub(TurnstileMock, :verify, fn _values, _ip -> {:ok, %{"success" => true}} end)
    stub(TurnstileMock, :refresh, fn socket -> socket end)
    :ok
  end

  test "contact form renders", %{conn: conn} do
    {:ok, _lv, html} = live(conn, ~p"/contact")
    assert html =~ "Send Message"
  end

  test "successful captcha and form submission", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/contact")

    assert lv
           |> form("#contact-form", %{
             "name" => "John Doe",
             "email" => "john@example.com",
             "message" => "This is a test message",
             "cf-turnstile-response" => "valid-token-here"
           })
           |> render_submit() =~ "Message sent successfully"
  end

  test "failed captcha shows error and refreshes widget", %{conn: conn} do
    stub(TurnstileMock, :verify, fn _values, _ip -> {:error, "invalid-token"} end)

    {:ok, lv, _html} = live(conn, ~p"/contact")

    assert lv
           |> form("#contact-form", %{
             "name" => "John Doe",
             "email" => "john@example.com",
             "message" => "This is a test message",
             "cf-turnstile-response" => "invalid-token"
           })
           |> render_submit() =~ "Verification failed"
  end

  test "missing token fails validation", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/contact")

    assert lv
           |> form("#contact-form", %{
             "name" => "John Doe",
             "email" => "john@example.com",
             "message" => "This is a test message"
           })
           |> render_submit() =~ "Verification failed"
  end

  test "form validation displays errors", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/contact")

    assert lv
           |> form("#contact-form", %{"name" => "", "email" => "invalid"})
           |> render_change() =~ "can&#39;t be blank"
  end
end
```

**5. Run tests:**

```bash
mix test test/tremtec_web/live/contact_live_test.exs
```

#### Verification

- [ ] Mox installed and configured
- [ ] Tests compile without errors
- [ ] All test cases pass
- [ ] Mock stubs work correctly
- [ ] No real API calls during tests

---

### [TASK 8-A] Security & CSP Headers

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: Task 4-A  
**Status**: `todo`

#### Steps

**1. Update CSP headers in `lib/tremtec_web/endpoint.ex`:**

Find the plug that sets CSP (usually around line 40-60):

```elixir
plug :put_security_headers

def put_security_headers(conn, _opts) do
  Plug.Conn.put_resp_headers(conn, %{
    "x-frame-options" => "SAMEORIGIN",
    "x-content-type-options" => "nosniff",
    "x-xss-protection" => "1; mode=block",
    "content-security-policy" =>
      "default-src 'self'; " <>
      "script-src 'self' 'unsafe-inline' https://challenges.cloudflare.com; " <>
      "frame-src 'self' https://challenges.cloudflare.com; " <>
      "style-src 'self' 'unsafe-inline'; " <>
      "img-src 'self' data: https:; " <>
      "font-src 'self' data:; " <>
      "connect-src 'self' https://challenges.cloudflare.com"
  })
end
```

**Key points:**

- `script-src`: Add `https://challenges.cloudflare.com`
- `frame-src`: Add `https://challenges.cloudflare.com`
- `connect-src`: Add `https://challenges.cloudflare.com` (for validation calls)

**2. Test CSP in browser:**

```bash
mix phx.server
# Open DevTools Console
# Verify no CSP warnings about challenges.cloudflare.com
```

**3. Audit logging (optional):**

Add logging to contact submission to track validation events:

```elixir
# In contact_live.ex handle_event
case validate_captcha(token, remote_ip) do
  {:ok, response} ->
    Logger.info("Captcha validation succeeded", extra: %{
      ip: inspect(remote_ip),
      challenge_ts: response["challenge_ts"]
    })
    # ... continue

  {:error, reason} ->
    Logger.warning("Captcha validation failed",
      extra: %{ip: inspect(remote_ip), reason: inspect(reason)}
    )
    # ... error handling
end
```

#### Verification

- [ ] CSP headers include Cloudflare Turnstile domains
- [ ] No CSP violations in browser console
- [ ] Validation calls succeed
- [ ] Logs capture validation events (no sensitive data)

---

### [TASK 9-A] Documentation & Handoff

**Owner**: AGENT  
**Duration**: 15 minutes  
**Depends On**: All above tasks  
**Status**: `todo`

#### Steps

**1. Create `docs/TURNSTILE_SETUP.md`:**

```markdown
# Cloudflare Turnstile Setup Guide

## Overview

The contact form is protected with Cloudflare Turnstile CAPTCHA.

## Environment Variables

Set these in `.env.local` (never commit):

- `TURNSTILE_SITE_KEY`: Public key from Cloudflare Dashboard
- `TURNSTILE_SECRET_KEY`: Private key from Cloudflare Dashboard

## Testing Locally

The dev environment uses Cloudflare test keys by default. No real API calls are made.

## Troubleshooting

- Widget not appearing: Check CSP headers and browser console
- Token validation failing: Verify secret key is correct
- Expired token: User must wait for new challenge (5 min timeout)

## Monitoring

Check logs for:

- Validation successes: `Captcha validation succeeded`
- Validation failures: `Captcha validation failed`
```

**2. Update README.md with Turnstile info:**
Add to relevant section:

```markdown
### Captcha Protection

The contact form uses Cloudflare Turnstile for bot protection.
See `docs/TURNSTILE_SETUP.md` for configuration.
```

**3. Add comments in code:**

```elixir
# lib/tremtec_web/live/contact_live.ex - top of file
# Turnstile CAPTCHA Integration
# - Widget: client-side verification
# - Validation: server-side token verification via Siteverify API
# - Token lifetime: 300 seconds (5 minutes)
# - Tokens are single-use and expire automatically
```

#### Verification

- [ ] Documentation created
- [ ] README updated
- [ ] Code comments added
- [ ] Team can understand setup from docs

---

## 4. Implementation Sequence (Recommended Order)

```
┌─────────────────────────────────────────────────────────┐
│  TASK 0-H: Cloudflare Dashboard Setup (HUMAN)           │
│  Duration: 15-30 min                                     │
│  Output: TURNSTILE_SITE_KEY, TURNSTILE_SECRET_KEY       │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  TASK 1-A: Dependencies & Config (AGENT)                │
│  Duration: 10 min                                        │
│  Blocks: 2-A, 3-A                                        │
└─────────────────────────────────────────────────────────┘
                   ↙                    ↘
        TASK 2-A (JS)              TASK 5-A (Logic)
        Duration: 10 min           Duration: 30 min
            ↓                           ↓
        TASK 3-A (Layout)          TASK 6-A (i18n)
        Duration: 5 min            Duration: 20 min
            ↓                           ↓
        TASK 4-A (Form)             (depends on above)
        Duration: 15 min                ↓
            ↓                       TASK 7-A (Tests)
        (depends on above)          Duration: 30 min
                                        ↓
                    TASK 8-A (CSP/Security)
                    Duration: 15 min
                        ↓
                    TASK 9-A (Docs)
                    Duration: 15 min
                        ↓
                  ✅ COMPLETE
```

### Critical Path

1. Task 0-H (human setup) - **MUST complete first**
2. Task 1-A (dependency) - prerequisite for all dev tasks
3. Tasks 2-A, 3-A, 4-A (sequential: JS → Layout → Form)
4. Task 5-A (logic) - can start in parallel with tasks 2-4
5. Tasks 6-A, 7-A, 8-A, 9-A (sequential: i18n → tests → security → docs)

---

## 5. Testing Strategy

### Unit Tests

- [ ] Captcha validation success/failure paths
- [ ] Form validation logic
- [ ] IP address extraction from socket
- [ ] Error message display

### Integration Tests

- [ ] Full form submission flow with mocked Turnstile
- [ ] Token expiration handling
- [ ] LiveView event handling

### Manual Testing

- [ ] Widget renders on page load
- [ ] Widget completes challenge successfully
- [ ] Failed validation shows error
- [ ] Form submits on success
- [ ] Mobile responsiveness (DevTools)
- [ ] Multiple locales (PT, EN, ES)

### Security Testing

- [ ] CSP headers allow Turnstile domains
- [ ] Secret key never exposed in client code
- [ ] Secret key not in logs
- [ ] Token validation always server-side
- [ ] Invalid tokens rejected

---

## 6. Rollback Plan

If issues arise at any point:

| Task | Rollback                                    | Impact                                 |
| ---- | ------------------------------------------- | -------------------------------------- |
| 0-H  | Delete Turnstile widget in dashboard        | Contact form shows validation error    |
| 1-A  | Remove phoenix_turnstile dep, revert config | Need to implement manually             |
| 2-A  | Remove TurnstileHook from app.js            | Widget won't load                      |
| 3-A  | Remove `<Turnstile.script />` from layout   | Widget breaks completely               |
| 4-A  | Remove widget component from form           | No captcha protection (security issue) |
| 5-A  | Revert to form without verification         | Spam risk (security issue)             |

**No rollback possible after Task 5-A without losing spam protection.**

---

## 7. Success Criteria

- [ ] Contact form renders with Turnstile widget
- [ ] Widget loads without CSP errors
- [ ] User can complete challenge
- [ ] Server validates token on submission
- [ ] Invalid/expired tokens are rejected with user-friendly errors
- [ ] All strings are internationalized (PT/EN/ES)
- [ ] Tests pass (unit + integration)
- [ ] No secret keys exposed in client code or logs
- [ ] CSP headers are properly configured
- [ ] Documentation is complete and accurate

---

## 8. Estimated Timeline

| Phase                   | Duration     | Owner     |
| ----------------------- | ------------ | --------- |
| Setup (Task 0-H)        | 15-30 min    | Human     |
| Dependencies (Task 1-A) | 10 min       | Agent     |
| Front-end (Tasks 2-4)   | 30 min       | Agent     |
| Back-end (Task 5-A)     | 30 min       | Agent     |
| i18n (Task 6-A)         | 20 min       | Agent     |
| Testing (Task 7-A)      | 30 min       | Agent     |
| Security (Task 8-A)     | 15 min       | Agent     |
| Docs (Task 9-A)         | 15 min       | Agent     |
| **TOTAL**               | **~3 hours** | **Split** |

**Parallel execution possible:** Human can do setup while Agent does Tasks 1-A in parallel  
**Realistic timeline:** 1-2 hours Agent time (if dependencies already known)

---

## 9. Risk Mitigation

| Risk                 | Probability | Severity | Mitigation                          |
| -------------------- | ----------- | -------- | ----------------------------------- |
| Keys not configured  | Medium      | High     | Early verification in Task 1-A      |
| CSP blocks widget    | Medium      | High     | Pre-add CSP before testing          |
| Token expiration UX  | Low         | Medium   | Clear error messages + widget reset |
| Accessibility issues | Low         | Medium   | Use WCAG 2.1 AA compliant widget    |
| Testing complexity   | Medium      | Medium   | Pre-write test stubs with Mox       |
| i18n strings missed  | Medium      | Low      | Use `gettext.extract` to catch all  |

---

## 10. Post-Implementation Tasks

After deployment:

- [ ] Monitor Turnstile analytics in Cloudflare Dashboard
- [ ] Check logs for validation failures (potential bot attacks)
- [ ] Periodically rotate secret keys (quarterly)
- [ ] Update documentation if widget modes change
- [ ] Consider rate limiting if spam persists
- [ ] Review user feedback on CAPTCHA experience

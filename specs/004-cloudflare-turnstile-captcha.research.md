# Technical Research: Cloudflare Turnstile CAPTCHA Implementation

## Executive Summary

Cloudflare Turnstile is a mature, production-ready bot verification service that replaces traditional CAPTCHAs. It provides free tier with comprehensive features and strong Phoenix/Elixir community support via the `phoenix_turnstile` library.

---

## 1. Cloudflare Turnstile Versions & Current State

### Latest Version
- **API**: `v0` (current stable version)
- **Script URL**: `https://challenges.cloudflare.com/turnstile/v0/api.js`
- **Library for Phoenix**: `phoenix_turnstile` v1.2.0 (latest stable)
- **Status**: Production-ready, actively maintained (2024-2025)

### Key Facts
- Free tier available with up to 20 widgets
- Enterprise plan available with unlimited widgets
- Platform-agnostic (works without Cloudflare CDN)
- WCAG 2.1 AA compliant (accessibility)
- Privacy-focused (no data harvesting for ads)

---

## 2. Technical Architecture

### Client-Side (JavaScript)
**Two Rendering Methods:**

1. **Implicit Rendering** (Simpler)
   - Auto-scans for `.cf-turnstile` class
   - Minimal JavaScript required
   - Ideal for forms, better for LiveView
   - Token injected into hidden form field `cf-turnstile-response`

2. **Explicit Rendering** (More Control)
   - Programmatic control via `turnstile.render()` API
   - Ideal for SPAs and dynamic content
   - Full lifecycle management (render, reset, remove, execute)

**Widget Types:**
- **Non-interactive**: No user interaction required (default)
- **Managed**: Shows checkbox if suspicious (fallback)
- **Invisible**: Completely hidden

### Server-Side (Elixir/Phoenix)

**Siteverify API Endpoint:**
```
POST https://challenges.cloudflare.com/turnstile/v0/siteverify
```

**Request Parameters:**
- `secret` (required): Secret key from Cloudflare dashboard
- `response` (required): Token from client widget
- `remoteip` (optional): Visitor IP for validation
- `idempotency_key` (optional): UUID for retry protection

**Response Format (JSON):**
```json
{
  "success": true,
  "challenge_ts": "2022-02-28T15:14:30.096Z",
  "hostname": "example.com",
  "error-codes": [],
  "action": "contact_form",
  "cdata": "optional_session_id"
}
```

**Token Characteristics:**
- **Validity**: 300 seconds (5 minutes)
- **Max length**: 2048 characters
- **Single-use**: Can only be validated once
- **Auto-expiry**: Expires automatically, cannot be reused

**Error Codes Reference:**
| Code | Meaning | Action |
|------|---------|--------|
| `missing-input-secret` | Secret not provided | Check secret config |
| `invalid-input-secret` | Secret invalid/expired | Rotate keys in dashboard |
| `missing-input-response` | Token not provided | Ensure form includes token |
| `invalid-input-response` | Token invalid/expired/malformed | User retries challenge |
| `timeout-or-duplicate` | Token already validated | Reset widget for new token |

---

## 3. Phoenix/Elixir Integration Options

### Option A: Phoenix Turnstile Library (RECOMMENDED)
**Package:** `phoenix_turnstile` v1.2.0
**GitHub:** https://github.com/jsonmaur/phoenix-turnstile
**Hex:** https://hex.pm/packages/phoenix_turnstile

**Advantages:**
- Purpose-built for Phoenix/LiveView
- Handles widget lifecycle automatically
- Easy configuration with data attributes
- Supports testing with Mox
- Event system (`:success`, `:error`, `:expired`, `:timeout`, etc.)
- Automatic token injection into forms

**Installation:**
```elixir
defp deps do
  [
    {:phoenix_turnstile, "~> 1.2"}
  ]
end
```

**Configuration in `config/runtime.exs`:**
```elixir
config :phoenix_turnstile,
  site_key: System.fetch_env!("TURNSTILE_SITE_KEY"),
  secret_key: System.fetch_env!("TURNSTILE_SECRET_KEY")
```

**Basic Usage:**
```heex
<!-- In layout (head) -->
<Turnstile.script />

<!-- In form template -->
<.form for={@form} phx-submit="submit">
  <Turnstile.widget theme="light" />
  <button type="submit">Submit</button>
</.form>
```

```elixir
# In LiveView
def handle_event("submit", values, socket) do
  case Turnstile.verify(values, socket.assigns.remote_ip) do
    {:ok, _response} ->
      # Process form
      {:noreply, socket}
    {:error, _reason} ->
      socket = socket |> put_flash(:error, "Verification failed") |> Turnstile.refresh()
      {:noreply, socket}
  end
end
```

### Option B: Manual Implementation with `:req`
**For maximum control or if not using LiveView**

```elixir
defmodule MyApp.Turnstile do
  def verify_token(token, remote_ip) do
    Req.post!("https://challenges.cloudflare.com/turnstile/v0/siteverify", 
      form: [
        secret: System.fetch_env!("TURNSTILE_SECRET_KEY"),
        response: token,
        remoteip: remote_ip
      ]
    )
    |> then(&{:ok, &1.body})
  rescue
    e -> {:error, e}
  end
end
```

---

## 4. Project Requirements Analysis

### Configuration Needs
- **Environment Variables**:
  - `TURNSTILE_SITE_KEY` (public, safe for client-side)
  - `TURNSTILE_SECRET_KEY` (private, server-only)
- **Location**: `config/runtime.exs` per AGENTS.md
- **Separate widgets for**: dev/test (uses test keys), staging, production

### Front-End Requirements
- Contact form must include Turnstile widget
- Token field auto-injected by library (`cf-turnstile-response`)
- Widget rendering: implicit (recommended) via `.cf-turnstile` class
- Responsive across mobile/desktop
- Accessibility: WCAG 2.1 AA compliant

### Back-End Requirements
- Validation in LiveView `handle_event/3`
- IP address collection from socket (`:peer_data`)
- Error handling with user-friendly messages
- All strings wrapped in `gettext()` per i18n guidelines
- Token expiration handling (reset widget after 5 mins)
- Rate limiting on failed attempts (consider)

### Testing Considerations
- Turnstile provides test sitekey/secret for dev
- Mock validation with `phoenix_turnstile` + `mox`
- Test keys don't require real Cloudflare API calls

---

## 5. HTTP Client Choice

**Decision:** Use `:req` library (Phoenix Turnstile uses it internally)
- Already in project dependencies
- Simple, ergonomic API
- Built-in timeout/retry handling
- Follows project guidelines

---

## 6. Internationalization (i18n)

### Strings to Translate
- Widget configuration labels (theme, size if customizable)
- Error messages: `gettext("Verification failed. Please try again.")`
- Error codes: `dgettext("errors", "invalid-input-response")`
- Success/failure flash messages
- Form placeholder/help text

### Testing
- Assert against `gettext()` in tests
- Run `mix gettext.extract --merge` after adding strings
- Test in multiple locales (Portuguese, English, Spanish per docs)

---

## 7. Key Technical Constraints

### Security
✅ **Server-side validation is mandatory** (not optional)
- Client-side widget alone provides no protection
- Must call Siteverify API on every form submission
- Never expose secret key in client-side code
- Secret key rotation recommended periodically

### Performance
- Token validity: 5 minutes max
- Single-use tokens (must request new after validation)
- Recommended timeout: 10 seconds for API calls
- Widget loads asynchronously, doesn't block page rendering

### Compatibility
- Works on HTTP and HTTPS only (not `file://`)
- All modern browsers supported (not IE)
- JavaScript required
- CSP headers must allow `https://challenges.cloudflare.com` (script-src + frame-src)

---

## 8. Widget Creation & Setup

### Cloudflare Dashboard Steps (HUMAN TASK)
1. Log into Cloudflare Dashboard
2. Go to Turnstile section
3. Create new site widget:
   - **Name**: "TremTec Contact Form" (or similar)
   - **Domain(s)**: Add production domain + localhost:3000 for dev
   - **Mode**: Managed (shows checkbox if suspicious)
   - **Hostname management**: Enable restricted hostnames
4. Copy **Site Key** and **Secret Key**
5. Repeat for staging/production if needed

---

## 9. Implementation Tasks

### Phase 1: Setup (HUMAN)
- [ ] Create Turnstile widget in Cloudflare Dashboard
- [ ] Obtain Site Key and Secret Key
- [ ] Document keys securely (for env var setup)

### Phase 2: Configuration (AGENT)
- [ ] Add `phoenix_turnstile` dependency to `mix.exs`
- [ ] Configure in `config/runtime.exs` with env vars
- [ ] Add env var examples to `.env.example`
- [ ] Set up hooks in `assets/app.js` (TurnstileHook)

### Phase 3: Front-End (AGENT)
- [ ] Add `<Turnstile.script />` to root layout
- [ ] Add `<Turnstile.widget />` to contact form
- [ ] Configure widget theme/size/behavior with data attributes
- [ ] Add widget events handler (`:success`, `:error`, `:expired`)
- [ ] Write CSS for responsive widget styling

### Phase 4: Back-End Validation (AGENT)
- [ ] Implement token validation in contact form LiveView
- [ ] Extract remote IP from socket `:peer_data`
- [ ] Add error handling (expired token → refresh widget)
- [ ] Implement retry logic with exponential backoff
- [ ] Add rate limiting on failed attempts (optional)
- [ ] Log validation failures securely (no secrets in logs)

### Phase 5: Internationalization (AGENT)
- [ ] Wrap all error messages in `dgettext("errors", "...")`
- [ ] Wrap UI strings in `gettext("...")`
- [ ] Run `mix gettext.extract --merge`
- [ ] Add translations to `.po` files (Portuguese, English, Spanish)
- [ ] Test in multiple locales

### Phase 6: Testing (AGENT)
- [ ] Write LiveView tests with mocked Turnstile
- [ ] Test validation success/failure paths
- [ ] Test token expiration handling
- [ ] Test IP address extraction
- [ ] Test error messages appear correctly
- [ ] Test i18n in multiple locales

### Phase 7: CSP & Security (AGENT)
- [ ] Update CSP headers to allow `challenges.cloudflare.com`
- [ ] Verify secret key never exposed in client code
- [ ] Audit logs for sensitive data leaks
- [ ] Document security best practices

### Phase 8: Documentation (HUMAN)
- [ ] Document env var setup procedure
- [ ] Add troubleshooting guide
- [ ] Document widget configuration options
- [ ] Add screenshots/examples

---

## 10. Potential Challenges & Mitigation

| Challenge | Mitigation |
|-----------|-----------|
| Token expires in 5 mins | Implement auto-reset widget on form mount, show warning before expiry |
| Network failures to Turnstile API | Implement retry logic, timeout handling, fallback messaging |
| CSP blocking widget | Pre-add `challenges.cloudflare.com` to CSP headers |
| Testing with real API | Use Mox to mock verification in tests, test keys in dev |
| Accessibility | Turnstile is WCAG 2.1 AA compliant, test with screen readers |
| Rate limiting abuse | Consider server-side rate limiting per IP after N failures |

---

## 11. Dependencies

### New Dependencies
- `phoenix_turnstile` v1.2 - Phoenix/LiveView integration

### Existing Dependencies (Already in Project)
- `:req` - HTTP client for server-side validation
- Phoenix LiveView - Form handling

### Optional (for testing)
- `mox` - For mocking Turnstile in tests

---

## 12. References

- **Cloudflare Turnstile Docs**: https://developers.cloudflare.com/turnstile/
- **Phoenix Turnstile Library**: https://github.com/jsonmaur/phoenix-turnstile
- **Siteverify API**: https://developers.cloudflare.com/turnstile/get-started/server-side-validation/
- **Widget Configuration**: https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/
- **Testing Guide**: https://developers.cloudflare.com/turnstile/troubleshooting/testing/

---

## Summary of Recommendations

1. **Use `phoenix_turnstile` library** - Purpose-built, well-maintained, reduces boilerplate
2. **Implicit rendering** - Simpler than explicit, works great with LiveView
3. **Managed widget mode** - Good balance between UX and security
4. **Use `:req` for HTTP** - Follows project standards
5. **Implement IP validation** - Optional but recommended for extra security
6. **Mock in tests** - Use test keys + Mox, avoid real API calls
7. **Localize all strings** - Use `gettext()` consistently
8. **Handle token expiry** - Reset widget on 5-minute timeout
9. **Rate limit failed attempts** - Prevent abuse, especially on contact forms
10. **Update CSP headers** - Allow `challenges.cloudflare.com` early


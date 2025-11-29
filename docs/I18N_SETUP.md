# i18n System Setup & Configuration

## Overview

This document explains how the i18n system is configured and integrated into Tremtec.

## Core Components

### 1. Gettext Backend

**File**: `lib/tremtec_web/gettext.ex`

```elixir
defmodule TremtecWeb.Gettext do
  use Gettext.Backend, otp_app: :tremtec
end
```

**Purpose**:

- Central gettext backend for the application
- Handles all translation lookups
- Manages locale-specific translations

**Configuration**:

- OTP app: `:tremtec`
- Translation files: `priv/gettext/`
- Domains: `default`, `errors`

### 2. Locale Detection Plug

**File**: `lib/tremtec_web/plug/determine_locale.ex`

**Purpose**: Runs on every HTTP request to detect and set the user's locale

**Detection Flow**:

```
Request arrives
  ↓
Check if DetermineLocale plug runs
  ↓
1. Parse Accept-Language header
   ├─ Contains supported locale → Use it
   └─ Not found/unsupported → Continue to step 2
  ↓
2. Use default locale (Portuguese)
  ↓
Set Gettext.put_locale(locale)
Set session[:locale]
Assign @locale to template
```

**Configuration in Router**:

```elixir
pipeline :browser do
  # ... other plugs ...

  plug TremtecWeb.Plug.DetermineLocale,
    supported_locales: ["pt", "en", "es"],
    default_locale: "pt",
    gettext: TremtecWeb.Gettext
end
```

**Available Options**:

- `supported_locales` - List of valid locales
- `default_locale` - Fallback if not detected
- `gettext` - Gettext backend module

### 3. Locale Helpers

**File**: `lib/tremtec_web/helpers/locale_helpers.ex`

**Available Functions**:

#### `get_locale/1`

```elixir
locale = TremtecWeb.LocaleHelpers.get_locale(conn_or_socket)
# Returns: "pt", "en", "es", or default "pt"
```

Works with both Plug.Conn and Phoenix.LiveView.Socket

#### `is_supported_locale?/1`

```elixir
TremtecWeb.LocaleHelpers.is_supported_locale?("es")
# Returns: true or false
```

#### `language_name/1`

```elixir
TremtecWeb.LocaleHelpers.language_name("es")
# Returns: "Español"
```

Used for displaying language names in UI.

#### `supported_locales/0`

```elixir
TremtecWeb.LocaleHelpers.supported_locales()
# Returns: ["pt", "en", "es"]
```

#### `default_locale/0`

```elixir
TremtecWeb.LocaleHelpers.default_locale()
# Returns: "pt"
```

### 4. Router Integration

**File**: `lib/tremtec_web/router.ex`

The DetermineLocale plug is added to the `:browser` pipeline, so it runs on all browser requests:

```elixir
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_live_flash
  plug :put_root_layout, html: {TremtecWeb.Layouts, :root}
  plug :protect_from_forgery
  plug :put_secure_browser_headers

  # Locale detection runs here
  plug TremtecWeb.Plug.DetermineLocale,
    cookie_key: "preferred_locale",
    supported_locales: ["pt", "en", "es"],
    default_locale: "pt",
    gettext: TremtecWeb.Gettext
end
```

**Result**:

- `conn` has `:locale` in session
- `@locale` available in all templates
- Gettext locale set globally for request

### 5. TremtecWeb Module

**File**: `lib/tremtec_web.ex`

In the `html_helpers` block:

```elixir
def html_helpers do
  quote do
    # ... other imports ...
    use Gettext, backend: TremtecWeb.Gettext
  end
end
```

**Result**: All templates automatically have access to `gettext()` function

## Translation Files

### Directory Structure

```
priv/gettext/
├── default.pot              # Master template (generated)
├── pt/LC_MESSAGES/          # Portuguese
│   ├── default.po           # 62 user strings
│   └── errors.po            # 24 error messages
├── en/LC_MESSAGES/          # English
│   ├── default.po           # 62 user strings
│   └── errors.po            # 24 error messages
└── es/LC_MESSAGES/          # Spanish
    ├── default.po           # 62 user strings
    └── errors.po            # 24 error messages
```

### File Format (.po files)

Example structure:

```po
#: lib/tremtec_web/live/contact_live.html.heex:4
#, elixir-autogen, elixir-format
msgid "Contact"
msgstr "Contato"

#: lib/tremtec_web/live/contact_live.html.heex:28
#, elixir-autogen, elixir-format
msgid "your@email.com"
msgstr "seu@email.com"
```

**Fields**:

- `#:` - Source file location (auto-generated)
- `#,` - Metadata flags
- `msgid` - Original English string
- `msgstr` - Translated string

### File Generation

Use `mix gettext.extract` to generate/update files:

```bash
# Extract from code and merge with existing translations
mix gettext.extract --merge
```

This command:

1. Scans code for `gettext()` calls
2. Generates/updates `default.pot`
3. Merges into language-specific `.po` files
4. Preserves existing translations
5. Marks new strings for translation

## How Translations Work

### Template Example

```heex
<h1>{gettext("Contact Form")}</h1>
```

At render time:

1. `gettext("Contact Form")` is called
2. Gettext looks up locale (from Gettext.get_locale() = "es")
3. Searches `priv/gettext/es/LC_MESSAGES/default.po`
4. Finds: `msgid "Contact Form"` → `msgstr "Formulario de Contacto"`
5. Returns: "Formulario de Contacto"

### Fallback Behavior

If translation is missing:

1. Checks if string exists in current locale file
2. If not found, returns original string (English)
3. Portuguese fallback is the source, never missing

### Error Messages

Validation errors use a separate domain:

```elixir
validate_format(email, ~r/@/)
```

When validation fails:

1. Returns error from `errors.po`
2. English: "has invalid format"
3. Portuguese: "Tem formato inválido"
4. Spanish: "Tiene formato inválido"

## Request Lifecycle

### 1. HTTP Request Arrives

```
GET /contact HTTP/1.1
Accept-Language: es-ES,es;q=0.9,en;q=0.8
Cookie: preferred_locale=es
```

### 2. DetermineLocale Plug Runs

```elixir
# Check cookie first
session[:locale] # Already has "es" from cookie
# → Skip to Gettext.put_locale("es")
```

### 3. Set Gettext Locale

```elixir
Gettext.put_locale(TremtecWeb.Gettext, "es")
# All gettext() calls in this request will use Spanish
```

### 4. Set Session

```elixir
conn |> put_session(:locale, "es")
```

### 5. Assign to Template

```elixir
conn |> assign(:locale, "es")
# @locale available in HEEx templates
```

### 6. Template Renders

```heex
{gettext("Contact")}
<!-- Looks up in es/LC_MESSAGES/default.po -->
<!-- Returns: "Contacto" -->
```

### 7. Response Sent

```
HTTP/1.1 200 OK
Set-Cookie: preferred_locale=es; Max-Age=31536000
Content-Type: text/html; charset=utf-8

<!DOCTYPE html>
<html>
  <!-- Content in Spanish -->
  <h1>Contacto</h1>
  ...
</html>
```

## LiveView Integration

In LiveViews, locale is maintained via socket assigns:

```elixir
defmodule TremtecWeb.ContactLive do
  use TremtecWeb, :live_view
  use Gettext, backend: TremtecWeb.Gettext

  def mount(_params, _session, socket) do
    # @locale from initial render is available
    locale = socket.assigns[:locale]
    {:ok, socket}
  end

  def handle_event("submit", params, socket) do
    # Gettext still uses correct locale for this request
    message = gettext("Thanks! Your message has been sent.")
    {:noreply, put_flash(socket, :info, message)}
  end
end
```

The DetermineLocale plug runs on initial load, setting `:locale` in session. LiveView socket inherits this via `Phoenix.LiveView.mount/3`.

## Testing Locale Detection

### Unit Test Plug

```elixir
test "detects Spanish from cookie" do
  conn = %Plug.Conn{}
    |> init_test_session(%{locale: "es"})
    |> TremtecWeb.Plug.DetermineLocale.call(
      supported_locales: ["pt", "en", "es"],
      default_locale: "pt"
    )

  assert get_session(conn, :locale) == "es"
end
```

### Integration Test

```elixir
test "renders in Spanish when locale is set" do
  {:ok, view, _html} = live(conn, ~p"/contact")
  # Default is Portuguese
  assert render(view) =~ "Contato"
end
```

## Modifying Supported Locales

### To Add a New Locale

1. **Update helpers**:

```elixir
# lib/tremtec_web/helpers/locale_helpers.ex
@supported_locales ["pt", "en", "es", "fr"]

def language_name(locale) do
  case locale do
    "pt" -> "Português"
    "en" -> "English"
    "es" -> "Español"
    "fr" -> "Français"  # Add this
    _ -> @default_locale
  end
end
```

2. **Update router**:

```elixir
# lib/tremtec_web/router.ex
plug TremtecWeb.Plug.DetermineLocale,
  cookie_key: "preferred_locale",
  supported_locales: ["pt", "en", "es", "fr"],  # Add "fr"
  default_locale: "pt",
  gettext: TremtecWeb.Gettext
```

3. **Create translation files**:

```bash
mkdir -p priv/gettext/fr/LC_MESSAGES
mix gettext.extract --merge
# Generates priv/gettext/fr/LC_MESSAGES/default.po and errors.po
```

4. **Add translations** to the new `.po` files

5. **Test** with new locale

See [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) for detailed instructions.

## Performance Considerations

### Minimal Overhead

- Locale detection: ~1ms (cookie/header check)
- Translation lookup: ~0.1ms (HashMap lookup in memory)
- No database queries for translations

### Translation Files

- Compiled into application at build time
- Zero runtime file I/O
- Translations in memory after `mix compile`

### Session & Cookie

- Locale stored in session (in-memory in dev)
- Cookie used for persistence (user preference)
- No extra database tables needed

## Security

### Safe Translation Strings

- Gettext strings are compile-time fixed
- No dynamic string injection
- No SQL injection risk
- Safe for untrusted locales (validated first)

### Cookie Security

- Locale cookie is non-sensitive
- No user data or tokens in cookie
- Safe to use with HTTPS
- HTTP-only flag not needed (non-sensitive)

## Debugging

### Enable Logging

```elixir
# lib/tremtec_web/plug/determine_locale.ex
# Already has Logger.info/1 calls
# Logs detected locale from header or cookie
```

### Check Current Locale

In iex:

```elixir
Gettext.get_locale(TremtecWeb.Gettext)
# Returns current locale for this process
```

### Find Missing Translations

```bash
mix gettext.extract --merge --check-format
# Identifies missing or conflicting translations
```

### View Translation File

```bash
grep -n "msgid" priv/gettext/es/LC_MESSAGES/default.po
# List all translatable strings for Spanish
```

## Related Documentation

- [I18N.md](./I18N.md) - Quick reference and common tasks
- [I18N_OVERVIEW.md](./I18N_OVERVIEW.md) - System overview
- [I18N_LOCALES.md](./I18N_LOCALES.md) - Supported languages
- [I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md) - Adding strings
- [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) - Adding languages
- [AGENTS.md](../AGENTS.md) - Code patterns and guidelines

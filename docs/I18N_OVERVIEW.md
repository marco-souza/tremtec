# i18n System Overview

## What is i18n?

Internationalization (i18n) allows your application to support multiple languages. Users see content in their preferred language based on:
- Browser language preference (Accept-Language header)
- Application default (Portuguese)

## How Tremtec Implements i18n

Tremtec uses **Gettext**, Phoenix's standard i18n framework.

### Three Levels of Implementation

#### Level 1: Core Infrastructure ✅
- Gettext backend configured
- DetermineLocale plug detects user's language
- LocaleHelpers provide utility functions
- Router integration ensures plug runs on every request

#### Level 2: String Translations ✅
- All user-facing strings wrapped in `gettext()`
- Validation errors wrapped in `dgettext("errors", ...)`
- Translation files (.po) for each language
- Supports plural forms with `ngettext()`

#### Level 3: User Experience
- Accept-Language header support
- Graceful fallback to Portuguese
- Session integration for LiveView

## Current Language Support

### Portuguese (pt) - DEFAULT
- **Region**: Brazil & Portugal
- **Status**: Complete
- **Strings**: 62 user-facing + 24 errors
- **Default**: Yes, all missing strings fallback to this

### English (en) - SECONDARY
- **Region**: United States & International
- **Status**: Complete
- **Strings**: 62 user-facing + 24 errors
- **Used for**: English-speaking users worldwide

### Spanish (es) - NEW
- **Region**: Spain & Latin America
- **Status**: Complete
- **Strings**: 62 user-facing + 24 errors
- **Used for**: Spanish-speaking users

## Where Translations Appear

### Landing Page (24 strings)
- Hero title and subtitle
- Problem section (title + 3 problems)
- Solution section (title + 3 solutions)
- CTA section (title + subtitle + button)

### Contact Form (10 strings)
- Page title
- Form labels and placeholders
- Button text
- Success message

### Admin Interface (8 strings)
- Message list headers
- Message detail view labels
- Status indicators
- Action buttons

### Layout & System (10 strings)
- Brand name (TremTec)
- Logo alt text
- Page title suffix
- Copyright notice
- Connection error messages

### Validation Errors (24 strings)
- Required field validation
- Format validation (email, etc.)
- Length validation
- Number validation
- All with proper plural forms

## Key Features

### 1. Automatic Locale Detection
```
User Request
  → Check Accept-Language header
    → Supported: Use it
    → Not supported: Use Portuguese (default)
```

### 2. Template Integration
Translations work seamlessly in HEEx templates:
```heex
<h1>{gettext("Contact")}</h1>
<.input placeholder={gettext("Your name")} />
<.button>{gettext("Send message")}</.button>
```

### 3. Error Message Localization
Validation errors automatically translated:
```elixir
# Changeset shows "Tem formato inválido" (PT) or "Has invalid format" (EN)
validate_format(email, ~r/@/)
```

### 4. Plural Forms
Proper grammatical handling of plurals:
```elixir
ngettext(
  "You have %{count} message",
  "You have %{count} messages",
  count,
  count: count
)
```

## Technical Implementation

### DetermineLocale Plug
Located at: `lib/tremtec_web/plug/determine_locale.ex`

- Runs on every HTTP request
- Detects and validates locale
- Sets Gettext backend locale
- Stores in session for LiveView
- Assigns to template as `@locale`

### LocaleHelpers Module
Located at: `lib/tremtec_web/helpers/locale_helpers.ex`

**Functions**:
- `get_locale/1` - Get current locale
- `is_supported_locale?/1` - Validate locale
- `language_name/1` - Human-readable name
- `supported_locales/0` - List all locales
- `default_locale/0` - Get default locale

### Translation Files
Located at: `priv/gettext/{locale}/LC_MESSAGES/{domain}.po`

**Domains**:
- `default.po` - User-facing strings (62 strings)
- `errors.po` - Validation messages (24 strings)

**Format**: GNU Gettext (.po files)
- `msgid` - Original string
- `msgstr` - Translated string
- Comments indicate where string is used

## Testing Translations

### Manual Testing
1. Set browser language to Spanish (or use `Accept-Language: es`)
2. Refresh page
3. Content appears in Spanish

### Automated Testing
```elixir
test "shows Spanish content" do
  {:ok, view, html} = live(conn, ~p"/contact")
  # Automatically renders in Portuguese (default)
  # To test Spanish, set locale via conn or socket
end
```

### Test Assertions
Always use `gettext()` for assertions, never hardcoded strings:
```elixir
# ✅ CORRECT
success_msg = gettext("Thanks! Your message has been sent.")
assert html =~ success_msg

# ❌ WRONG - String might be translated
assert html =~ "Thanks! Your message has been sent."
```

## Common Patterns

### In Templates
```heex
<h1>{gettext("Contact Form")}</h1>
<.input 
  label={gettext("Your Email")}
  placeholder={gettext("name@example.com")}
/>
```

### In LiveView Modules
```elixir
defmodule TremtecWeb.ContactLive do
  use TremtecWeb, :live_view
  use Gettext, backend: TremtecWeb.Gettext

  def mount(_params, _session, socket) do
    {:ok, assign(socket, message: gettext("Welcome!"))}
  end
end
```

### In Controllers
```elixir
defmodule TremtecWeb.PageController do
  use TremtecWeb, :controller
  use Gettext, backend: TremtecWeb.Gettext

  def index(conn, _params) do
    render(conn, :index, title: gettext("Welcome"))
  end
end
```

### For Error Messages
```elixir
# In validation
dgettext("errors", "can't be blank")
dgettext("errors", "has invalid format")
```

## Adding New Content

### When Adding New Strings
1. Wrap in `gettext()`:
   ```heex
   {gettext("My new feature text")}
   ```

2. Extract strings:
   ```bash
   mix gettext.extract --merge
   ```

3. Add translations to `.po` files

4. Restart server

### When Adding New Language (e.g., French)
1. Update config files
2. Create `.po` files
3. Add translations
4. Update helpers
5. Test and commit

See [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) for detailed steps.

## Architecture Decisions

### Why Gettext?
- Standard for Phoenix applications
- Well-documented and battle-tested
- Excellent plural form support
- Works with HEEx templates
- No database required

### Why Accept-Language Header?
- Respects browser settings
- Simple and stateless
- No need to manage cookies
- Standard web best practice

### Why Default to Portuguese?
- TremTec is primarily a Brazilian service
- All content is best in Portuguese first
- Easy to maintain consistency
- Natural for the development team

## Limitations & Future Work

### Current Limitations
- Brand name (TremTec) not translated (by design)
- External links (Phoenix docs, forums) remain in English
- No admin panel for locale selection yet

### Future Enhancements
- **Phase 4**: Add French (fr) and German (de)
- **Phase 5**: Locale selector in UI
- **Phase 6**: Community translation platform

## Troubleshooting

### Strings Not Translating
**Cause**: Forgot to wrap in `gettext()`
**Fix**: Add `gettext("string")` or `{gettext("string")}`

### Missing Translations
**Cause**: Didn't extract or didn't add to `.po` file
**Fix**: Run `mix gettext.extract --merge` and translate

### Tests Failing with String
**Cause**: Using hardcoded string in assertion
**Fix**: Use `gettext()` in test: `success = gettext("..."); assert html =~ success`

### Locale Changes Not Persisting
**Cause**: Locale is determined by Accept-Language header on each request
**Note**: Locale is not persisted - it's determined fresh on each request from the browser's Accept-Language header

## Related Documentation

- [AGENTS.md i18n Guidelines](../AGENTS.md) - Code patterns and best practices
- [I18N_SETUP.md](./I18N_SETUP.md) - System configuration details
- [I18N_LOCALES.md](./I18N_LOCALES.md) - Supported languages reference
- [I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md) - How to add strings
- [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) - How to add languages

## Implementation Timeline

- **Phase 1** (Completed): Core infrastructure
  - Gettext framework
  - DetermineLocale plug
  - LocaleHelpers utilities
  - Portuguese + English translations

- **Phase 2** (Completed): Brand localization
  - TremTec brand strings wrapped
  - Logo alt text localized
  - Page title suffix localized

- **Phase 3** (Completed): Spanish support
  - 62 user strings translated
  - 24 error messages translated
  - Full Spanish locale support

- **Phase 4** (Planned): Additional languages
  - French (fr) support
  - German (de) support

- **Phase 5** (Planned): UI enhancements
  - Language selector component
  - User preference persistence UI
  - Analytics dashboard

## Support

For questions or issues:
1. Check [I18N.md](./I18N.md) for quick reference
2. Review [AGENTS.md](../AGENTS.md) guidelines
3. Check implementation in `lib/tremtec_web/`
4. Search git history: `git log --grep="i18n"`

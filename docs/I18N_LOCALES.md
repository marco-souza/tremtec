# Supported Locales Reference

## Quick Reference

| Code | Language | Region | Default | Status | Strings |
|------|----------|--------|---------|--------|---------|
| pt | Português | Brazil & Portugal | ✅ Yes | Complete | 62 + 24 |
| en | English | United States & International | No | Complete | 62 + 24 |
| es | Español | Spain & Latin America | No | Complete | 62 + 24 |

## Portuguese (pt)

### Basic Information
- **Locale Code**: `pt`
- **Language**: Português (Portuguese)
- **Regions**: Brazil (pt-BR), Portugal (pt-PT)
- **Default**: Yes - all content defaults to Portuguese
- **Status**: ✅ Complete

### Characteristics
- Default fallback language
- All features in Portuguese first
- Native for development team
- Primary market language

### Usage
To set Portuguese locale:
```elixir
TremtecWeb.LocaleHelpers.set_locale(conn, "pt")
```

### Translations
- User-facing strings: 62
- Error/validation messages: 24
- Total: 86 translations

### Files
- `priv/gettext/pt/LC_MESSAGES/default.po` - User strings
- `priv/gettext/pt/LC_MESSAGES/errors.po` - Error messages

### Examples
```
"Contact" → "Contato"
"Email" → "E-mail"
"Send message" → "Enviar mensagem"
"can't be blank" → "Não pode ficar em branco"
```

### Detected Via
- Cookie: `preferred_locale=pt`
- Header: `Accept-Language: pt-BR` or `pt-PT`
- Default: Used if no preference set

## English (en)

### Basic Information
- **Locale Code**: `en`
- **Language**: English
- **Regions**: United States, United Kingdom, International
- **Default**: No
- **Status**: ✅ Complete

### Characteristics
- International business language
- Secondary to Portuguese
- Most software docs in English
- Wide international audience

### Usage
To set English locale:
```elixir
TremtecWeb.LocaleHelpers.set_locale(conn, "en")
```

### Translations
- User-facing strings: 62
- Error/validation messages: 24
- Total: 86 translations

### Files
- `priv/gettext/en/LC_MESSAGES/default.po` - User strings
- `priv/gettext/en/LC_MESSAGES/errors.po` - Error messages

### Examples
```
"Contact" → "Contact"
"Email" → "Email"
"Send message" → "Send message"
"can't be blank" → "can't be blank"
```

### Detected Via
- Cookie: `preferred_locale=en`
- Header: `Accept-Language: en-US` or `en-GB`
- Fallback: If translation missing, English is source

## Spanish (es)

### Basic Information
- **Locale Code**: `es`
- **Language**: Español (Spanish)
- **Regions**: Spain, Mexico, Central America, South America
- **Default**: No
- **Status**: ✅ Complete

### Characteristics
- Major Latin American market
- 500+ million speakers worldwide
- Growing business language
- Important for expansion

### Usage
To set Spanish locale:
```elixir
TremtecWeb.LocaleHelpers.set_locale(conn, "es")
```

### Translations
- User-facing strings: 62
- Error/validation messages: 24
- Total: 86 translations

### Files
- `priv/gettext/es/LC_MESSAGES/default.po` - User strings
- `priv/gettext/es/LC_MESSAGES/errors.po` - Error messages

### Examples
```
"Contact" → "Contacto"
"Email" → "Correo Electrónico"
"Send message" → "Enviar mensaje"
"can't be blank" → "No puede estar vacío"
```

### Detected Via
- Cookie: `preferred_locale=es`
- Header: `Accept-Language: es-ES` or `es-MX`
- Dialect: Neutral Spanish (works for all regions)

## Checking Supported Locales

### In Code
```elixir
# Get all supported locales
locales = TremtecWeb.LocaleHelpers.supported_locales()
# Returns: ["pt", "en", "es"]

# Check if specific locale is supported
TremtecWeb.LocaleHelpers.is_supported_locale?("fr")
# Returns: false

TremtecWeb.LocaleHelpers.is_supported_locale?("es")
# Returns: true
```

### In Tests
```elixir
test "all required locales are supported" do
  required = ["pt", "en", "es"]
  actual = TremtecWeb.LocaleHelpers.supported_locales()
  
  for locale <- required do
    assert locale in actual
  end
end
```

## Language Names

Get human-readable language names:

```elixir
TremtecWeb.LocaleHelpers.language_name("pt")
# Returns: "Português"

TremtecWeb.LocaleHelpers.language_name("en")
# Returns: "English"

TremtecWeb.LocaleHelpers.language_name("es")
# Returns: "Español"

TremtecWeb.LocaleHelpers.language_name("fr")
# Returns: "pt" (invalid locale returns default)
```

### Use Cases
Display language names in UI:
```heex
<div class="languages">
  <button>
    {TremtecWeb.LocaleHelpers.language_name("pt")}
  </button>
  <button>
    {TremtecWeb.LocaleHelpers.language_name("en")}
  </button>
  <button>
    {TremtecWeb.LocaleHelpers.language_name("es")}
  </button>
</div>
```

## Setting User Locale

### Via Controller
```elixir
def change_language(conn, %{"locale" => locale}) do
  conn
  |> TremtecWeb.LocaleHelpers.set_locale(locale)
  |> redirect(to: back_path(conn))
end
```

### Via LiveView
```elixir
def handle_event("change_language", %{"locale" => locale}, socket) do
  # For LiveView, manually set session
  new_socket = socket
    |> assign(:locale, locale)
    |> put_session(:locale, locale)
  
  {:noreply, new_socket}
end
```

### Via URL Parameter
```elixir
def set_locale(conn, %{"locale" => locale}) do
  conn
  |> TremtecWeb.LocaleHelpers.set_locale(locale)
  |> put_flash(:info, "Language changed")
  |> redirect(to: ~p"/")
end
```

## Locale Detection Order

The system checks locales in this order:

### 1. User's Saved Preference (Cookie)
```
Highest priority
If preferred_locale cookie exists, use it
Example: Cookie set to "es"
```

### 2. Browser's Accept-Language Header
```
Second priority
Parse header and find first supported locale
Example: Header = "es-ES,es;q=0.9,en;q=0.8"
Result: Use "es" if supported
```

### 3. Application Default
```
Lowest priority
Fall back to Portuguese
Example: Use "pt"
```

### Example Scenarios

**Scenario 1: User has preference**
```
User cookie: preferred_locale=es
Accept-Language: pt-BR
Result: Spanish (es) - cookie takes priority
```

**Scenario 2: No preference, browser says Portuguese**
```
User cookie: none
Accept-Language: pt-BR
Result: Portuguese (pt) - matches header
```

**Scenario 3: No preference, unsupported browser language**
```
User cookie: none
Accept-Language: fr-FR (French not supported)
Result: Portuguese (pt) - default fallback
```

**Scenario 4: No preference, no header**
```
User cookie: none
Accept-Language: none
Result: Portuguese (pt) - default fallback
```

## Adding New Locales

### Prerequisites
- Decide on locale code (e.g., "fr" for French)
- Determine region coverage
- Ensure translator availability

### Steps

1. **Update Helpers**:
```elixir
# lib/tremtec_web/helpers/locale_helpers.ex
@supported_locales ["pt", "en", "es", "fr"]  # Add "fr"

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

2. **Update Router**:
```elixir
# lib/tremtec_web/router.ex
plug TremtecWeb.Plug.DetermineLocale,
  cookie_key: "preferred_locale",
  supported_locales: ["pt", "en", "es", "fr"],  # Add "fr"
  default_locale: "pt",
  gettext: TremtecWeb.Gettext
```

3. **Create Directories**:
```bash
mkdir -p priv/gettext/fr/LC_MESSAGES
```

4. **Generate Template Files**:
```bash
mix gettext.extract --merge
# Creates priv/gettext/fr/LC_MESSAGES/default.po
# Creates priv/gettext/fr/LC_MESSAGES/errors.po
```

5. **Add Translations**:
- Edit `priv/gettext/fr/LC_MESSAGES/default.po`
- Edit `priv/gettext/fr/LC_MESSAGES/errors.po`
- Add all msgstr translations

6. **Test**:
```bash
mix compile
mix test
mix format
```

7. **Commit**:
```bash
git add -A
git commit -m "i18n: Add French locale support"
```

See [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) for detailed guide.

## Locale Codes (Standards)

Tremtec uses ISO 639-1 two-letter codes for locales:

```
pt - Portuguese
en - English
es - Spanish
fr - French (if added)
de - German (if added)
it - Italian (if added)
ja - Japanese (if added)
zh - Chinese (if added)
```

### Regional Variants

Some languages have variants:
```
pt-BR - Brazilian Portuguese (primary for us)
pt-PT - Portugal Portuguese
en-US - American English
en-GB - British English
es-ES - Spain Spanish
es-MX - Mexican Spanish
```

**Current Implementation**: Uses base codes (pt, en, es) without regional variant, making translations neutral and applicable to all regions.

## Translation Statistics

### Portuguese (pt)
- Landing page: 24 strings
- Contact form: 10 strings
- Admin interface: 8 strings
- System messages: 10 strings
- Error messages: 24 strings
- **Total: 86 strings**
- **Status**: 100% complete
- **Last Updated**: 2025-11-22

### English (en)
- Landing page: 24 strings
- Contact form: 10 strings
- Admin interface: 8 strings
- System messages: 10 strings
- Error messages: 24 strings
- **Total: 86 strings**
- **Status**: 100% complete
- **Last Updated**: 2025-11-22

### Spanish (es)
- Landing page: 24 strings
- Contact form: 10 strings
- Admin interface: 8 strings
- System messages: 10 strings
- Error messages: 24 strings
- **Total: 86 strings**
- **Status**: 100% complete
- **Last Updated**: 2025-11-22

### Total Coverage
```
3 locales × 86 translations = 258 translations
```

## Testing Locales

### Manual Testing
1. Open browser console
2. Set cookie: `document.cookie = "preferred_locale=es"`
3. Refresh page
4. Content should be in Spanish

### Programmatic Testing
```elixir
# In tests
test "renders in Spanish" do
  conn = 
    conn
    |> init_test_session(%{locale: "es"})
  
  {:ok, view, html} = live(conn, ~p"/contact")
  spanish_text = "Contacto"
  assert html =~ spanish_text
end
```

### Header-Based Testing
```bash
# Using curl
curl -H "Accept-Language: es-ES" http://localhost:4000/contact
# Response should contain Spanish content
```

## Troubleshooting

### Locale Not Detected
**Problem**: Page always shows Portuguese despite language preference

**Solutions**:
1. Check cookie is being set: `document.cookie`
2. Clear browser cache
3. Verify Accept-Language header: Dev Tools → Network → Headers
4. Check DetermineLocale plug is in router

### Missing Translations
**Problem**: Some strings show untranslated

**Solutions**:
1. Run `mix gettext.extract --merge`
2. Check `.po` file for untranslated msgstr
3. Verify locale code is in supported_locales
4. Rebuild: `mix compile`

### Wrong Language Displayed
**Problem**: Wrong language showing despite correct locale

**Solutions**:
1. Check Gettext.get_locale() in code
2. Verify .po file has correct translations
3. Look for hardcoded strings (not in gettext())
4. Check plural forms in errors.po

## References

- [I18N.md](./I18N.md) - Quick reference
- [I18N_OVERVIEW.md](./I18N_OVERVIEW.md) - System overview
- [I18N_SETUP.md](./I18N_SETUP.md) - Configuration details
- [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) - How to add languages
- [AGENTS.md](../AGENTS.md) - Code guidelines

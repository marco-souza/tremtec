# Adding New Locales (Languages)

This guide explains how to add support for a new language in Tremtec.

## Quick Start

To add French (fr) as an example:

```bash
# 1. Update helpers
# 2. Update router
# 3. Create directories
mkdir -p priv/gettext/fr/LC_MESSAGES

# 4. Generate templates
mix gettext.extract --merge

# 5. Translate strings in:
# priv/gettext/fr/LC_MESSAGES/default.po
# priv/gettext/fr/LC_MESSAGES/errors.po

# 6. Test and commit
mix test
mix format
git add -A
git commit -m "i18n: Add French locale support"
```

## Detailed Guide

### Step 1: Decide on Locale Code

Choose a two-letter ISO 639-1 code:

| Language | Code | Example      |
| -------- | ---- | ------------ |
| French   | fr   | fr-FR, fr-CA |
| German   | de   | de-DE, de-AT |
| Italian  | it   | it-IT        |
| Dutch    | nl   | nl-NL, nl-BE |
| Polish   | pl   | pl-PL        |
| Russian  | ru   | ru-RU        |
| Japanese | ja   | ja-JP        |
| Chinese  | zh   | zh-CN, zh-TW |

For this guide, we'll use `fr` (French).

### Step 2: Update LocaleHelpers

**File**: `lib/tremtec_web/helpers/locale_helpers.ex`

Add the new locale to the supported list:

```elixir
# BEFORE
@supported_locales ["pt", "en", "es"]

# AFTER
@supported_locales ["pt", "en", "es", "fr"]
```

Add the language name function case:

```elixir
def language_name(locale) do
  case locale do
    "pt" -> "Português"
    "en" -> "English"
    "es" -> "Español"
    "fr" -> "Français"  # ADD THIS
    _ -> @default_locale
  end
end
```

**Full Example**:

```elixir
defmodule TremtecWeb.LocaleHelpers do
  @moduledoc """
  Helper functions for managing locale/language preferences throughout the app.
  """

  import Plug.Conn

  @supported_locales ["pt", "en", "es", "fr"]  # Updated
  @default_locale "pt"
  @locale_cookie_key "preferred_locale"

  # ... other functions ...

  @doc """
  Get the language name for display purposes.
  """
  def language_name(locale) do
    case locale do
      "pt" -> "Português"
      "en" -> "English"
      "es" -> "Español"
      "fr" -> "Français"  # New
      _ -> @default_locale
    end
  end
end
```

### Step 3: Update Router

**File**: `lib/tremtec_web/router.ex`

Update the DetermineLocale plug configuration:

```elixir
# BEFORE
plug TremtecWeb.Plug.DetermineLocale,
  cookie_key: "preferred_locale",
  supported_locales: ["pt", "en", "es"],
  default_locale: "pt",
  gettext: TremtecWeb.Gettext

# AFTER
plug TremtecWeb.Plug.DetermineLocale,
  cookie_key: "preferred_locale",
  supported_locales: ["pt", "en", "es", "fr"],
  default_locale: "pt",
  gettext: TremtecWeb.Gettext
```

### Step 4: Create Locale Directories

Create the translation file directories:

```bash
mkdir -p priv/gettext/fr/LC_MESSAGES
```

This creates:

- `priv/gettext/fr/` - French locale directory
- `priv/gettext/fr/LC_MESSAGES/` - Translation files location

### Step 5: Generate Translation Templates

Use Gettext to generate the `.po` files:

```bash
mix gettext.extract --merge
```

**Output**:

```
Extracted priv/gettext/default.pot
Wrote priv/gettext/pt/LC_MESSAGES/errors.po (...)
Wrote priv/gettext/pt/LC_MESSAGES/default.po (...)
Wrote priv/gettext/en/LC_MESSAGES/errors.po (...)
Wrote priv/gettext/en/LC_MESSAGES/default.po (...)
Wrote priv/gettext/es/LC_MESSAGES/errors.po (...)
Wrote priv/gettext/es/LC_MESSAGES/default.po (...)
Wrote priv/gettext/fr/LC_MESSAGES/errors.po (24 new messages, 0 removed)
Wrote priv/gettext/fr/LC_MESSAGES/default.po (62 new messages, 0 removed)
```

This creates:

- `priv/gettext/fr/LC_MESSAGES/default.po` - User-facing strings (62)
- `priv/gettext/fr/LC_MESSAGES/errors.po` - Error messages (24)

### Step 6: Verify Files Created

Check the new files exist:

```bash
ls -la priv/gettext/fr/LC_MESSAGES/
# Output:
# default.po
# errors.po
```

View a sample:

```bash
head -30 priv/gettext/fr/LC_MESSAGES/default.po
```

### Step 7: Add Translations

Edit each `.po` file and fill in translations.

#### File 1: default.po (User Strings)

**Path**: `priv/gettext/fr/LC_MESSAGES/default.po`

**Format**:

```po
#: lib/tremtec_web/live/contact_live.html.heex:4
#, elixir-autogen, elixir-format
msgid "Contact"
msgstr ""
```

**Fill in**:

```po
#: lib/tremtec_web/live/contact_live.html.heex:4
#, elixir-autogen, elixir-format
msgid "Contact"
msgstr "Contact"
```

**Example Translations** (French):

```po
msgid "Contact"
msgstr "Contact"

msgid "Email"
msgstr "E-mail"

msgid "Send message"
msgstr "Envoyer un message"

msgid "TremTec"
msgstr "TremTec"

msgid "Thank you! Your message has been sent."
msgstr "Merci ! Votre message a été envoyé."
```

#### File 2: errors.po (Error Messages)

**Path**: `priv/gettext/fr/LC_MESSAGES/errors.po`

**Example Translations** (French):

```po
msgid "can't be blank"
msgstr "ne peut pas être vide"

msgid "has invalid format"
msgstr "a un format invalide"

msgid "has already been taken"
msgstr "est déjà utilisé"

msgid "should have at least %{count} character(s)"
msgid_plural "should have at least %{count} character(s)"
msgstr[0] "doit contenir au moins %{count} caractère"
msgstr[1] "doit contenir au moins %{count} caractères"
```

### Step 8: Tools for Translation

#### Option A: Manual Editing

Edit `.po` files directly in your editor:

```bash
vim priv/gettext/fr/LC_MESSAGES/default.po
```

#### Option B: Online Editor

Use [Poedit](https://poedit.net/) for easier editing:

1. Open `priv/gettext/fr/LC_MESSAGES/default.po`
2. Add translations via GUI
3. Save file

#### Option C: AI/Translation Service

Use online services for bulk translation:

1. Export strings from `.po` file
2. Translate via service
3. Update `.po` files

### Step 9: Compile & Test

Check for errors:

```bash
mix compile
```

Run tests:

```bash
mix test
```

If tests fail, check:

- Syntax errors in `.po` files
- Missing translations
- Invalid locale codes

### Step 10: Verify Locale Works

Test the new locale in iex:

```bash
iex -S mix phx.server
```

In another terminal:

```bash
iex> Gettext.get_locale(TremtecWeb.Gettext)
"pt"

iex> Gettext.put_locale(TremtecWeb.Gettext, "fr")
:ok

iex> Gettext.gettext(TremtecWeb.Gettext, "Contact")
"Contact"
```

Or in the browser:

1. Set cookie: `preferred_locale=fr`
2. Visit http://localhost:4000
3. Content should be in French

### Step 11: Format Code

```bash
mix format
```

### Step 12: Commit

```bash
git add -A
git commit -m "i18n: Add French locale support

- Added 'fr' to supported locales
- Created French translation files
- Translated 62 user strings
- Translated 24 error messages"
```

## Adding Multiple Locales

To add French, German, and Italian at once:

```bash
# Step 1: Create all directories
mkdir -p priv/gettext/fr/LC_MESSAGES
mkdir -p priv/gettext/de/LC_MESSAGES
mkdir -p priv/gettext/it/LC_MESSAGES

# Step 2: Update helpers (add all three)
# Edit lib/tremtec_web/helpers/locale_helpers.ex
# @supported_locales ["pt", "en", "es", "fr", "de", "it"]
# Add cases for each language

# Step 3: Update router (add all three)
# Edit lib/tremtec_web/router.ex
# supported_locales: ["pt", "en", "es", "fr", "de", "it"]

# Step 4: Generate all templates
mix gettext.extract --merge

# Step 5: Translate all three files
# priv/gettext/fr/LC_MESSAGES/default.po
# priv/gettext/de/LC_MESSAGES/default.po
# priv/gettext/it/LC_MESSAGES/default.po
# And errors.po for each

# Step 6: Test and commit
mix test
mix format
git add -A
git commit -m "i18n: Add French, German, Italian locales"
```

## Full Code Example: Adding German (de)

### Changes Summary

**1. lib/tremtec_web/helpers/locale_helpers.ex**

```elixir
@supported_locales ["pt", "en", "es", "de"]

def language_name(locale) do
  case locale do
    "pt" -> "Português"
    "en" -> "English"
    "es" -> "Español"
    "de" -> "Deutsch"
    _ -> @default_locale
  end
end
```

**2. lib/tremtec_web/router.ex**

```elixir
plug TremtecWeb.Plug.DetermineLocale,
  cookie_key: "preferred_locale",
  supported_locales: ["pt", "en", "es", "de"],
  default_locale: "pt",
  gettext: TremtecWeb.Gettext
```

**3. Create directories**

```bash
mkdir -p priv/gettext/de/LC_MESSAGES
```

**4. Generate files**

```bash
mix gettext.extract --merge
```

**5. Add translations to:**

- `priv/gettext/de/LC_MESSAGES/default.po` - 62 strings
- `priv/gettext/de/LC_MESSAGES/errors.po` - 24 errors

**6. Test & commit**

```bash
mix test && git add -A && git commit -m "i18n: Add German locale"
```

## Translation Coverage

After adding a new locale, check translation status:

```bash
# See all untranslated strings
grep -c 'msgstr ""' priv/gettext/fr/LC_MESSAGES/default.po

# Example output: 0 (all translated)
```

## Common Locale Codes

```
af - Afrikaans
ar - Arabic
cs - Czech
da - Danish
de - German
en - English
es - Spanish
fi - Finnish
fr - French
hu - Hungarian
it - Italian
ja - Japanese
ko - Korean
nl - Dutch
no - Norwegian
pl - Polish
pt - Portuguese
ru - Russian
sv - Swedish
tr - Turkish
uk - Ukrainian
zh - Chinese
```

## Tips for Adding Locales

### ✅ DO

- **Add all locales at once** if possible - easier to maintain
- **Test in all browsers** - different header parsing
- **Verify plural forms** - especially in errors.po
- **Document language variants** - de-DE vs de-AT
- **Ask native speakers** - for accuracy
- **Test RTL languages separately** - if adding Arabic, Hebrew, etc.

### ❌ DON'T

- **Don't add partial translations** - complete or skip
- **Don't mix languages in code** - keep one per file
- **Don't assume English fallback** - add translations
- **Don't forget error.po** - validation messages matter

## Removing a Locale

To remove support for a locale:

1. **Update helpers**:

```elixir
@supported_locales ["pt", "en", "es"]  # Remove "fr"

# Remove from language_name/1
```

2. **Update router**:

```elixir
supported_locales: ["pt", "en", "es"],  # Remove "fr"
```

3. **Delete translation files**:

```bash
rm -rf priv/gettext/fr
```

4. **Test and commit**:

```bash
mix test
git add -A
git commit -m "i18n: Remove French locale support"
```

## Troubleshooting

### New Locale Not Detected

**Problem**: Locale set to "fr" but shows Portuguese

**Solutions**:

1. Check you updated both helper AND router
2. Verify `mix compile` succeeded
3. Restart server
4. Check cookie is set correctly

### Empty .po Files

**Problem**: `default.po` has no strings

**Solution**: Run extraction again

```bash
mix gettext.extract --merge
```

### Plural Forms Wrong

**Problem**: Plural translations not working

**Check**: Verify correct format in errors.po

```po
# WRONG
msgstr "One item"
msgstr "Many items"

# RIGHT
msgstr[0] "One item"
msgstr[1] "Many items"
```

### Character Encoding Issues

**Problem**: Special characters show as ???

**Solution**: Ensure files are UTF-8

```bash
file priv/gettext/fr/LC_MESSAGES/default.po
# Should show: UTF-8 Unicode text
```

## References

- [I18N.md](./I18N.md) - Quick reference
- [I18N_OVERVIEW.md](./I18N_OVERVIEW.md) - System overview
- [I18N_SETUP.md](./I18N_SETUP.md) - Configuration details
- [I18N_LOCALES.md](./I18N_LOCALES.md) - Supported languages
- [I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md) - Add strings
- [Gettext Docs](https://hexdocs.pm/gettext)
- [AGENTS.md](../AGENTS.md) - Code guidelines

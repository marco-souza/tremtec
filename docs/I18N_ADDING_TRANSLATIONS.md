# Adding New Translations

This guide explains how to add new translatable strings to Tremtec.

## Quick Start

1. Wrap string in `gettext()`:

   ```heex
   {gettext("My new text")}
   ```

2. Extract strings:

   ```bash
   mix gettext.extract --merge
   ```

3. Add translations to `.po` files

4. Restart server

5. Done!

## Step-by-Step Guide

### Step 1: Identify Where to Add String

Find the file where you want to add the translatable string:

**Examples**:

- Template: `lib/tremtec_web/live/my_live.html.heex`
- LiveView module: `lib/tremtec_web/live/my_live.ex`
- Controller: `lib/tremtec_web/controllers/my_controller.ex`
- Component: `lib/tremtec_web/components/my_component.ex`

### Step 2: Wrap String in gettext()

#### In Templates (HEEx)

**Single line**:

```heex
<h1>{gettext("Welcome to My Page")}</h1>
```

**In attributes**:

```heex
<.input placeholder={gettext("Enter your name")} />
```

**In component props**:

```heex
<.button phx-disable-with={gettext("Loading...")}>
  {gettext("Submit")}
</.button>
```

**Multiple strings**:

```heex
<div>
  <h1>{gettext("Title")}</h1>
  <p>{gettext("Description")}</p>
  <.button>{gettext("Action")}</.button>
</div>
```

#### In Elixir Code

**In LiveView**:

```elixir
defmodule TremtecWeb.MyLive do
  use TremtecWeb, :live_view
  use Gettext, backend: TremtecWeb.Gettext  # Add this!

  def mount(_params, _session, socket) do
    message = gettext("Welcome!")
    {:ok, assign(socket, message: message)}
  end
end
```

**In Controller**:

```elixir
defmodule TremtecWeb.MyController do
  use TremtecWeb, :controller
  use Gettext, backend: TremtecWeb.Gettext  # Add this!

  def action(conn, _params) do
    flash_msg = gettext("Action completed!")
    put_flash(conn, :info, flash_msg)
  end
end
```

**In Module/Helper**:

```elixir
defmodule MyApp.Helper do
  use Gettext, backend: TremtecWeb.Gettext

  def format_message do
    gettext("Hello, world!")
  end
end
```

**For Error Messages** (use dgettext):

```elixir
# In validation
error = dgettext("errors", "can't be blank")

# In handler
message = dgettext("errors", "Invalid email format")
```

### Step 3: Extract Strings

Run the extraction command to find all new strings:

```bash
cd /path/to/tremtec
mix gettext.extract --merge
```

**Output**:

```
Extracted priv/gettext/default.pot
Wrote priv/gettext/pt/LC_MESSAGES/errors.po (0 new, 0 removed, 24 unchanged)
Wrote priv/gettext/pt/LC_MESSAGES/default.po (1 new, 0 removed, 62 unchanged)
Wrote priv/gettext/en/LC_MESSAGES/errors.po (0 new, 0 removed, 24 unchanged)
Wrote priv/gettext/en/LC_MESSAGES/default.po (1 new, 0 removed, 62 unchanged)
Wrote priv/gettext/es/LC_MESSAGES/errors.po (0 new, 0 removed, 24 unchanged)
Wrote priv/gettext/es/LC_MESSAGES/default.po (1 new, 0 removed, 62 unchanged)
```

This updates all `.po` files with the new strings.

### Step 4: View New Strings

Check what was added:

```bash
# View in Portuguese file
grep -A 3 "msgid \"My new text\"" priv/gettext/pt/LC_MESSAGES/default.po

# Result:
# #: lib/tremtec_web/live/my_live.html.heex:15
# #, elixir-autogen, elixir-format
# msgid "My new text"
# msgstr ""
```

The `msgstr ""` means it needs translation.

### Step 5: Add Translations

Open each `.po` file and add translations:

#### Portuguese Translation

Edit: `priv/gettext/pt/LC_MESSAGES/default.po`

Find the new entry:

```po
#: lib/tremtec_web/live/my_live.html.heex:15
#, elixir-autogen, elixir-format
msgid "My new text"
msgstr ""
```

Add the translation:

```po
#: lib/tremtec_web/live/my_live.html.heex:15
#, elixir-autogen, elixir-format
msgid "My new text"
msgstr "Meu novo texto"
```

#### English Translation

Edit: `priv/gettext/en/LC_MESSAGES/default.po`

English usually matches the source:

```po
#: lib/tremtec_web/live/my_live.html.heex:15
#, elixir-autogen, elixir-format
msgid "My new text"
msgstr "My new text"
```

#### Spanish Translation

Edit: `priv/gettext/es/LC_MESSAGES/default.po`

```po
#: lib/tremtec_web/live/my_live.html.heex:15
#, elixir-autogen, elixir-format
msgid "My new text"
msgstr "Mi nuevo texto"
```

### Step 6: Test

Restart the server and test each language:

**Test Portuguese** (default):

```bash
iex -S mix phx.server
```

Visit http://localhost:4000 - should show "Meu novo texto"

**Test English**:
Set cookie: `preferred_locale=en`
Refresh - should show "My new text"

**Test Spanish**:
Set cookie: `preferred_locale=es`
Refresh - should show "Mi nuevo texto"

### Step 7: Format and Commit

Format the code:

```bash
mix format
```

Commit your changes:

```bash
git add -A
git commit -m "feat: Add new feature with i18n support

- Added 'My new text' with translations
- Supports Portuguese, English, Spanish"
```

## Common Patterns

### Form Labels

```heex
<.input
  field={@form[:email]}
  label={gettext("Email Address")}
  placeholder={gettext("name@example.com")}
/>
```

### Buttons

```heex
<.button type="submit" phx-disable-with={gettext("Saving...")}>
  {gettext("Save Changes")}
</.button>
```

### Flash Messages

```elixir
message = gettext("Profile updated successfully!")
put_flash(conn, :info, message)
```

### Error Messages

```elixir
# Validation errors
dgettext("errors", "can't be blank")
dgettext("errors", "has invalid format")
```

### Plural Forms

For strings with counts:

```heex
{ngettext(
  "You have 1 message",
  "You have %{count} messages",
  @message_count,
  count: @message_count
)}
```

In Portuguese:

```po
msgid "You have 1 message"
msgid_plural "You have %{count} messages"
msgstr[0] "Você tem 1 mensagem"
msgstr[1] "Você tem %{count} mensagens"
```

## Tips & Best Practices

### ✅ DO

- **Wrap all user-facing text** in `gettext()`
- **Use descriptive strings** - context helps translators
- **Group related strings** - similar functions near each other
- **Test in all languages** - before committing
- **Use singular form** - for strings with counts, gettext handles plural
- **Keep strings concise** - easier to translate

### ❌ DON'T

- **Don't translate logging** - use English for logs
- **Don't hardcode strings** - always use gettext()
- **Don't split sentences** - translators need context
- **Don't add HTML** - keep it in template, just translate text
- **Don't use string interpolation** - use `%{var}` for variables

### Example: Good String

```heex
<!-- ✅ GOOD: Translator has context -->
{gettext("Send message")}

<!-- ❌ BAD: Ambiguous -->
{gettext("Send")}

<!-- ❌ BAD: Split sentences -->
{gettext("Click the")} <.link>{gettext("button")}</.link>
```

### Example: Variables

```heex
<!-- ✅ GOOD: Use template variables -->
{gettext("Welcome, %{name}!", name: @user.name)}

<!-- ❌ BAD: String concatenation -->
{gettext("Welcome, ") <> @user.name}
```

## Updating Existing Strings

### If You Need to Change a String

**Option 1: Minor Edit** (typo fix)

```po
# Before
msgid "Snd message"
msgstr "Enviar mensagen"

# After
msgid "Send message"
msgstr "Enviar mensagem"
```

Run `mix gettext.extract --merge` - it updates all files.

**Option 2: Complete Rewrite** (change meaning)

1. Remove old string from `.po` files
2. Add new string using `gettext()`
3. Run `mix gettext.extract --merge`
4. Add new translations

### If String is Used Multiple Places

**Reuse, don't duplicate**:

```heex
<!-- ✅ GOOD: Reuse same string -->
<button>{gettext("Send")}</button>
<span>{gettext("Send")}</span>

<!-- ❌ BAD: Different strings, same meaning -->
<button>{gettext("Send")}</button>
<span>{gettext("Transmit")}</span>
```

## Validation Errors

Validation errors use the `errors` domain:

```elixir
# In schema or changeset
field :email, :string do
  validate_format(~r/@/)  # Error key in errors.po
end
```

When validation fails, Gettext looks in `errors.po`:

```po
# priv/gettext/pt/LC_MESSAGES/errors.po
msgid "has invalid format"
msgstr "Tem formato inválido"
```

### Common Validation Strings

```
"can't be blank"
"has invalid format"
"has already been taken"
"is invalid"
"should have at least X character(s)"
```

These are already in `errors.po` for all locales.

## Checking Translation Status

### See all untranslated strings

```bash
grep -n 'msgstr ""' priv/gettext/es/LC_MESSAGES/default.po
```

### Count translations

```bash
echo "Portuguese:"
grep "^msgstr" priv/gettext/pt/LC_MESSAGES/default.po | wc -l

echo "English:"
grep "^msgstr" priv/gettext/en/LC_MESSAGES/default.po | wc -l

echo "Spanish:"
grep "^msgstr" priv/gettext/es/LC_MESSAGES/default.po | wc -l
```

### Verify no empty translations

```bash
grep -c 'msgstr ""' priv/gettext/pt/LC_MESSAGES/default.po
# Should output: 0
```

## Workflow Summary

```
1. Add gettext() to code
   ↓
2. mix gettext.extract --merge
   ↓
3. Edit .po files and add msgstr
   ↓
4. Test in all languages
   ↓
5. mix format
   ↓
6. git commit
```

## Troubleshooting

### String Not Appearing Translated

**Check**:

1. Did you run `mix gettext.extract --merge`?
2. Is msgstr filled in (not empty)?
3. Did you restart the server?
4. Is the correct locale set?

```bash
# Verify string exists
grep "My new text" priv/gettext/pt/LC_MESSAGES/default.po
```

### Too Many Untranslated Strings

**Solution**: Run extraction and fill in immediately

```bash
mix gettext.extract --merge
grep 'msgstr ""' priv/gettext/es/LC_MESSAGES/default.po | wc -l
# Fix any found
```

### Merge Conflicts in .po Files

**Solution**: Keep both, extract again

```bash
# Resolve conflicts manually, then:
mix gettext.extract --merge
```

## Tools

### Editor Plugins

- VS Code: Gettext extension
- Vim: po.vim syntax
- Emacs: po-mode

### Command Line

```bash
# Extract only (don't merge)
mix gettext.extract

# Merge with existing
mix gettext.extract --merge

# Check for issues
mix gettext.extract --check-format

# Find untranslated
grep 'msgstr ""' priv/gettext/*/LC_MESSAGES/*.po

# Count strings
find priv/gettext -name "*.po" -exec grep -c "^msgid" {} \;
```

## References

- [I18N.md](./I18N.md) - Quick reference
- [I18N_SETUP.md](./I18N_SETUP.md) - System setup
- [I18N_LOCALES.md](./I18N_LOCALES.md) - Supported languages
- [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) - Add new languages
- [Gettext Docs](https://hexdocs.pm/gettext)
- [AGENTS.md](../AGENTS.md) - Code guidelines

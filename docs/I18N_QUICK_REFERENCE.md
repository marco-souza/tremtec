# I18N Quick Reference Guide

**Quick lookup for common i18n patterns in Tremtec**

---

## 1. Basic String Translation

### In Templates (HEEx)
```heex
<!-- Simple string -->
<h1>{gettext("Welcome")}</h1>

<!-- With variable -->
<p>{gettext("Hello,")} {user.name}</p>

<!-- In attributes -->
<.input placeholder={gettext("Enter email")} />
<button>{gettext("Save Changes")}</button>
```

### In Elixir Code
```elixir
defmodule MyLiveView do
  def render(assigns) do
    ~H"""
    <div>{gettext("Page Title")}</div>
    """
  end
  
  def handle_event("action", _params, socket) do
    message = gettext("Action completed successfully")
    {:noreply, put_flash(socket, :info, message)}
  end
end
```

---

## 2. Error Messages

### Validation Errors
```elixir
# In a changeset
def validate_email(changeset) do
  validate_format(
    changeset,
    :email,
    ~r/@/,
    message: dgettext("errors", "has invalid format")
  )
end

# In tests
test "validates email format" do
  error = dgettext("errors", "has invalid format")
  assert form_errors =~ error
end
```

### Available Error Messages
See `priv/gettext/{locale}/LC_MESSAGES/errors.po` for all available error messages:
- `"can't be blank"`
- `"has already been taken"`
- `"has invalid format"`
- `"must be accepted"`
- And 20+ more Ecto-generated messages

---

## 3. Pluralization

### Variable Count (ngettext)
```elixir
# Count items
count = 5
message = ngettext(
  "%{count} item",
  "%{count} items", 
  count,
  count: count
)
# Returns: "5 items"

# Time formatting (see dashboard_live.ex for example)
minutes = 3
ngettext(
  "%{count} minute ago",
  "%{count} minutes ago",
  minutes,
  count: minutes
)
# Returns: "3 minutes ago"
```

### Translation Pattern
```po
#: lib/myfile.ex:10
#, elixir-autogen, elixir-format
msgid "%{count} item"
msgid_plural "%{count} items"
msgstr[0] "1 item singular form"
msgstr[1] "Multiple items plural form"
```

---

## 4. String Extraction & Translation

### Workflow
```bash
# 1. Write code with gettext()
# (see templates/views above)

# 2. Extract strings
mix gettext.extract --merge

# 3. Find the file in priv/gettext/{locale}/LC_MESSAGES/
# Example: priv/gettext/pt/LC_MESSAGES/default.po

# 4. Add translation
# Before:
# #: lib/myfile.ex:10
# msgid "Welcome"
# msgstr ""

# After:
# #: lib/myfile.ex:10
# msgid "Welcome"
# msgstr "Bem-vindo"

# 5. Test: visit the app in different locales
```

### File Locations
- Portuguese: `priv/gettext/pt/LC_MESSAGES/default.po`
- English: `priv/gettext/en/LC_MESSAGES/default.po`
- Spanish: `priv/gettext/es/LC_MESSAGES/default.po`

---

## 5. Testing with Translations

### Test File Setup
```elixir
defmodule MyTest do
  use TremtecWeb.ConnCase
  import Phoenix.LiveViewTest
  
  # Required: Import Gettext
  use Gettext, backend: TremtecWeb.Gettext

  test "shows translated message" do
    # Use gettext() in assertions
    success_msg = gettext("Thanks! Your message has been sent.")
    
    {:ok, _lv, html} = live(conn, ~p"/contact")
    assert html =~ success_msg  # ✅ Correct
  end
  
  test "validates email format" do
    # Use dgettext() for error messages
    error_msg = dgettext("errors", "has invalid format")
    
    # ... test code ...
    assert form_errors =~ error_msg  # ✅ Correct
  end
end
```

### Common Assertion Patterns
```elixir
# ✅ Correct
assert html =~ gettext("Admin Dashboard")

# ❌ Wrong
assert html =~ "Admin Dashboard"

# ✅ Correct
error_msg = dgettext("errors", "can't be blank")
assert form =~ error_msg

# ❌ Wrong
assert form =~ "can't be blank"
```

---

## 6. Admin Interface Examples

### Dashboard (dashboard_live.ex)
```heex
<h1>{gettext("Admin Dashboard")}</h1>

<.stat_card
  title={gettext("Total Users")}
  value={@total_users}
/>
```

### Navigation (admin_sidebar.ex)
```heex
<.nav_link href={~p"/admin/dashboard"} icon="hero-home">
  {gettext("Dashboard")}
</.nav_link>

<.link method="delete" href={~p"/admin/log-out"}>
  {gettext("Logout")}
</.link>
```

### Messages Page (messages_live/index_live.ex)
```heex
<h1>{gettext("Contact Messages")}</h1>
<.input placeholder={gettext("Search by name or email")} />
```

---

## 7. Relative Time Formatting

### Pattern (from dashboard_live.ex)
```elixir
defp format_relative_time(date) do
  now = DateTime.utc_now()
  diff_seconds = DateTime.diff(now, date, :second)

  cond do
    diff_seconds < 60 ->
      gettext("Just now")
    
    diff_seconds < 3600 ->
      minutes = div(diff_seconds, 60)
      ngettext(
        "%{count} minute ago",
        "%{count} minutes ago",
        minutes,
        count: minutes
      )
    
    # ... more cases
  end
end
```

### Supported Time Formats
- "Just now"
- "%{count} minute(s) ago"
- "%{count} hour(s) ago"
- "%{count} day(s) ago"
- "%{count} week(s) ago"

---

## 8. Component Context

### For Components Using gettext
```elixir
defmodule MyComponent do
  use TremtecWeb, :html
  # ✅ Automatically has access to gettext()
  # because core_components.ex includes: use Gettext, backend: TremtecWeb.Gettext

  def my_component(assigns) do
    ~H"""
    <p>{gettext("This works!")}</p>
    """
  end
end
```

---

## 9. Locale Detection & Switching

### Get Current Locale
```elixir
# In LiveView or Controller
locale = TremtecWeb.LocaleHelpers.get_locale(socket_or_conn)
```

### Set User's Preferred Locale
```elixir
# In a LiveView event
def handle_event("set_locale", %{"locale" => locale}, socket) do
  TremtecWeb.LocaleHelpers.set_locale(socket, locale)
  {:noreply, socket}
end
```

### Supported Locales
- `"pt"` - Portuguese (default)
- `"en"` - English
- `"es"` - Spanish

---

## 10. Common Issues & Solutions

### Issue: String not translating
```
Problem: String appears in English even in other locales

Solution:
1. Did you use gettext()? ✅
2. Did you run mix gettext.extract --merge? ✅
3. Is the translation in the .po file? ✅
4. Is msgstr empty? Add the translation
5. Restart the server? Try that
```

### Issue: Test fails with message comparison
```
Problem: assert html =~ "Some message" fails

Solution: 
Use gettext() in your assertion:
assert html =~ gettext("Some message")
```

### Issue: Pluralization not working
```
Problem: Always shows singular form

Solution:
Use ngettext(), not gettext():
ngettext("1 item", "%{count} items", count, count: count)
           ↑ singular        ↑ plural       ↑ condition ↑ context
```

---

## 11. Translation Status

### Current Coverage
| Locale | User Strings | Error Messages | Status |
|--------|------|--------|--------|
| Portuguese | 142 | 24 | ✅ Complete |
| English | 142 | 24 | ✅ Complete |
| Spanish | 142 | 24 | ✅ Complete |

### How to Check
```bash
# Count translations in Portuguese
grep -c "^msgid \"" priv/gettext/pt/LC_MESSAGES/default.po
# Output: 142

# Check for untranslated strings (empty msgstr)
grep -B1 "^msgstr \"\"$" priv/gettext/pt/LC_MESSAGES/default.po
```

---

## 12. Best Practices Checklist

When adding a new feature:

- [ ] Wrapped all user-facing strings in `gettext()`
- [ ] Used `dgettext("errors", "...")` for validation messages
- [ ] Used `ngettext()` for variable counts
- [ ] Ran `mix gettext.extract --merge`
- [ ] Translated strings in all supported locales
- [ ] Updated tests to use `gettext()` in assertions
- [ ] Added `use Gettext, backend: TremtecWeb.Gettext` to test files
- [ ] Tested in different locales (pt, en, es)
- [ ] Didn't manually edit msgids in .po files
- [ ] Company name "TremTec" NOT translated

---

## Quick Commands

```bash
# Extract new strings
mix gettext.extract --merge

# Run tests with i18n assertions
mix test test/tremtec_web/

# Check for hardcoded strings (anti-pattern)
grep -r "\"[A-Z][a-z].*\"" lib/tremtec_web/live --include="*.ex" --include="*.heex"

# Count total translations
grep -c "^msgid \"" priv/gettext/*/LC_MESSAGES/default.po
```

---

## References

- **Full Documentation**: `docs/I18N.md`
- **Audit Report**: `I18N_AUDIT_REPORT.md`
- **Guidelines**: `AGENTS.md` (i18n section)
- **Gettext Docs**: https://hexdocs.pm/gettext/

---

**Last Updated**: 2025-12-01  
**Status**: ✅ Up-to-date and verified

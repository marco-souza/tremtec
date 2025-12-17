# Tremtec Documentation

This directory contains comprehensive documentation for Tremtec's features and systems.

## Internationalization (i18n)

Complete documentation for the i18n system supporting Portuguese, English, and Spanish.

### Quick Navigation

| Document                                                         | Purpose                        | Audience                 |
| ---------------------------------------------------------------- | ------------------------------ | ------------------------ |
| **[I18N.md](./I18N.md)**                                         | Overview & quick reference     | Everyone                 |
| **[I18N_OVERVIEW.md](./I18N_OVERVIEW.md)**                       | How the system works           | Developers & Maintainers |
| **[I18N_SETUP.md](./I18N_SETUP.md)**                             | Configuration & infrastructure | Developers               |
| **[I18N_LOCALES.md](./I18N_LOCALES.md)**                         | Supported languages reference  | Everyone                 |
| **[I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md)** | How to add new strings         | Content Managers         |
| **[I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md)**           | How to add new languages       | Developers               |

### What is i18n?

Internationalization (i18n) enables Tremtec to support multiple languages. Users see content in their preferred language based on:

- Browser language preference
- Saved user preference (cookie)
- Application default (Portuguese)

### Current Support

✅ **Portuguese (pt)** - Default  
✅ **English (en)** - Full support  
✅ **Spanish (es)** - Full support

### Start Here

- **First time?** → Read [I18N.md](./I18N.md)
- **Adding translations?** → Read [I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md)
- **Adding a language?** → Read [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md)
- **Want details?** → Read [I18N_SETUP.md](./I18N_SETUP.md)

## Quick Commands

### Extract new strings

```bash
mix gettext.extract --merge
```

### Test i18n

```bash
mix test
```

### Check format

```bash
mix format
```

## Key Files

**Core Infrastructure** (inside `apps/tremtec/`):

- `apps/tremtec/lib/tremtec_web/plug/determine_locale.ex` - Locale detection
- `apps/tremtec/lib/tremtec_web/helpers/locale_helpers.ex` - Locale utilities
- `apps/tremtec/lib/tremtec_web/gettext.ex` - Gettext configuration

**Translation Files** (inside `apps/tremtec/`):

- `apps/tremtec/priv/gettext/pt/LC_MESSAGES/` - Portuguese translations
- `apps/tremtec/priv/gettext/en/LC_MESSAGES/` - English translations
- `apps/tremtec/priv/gettext/es/LC_MESSAGES/` - Spanish translations

## Documentation Index

### Development Process

- [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md) - Three-phase spec-driven development workflow

### Internationalization

- [I18N.md](./I18N.md) - Quick start & reference
- [I18N_OVERVIEW.md](./I18N_OVERVIEW.md) - System overview
- [I18N_SETUP.md](./I18N_SETUP.md) - Setup & configuration
- [I18N_LOCALES.md](./I18N_LOCALES.md) - Supported languages
- [I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md) - Add strings
- [I18N_ADDING_LOCALES.md](./I18N_ADDING_LOCALES.md) - Add languages

## Best Practices

### Code

- Always wrap user-facing strings in `gettext()`
- Use `dgettext("errors", "...")` for validation messages
- Test in all supported languages

### Translations

- Keep strings concise and context-aware
- Use proper plural forms with `ngettext()`
- Translate consistently across all languages

### Commits

- One feature per commit
- Include translation counts in message
- Reference documentation in comments

## Implementation Status

✅ **Phase 1** - Core infrastructure  
✅ **Phase 2** - Brand name localization  
✅ **Phase 3** - Spanish language support  
✅ **Phase 4** - CI/CD Pipelines (GitHub Actions)  
⏳ **Phase 5** - Additional languages (French, German)  
⏳ **Phase 6** - UI language selector

## Related Documentation

- **[AGENTS.md](../AGENTS.md)** - Development guidelines & code patterns
- **[README.md](../README.md)** - Project overview
- **[SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md)** - Three-phase development workflow
- **[PRODUCTION_DEPLOYMENT.md](./PRODUCTION_DEPLOYMENT.md)** - Deployment guide & CI/CD

## Troubleshooting

### Strings not translating?

1. Check string is wrapped in `gettext()`
2. Run `mix gettext.extract --merge`
3. Verify translation is in `.po` file
4. Restart server

### Locale not detected?

1. Check cookie is being set
2. Verify locale in `supported_locales`
3. Check DetermineLocale plug in router

### Tests failing?

1. Use `gettext()` in test assertions
2. Never use hardcoded strings
3. Verify all locales have translations

See [I18N_ADDING_TRANSLATIONS.md](./I18N_ADDING_TRANSLATIONS.md#troubleshooting) for more help.

## Contributing

When adding new features:

1. **Wrap strings in gettext()**

   ```heex
   {gettext("My text")}
   ```

2. **Extract translations**

   ```bash
   mix gettext.extract --merge
   ```

3. **Add translations** to `.po` files

4. **Test**

   ```bash
   mix test
   mix format
   ```

5. **Commit**
   ```bash
   git add -A
   git commit -m "feature: Add feature with i18n support"
   ```

## Support

For questions:

1. Check [I18N.md](./I18N.md) for quick answers
2. Read specific guide for detailed help
3. Check [AGENTS.md](../AGENTS.md) for code patterns
4. Search git history: `git log --grep="i18n"`

## License

See [LICENSE](../LICENSE) file in project root.

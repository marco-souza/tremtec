# Tremtec

A Phoenix web application.

## Features

- 🌍 **Internationalization (i18n)**: Full support for Portuguese, English, and Spanish
- 📱 **Responsive Design**: Mobile-first UI with Tailwind CSS
- ⚡ **Real-time Communication**: Phoenix LiveView for interactive features
- 🔐 **Admin Dashboard**: Secure admin interface with basic auth
- 📧 **Contact Form**: Fully localized contact form with spam detection

## Development

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Documentation

Comprehensive documentation available in the `docs/` directory:

### Internationalization (i18n)
- **[docs/README.md](./docs/README.md)** - Documentation index
- **[docs/I18N.md](./docs/I18N.md)** - Quick reference and overview
- **[docs/I18N_OVERVIEW.md](./docs/I18N_OVERVIEW.md)** - How the system works
- **[docs/I18N_SETUP.md](./docs/I18N_SETUP.md)** - Configuration details
- **[docs/I18N_LOCALES.md](./docs/I18N_LOCALES.md)** - Supported languages
- **[docs/I18N_ADDING_TRANSLATIONS.md](./docs/I18N_ADDING_TRANSLATIONS.md)** - How to add strings
- **[docs/I18N_ADDING_LOCALES.md](./docs/I18N_ADDING_LOCALES.md)** - How to add languages

### Guidelines
- **[AGENTS.md](./AGENTS.md)** - Development guidelines and code patterns

## Configuration

The application uses environment variables for runtime configuration. Key variables:

### All Environments
- `ADMIN_USER`: Admin username for basic auth (default: `admin`)
- `ADMIN_PASS`: Admin password for basic auth (default: `admin`)
- `LIVE_VIEW_SIGNING_SALT`: Signing salt for LiveView (default in dev: `MkHmw9im`, required in prod)

### Production
- `DATABASE_PATH`: Path to SQLite database file (default: `/data/tremtec.db`)
- `SECRET_KEY_BASE`: Secret key for session encryption (required)
- `PHX_HOST`: Hostname for production (default: `example.com`)
- `PORT`: Port to bind (default: `4000`)
- `POOL_SIZE`: Ecto connection pool size (default: `5`)
- `DNS_CLUSTER_QUERY`: DNS cluster query for distributed setup (optional)

Generate secrets with `mix phx.gen.secret` (for `SECRET_KEY_BASE`) or `mix phx.gen.secret 32` (for `LIVE_VIEW_SIGNING_SALT`).

## Docker

Build and run with Docker:

```bash
# Build the image
docker build -t tremtec .

# Run the container
docker run -p 4000:4000 \
  -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
  -e LIVE_VIEW_SIGNING_SALT=$(mix phx.gen.secret 32) \
  -e PHX_SERVER=true \
  tremtec
```

For persistent data, mount a volume: `-v $(pwd)/data:/data`

## Deployment

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

This app is configured for deployment on Fly.io with persistent SQLite storage.

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

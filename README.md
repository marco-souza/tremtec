# Tremtec

A Phoenix web application using an umbrella project structure.

## Project Structure

This is an umbrella project containing multiple Phoenix applications:

- `apps/tremtec/` - Main Tremtec application
- `apps/tremtec_shared/` - Shared components and utilities for all apps

### Working with the Umbrella

Most development commands should be run from the project root:

```bash
# Start the server
mix phx.server

# Run tests
mix test

# Run migrations
mix ecto.migrate

# Compile all apps
mix compile

# Run precommit checks
mix precommit
```

You can also run commands directly inside `apps/tremtec/`:

```bash
cd apps/tremtec
mix phx.server
mix test
```

## Features

- 🌍 **Internationalization (i18n)**: Full support for Portuguese, English, and Spanish
- 📱 **Responsive Design**: Mobile-first UI with Tailwind CSS
- ⚡ **Real-time Communication**: Phoenix LiveView for interactive features
- 🔐 **Admin Dashboard**: Secure admin interface with basic auth
- 📧 **Contact Form**: Fully localized contact form with spam detection and CAPTCHA
- 🛡️ **Bot Protection**: Cloudflare Turnstile CAPTCHA on contact form

## Development

To start your Phoenix server:

- Run `mix setup` to install and setup dependencies
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

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

### Bot Protection & Security

- **[docs/TURNSTILE_SETUP.md](./docs/TURNSTILE_SETUP.md)** - Cloudflare Turnstile CAPTCHA setup guide

### Guidelines

- **[AGENTS.md](./AGENTS.md)** - Development guidelines and code patterns

## Configuration

The application uses environment variables for runtime configuration. Key variables:

### All Environments

- `RESEND_API_KEY`: Resend API key for email delivery (optional in dev, required in prod)
- `SMTP_FROM_EMAIL`: Email "from" address (optional, defaults to `noreply@tremtec.com`)
- `LIVE_VIEW_SIGNING_SALT`: Signing salt for LiveView (default in dev: `MkHmw9im`, required in prod)
- `TURNSTILE_SITE_KEY`: Cloudflare Turnstile public key (required for contact form)
- `TURNSTILE_SECRET_KEY`: Cloudflare Turnstile private key (required for contact form)

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
# Build the image (specify APP_NAME for the target app)
docker build --build-arg APP_NAME=tremtec -t tremtec .

# Run the container
docker run -p 4000:4000 \
  -e SECRET_KEY_BASE=$(mix phx.gen.secret) \
  -e LIVE_VIEW_SIGNING_SALT=$(mix phx.gen.secret 32) \
  -e PHX_SERVER=true \
  tremtec
```

For persistent data, mount a volume: `-v $(pwd)/data:/data`

## Deployment

This umbrella project supports deploying each Phoenix app independently to Fly.io.

### Fly.io Deployment

Each deployable app has its own `fly.toml` inside its directory:

```bash
# Deploy the tremtec app
cd apps/tremtec
fly deploy

# Set secrets for the app
fly secrets set SECRET_KEY_BASE='your-key'
fly secrets set RESEND_API_KEY='your-resend-api-key'
```

The Dockerfile at the root accepts an `APP_NAME` build argument, which is configured in each app's `fly.toml`.

### Adding New Deployable Apps

When adding a new Phoenix app to the umbrella:

1. Create the app: `cd apps && mix phx.new my_app`
2. Create `apps/my_app/fly.toml` with:

   ```toml
   app = 'my-app-name'
   primary_region = 'gru'

   [build]
     dockerfile = "../../Dockerfile"
     [build.args]
       APP_NAME = "my_app"
   ```

3. Deploy: `cd apps/my_app && fly deploy`

For more details, see [docs/PRODUCTION_DEPLOYMENT.md](./docs/PRODUCTION_DEPLOYMENT.md).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix

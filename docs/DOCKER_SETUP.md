# Docker Setup Guide

This guide explains how to use Docker for both development and production environments in TremTec.

## Overview

The project uses Docker Compose with two distinct configurations:
- **Development** - Local development with hot reload
- **Production** - Optimized release build

## Configuration

### Files

- `docker-compose.yml` - Main Docker Compose configuration with two services
- `Dockerfile` - Production build (multi-stage)
- `Dockerfile.dev` - Development build (lightweight, with hot reload)
- `.env` - Development environment variables
- `.env.production` - Production environment variables

### Services

#### Development Service (`tremtec-dev`)
- Container name: `tremtec-dev`
- Port: 4000
- Runs: `mix phx.server` (hot reload enabled)
- Database: `/data/tremtec_dev.db`
- Environment file: `.env`
- Profile: `dev`

#### Production Service (`tremtec-prod`)
- Container name: `tremtec-prod`
- Port: 4000
- Runs: Compiled release binary
- Database: `/data/tremtec.db`
- Environment file: `.env.production`
- Profile: `prod`

## Usage

### Development Environment

Start the development server with hot reload:

```bash
docker-compose --profile dev up
```

This will:
- Build from `Dockerfile.dev`
- Load variables from `.env`
- Run `mix phx.server` with file watching
- Mount local source code for live changes
- Create `/data/tremtec_dev.db` for development data

Access at: http://localhost:4000

**Useful commands:**

```bash
# View logs
docker-compose --profile dev logs -f tremtec-dev

# Access container shell
docker-compose --profile dev exec tremtec-dev bash

# Stop the service
docker-compose --profile dev down

# Remove volumes (reset database)
docker-compose --profile dev down -v
```

### Production Environment

Start the production server:

```bash
docker-compose --profile prod up
```

This will:
- Build a multi-stage optimized release from `Dockerfile`
- Load variables from `.env.production`
- Run the compiled release binary
- Create `/data/tremtec.db` for production data

Access at: http://localhost:4000

**Useful commands:**

```bash
# View logs
docker-compose --profile prod logs -f tremtec-prod

# Stop the service
docker-compose --profile prod down

# Remove volumes (reset database)
docker-compose --profile prod down -v
```

### Running Both Simultaneously

If you need to test both dev and prod at the same time:

```bash
docker-compose --profile dev --profile prod up
```

**Note:** Both services will try to use port 4000. You'll need to change one port in `docker-compose.yml`:

```yaml
tremtec-dev:
  ports:
    - "4000:4000"  # Development on 4000

tremtec-prod:
  ports:
    - "4001:4000"  # Production on 4001
```

Then access:
- Dev: http://localhost:4000
- Prod: http://localhost:4001

## Environment Variables

### Development (`.env`)

Typically includes:
```
DATABASE_PATH=/data/tremtec_dev.db
SECRET_KEY_BASE=<development_key>
LIVE_VIEW_SIGNING_SALT=<development_salt>
SMTP_FROM_EMAIL=noreply@tremtec.local
```

### Production (`.env.production`)

Typically includes:
```
DATABASE_PATH=/data/tremtec.db
SECRET_KEY_BASE=<production_key>
LIVE_VIEW_SIGNING_SALT=<production_salt>
RESEND_API_KEY=<api_key>
SMTP_FROM_EMAIL=noreply@tremtec.com
```

**Security:** Never commit `.env` or `.env.production` to version control. Use `.env.example` and `.env.production.example` instead.

## Database Management

Each environment has its own database file:
- **Dev**: `tremtec_dev_data` volume → `/data/tremtec_dev.db`
- **Prod**: `tremtec_prod_data` volume → `/data/tremtec.db`

### Reset Database

For development:
```bash
docker-compose --profile dev down -v
```

For production:
```bash
docker-compose --profile prod down -v
```

This removes the volume and creates a fresh database on next startup.

### Backup Database

```bash
# Development
docker cp tremtec-dev:/data/tremtec_dev.db ./backup_dev.db

# Production
docker cp tremtec-prod:/data/tremtec.db ./backup_prod.db
```

## Building Images

### Build Development Image

```bash
docker-compose --profile dev build tremtec-dev
```

### Build Production Image

```bash
docker-compose --profile dev build tremtec-prod
```

### Rebuild Without Cache

```bash
docker-compose --profile dev build --no-cache tremtec-dev
docker-compose --profile prod build --no-cache tremtec-prod
```

## Troubleshooting

### Port Already in Use

If port 4000 is already in use:

1. Find the container using it:
   ```bash
   lsof -i :4000
   ```

2. Stop it:
   ```bash
   docker stop <container_id>
   ```

3. Or change the port in `docker-compose.yml`

### Container Won't Start

Check logs:
```bash
docker-compose --profile dev logs tremtec-dev
# or
docker-compose --profile prod logs tremtec-prod
```

### Database Permissions Error

Rebuild the image:
```bash
docker-compose --profile dev build --no-cache tremtec-dev
docker-compose --profile prod build --no-cache tremtec-prod
```

### Hot Reload Not Working (Dev)

The development server uses file watching. If hot reload doesn't work:

1. Ensure Docker Desktop has proper volume mounts enabled
2. Check file permissions: `chmod -R 755 .`
3. Restart the container:
   ```bash
   docker-compose --profile dev restart tremtec-dev
   ```

## Performance Notes

### Development
- Slower startup (compilation on each change)
- Full Elixir/OTP stack in container
- Useful for debugging and development

### Production
- Fast startup (pre-compiled release)
- Minimal runtime image (Debian slim)
- Optimized for deployment

## Prerequisites

- **Docker Desktop** installed and running
- **Docker Compose** (included with Docker Desktop)
- For Linux: install Docker Engine and Docker Compose separately

## Quick Start

**First time setup:**

```bash
# Build and start development environment
docker-compose --profile dev up --build
```

**Subsequent runs:**

```bash
# Just start it
docker-compose --profile dev up
```

Then visit http://localhost:4000 in your browser.

## Cleaning Up

Remove all containers and volumes (including databases):

```bash
docker-compose --profile dev down -v
docker-compose --profile prod down -v

# Or both at once
docker-compose --profile dev --profile prod down -v
```

Remove just containers (keeps data):

```bash
docker-compose --profile dev down
```

## Environment Setup

### First-time configuration

1. Copy environment template files:

```bash
cp .env.example .env
cp .env.production.example .env.production
```

2. Edit `.env` and `.env.production` with your secrets:
   - `SECRET_KEY_BASE` - Generate with `mix phx.gen.secret`
   - `LIVE_VIEW_SIGNING_SALT` - Generate with `mix phx.gen.secret`
   - `RESEND_API_KEY` - (Production only, for email)

### Verifying Variables

Check that Docker has loaded your environment:

```bash
docker-compose --profile dev config
```

This shows the resolved configuration including environment variables.

## Debugging

### Check Container Status

```bash
docker-compose --profile dev ps
```

### Monitor Real-time Logs

```bash
docker-compose --profile dev logs -f tremtec-dev
```

### Interactive Shell

```bash
docker-compose --profile dev exec tremtec-dev bash
```

Inside the container, you can run:

```bash
# Check database schema
sqlite3 /data/tremtec_dev.db ".schema"

# Run Elixir commands
iex -S mix
```

### Inspect Volumes

```bash
# List all volumes
docker volume ls

# Inspect a specific volume
docker volume inspect tremtec_dev_data

# Access files in the volume
docker-compose --profile dev exec tremtec-dev ls -la /data
```

## Next Steps

- Read [PRODUCTION_DEPLOYMENT.md](./PRODUCTION_DEPLOYMENT.md) for deploying to Fly.io
- Check [I18N.md](./I18N.md) for internationalization setup
- See [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md) for development workflow

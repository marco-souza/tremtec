# Production Deployment Guide

This document outlines the critical requirements and best practices for deploying TremTec to production.

## Critical Security Requirements

### Admin Credentials (REQUIRED)

Admin credentials **must** be explicitly set before deployment. The application will fail to start if these environment variables are not provided.

```bash
# Set these environment variables in your production environment
export ADMIN_USER='your-secure-username'
export ADMIN_PASS='your-secure-password'
```

**Important**: 
- Do NOT use the default credentials from development
- Use strong, randomly-generated credentials (minimum 16 characters)
- Store these in your secrets manager (not in code or Docker image)
- Rotate credentials regularly

### Session Encryption (REQUIRED)

The `LIVE_VIEW_SIGNING_SALT` environment variable must be set for LiveView security:

```bash
# Generate a new salt
mix phx.gen.secret 32

# Set in production
export LIVE_VIEW_SIGNING_SALT='your-generated-salt'
```

### Secret Key Base (REQUIRED)

```bash
# Generate a new key
mix phx.gen.secret

# Set in production
export SECRET_KEY_BASE='your-generated-key'
```

## Database Configuration

### SQLite Setup

For production with SQLite:

```bash
export DATABASE_PATH='/var/lib/tremtec/tremtec.db'
export POOL_SIZE='5'  # Adjust based on concurrency needs
```

Ensure the directory has proper permissions:
```bash
mkdir -p /var/lib/tremtec
chown -R app:app /var/lib/tremtec
chmod 750 /var/lib/tremtec
```

**Persistence**: When using Docker, ensure the database volume is properly mounted:
```bash
docker run -v tremtec-data:/data tremtec:latest
```

## Fly.io Deployment

### Environment Variables

Set these secrets in Fly.io:
```bash
fly secrets set ADMIN_USER='your-username'
fly secrets set ADMIN_PASS='your-password'
fly secrets set SECRET_KEY_BASE='your-key'
fly secrets set LIVE_VIEW_SIGNING_SALT='your-salt'
```

### Volume Configuration

The `fly.toml` already includes persistent storage configuration:
```toml
[mounts]
  source = "data"
  destination = "/data"
```

## Docker Deployment

### Building the Image

```bash
docker build -t tremtec:latest .
```

### Running the Container

```bash
docker run \
  -p 4000:8080 \
  -e ADMIN_USER='your-username' \
  -e ADMIN_PASS='your-password' \
  -e SECRET_KEY_BASE='your-key' \
  -e LIVE_VIEW_SIGNING_SALT='your-salt' \
  -e DATABASE_PATH='/data/tremtec.db' \
  -e PHX_HOST='your-domain.com' \
  -v tremtec-data:/data \
  tremtec:latest
```

## Locale Configuration

### Supported Locales

TremTec supports 3 locales:
- Portuguese (pt) - `pt` or `pt-BR`, `pt-PT`
- English (en) - `en`, `en-US`, `en-GB`
- Spanish (es) - `es`, `es-ES`, `es-MX`

### Accept-Language Header

Locale detection is automatic based on the `Accept-Language` HTTP header sent by browsers. No configuration required.

Fallback:
- If no supported locale is detected, defaults to English (en)
- Users cannot manually switch locales (design by intent)

## SSL/HTTPS Configuration

### Fly.io (Automatic)

Fly.io automatically provides HTTPS with Let's Encrypt. Ensure `force_https = true` in `fly.toml`.

### Docker/Self-Hosted

Configure SSL certificates in your reverse proxy (nginx, Caddy, etc.):

```nginx
# Example nginx configuration
upstream tremtec {
  server 127.0.0.1:8080;
}

server {
  listen 443 ssl http2;
  server_name your-domain.com;

  ssl_certificate /path/to/cert.pem;
  ssl_certificate_key /path/to/key.pem;

  location / {
    proxy_pass http://tremtec;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
```

## Health Checks

The application provides a health check endpoint:

```bash
curl https://your-domain.com/docs
```

Expected response: HTTP 200 with the documentation page.

## Monitoring and Logging

### Application Logs

Access logs via:
```bash
# Fly.io
fly logs

# Docker
docker logs <container-id>
```

### Admin Access Monitoring

Admin authentication attempts are not logged to prevent credential exposure. Monitor access via:
- Web server access logs (nginx, etc.)
- Container orchestration logs (Fly.io)

### Performance Monitoring

For production, consider:
- HTTP request metrics (response time, error rates)
- Database query performance
- Memory and CPU usage

## Database Maintenance

### Backups

For SQLite in production, establish regular backups:

```bash
# Manual backup
cp /data/tremtec.db /backups/tremtec.db.backup.$(date +%s)

# Automated backup (example with cron)
0 2 * * * cp /data/tremtec.db /backups/tremtec.db.backup.$(date +\%s)
```

### Recovery

To restore from backup:
```bash
cp /backups/tremtec.db.backup.XXX /data/tremtec.db
```

## Pre-Deployment Checklist

- [ ] All environment variables set and verified
- [ ] Admin credentials are strong and secure
- [ ] Database volume/path configured correctly
- [ ] SSL/HTTPS enabled
- [ ] Admin auth URL (`/admin/*`) is behind authentication
- [ ] No compiler warnings: `mix compile --force`
- [ ] All tests passing: `mix test`
- [ ] Code quality checks pass: `mix precommit`
- [ ] Logs don't expose sensitive information
- [ ] Backups configured for database

## Rollback Procedure

If issues occur:

1. Identify the problem from logs
2. Roll back to previous Docker image or Fly deployment
3. Check database integrity (backup and restore if needed)
4. Verify admin credentials still work

## Production Configuration Summary

| Variable | Required | Description |
|----------|----------|-------------|
| ADMIN_USER | Yes | Admin username (no default) |
| ADMIN_PASS | Yes | Admin password (no default) |
| SECRET_KEY_BASE | Yes | Session encryption key |
| LIVE_VIEW_SIGNING_SALT | Yes | LiveView security salt |
| DATABASE_PATH | No | SQLite file path (default: `/data/tremtec.db`) |
| PHX_HOST | No | Application hostname (default: `example.com`) |
| PORT | No | Server port (default: `4000`) |
| POOL_SIZE | No | Database connection pool (default: `5`) |

## Troubleshooting

### Application fails to start: "Admin credentials not configured!"

**Cause**: ADMIN_USER or ADMIN_PASS environment variables are not set.

**Solution**: Set both environment variables before starting.

### HTTPS not working

**Cause**: Certificate not configured or SSL key missing.

**Solution**: Verify certificate paths and ensure HTTPS is enabled in configuration.

### Database not persisting between restarts

**Cause**: Database volume not properly mounted.

**Solution**: Verify volume mount configuration and ensure the `/data` directory has correct permissions.

## Support

For issues or questions about production deployment:
1. Check the logs first
2. Verify all environment variables are set
3. Consult this documentation
4. Review Phoenix deployment guides: https://hexdocs.pm/phoenix/deployment.html

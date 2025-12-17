# Unified Dockerfile for TremTec (Phoenix Umbrella)
# Supports both development and production via build targets
#
# Usage:
#   Development: docker build --target dev -t tremtec:dev .
#   Production:  docker build --target prod -t tremtec:latest .
#
# Build args:
#   APP_NAME: Which app to build/run (default: tremtec)

ARG ELIXIR_VERSION=1.18.4

# =============================================================================
# Base stage - shared dependencies
# =============================================================================
FROM elixir:${ELIXIR_VERSION} AS base

ARG APP_NAME=tremtec
ENV APP_NAME=${APP_NAME}
ENV LANG=C.UTF-8 \
    SHELL=/bin/bash

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      curl \
      ca-certificates \
      pkg-config \
      libssl-dev \
      libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

# =============================================================================
# Development stage - hot reload, full tooling
# =============================================================================
FROM base AS dev

ARG APP_NAME=tremtec
ENV APP_NAME=${APP_NAME}
ENV MIX_ENV=dev

# Install dev-only dependencies (inotify-tools for file watching/hot reload)
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      inotify-tools && \
    rm -rf /var/lib/apt/lists/*

# Copy umbrella structure
COPY mix.exs mix.lock ./
COPY config ./config
COPY apps ./apps

# Install all dependencies (including dev and test)
RUN mix deps.get

# Create data directory for SQLite database
RUN mkdir -p /data && chmod 755 /data

ENV DATABASE_PATH=${DATABASE_PATH:-/data/tremtec_dev.db}

EXPOSE 4000

# Run the server from umbrella root (delegates to specific app via mix.exs aliases)
CMD ["mix", "phx.server"]

# =============================================================================
# Builder stage - compile release for production
# =============================================================================
FROM base AS builder

ARG APP_NAME=tremtec
ENV APP_NAME=${APP_NAME}
ENV MIX_ENV=prod

# Install libvips for image processing
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends libvips-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy umbrella structure
COPY mix.exs mix.lock ./
COPY config ./config
COPY apps ./apps

# Install production dependencies only
RUN mix deps.get --only prod && \
    mix deps.compile

# Compile and build assets
RUN mix compile && \
    if [ -d "apps/${APP_NAME}/assets" ]; then \
      mix assets.deploy; \
    fi && \
    mix release ${APP_NAME}

# =============================================================================
# Production stage - minimal runtime image
# =============================================================================
FROM debian:trixie-slim AS prod

ARG APP_NAME=tremtec
ENV APP_NAME=${APP_NAME}
ENV LANG=C.UTF-8 \
    SHELL=/bin/bash

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      libssl3 \
      libsqlite3-0 \
      ca-certificates \
      curl \
      libvips && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m -u 1000 app

WORKDIR /app

# Copy release from builder
COPY --from=builder --chown=app:app /app/_build/prod/rel/${APP_NAME} ./

# Copy entrypoint script
COPY --chown=app:app scripts/docker_entrypoint.sh ./bin/docker_entrypoint.sh
RUN chmod +x ./bin/docker_entrypoint.sh

# Create data directory
RUN mkdir -p /data && chown -R app:app /data

USER app

EXPOSE 4000

# Health check (port 4000 is the default internal port)
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:4000/api/healthz || exit 1

ENTRYPOINT ["/app/bin/docker_entrypoint.sh"]

CMD ["start"]

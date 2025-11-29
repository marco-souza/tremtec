# Production Dockerfile for TremTec (Phoenix)
# Multi-stage build: compile on Elixir base, run on Debian slim
# Elixir 1.18.4, OTP 28

ARG ELIXIR_VERSION=1.18.4
ARG ERLANG_VERSION=28.0.0

# Build stage
FROM elixir:${ELIXIR_VERSION} AS builder

ENV MIX_ENV=prod \
    LANG=C.UTF-8 \
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

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files and config
COPY mix.exs mix.lock ./
COPY config ./config

# Install dependencies (prod only - no dev/test)
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy entire application
COPY . .

# Compile the application
RUN mix compile

# Build the release
RUN mix release

# Runtime stage - minimal image
FROM debian:bookworm-slim

ENV LANG=C.UTF-8 \
    SHELL=/bin/bash

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      libssl3 \
      libsqlite3-0 \
      ca-certificates \
      curl && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for security
RUN useradd -m -u 1000 app

WORKDIR /app

# Copy release from builder
COPY --from=builder --chown=app:app /app/_build/prod/rel/tremtec ./

# Create data directory
RUN mkdir -p /data && chown -R app:app /data

USER app

EXPOSE 4000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:4000/healthz || exit 1

# Run the release
CMD ["bin/tremtec", "start"]

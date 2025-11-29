#!/bin/bash
set -e

# Run migrations
echo "Running migrations..."
/app/bin/tremtec eval "Tremtec.Release.migrate"

# Start the application
echo "Starting Tremtec..."
exec /app/bin/tremtec "$@"


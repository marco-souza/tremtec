#!/bin/bash

# LSP Diagnostics Script
# Usage: ./check-diagnostics.sh [path]
# Example: ./check-diagnostics.sh src/lib/domain

set -e

PATH_TO_CHECK="${1:-.}"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo '.')"

cd "$PROJECT_ROOT"

echo "🔍 Running TypeScript Diagnostics on: $PATH_TO_CHECK"
echo ""

# Run TypeScript compiler in noEmit mode (check only, don't generate files)
echo "📋 TypeScript Check:"
npx tsc --noEmit --listFiles false 2>&1 | grep -E "error TS|warning TS" || echo "  ✅ No TypeScript errors"

echo ""
echo "🎨 Biome Linting:"
npx biome lint "$PATH_TO_CHECK" --reporter=github 2>&1 || true

echo ""
echo "✨ Diagnostics complete"

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if command -v lake >/dev/null 2>&1; then
  LAKE="$(command -v lake)"
else
  LAKE="$HOME/.elan/bin/lake"
fi
# Fetch only public Mathlib imports and their dependency closures. No private
# project proof objects are obtained from another working copy.
grep -h '^import Mathlib\.' D1Bound5/*.lean |
  sed 's/^import //' | sort -u | xargs "$LAKE" exe cache get

#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if command -v lake >/dev/null 2>&1; then
  LAKE="$(command -v lake)"
else
  LAKE="$HOME/.elan/bin/lake"
fi
PYTHON="${PYTHON:-python3}"
mkdir -p local-logs
"$PYTHON" scripts/source_audit.py | tee local-logs/source-audit.log
"$LAKE" env lean --version | tee local-logs/lean-version.log
"$LAKE" build 2>&1 | tee local-logs/build.log
"$LAKE" env lean scripts/Audit.lean 2>&1 | tee local-logs/axiom-audit.log
if [[ "${1:-}" == "--replay" ]]; then
  # One worker avoids running many Mathlib import environments concurrently.
  LEAN_NUM_THREADS=1 "$LAKE" env leanchecker --verbose D1Bound5 \
    2>&1 | tee local-logs/kernel-replay.log
elif [[ -n "${1:-}" ]]; then
  printf 'Unknown option: %s\n' "$1" >&2
  exit 2
fi
printf 'CHECKS_PASS\n'

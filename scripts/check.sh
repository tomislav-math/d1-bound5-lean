#!/usr/bin/env bash
set -euo pipefail
D1_CHECK_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec "${PYTHON:-python3}" "$D1_CHECK_ROOT/scripts/verification/check.py" "$@"

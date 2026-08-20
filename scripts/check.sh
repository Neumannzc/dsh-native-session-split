#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PATCH="$SCRIPT_DIR/../patches/dsh-native-session-split.patch"

if [[ ! -e "$ROOT/.git" ]]; then
  printf 'Expected a DeepSeek Harness Git checkout: %s\n' "$ROOT" >&2
  exit 1
fi

git -C "$ROOT" apply --whitespace=nowarn --check "$PATCH"
printf 'Patch applies cleanly to %s\n' "$ROOT"

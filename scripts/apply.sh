#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PATCH="$SCRIPT_DIR/../patches/dsh-native-session-split.patch"

if [[ ! -e "$ROOT/.git" ]]; then
  printf 'Expected a DeepSeek Harness Git checkout: %s\n' "$ROOT" >&2
  exit 1
fi

if ! git -C "$ROOT" apply --whitespace=nowarn --check "$PATCH"; then
  printf 'Patch cannot be applied cleanly. Use the target DSH revision or rebase the patch.\n' >&2
  exit 1
fi

git -C "$ROOT" apply --whitespace=nowarn --index "$PATCH"
printf 'Applied native session split patch to %s\n' "$ROOT"
printf 'Next: pnpm run build:lib:host && pnpm run build:lib:client && pnpm --filter @deepseek-ai/dsh-web-frontend build\n'

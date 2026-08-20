#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
PATCH="$SCRIPT_DIR/../patches/dsh-native-session-split.patch"

if [[ ! -e "$ROOT/.git" ]]; then
  printf 'Expected a DeepSeek Harness Git checkout: %s\n' "$ROOT" >&2
  exit 1
fi

if ! git -C "$ROOT" apply --whitespace=nowarn --reverse --check "$PATCH"; then
  printf 'Patch cannot be reversed cleanly. Confirm that this exact patch is applied first.\n' >&2
  exit 1
fi

git -C "$ROOT" apply --whitespace=nowarn --reverse --index "$PATCH"
printf 'Removed native session split patch from %s\n' "$ROOT"

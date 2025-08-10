#!/usr/bin/env bash
set -e

for file in "$@"; do
  if ! head -n 1 "$file" | grep -q '^\$ANSIBLE_VAULT'; then
    echo "$file: missing \$ANSIBLE_VAULT header" >&2
    exit 1
  fi
done

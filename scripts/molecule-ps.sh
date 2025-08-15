#!/usr/bin/env bash
set -euo pipefail

containers=$(docker ps -q --filter "label=project=linux-dev-playbook")
if [ -n "$containers" ]; then
  echo "Warning: lingering containers with label project=linux-dev-playbook found:"
  docker ps --filter "label=project=linux-dev-playbook"
else
  echo "No molecule containers found."
fi

#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

if [ ! -f "$HOME/.nanobot/config.json" ]; then
  echo "Missing ~/.nanobot/config.json"
  echo "Copy templates/nanobot-config.example.json there and add local values first."
  exit 1
fi

if [ -z "${SCADSAI_LLM_API_KEY:-}" ]; then
  echo "SCADSAI_LLM_API_KEY is not set in this shell."
  echo "If the key is stored directly in ~/.nanobot/config.json, you can ignore this warning."
fi

nanobot status
nanobot agent -m "Hello! Reply in one short sentence."

if command -v xdg-open >/dev/null 2>&1; then
  (sleep 2 && xdg-open "http://127.0.0.1:8765" >/dev/null 2>&1) &
fi

nanobot gateway

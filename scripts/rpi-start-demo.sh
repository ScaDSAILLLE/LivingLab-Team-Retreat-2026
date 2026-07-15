#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

if [ -f "scripts/set_secrets.local.sh" ]; then
  # shellcheck source=/dev/null
  source "scripts/set_secrets.local.sh"
else
  echo "Missing scripts/set_secrets.local.sh"
  echo "Copy scripts/set_secrets.example.sh and add local values first."
  exit 1
fi

if [ ! -f "$HOME/.nanobot/config.json" ]; then
  echo "Missing ~/.nanobot/config.json"
  echo "Copy templates/nanobot-config.example.json there and add local values first."
  exit 1
fi

if [ -z "${SCADSAI_LLM_API_KEY:-}" ]; then
  echo "SCADSAI_LLM_API_KEY is not set in this shell."
  echo "Edit and source scripts/set_secrets.local.sh first."
  exit 1
fi

if [ -z "${NANOBOT_WEBUI_SECRET:-}" ]; then
  echo "NANOBOT_WEBUI_SECRET is not set in this shell."
  echo "Edit and source scripts/set_secrets.local.sh first."
  exit 1
fi

rpi_ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
if [ -n "$rpi_ip" ]; then
  echo "Nanobot WebUI should be reachable at: http://$rpi_ip:8765"
fi

nanobot status
nanobot agent -m "Hello! Reply in one short sentence."

if command -v xdg-open >/dev/null 2>&1; then
  (sleep 2 && xdg-open "http://127.0.0.1:8765" >/dev/null 2>&1) &
fi

nanobot gateway &
gateway_pid=$!

if command -v x-terminal-emulator >/dev/null 2>&1; then
  x-terminal-emulator -e bash -lc 'source scripts/set_secrets.local.sh && opencode; exec bash' >/dev/null 2>&1 || true
else
  echo "Open a second terminal and run: source scripts/set_secrets.local.sh && opencode"
fi

wait "$gateway_pid"

#!/usr/bin/env bash
set -euo pipefail

cat <<'MSG'
RPi bootstrap for the Living Lab Retreat.

Review this script before running it. It installs packages and executes remote
installer commands. Use only on the prepared retreat Raspberry Pi or another
system where you accept these changes.
MSG

read -r -p "Continue? Type YES: " confirm
if [ "$confirm" != "YES" ]; then
  echo "Aborted."
  exit 1
fi

sudo apt update
sudo apt install -y git curl ca-certificates

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

export PATH="$HOME/.local/bin:$PATH"

uv tool install nanobot-ai

if command -v nanobot >/dev/null 2>&1; then
  nanobot --version
  echo
  read -r -p "Run 'nanobot onboard' now? Type YES: " onboard_confirm
  if [ "$onboard_confirm" = "YES" ]; then
    nanobot onboard
  else
    echo "Skipped nanobot onboard. You can run it later with: nanobot onboard"
  fi
fi

if ! command -v opencode >/dev/null 2>&1; then
  curl -fsSL https://opencode.ai/install | bash
fi

cat <<'MSG'

Bootstrap finished.

Next steps:
1. Copy templates/nanobot-config.example.json to ~/.nanobot/config.json.
2. Copy templates/opencode.example.json to opencode.json in the working repository.
3. Copy scripts/set_secrets.example.sh to scripts/set_secrets.local.sh.
4. Set the shared ScaDS.AI API key for opencode and Nanobot:
   echo 'export SCADSAI_API_KEY="ihr_aktueller_api_key"' >> ~/.bashrc
   source ~/.bashrc
5. For prepared RPi systems, add local secrets to scripts/set_secrets.local.sh and source it:
   source scripts/set_secrets.local.sh
6. Re-check model IDs against https://llm.scads.ai/status/ if needed.
7. Start:
   nanobot gateway
8. Open:
   http://127.0.0.1:8765
   http://<rpi-ip>:8765
9. Start opencode from the working repository:
   opencode

Do not commit local configs or secrets.
MSG

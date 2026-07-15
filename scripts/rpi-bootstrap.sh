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
sudo apt install -y git curl ca-certificates python3 python3-venv python3-pip

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

export PATH="$HOME/.local/bin:$PATH"

uv tool install nanobot-ai

if ! command -v opencode >/dev/null 2>&1; then
  curl -fsSL https://opencode.ai/install | bash
fi

mkdir -p "$HOME/.nanobot"

cat <<'MSG'

Bootstrap finished.

Next steps:
1. Copy templates/nanobot-config.example.json to ~/.nanobot/config.json.
2. Copy templates/opencode.example.json to opencode.local.json in the working repository.
3. Replace model placeholders with exact llm.scads.ai model IDs.
4. Provide local secrets through environment variables or local-only config:
   export SCADSAI_LLM_API_KEY="replace-with-local-key"
   export NANOBOT_WEBUI_SECRET="replace-with-local-webui-password"
5. Verify:
   nanobot status
   nanobot agent -m "Hello!"
6. Start:
   nanobot gateway
7. Open:
   http://127.0.0.1:8765
   http://<rpi-ip>:8765
8. Start opencode from the working repository:
   OPENCODE_CONFIG=opencode.local.json opencode

Do not commit local configs or secrets.
MSG

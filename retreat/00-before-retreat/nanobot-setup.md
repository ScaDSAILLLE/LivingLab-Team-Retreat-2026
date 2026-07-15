# Nanobot Setup

## Purpose
Prepare Nanobot as the baseline demonstrator surface for the retreat.

## Known Baseline
- Nanobot package: `nanobot-ai`
- Recommended install path for the retreat: `uv tool install nanobot-ai`
- WebUI command path: `nanobot gateway`, then open port `8765`
- LAN access path: bind WebSocket/WebUI to `0.0.0.0` and set a WebUI secret
- Provider: `llm.scads.ai` / TUD:AI, documented at <https://llm.scads.ai>
- Configuration docs: <https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md>

## Model Placeholders
Use the current `llm.scads.ai` model list before the retreat. Candidate defaults:
- Nanobot primary model: `gemma-4` placeholder
- Alternatives to document if available: `glm-5.2`, `kimi-2.7-code`

Replace placeholder model IDs in local configs with exact model IDs from the authenticated `llm.scads.ai` model overview.

## Install
```bash
uv tool install nanobot-ai
nanobot --version
nanobot onboard
```

If `nanobot` is not on `PATH`, open a new terminal or ensure `~/.local/bin` is included in `PATH`.

`nanobot onboard --wizard` is available if an interactive configuration flow is preferred.

## Prepare Config
Use [`../../templates/nanobot-config.example.json`](../../templates/nanobot-config.example.json) as the safe template.

Recommended local target path, run from the repository root:

```bash
mkdir -p ~/.nanobot
cp templates/nanobot-config.example.json ~/.nanobot/config.json
```

Then edit the local file only:

```bash
nano ~/.nanobot/config.json
```

Keep `${SCADSAI_LLM_API_KEY}` and `${NANOBOT_WEBUI_SECRET}` in the config. Export the real values before starting Nanobot.

Never copy the real local config back into this repository.

## Local Secret Script
Prepare a local script from the example:

```bash
cp scripts/set_secrets.example.sh scripts/set_secrets.local.sh
nano scripts/set_secrets.local.sh
```

Edit `scripts/set_secrets.local.sh` locally and insert the real values. Then source it in the terminal that starts Nanobot:

```bash
source scripts/set_secrets.local.sh
```

The script must be sourced, not executed, so the exported variables remain available in the current shell.

## Verify Model IDs
Use the `llm.scads.ai` status overview to check currently available models:

```text
https://llm.scads.ai/status/
```

Use the confirmed model IDs to update the config template.

## Smoke Test
```bash
nanobot status
nanobot agent -m "Hello! Reply in one short sentence."
```

Fix provider/config problems before starting the WebUI.

## Start WebUI
```bash
nanobot gateway
```

Open locally on the RPi:

```text
http://127.0.0.1:8765
```

Open from another device on the same network:

```text
http://<rpi-ip>:8765
```

The LAN path requires the config to set `channels.websocket.host` to `0.0.0.0` and define `tokenIssueSecret` or `token`.

## Troubleshooting
- Open port `8765`, not the gateway health port.
- If LAN access fails, check RPi IP address, firewall, and `channels.websocket.host`.
- If startup fails after setting `0.0.0.0`, ensure `tokenIssueSecret` or `token` is configured.
- If the model call fails, verify the exact `apiBase`, model ID, and key with the authenticated `llm.scads.ai` docs.

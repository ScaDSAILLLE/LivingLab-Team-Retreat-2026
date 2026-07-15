# Nanobot Setup

## Purpose
Prepare Nanobot as the baseline demonstrator surface for the retreat.

## Known Baseline
- Nanobot package: `nanobot-ai`
- Python requirement: Python 3.11+
- Recommended install path for the retreat: `uv tool install nanobot-ai`
- WebUI command path: `nanobot gateway`, then open port `8765`
- LAN access path: bind WebSocket/WebUI to `0.0.0.0` and set a WebUI secret
- Provider: `llm.scads.ai` / TUD:AI, documented at <https://llm.scads.ai>

## Model Placeholders
Use the current `llm.scads.ai` model list before the retreat. Candidate defaults:
- Nanobot primary model: `gemma-4` placeholder
- Alternatives to document if available: `glm-5.2`, `kimi-2.7-code`

Replace placeholder model IDs in local configs with exact model IDs from the authenticated `llm.scads.ai` model overview.

## Install
```bash
uv tool install nanobot-ai
nanobot --version
```

If `nanobot` is not on `PATH`, open a new terminal or ensure `~/.local/bin` is included in `PATH`.

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

Two safe key-handling options are acceptable:
- Keep `${SCADSAI_LLM_API_KEY}` and export the key in the terminal that starts Nanobot.
- Replace the placeholder in `~/.nanobot/config.json` with the real key on the RPi only.

Never copy the real local config back into this repository.

## Environment Variable Option
```bash
export SCADSAI_LLM_API_KEY="replace-with-local-key"
export NANOBOT_WEBUI_SECRET="replace-with-local-webui-password"
```

The shell exports apply only to the current terminal unless added to a protected local shell profile or service environment.

## Verify Provider Access
Without a key, `https://llm.scads.ai/v1/models` returns `401`. With a valid key, the model list should be reachable:

```bash
curl -sS https://llm.scads.ai/v1/models \
  -H "Authorization: Bearer $SCADSAI_LLM_API_KEY"
```

Use the returned model IDs to update the config template.

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

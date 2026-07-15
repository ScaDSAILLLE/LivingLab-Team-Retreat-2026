# Raspberry Pi Target System Notes

## Purpose
Use a dedicated Raspberry Pi as a realistic demonstrator target for Nanobot WebUI access, operations discussion, and deployment practice.

## Initial Assumption
- The RPi is a dedicated, closed demonstrator system.
- Compute-heavy multimodal tasks may need central/HPC/GPU resources; the RPi should primarily host or expose the lightweight interface and orchestration layer.

## Primary Retreat Architecture
- Nanobot runs on the RPi through `uv tool install nanobot-ai`.
- Nanobot WebUI is exposed directly on the trusted workshop network through the WebSocket channel.
- `nanobot gateway` provides the WebUI/WebSocket surface on port `8765`.
- LAN access uses `channels.websocket.host: "0.0.0.0"` plus `tokenIssueSecret` or `token`.
- opencode runs in the cloned working repository on the RPi desktop.
- Secrets are injected by sourcing `scripts/set_secrets.local.sh`, never through Git.

## Required Local Config State
- `~/.nanobot/config.json` exists and was copied from [`../../templates/nanobot-config.example.json`](../../templates/nanobot-config.example.json).
- `opencode.json` exists in the cloned working repository and was copied from [`../../templates/opencode.example.json`](../../templates/opencode.example.json).
- `scripts/set_secrets.local.sh` exists locally and was copied from [`../../scripts/set_secrets.example.sh`](../../scripts/set_secrets.example.sh).
- The local shell has loaded the secrets with `source scripts/set_secrets.local.sh` before starting Nanobot or opencode.

Open from another device on the same network:

```text
http://<rpi-ip>:8765
```

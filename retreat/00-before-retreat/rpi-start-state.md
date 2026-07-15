# Raspberry Pi 400 Start State

## Purpose
Define the state the Raspberry Pi 400 should be in before participants arrive.

## Hardware
- Raspberry Pi 400 powered on.
- Monitor connected.
- Built-in keyboard ready; mouse connected.
- Network connected and IP address known.
- Browser available on the RPi desktop.
- Optional SSH access enabled for technical support.

## Installed Software
- Git installed.
- `uv` installed and available on `PATH`.
- `nanobot-ai` installed.
- opencode installed.
- Browser and terminal available.
- VS Code or another editor available if planned for the workshop.

## Prepared Repositories
- Workshop repository cloned.
- Nanobot or starter working repository cloned if separate from this repository.
- Working folder opened in terminal or VS Code.
- `AGENTS.md` present in the working folder.

## Prepared Config
- Nanobot config copied to `~/.nanobot/config.json`.
- Nanobot model ID and `llm.scads.ai` endpoint verified.
- WebUI secret configured for LAN access.
- opencode config prepared as `opencode.json` in the working repository.
- `scripts/set_secrets.local.sh` prepared locally and sourced before startup.

## Running Before 10:00
- `nanobot status` succeeds.
- `nanobot agent -m "Hello!"` succeeds.
- `nanobot gateway` is running.
- Nanobot WebUI is open on the RPi browser.
- Nanobot WebUI is reachable from another trusted device if needed.
- opencode is open in the cloned working folder.
- The repository, setup docs, Nextcloud overview, or cheatsheet is open next to the demo.

## Room Check
- Participants can see the RPi screen or projected browser.
- Facilitators know the WebUI URL, RPi IP, and fallback path.
- No real secrets are visible on screen.

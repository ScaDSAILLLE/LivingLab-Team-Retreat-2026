# RPi Start State

## Purpose
Define the state the Raspberry Pi should be in before participants arrive.

## Hardware
- Raspberry Pi powered on.
- Monitor connected.
- Keyboard and mouse connected.
- Network connected and IP address known.
- Browser available on the RPi desktop.
- Optional SSH access enabled for technical support.

## Installed Software
- Git installed.
- Python 3.11+ available.
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
- opencode local config prepared as `opencode.local.json` or equivalent.
- API key provided through environment variables or local-only config.

## Running Before 10:00
- `nanobot status` succeeds.
- `nanobot agent -m "Hello!"` succeeds.
- `nanobot gateway` is running.
- Nanobot WebUI is open on the RPi browser.
- Nanobot WebUI is reachable from another trusted device if needed.
- opencode is open in the cloned working folder.
- Shared dashboard is open next to the demo.

## Room Check
- Participants can see the RPi screen or projected browser.
- Facilitators know the WebUI URL, RPi IP, and fallback path.
- No real secrets are visible on screen.

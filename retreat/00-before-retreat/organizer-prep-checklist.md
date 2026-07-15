# Organizer Prep Checklist

## Shared Workspace
- Create Nextcloud share for the day.
- Prepare a retreat dashboard with links, ports, contacts, setup commands, track documents, and current status.
- Prepare prompt cards for opencode.
- Prepare documentation templates: `README.md`, `setup.md`, `manual.md`, `deployment.md`, `known-limitations.md`.
- Prepare accessibility and corporate-design input material.
- Prepare Scaddy-V1 reference material for comparison, not for a one-to-one rebuild.

## Nanobot Baseline
- Use the direct RPi/WebUI path as the primary retreat baseline unless a prepared Docker setup is already tested.
- Install Nanobot via `uv tool install nanobot-ai` on the RPi.
- Prepare `~/.nanobot/config.json` from `templates/nanobot-config.example.json`.
- Replace model placeholders with exact authenticated `llm.scads.ai` model IDs.
- Add the API key through a local-only environment variable or local-only RPi config.
- Run `nanobot status` and `nanobot agent -m "Hello!"` before the retreat.
- Start `nanobot gateway` and verify WebUI at `http://127.0.0.1:8765` and `http://<rpi-ip>:8765` if LAN access is needed.
- If API integration is needed, enable and test `nanobot serve` on `127.0.0.1:8900` after `nanobot plugins enable api`.
- Prepare fallback screenshots or a mock transcript in case the live setup fails.

## opencode Baseline
- Install opencode on the RPi and any facilitator laptops that need it.
- Prepare `opencode.local.json` from `templates/opencode.example.json` in the working repository.
- Replace model placeholders with exact authenticated `llm.scads.ai` model IDs.
- Verify opencode starts in the working folder with `OPENCODE_CONFIG=opencode.local.json opencode`.
- Verify edit and shell permissions ask for confirmation.

## Secrets and Config
- Prepare `.env.example` only after the starter project exists.
- Use environment-variable placeholders for secrets in examples.
- Never copy real `~/.nanobot/config.json` into the repository.
- Never commit `opencode.local.json`, `nanobot.local.json`, `nanobot.env`, `.nanobot/`, or copied local configs.
- Verify `.gitignore` still covers `.env*`, tokens, keys, credentials, and local-only config files.

## Retreat Materials
- Prepare role cards for Prompt Navigator, Demo Tester, Accessibility Reviewer, Documentation Lead, Story Lead, and Spec Keeper.
- Prepare one visible success criterion for each feature track.
- Prepare one fallback task per track that can be completed without live model access.

## Start State
- RPi, monitor, keyboard, mouse, network, and power are ready.
- RPi desktop shows Nanobot WebUI and the shared dashboard.
- Terminal or VS Code is open in the cloned working repository.
- opencode is started or ready to start in that working folder.

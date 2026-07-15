# Organizer Prep Checklist

Use this as the main setup runbook before participants arrive. Detailed config notes live in the linked setup files to avoid duplicating templates across documents.

## Step-by-Step Setup

| Step | Action | Reference |
|---:|---|---|
| 1 | Prepare the shared workspace, repository access, and optional Nextcloud overview. | [Shared Workspace](#shared-workspace) |
| 2 | Prepare the Raspberry Pi 400 hardware and desktop start state. | [`rpi-start-state.md`](rpi-start-state.md) |
| 3 | Install Git, `uv`, Nanobot, and opencode on the RPi. | [`rpi-target-system.md`](rpi-target-system.md), [`nanobot-setup.md`](nanobot-setup.md), [`opencode-setup.md`](opencode-setup.md) |
| 4 | Copy config templates and re-check model IDs against `llm.scads.ai/status/`. | [`config-templates.md`](config-templates.md) |
| 5 | Create and source `scripts/set_secrets.local.sh` locally. | [`config-templates.md`](config-templates.md) |
| 6 | Verify Nanobot with `nanobot status` and `nanobot agent -m "Hello!"`. | [`nanobot-setup.md`](nanobot-setup.md) |
| 7 | Start Nanobot WebUI and verify `http://127.0.0.1:8765` plus LAN access if needed. | [`nanobot-setup.md`](nanobot-setup.md) |
| 8 | Start opencode from the cloned repository and verify it loads `AGENTS.md`. | [`opencode-setup.md`](opencode-setup.md) |
| 9 | Prepare fallback screenshots, mock transcript, and track materials. | [Retreat Materials](#retreat-materials) |
| 10 | Leave the RPi desktop ready with browser, terminal/VS Code, WebUI, and repository open. | [Start State](#start-state) |

## Scripted Setup Option

Use the scripts only on the prepared RPi after reviewing them.

```bash
bash scripts/rpi-bootstrap.sh
cp templates/nanobot-config.example.json ~/.nanobot/config.json
cp templates/opencode.example.json opencode.json
cp scripts/set_secrets.example.sh scripts/set_secrets.local.sh
nano scripts/set_secrets.local.sh
source scripts/set_secrets.local.sh
bash scripts/rpi-start-demo.sh
```

`rpi-bootstrap.sh` installs tools and should be reviewed before execution. `rpi-start-demo.sh` expects the local configs and secrets to exist. The scripts are intended to be executable in Git; using `bash scripts/<name>.sh` also works if executable bits are lost.

## Manual Setup Option

Use this if you do not want to run the scripts.

```bash
uv tool install nanobot-ai
nanobot onboard
cp templates/nanobot-config.example.json ~/.nanobot/config.json
cp templates/opencode.example.json opencode.json
cp scripts/set_secrets.example.sh scripts/set_secrets.local.sh
nano scripts/set_secrets.local.sh
source scripts/set_secrets.local.sh
nanobot status
nanobot agent -m "Hello!"
nanobot gateway
```

Open a second terminal in the repository root:

```bash
source scripts/set_secrets.local.sh
opencode
```

## Shared Workspace
- Create Nextcloud share for the day.
- Prepare a compact cheatsheet with links, ports, contacts, setup commands, track documents, and current status if this is not already covered by the repo files.
- Prepare prompt cards for opencode.
- Prepare documentation templates: `README.md`, `setup.md`, `manual.md`, `deployment.md`, `known-limitations.md`.
- Prepare accessibility and corporate-design input material.
- Prepare Scaddy-V1 reference material for comparison, not for a one-to-one rebuild.

## Nanobot Baseline
- Use the direct RPi/WebUI path as the primary retreat baseline.
- Install Nanobot via `uv tool install nanobot-ai` on the RPi.
- Prepare `~/.nanobot/config.json` from `templates/nanobot-config.example.json`.
- Re-check configured model IDs against the `llm.scads.ai` status overview.
- Add the API key through a local-only environment variable or local-only RPi config.
- Run `nanobot status` and `nanobot agent -m "Hello!"` before the retreat.
- Start `nanobot gateway` and verify WebUI at `http://127.0.0.1:8765` and `http://<rpi-ip>:8765` if LAN access is needed.
- If API integration is needed, enable and test `nanobot serve` on `127.0.0.1:8900` after `nanobot plugins enable api`.
- Prepare fallback screenshots or a mock transcript in case the live setup fails.

## opencode Baseline
- Install opencode on the RPi and any facilitator laptops that need it.
- Prepare `opencode.json` from `templates/opencode.example.json` in the working repository.
- Re-check configured model IDs against the `llm.scads.ai` status overview.
- Verify opencode starts in the working folder with `opencode` after sourcing local secrets.
- Verify edit and shell permissions ask for confirmation.

## Secrets and Config
- Prepare `.env.example` only after the starter project exists.
- Use environment-variable placeholders for secrets in examples.
- Never copy real `~/.nanobot/config.json` into the repository.
- Never commit `scripts/set_secrets.local.sh`, `nanobot.local.json`, `nanobot.env`, `.nanobot/`, or copied local configs with real secrets.
- Verify `.gitignore` still covers `.env*`, tokens, keys, credentials, and local-only config files.

## Retreat Materials
- Prepare role cards for Prompt Navigator, Demo Tester, Accessibility Reviewer, Documentation Lead, Story Lead, and Spec Keeper.
- Prepare one visible success criterion for each feature track.
- Prepare one fallback task per track that can be completed without live model access.

## Start State
- Raspberry Pi 400, monitor, network, and power are ready.
- RPi desktop shows Nanobot WebUI and the shared cheatsheet or repository overview.
- Terminal or VS Code is open in the cloned working repository.
- opencode is started or ready to start in that working folder.

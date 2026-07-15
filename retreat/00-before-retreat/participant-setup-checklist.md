# Participant Setup Checklist

Send this before the retreat. Local installation is done at each participant's own risk; anyone who does not want to install tools can still contribute through pairing, testing, prompting, documentation, and discussion.

## Required Access
- GitLab or GitHub access to the starter repository.
- Browser access to the shared Nextcloud folder or retreat dashboard.
- Access to `llm.scads.ai` tested before the retreat.
- Current browser for Nanobot WebUI and shared documents.

## Required Workshop Readiness
- You can open the shared dashboard.
- You know whether you will work on the shared RPi, your own laptop, or in a pair.
- You can access the Nanobot WebUI URL provided by the organizers.
- You can ask an organizer before entering or storing any API key.

## Recommended Local Tools
- Git installed.
- Editor installed, preferably VS Code.
- Terminal opened and tested once.
- `opencode` installed and connected to `llm.scads.ai` if possible.
- Docker Desktop or Docker Engine installed only if the participant wants to run a sandbox locally. Docker is optional for the retreat.
- Python 3.11+ and `uv` installed only if the participant wants to run Nanobot locally without Docker.

## Optional opencode Quick Check
Use this only if opencode local setup is part of your role.

```bash
opencode --version
OPENCODE_CONFIG=opencode.local.json opencode
```

If `opencode.local.json` does not exist, use the organizer-provided template and add local values only where instructed.

## Nanobot Quick Check
Use this only if local Nanobot setup is part of the participant's role.

```bash
uv tool install nanobot-ai
nanobot --version
nanobot onboard --wizard
nanobot status
nanobot agent -m "Hello!"
nanobot gateway
```

Open `http://127.0.0.1:8765` after `nanobot gateway` starts.

## Safety Notes
- Do not commit `.env`, API keys, access tokens, private config files, or copied local Nanobot config.
- If a setup step asks for a secret, keep it local and ask the organizers if unsure.
- Messenger integrations are not required for the retreat; they create avoidable token and account-management friction.
- Local files such as `opencode.local.json`, `nanobot.local.json`, `nanobot.env`, and `.nanobot/` must stay local-only.

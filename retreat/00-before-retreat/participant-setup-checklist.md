# Participant Setup Checklist

Send this before the retreat. Local installation is done at each participant's own risk; anyone who does not want to install tools can still contribute through pairing, testing, prompting, documentation, and discussion.

## Required Access
- GitLab or GitHub access to the starter repository.
- Browser access to the shared Nextcloud folder or retreat dashboard.
- Access to `llm.scads.ai` tested before the retreat.
- Current browser for Nanobot WebUI and shared documents.

## Recommended Local Tools
- Git installed.
- Editor installed, preferably VS Code.
- Terminal opened and tested once.
- `opencode` installed and connected to `llm.scads.ai` if possible.
- Docker Desktop or Docker Engine installed only if the participant wants to run the prepared sandbox locally.
- Python 3.11+ and `uv` installed only if the participant wants to run Nanobot locally without Docker.

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

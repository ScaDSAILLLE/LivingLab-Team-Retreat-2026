# Participant Setup Checklist

Send this before the retreat. Local installation is done at each participant's own risk; anyone who does not want to install tools can still contribute through pairing, testing, prompting, documentation, and discussion.

## What To Do

Follow these steps in order if you want to prepare your own laptop. The planned workshop target systems are prepared Raspberry Pi 400 devices, so local setup is optional. If you will only work on a shared RPi or in a pair, complete steps 1-2 and skip local installation.

| Step | Action | Required? |
|---:|---|---|
| 1 | Check access to GitHub, Nextcloud/workshop overview if used, `llm.scads.ai`, and the Nanobot WebUI URL provided by organizers. | Yes |
| 2 | Open the repository URL and confirm you can see the workshop files. | Yes |
| 3 | Install Git, `uv`, VS Code, and opencode using the links below. | Optional but recommended |
| 4 | Clone the workshop repository. | Optional if working locally |
| 5 | Start opencode from the repository root. | Optional if using opencode locally |
| 6 | Run the Nanobot quick check only if your role includes local Nanobot setup. | Optional |

## Install Links

| Tool | Purpose | Link |
|---|---|---|
| Git | Version control and cloning the repository | <https://git-scm.com/install/> |
| `uv` | Python package/tool manager used for Nanobot | <https://docs.astral.sh/uv/getting-started/installation/> |
| VS Code | Recommended editor | <https://code.visualstudio.com/download?_exp_download=fb315fc982> |
| opencode | Agent-assisted repository work | <https://opencode.ai/> |

Python is handled through `uv` and does not need separate participant setup.

## Required Access
- GitHub access to the workshop repository.
- Browser access to the shared Nextcloud folder or workshop overview if used.
- Access to `llm.scads.ai` tested before the retreat.
- Current browser for Nanobot WebUI and shared documents.

Repository to clone:

```text
https://github.com/ScaDSAILLLE/LivingLab-Team-Retreat-2026
```

## Required Workshop Readiness
- You can open the workshop repository and shared files.
- You know whether you will work on a prepared Raspberry Pi 400, your own laptop, or in a pair.
- You can access the Nanobot WebUI URL provided by the organizers.
- You can ask an organizer before entering or storing any API key.

## Clone The Repository

```bash
git clone https://github.com/ScaDSAILLLE/LivingLab-Team-Retreat-2026.git
cd LivingLab-Team-Retreat-2026
```

This repository contains the content, tasks, setup notes, and workshop material for the day.

## Optional opencode Quick Check
Use this only if opencode local setup is part of your role. Organizers will provide the final `opencode.json` and local secret setup.

If organizers provide an opencode API key for your local machine, set it as a shell environment variable:

```bash
echo 'export SCADSAI_API_KEY="ihr_aktueller_api_key"' >> ~/.bashrc
source ~/.bashrc
```

```bash
opencode --version
opencode
```

Do not write API keys into `opencode.json` or other shared files. See [`opencode-setup.md`](opencode-setup.md) and [`config-templates.md`](config-templates.md) for details.

## Nanobot Quick Check
Use this only if local Nanobot setup is part of the participant's role.

```bash
uv tool install nanobot-ai
nanobot --version
nanobot onboard
nanobot status
nanobot agent -m "Hello!"
nanobot gateway
```

Open `http://127.0.0.1:8765` after `nanobot gateway` starts.

`nanobot onboard --wizard` is also available if an interactive configuration flow is preferred.

Nanobot repository and docs:
- <https://github.com/HKUDS/nanobot>
- <https://github.com/HKUDS/nanobot/blob/main/docs/configuration.md>

Detailed Nanobot instructions are in [`nanobot-setup.md`](nanobot-setup.md).

## Safety Notes
- Do not commit `.env`, API keys, access tokens, private config files, or copied local Nanobot config.
- If a setup step asks for a secret, keep it local and ask the organizers if unsure.
- Messenger integrations are not required for the retreat; they create avoidable token and account-management friction.
- Local files such as `scripts/set_secrets.local.sh`, `nanobot.local.json`, `nanobot.env`, and `.nanobot/` must stay local-only.

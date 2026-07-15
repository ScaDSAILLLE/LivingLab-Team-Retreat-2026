# Config Templates

## Purpose
Keep configuration reproducible without committing real secrets.

## Files
- [`../../templates/nanobot-config.example.json`](../../templates/nanobot-config.example.json) - safe Nanobot config example for `llm.scads.ai` and LAN WebUI.
- [`../../templates/opencode.example.json`](../../templates/opencode.example.json) - safe opencode config example for `llm.scads.ai`.
- [`../../scripts/set_secrets.example.sh`](../../scripts/set_secrets.example.sh) - local environment-variable export template.

## Values To Fill Before The Retreat
| Value | Used by | Suggested placeholder | Source |
|---|---|---|---|
| API key | Nanobot, opencode | `SCADSAI_LLM_API_KEY` | Local user/team credential from `llm.scads.ai` |
| Nanobot model | Nanobot | `gemma-4` placeholder | Authenticated `llm.scads.ai` model list |
| Coding model | opencode | `minimax-m3` placeholder | Authenticated `llm.scads.ai` model list |
| Alternative models | opencode/Nanobot | `glm-5.2`, `kimi-2.7-code` placeholders | Authenticated `llm.scads.ai` model list |
| WebUI secret | Nanobot WebUI | `NANOBOT_WEBUI_SECRET` | Local workshop password |

## Safe Copy Pattern
Copy examples to local-only paths and edit those files. Run from the repository root:

```bash
cp templates/opencode.example.json opencode.json
cp scripts/set_secrets.example.sh scripts/set_secrets.local.sh
mkdir -p ~/.nanobot
cp templates/nanobot-config.example.json ~/.nanobot/config.json
```

Edit `scripts/set_secrets.local.sh` locally, then source it before starting Nanobot or opencode:

```bash
nano scripts/set_secrets.local.sh
source scripts/set_secrets.local.sh
```

`scripts/set_secrets.local.sh`, `*.local.json`, `nanobot.env`, `.nanobot/`, and `.env*` are ignored by Git.

## Key Placement
Use local environment variables for both tools:

```bash
export SCADSAI_LLM_API_KEY="replace-with-local-key"
export NANOBOT_WEBUI_SECRET="replace-with-local-webui-password"
```

Never commit files with real keys. `opencode.json` should only contain placeholders or `{env:...}` references.

## Where To Verify Values
- Public documentation: <https://llm.scads.ai>
- Status overview: <https://llm.scads.ai/status/>

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
| API key | opencode | `SCADSAI_API_KEY` | Local user/team credential from `llm.scads.ai` |
| API key | Nanobot | `SCADSAI_LLM_API_KEY` | Local user/team credential from `llm.scads.ai`; may be updated with the final Nanobot config |
| Nanobot model | Nanobot | `google/gemma-4-31B-it` | `llm.scads.ai` status overview |
| Coding model | opencode | `MiniMaxAI/MiniMax-M3-MXFP8` | `llm.scads.ai` status overview |
| Alternative model | opencode/Nanobot | `zai-org/GLM-5.2-FP8` | `llm.scads.ai` status overview |
| Alternative coding model | opencode/Nanobot | `moonshotai/Kimi-K2.7-Code` | `llm.scads.ai` status overview |
| WebUI secret | Nanobot WebUI | `NANOBOT_WEBUI_SECRET` | Local workshop password |

## Safe Copy Pattern
Copy examples to local-only paths and edit those files. Run from the repository root:

```bash
cp templates/opencode.example.json opencode.json
cp scripts/set_secrets.example.sh scripts/set_secrets.local.sh
mkdir -p ~/.nanobot
cp templates/nanobot-config.example.json ~/.nanobot/config.json
```

For opencode, the simplest persistent setup is a shell environment variable:

```bash
echo 'export SCADSAI_API_KEY="ihr_aktueller_api_key"' >> ~/.bashrc
source ~/.bashrc
```

For prepared Raspberry Pi systems or shared organizer setup, edit `scripts/set_secrets.local.sh` locally, then source it before starting Nanobot or opencode:

```bash
nano scripts/set_secrets.local.sh
source scripts/set_secrets.local.sh
```

`scripts/set_secrets.local.sh`, `*.local.json`, `nanobot.env`, `.nanobot/`, and `.env*` are ignored by Git.

## Key Placement
Use local environment variables for both tools:

```bash
export SCADSAI_API_KEY="replace-with-local-key"
export SCADSAI_LLM_API_KEY="$SCADSAI_API_KEY"
export NANOBOT_WEBUI_SECRET="replace-with-local-webui-password"
```

Never commit files with real keys. `opencode.json` should only contain placeholders or `{env:...}` references.

## Where To Verify Values
- Public documentation: <https://llm.scads.ai>
- Status overview: <https://llm.scads.ai/status/>
- Status data source: <https://llm.scads.ai/status/state.json>

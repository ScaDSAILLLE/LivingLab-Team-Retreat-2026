# Config Templates

## Purpose
Keep configuration reproducible without committing real secrets.

## Files
- [`../../templates/nanobot-config.example.json`](../../templates/nanobot-config.example.json) - safe Nanobot config example for `llm.scads.ai` and LAN WebUI.
- [`../../templates/opencode.example.json`](../../templates/opencode.example.json) - safe opencode config example for `llm.scads.ai`.

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
cp templates/opencode.example.json opencode.local.json
mkdir -p ~/.nanobot
cp templates/nanobot-config.example.json ~/.nanobot/config.json
```

`opencode.local.json`, `*.local.json`, `nanobot.env`, `.nanobot/`, and `.env*` are ignored by Git.

## Key Placement Options
Preferred for reproducible setup:

```bash
export SCADSAI_LLM_API_KEY="replace-with-local-key"
export NANOBOT_WEBUI_SECRET="replace-with-local-webui-password"
```

Acceptable on the dedicated RPi if the file stays local and protected:
- write the real API key directly into `~/.nanobot/config.json`,
- write the real API key directly into `opencode.local.json`.

Never commit files with real keys.

## Where To Verify Values
- Public documentation: <https://llm.scads.ai>
- API model endpoint, with valid key: `https://llm.scads.ai/v1/models`
- Status overview: <https://llm.scads.ai/status/>

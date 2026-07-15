# opencode Setup

## Purpose
Prepare opencode for repository exploration, documentation work, safe Git workflows, and agent-assisted coding tasks during the retreat.

## Install
Check the current installer before running it. Installation commands may change.

```bash
curl -fsSL https://opencode.ai/install | bash
opencode --version
```

Alternative package-manager installs are documented at <https://opencode.ai/docs/>.

## Config Location
For the retreat, use a project-local `opencode.json` so the working folder is self-contained.

Safe template:

```text
templates/opencode.example.json
```

Project target:

```text
opencode.json
```

`opencode.json` may be committed only if it contains placeholders or environment-variable references, never a real API key.

Start opencode from the repository root:

```bash
opencode
```

## Provider
Provider: `llm.scads.ai` through an OpenAI-compatible endpoint.

Current model IDs from the `llm.scads.ai` status overview:
- Primary opencode model: `MiniMaxAI/MiniMax-M3-MXFP8`
- Alternatives: `zai-org/GLM-5.2-FP8`, `moonshotai/Kimi-K2.7-Code`

Re-check the exact IDs before the retreat via <https://llm.scads.ai/status/> or <https://llm.scads.ai/status/state.json>.

## Key Handling
The template uses an environment variable by default:

```bash
source scripts/set_secrets.local.sh
```

Do not write the API key into `opencode.json`. If a separate local config with a real key is created for debugging, it must stay ignored and local-only.

## Verify
From the cloned working folder:

```bash
source scripts/set_secrets.local.sh
opencode
```

Inside opencode, verify:
- the configured model is selected,
- `AGENTS.md` is loaded as project guidance,
- the agent can answer a simple repository question,
- file edits and shell commands ask for confirmation.

## Useful First Prompts
```text
Explain this repository for a participant who has never used opencode before. Keep it short and point to the relevant workshop files.
```

```text
Check the repository state safely. Do not read .env files, local configs, keys, credentials, or .nanobot directories.
```

## Restart Requirement
opencode reads config at startup. After editing `opencode.json`, quit and restart opencode.

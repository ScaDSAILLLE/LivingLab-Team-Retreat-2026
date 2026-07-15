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
For the retreat, prefer a project-local config template so the working folder is self-contained.

Safe template:

```text
templates/opencode.example.json
```

Possible local target:

```text
opencode.local.json
```

`opencode.local.json` is ignored by Git and may contain local endpoint or key information. Do not commit it.

Start opencode with an explicit local config if needed:

```bash
OPENCODE_CONFIG=opencode.local.json opencode
```

If a checked-in `opencode.json` is added later, it must not contain a real API key.

## Provider
Provider: `llm.scads.ai` through an OpenAI-compatible endpoint.

Candidate model IDs to verify against the authenticated `llm.scads.ai` model list:
- Primary opencode model: `minimax-m3`
- Alternatives: `glm-5.2`, `kimi-2.7-code`

The exact IDs must be confirmed before the retreat and inserted into the local config or checked-in example placeholders.

## Key Handling
The template uses an environment variable by default:

```bash
export SCADSAI_LLM_API_KEY="replace-with-local-key"
```

If the key is written directly into a local opencode config, that file must stay ignored and local-only.

## Verify
From the cloned working folder:

```bash
OPENCODE_CONFIG=opencode.local.json opencode
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
opencode reads config at startup. After editing `opencode.local.json` or `opencode.json`, quit and restart opencode.

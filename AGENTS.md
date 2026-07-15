# AGENTS.md

## Repository Shape
- This repository is currently a workshop-content repository for the 2026 Living Lab Retreat; `retreat/` contains agenda blocks, facilitator material, setup notes, and templates.
- No root manifest, lockfile, CI workflow, task runner, formatter, linter, or test config is present. Do not invent `npm`, `pytest`, `make`, or similar verification commands unless new files add them.
- `.gitignore` is a broad Python template, but there is no verified Python package or runtime configuration in the repo.
- Starter code with `uv` is planned but not present yet; keep setup instructions clearly marked as documented plans unless executable files are added.

## Working Guidance
- Prefer adding retreat content as Markdown or other plain project artifacts unless the user asks for code or a specific format.
- If adding tooling later, include the executable config and update this file with the exact commands future agents should run.
- Workshop materials should be written in English, while user-facing collaboration can be German if the user uses German.
- Nanobot already has a WebUI; do not recreate an early custom-UI slot unless the agenda changes again.

## Sensitive Files
- Never read, print, summarize, or copy `.env` files or files that appear to contain secrets, credentials, private keys, tokens, or local-only config. Use filename-only checks such as `glob` if needed.
- Treat `scripts/set_secrets.local.sh`, `nanobot.local.json`, `nanobot.env`, `.nanobot/`, any `*.local.json`, and any `*.local.sh` as sensitive local config unless the user explicitly says otherwise.
- If a task seems to require inspecting a sensitive config or you are unsure whether a file is safe, ask the user before opening it.
- Keep `.gitignore` updated when adding tooling or local configs so vulnerable files stay untracked.

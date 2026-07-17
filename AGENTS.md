# AGENTS.md

## Repository Purpose
- This repository contains workshop content and setup material for the 2026 Living Lab Retreat.
- The working object is a Nanobot-based Scaddy-V2-style demonstrator explored with opencode, Nanobot WebUI, Raspberry Pi target systems, and Digital Living Lab / HPC deployment perspectives.
- The repository is primarily Markdown documentation plus safe config templates and helper scripts. It is not currently an application repository.

## Repository Shape
- `retreat/` contains the block-by-block agenda, facilitator guidance, setup notes, templates, and expected outputs.
- `retreat/00-before-retreat/` contains participant setup, organizer prep, Nanobot/opencode setup, RPi notes, and config-template guidance.
- `templates/` contains safe example config files, including `opencode.example.json` and `nanobot-config.example.json`.
- `scripts/` contains helper scripts for Raspberry Pi bootstrap/start and local secret export examples.
- `starter/` has intentionally been removed; do not refer to starter code unless new executable starter material is added.
- There is no root manifest, lockfile, CI workflow, task runner, formatter, linter, or test config. Do not invent `npm`, `pytest`, `make`, or similar commands.

## Workshop Flow
- The retreat is documented in numbered blocks under `retreat/`.
- Current flow: preparation -> welcome -> Nanobot exploration -> Scaddy-V2 scoping -> opencode daily work -> design spec -> first UI improvement -> midday check -> feature tracks -> Digital Living Lab/HPC deployment -> docs finalization -> pitches -> SWOT/Vision 2030.
- Blocks should keep the established structure where practical: title, time, purpose, key question, objectives, content/workflow, expected output, moderation notes.
- `Expected Output` should be singular for section naming consistency.
- Moderation notes should usually be the final section in block files.

## Content Guidance
- Workshop materials should be written in English.
- User-facing collaboration can be German if the user uses German.
- Prefer Markdown and plain project artifacts unless the user explicitly requests code or another format.
- Keep content practical, facilitator-ready, and concise enough for the timebox.
- Preserve the distinction between setup-before-workshop, in-workshop activity, and post-workshop reference material.
- Nanobot already has a WebUI. Custom UI work is only relevant where the agenda explicitly calls for improving the Nanobot demo UI based on the shared design spec.
- PR/communications, Living Lab, HPC/deployment, researchers, developers, and non-coders are all first-class perspectives in the material.

## Current Technical Baseline
- opencode uses `SCADSAI_API_KEY` through `opencode.json` / `templates/opencode.example.json`.
- Nanobot config also uses `SCADSAI_API_KEY` through `templates/nanobot-config.example.json`.
- Only one `llm.scads.ai` API key should be needed for both tools.
- Local persistent shell setup is documented as:

```bash
echo 'export SCADSAI_API_KEY="ihr_aktueller_api_key"' >> ~/.bashrc
source ~/.bashrc
```

- `scripts/set_secrets.example.sh` is a safe template. Real secrets belong only in ignored local files such as `scripts/set_secrets.local.sh` or the user's shell environment.
- `scripts/rpi-bootstrap.sh` installs required packages, `uv`, Nanobot via `uv tool install nanobot-ai`, and opencode. It may optionally run `nanobot onboard`, but avoid rerunning onboard if it would overwrite prepared local Nanobot config.
- `scripts/rpi-start-demo.sh` expects local config and secrets to already exist, then starts Nanobot gateway and opens opencode.

## Verification Commands
Only run commands that correspond to existing files. Current useful checks are:

```bash
python3 -m json.tool templates/opencode.example.json >/tmp/opencode-example.json.validated
python3 -m json.tool templates/nanobot-config.example.json >/tmp/nanobot-config-example.json.validated
python3 -m json.tool opencode.json >/tmp/opencode.json.validated
bash -n scripts/rpi-bootstrap.sh
bash -n scripts/rpi-start-demo.sh
bash -n scripts/set_secrets.example.sh
```

- Do not run Nanobot/opencode installer or startup commands unless the user asks or the task is explicitly setup verification on the prepared machine.
- Do not run `nanobot onboard` casually; it can rewrite local config.

## Sensitive Files
- Never read, print, summarize, copy, or commit `.env` files or files that appear to contain secrets, credentials, private keys, tokens, or local-only config.
- Treat `scripts/set_secrets.local.sh`, `nanobot.local.json`, `nanobot.env`, `.nanobot/`, any `*.local.json`, any `*.local.sh`, private keys, token files, and copied local Nanobot/opencode configs as sensitive unless the user explicitly says otherwise.
- Filename-only checks with `glob` or `git status` are okay; do not open sensitive files.
- If a task seems to require inspecting a sensitive config, ask the user before opening it.
- Keep `.gitignore` updated when adding tooling, local configs, generated state, or secret-bearing files.

## Git And Collaboration
- The worktree may contain user changes. Do not revert or overwrite changes you did not make.
- Before committing, inspect `git status --short`, the relevant `git diff`, and recent commits.
- Stage only intended files.
- Commit messages should be concise and factual, matching the existing style.
- Do not amend commits unless the user explicitly asks.

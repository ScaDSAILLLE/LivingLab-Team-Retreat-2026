# Organizer Prep Checklist

## Shared Workspace
- Create Nextcloud share for the day.
- Prepare a retreat dashboard with links, ports, contacts, setup commands, track documents, and current status.
- Prepare prompt cards for opencode.
- Prepare documentation templates: `README.md`, `setup.md`, `manual.md`, `deployment.md`, `known-limitations.md`.
- Prepare accessibility and corporate-design input material.
- Prepare Scaddy-V1 reference material for comparison, not for a one-to-one rebuild.

## Nanobot Baseline
- Decide whether the baseline runs from PyPI via `uv tool install nanobot-ai`, from source, or in Docker.
- Run `nanobot status` and `nanobot agent -m "Hello!"` before the retreat.
- Start `nanobot gateway` and verify WebUI at `http://127.0.0.1:8765`.
- If API integration is needed, enable and test `nanobot serve` on `127.0.0.1:8900` after `nanobot plugins enable api`.
- Prepare fallback screenshots or a mock transcript in case the live setup fails.

## Secrets and Config
- Prepare `.env.example` only after the starter project exists.
- Use environment-variable placeholders for secrets in examples.
- Never copy real `~/.nanobot/config.json` into the repository.
- Verify `.gitignore` still covers `.env*`, tokens, keys, credentials, and local-only config files.

## Retreat Materials
- Prepare role cards for Prompt Navigator, Demo Tester, Accessibility Reviewer, Documentation Lead, Story Lead, and Spec Keeper.
- Prepare one visible success criterion for each feature track.
- Prepare one fallback task per track that can be completed without live model access.

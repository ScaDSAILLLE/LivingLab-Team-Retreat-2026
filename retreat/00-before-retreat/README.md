# 00 - Before the Retreat

**Time:** Before the retreat

## Purpose
Prepare the shared workspace and the Raspberry Pi target system so the retreat can focus on learning, collaboration, and demonstrator decisions instead of setup friction.

## Start Here

| Audience | Read this | Purpose |
|---|---|---|
| Participants | [`participant-setup-checklist.md`](participant-setup-checklist.md) | Access, install links, optional local tools, safety notes |
| Organizers | [`organizer-prep-checklist.md`](organizer-prep-checklist.md) | Shared workspace, materials, fallbacks |
| RPi operator | [`rpi-start-state.md`](rpi-start-state.md), [`rpi-target-system.md`](rpi-target-system.md) | Hardware, network, Nanobot WebUI, opencode workspace |
| Technical setup | [`nanobot-setup.md`](nanobot-setup.md), [`opencode-setup.md`](opencode-setup.md) | Install, configure, and verify the toolchain |
| Template maintainers | [`config-templates.md`](config-templates.md) | Safe config examples and local secret setup |
| Facilitators | [`cheatsheet-template.md`](cheatsheet-template.md) | Optional one-page cheatsheet for repo or Nextcloud |

## Key Question
What must be ready before 10:00 so participants can start without losing workshop time?

## Objectives
- Participants can access the repository, shared files, Nanobot demo surface, opencode, and `llm.scads.ai`.
- Organizers have a working Nanobot baseline and fallback material.
- The Raspberry Pi target system has a documented first deployment path.
- Real secrets are never committed; `.env.example` and documented environment variables are used instead.

## Must Be Ready Before 10:00
- Raspberry Pi 400 powered, networked, and reachable from the workshop room.
- Nanobot installed, configured for `llm.scads.ai`, and running through `nanobot gateway`.
- Nanobot WebUI reachable from the RPi browser and, if needed, other devices on the workshop network.
- opencode installed and configured in the working folder of the cloned Nanobot or starter repository.
- Browser, terminal, and optionally VS Code opened on the RPi desktop.
- The repository or Nextcloud overview is open with current links, ports, roles, and fallback status.
- No real API keys, `.env` files, local Nanobot configs, or local opencode configs committed to Git.

## Scope
- The primary workshop path is a dedicated RPi with direct Nanobot WebUI access on the trusted local network.
- Reverse proxies, containers, TLS, and service management are out of scope for the start setup unless prepared separately for later production use.

## Expected Output
- Participant setup checklist sent in advance.
- Organizer prep checklist completed.
- Optional retreat cheatsheet prepared in Nextcloud or the repo.
- RPi target-system notes prepared for the concrete start state.
- `.env.example` prepared later when the starter code exists, never a real `.env` file.
- Nanobot and opencode config templates prepared with placeholders only.
- Bootstrap/start commands tested or clearly marked as unverified for the chosen RPi image.

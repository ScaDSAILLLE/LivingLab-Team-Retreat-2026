# 00 - Before the Retreat

**Time:** Before the retreat

## Purpose
Prepare the shared workspace and the Raspberry Pi target system so the retreat can focus on learning, collaboration, and demonstrator decisions instead of setup friction.

## Start Here

| Audience | Read this | Purpose |
|---|---|---|
| Participants | [`participant-setup-checklist.md`](participant-setup-checklist.md) | Access, optional local tools, safety notes |
| Organizers | [`organizer-prep-checklist.md`](organizer-prep-checklist.md) | Shared workspace, materials, fallbacks |
| RPi operator | [`rpi-start-state.md`](rpi-start-state.md), [`rpi-target-system.md`](rpi-target-system.md) | Hardware, network, Nanobot WebUI, opencode workspace |
| Technical setup | [`nanobot-setup.md`](nanobot-setup.md), [`opencode-setup.md`](opencode-setup.md) | Install, configure, and verify the toolchain |
| Template maintainers | [`config-templates.md`](config-templates.md) | Safe config examples without real API keys |
| Facilitators | [`dashboard-template.md`](dashboard-template.md) | Links, ports, roles, current status |

## Key Question
What must be ready before 10:00 so participants can start without losing workshop time?

## Objectives
- Participants can access the repository, shared files, Nanobot demo surface, opencode, and `llm.scads.ai`.
- Organizers have a working Nanobot baseline and fallback material.
- The Raspberry Pi target system has a documented first deployment path.
- Real secrets are never committed; `.env.example` and documented environment variables are used instead.

## Must Be Ready Before 10:00
- RPi powered, networked, and reachable from the workshop room.
- Nanobot installed, configured for `llm.scads.ai`, and running through `nanobot gateway`.
- Nanobot WebUI reachable from the RPi browser and, if needed, other devices on the workshop network.
- opencode installed and configured in the working folder of the cloned Nanobot or starter repository.
- Browser, terminal, and optionally VS Code opened on the RPi desktop.
- Shared dashboard open with current links, ports, roles, and fallback status.
- No real API keys, `.env` files, local Nanobot configs, or local opencode configs committed to Git.

## Optional Hardening
- Docker sandboxing, Nginx, TLS, systemd services, and stricter workspace isolation are recommended for longer-term or production use.
- For the retreat, they should be treated as best-practice discussion points unless they are already prepared and tested.
- The primary workshop path is a dedicated RPi with direct Nanobot WebUI access on the trusted local network.

## Expected Outputs
- Participant setup checklist sent in advance.
- Organizer prep checklist completed.
- Shared retreat dashboard prepared in Nextcloud or the repo.
- RPi target-system notes with open decisions marked.
- `.env.example` prepared later when the starter code exists, never a real `.env` file.
- Nanobot and opencode config templates prepared with placeholders only.
- Bootstrap/start commands tested or clearly marked as unverified for the chosen RPi image.

## Discussion Prompts
- Which setup steps are reasonable to ask from participants before a retreat?
- What must work for non-coders to contribute from minute one?
- Which parts should run locally, on the RPi, or on central/HPC resources?
- Which credentials or local configs must never enter Git?

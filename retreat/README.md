# Scaddy-V2 Developer Retreat 2026

This folder contains the agenda and working material for the Living Lab Retreat 2026.

The retreat is organized as a learning and build curve:

> Experience -> compare -> enable -> specify -> stabilize -> sprint -> deploy -> document -> pitch -> reflect

The concrete working object is a Nanobot-based Scaddy-V2-style demonstrator. Nanobot WebUI is used as the baseline interface for the workshop. Custom UI work is optional and should only be pursued if it directly supports the workshop objectives.

The demonstrator is the concrete investigation object for this retreat, but the method is transferable. Future versions can use another demonstrator, prototype, or technical system if it is scoped small enough for a mixed team to explore, adapt, document, and assess with opencode, coding agents, or agentic assistants.

## Schedule

| Time | Block | Outcome |
|---:|---|---|
| Before | [Preparation](00-before-retreat/) | Access, shared workspace, target-system setup, fallback material |
| 10:00 | [Welcome and framing](01-welcome-framing/) | Shared objective and team perspectives |
| 10:15 | [Explore Nanobot](02-explore-nanobot/) | First WebUI experience and capability notes |
| 10:30 | [Nanobot to Scaddy-V2](03-nanobot-to-scaddy-v2/) | Demonstrator scope and comparison with Scaddy-V1 |
| 10:45 | [AI pair programming](04-ai-pair-programming-opencode/) | opencode workflows, prompt patterns, safe Git |
| 11:30 | [Demo spec and accessibility](05-demo-spec-accessibility-cd/) | Shared demo/coding spec |
| 12:30 | [Baseline stabilization](06-baseline-stabilization/) | Setup notes, repo hygiene, fallback status |
| 12:55 | [Midday check](07-midday-check/) | Current status and afternoon needs |
| 13:00 | Lunch | Break |
| 14:00 | [Re-entry plan](08-reentry-plan/) | Track assignments and success criteria |
| 14:10 | [Feature tracks](09-feature-tracks/) | Knowledge, vision, voice, or hardening result |
| 14:55 | [Deployment](10-deployment/) | RPi, Nginx, Docker/uv, operations notes |
| 15:20 | [Repo and docs finalization](11-repo-docs-finalization/) | Start, manual, deployment, limitations, demo story |
| 15:45 | [Demo pitches](12-demo-pitches/) | Short track demos and learnings |
| 16:05 | [SWOT and closing](13-swot-closing/) | Follow-up actions and responsibilities |

## Objectives

By the end of the retreat, participants should have:

- explored Nanobot as a practical foundation for AI demonstrators,
- compared Nanobot capabilities with the Scaddy-V1 reference,
- practiced opencode for exploration, documentation, safe changes, and daily work,
- defined a shared demo specification including accessibility and corporate design criteria,
- created or assessed small feature extensions around knowledge, vision, voice, or hardening,
- documented setup, operation, limitations, and deployment considerations,
- reflected on responsibilities across Living Lab, PR, HPC/deployment, development, and research.

## Collaboration

The retreat is not only a coding workshop. It is designed to make different perspectives visible:

- Living Lab: visitor experience, demonstrator value, public setting.
- PR/communications: clarity, accessibility, wording, visual consistency.
- HPC/deployment: operations, secrets, persistence, logs, reliability.
- Developers: maintainability, architecture, interfaces, implementation tradeoffs.
- Researchers: scientific accuracy, model behavior, responsible communication.
- Non-coders: prompting, testing, documentation, story, accessibility review, specification work.

Each block should produce either a visible artifact, a shared decision, or a clarified responsibility.

## Flow
1. Preparation and target-system setup before the retreat.
2. Welcome, framing, and shared objective.
3. Explore Nanobot and its WebUI.
4. Compare Nanobot with Scaddy-V1 and define the Scaddy-V2 demonstrator scope.
5. Practice opencode for exploration, documentation, safe changes, and everyday work.
6. Define demo design, accessibility, corporate design, and interaction specification.
7. Stabilize the baseline: repo hygiene, setup docs, prompts, fallback material.
8. Lunch and re-entry.
9. Parallel feature tracks: knowledge, vision, voice, hardening.
10. Deployment and Raspberry Pi target-system walkthrough.
11. Repository, documentation, and demo finalization.
12. Demo pitches, SWOT, responsibilities, and next steps.

## Block Map

- 🧰 [`00-before-retreat`](00-before-retreat/) - participant setup, organizer prep, RPi target system, shared dashboard.
- 🎯 [`01-welcome-framing`](01-welcome-framing/) - framing, goals, roles, perspective exchange.
- 🧪 [`02-explore-nanobot`](02-explore-nanobot/) - Nanobot WebUI and first success tasks.
- 🔎 [`03-nanobot-to-scaddy-v2`](03-nanobot-to-scaddy-v2/) - Scaddy-V1 comparison and demonstrator scope.
- 🤝 [`04-ai-pair-programming-opencode`](04-ai-pair-programming-opencode/) - opencode practice, prompt patterns, safe Git.
- 🧭 [`05-demo-spec-accessibility-cd`](05-demo-spec-accessibility-cd/) - combined demo spec, accessibility, corporate design, UI implications.
- 🧱 [`06-baseline-stabilization`](06-baseline-stabilization/) - repo, docs, setup, fallback, known limitations.
- ☑️ [`07-midday-check`](07-midday-check/) - status before lunch.
- 🔁 [`08-reentry-plan`](08-reentry-plan/) - afternoon planning and track selection.
- 🛠️ [`09-feature-tracks`](09-feature-tracks/) - knowledge, vision, voice, demo hardening.
- 🚀 [`10-deployment`](10-deployment/) - deployment input, RPi/Nginx/Docker notes, operations questions.
- 📚 [`11-repo-docs-finalization`](11-repo-docs-finalization/) - final documentation and demo packaging.
- 🎤 [`12-demo-pitches`](12-demo-pitches/) - pitch structure.
- 🧩 [`13-swot-closing`](13-swot-closing/) - SWOT, Vision 2030, follow-up actions.

## Reuse For Future Workshops

To reuse this structure, replace the concrete demonstrator context and keep the block logic:

- prepare setup and fallback material before the event,
- start with a shared working system,
- compare current capabilities with the target vision,
- teach agent-assisted work practices,
- define a shared specification before feature work,
- keep feature tracks small and demonstrable,
- include deployment and operations explicitly,
- finish with documentation, pitches, and reflection.

## Facilitation Principle

Every technical step should also expose one non-technical perspective: usability, accessibility, communication, operation, privacy, maintenance, or public-demo value.

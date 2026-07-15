# Living Lab Retreat Workshop Repository

This repository contains workshop material for a Living Lab team retreat focused on building, understanding, documenting, and operating AI demonstrators.

The immediate workshop context is the Scaddy-V2 Developer Retreat 2026. The structure is intentionally reusable: future Living Lab demonstrator workshops can copy the agenda blocks, setup checklists, prompt cards, documentation templates, and deployment notes.

## Purpose

The workshop uses a shared working object as a learning and collaboration format. For this retreat, the working object is a Nanobot-based Scaddy-V2-style demonstrator. In future workshops, this object can be replaced by another demonstrator, prototype, or technical system if the scope remains practical for opencode, coding agents, or agentic assistants in general.

Participants from Living Lab, PR/communications, HPC/deployment, web app and AI development, and AI research work on the same prototype from different perspectives.

The goals are to:

- create a small Nanobot-based Scaddy-V2-style demonstrator,
- make team responsibilities, constraints, and expertise visible,
- practice opencode for coding and non-coding work,
- produce reusable setup, documentation, prompt, and deployment material,
- identify follow-up actions for future Living Lab demonstrators.

## Repository Structure

- `retreat/` contains the workshop agenda, block instructions, facilitator notes, discussion questions, and expected outputs.
- `templates/` contains reusable prompt cards and documentation templates.
- `starter/` is reserved for future starter-code material and `uv` setup notes.
- `AGENTS.md` contains guidance for future OpenCode sessions working in this repository.

## How To Use This Repository

Start with [`retreat/README.md`](retreat/README.md) for the workshop flow.

Each agenda block is stored in its own folder. The block files describe:

- purpose,
- key questions,
- objectives,
- facilitator instructions,
- participant tasks,
- expected outputs,
- prompts or fallback material where useful.

For a new workshop, copy the folder structure and adjust the concrete demonstrator, timeboxes, roles, and deployment target.

## Current Technical Baseline

The planned demonstrator foundation is Nanobot with its existing WebUI. The target setup uses a Raspberry Pi system, direct WebUI access on the workshop network, `uv`-based installation, opencode, and careful handling of secrets.

No executable starter application is present yet. Do not assume build, test, lint, or run commands unless matching configuration files are added.

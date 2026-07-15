# Demo Spec, Accessibility, Corporate Design, and PR Perspective

**Time:** 11:30-12:30

## Purpose
Create a shared Markdown specification for the Scaddy-V2 demonstrator. The block brings together PR/communications input, accessibility expectations, corporate design, Living Lab templates, university guidelines, and the practical constraints of the Nanobot-based demo.

## Key Question
What must the demonstrator look, say, and do so that it is understandable, accessible, institutionally consistent, and feasible for today?

## Objectives
- Make the PR/communications perspective explicit: accessibility, clarity, wording, trust, visual consistency, and public suitability.
- Use Living Lab templates and university or institutional guidelines as practical design inputs.
- Collect sources in Nextcloud so nobody needs Git knowledge to contribute material.
- Use opencode to turn links, notes, templates, and examples into a concise `demo-spec.md` or `coding-spec.md`.
- Prepare a careful opencode-driven UI change workflow for the Nanobot instance on the Raspberry Pi.
- Define must-have and nice-to-have criteria for the afternoon work.

## Inputs and Source Collection
Collect relevant material in a shared Nextcloud folder before or during the block. This is the primary handover point for PR, Living Lab, and anyone who does not work with Git.

Useful sources:
- PR/communications notes on wording, public tone, accessibility, and visual quality.
- University or institutional corporate design and accessibility guidelines.
- Living Lab templates, slide styles, website examples, print material, icons, or prior demo layouts.
- Scaddy-V1 references and lessons learned.
- Nanobot screenshots, WebUI observations, setup notes, or demo constraints.
- Public links to guideline pages or template repositories.

Only clone repositories or copy files into a working folder if this helps opencode inspect the material. Do not use private, unpublished, license-restricted, or confidential material unless it is explicitly cleared for workshop use.

## Suggested Time Split
- 10 minutes: PR/communications input on accessibility, clarity, public wording, visual trust, and corporate design.
- 10 minutes: Living Lab input on templates, visitor context, Scaddy references, and demo setting.
- 10 minutes: collect or review sources from Nextcloud and public links.
- 20 minutes: use opencode to draft the shared Markdown spec.
- 10 minutes: group review, acceptance criteria, and UI implementation handoff.

## Working Method With opencode
Use opencode as a specification assistant, not as the final design authority.

1. Put safe source material from Nextcloud into a prepared working folder, or provide a short source list with links and notes.
2. Ask opencode to extract requirements, recommendations, constraints, and open questions.
3. Draft `demo-spec.md` or `coding-spec.md`.
4. Review the result with PR, Living Lab, developers, researchers, and operations.
5. Mark what is mandatory today, optional today, and postponed.
6. After the spec is accepted, use opencode on the Raspberry Pi to plan and implement UI changes against the local Nanobot code.

Example prompt:

```text
We are creating a public demo specification for a Nanobot-based Scaddy-V2 demonstrator.

Use the files, notes, links, or template material in [FOLDER OR SOURCE LIST].
Extract requirements for accessibility, public wording, corporate design, visual tone, demo interaction, error communication, and today's acceptance criteria.

Separate:
1. must-have requirements for today,
2. nice-to-have improvements,
3. open questions for PR/Living Lab,
4. things that should not be changed today.

Draft the result as a concise Markdown specification.
Do not invent institutional rules. Mark missing facts as TODO.
```

## UI Change Handoff
After the group agrees on the design spec, switch from specification work to a controlled UI-change workflow on the prepared Raspberry Pi.

Do not ask opencode to directly "make it look better". First ask for a plan, then review the plan, then allow a small build step.

Step-by-step:
1. Open opencode in the prepared Nanobot working folder on the Raspberry Pi.
2. Point opencode to the agreed `demo-spec.md` or `coding-spec.md` and any copied template assets or notes.
3. Ask opencode to identify the relevant Nanobot files, templates, styles, configuration points, or extension hooks for the requested UI change.
4. Ask for a plan first: what will change, why, which files are involved, how to test it, and how to restart the service.
5. Review the plan with PR/Living Lab and at least one technical participant.
6. Approve only a small, concrete build step.
7. Ask opencode to explain the changes and the restart procedure after implementation.
8. Test the WebUI in the browser and compare it against the spec.

Use a prompt like this:

```text
We have agreed on the attached demo specification for a Nanobot-based Scaddy-V2 demonstrator.

First, inspect the local Nanobot code and identify the files, templates, style definitions, configuration points, or extension hooks relevant for the UI changes described in [SPEC FILE].

Do not edit files yet.

Create a plan that explains:
1. which UI changes are feasible today,
2. which files or settings would be touched,
3. which changes are risky or should be postponed,
4. how the result should be tested in the browser,
5. how Nanobot must be restarted after changes.
```

Only after the plan is reviewed, use a build prompt:

```text
Implement only the approved UI changes from the reviewed plan.
Keep the change small and reversible.
Afterwards, summarize what changed, which files were touched, how to restart Nanobot, and how to verify the result in the browser.
Do not read or modify secrets, .env files, local credentials, or unrelated configuration.
```

## Review Lenses
PR/communications should focus on:
- clear, inclusive, non-hyped language,
- public trust and institutional quality,
- responsible wording around AI-generated output, uncertainty, and limitations,
- accessibility basics such as contrast, text size, plain language, keyboard navigation, and visible system states.

Living Lab should focus on:
- visitor journey and demo setting,
- available templates and visual references,
- Scaddy-V1 lessons,
- what must be recognizable as Living Lab,
- what can remain Nanobot-default for now.

Technical participants should focus on:
- what Nanobot WebUI already supports,
- what can be configured quickly,
- what would require custom UI work,
- where the relevant Nanobot code or configuration likely lives,
- how a safe restart and browser test should work,
- what should be postponed.

## Spec Structure
The shared Markdown spec should be short and actionable:

```md
# Demo Specification

## Demo Goal
## Target Audience and Setting
## Core User Journey
## Tone of Voice
## Accessibility Requirements
## Corporate Design Requirements
## Template and Guideline Sources
## Nanobot/WebUI Constraints
## Required Changes Today
## Optional Changes Today
## Non-Goals
## Open Questions
## Acceptance Criteria
```

## Discussion Questions
- What would confuse or exclude a first-time visitor?
- Which design and accessibility requirements are mandatory today?
- Which corporate design rules matter now, and which can be documented for later?
- What can Nanobot WebUI provide without custom UI work?
- Where do visual quality, accessibility, feasibility, and time constraints conflict?

## Expected Output
- A shared `demo-spec.md` or `coding-spec.md`.
- A Nextcloud source folder or source list for design, accessibility, and corporate design inputs.
- Clear must-have and nice-to-have criteria for the afternoon tracks.
- A reviewed opencode plan for the first UI changes in the Nanobot code on the Raspberry Pi.
- Open questions marked clearly instead of silently guessed.

## Moderation Notes
- Give PR and Living Lab the lead in this block.
- Keep developers in listening/specification mode first.
- Keep source collection accessible through Nextcloud, not Git-only workflows.
- Avoid jumping into UI implementation too early.
- Move to UI implementation only after the group has accepted the spec.
- Keep the first UI change small; the goal is a controlled start, not a full redesign.
- Use opencode to structure and draft, but keep final design and public communication decisions human-led.

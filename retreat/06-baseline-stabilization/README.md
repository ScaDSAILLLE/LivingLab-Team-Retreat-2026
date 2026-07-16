# Improve the UI and Stabilize the First Version

**Time:** 12:30-12:55

## Purpose
Apply the shared design specification to the local Nanobot demo and create a functional first UI version that better follows the agreed corporate design, accessibility, and public-demo requirements.

## Key Question
How well does the current UI match the shared specification, and what is the smallest useful improvement we can safely implement now?

## Objectives
- Use the agreed `demo-spec.md` or `coding-spec.md` as the source of truth.
- Ask opencode to identify the relevant Nanobot files, templates, styles, configuration points, or extension hooks on the Raspberry Pi.
- Review an implementation plan before changes.
- Implement one small approved UI change toward the agreed corporate design and spec.
- Restart Nanobot, test the WebUI, and record what changed.
- Make 1-2 small refinements if time allows.

## Inputs
- Agreed `demo-spec.md` or `coding-spec.md` from Block 05.
- Nextcloud source folder or source list with templates, screenshots, links, or notes.
- Prepared Nanobot working folder on the Raspberry Pi.
- Running Nanobot/WebUI baseline.
- Local setup notes needed for restart.

## Step-by-Step Workflow
1. Open opencode in the Nanobot working folder on the Raspberry Pi.
2. Reference the agreed design spec and safe source material.
3. Ask for a plan first. No edits yet.
4. Review the plan with PR/Living Lab and one technical participant.
5. Approve one small visible UI change.
6. Let opencode implement only that approved change.
7. Ask opencode to explain touched files, restart steps, and browser verification.
8. Restart Nanobot as instructed.
9. Test the WebUI against the design spec.
10. If time allows, do 1-2 small refinements.
11. Record current status, known limitations, and next steps.

## Plan Prompt
```text
We have agreed on [SPEC FILE] for the Nanobot-based Scaddy-V2 demonstrator.

Inspect the local Nanobot code on this Raspberry Pi.
Identify the files, templates, style definitions, configuration points, or extension hooks relevant for the UI requirements in the spec.

Also consider the safe source material in [NEXTCLOUD EXPORT, LOCAL FOLDER, OR SOURCE LIST], if available.

Do not edit files yet.

Create a short implementation plan:
1. one small UI change feasible before lunch,
2. files or settings likely to be touched,
3. risks and rollback considerations,
4. how to test the result in the browser,
5. how Nanobot should be restarted after changes.
```

## Build Prompt
```text
Implement only the approved UI change from the reviewed plan.

Keep the change small and reversible.
The result should be a functional UI improvement that follows [SPEC FILE] and the agreed corporate design direction.
Do not read or modify secrets, .env files, local credentials, or unrelated configuration.

Afterwards, summarize:
1. what changed,
2. which files were touched,
3. how to restart Nanobot,
4. how to verify the result in the browser,
5. what should be refined next if time allows.
```

## Refinement Prompt
```text
Compare the current UI against [SPEC FILE].
Suggest at most two small refinements that would improve accessibility, corporate design alignment, or public-demo clarity.
Do not edit files yet.
```

If a refinement is approved:

```text
Implement only the approved refinement.
Keep it small and explain how to verify it in the browser.
Do not touch secrets, credentials, .env files, or unrelated configuration.
```

## Discussion Questions
- Does the changed UI visibly follow the design spec better than before?
- Is the interface still functional after restart?
- Did the change improve accessibility, wording, visual consistency, or public-demo clarity?
- What should be refined after lunch instead of rushed now?

## Expected Output
- A functional first UI version aligned with the shared spec and corporate design direction.
- Restart and browser verification steps.
- Short baseline status before lunch.
- 1-2 refinement results or follow-up tasks for the afternoon.

## Moderation Notes
- Keep the scope tiny; one visible improvement is enough.
- Do not start a full custom UI rewrite.
- PR/Living Lab should verify visible outcome, wording, and design fit.
- Technical participants should verify touched files, restart, and operational risk.
- If implementation becomes unclear, stop after the reviewed plan and carry it into the afternoon.

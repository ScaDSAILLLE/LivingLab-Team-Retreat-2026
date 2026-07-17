# Repository, Documentation, and Demo Finalization

**Time:** 15:25-15:50

## Purpose
Turn the workshop result into a traceable and reusable demonstrator package that another person can understand, start, operate, review, and continue after the retreat.

## Key Question
Can another person understand what was built, how to start it, what is stable, what is fragile, and what should happen next? Are we ready to deploy this now to our Digital Living Lab?

## Objectives
- **For colleagues who are not familiar with Git**: use opencode to learn or focus on your strengths, for example documenting progress and what you did or solved.
- Clean up the repository and documentation state before the final pitches.
- Capture setup, operation, limitations, deployment notes, and demo story.
- Make outputs usable for follow-up work, not only for the final presentation.
- Ensure public-demo decisions, open risks, and responsibilities are visible.
- Check that no secrets, credentials, local configs, or private state are committed or documented accidentally.

## Suggested Time Split
- 5 minutes: collect the current status from feature tracks.
- 10 minutes: update setup, operation, and deployment notes.
- 5 minutes: finalize demo story, screenshots, or fallback evidence.
- 5 minutes: check repository state, secrets, limitations, and follow-up tasks.

## Parallel Workstreams
Technical participants should focus on:
- startup commands or scripts,
- touched files and current repository state,
- restart and browser verification steps,
- ports, logs, persistence, model endpoints, and known technical limitations.

Documentation and non-coding participants should focus on:
- setup guide and manual notes,
- FAQ and visitor-facing wording,
- screenshots or fallback story,
- plain-language explanation of what works and what does not.

Story and communication participants should focus on:
- final pitch narrative,
- target audience,
- what changed today,
- what remains difficult,
- why the result matters for the Living Lab.

## Finalization Checklist
- README or working notes point to the correct start path.
- Setup instructions are current enough for a follow-up session.
- Manual explains how to operate the demo without programming knowledge.
- Deployment notes include Digital Living Lab / HPC implications, RPi status, WebUI access, operations notes, and open questions.
- Known limitations and non-goals are explicit.
- Feature-track outputs are documented with result, evidence, and next step.
- Pitch material is ready: live demo, screenshot, fallback evidence, or clear integration assessment.
- No secrets, `.env`, tokens, private keys, local-only configs, or private Nextcloud material are committed.

## Useful opencode Prompt
```text
Review the current workshop result and help prepare final documentation.

Focus on:
1. what can be started or demonstrated,
2. what changed today,
3. setup and restart instructions,
4. known limitations,
5. deployment or operations notes,
6. follow-up tasks.

Do not read .env files, private keys, tokens, local configs, or secret-looking files.
Do not commit anything unless explicitly asked.
```

## Expected Output
- Final demo package for pitches.
- Follow-up-ready documentation state.
- Clear setup, operation, limitation, and deployment notes.
- Short list of open decisions and responsible follow-ups.

## Moderation Notes
- Keep this block practical; it is not the time for new feature work.
- Ask every track for one concrete result and one honest limitation.
- Make non-coders central for manual, wording, story, and visitor perspective.
- If something cannot be cleaned up, document it clearly instead of hiding it.
- Treat secret handling and private material checks as mandatory before the pitch.

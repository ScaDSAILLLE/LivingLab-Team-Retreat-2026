# AI Agents for Daily Work with opencode

**Time:** 10:45-11:30

## Purpose
Explore whether an agentic tool such as opencode can be useful for everyday Living Lab work beyond software development: communication, documentation, planning, reviewing, research support, technical coordination, and small automation ideas.

## Key Question
Can an AI coding agent become useful for daily tasks beyond coding, and where does it add value compared to ordinary chat-based AI?

## Objectives
- Understand opencode as an agent working with project files, not only as a coding tool.
- Test non-coding and mixed-role use cases relevant to daily Living Lab work.
- Identify which tasks feel promising, risky, unnecessary, or better suited for other tools.
- Collect ideas for future agent workflows, prompts, skills, or small automations.
- Reinforce safe habits around internal information, personal data, secrets, and human review.

## Reference: What opencode Is
This section is useful after the retreat as a quick reminder. During the workshop, setup should already be prepared.

opencode is not autocomplete and not just a chat window. Treat it as an agentic work partner that can inspect project files, explain material, propose plans, edit documents or code when allowed, run commands when approved, and help structure work across a repository.

| Concept | Practical Meaning |
|---|---|
| Session | One goal or task. Start a new session for a new topic. |
| Repository context | opencode is most useful when started from the folder that contains the relevant files. |
| Plan Mode | Use for analysis, ideas, review, and risky or unclear work. |
| Build Mode | Use only when a concrete edit or implementation is intended. |
| Tool approvals | The human remains responsible for allowed file edits and command execution. |
| Files | opencode is strongest when tasks refer to concrete files, notes, drafts, or project material. |

## Reference: Starting opencode
Only necessary when re-using the content. During the workshop, setup should already be up and running. This is just for your convenience.

```bash
source scripts/set_secrets.local.sh
opencode
```

If people prefer graphical interfaces, mention that opencode also has a desktop app. Detailed installation and UI preferences belong in the setup material, not in this block.

For a new project, initialize local project guidance before serious use:

```bash
opencode init
```

This should create or update agent instructions such as `AGENTS.md`. Use it to document project-specific rules, for example what the agent may inspect, what it must never read, what commands are safe, and how secrets are handled.

## Reference: Short Best-Practice Workflow
Use this as a reminder, not as a full workshop script:

1. Start from a prepared folder with only the files needed for the task.
2. Keep secrets, API keys, `.env` files, local configs, and credentials outside the working material.
3. Make sure `.gitignore` excludes secret and local-only files.
4. Make sure `AGENTS.md` tells the agent not to read `.env`, secret-looking files, private keys, tokens, or local configs.
5. Start in Plan Mode for unclear, sensitive, or open-ended tasks.
6. Ask the agent to explain its plan, assumptions, and risks before it changes anything.
7. Switch to Build Mode only for small, concrete, reviewed changes.
8. Review outputs manually before using them in public, technical, scientific, or operational contexts.

## During the Workshop
This block is not a setup exercise and not a coding sprint. Participants should use the prepared environment to test whether agentic workflows could help with their real work.

Suggested flow:
1. Briefly frame the hypothesis: coding agents may also help with daily knowledge work.
2. Show one short facilitator demo using safe demo material, Nanobot notes, or generic daily-work examples.
3. Let participants choose a role-based task.
4. Ask them to record what worked, what felt awkward, and what should never be automated.
5. Share promising workflows and concerns with the group.

## Facilitator Demo
Use a short non-coding example first. Do not rely on this retreat repository; participants will work on the prepared Raspberry Pi environment and with workshop/demo material.

```text
Explain the purpose of this demo folder or Nanobot setup notes for a new team member who is not a developer.
Keep it short, concrete, and focused on what they can safely try.
```

Then show how to make the task more concrete:

```text
Review the file or notes at [PATH OR SHORT DESCRIPTION].
Identify where the explanation is too technical for non-developers and suggest improvements.
Do not edit files yet.
```

Show:
- that opencode can work with repository files,
- that concrete files and concrete roles improve the answer,
- that asking for a plan or review first is often better than asking for immediate changes,
- that participants should avoid entering private, internal, or sensitive content.

## Role-Based Tasks
Each participant or small group should choose one task that fits their daily work. The point is to test usefulness, not to produce a perfect result.

### Everyone: Personal Use Case Discovery
```text
I want to explore how an agent like opencode could help with my daily work.
Ask me five short questions about recurring tasks, documents, communication, planning, and technical friction.
Then suggest three realistic agent workflows I could try today.
```

### PR and Communication: Press Draft
```text
Help me draft a short press release about [PROJECT, DEMO, EVENT, OR RESULT].
Use a clear public tone, avoid hype, and include placeholders where factual confirmation is needed.
Do not invent names, dates, numbers, quotes, or institutional claims.
```

### PR and Communication: Speech or Welcome Text
```text
Draft a two-minute welcome speech for [EVENT OR DEMO] and a mixed audience of researchers, technical staff, communication staff, and guests.
Make it warm, concise, and concrete.
Mark anything that needs human confirmation.
```

### Non-Coders: Understand Agent Potential
```text
Explain opencode to me as someone who does not code.
Focus on what kinds of daily work it could support, what it should not be used for, and how I can stay in control.
Give five examples from communication, coordination, review, documentation, and planning.
```

### Research: Review and Clarify Claims
```text
Review [DRAFT, ABSTRACT, DEMO EXPLANATION, OR PUBLIC TEXT] for scientific caution.
Separate confirmed facts, assumptions, unclear claims, and statements that need expert review.
Suggest safer wording without making the text vague.
```

### Developers: Demo Improvement Scout
```text
Inspect [DEMO FOLDER, NANOBOT CONFIG, SCRIPT, OR SELECTED FILES] and suggest one small improvement that would help the demo or daily work.
Start with a plan and explain the benefit.
Do not edit files until I approve.
```

### HPC and Operations: Risk Check
```text
Review the setup or operations notes of [DEMO, NANOBOT INSTANCE, RPI SETUP, OR SERVICE] from an infrastructure perspective.
List risks around credentials, ports, logs, persistence, updates, restart behavior, and user access.
Separate quick fixes from topics that need later planning.
Do not edit files yet.
```

### Documentation: Plain-Language Rewrite
```text
Review [SETUP NOTE, DEMO INSTRUCTION, FAQ, OR USER GUIDE] for clarity.
Identify jargon, missing assumptions, and steps that could confuse first-time participants.
Suggest a clearer version in plain English.
Do not edit files yet.
```

### Coordination: Meeting or Task Helper
```text
Turn these rough notes about [MEETING, DEMO PLANNING, OUTREACH, OR OPERATIONS] into a practical follow-up list.
Separate decisions, open questions, owners, deadlines, and risks.
Do not invent missing information; use placeholders where needed.
```

## Discussion Questions
- Which everyday tasks outside coding could an agent realistically support?
- Where did opencode feel more useful than a normal chat interface?
- Where did it feel too technical, too risky, or unnecessary?
- Which workflows could become reusable prompts, skills, templates, or small automations?
- What information should never be pasted into an AI tool, even when the API is locally provided or institutionally operated?

## Safety and Best Practice
- Do not paste private, confidential, internal, personal, contractual, or security-relevant information into AI tools.
- Do not paste secrets, API keys, tokens, passwords, private keys, `.env` files, local config files, or unpublished credentials.
- Treat the SCADS/HPC-hosted API and `llm.scads.ai` as useful infrastructure, not as permission to relax data-handling habits.
- Keep environment variables, secret exports, local config files, and credentials separate from shared workshop or demo material.
- Use `.gitignore` to exclude `.env`, local scripts, credentials, keys, tokens, and generated private state.
- Use `AGENTS.md` to explicitly tell the agent not to read `.env` files, secret-looking files, private keys, tokens, or local-only config.
- Keep public communication, scientific claims, legal statements, and deployment decisions under human responsibility.
- Ask the agent to mark uncertainty, missing facts, and assumptions instead of filling gaps creatively.
- Prefer anonymized, synthetic, shortened, or public examples when exploring workflows.

Useful safety prompt:

```text
Before helping, check whether this task might involve private, confidential, personal, contractual, or security-relevant information.
If yes, tell me what to remove or anonymize first.
Do not ask me to paste secrets, credentials, internal documents, or personal data.
```

## Further Reading
- opencode docs: <https://opencode.ai/docs/>
- TUI basics: <https://opencode.ai/docs/tui/>
- Config: <https://opencode.ai/docs/config/>
- Permissions: <https://opencode.ai/docs/permissions/>

## Expected Output
- Participants have tested at least one role-relevant non-coding or mixed-role workflow.
- The group has collected promising everyday use cases for agents beyond software development.
- The group has identified tasks that should remain human-led or require strict review.
- Participants understand the basic safety rule: do not share private, internal, personal, or secret information with AI tools.

## Moderation Notes
- Keep setup out of this block; only remind participants where to find it later.
- Keep examples tied to daily work, Nanobot, the demo, or placeholder material on the prepared Raspberry Pi systems.
- Avoid making developers the default audience.
- Encourage participants to test real task types with safe or synthetic content.
- If someone wants to implement something, first ask for a plan and keep the scope small.
- Treat data-handling caution as part of good professional practice, not as a blocker.

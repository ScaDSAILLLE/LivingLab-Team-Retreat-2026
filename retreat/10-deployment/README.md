# Deployment Input and Live Walkthrough

**Time:** 14:55-15:20

## Purpose
Create a shared understanding of what it takes to run, maintain, update, secure, and possibly persist the demonstrator on real resources.

## Key Question
What does it take to operate this demonstrator on a Raspberry Pi target system and, where needed, connect it to ScaDS.AI/HPC resources?

## Objectives
- Explain the difference between workshop code and maintainable deployment.
- Walk through the RPi target-system plan.
- Clarify secrets, logs, ports, persistence, updates, and responsibilities.
- Identify which compute should run on the RPi and which should run elsewhere.

## Required Topics
- RPi deployment target and expected network environment.
- Nginx reverse proxy for Nanobot WebUI.
- Docker versus direct `uv`/systemd installation.
- Whether sandboxing is necessary on a dedicated closed system.
- Secret handling and `.env.example` policy.
- Persistent Nanobot state and backups.
- Log access and troubleshooting ownership.
- Model endpoint routing: `llm.scads.ai`, KIARA, cloud fallback, or mock.

## Discussion Questions
- Who owns the demo after the retreat?
- How do we update it without breaking a public demonstrator?
- What needs monitoring, and what should not be logged?
- Which ports are acceptable on the target network?
- What is the recovery plan if model access fails during a public demo?

## Expected Output
- Deployment notes with open decisions.
- Clear owner or follow-up for RPi setup.
- List of operational risks and mitigations.

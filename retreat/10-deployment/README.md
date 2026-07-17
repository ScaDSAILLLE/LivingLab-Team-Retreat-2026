# Digital Living Lab Deployment and HPC Infrastructure

**Time:** 14:55-15:25

## Purpose
The HPC / Digital Living Lab team explains the infrastructure, deployment paths, and best practices for hosting AI applications and making them publicly available through the Digital Living Lab.

## Key Question
What does it take to move a Living Lab AI demonstrator from a workshop prototype to a hosted, maintainable, and publicly reachable application?

## Objectives
- Explain the structure and architecture of the Digital Living Lab.
- Show what is needed to deploy a Living Lab app and which services the team provides.
- Clarify how AI backends can be hosted or connected, including HPC jobs and model-serving scripts.
- Discuss operational best practices for public AI apps: secrets, logs, ports, persistence, monitoring, updates, and ownership.
- Connect the afternoon feature tracks to realistic deployment options, especially the Voice Track and possible HPC-backed models.

## Lead Perspective
The HPC / Digital Living Lab team leads this block. Other teams should use it to ask practical deployment questions and to understand what their feature track would need after the retreat.

## Suggested Time Split
- 10 minutes: Digital Living Lab structure and app deployment overview.
- 10 minutes: current HPC / AI infrastructure overview and available services.
- 10 minutes: example path for hosting an AI backend through an HPC job or service script. Operational questions from the feature tracks and public-demo readiness. 

## Topics To Cover
- Structure and architecture of the Digital Living Lab.
- What an app needs before it can be deployed publicly.
- Which services are provided by the Digital Living Lab / HPC team.
- How a frontend or Living Lab app connects to an AI backend.
- How to host AI backends through HPC resources, job scripts, service wrappers, or model endpoints.
- How `llm.scads.ai` and available LLM/VLM models fit into the architecture.
- How public access changes requirements for authentication, logging, secrets, abuse prevention, monitoring, and restart behavior.
- What should run locally on the Raspberry Pi, what should run in the Digital Living Lab, and what should run on HPC.

## Concrete Example: Voice Track and OmniVoice
One useful HPC example would be to run a specific TTS model such as OmniVoice through an HPC job during the feature tracks. This could support the Voice Track for testing and showcasing while keeping the main Nanobot demo lightweight.

Possible demonstration path:
1. Start an OmniVoice or comparable TTS model through an HPC job or prepared script.
2. Expose the result through a controlled internal endpoint or documented handoff mechanism.
3. Let the Voice Track send a short text sample and receive audio output.
4. Document latency, reliability, access constraints, and what would be needed for a real deployment.

This is only one example. STT, vision, and general multimodal reasoning may already be covered by the LLM/VLM setup, especially Gemma 4. The deployment discussion should focus on what needs separate infrastructure and what can use existing endpoints.

## Questions For Feature Tracks
- Knowledge and Explanation: where should content live, and how would updates be deployed?
- Eyes for Scaddy: can image understanding stay within the current VLM endpoint, or does it need a separate service?
- Voice for Scaddy: could TTS be provided by an HPC job, a persistent service, or a later hosted backend?
- Demo Hardening: what changes if the app becomes reachable through the Digital Living Lab or the public internet?

## Operational Checklist
- Who owns the deployed app after the retreat?
- Which services are required: frontend, backend, model endpoint, storage, authentication, monitoring?
- Where are secrets stored and rotated?
- Which logs are useful, and what must not be logged?
- How are updates, rollbacks, restarts, and incidents handled?
- Which ports, URLs, and network paths are acceptable?
- What is the fallback plan if model access fails during a public demo?

## Expected Output
- Shared understanding of the Digital Living Lab deployment path.
- Notes on available HPC / AI infrastructure and services.
- Deployment implications for each active feature track.
- Decision or follow-up on whether OmniVoice or another TTS model can support the Voice Track.
- List of operational risks, open decisions, and responsible follow-ups.

## Moderation Notes
- Keep the block practical and architecture-focused; this is not a full deployment workshop.
- Let the HPC / Digital Living Lab team lead and explain constraints clearly.
- Use the feature tracks as concrete examples instead of discussing deployment abstractly.
- Separate workshop-only hacks from practices suitable for a public Living Lab app.
- If OmniVoice or another HPC-backed model cannot be started live, document the intended path and requirements instead.

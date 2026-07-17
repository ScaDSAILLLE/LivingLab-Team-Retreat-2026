# Feature Tracks

**Time:** 14:10-14:55

## Purpose
Explore how Nanobot can be extended toward Scaddy-V2 without rebuilding the original system from scratch.

## Key Question
Which small feature, integration assessment, or hardening step would make Scaddy-V2 more useful for Living Lab visitors today?

## Objectives
- Test how far the Nanobot-based demo can be pushed toward Scaddy-V2 in a short timeframe and based on today's learning, including opencode.
- Produce the smallest visible improvement or the clearest integration assessment per track.
- Keep each track connected to public-demo value, maintainability, accessibility, and operations.
- Document what works, what fails, and what should be postponed. (Git!)

## Shared Rule
Each track should produce either a small visible result or a clear decision about feasibility, integration effort, risks, and next steps.

## Suggested Workflow
1. Pick one track and one concrete success criterion.
2. Use opencode to inspect relevant files, notes, APIs, repositories, or public examples.
3. Ask for a short plan before implementing anything.
4. Build or test only the smallest useful step.
5. Document the result, limitations, and follow-up needs.
6. Prepare one short demo or explanation for the pitch block.

## Track 1 - Knowledge and Explanation
**Question:** What should Scaddy know about the Living Lab, and how should it explain that knowledge to different audiences?

**Context:** Check how this was solved for Scaddy-V1 and whether useful sources exist in the Scaddy-V1 repository or related material.

**Possible tasks:**
- Create a small knowledge source, even a simple text file.
- Test whether Nanobot can use Markdown-style memory or persona files such as `soul.md` or `memory.md`, similar to approaches proposed by Nanobot or OpenClaw-style agent setups.
- Define audience modes, for example visitor, researcher, student, or press.
- Create explanation prompts and demo questions.
- Assess whether RAG/CAG is useful today or should be postponed.

**Possible output:** Small knowledge source, audience modes, explanation prompts, RAG/CAG spike, demo questions, or a clear recommendation for the next iteration.

## Track 2 - Eyes for Scaddy
**Question:** How can Scaddy use images to understand or explain exhibits and situations?

**Context:** A useful baseline is to ask Nanobot to understand an image posted in the chat UI. Since the setup uses Gemma-4 as a multimodal LLM via API, a Nanobot-based Scaddy-V2 may already be able to process images natively. Test that assumption before building extra infrastructure.

**Possible tasks:**
- Test image upload or image input in the current Nanobot chat UI.
- Check whether the model can describe, classify, or explain exhibit-like images.
- Improve the prompt or system instruction for visual understanding.
- Explore whether visual inputs can be remembered or referenced later in the conversation.
- Document whether a visRAG-style path is useful or too large for today.

**Possible output:** Image upload test, vision-capable model path, prompt improvement, visual-memory assessment, mock adapter, visRAG concept, or exhibit-photo scenario.

## Track 3 - Voice for Scaddy
**Question:** How realistic is speech input and output for Scaddy-V2 on this foundation?

**Context:** Check TUD:AI / `llm.scads.ai` for possible models and review interesting external projects such as [Hugging Face speech-to-speech](https://github.com/huggingface/speech-to-speech). The goal is not necessarily full implementation; a realistic integration decision is valuable.

**Possible tasks:**
- Identify available STT, TTS, or speech-to-speech model options.
- Sketch how voice input/output would connect to Nanobot or the current UI.
- Test a small transcript or speech-to-text path if feasible.
- Decide whether transcript display is enough for a first demo.
- Document operational constraints such as latency, audio devices, browser permissions, and network dependency.

**Possible output:** STT/TTS concept, transcript display idea, speech-to-speech mode, proposed decision, demo-ready integration path, or a documented reason to postpone.

## Track 4 - Demo Hardening
**Question:** How does the prototype become stable, understandable, accessible, and presentation-ready?

**Context:** Consider what is needed if such a demo becomes reachable via the internet, the Digital Living Lab, or a public event setting. Hardening includes wording and usability, but also operational and security advice.

**Possible tasks:**
- Improve wording, labels, fallback behavior, and visible system states.
- Check accessibility against the design spec from Block 05.
- Update manual notes, pitch story, or visitor instructions.
- Identify risks around public access, secrets, logs, persistence, abuse, and restart behavior.
- Separate quick fixes from topics that need later security or operations planning.

**Possible output:** Better wording, fallback behavior, manual, pitch story, accessibility fixes, operations checklist, security advice, or a public-demo readiness note.

## Cross-Perspective Questions
- What does this track need from PR, HPC, researchers, developers, and Living Lab staff?
- What is the public-demo value of this feature?
- What are the maintenance costs after the retreat?
- Which risks should be documented instead of solved today?

## Expected Output
- One small visible improvement, test result, or integration assessment per active track.
- Short notes on what was changed, tested, or learned.
- Clear follow-up tasks for anything too large for the timebox.
- Material for the demo pitch block.

## Moderation Notes
- Keep tracks small and outcome-oriented.
- A clear "not feasible today" decision is a valid result if it explains why.
- Ensure every track includes a non-developer perspective where possible.
- Avoid starting large architectural work or full rewrites.
- Ask teams to document assumptions, risks, and next steps while they work, not only at the end.

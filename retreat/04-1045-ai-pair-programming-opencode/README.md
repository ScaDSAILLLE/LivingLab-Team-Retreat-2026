# 10:45-11:30 - AI Pair Programming with opencode

## Purpose
Enable everyone to use opencode productively for exploration, documentation, safe changes, and daily work beyond coding.

## Key Question
How can we use an AI coding agent to understand, modify, document, and maintain the system?

## Objectives
- Practice repository exploration and asking precise questions.
- Use prompt templates for small, safe tasks.
- Make Git visible as a safety net, not as a barrier.
- Show non-coding use cases: documentation, prompts, instructions, testing, communication, analysis.

## Participant Roles
- Prompt Navigator: formulates and refines prompts.
- Demo Tester: uses the system like a visitor.
- Accessibility Reviewer: checks wording, labels, and interaction clarity.
- Documentation Lead: writes setup, manual, FAQ, and limitations.
- Story Lead: shapes the demo pitch and visitor narrative.
- Spec Keeper: maintains the shared demo/coding spec.

## Prompt Templates
```text
Explain this repository so a non-coder can understand:
1. What it contains,
2. what can be run,
3. where configuration lives,
4. what must not be touched.
Keep it short and concrete.
```

```text
We have limited workshop time.
Suggest the smallest useful next step for this block.
Separate what coders, non-coders, PR, HPC, and researchers can contribute.
```

```text
Check the repository state safely.
Show git status and changed files.
Do not read any .env file or secret-looking config.
Tell me whether anything looks risky before proposing a commit.
```

## Discussion Questions
- Which daily tasks outside coding could opencode support?
- What should an agent never do automatically in our environment?
- How do we keep humans responsible for public communication, privacy, and deployment decisions?

## Expected Output
- Shared prompt patterns.
- Shared safety rules.
- Participants understand at least one useful opencode workflow for their own role.

---
name: verification-before-completion
description: "Advisory: when a release, merge, or high-risk completion claim would benefit from stronger evidence, recommend an on-demand formal verification pass. Run it only after the user accepts; ordinary task checks remain lightweight."
---

<!-- managed-by: shared-reference -->
<!-- source-repo: https://github.com/1008k/shared-reference -->
<!-- source-path: .agents/skills/verification-before-completion/SKILL.md -->

## Shared-reference activation

If the user has not explicitly requested this workflow, briefly recommend it and wait for acceptance before starting the formal verification pass.

# Verification Before Completion

Claiming work is complete without verification is dishonesty, not efficiency. Evidence before claims, always.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate

Before any status claim or expression of satisfaction:

1. **IDENTIFY** the command that proves the claim
2. **RUN** it fresh and complete
3. **READ** full output, check exit code, count failures
4. **VERIFY** — then state the claim WITH the evidence, or state the actual status if it failed

Skip any step = lying, not verifying.

## Apply — ALWAYS before

- Any success/completion claim, satisfaction, or positive statement about work state
- Committing, PR creation, task completion, moving to next task, delegating to agents

Covers exact phrases, paraphrases, implications — any communication suggesting completion without having run verification.

## What counts as evidence

| Claim | Requires | Not sufficient |
|-------|----------|----------------|
| Tests pass | Test output: 0 failures | Previous run, "should pass" |
| Linter clean | Linter output: 0 errors | Partial check, extrapolation |
| Build succeeds | Build: exit 0 | Linter passing, logs look good |
| Bug fixed | Original symptom: passes | Code changed, assumed fixed |
| Regression test | Red-green cycle verified | Test passes once |
| Agent completed | VCS diff shows changes | Agent reports "success" |
| Requirements met | Line-by-line checklist | Tests passing |

## Red Flags — STOP

Using "should", "probably", "seems to"; satisfaction before verification ("Great!", "Perfect!", "Done!"); committing/pushing/PR without verification; trusting agent success reports; partial verification; "just this once"; **any wording implying success without having run verification**.

| Excuse | Reality |
|--------|---------|
| "Should work now" / "I'm confident" | RUN it. Confidence ≠ evidence |
| "Just this once" | No exceptions |
| "Linter passed" / "Agent said success" | Linter ≠ compiler. Verify independently |
| "Partial check is enough" | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter |

## Patterns

```
Tests:        [Run] [N/N pass] "All tests pass"        ❌ "Should pass now"
Build:        [Run build] [exit 0] "Build passes"      ❌ "Linter passed"
Requirements: Re-read plan → checklist → verify each → report gaps
Agent:        report → check VCS diff → verify → report actual state
```

Regression (TDD red-green):
```
Write → Run(pass) → Revert fix → Run(MUST FAIL) → Restore → Run(pass)
❌ "I've written a regression test" (without red-green verification)
```

## Why this matters

From failure memories: trust broken ("I don't believe you"), undefined functions shipped, missing requirements shipped, time wasted on false completion. Honesty is a core value — lying gets you replaced.

**Bottom line:** Run the command. Read the output. THEN claim the result. Non-negotiable.

# Agent Harness Map

This directory documents how agents should work in this repo without turning
`AGENTS.md` into a long manual.

## Default load order

1. `validation-harness.md`
2. `doc-gardening.md` if the task touches docs or architecture knowledge
3. `review-and-merge-philosophy.md` if the task changes PR/review expectations
4. `docs/architecture/invariants.md` when a rule should be enforced

## Documents

| Document                         | Purpose                                                    |
| -------------------------------- | ---------------------------------------------------------- |
| `validation-harness.md`          | Commands, checks, and feedback loops agents should run.    |
| `doc-gardening.md`               | How to keep docs fresh and garbage-collect stale guidance. |
| `review-and-merge-philosophy.md` | Merge and review posture for agent-assisted work.          |

## Operating principle

Agents should not rely on hidden chat context or human memory. If a rule is
reused, encode it in this repo as a doc, manifest, generated artifact, test, or
script.

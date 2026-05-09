# Technical Debt Tracker

This tracker is intentionally small. Prefer targeted cleanup PRs over broad
rewrite plans.

| Area            | Debt                                                           | Desired cleanup                                                           | Status |
| --------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------- | ------ |
| Agent knowledge | New architecture docs are not yet fully generated from source. | Add richer generators for `docs/generated/*`.                             | Open   |
| Validation      | Knowledge checks are shell-based and lightweight.              | Promote stable checks into CI or `std` targets when the workflow settles. | Open   |
| Legacy docs     | Root `ARCHITECTURE.md` remains narrative and historical.       | Keep it, but link new agent-facing docs as the retrieval surface.         | Open   |

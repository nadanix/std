# Event and Contract Artifact Checklist

## Summary

- Use this checklist to review event catalogs, trust-boundary notes, and cross-context contract documents.
- The goal is to keep event language factual, contract seams explicit, and foreign detail translated before it leaks inward.
- Apply it to canonical docs or project-specific context packs.

## Use this when

- adding or revising an event catalog
- documenting a context-to-context contract
- reviewing anti-corruption or translation seams
- checking whether a read model or downstream consumer is relying on unstable language

## Event artifact checks

- [ ] event names are written as facts, not commands
- [ ] each important event has an emitting context or owner
- [ ] business events are distinguished from technical notifications
- [ ] the event meaning is clear without implementation detail
- [ ] likely consumers or downstream readers are identified where relevant
- [ ] disputed or overloaded event terms are recorded instead of hidden

## Contract artifact checks

- [ ] the participants and direction of interaction are explicit
- [ ] the relationship model is named or clearly implied
- [ ] shared terms and translated terms are distinguished
- [ ] the stable success and failure surface is documented
- [ ] anti-corruption or translation boundaries are visible
- [ ] ownership of state, identifiers, and compatibility expectations is clear

## Review prompts

- Which details matter to the receiver, and which should remain hidden?
- Would a vendor or protocol change force this artifact to change more than necessary?
- Are read-side consumers depending on internal write-side language?
- Is the artifact small enough to scan yet concrete enough to govern change?

## Related docs

- `context/playbooks/08-business-event-discovery-and-event-catalog-playbook.md`
- `context/playbooks/09-domain-error-and-failure-taxonomy-playbook.md`
- `context/playbooks/10-cross-context-contract-and-anti-corruption-playbook.md`
- `context/review/02-architecture-review-checklist.md`

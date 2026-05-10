# Agent Validation Harness

## Summary

- Agents should validate through repo-local tools and docs, not hidden memory.
- Run the smallest useful feedback loop first, then escalate to heavier checks.
- When a validation gap recurs, encode it as a script, test, generated doc, or
  manifest rule.

## Knowledge checks

Run this when architecture docs, dependency docs, Block Types, or `AGENTS.md`
change:

```bash
tooling/check-agent-knowledge.sh
```

The script checks:

- `AGENTS.md` stays map-sized
- architecture manifests point to existing files
- every built-in Block Type has catalog coverage
- direct dependency contracts mention required root inputs
- generated Block Type inventory mentions current Block Type files

## Formatting checks

Preferred repo command in a working dev environment:

```bash
treefmt
```

If the dev environment is unavailable, use temporary Nix tools for targeted
checks, for example:

```bash
nix shell nixpkgs#prettier -c prettier --check docs/00-map.md docs/architecture/*.md docs/agent/*.md
nix shell nixpkgs#alejandra -c alejandra --check src/local/configs.nix
```

## Nix checks

Use the smallest check that covers the change:

```bash
nix eval --json --no-write-lock-file .#__std --apply 'x: builtins.attrNames x'
nix build
namaka check
nix flake check
```

Notes:

- `nix flake check` is release-level confidence and may be slow.
- Snapshot updates should go through `namaka review`, not manual edits.
- `src/local` and `src/tests` locks are private dogfood input manifests; report
  exact lock diffs or evaluation failures rather than hiding them.

## Documentation checks

When docs change:

```bash
mdbook build
tooling/check-agent-knowledge.sh
```

For map/manifest changes, verify:

- the nearest map links to the new file
- the nearest manifest contains the new file
- parent maps still get an agent to the right leaf doc in under two hops
- generated snapshots are updated or explicitly unaffected

## Agent feedback loop

Use this loop for non-trivial changes:

1. Read the smallest map/manifest that owns the task.
2. Make the code or doc change.
3. Run the smallest local validation.
4. If validation fails, improve the harness or docs when the failure indicates a
   missing capability.
5. Escalate to heavier checks only after the local loop is clean.
6. Capture reusable lessons in docs or mechanical checks.

## Escalation policy

Escalate to a human when:

- the change relaxes an invariant
- the dependency boundary is ambiguous
- validation requires external credentials or destructive side effects
- there is a product or project judgment call not encoded in the repo

## Related docs

- `docs/architecture/invariants.md`
- `doc-gardening.md`
- `review-and-merge-philosophy.md`

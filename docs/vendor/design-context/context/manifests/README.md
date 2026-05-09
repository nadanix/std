# Manifests

This directory holds machine-readable retrieval metadata.

Start with:
- `project-manifest.yaml`
- `principles-manifest.yaml`
- `glossary-manifest.yaml`
- `playbooks-manifest.yaml`
- `review-manifest.yaml`
- `patterns-manifest.yaml`

Rules:
- keep keys simple and stable
- optimize for retrieval, not prose
- update manifests whenever canonical docs move or new ones are added
- keep manifest summaries short enough for selective loading
- treat `next_reads` as optional suggestions, not mandatory recursive dependencies

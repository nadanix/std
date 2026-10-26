# ADR template

`adrgen` uses `template.md.in` to generate new records. The placeholders below
are replaced with the record's title, date and status.

```markdown
{{#include ./template.md.in}}
```

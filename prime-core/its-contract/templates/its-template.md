# ITS Template

Canonical template owned by prime-core/its-contract. The architect writes it; the developer implements from it; code review validates against it. See the its-contract SKILL.md for level-of-detail and traceability rules.

```markdown
# ITS-<story-id> — [Story title]

## Metadata
- **Story:** <id and one-line summary>
- **Affected use cases:** UC-NNN (creation|change), ...
- **Config snapshot:** stack + versions relevant to this plan

## Per-use-case analysis
### UC-NNN — [title] (creation | change)
- **Delta:** [copied from the use case's revision entry for this story; for creation, "entire document"]
- **Mapping:** table of delta item (or flow step) → component/file → action (create | modify | remove)
- **Regression points:** [change scenario only — unchanged behavior sharing code with the changes]

## Consolidated plan
### Files affected
[Unified list across all use cases: path, nature of change, which UC/delta items it serves. Resolve overlaps — one entry per file.]
### New files
### Schema / migration changes
### Implementation order
[Numbered sequence with rationale (dependencies first, etc.)]
### Test strategy
[Tests derived from each acceptance criterion touched by the deltas + non-regression tests for every regression point + hot areas. Reference the project config's verification commands.]
### Risks and attention points
[Other use cases served by modified components; open questions]

## Traceability check
[Explicit confirmation, per use case section: every delta item has a corresponding change (or a justification that existing code already covers it), and every planned change references a delta item or is justified as a technical consequence.]
```

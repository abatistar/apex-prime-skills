# Use Case Template

This is the canonical template — the single copy, owned by prime-core. If the project's `prime-config.md` declares a custom template path or additional mandatory sections, the project configuration takes precedence.

## File naming convention

`docs/use-cases/UC-NNN-short-title.md` (e.g., `UC-042-export-report-pdf.md`). `NNN` is a zero-padded sequential number, stable for the life of the document. Never renumber existing use cases.

## Document structure

```markdown
# UC-NNN — [Use Case Title]

## Metadata
- **ID:** UC-NNN
- **Status:** Draft | Reviewed | Active
- **Actors:** [primary actor; secondary actors if any]
- **Related use cases:** [UC-XXX links, or "none"]

## Goal
[One or two sentences: what the actor wants to achieve and why. Intent level, not UI level.]

## Preconditions
- [System state that must be true before the flow starts]

## Main Flow
1. [Actor action]
2. [System response]
3. ...
[Number every step. Alternate actor actions and system responses. Write at intent level ("the user confirms the order"), never at UI level ("the user clicks the blue button").]

## Alternative Flows
### [N]a. [Condition that triggers the alternative]
- [Steps; state where the flow rejoins the main flow or ends]

## Exception Flows
### [N]x. [Failure condition — validation error, permission denied, timeout, limit exceeded, integration failure, concurrency conflict]
- [How the system responds; final outcome. Every exception must have a defined outcome.]

## Postconditions
- **On success:** [what is guaranteed to be true]
- **On failure:** [what is guaranteed — e.g., no partial state persisted]

## Business Rules
- **BR-1:** [Rule referenced by the flows, stated precisely and testably]

## Acceptance Criteria
- **AC-1:** Given [context], when [action], then [verifiable outcome]
[Every criterion must be objectively verifiable. Cover the main flow and every exception flow.]

## Revision History
| Rev | Story | Date | Summary of changes |
|-----|-------|------|--------------------|
| 1 | S-NNN or "initial mapping from code" | YYYY-MM-DD | [Added/changed/removed items, referencing step and section numbers] |
[Keep only the 5 most recent entries. Full history lives in version control.]
```

## Quality rules

Enforce all of these before considering a document done:

1. Intent level, not interface level. No UI widget names in flows.
2. Every exception flow has a defined outcome. No dangling failures.
3. Every acceptance criterion is verifiable. No "the system should be fast" without a metric.
4. Every business rule referenced in a flow exists in the Business Rules section, and vice versa.
5. Postconditions state what is true on failure, not only on success.
6. Revision History entries always carry the originating story ID and reference the affected step/section numbers — the ITS Generator depends on this to locate the delta.

## Uncertainty markers (used by Use Case Extractor)

When a document is reverse-engineered from code, mark unverified content:

- `[INFERRED]` — behavior deduced from code structure but not confirmed by tests or stakeholders.
- `[CONFIRM: question]` — an open question a human must answer (e.g., `[CONFIRM: is the 10-item limit a business rule or a technical constraint?]`).

A document containing uncertainty markers has Status "Draft" and must not be treated as source of truth until a human resolves the markers and promotes it to "Reviewed".

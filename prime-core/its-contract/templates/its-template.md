# ITS Template

Canonical template owned by prime-core/its-contract. The architect writes it; the developer implements from it; code review validates against it. See the its-contract SKILL.md for level-of-detail, writing rules, traceability, and ITS-vs-ADR boundary rules.

Formatting constraints (from the contract's writing rules): maximum 3 heading levels, 2 list-nesting levels, simple tables (no multi-line cells, no embedded HTML), simple non-nested code fences, no diagrams. The document must survive copy-paste into the company's documentation platform as-is.

```markdown
# ITS-<story-id> — [Story title]

## Metadata
- **Story:** <id — one-line summary — resolvable link to the tracker item>
- **Affected use cases:** UC-NNN (creation|change), ...
- **Config snapshot:** stack + versions relevant to this plan
- **Referenced ADRs:** ADR-NNN (status), ... or "none"
  [Decisions that outlive the story live in ADRs and are only referenced here — see the contract's decision boundary. Accepted ADRs are binding on the implementer.]

## Executive summary
[3–5 lines, business language, no code identifiers. What the story changes, in which
use cases, and the observable effect for the user/system. Write this LAST, after the
consolidated plan is closed. This is the entry point for tech leaders and compliance —
the cold-reader test applies here: understandable without opening any other document.]

## Per-use-case analysis
### UC-NNN — [title] (creation | change)
[Open with ONE synthesis sentence in behavior language — what changes in this use case,
readable by a non-implementer. E.g., "This use case gains a credit-limit validation
before order confirmation." The table below carries the technical precision.]
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
### Out of scope — do not touch
[One line per untouchable area: component/path, why it stays unchanged, and the
non-regression coverage protecting it. E.g., "Do not modify `PaymentService` — refund
flow unchanged by this story, covered by the refund non-regression suite." Named borders
make "all of it and nothing beyond it" enforceable for the implementer and checkable
for the reviewer. If nothing is at risk of accidental change, write "none identified".]
### Risks and attention points
[Other use cases served by modified components; open questions]

## Traceability check
[Explicit confirmation, per use case section: every delta item has a corresponding change (or a justification that existing code already covers it), and every planned change references a delta item or is justified as a technical consequence. Where a change had more than one viable path, state the discarded alternative and the deciding reason in one line. Beyond gating delivery, this section is the document's audit evidence.]

## Reference glossary
[For readers without access to the document repository. Metadata only — resolve WHAT
each identifier is, never copy WHAT the document says. Fill from the documents already
loaded during planning; snapshot at delivery time. Qualify RN/CA with their UC when
more than one use case is affected.]

### Cited in this ITS
| ID | Type | Name / one-line gloss |
|---|---|---|
| UC-NNN | Use case | [Name field of the document] |
| UC-NNN/RN-N | Business rule | [one-line paraphrase of the rule's intent] |
| UC-NNN/CA-N | Acceptance criterion | [one-line paraphrase of what it verifies] |
| ADR-NNN | Decision record | [title] (Status) |

### Process terms
| Term | Meaning |
|---|---|
| ITS | Software Work Instruction — this document: the implementation plan for one story |
| UC | Use case — the living documentation of one system behavior |
| RN | Business rule inside a use case |
| CA | Acceptance criterion inside a use case |
| ADR | Architecture Decision Record — a decision that outlives the story |
| Delta | The set of changes a story applies to a use case |
```
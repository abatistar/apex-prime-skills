---
name: its-contract
description: The canonical contract for the ITS (Instrucao de Trabalho de Software) owned by prime-core - mandatory sections, level of detail, naming, traceability rules, and the decision-record (ADR) boundary. The handoff artifact between Solution Architect and Developer. The architect's its-generator writes against this contract; the dev's its-implementation reads against it. Consult whenever producing, validating, or consuming an ITS. Never duplicate its content elsewhere - reference it.
---

# ITS Contract (prime-core)

The ITS is the handoff artifact of the workflow: the Solution Architect writes it, the Developer implements from it, the architect's code review validates against it. This skill owns its format. Because writer and reader consume the same contract, a change here updates both sides at once — no drift between specification and implementation.

## File naming

`docs/its/ITS-<story-id>-short-title.md` (or as overridden by `docs/prime-config.md`). One ITS per story.

## Canonical template

`templates/its-template.md` is the authoritative structure. Read it in full before writing or validating an ITS. Mandatory sections:

- **Metadata** — story ID and summary; affected use cases with scenario (creation | change); config snapshot (stack and versions the plan assumes); referenced ADRs, if any.
- **Per-use-case analysis** — one section per affected use case: the delta (from the use case's Revision History entry for this story), the mapping table (delta item / flow step → component or file → action: create | modify | remove), and regression points (change scenario only).
- **Consolidated plan** — files affected (unified, one entry per file), new files, schema/migration changes, implementation order with rationale, test strategy, risks and attention points.
- **Traceability check** — explicit bidirectional confirmation per use case section.

## Level of detail

- Every planned change names concrete files or components. "Adjust the service layer" is not ITS-grade; `OrderService.confirm(): add limit validation before persisting` is.
- The ITS instructs; it does not implement. No full code listings — snippets only when a signature, contract, or schema must be pinned exactly.
- Write to eliminate questions. The implementer's ambiguity policy is to return questions, not to assume — every question returned is a hole in the ITS.
- Test strategy derives from the use cases' acceptance criteria touched by the deltas, plus non-regression coverage for every regression point.

## Traceability rules (bidirectional, per use case section)

- Delta → plan: no delta item without a corresponding change or an explicit "already covered" justification.
- Plan → delta: no planned change without a referenced delta item or a stated technical-consequence justification.
- **Discarded alternative:** when a planned change had more than one viable implementation path, the entry states the discarded alternative and the deciding reason in one line. No viable alternative → nothing to state; this is a record of real choices, not a form field.
- An ITS failing either direction is not deliverable.

## Decision boundary: ITS vs ADR

The ITS records decisions that **die with the story** (choices between equivalent implementation paths — captured by the discarded-alternative rule above). Decisions that **outlive the story** do not belong in the ITS body; they go to an Architecture Decision Record and the ITS only references the ADR ID.

A decision outlives the story when at least one holds:
- it constrains future implementation choices (pattern, library, integration style, persistence strategy);
- it affects more than one use case or module;
- someone who never read this ITS will need the rationale later.

ADR location and naming come from `docs/prime-config.md` (default: `docs/adr/ADR-NNN-short-title.md`, sequential, never renumbered; minimal structure: Context, Decision, Consequences, Status — Proposed | Accepted | Superseded by ADR-NNN). The its-generator detects candidate decisions and **proposes** the ADR; the architect approves before the ITS is delivered. An ITS embedding an architectural decision instead of referencing an ADR is not deliverable — same severity as a traceability failure.

## Consumption rules (for the implementer)

- The ITS is the scope. Implement all of it and nothing beyond it.
- Referenced ADRs are binding context: read them before implementing; never contradict an Accepted ADR. A conflict between the ITS and an ADR is ambiguity — return it as a question.
- Ambiguity, contradiction, or missing detail → do not fill the gap by assumption; return questions to the architect referencing the ITS section.
- Deviations discovered mid-implementation (the plan doesn't survive contact with the code) → report back; the architect revises the ITS. The document stays the source of truth of what was agreed.

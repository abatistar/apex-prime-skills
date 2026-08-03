---
name: its-contract
description: The canonical contract for the ITS (Instrucao de Trabalho de Software) owned by prime-core - mandatory sections, level of detail, naming, and traceability rules. The handoff artifact between Solution Architect and Developer. The architect's its-generator writes against this contract; the dev's its-implementation reads against it. Consult whenever producing, validating, or consuming an ITS. Never duplicate its content elsewhere - reference it.
---

# ITS Contract (prime-core)

The ITS is the handoff artifact of the workflow: the Solution Architect writes it, the Developer implements from it, the architect's code review validates against it. This skill owns its format. Because writer and reader consume the same contract, a change here updates both sides at once — no drift between specification and implementation.

## File naming

`docs/its/ITS-<story-id>-short-title.md` (or as overridden by `docs/prime-config.md`). One ITS per story.

## Canonical template

`templates/its-template.md` is the authoritative structure. Read it in full before writing or validating an ITS. Mandatory sections:

- **Metadata** — story ID and summary; affected use cases with scenario (creation | change); config snapshot (stack and versions the plan assumes).
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
- An ITS failing either direction is not deliverable.

## Consumption rules (for the implementer)

- The ITS is the scope. Implement all of it and nothing beyond it.
- Ambiguity, contradiction, or missing detail → do not fill the gap by assumption; return questions to the architect referencing the ITS section.
- Deviations discovered mid-implementation (the plan doesn't survive contact with the code) → report back; the architect revises the ITS. The document stays the source of truth of what was agreed.

---
name: its-contract
description: The canonical contract for the ITS (Instrucao de Trabalho de Software) owned by prime-core - mandatory sections, level of detail, writing rules, naming, traceability rules, and the decision-record (ADR) boundary. The handoff artifact between Solution Architect and Developer, also readable by tech leaders and compliance without translation. The architect's its-generator writes against this contract; the dev's its-implementation reads against it. Consult whenever producing, validating, or consuming an ITS. Never duplicate its content elsewhere - reference it.
---

# ITS Contract (prime-core)

The ITS is the handoff artifact of the workflow: the Solution Architect writes it, the Developer implements from it, the architect's code review validates against it. This skill owns its format. Because writer and reader consume the same contract, a change here updates both sides at once — no drift between specification and implementation.

The ITS has one canonical home (the repository) and more than one reader: the implementer (human developer and/or the Friday agent), the reviewer, tech leaders, and compliance — including readers who encounter the document outside the repository, on the company's documentation platform. One document serves all of them through **layered reading** (see Writing rules): non-technical readers stop at the executive summary and the per-use-case synthesis sentences; the implementer consumes the full technical depth. The document is written once — never in per-audience versions.

## File naming

`docs/its/ITS-<story-id>-short-title.md` (or as overridden by `docs/prime-config.md`). One ITS per story.

## Canonical template

`templates/its-template.md` is the authoritative structure. Read it in full before writing or validating an ITS. Mandatory sections:

- **Metadata** — story ID, summary, and a resolvable link to the story in the tracker; affected use cases with scenario (creation | change); config snapshot (stack and versions the plan assumes); referenced ADRs, if any.
- **Executive summary** — 3–5 lines in business language: what the story changes, in which use cases, and the observable effect. The only section non-implementing readers must read. Written last, after the plan is closed, so it stays faithful.
- **Per-use-case analysis** — one section per affected use case, opening with a one-sentence synthesis in behavior language, then: the delta (from the use case's Revision History entry for this story), the mapping table (delta item / flow step → component or file → action: create | modify | remove), and regression points (change scenario only).
- **Consolidated plan** — files affected (unified, one entry per file), new files, schema/migration changes, implementation order with rationale, test strategy, out-of-scope boundaries, risks and attention points.
- **Traceability check** — explicit bidirectional confirmation per use case section. Beyond gating delivery, this section is the document's audit evidence: every change justified, every alternative recorded.
- **Reference glossary** — resolves every identifier the document cites (`UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`) for readers who do not have the referenced documents at hand, plus the fixed process-term table. Metadata only (ID + name + one line) — never the referenced content. See Writing rules.

## Level of detail

- Every planned change names concrete files or components. "Adjust the service layer" is not ITS-grade; `OrderService.confirm(): add limit validation before persisting` is.
- The ITS instructs; it does not implement. No full code listings — snippets only when a signature, contract, or schema must be pinned exactly.
- Write to eliminate questions. The implementer's ambiguity policy is to return questions, not to assume — every question returned is a hole in the ITS. This holds identically for the human developer and for the Friday agent: an instruction that admits two implementations is a defect, not a style issue.
- Test strategy derives from the use cases' acceptance criteria touched by the deltas, plus non-regression coverage for every regression point.

## Writing rules

The same rules serve every reader — human or agent. What makes an instruction unambiguous for an LLM is what makes it verifiable for a reviewer and legible for compliance.

**Register separation — behavior in prose, code in tables.**
- Prose (executive summary, synthesis sentences, rationale, risks) uses behavior language: "the system starts rejecting orders above the credit limit". No class names in prose unless unavoidable.
- Tables and technical lists (mapping, files affected, implementation order) use code language: exact paths, signatures, identifiers. No vagueness in tables — if a cell needs a paragraph, the content belongs in prose.

**Sentence discipline.**
- One instruction per sentence. Active voice, present tense. Compound sentences hide instructions the implementer can miss and the reviewer cannot check item by item.
- References are always resolvable in place: `UC-042`, `RN-3`, `CA-2`, full file paths. Never "the rule above", "as discussed", "the usual adjustment" — deixis and presupposition are the primary failure point for both agents and readers entering mid-document. If it is not in the ITS or a referenced ADR, it does not exist for the reader.
- Every criterion is verifiable: numbers, conditions, named rules ("timeout of 30s per RN-5", never "an adequate timeout").
- Project jargon and acronyms are expanded on first occurrence per section. The document will be read outside the story's context.
- When more than one use case is affected, qualify `RN-N` and `CA-N` references with their use case (`UC-042/RN-3`) — these identifiers are scoped per document, and an unqualified reference is ambiguous.

**Self-contained references — the glossary.**
References are resolvable in the repository, but the document is also read where the referenced documents do not exist (the company's documentation platform). The Reference glossary closes that gap:
- One table listing every cited identifier: ID, type, name, and a one-line gloss. For use cases, the Name field; for business rules and acceptance criteria, a one-line paraphrase of intent; for ADRs, the title and status.
- **Metadata only, never content.** The glossary resolves *what the identifier is*, not *what the document says* — copying flows, rules verbatim, or ADR rationale into the glossary is duplication and breaks the single-owner principle. A reader who needs the content goes to the source; the glossary tells them which source.
- The glossary is a snapshot at delivery time, same discipline as the config snapshot: the writer fills it from the actual documents already loaded during planning, so it costs nothing and cannot be invented.
- The fixed process-term table (ITS, UC, RN, CA, ADR, delta) ships with the template as boilerplate — the cold reader learns the vocabulary without leaving the page.

**Explicit negative scope.**
The consolidated plan states what must **not** change: one line per untouchable area, with the reason and the regression coverage that protects it ("Do not modify `PaymentService` — refund flow unchanged, covered by non-regression tests"). For the implementer this is a hard boundary ("all of it and nothing beyond it" requires named borders); for the reviewer, a checklist; for compliance, evidence of risk containment.

**Publication-ready formatting.**
The ITS must survive copy-paste into the company's documentation platform without rework — and these constraints improve readability everywhere:
- Maximum 3 heading levels and 2 list-nesting levels.
- Simple tables only: no multi-line cells, no embedded HTML, no merged columns.
- Code fences are simple and never nested; used only where the contract allows snippets.
- No diagrams in the ITS body (the use case documents own the diagrams).

**Pre-delivery test.** Before delivering, answer three questions about the finished document:
1. *Implementer test:* does any instruction admit two different implementations? If yes, it is a question the implementer will return — close it now.
2. *Cold-reader test:* does someone who never saw the story — and without access to the use case repository — understand the executive summary and the synthesis sentences, and resolve every cited identifier through the Reference glossary, without opening another document?
3. *Paste test:* pasted into the documentation platform, do tables and heading hierarchy survive?

A document failing any of the three is not deliverable.

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

- The ITS is the scope. Implement all of it and nothing beyond it — including respecting the out-of-scope boundaries stated in the consolidated plan.
- Referenced ADRs are binding context: read them before implementing; never contradict an Accepted ADR. A conflict between the ITS and an ADR is ambiguity — return it as a question.
- Ambiguity, contradiction, or missing detail → do not fill the gap by assumption; return questions to the architect referencing the ITS section.
- Deviations discovered mid-implementation (the plan doesn't survive contact with the code) → report back; the architect revises the ITS. The document stays the source of truth of what was agreed. Copies published elsewhere are views; validating divergence between them and the repository is the architect's responsibility, not the implementer's.
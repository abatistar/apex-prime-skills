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

- **Metadata** — story ID, summary, and a resolvable link to the story in the tracker; affected use cases with scenario (creation | change); config snapshot (stack and versions the plan assumes); referenced ADRs, if any; and the **traceability check** (see Traceability rules). Written last, together with the executive summary. This section carries the document's facts and its audit evidence — the two things addressed to readers who are not implementing.
- **Executive summary** — 3–5 lines in business language: what the story changes, in which use cases, and the observable effect. The only section non-implementing readers must read. Written last, after the plan is closed, so it stays faithful.
- **What changes in behavior** — one section per affected use case, carrying only what exists on that axis: a one-sentence synthesis in behavior language, the delta as **numbered items** (`D1`, `D2`, ... — qualified as `UC-NNN/D1` when more than one use case is affected) taken from the use case's Revision History entry for this story, and the regression points (change scenario only). No file mapping here: the plan owns the single mapping.
- **Implementation plan** — the document's spine, written in execution order. One numbered unit per step of work, each stating: the files it creates, modifies, or removes; what to do, with every cited requirement written in place; the delta items it satisfies (`UC-NNN/D1`) or the technical consequence that justifies it; and the tests it owes. A unit touching code shared with a regression point states the non-regression test it owes. The plan closes with schema and migration changes, the out-of-scope boundaries, the risks and attention points, and the project's verification commands.
- **Reference glossary** — resolves every identifier the document cites (`UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`) for readers who do not have the referenced documents at hand, plus the fixed process-term table. Metadata only (ID + name + one line) — never the referenced content. See Writing rules.
- **One axis.** The mapping from behavior to code exists once, in the implementation plan, on the axis the implementer works in: order of execution. The behavior section carries what the plan cannot — the delta and what must keep working — and nothing that the plan will restate. Two sections describing the same change on two axes force the reader to redo a fusion the document already performed, and the section they skip is the one that was not written in their axis.

## Level of detail

- Every planned change names concrete files or components. "Adjust the service layer" is not ITS-grade; `OrderService.confirm(): add limit validation before persisting` is.
- The ITS instructs; it does not implement. No full code listings — snippets only when a signature, contract, or schema must be pinned exactly.
- Write to eliminate questions. The implementer's ambiguity policy is to return questions, not to assume — every question returned is a hole in the ITS. This holds identically for the human developer and for the Friday agent: an instruction that admits two implementations is a defect, not a style issue.
- Tests are declared per plan unit, not as a separate strategy block: each unit owes the tests derived from the acceptance criteria its delta items touch, plus the non-regression coverage for any regression point sharing code with it. Every regression point listed in the behavior section is claimed by exactly one unit — an unclaimed regression point is a traceability failure.

## Writing rules

The same rules serve every reader — human or agent. What makes an instruction unambiguous for an LLM is what makes it verifiable for a reviewer and legible for compliance.

**Register separation — behavior in prose, code in tables.**
- Prose (executive summary, synthesis sentences, rationale, risks) uses behavior language: "the system starts rejecting orders above the credit limit". No class names in prose unless unavoidable.
- Tables and technical lists (mapping, files affected, implementation order) use code language: exact paths, signatures, identifiers. No vagueness in tables — if a cell needs a paragraph, the content belongs in prose.

**Author's voice — the document instructs; it does not narrate its own production.**
The ITS carries the architect's signature and reads as their instruction. A document that narrates deliberation invites renegotiation of what was already decided, and a hedge reaches the implementer as ambiguity — which returns as a question, the round-trip this contract exists to prevent. The rule is a closed list of marks, not a style to imitate:

- No narration of how the plan was produced: what was inspected, searched, considered, or ruled out along the way.
- No self-reference to the document or to its drafting.
- No hedging inside an instruction ("provavelmente", "talvez", "sugere-se", "seria interessante"). The decision is closed when the ITS is delivered.
- No section filled by ceremony. With nothing to state, the section states that ("nenhuma identificada").
- No address to whoever commissioned the plan ("conforme solicitado"). The reader is the implementer.

This governs residue of process, never the substance of the plan: stating why a path was chosen is instruction and belongs in the document. Nor is it an instruction to conceal how the document was drafted — the architect approves and signs it, and answering that question honestly is unaffected by this rule.

**Sentence discipline.**
- One instruction per sentence. Active voice, present tense. Compound sentences hide instructions the implementer can miss and the reviewer cannot check item by item.
- References are always resolvable in place: `UC-042`, `RN-3`, `CA-2`, full file paths. Never "the rule above", "as discussed", "the usual adjustment" — deixis and presupposition are the primary failure point for both agents and readers entering mid-document. If it is not in the ITS or a referenced ADR, it does not exist for the reader. Resolving the *address* is the floor; the rule below states what the reference must additionally carry.
- Every criterion is verifiable: numbers, conditions, named rules ("timeout of 30s per RN-5", never "an adequate timeout").
- Project jargon and acronyms are expanded on first occurrence per section. The document will be read outside the story's context.
- When more than one use case is affected, qualify `RN-N` and `CA-N` references with their use case (`UC-042/RN-3`) — these identifiers are scoped per document, and an unqualified reference is ambiguous.

**References resolve in content, not only in address.**
An identifier tells the reader which document holds the answer; it does not tell them the answer. An implementer who knows the code weighs the cost of the lookup against its expected value and skips it — correctly, given a bare identifier. Every reference cited inside an instruction therefore carries, on the same line, the requirement it imposes on this plan; the identifier stays as provenance for the reviewer and the audit.

- `OrderService.confirm — apply UC-042/RN-3` is an address. `OrderService.confirm — reject when the order total exceeds the customer's current credit limit (UC-042/RN-3)` is an instruction.
- The inline text is one line of *requirement*: a rule's obligation, an acceptance criterion's verifiable outcome, an ADR's operational constraint on this plan. It is never the source's content — copying a flow, a full rule statement, or an ADR's rationale is duplication and breaks the single-owner principle.
- Where the requirement cannot be stated in one line without dragging the rationale with it, the reference is in the wrong place. Either the decision is story-scoped — a discarded-alternative line — or the source document is the thing that needs fixing. Summarizing the rationale into the ITS is neither.

The rule holds wherever an instruction cites an identifier: every field of a plan unit — what to do, the delta items it satisfies, the tests it owes — and the out-of-scope boundaries. It does not extend to the Metadata or to the Reference glossary, which are addressed to readers who are not implementing and whose limits are stated in their own rules.

**Self-contained references — the glossary.**
References are resolvable in the repository, but the document is also read where the referenced documents do not exist (the company's documentation platform). The Reference glossary closes that gap:
- One table listing every cited identifier: ID, type, name, and a one-line gloss. For use cases, the Name field; for business rules and acceptance criteria, a one-line paraphrase of intent; for ADRs, the title, the status, and a one-line paraphrase of the **Decision** — what was decided, never why.
- The ADR gloss stops at the decision. Context, Consequences, and the alternatives considered stay in the ADR: the rationale is what the record exists to own, and copying it into every ITS that cites it is the duplication this rule prevents. A reader who needs the rationale goes to the ADR — the gloss tells them whether they need to.
- Like the rest of the glossary, the ADR gloss is a snapshot at delivery: it states the decision as it stood when the plan closed, and the status field carries whether it still stands.
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

**Pre-delivery test.** Before delivering, answer four questions about the finished document:
1. *Implementer test:* does any instruction admit two different implementations? If yes, it is a question the implementer will return — close it now.
2. *Cold-reader test:* does someone who never saw the story — and without access to the use case repository — understand the executive summary and the synthesis sentences, and resolve every cited identifier through the Reference glossary, without opening another document?
3. *Paste test:* pasted into the documentation platform, do tables and heading hierarchy survive?
4. *Author test:* does any sentence describe how the document was produced rather than what must be done? Does any instruction hedge a decision that is already closed?

A document failing any of the four is not deliverable.

## Traceability rules (bidirectional, by delta item and plan unit)

The check lives in **Metadata**, written last with the executive summary. It is evidence, not prose: two lists of identifiers plus the discarded-alternative lines. Its readers are the reviewer and the audit — the implementer does not depend on it to work, which is why it does not sit in the body.

- Delta → plan: every delta item (`UC-NNN/D1`) names the unit that satisfies it, or carries an explicit "already covered" justification.
- Plan → delta: every unit names the delta items it satisfies, or states the technical consequence that justifies it.
- Regression → plan: every regression point is claimed by the unit that covers it.
- **Discarded alternative:** when a unit had more than one viable implementation path, one line states the discarded alternative and the deciding reason. No viable alternative → nothing to state; this is a record of real choices, not a form field.
- **Boundary check:** no architectural decision embedded in the document body — each lives in a referenced ADR.

An ITS failing any of these is not deliverable.

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
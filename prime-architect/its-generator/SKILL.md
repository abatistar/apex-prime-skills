---
name: its-generator
description: Generate an ITS (Instrucao de Trabalho de Software) - the implementation plan mapping a user story and its use case documents to concrete code changes, written against the prime-core/its-contract. Architect-layer skill. Use whenever the architect asks for an implementation plan, impact analysis, "what needs to change in the code", "generate the ITS for story S-NNN", or provides a story plus use case documents. Also use to revise an ITS that the implementation or the code review sent back. Requires the use case repository as input. Do NOT use for writing or updating use case documents (use-case-creator, use-case-extractor) for reviewing an implementation (code-review), for mapping what a change reaches without planning it (impact-mapping), or for judging whether a demand can be absorbed at all (feasibility-analysis).
---

# ITS Generator (prime-architect)

Generate one ITS per story: the work instruction the Developer will implement from. The ITS format is NOT defined here — it is owned by **prime-core/its-contract** (read its SKILL.md and `templates/its-template.md` before writing). This skill defines the *process* of producing an ITS that honors that contract.

Core discipline: **read before proposing**. Never plan changes to code you have not inspected. And process **exactly one delta**: the one belonging to the story at hand.

## Step 0 — Load project configuration and core contracts

Read `docs/prime-config.md` per **prime-core/prime-config** — location, fallback, precedence, divergence handling, and the bootstrap procedure when the file is missing all live in that contract; never re-derive them here. From the config this skill uses: the stack and versions (respect them — do not propose Java 17 features in a Java 11 project), the folder structure as the map for code inspection, the *Conventions and constraints* section in full — the area register, the slot overrides, the declared migrations, the quality model posture, and the project rules — the document locations (including the ADR repository), and the verification commands.

Then load the core contracts this skill writes against: **prime-core/its-contract** (output format and the ITS-vs-ADR decision boundary), **prime-core/use-case** (input format), **prime-core/coding-standards** with `references/convention-slots.md` and the defaults file for the project's stack (the concrete conventions the plan conforms to), and **prime-core/quality-model** with `references/quality-criteria.md` — consumed not as a rulebook to satisfy mechanically, but as the *definition* the plan is interrogated against before delivery (Step 4.6), honoring its calibration and its named-exception discipline. It does not, by itself, approve or reject the plan.

A slot the plan depends on with no value — neither a stack default nor a config override — is a **reportable gap** per prime-core/coding-standards, never a value this skill improvises. Report it and offer to fill it; do not plan a change that rests on it.

## Step 1 — Gather inputs and validate

Required inputs: the story (ID + description) and the use case documents it created or revised. If the architect did not list the affected use cases, find them by searching Revision History entries for the story ID in the use case repository.

Validate each document against the prime-core/use-case format. Two conditions stop the run, and both are reported rather than worked around — a plan built on unvalidated behavior is worse than no plan.

- **Status is not `Reviewed`.** Per prime-core/use-case, only a Reviewed document is source of truth and only a Reviewed document feeds this skill. This holds whatever is holding the document in `Draft` — an unresolved `[CONFIRM: ...]` marker in an unrelated section leaves the whole document outside source of truth, because the status is a property of the document and not of the story's slice of it. Name the markers and route the document back to the architect through use-case-creator; promotion is a human act and no skill performs it.
- **A mandatory section is missing.** Report the gap against the format and stop.

If the story modifies behavior whose use case does not exist at all, recommend running use-case-extractor on that area first.

Also scan the ADR repository for Accepted ADRs touching the affected area — they constrain the plan the same way the config's conventions do. A delta that cannot be satisfied without contradicting one is a decision, not a planning detail: it routes to Step 4.5 and is never absorbed into the plan.

## Step 2 — Locate the delta and classify the scenario

For each affected use case, find the Revision History entry matching the current story ID.

- Entry says the document was **created** by this story → **creation scenario** for this use case.
- Entry lists added/changed/removed items → **change scenario**; that entry is the delta.
- **No entry carries the story ID** → the document was not updated for this story. Do not infer the delta from the story text: report it and route the document to use-case-creator before planning. The one exception is an entry the template's five-entry cap pushed out of the retained history — recover it from version control, where the full history lives, and proceed; when it cannot be recovered, report and stop.

**Older revision entries are read-only.** They describe behavior already implemented — they are state, not pending work. Never treat them as something to implement. Their only legitimate use is in Step 4's hot-area check.

Number the delta items as you locate them (`D1`, `D2`, ...), qualified by use case when more than one is affected (`UC-042/D1`). In the change scenario the revision entry already lists them. In the creation scenario the whole document is the delta: unfold it into items along the axis the plan will satisfy — each main-flow step, each extension, and each business rule or acceptance criterion that does not fall out of one of those — so every unit still names what it satisfies. The numbering is what makes the single-axis plan verifiable: the plan's units cite these identifiers and the traceability check is two lists of them.

## Step 3 — Inspect the codebase (per use case)

**The inspection always happens here.** An `impact-mapping` map is not an input to this step, even when one exists for the demand this story came from. A map is scoped to a demand under refinement and an ITS to exactly one story; refinement can run for months between the two, and by the time the plan exists, verifying the map costs what deriving the reach fresh would. `impact-mapping` states the same boundary from its own side. The architect may of course have read the map; what does not happen is a plan inheriting reach it never verified.

**Creation scenario** — broad, directed exploration:
- Locate entry points, layers, and models related to the actor/action, guided by the config's structure map.
- Find similar existing features to reuse patterns (error handling, validation style, test layout).
- Map every main-flow step and every exception flow to a component, classifying each as: exists as-is / modify / create.
- Every component classified **modify** already serves behavior this story does not change. It enters Step 4's risk sweep, and the unit that modifies it owes the non-regression test for that behavior, named in the unit like any other test. Numbered regression points (`RG-N`) belong to the change scenario: here the coverage is owed by the unit, not tracked as a delta-side identifier.

**Change scenario** — narrow, delta-driven analysis:
1. Use the document (its current body describes the consolidated behavior) to locate the components implementing this use case today.
2. Map **only the delta items**: for each added/changed/removed item, identify the corresponding code and what must change.
3. **Regression analysis** — exclusive to this scenario: identify behavior that did *not* change but shares code with what will change. The full document body (not the delta) tells you everything that must keep working. Number these points (`RG-1`, `RG-2`) — each will be claimed by the plan unit that touches the shared code, and the claim is checked in Step 6.

Throughout the inspection, note every point where more than one viable implementation path exists. These notes feed Step 5 (discarded-alternative lines) and Step 4.5 (ADR candidates).

## Step 4 — Repository-wide risk check and the out-of-scope boundary

For every component slated for modification, check whether it also serves other documented use cases (search the repository). This single sweep yields two different outputs, and merging them is the error to avoid.

**Risk areas.** The use cases that share the component and stay in the plan's path. List them; they raise the test attention the affected units owe. Optionally, if a delta touches a step that also appears in the last 1–2 revision entries of the same document, flag it as a **hot area** (frequently changed → deserves extra test attention). This is a targeted lookup, not a re-reading of history.

**Out-of-scope boundaries.** The contract requires the implementation plan to name what must not be touched, and this is where those borders are derived. Three sources, each entry naming *why it is a border*:

- **Shared but untouched.** Code the inspection reached, serving another use case, that the delta does not require changing — the most likely place for an unrequested improvement to land. Distinct from a regression point: `RG-N` is code the plan **does** touch and that must keep working; a boundary is code the plan **must not** touch at all.
- **Contract surfaces this story does not change.** API shapes, schema, event payloads reached by the inspection whose consumers the story has no mandate to migrate. Naming them is what keeps a convenient signature change from arriving unannounced.
- **Legacy deliberately left alone.** Inherited code in a `legacy-maintained` or `strangler` area the plan runs alongside without correcting — the vehicle Step 4.6 routes such departures into.

An empty boundary list is legitimate and is written as such ("nenhuma identificada"), never omitted: a story genuinely confined to code nobody else uses has no borders to name. What is not legitimate is a border with no reason — the implementer must be able to tell a boundary from an oversight, and the reviewer checks the section item by item.

## Step 4.5 — Detect and propose ADRs

Review the decision points noted in Step 3 against the contract's decision boundary: does any choice constrain future implementations, affect more than one use case or module, or need a rationale readable outside this ITS? If yes:

1. Draft the ADR per the contract's `templates/adr-template.md`, status `Proposed`, in the configured ADR location. The alternatives considered are the point of the record, not padding.
2. **Present it to the architect for approval before delivering the ITS.** The architect decides; you propose. An ITS is not delivered while an ADR it references is still Proposed. If rejected as "story-scoped", the decision falls back to a discarded-alternative line in the ITS.
3. Reference the approved ADR's ID in the ITS metadata, and at every plan unit the decision constrains, state the constraint it imposes there — per the contract's reference rule. The implementer must not need to open the ADR to know what to do; they read it to know why, and because Accepted ADRs are binding context.

**A delta that contradicts an Accepted ADR routes through this step, always.** Never plan around the contradiction silently, and never let the config's conventions settle it — prime-core/prime-config's precedence rule is that a conflict with an Accepted ADR is reported, not resolved. Two outcomes are legitimate: the plan fits under the ADR, and the constraint is stated at the units it binds; or the story genuinely supersedes the decision, and the superseding record is drafted and routed exactly like any other candidate. The superseded ADR takes `Superseded by ADR-NNN` only once the architect approves the replacement.

Do not over-produce: most stories yield zero ADRs. An ADR exists because a real cross-story decision was made, not because the section wants filling.

## Step 4.6 — Interrogate the plan against the quality model and the conventions

Before writing, run the intended plan past **prime-core/quality-model**, consuming it as a definition to question the deliverable against — not as a gate (approval is the reviewer's job, later). Cite criteria by ID. Three questions, from the model's its-generator consumption rule:

- Does any proposed change commit a cardinal sin (a `[NON-NEGOTIABLE]`) **silently**? A non-negotiable may be departed from, but only as a named, owned exception — never by omission.
- Is the proposed level of care **calibrated** to the code's expected lifetime and importance (QM-MT-4)? Flag both under- and over-engineering — excess is as harmful as deficiency.
- Where the plan departs from a criterion for legacy or deliberate debt, is that departure recorded in one of the ITS's own vehicles?

The model defers to **prime-core/coding-standards** wherever a criterion needs a concrete convention to be checkable, so the same pass asks two more questions there, citing slots by ID (`CS-XX-N`):

- Does any planned change violate an **INVARIANT** slot? Those apply to every line written or changed regardless of what surrounds it, and a silent violation is the same defect as a silent non-negotiable — the reviewer blocks on both.
- For each area the plan touches, does the plan follow the **conventional** value that area's registered state calls for — the current standard in a `current` area, the local pattern in `legacy-maintained` and `strangler`, the new value inside a declared migration's scope? A `strangler` area takes no new behavior: new capability planned there belongs in the replacement module the register names.

Record each named departure where it belongs, never as loose prose:
- a **discarded-alternative line** in the Traceability check, when it is a choice between viable paths that dies with the story;
- an **out-of-scope / do-not-touch boundary**, when it is inherited legacy you deliberately leave untouched;
- an **ADR**, when the departure outlives the story — route it back through Step 4.5 for the architect's approval.

This step surfaces improvements; it never blocks delivery on its own. A *silent* non-negotiable violation or a *silent* INVARIANT slot violation, however, is a defect — name it or fix it before writing.

## Step 5 — Write the ITS per the contract

Write the document exactly per **prime-core/its-contract**: file naming, mandatory sections, level of detail, the "instructs, does not implement" rule, and the discarded-alternative rule all come from there. Write the plan in execution order and let it carry the single mapping — the behavior section states the delta and the regression points and stops there. Sequencing is now a writing act, not a separate list: the order you choose is the order the implementer works in and the order the reviewer walks the diff in. Two of the contract's writing rules are where a delivered ITS most often fails its reader, and both are worth re-reading before the first line: *references resolve in content, not only in address*, and *the author's voice*. What this skill adds to the second is only its scope here — the notes taken across Steps 3 through 4.6 are working material, and none of them belongs in the document.

The **Reference glossary** is written from the documents already open: the use cases loaded in Step 1, the business rules and acceptance criteria the plan cites, and the ADRs approved in Step 4.5. Fill each entry as you write the instruction that cites it, while the source is still in front of you — that is what keeps the section a snapshot taken at delivery instead of a reconstruction from memory, and it is why it costs nothing to produce. It resolves *what each identifier is* and stops there: metadata only, and for an ADR the gloss stops at the Decision.

## Step 6 — Verify traceability before delivering

Run the contract's checks and record them in the ITS's Metadata section:
- Delta → plan: every delta item (`UC-NNN/D1`) names the unit that satisfies it, or an explicit "already covered" justification.
- Plan → delta: every unit names its delta items or a stated technical consequence.
- Regression → plan: every `RG-N` is claimed by exactly one unit, with the non-regression test named there.
- Discarded alternative: every point where Step 3 found more than one viable path is closed — a discarded-alternative line carrying the deciding reason, or a referenced ADR. A unit that faced no real choice states nothing; what this check catches is a real choice left unrecorded.
- Boundary check: no architectural decision (per the contract's criteria) embedded in the document body — each one lives in a referenced ADR, and no referenced ADR is still Proposed.
- Out-of-scope check: every entry in "Out of scope — do not touch" states why it is a border (shared but untouched · contract surface not migrated · legacy left alone), and no entry duplicates a regression point — `RG-N` is touched code that must keep working, a boundary is code that must not be touched.
- Quality check: every departure from a prime-core/quality-model criterion or a prime-core/coding-standards slot surfaced in Step 4.6 is recorded as a named exception (discarded-alternative line, out-of-scope boundary, or referenced ADR). No silent non-negotiable violation and no silent INVARIANT slot violation remains.
- Glossary check: every identifier the document cites resolves in the Reference glossary, and no entry carries the source's content where its metadata belongs.

Then run the contract's four pre-delivery tests over the finished document — implementer, cold reader, paste, author. If any check or any test fails, fix the plan — do not deliver an ITS with unexplained scope or buried decisions.

## Revising a delivered ITS

An ITS comes back when the plan did not survive contact with the code: the implementer returned a question the document cannot answer, or the code review's fourth verdict returned the story to the architect. The revision is this same process over a narrower input, under three constraints.

- **Re-enter at the step the problem lives in.** A wrong or missing delta means the use case changed first — route to use-case-creator, then resume from Step 1. A delta mapped to the wrong code re-runs Steps 3 and 4. A decision the plan took without recording it re-runs Step 4.5.
- **Unit numbering is stable.** The implementer has already worked in it and the reviewer walks the diff in it. New work arrives as new units at the end; never renumber a unit someone has implemented. Where a unit no longer applies, its delta items return to the traceability check claimed by the unit that replaces them, under the "already covered" justification the contract allows.
- **Re-run Step 6 in full.** A revised ITS passes the same checks as a new one. A delta item silently orphaned by the revision is the failure this run exists to prevent.

One ITS per story still holds: the revision replaces the document in place. The contract defines no revision history inside the ITS — version control is that record, and no section is invented to hold it.

## Output

One ITS document (named per the contract) in the configured location, plus zero or more ADRs approved by the architect, traceable end-to-end: story → use case deltas → decisions (ADRs) → code changes → tests. A candidate decision the architect rejected as story-scoped leaves no ADR: it lives as a discarded-alternative line in the traceability check.

The operational pass lives in `checklists/its-checklist.md`. The document's own template does not: it is owned by `prime-core/its-contract` and read from there.
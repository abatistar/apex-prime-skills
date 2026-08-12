---
name: its-generator
description: Generate an ITS (Instrucao de Trabalho de Software) - the implementation plan mapping a user story and its use case documents to concrete code changes, written against the prime-core/its-contract. Architect-layer skill. Use whenever the architect asks for an implementation plan, impact analysis, "what needs to change in the code", "generate the ITS for story S-NNN", or provides a story plus use case documents. Requires the use case repository as input. Do NOT use for writing or updating use case documents (prime-docs skills) or for reviewing an implementation (code-review).
---

# ITS Generator (prime-architect)

Generate one ITS per story: the work instruction the Developer will implement from. The ITS format is NOT defined here — it is owned by **prime-core/its-contract** (read its SKILL.md and `templates/its-template.md` before writing). This skill defines the *process* of producing an ITS that honors that contract.

Core discipline: **read before proposing**. Never plan changes to code you have not inspected. And process **exactly one delta**: the one belonging to the story at hand.

## Step 0 — Load project configuration and core contracts

Read `docs/prime-config.md` per **prime-core/prime-config** — location, fallback, precedence, divergence handling, and the bootstrap procedure when the file is missing all live in that contract; never re-derive them here. From the config this skill uses: the stack and versions (respect them — do not propose Java 17 features in a Java 11 project), the folder structure as the map for code inspection, the architectural conventions, the document locations (including the ADR repository), and the verification commands.

Then load the core contracts this skill writes against: **prime-core/its-contract** (output format and the ITS-vs-ADR decision boundary), **prime-core/use-case** (input format), **prime-core/coding-standards** (the concrete conventions the plan conforms to), and **prime-core/quality-model** — consumed not as a rulebook to satisfy mechanically, but as the *definition* the plan is interrogated against before delivery (Step 4.6), honoring its calibration and its named-exception discipline. It does not, by itself, approve or reject the plan.

## Step 1 — Gather inputs and validate

Required inputs: the story (ID + description) and the use case documents it created or revised. If the architect did not list the affected use cases, find them by searching Revision History entries for the story ID in the use case repository.

Validate each document against the prime-core/use-case format. If a document is missing mandatory sections, or is in Draft status with unresolved `[CONFIRM: ...]` markers relevant to the story, report the gaps and stop — a plan built on unvalidated behavior is worse than no plan. If the story modifies behavior whose use case does not exist at all, recommend running prime-docs/use-case-extractor on that area first.

Also scan the ADR repository for Accepted ADRs touching the affected area — they constrain the plan the same way the config's conventions do.

## Step 2 — Locate the delta and classify the scenario

For each affected use case, find the Revision History entry matching the current story ID.

- Entry says the document was **created** by this story → **creation scenario** for this use case.
- Entry lists added/changed/removed items → **change scenario**; that entry is the delta.

**Older revision entries are read-only.** They describe behavior already implemented — they are state, not pending work. Never treat them as something to implement. Their only legitimate use is in Step 4's hot-area check.

## Step 3 — Inspect the codebase (per use case)

**Creation scenario** — broad, directed exploration:
- Locate entry points, layers, and models related to the actor/action, guided by the config's structure map.
- Find similar existing features to reuse patterns (error handling, validation style, test layout).
- Map every main-flow step and every exception flow to a component, classifying each as: exists as-is / modify / create.

**Change scenario** — narrow, delta-driven analysis:
1. Use the document (its current body describes the consolidated behavior) to locate the components implementing this use case today.
2. Map **only the delta items**: for each added/changed/removed item, identify the corresponding code and what must change.
3. **Regression analysis** — exclusive to this scenario: identify behavior that did *not* change but shares code with what will change. The full document body (not the delta) tells you everything that must keep working. List these points for the test strategy.

Throughout the inspection, note every point where more than one viable implementation path exists. These notes feed Step 5 (discarded-alternative lines) and Step 4.5 (ADR candidates).

## Step 4 — Repository-wide risk check

For every component slated for modification, check whether it also serves other documented use cases (search the repository). List those use cases as risk areas. Optionally, if a delta touches a step that also appears in the last 1–2 revision entries of the same document, flag it as a **hot area** (frequently changed → deserves extra test attention). This is a targeted lookup, not a re-reading of history.

## Step 4.5 — Detect and propose ADRs

Review the decision points noted in Step 3 against the contract's decision boundary: does any choice constrain future implementations, affect more than one use case or module, or need a rationale readable outside this ITS? If yes:

1. Draft the ADR (Context, Decision, Consequences, Status: Proposed) in the configured ADR location, presenting the alternatives considered.
2. **Present it to the architect for approval before delivering the ITS.** The architect decides; you propose. If rejected as "story-scoped", the decision falls back to a discarded-alternative line in the ITS.
3. Reference the approved ADR's ID in the ITS metadata.

Do not over-produce: most stories yield zero ADRs. An ADR exists because a real cross-story decision was made, not because the section wants filling.

## Step 4.6 — Interrogate the plan against the quality model

Before writing, run the intended plan past **prime-core/quality-model**, consuming it as a definition to question the deliverable against — not as a gate (approval is the reviewer's job, later). Cite criteria by ID. Three questions, from the model's its-generator consumption rule:

- Does any proposed change commit a cardinal sin (a `[NON-NEGOTIABLE]`) **silently**? A non-negotiable may be departed from, but only as a named, owned exception — never by omission.
- Is the proposed level of care **calibrated** to the code's expected lifetime and importance (QM-MT-4)? Flag both under- and over-engineering — excess is as harmful as deficiency.
- Where the plan departs from a criterion for legacy or deliberate debt, is that departure recorded in one of the ITS's own vehicles?

Record each named departure where it belongs, never as loose prose:
- a **discarded-alternative line** in the Traceability check, when it is a choice between viable paths that dies with the story;
- an **out-of-scope / do-not-touch boundary**, when it is inherited legacy you deliberately leave untouched;
- an **ADR**, when the departure outlives the story — route it back through Step 4.5 for the architect's approval.

This step surfaces improvements; it never blocks delivery on its own. A *silent* non-negotiable violation, however, is a defect — name it or fix it before writing.

## Step 5 — Write the ITS per the contract

Write the document exactly per **prime-core/its-contract**: file naming, mandatory sections, level of detail, the "instructs, does not implement" rule, and the discarded-alternative rule all come from there. Remember the reader: the Developer will implement from this document and is instructed to return questions rather than assume — every ambiguity you leave is a round-trip you cause.

## Step 6 — Verify traceability before delivering

Run the contract's bidirectional check per use case section and record it in the ITS:
- Delta → plan: no delta item without a planned change or an explicit "already covered" justification.
- Plan → delta: no planned change without a referenced delta item or a stated technical-consequence justification.
- Boundary check: no architectural decision (per the contract's criteria) embedded in the ITS body — each one lives in a referenced ADR.
- Quality check: every departure from a prime-core/quality-model criterion surfaced in Step 4.6 is recorded as a named exception (discarded-alternative line, out-of-scope boundary, or referenced ADR). No silent non-negotiable violation remains.

If any check fails, fix the plan — do not deliver an ITS with unexplained scope or buried decisions.

## Output

One ITS document (named per the contract) in the configured location, plus zero or more Proposed/Accepted ADRs, traceable end-to-end: story → use case deltas → decisions (ADRs) → code changes → tests.
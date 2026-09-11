# ITS — operational pass

The operational pass for `prime-architect/its-generator`. **No document template lives here:** the ITS's structure is owned by `prime-core/its-contract` (`templates/its-template.md`) and is never copied into this layer. This file checks the *process*; that file supplies the *form*.

## Configuration and contracts

- [ ] `docs/prime-config.md` read per the **prime-core/prime-config** contract.
- [ ] From the config: stack and versions, structure map, *Conventions and constraints* in full (area register, slot overrides, declared migrations, quality model posture, project rules), document and ADR locations, verification commands.
- [ ] Core contracts loaded: `its-contract` (+ template), `use-case`, `coding-standards` (+ `references/convention-slots.md` and the stack defaults), `quality-model` (+ `references/quality-criteria.md`).
- [ ] A slot the plan depends on with no value → reported as a gap (`coding-standards`, Unfilled slots). Never improvised.
- [ ] Divergence between config and codebase → reported, not silently resolved.

## Inputs

- [ ] Story identified; affected use cases listed, or found by searching Revision History for the story ID.
- [ ] Every affected document has Status `Reviewed`. Anything else → report and stop; route to use-case-creator. Promotion is a human act.
- [ ] Every affected document passes the `use-case` format: no missing mandatory section.
- [ ] Behavior with no use case at all → `use-case-extractor` recommended for that area first.
- [ ] Accepted ADRs touching the affected area listed. A delta that cannot be satisfied without contradicting one → routed to the ADR step, never absorbed into the plan.

## Delta and scenario

- [ ] Per use case, the Revision History entry for **this** story located.
- [ ] Scenario classified: creation | change.
- [ ] No entry for the story ID → reported and routed to use-case-creator; the only exception is an entry the five-entry cap pushed out, recovered from version control.
- [ ] Older revision entries treated as read-only state — never as pending work.
- [ ] Delta items numbered (`D1`, `D2`, ...), qualified per use case when more than one is affected.
- [ ] Creation scenario: the whole document unfolded into numbered items along the axis the plan satisfies.

## Inspection

- [ ] The inspection performed here in full. No `impact-mapping` map used as an input, however recent.
- [ ] Nothing planned against code that was not opened.
- [ ] Creation: entry points, layers and models located; similar features found for pattern reuse; every main-flow step and exception flow mapped to a component classified as exists as-is / modify / create.
- [ ] Creation: every component classified **modify** carries the non-regression test owed by the unit that touches it.
- [ ] Change: only the delta items mapped to code.
- [ ] Change: regression points numbered (`RG-1`, `RG-2`) from the document body, not from the delta.
- [ ] Every point with more than one viable implementation path noted for the discarded-alternative line or the ADR step.

## Risk and out-of-scope boundary

- [ ] Every component slated for modification checked against the rest of the repository.
- [ ] **Risk areas** listed: other documented use cases sharing the component, raising the test attention their units owe.
- [ ] **Boundaries** derived and separated from risk areas, each naming why it is a border: shared but untouched · contract surface not migrated · legacy left alone.
- [ ] No boundary duplicates a regression point. `RG-N` is touched code that must keep working; a boundary is code that must not be touched.
- [ ] Nothing under risk of accidental change → the section says so explicitly ("nenhuma identificada"), never omitted.

## Decisions (ADR)

- [ ] Each decision point tested against the contract's decision boundary: constrains future implementations · affects more than one use case or module · needs rationale readable outside this ITS.
- [ ] Candidate drafted as Proposed (Context, Decision, Consequences, Status) in the configured location, with the alternatives considered.
- [ ] Presented to the architect. No ITS delivered while an ADR it references is still Proposed.
- [ ] Rejected as story-scoped → falls back to a discarded-alternative line.
- [ ] Approved → referenced by ID in Metadata, and its constraint stated at every unit it binds.
- [ ] Contradiction with an Accepted ADR → either the plan fits under it, or a superseding record is routed for approval. Never resolved silently.
- [ ] No ADR produced to fill a section. Most stories yield zero.

## Quality and conventions

- [ ] `[NON-NEGOTIABLE]` criteria: no silent departure anywhere in the plan (`QM-XX-N` cited by ID).
- [ ] Level of care calibrated to the code's lifetime and importance (`QM-MT-4`). Under- and over-engineering both flagged.
- [ ] INVARIANT slots: no violation planned (`CS-XX-N` cited by ID).
- [ ] CONVENTIONAL slots: the value matches each area's registered state — current standard in `current`, local pattern in `legacy-maintained` and `strangler`, the new value inside a declared migration's scope.
- [ ] No new behavior planned into a `strangler` area.
- [ ] Every departure recorded in one of the ITS's vehicles: discarded-alternative line · out-of-scope boundary · referenced ADR.

## Writing

- [ ] Written per `its-contract`: naming, mandatory sections, level of detail, "instructs, does not implement".
- [ ] Plan written in execution order; the behavior section carries the delta and the regression points and nothing the plan restates.
- [ ] Every cited reference carries its requirement on the same line.
- [ ] No sentence narrates how the plan was produced. Working notes stayed out of the document.
- [ ] Reference glossary filled from the documents already open, metadata only; the ADR gloss stops at the Decision.
- [ ] Executive summary and Metadata written last.

## Traceability before delivering

- [ ] **Delta → plan:** every delta item names its unit, or carries an explicit "already covered" justification.
- [ ] **Plan → delta:** every unit names its delta items or a stated technical consequence.
- [ ] **Regression → plan:** every `RG-N` claimed by exactly one unit, with the non-regression test named there.
- [ ] **Discarded alternative:** every real choice from the inspection is closed by a line with its deciding reason, or by a referenced ADR.
- [ ] **Boundary:** no architectural decision embedded in the body; no referenced ADR still Proposed.
- [ ] **Out of scope:** every entry states why it is a border; none duplicates a regression point.
- [ ] **Quality:** every departure from a `QM-XX-N` criterion or a `CS-XX-N` slot recorded as a named exception. No silent non-negotiable and no silent INVARIANT violation remains.
- [ ] **Glossary:** every cited identifier resolves; no entry carries content where metadata belongs.
- [ ] The contract's four pre-delivery tests run over the finished document: implementer · cold reader · paste · author.

## When revising a delivered ITS

- [ ] Re-entered at the step the problem lives in, not at the top.
- [ ] Unit numbering preserved. New work appended as new units; nothing already implemented renumbered.
- [ ] Delta items of a dropped unit re-claimed in the traceability check.
- [ ] This whole traceability pass re-run in full.
- [ ] No revision-history section invented inside the ITS — version control is that record.

## Boundary check before delivering

- [ ] No application code written or proposed.
- [ ] No use case patched, no use case status promoted.
- [ ] No configuration file edited as a side effect.
- [ ] Nothing decided on the architect's behalf: proposals were presented, not applied.

# Review Checklist

Operational pass owned by `prime-architect/code-review`. The SKILL.md defines the standard, the severities, the verdicts, and the boundaries — this file is the sequence and the report shape.

**This checklist holds no criteria.** Every item points at the ID where the answer lives (`QM-XX-N` in `prime-core/quality-model`, `CS-XX-N` in `prime-core/coding-standards`, the ITS section, or `UC-NNN/CA-N`). An item you cannot resolve to an ID is not a finding — it is a preference, or a gap to report.

---

## 0. Preconditions — do not start without these

- [ ] The **ITS for the story** is located and read, together with every ADR it references.
- [ ] The **use cases** it names are read: the delta for this story and the acceptance criteria the delta touches.
- [ ] `docs/prime-config.md` is loaded (pipeline and required checks, verification commands, area register, slot overrides).
- [ ] The **required checks are green**. Red pipeline → the review does not start. Red because of a flaky test → that is a `Blocking:` finding on its own (`QM-TS-1`).
- [ ] The diff is reviewable in one sitting. If not: ask for a split, or declare the plan units you will review and in which order.

*No ITS → report and stop, unless the change is declared out-of-process; then state that scope conformance was not checkable.*

## 1. First pass — does the change make sense as a whole?

- [ ] Can I state what this change should do before reading the diff?
- [ ] Does the direction taken match the plan, or did the author solve a different problem?
- [ ] Which files should have been touched, and which behavior must keep working (ITS regression points)?

*Wrong direction → stop here and say so. Do not annotate code that should not exist.*

## 2. Scope conformance (diff ⇄ plan, both directions)

- [ ] **Plan → diff**: every planned change is present, or its absence is justified.
- [ ] **Diff → plan**: every changed file traces to a plan item or a stated technical consequence. Unrequested improvements count as scope creep (`QM-CN-1`).
- [ ] **Boundaries**: nothing in "Out of scope — do not touch" was touched.
- [ ] **ADRs**: no contradiction with an Accepted ADR; no architectural decision landed without one.
- [ ] **Divergence**: departures from the plan were returned as questions and the ITS revised — not applied silently.

## 3. Lenses, in order (design first)

- [ ] **Design** — boundaries, coupling, does it fit the system? `QM-CC-1..5`, `CS-AR-1..5`.
- [ ] **Functionality** — behavior against `UC-NNN/CA-N`; concurrency, edge cases, failure paths (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`).
- [ ] **Complexity** — readable quickly (`QM-RC-2/3/4`); speculative generality is complexity (`QM-MT-4`).
- [ ] **Tests** — obligation `CS-TS-1`; scope from the ITS test strategy; behavior not implementation `QM-TS-2`; trustworthy `QM-TS-1`, `CS-TS-4`. Regression points covered.
- [ ] **Naming** — `QM-RC-1`, `CS-NM-2`: no name concealing I/O, mutation, or an event.
- [ ] **Comments** — `QM-RC-5`, `QM-DO-2`: *why*, not *what*.
- [ ] **Style and consistency** — conventional slots judged against the area's registered state (`current` / `legacy-maintained` / `strangler`). In legacy-maintained, a conventional finding is valid only if a **third** pattern was introduced.
- [ ] **Security** — `QM-SR-*` and `CS-SC-*` on every new boundary: input validated, secrets absent, authorization at the right layer, nothing sensitive in logs (`CS-OB-3`).
- [ ] **Documentation** — `QM-DO-1`: no co-located document left lying by the change.
- [ ] **Every line** a human will maintain was actually read.
- [ ] **One thing done well** is identified and named.

## 4. Classification

For each finding: **where · what · why (ID) · what is expected**.

| Severity | Use for | Blocks merge |
|---|---|---|
| `Blocking:` | INVARIANT slot violated; `[NON-NEGOTIABLE]` violated **silently**; missing obligatory test; unagreed scope creep or crossed boundary; conflict with an Accepted ADR; decision without an ADR; document left lying | yes |
| `Consider:` | `[CALIBRATED]` criteria and CONVENTIONAL slots with a real argument; the author may decline with a reason | no |
| `Nit:` | trivial, author's option. Mechanizable → not a nit: record a toolchain gap | no |
| `FYI:` | context, teaching, praise — no obligation | no |

- [ ] Every finding cites an ID.
- [ ] Named, owned, justified departures were classified as recorded exceptions, not as blockers (`QM-MT-1`).
- [ ] Repeated small findings in one area were aggregated into the design finding that causes them.

## 5. Verdict — exactly one

- [ ] **Approve** — no blocking finding.
- [ ] **Approve with comments** — nothing blocking; Considers left to the author, no second round required.
- [ ] **Request changes** — at least one `Blocking:`, listed separately from everything else.
- [ ] **Return to the architect** — the plan is wrong, incomplete, or overtaken; or a decision needs an ADR. Routes back to its-generator or prime-docs.

*Never approve a change you did not understand.*

## 6. Follow-ups to register before closing

- [ ] ADR to propose (its-generator, architect approves).
- [ ] ITS or use case to revise, with the section named.
- [ ] Unfilled slot to report (`coding-standards`, Unfilled slots) — never improvised.
- [ ] Toolchain gap (a check a human made that a tool should own — `QM-CN-3`).
- [ ] Deliberate debt to register, with an owner (`QM-MT-1`).

---

## Report template

````markdown
# Review — [PR / branch] · ITS-<story-id>

**Verdict:** Approve | Approve with comments | Request changes | Return to the architect
**Reason:** [one line]

## Scope conformance
- Plan → diff: [complete | gaps listed below]
- Diff → plan: [clean | scope creep listed below]
- Out-of-scope boundaries: [respected | crossed at ...]
- ADRs: [consistent | conflict with ADR-NNN | ADR to propose]

## Findings
| # | Severity | Location | Criterion | Finding and expectation |
|---|---|---|---|---|
| 1 | Blocking | `path/File.java:42` | QM-EO-1 / CS-ER-6 | [what is wrong and what is expected] |
| 2 | Consider | `path/Other.java:88` | QM-RC-4 | [argument, author may decline with a reason] |
| 3 | Nit | `path/Third.java:12` | CS-NM-1 | [trivial, author's option] |

## Follow-ups
- [ADR to propose / ITS section to revise / slot gap / toolchain gap / debt registered with owner]

## Done well
- [what should be repeated]
````
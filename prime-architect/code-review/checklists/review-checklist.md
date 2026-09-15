# Review Checklist

Operational pass owned by `prime-architect/code-review`. The SKILL.md defines the standard, the severities, the verdicts, and the boundaries — this file is the sequence and the report shape.

**This checklist holds no criteria.** Every item points at the ID where the answer lives (`QM-XX-N` in `prime-core/quality-model`, `CS-XX-N` in `prime-core/coding-standards`, the ITS section, or `UC-NNN/CA-N`). An item you cannot resolve to an ID is not a finding — it is a preference, or a gap to report.

---

## 0. Preconditions — do not start without these

- [ ] The **ITS for the story** is located and read, together with every ADR it references.
- [ ] The **use cases** it names are read: the delta for this story and the acceptance criteria the delta touches.
- [ ] `docs/prime-config.md` is loaded (pipeline and required checks, verification commands, area register, slot overrides).
- [ ] The **required checks are green**, per Step 0. No pipeline declared → the config's verification commands ran in their place. Red because of a flaky test → the review starts and that is a `Blocking:` finding on its own (`QM-TS-1`).
- [ ] The diff is reviewable in one sitting. If not: ask for a split, or declare the plan units you will review and in which order.

*No ITS → report and stop, unless the change is declared out-of-process; then state that scope conformance was not checkable.*

## 1. First pass — does the change make sense as a whole?

- [ ] Can I state what this change should do before reading the diff?
- [ ] Does the direction taken match the plan, or did the author solve a different problem?
- [ ] Which files should have been touched — read off the plan's units — and which behavior must keep working (the regression points and the unit that claimed each)?

*Wrong direction → stop here and say so. Do not annotate code that should not exist.*

## 2. Scope conformance (diff ⇄ plan, both directions)

- [ ] **Plan → diff**: every unit of the plan is present, or its absence is justified; every test a unit owes exists.
- [ ] **Diff → plan**: every changed file traces to a unit or a stated technical consequence. Unrequested improvements count as scope creep (`QM-CN-1`).
- [ ] **Boundaries**: nothing in "Out of scope — do not touch" was touched.
- [ ] **ADRs**: no contradiction with an Accepted ADR; no architectural decision landed without one.
- [ ] **Divergence**: departures from the plan were returned as questions and the ITS revised — not applied silently.

## 3. Lenses, in order (design first)

- [ ] **Design** — boundaries, coupling, does it fit the system? `QM-CC-1..5`, `CS-AR-1..5`.
- [ ] **Functionality** — behavior against `UC-NNN/CA-N`; concurrency, edge cases, failure paths (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`).
- [ ] **Complexity** — readable quickly (`QM-RC-2/3/4`); speculative generality is complexity (`QM-MT-4`).
- [ ] **Tests** — obligation `CS-TS-1`; scope from each plan unit's declared tests; behavior not implementation `QM-TS-2`; trustworthy `QM-TS-1`, `CS-TS-4`. Regression points covered.
- [ ] **Naming** — `QM-RC-1`, `CS-NM-2`: no name concealing I/O, mutation, or an event.
- [ ] **Comments** — `QM-RC-5`, `QM-DO-2`: *why*, not *what*.
- [ ] **Style and consistency** — conventional slots judged against the area's registered state (`current` / `legacy-maintained` / `strangler`). In legacy-maintained, a conventional finding is valid only if a **third** pattern was introduced.
- [ ] **Security** — `QM-SR-*` and `CS-SC-*` on every new boundary: input validated, secrets absent, authorization at the right layer, nothing sensitive in logs (`CS-OB-3`).
- [ ] **Documentation** — `QM-DO-1`: no co-located document left lying by the change. Delivered behavior diverging from the use case routes to the use case skills, never patched here.
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
- [ ] **Return to the architect** — the plan is wrong, incomplete, or overtaken; or a decision needs an ADR. Routes back to its-generator or the use case skills.

*Never approve a change you did not understand.*

## 6. Follow-ups to register before closing

- [ ] ADR to propose (its-generator, architect approves).
- [ ] ITS or use case to revise, with the section named.
- [ ] Unfilled slot to report (`coding-standards`, Unfilled slots) — never improvised.
- [ ] Toolchain gap (a check a human made that a tool should own — `QM-CN-3`).
- [ ] Deliberate debt to register, with an owner (`QM-MT-1`).

## 7. Boundary check before delivering

- [ ] No application code written: the deliverables are findings and, where the plan itself was wrong, a revised ITS.
- [ ] No criterion restated in a comment. Every finding points at an ID owned elsewhere.
- [ ] No use case status promoted, no documentation rewritten, no configuration file edited as a side effect.
- [ ] Nothing re-litigated that the toolchain already owns (`QM-CN-3`); its absence recorded as a gap instead.

---

## Template do relatório

**Language.** The block below is the artifact the reviewer files, and it is written in the document language the core templates use: `pt-BR`. The checklist above is skill-facing and stays in English. Section titles are translated; the stable tokens — the four verdicts, the four severities, `QM-XX-N`, `CS-XX-N`, `UC-NNN`, `ADR-NNN`, `ITS-<story-id>`, file paths and identifiers — are never translated.

````markdown
# Revisão — [PR / branch] · ITS-<story-id>

**Veredito:** Approve | Approve with comments | Request changes | Return to the architect
**Razão:** [uma linha]

## Conformidade de escopo
- Plano → diff: [completo | lacunas listadas abaixo]
- Diff → plano: [limpo | escopo excedido listado abaixo]
- Fronteiras de fora de escopo: [respeitadas | cruzadas em ...]
- ADRs: [consistente | conflito com ADR-NNN | ADR a propor]

## Achados
| # | Severidade | Local | Critério | Achado e expectativa |
|---|---|---|---|---|
| 1 | Blocking | `caminho/Arquivo.java:42` | QM-EO-1 / CS-ER-6 | [o que está errado e o que se espera] |
| 2 | Blocking | `caminho/Novo.java` (arquivo inteiro) | ITS › Plano, unidade 4 | [nenhuma unidade do plano pede este arquivo: escopo excedido] |
| 3 | Blocking | `caminho/Pedido.java:120` | UC-042/CA-2 | [o comportamento entregue diverge do critério de aceite] |
| 4 | Consider | `caminho/Outro.java:88` | QM-RC-4 | [argumento; o autor pode declinar com uma razão] |
| 5 | Nit | `caminho/Terceiro.java:12` | CS-NM-1 | [trivial, opção do autor] |

## Follow-ups
- [ADR a propor / seção do ITS a revisar / lacuna de slot / lacuna de toolchain / dívida registrada com responsável]

## Feito bem
- [o que deve ser repetido]
````
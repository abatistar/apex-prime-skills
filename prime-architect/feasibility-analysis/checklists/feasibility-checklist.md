# Feasibility analysis — operational pass

## 0. Inputs loaded

- [ ] `docs/prime-config.md` read per `prime-core/prime-config`: stack and versions, structure map, **area register**, slot overrides, document locations, verification commands.
- [ ] `prime-core/quality-model` + `references/quality-criteria.md`.
- [ ] `prime-core/coding-standards` + `references/convention-slots.md` and the stack defaults.
- [ ] Accepted ADRs scanned.

## 1. The demand, restated

- [ ] One or two sentences naming the **observable outcome** claimed.
- [ ] Confirmed with the architect.
- [ ] What the demand explicitly does **not** claim is written down.
- [ ] If no observable outcome could be stated → returned at this step, nothing further judged.

## 2. The map

- [ ] `impact-mapping` run on the restated demand.
- [ ] Map cited by **ID and data**. Map without data is not a citable reference.    
- [ ] Three degrees read: direct, coupled, contract surface.
- [ ] Area states read from the map's register overlay.
- [ ] Documented layer read: coverage, divergences, ADR incidence.
- [ ] **Stated edge** read — where the map stopped, and whether the verdict turns on anything beyond it.
- [ ] Undocumented affected area → `Condition:` with owner and route to `use-case-extractor`. Exception: the undocumented area is where a Blocker: would rest → Undecidable, exception stated and justified. Green-field touching nothing existing → noted, no baseline required.
- [ ] Code × use case divergence → recorded; neither side is a safe baseline. May carry the run to *Undecidable*.

## 3. Lenses, in order

- [ ] **Constraint** — stack/version ceiling, platform, missing data, external dependency, license, regulation. The only source of true impossibility.
- [ ] **Structural fit** — `CS-AR-1..5`, `QM-CC-1..5`, ADR incidence from the map. Contradicting an ADR is an **ADR question**, not a blocker: `Condition:` naming the ADR, owner architect, route to the ADR lifecycle. No ADR drafted here.
- [ ] **Contract surface** — can every known consumer be migrated? Is the consumer set enumerable at all?
- [ ] **Verification** — verification commands, observability present, test obligation (`CS-TS-1`).
- [ ] **Erosion risk** — does the cheapest path create a second way of doing something (`QM-CN-1`)?
- [ ] **Concurrency and scale** — only if the outcome implies them (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`).
- [ ] **Security surface** — every new boundary (`QM-SR-*`, `CS-SC-*`).
- [ ] No re-walking of code the map already walked.

## 4. Evidence

- [ ] Every finding carries its anchor from the map: **anchored**, `[INFERRED]`, or `[UNVERIFIED]`.
- [ ] Vocabulary reused from `impact-mapping`, not redefined here.
- [ ] No `Blocker:` resting on `[INFERRED]` or `[UNVERIFIED]` evidence.

## 5. Classification

| Severity | Use for | Contributes to |
|---|---|---|
| `Blocker:` | hard constraint; invariant contradicted with no path around it. Anchored evidence required | Not viable as specified |
| `Condition:` | feasible once something is true first. **Owner + route mandatory** | Viable with conditions |
| `Cost driver:` | changes the size, not the answer: area state, breadth of the coupled set, contract surfaces crossed, missing observability, debt created | none |
| `FYI:` | context for the demander | none |

*This table classifies findings; it does not decide the verdict. Verdict resolution is §6 —
the evidence base can override rules 3 and 4 regardless of what was classified here.*

- [ ] Every finding cites an ID or an evidence anchor.
- [ ] Every `Condition:` has an owner and a route (a condition without a route is a blocker in disguise).
- [ ] Findings caused by one structural fact aggregated into that fact.
- [ ] No effort estimate in hours, points, or sprints anywhere in the report.

## 6. Verdict — exactly one

Resolve in order, first match wins:

- [ ] **1. Anchored `Blocker:` present** → *Not viable as specified*. Blockers listed separately
      **and** what would have to change in the demand. Evidence gaps elsewhere registered as
      follow-ups, never used to soften the ruling.
- [ ] **2. No anchored blocker + evidence base insufficient** → *Undecidable with current evidence*.
      Insufficient means exactly one of: edge short of what the verdict turns on · open divergence,
      no safe baseline · undocumented area carrying the demand's hardest constraint · untested
      dependency the outcome rests on. Names the single run that would decide it. A blocker resting
      on `[INFERRED]` or `[UNVERIFIED]` evidence lands here, not in rule 1.
- [ ] **3. At least one `Condition:`** → *Viable with conditions*, each condition owned and routed.
- [ ] **4. None of the above** → *Viable*.

- [ ] `Cost driver:` and `FYI:` did not move the verdict.

*Never deliver a verdict on a demand you did not understand.*
*Viable authorizes refinement, never skipping the specification pipeline.*

## 7. Follow-ups to register before closing

- [ ] Extractor run required for a baseline.
- [ ] Divergence routed to prime-docs (`QM-DO-1`) — never patched here.
- [ ] ADR decision to raise (`Condition:`, owner architect) — the ADR is drafted by whoever takes the decision, never in this report.
- [ ] Unfilled slot to report (`coding-standards`) — never improvised.
- [ ] Config gap: a project fact the analysis needed and the config does not carry.
- [ ] Debt the viable path would create, with a prospective owner (`QM-MT-1`).

---

## Template do relatório

````markdown
# Viabilidade — FA-<id-da-demanda>-N
**Data:** [data] · **Demanda:** [nos termos de quem pediu]
**Veredito:** Viable | Viable with conditions | Not viable as specified | Undecidable with current evidence
**Razão:** [uma linha]

**Veredito:** Viable | Viable with conditions | Not viable as specified | Undecidable with current evidence
**Razão:** [uma linha]

## A demanda, como julgada
- Resultado observável: [uma ou duas frases]
- Explicitamente fora do escopo: [fronteira]

## Base de evidência
- **Mapa de impacto:** IM-<id>-N de [data] — [referência; não reproduzir aqui]
- Baseline: [documentada | parcial — extractor exigido em X | divergência aberta em UC-NNN | green-field]
- Borda do mapa: [o veredito depende de algo além dela? sim/não — se sim, veredito é Undecidable (§6, regra 2)]

## Achados
| # | Severidade | Onde | Critério / evidência | Achado e implicação |
|---|---|---|---|---|
| 1 | Blocker | `pom.xml` (ancorado) | teto de stack — config | [o que é impossível e por quê] |
| 2 | Condition | UC-042 ausente | baseline | [o que precisa ser verdade antes] · responsável: [x] · rota: use-case-extractor |
| 3 | Cost driver | `billing/legacy` | area register | [o que aumenta o tamanho] |

## Se Not viable — o que teria de mudar na demanda
- [a porta de saída]

## Se Undecidable — a corrida que decidiria
- [extractor na área X | spike em Y | medição de Z]

## Follow-ups
- [corrida do extractor / divergência para prime-docs / ADR a propor / lacuna de slot / lacuna de config / dívida com responsável]
````

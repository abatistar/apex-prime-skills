# Impact map — operational pass

## Configuration

- [ ] `docs/prime-config.md` read per the **prime-core/prime-config** contract.
- [ ] Structure map, area register, document locations (UC, ADR), and verification commands loaded.
- [ ] Unfilled slot or unregistered area recorded as a gap (`coding-standards`, Unfilled slots) — never improvised.

## The change, as behavior

- [ ] Restated as an observable behavior delta, not as a solution.
- [ ] Boundary stated: what is explicitly **not** changing.
- [ ] If the restatement required inventing intent → **Insufficient input**, with the specific questions. Stop here.
- [ ] Solution named in the input while other behavior deltas exist → noted in one line, not evaluated.

## Entry points

- [ ] Every trigger located and anchored: endpoint, job, event handler, CLI, UI action, migration.
- [ ] Entry points the search could not reach (dynamic dispatch, reflection, config-driven wiring, framework convention) recorded as a gap with its resolution.

## Reach, in three degrees

- [ ] **Direct** — must change for the behavior to change. Smallest honest set.
- [ ] **Coupled** — callers, subscribers, reports, fixtures, tests, flags, readers of the same persisted state.
- [ ] **Contract surface** — API shapes, DB schema, event payloads, exported files, shared signatures. Known consumers named, not entered.
- [ ] Every entry carries location, degree, and one line of *why it is in the map*.

## Area register overlay

- [ ] Each touched area carries its registered state: `current` / `legacy-maintained` / `strangler`.
- [ ] State taken from the configuration — never inferred from directory name or file age.
- [ ] State recorded, **not** priced.

## Documented layer overlay

- [ ] Use case coverage listed (`UC-NNN`, `CA-N` where specific).
- [ ] Touched behavior with no use case → documentation gap, area named, `use-case-extractor` noted as the route.
- [ ] Code × use case divergence recorded as a finding and routed to prime-docs (`QM-DO-1`). No use case patched here.
- [ ] Accepted ADRs bearing on the touched areas listed; apparent contradiction stated and cited, **not resolved**.

## Procedence

- [ ] Every line is exactly one of: **anchored** (`path/File.ext:line` or `UC-NNN/CA-N`, read), **`[INFERRED]`** with the reasoning on the line, **`[UNVERIFIED]`** (asserted, not checked), or **gap** with what would resolve it.
- [ ] No unmarked inference anywhere in the report.
- [ ] This vocabulary is defined by this skill and reused unchanged by its consumers.

## The edge

- [ ] Stopped at the contract surface; consumers named, not traced into.
- [ ] Stopped where there is no behavioral dependence.
- [ ] What was deliberately not traced is written down, with what would justify tracing it.

## Boundary check before delivering

- [ ] No verdict, no recommendation, no estimate anywhere in the report.
- [ ] No application code written or proposed.
- [ ] No use case, ITS, ADR, or configuration file modified.

---

## Template do relatório

````markdown
# Mapa de impacto — IM-<id-da-demanda>-N
**Data:** [dia em que o código foi lido] · **Demanda:** [nos termos de quem pediu]

## A mudança
**Delta de comportamento:** [o que ficará observavelmente diferente, e para quem]
**Não muda:** [fronteira explícita, nos mesmos termos]
**Observação:** [somente se a entrada nomeou uma solução e havia outros deltas viáveis — uma linha, sem avaliação]

## Alcance

### Direto — precisa mudar
| Local | Por que está no mapa |
|---|---|
| `caminho/Arquivo.ext:42` | [uma linha] |

### Acoplado — não muda, mas depende do que muda
| Local | Relação | Por que está no mapa |
|---|---|---|
| `caminho/Outro.ext:88` | chamador / assinante / teste / estado compartilhado | [uma linha] |

### Superfície de contrato — visível fora desta base de código
| Superfície | Consumidores conhecidos | Por que está no mapa |
|---|---|---|
| formato da resposta de `POST /orders` | [consumidores nomeados, não rastreados por dentro] | [uma linha] |

## Estados das áreas
| Área | Estado registrado |
|---|---|
| [área] | current / legacy-maintained / strangler |

## Camada documentada
- **Cobertura:** UC-NNN (CA-N, CA-N) cobre [o quê]
- **Lacuna de documentação:** [área] — sem caso de uso para [comportamento]. Rota: `use-case-extractor`.
- **Divergência:** UC-NNN/CA-N afirma [X]; `caminho/Arquivo.ext:120` faz [Y] (`QM-DO-1`). Rota: prime-docs.
- **Incidência de ADR:** ADR-NNN incide sobre [área]. [Contradição aparente, declarada e citada — não resolvida.]

## Lacunas e questões em aberto
| Lacuna | O que resolveria |
|---|---|
| [o que não foi possível determinar] | [o artefato, rastreio ou resposta que fecha a questão] |

## Onde este mapa para
- [o que deliberadamente não foi rastreado, e o que justificaria rastrear]
````

# ADR Template

Canonical template owned by prime-core/its-contract. The its-generator drafts against it; the architect approves it; code-review blocks on a decision that landed in code without one. See the its-contract SKILL.md for the decision boundary that says when a decision is owed an ADR at all, and for the glossary rule that governs how an ITS cites one.

**Language.** The block below is the artifact and is written in the document language of this format: `pt-BR`; the guidance around it is skill-facing and stays in English. Section titles are translated; the stable tokens cited here — `ADR-NNN`, the status values (`Proposed`, `Accepted`, `Superseded by ADR-NNN`), `UC-NNN`, `ITS-<story-id>`, `QM-XX-N`, `CS-XX-N`, file paths and identifiers — are never translated.

## File naming convention

`docs/adr/ADR-NNN-titulo-curto.md`, or as overridden by `docs/prime-config.md` › Document repository. `NNN` is sequential across the repository and is never renumbered; a retired decision keeps its number and takes the `Superseded by ADR-NNN` status. The slug follows the document language; the `ADR-NNN` prefix does not.

## Status lifecycle

- **Proposed** — drafted, not yet approved. An ITS is never delivered while an ADR it references is still `Proposed`.
- **Accepted** — approved by the architect. Binding context for every implementer and every later plan. The config does not override it; a conflict between the two is reported, not resolved silently.
- **Superseded by ADR-NNN** — replaced. The record stays in place with its rationale intact, pointing at its replacement. The status changes only when the architect approves the replacement.

Only the architect moves an ADR between statuses. The its-generator drafts and proposes.

## Scope rules

- **Who files it.** A decision a plan must commit to is drafted by the its-generator and approved by the architect. A decision taken where no plan exists yet, at refinement or in architectural counsel, is drafted by the architect directly and needs no story. The `Origem` field records which of the two happened. No other skill drafts one.
- One decision per record. A document carrying two decisions cannot be superseded by half.
- **Consequences are not a disclaimer.** State what the decision costs as well as what it buys, including what it forecloses. A record that lists only benefits is advocacy, not a decision record.
- **The rationale lives here and only here.** An ITS citing this record carries one line of the operational constraint the decision imposes on its plan, never the context or the alternatives. That single ownership is why a reader who needs the why comes to this document.
- Alternatives considered are the point of the record, not padding. A decision with no viable alternative was not a decision, and probably did not need an ADR.

````markdown
# ADR-NNN — [Título da decisão, em substantivo: "Estratégia de idempotência para consumidores"]

| Campo | Valor |
|---|---|
| **ID** | ADR-NNN |
| **Status** | Proposed · Accepted · Superseded by ADR-NNN |
| **Data** | AAAA-MM-DD |
| **Origem** | ITS-<story-id> · demanda em refinamento · conselho arquitetural |
| **Escopo** | [módulos, camadas ou casos de uso que a decisão vincula] |
| **Substitui** | ADR-NNN, ou "nenhum" |

## Contexto

[A situação que obrigou a decidir, em linguagem de comportamento e de restrição. As forças em
jogo: exigência do negócio, limite da stack, decisão anterior, custo operacional. O que era
verdade quando se decidiu — este bloco não é reescrito depois, é o que data a decisão.]

## Decisão

[O que ficou decidido, em uma ou duas frases, na voz de quem instrui. Sem hedge: a decisão está
fechada quando o registro é aprovado. Esta é a única parte que a glosa de um ITS parafraseia.]

**Vincula:** [a obrigação concreta que isto impõe a quem planeja e a quem implementa — a linha
que as unidades de um ITS vão citar]

## Alternativas consideradas

| Alternativa | Por que foi descartada |
|---|---|
| [caminho viável] | [o motivo decisivo, não uma preferência] |

## Consequências

**Ganhos:** [o que a decisão compra]
**Custos:** [o que ela cobra, incluindo o que passa a ser mais caro ou impossível]
**Dívida aceita:** [se houver — nomeada, com responsável, per QM-MT-1. Senão, "nenhuma"]
**Revisitar quando:** [a condição que tornaria esta decisão obsoleta, ou "sem gatilho previsto"]
````

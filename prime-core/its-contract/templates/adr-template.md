# Template de ADR

Template canônico de propriedade do prime-core/its-contract. O its-generator redige contra ele quando um plano precisa se comprometer com a decisão, e o arquiteto redige contra ele diretamente quando ainda não existe plano; o arquiteto aprova em ambos os casos, e o code-review bloqueia uma decisão que chegou ao código sem registro. Veja o SKILL.md do its-contract para a fronteira de decisão, que diz quando uma decisão deve um ADR, e para a regra de conteúdo, que governa como uma ITS escreve o que um ADR exige do seu plano.

**Idioma.** O bloco abaixo é o artefato e é escrito no idioma de documento deste formato: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis citados aqui — `ADR-NNN`, os valores de status (`Proposed`, `Accepted`, `Superseded by ADR-NNN`), `UC-NNN`, `ITS-<story-id>`, `QM-XX-N`, `CS-XX-N`, caminhos de arquivo e identificadores — nunca são traduzidos.

## Convenção de nomenclatura de arquivo

`docs/adr/ADR-NNN-titulo-curto.md`, ou conforme sobrescrito pelo `docs/prime-config.md` › Repositório de documentos. `NNN` é sequencial em todo o repositório e nunca é renumerado; uma decisão aposentada mantém seu número e assume o status `Superseded by ADR-NNN`. O slug segue o idioma do documento; o prefixo `ADR-NNN` não.

## Ciclo de vida do status

- **Proposed** — redigido, ainda não aprovado. Uma ITS nunca é entregue enquanto um ADR que ela referencia ainda estiver `Proposed`.
- **Accepted** — aprovado pelo arquiteto. Contexto vinculante para todo implementador e todo plano posterior. A configuração não o sobrescreve; um conflito entre os dois é reportado, não resolvido em silêncio.
- **Superseded by ADR-NNN** — substituído. O registro permanece no lugar com a justificativa intacta, apontando para seu substituto. O status só muda quando o arquiteto aprova o substituto.

Só o arquiteto move um ADR entre status, quem quer que tenha escrito o registro. Redigir é um ato separado; **Quem arquiva** abaixo diz quem o executa.

## Regras de escopo

- **Quem arquiva.** Uma decisão com a qual um plano precisa se comprometer é redigida pelo its-generator e aprovada pelo arquiteto. Uma decisão tomada onde ainda não existe plano, no refinamento ou em aconselhamento arquitetural, é redigida diretamente pelo arquiteto e não precisa de story. O campo `Origem` nomeia de onde veio a decisão e, com isso, qual dos dois caminhos arquivou o registro. Nenhuma outra skill redige um.
- Uma decisão por registro. Um documento com duas decisões não pode ser substituído pela metade.
- **Consequências não são um aviso legal.** Declare o que a decisão custa, além do que ela compra, incluindo o que ela impede. Um registro que lista apenas benefícios é advocacia, não um registro de decisão.
- **A justificativa vive aqui e só aqui.** Uma ITS derivada deste registro o lista em suas Referências e escreve, nas unidades que ele vincula, a restrição operacional que a decisão impõe ao seu plano — nunca o contexto nem as alternativas. Essa propriedade única é o motivo pelo qual quem precisa do porquê vem a este documento.
- As alternativas consideradas são o ponto do registro, não enchimento. Uma decisão sem alternativa viável não foi uma decisão, e provavelmente não precisava de um ADR.

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

[A situação que obrigou a decidir, em linguagem de comportamento e de restrição. As forças em jogo: exigência do negócio, limite da stack, decisão anterior, custo operacional. O que era verdade quando se decidiu — este bloco não é reescrito depois, é o que data a decisão.]

## Decisão

[O que ficou decidido, em uma ou duas frases, na voz de quem instrui. Sem hedge: a decisão está fechada quando o registro é aprovado. Esta seção e o Vincula são as únicas partes que uma ITS reproduz, sempre como instrução.]

**Vincula:** [a obrigação concreta que isto impõe a quem planeja e a quem implementa — a linha que as unidades de uma ITS vão escrever como instrução]

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

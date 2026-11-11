# Template de ADR

Template canônico de propriedade do adr-contract. O adr-generator redige contra ele, e o arquiteto também, quando escreve um registro à mão. Veja o SKILL.md do adr-contract para quando uma decisão merece um ADR, a nomenclatura do arquivo, o ciclo de vida do status e quem redige e quem aprova.

**Idioma.** O bloco abaixo é o artefato e é escrito no idioma de documento deste formato: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis citados aqui — `ADR-NNN`, os valores de status (`Proposed`, `Accepted`, `Rejected`, `Superseded by ADR-NNN`), `UC-NNN`, `ITS-<story-id>`, `QM-XX-N`, `CS-XX-N`, caminhos de arquivo e identificadores — nunca são traduzidos.

**Marcação.** O ADR é sempre escrito em Markdown, seja qual for o formato de saída que o projeto usa para a ITS.

## Regras de escopo

- Uma decisão por registro. Um documento com duas decisões não pode ser substituído pela metade.
- **Consequências não são um aviso legal.** Declare o que a decisão custa, além do que ela compra, incluindo o que ela impede. Um registro que lista apenas benefícios é advocacia, não um registro de decisão.
- **A justificativa vive aqui e só aqui.** Uma ITS que depende deste registro o cita nas premissas do plano e escreve, nas unidades que ele vincula, a restrição operacional que a decisão impõe ao seu plano — nunca o contexto nem as alternativas (its-contract, Fronteira de decisão). Essa propriedade única é o motivo pelo qual quem precisa do porquê vem a este documento.
- As alternativas consideradas são o ponto do registro, não enchimento. Uma decisão sem alternativa viável não foi uma decisão, e provavelmente não precisava de um ADR.
- **O registro se sustenta sozinho.** Ele precisa fazer sentido para quem nunca leu a ITS, a story ou a conversa de onde veio: além do campo Origem, nenhum identificador de ITS entra nele — nem item `D`, nem unidade de plano.

````markdown
# ADR-NNN — [Título da decisão, em substantivo: "Estratégia de idempotência para consumidores"]

| Campo | Valor |
|---|---|
| **ID** | ADR-NNN |
| **Status** | Proposed · Accepted · Rejected — [razão em uma linha] · Superseded by ADR-NNN |
| **Data** | AAAA-MM-DD |
| **Origem** | ITS-<story-id> · demanda em refinamento · aconselhamento arquitetural |
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
**Dívida aceita:** [se houver — nomeada, com responsável e condição de saída, conforme o registro de exceção do quality-model (QM-MT-1). Senão, "nenhuma"]
**Revisitar quando:** [a condição que tornaria esta decisão obsoleta, ou "sem gatilho previsto"]
````

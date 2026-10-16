---
name: use-case
description: O formato canônico do documento de caso de uso, de propriedade do prime-architect - template, regras de qualidade, regras de histórico de revisões (delta) e marcadores de incerteza. Consulte sempre que for criar, atualizar, validar ou consumir um documento de caso de uso. Quem escreve (prime-architect/use-case-creator, prime-architect/use-case-extractor) escreve contra este formato; quem lê (prime-architect/its-generator, prime-architect/code-review) valida contra ele. Nunca duplique seu conteúdo em outro lugar - referencie-o.
---

# Formato de Caso de Uso (prime-architect)

Esta skill é dona do formato do documento de caso de uso. Tem um endereço e um dono; toda outra skill o referencia em vez de copiá-lo. Uma mudança aqui atualiza escrita e leitura ao mesmo tempo.

## O template canônico

`references/use-case-template.md` define: a nomenclatura de arquivo (`use-cases/UC-NNN-titulo-curto.md` sob a raiz de documentos do projeto), a granularidade (o que um documento descreve, o nível, extensão ou documento próprio), a forma das regras de negócio (padrões adaptados do EARS), a estrutura do documento (metadados, envolvidos e interesses — opcional, condições com pré-condições e garantias mínimas/de sucesso, cenário principal de sucesso, extensões, regras de negócio, critérios de aceite rotulados com o que cobrem — inclusive os requisitos não funcionais do fluxo —, resumo gráfico em UML — opcional quando não há relações a mostrar, histórico de revisões), o ciclo de vida de status (Draft · Reviewed · Retired), quando um documento volta a Draft e quando passa a Retired, a reorganização entre documentos (divisão, incorporação), os tipos de entrada do histórico de revisões, as regras de qualidade que todo documento precisa satisfazer, os marcadores de incerteza (`[INFERRED]`, `[CONFIRM: ...]`) para conteúdo não verificado e a lista de perguntas com que eles chegam ao arquiteto.

Leia o template integralmente antes de escrever ou validar qualquer documento de caso de uso.

## Regras inegociáveis (resumo — o template é a autoridade)

- Casos de uso são a fonte de verdade viva do comportamento do sistema. Stories são diffs aplicados a eles.
- Toda entrada do Histórico de revisões tem um tipo — criação, alteração, conformidade, retirada, mapeamento inicial, reconciliação ou revisão editorial. Só as quatro primeiras, identificadas pela story, são trabalho para o its-generator: o delta é a principal entrada dele. Uma entrada por story por documento, reescrita só enquanto for a mais recente; uma story por vez sobre cada documento; máximo de 5 entradas; histórico completo no controle de versão. Atualizações apenas de diagrama ou do campo Casos de uso relacionados (que é recíproco) e a resolução de marcadores nunca geram entrada.
- `UC-NNN`, `RN-N` e `CA-N` nunca são renumerados nem reaproveitados — um item removido ou movido vira lápide, e um documento que deixa de descrever comportamento vivo passa a `Retired`, nunca é apagado. Passos e extensões podem ser renumerados, desde que o delta declare a renumeração. Reorganizar documentos e mudar comportamento nunca acontecem na mesma entrada.
- Documentos com marcadores de incerteza não resolvidos permanecem em status Draft e não são fonte de verdade. Somente documentos Reviewed alimentam o ITS Generator — a única exceção é um documento Retired pela entrada de retirada da própria story. Uma entrada de alteração, de reconciliação ou de revisão editorial, ou um marcador novo, devolve um documento Reviewed a Draft: quem escreve rebaixa, e a promoção é sempre um ato humano.
- O `docs/prime-config.md` do projeto pode sobrescrever o caminho do template ou adicionar seções obrigatórias; a configuração do projeto tem precedência.

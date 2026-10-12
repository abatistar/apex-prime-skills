---
name: use-case
description: O formato canônico do documento de caso de uso, de propriedade do prime-architect - template, regras de qualidade, regras de histórico de revisões (delta) e marcadores de incerteza. Consulte sempre que for criar, atualizar, validar ou consumir um documento de caso de uso. Quem escreve (prime-architect/use-case-creator, prime-architect/use-case-extractor) escreve contra este formato; quem lê (prime-architect/its-generator, prime-architect/code-review) valida contra ele. Nunca duplique seu conteúdo em outro lugar - referencie-o.
---

# Formato de Caso de Uso (prime-architect)

Esta skill é dona do formato do documento de caso de uso. Tem um endereço e um dono; toda outra skill o referencia em vez de copiá-lo. Uma mudança aqui atualiza escrita e leitura ao mesmo tempo.

## O template canônico

`references/use-case-template.md` define: a nomenclatura de arquivo (`docs/use-cases/UC-NNN-titulo-curto.md`), a estrutura do documento (metadados, envolvidos e interesses — opcional, condições com pré-condições e garantias mínimas/de sucesso, cenário principal de sucesso, extensões, regras de negócio, critérios de aceite, resumo gráfico em UML, histórico de revisões), o ciclo de vida de status (Draft · Reviewed) e quando um documento volta a Draft, os tipos de entrada do histórico de revisões, as regras de qualidade que todo documento precisa satisfazer e os marcadores de incerteza (`[INFERRED]`, `[CONFIRM: ...]`) para conteúdo não verificado.

Leia o template integralmente antes de escrever ou validar qualquer documento de caso de uso.

## Regras inegociáveis (resumo — o template é a autoridade)

- Casos de uso são a fonte de verdade viva do comportamento do sistema. Stories são diffs aplicados a eles.
- Toda entrada do Histórico de revisões tem um tipo — criação, alteração, conformidade, mapeamento inicial ou reconciliação. Só as três primeiras, identificadas pela story, são trabalho para o its-generator: o delta é a principal entrada dele. Uma entrada por story por documento; máximo de 5 entradas; histórico completo no controle de versão. Atualizações apenas de diagrama ou do campo Casos de uso relacionados (que é recíproco) e a resolução de marcadores nunca geram entrada.
- `RN-N` e `CA-N` nunca são renumerados nem reaproveitados — um item removido vira lápide. Passos e extensões podem ser renumerados, desde que o delta declare a renumeração.
- Documentos com marcadores de incerteza não resolvidos permanecem em status Draft e não são fonte de verdade. Somente documentos Reviewed alimentam o ITS Generator. Uma entrada de alteração ou de reconciliação, ou um marcador novo, devolve um documento Reviewed a Draft: quem escreve rebaixa, e a promoção é sempre um ato humano.
- O `docs/prime-config.md` do projeto pode sobrescrever o caminho do template ou adicionar seções obrigatórias; a configuração do projeto tem precedência.

---
name: use-case
description: O formato canônico do documento de caso de uso, de propriedade do prime-core - template, regras de qualidade, regras de histórico de revisões (delta) e marcadores de incerteza. Consulte sempre que for criar, atualizar, validar ou consumir um documento de caso de uso. Quem escreve (prime-architect/use-case-creator, prime-architect/use-case-extractor) escreve contra este formato; quem lê (prime-architect/its-generator, prime-architect/code-review) valida contra ele. Nunca duplique seu conteúdo em outro lugar - referencie-o.
---

# Formato de Caso de Uso (prime-core)

Esta skill é dona do formato do documento de caso de uso. Tem um endereço e um dono; toda outra skill o referencia em vez de copiá-lo. Uma mudança aqui atualiza escrita e leitura ao mesmo tempo.

## O template canônico

`references/use-case-template.md` define: a nomenclatura de arquivo (`docs/use-cases/UC-NNN-titulo-curto.md`), a estrutura do documento (metadados, envolvidos e interesses — opcional, condições com pré-condições e garantias mínimas/de sucesso, cenário principal de sucesso, extensões, regras de negócio, critérios de aceite, resumo gráfico em UML, histórico de revisões), o ciclo de vida de status (Draft · Reviewed), as regras de qualidade que todo documento precisa satisfazer e os marcadores de incerteza (`[INFERRED]`, `[CONFIRM: ...]`) usados em conteúdo obtido por engenharia reversa.

Leia o template integralmente antes de escrever ou validar qualquer documento de caso de uso.

## Regras inegociáveis (resumo — o template é a autoridade)

- Casos de uso são a fonte de verdade viva do comportamento do sistema. Stories são diffs aplicados a eles.
- Toda revisão carrega um delta identificado pela story no Histórico de revisões (máximo de 5 entradas; histórico completo no controle de versão). O delta é a principal entrada do its-generator. Atualizações apenas de diagrama nunca são itens de delta.
- Documentos com marcadores de incerteza não resolvidos permanecem em status Draft e não são fonte de verdade. Somente documentos Reviewed alimentam o ITS Generator. A promoção de status é sempre um ato humano.
- O `docs/prime-config.md` do projeto pode sobrescrever o caminho do template ou adicionar seções obrigatórias; a configuração do projeto tem precedência.

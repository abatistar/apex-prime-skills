# ADR — passada operacional

A passada operacional do `adr-generator`. **Nenhum template de documento vive aqui:** a estrutura do ADR, a fronteira de decisão e o ciclo de vida do status são de propriedade do `adr-contract` (`../adr-contract/SKILL.md` e `../adr-contract/templates/adr-template.md`) e nunca são copiados para esta camada. Este arquivo confere o *processo*; o contrato fornece a *forma*.

## Configuração e contrato

- [ ] Do `docs/prime-config.md`, a seção Repositório de documentos lida conforme as regras de consumo do **prime-config**: localização e nomenclatura dos ADRs.
- [ ] `adr-contract` carregado; o template lido integralmente só no passo de redação.

## Entrada

- [ ] A decisão em uma frase, os caminhos em jogo, a origem e a evidência identificados. Invocação pelo its-generator → recebidos nos argumentos, sem depender da conversa da ITS.
- [ ] Invocação direta → perguntado só o que faltava da decisão e dos caminhos. Nenhum requisito coletado.
- [ ] Regra de negócio → não redigida; roteada ao use-case-creator.
- [ ] Decisão que não atende a nenhum critério do contrato → dito uma vez, com a razão; redigida só com o pedido mantido pelo arquiteto. Proposta já aceita vinda do its-generator → não rediscutida.
- [ ] Repositório de ADRs examinado: `Proposed` sobre a mesma decisão → ajustado, nenhum registro novo; `Accepted` contradito → campo Substitui; `Rejected` sobre a mesma decisão → razão mostrada ao arquiteto antes de redigir.
- [ ] Um registro por decisão.

## Registro

- [ ] Próximo número livre; nomenclatura do contrato; status `Proposed`; Origem preenchida (`ITS-<story-id>` · demanda em refinamento · aconselhamento arquitetural).
- [ ] Toda seção do template preenchida; campo sem valor diz isso.
- [ ] Alternativas conferidas contra a configuração, os ADRs `Accepted` e o código do Escopo: ao menos uma viável descartada, com motivo decisivo. Nada lido além do Escopo.
- [ ] Consequências com custos e com o que a decisão impede, não só ganhos. Dívida aceita com responsável e condição de saída, ou "nenhuma".
- [ ] Decisão e Vincula na voz de quem instrui, sem hedge: uma obrigação que um plano escreve como instrução.
- [ ] Caminho da Decisão = escolha do arquiteto, ou a recomendação, declarada como tal na entrega.
- [ ] Além da Origem, nenhum identificador de ITS no registro. O texto se entende sem a story e sem a conversa.

## Entrega e espera

- [ ] Entrega com o caminho do arquivo, a decisão em uma frase e as três respostas possíveis: aprovar · pedir ajustes · recusar.
- [ ] Parada depois da entrega. Aprovação não presumida; status não movido; nenhuma ITS escrita, continuada ou adiantada.
- [ ] Aprovação só por ordem explícita para aquele registro. Silêncio, comentário, pedido de ajuste e ordem genérica de continuar não contam; ordem genérica → perguntado qual é a decisão.
- [ ] Pedido de ajuste → registro revisado no lugar, mesmo número, ainda `Proposed`, reentregue com o que mudou, e nova espera. Nenhuma aprovação embutida num ajuste.
- [ ] Só registro `Proposed` ajustado; mudança em decisão `Accepted` → registro novo que a substitui.

## Decisão do arquiteto

- [ ] Aprovado → Status `Accepted`; registro substituído → `Superseded by ADR-NNN` na mesma ordem.
- [ ] Recusado → Status `Rejected`, com a razão em uma linha; número não reaproveitado.
- [ ] Origem numa ITS → dito ao arquiteto que a geração dela recomeça do início pelo its-generator, e o controle devolvido a ele. Nada da ITS retomado ou escrito aqui.

## Verificação de fronteira antes de encerrar

- [ ] Nenhuma ITS, caso de uso ou arquivo de configuração escrito ou editado; nenhum código de aplicação.
- [ ] Nenhum registro iniciado sem a palavra do arquiteto.
- [ ] Nada decidido em nome do arquiteto.

# ADR — conferência antes de entregar

A conferência do Passo 4 do `adr-generator`, feita sobre o registro pronto, antes de entregá-lo ao arquiteto. A forma do ADR, a fronteira de decisão e o ciclo de vida do status são do `adr-contract`; os passos são do SKILL.md. Esta lista não os repete: confere se o registro os cumpre. Quando um item falha, conserte o registro.

## 1. O registro

- [ ] Uma decisão só, e ela passa pela fronteira do contrato: é sobre como o sistema é construído, não uma regra de negócio.
- [ ] Próximo número livre do repositório, nomenclatura do contrato, Status `Proposed` e Origem preenchida: `ITS-<story-id>`, demanda em refinamento ou aconselhamento arquitetural.
- [ ] Toda seção do template preenchida. Campo sem valor diz isso ("nenhum", "sem gatilho previsto").
- [ ] Ao menos uma alternativa viável descartada, com motivo decisivo e não preferência. Nenhum caminho que a stack ou um ADR `Accepted` já impede entrou como alternativa viável.
- [ ] Consequências com os custos e com o que a decisão passa a impedir, não só os ganhos. Dívida aceita com responsável e condição de saída, ou "nenhuma".
- [ ] Decisão e Vincula na voz de quem instrui, sem hedge: o Vincula é uma obrigação que um plano consegue escrever como instrução.
- [ ] Nenhuma contradição com um ADR `Accepted` sem o campo Substitui.
- [ ] O registro se entende sem a ITS, a story ou a conversa de onde veio. Além da Origem, nenhum identificador de ITS.

## 2. Fronteira

- [ ] Nenhuma ITS, caso de uso ou configuração escrito ou editado. Nenhum código de aplicação.
- [ ] Nenhum registro iniciado sem a palavra do arquiteto, e nenhum status movido sem ordem explícita dele para aquele registro.
- [ ] A entrega diz se o caminho da Decisão é escolha do arquiteto ou recomendação.

# Extração de casos de uso — conferência antes de entregar

A conferência do Passo 5 do `use-case-extractor`, feita sobre os documentos escritos, antes de entregá-los. A forma do documento, as regras de qualidade e os marcadores são do `use-case`; os passos são do SKILL.md. Esta lista não os repete nem guarda template: confere se os documentos e a entrega os cumprem. Quando um item falha, conserte o documento.

## 1. Cada documento escrito

- [ ] As regras de qualidade do formato verificadas uma a uma.
- [ ] Todo conteúdo se apoia em código ou em testes lidos nesta execução, ou carrega um marcador. Nenhuma intenção inventada.
- [ ] `[INFERRED]` só no que foi deduzido em vez de rastreado de ponta a ponta. Nada rastreado marcado só por falta de teste.
- [ ] `[CONFIRM: ...]` em toda decisão humana pendente: número mágico, ramificação ambígua, comportamento suspeito de bug, valor que pode ser requisito ou restrição técnica, teste que contradiz o código.
- [ ] Nenhum comportamento estranho normalizado numa regra limpa: documentado como o código o executa, e sinalizado.
- [ ] Número igual ao maior já usado + 1, tirado da listagem da pasta e nunca do índice, com os `Retired` contados. Status `Draft`. Primeira entrada do histórico `mapeamento inicial a partir do código`, com o escopo no Resumo.
- [ ] Casos de uso relacionados preenchidos nos dois lados, sem entrada no histórico e sem mudança de Status no documento que já existia.

## 2. O repositório

- [ ] O escopo e os candidatos foram acordados com o usuário antes da escrita. No máximo três a cinco documentos nesta execução.
- [ ] Nenhum documento novo para comportamento que já tinha caso de uso. Divergência com um documento existente foi roteada ao `use-case-creator`, e um candidato coberto por um `Retired` foi reportado ao arquiteto.
- [ ] A linha de cada documento escrito está no índice.

## 3. A entrega

- [ ] A Lista de perguntas do formato, por documento, com recomendação e evidência `arquivo:linha` em cada item.
- [ ] A declaração de que os documentos só viram fonte de verdade depois que o arquiteto resolver os marcadores, pelo modo validação do `use-case-creator`, e os promover.
- [ ] Os documentos existentes que receberam só o link recíproco.

## 4. Fronteira

- [ ] Nenhum status promovido.
- [ ] Nenhum código alterado, nenhuma ITS gerada, nenhuma configuração editada.

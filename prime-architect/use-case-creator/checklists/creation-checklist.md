# Caso de uso — conferência antes de entregar

A conferência do Passo 3 do `use-case-creator`, feita sobre os documentos escritos ou alterados, antes de entregá-los. A forma do documento e as regras de qualidade são do `use-case`; os passos e os modos são do SKILL.md e dos arquivos de modo. Esta lista não os repete nem guarda template: confere se os documentos e a entrega os cumprem. Quando um item falha, conserte o documento.

## 1. Cada documento escrito ou alterado

- [ ] As regras de qualidade do formato verificadas uma a uma. Violação corrigida ou, quando depende do arquiteto, marcada com `[CONFIRM: ...]` no ponto exato.
- [ ] Nada inventado para preencher uma seção opcional. Meta não funcional pedida sem número é `[CONFIRM: ...]`, nunca um valor.
- [ ] Identificadores estáveis: nenhum `RN-N` ou `CA-N` renumerado ou reaproveitado; os removidos viraram lápide; toda renumeração de passos está declarada no delta e levou junto os rótulos dos critérios de aceite.
- [ ] Uma entrada por story no Histórico de revisões, num dos tipos do formato. A que é trabalho para o its-generator cita passo, extensão e seção. No máximo cinco entradas.
- [ ] Documento novo: número igual ao maior já usado + 1, tirado da listagem da pasta e nunca do índice, com os `Retired` contados; Status `Draft`; primeira entrada `Criação`, com o ID da story.
- [ ] Documento `Reviewed` cujo corpo mudou voltou a `Draft`.
- [ ] Diagrama e Casos de uso relacionados atualizados nos dois lados, sem entrada no histórico e sem mudança de Status no outro documento.

## 2. O repositório

- [ ] O mapeamento story ↔ casos de uso e o ID da story foram confirmados com o usuário antes da escrita. Nenhum documento foi classificado só pela linha do índice.
- [ ] Nenhum delta aplicado sobre base não validada: alteração, conformidade e retirada partiram de um documento `Reviewed`.
- [ ] A linha do índice de cada documento criado, retirado ou alterado está atualizada.
- [ ] Consistência cruzada: nenhum conflito com outro caso de uso deixado em silêncio.

## 3. A entrega

- [ ] O resumo do modo: o delta (alteração e conformidade), o que sai do sistema (retirada), o que mudou no corpo (reconciliação), o que mudou de redação ou de lugar e o mapa de identificadores (revisão editorial).
- [ ] Os critérios de aceite derivados aparecem separados dos que a entrada trazia.
- [ ] O Status resultante de cada documento, e o que isso significa para o its-generator.
- [ ] Os marcadores pendentes como a Lista de perguntas do formato, com recomendação e evidência em cada item.
- [ ] As stories em espera, as dependências entre stories e os documentos que receberam só o link recíproco.

## 4. Fronteira

- [ ] Nenhum status promovido sem ordem explícita do arquiteto para aquele documento, e nunca com marcador pendente.
- [ ] Nenhum documento apagado: o que deixa de descrever comportamento vivo vira `Retired`.
- [ ] Nenhum lado de uma divergência escolhido em nome do arquiteto.
- [ ] Nenhum código escrito, nenhuma ITS gerada, nenhuma configuração editada.

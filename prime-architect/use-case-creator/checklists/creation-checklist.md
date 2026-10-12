# Caso de uso — passada operacional

A passada operacional do `prime-architect/use-case-creator`. **Nenhum template de documento vive aqui:** a estrutura do caso de uso, as regras de qualidade, os tipos de entrada do Histórico de revisões, a estabilidade dos identificadores e os marcadores são de propriedade do `prime-architect/use-case` (`references/use-case-template.md`) e nunca são copiados para esta camada. Este arquivo confere o *processo*; aquele arquivo fornece a *forma*.

## Configuração e formato

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Da configuração: localização e nomenclatura do repositório de casos de uso, template customizado, seções obrigatórias extras, formato do identificador de story.
- [ ] Formato `use-case` carregado por inteiro, incluindo as regras de qualidade; template customizado, quando declarado, no lugar do padrão.

## Roteamento

- [ ] Cada documento classificado: criação | atualização | conformidade ou reconciliação | validação | retirada | revisão editorial.
- [ ] Mapeamento N-para-N (documentos existentes afetados e novos a nascer, com o modo de cada um) confirmado com o usuário antes de escrever.
- [ ] ID da story confirmado junto com o mapeamento. Sem story → origem seguida de `[CONFIRM: story de origem]`, documento em `Draft`.
- [ ] Alteração, conformidade e retirada só sobre documento `Reviewed`. Documento em `Draft` → a story espera (marcadores pendentes → modo validação; delta de outra story → promoção do arquiteto), e a espera consta do mapeamento.
- [ ] Delta escrito sobre o de outra story → dependência entre as stories dita ao confirmar o mapeamento.
- [ ] Comportamento existente sem caso de uso → `use-case-extractor` recomendado. Nada improvisado.

## Escrita

- [ ] Checklist de elicitação respondido pela entrada, pelo repositório e pelos documentos vizinhos. Estrutura decidida pela Granularidade do formato; perguntas ao usuário restritas ao que ela não decide e muda a estrutura do documento, cada uma com a recomendação junto; o resto virou `[CONFIRM: ...]` no ponto exato.
- [ ] Pré-condição só o que já chega garantido; o que o fluxo verifica e pode falhar virou extensão.
- [ ] Toda `RN-N` criada ou alterada num padrão da Forma das regras de negócio: uma resposta, sem citar passo nem extensão; toda regra `Se … então` citada por ao menos uma extensão. Regra que a story não altera mantida como estava — convertê-la é revisão editorial.
- [ ] Todo critério de aceite rotulado com o que cobre; uma renumeração de passos levou junto os rótulos.
- [ ] Requisito não funcional deste fluxo como critério `não funcional`, com métrica e condição. Meta pedida sem número → `[CONFIRM: ...]`; nenhuma meta inventada; nada sistêmico (ADR) nem de qualidade interna do código.
- [ ] Nada inventado para preencher uma seção opcional; diagrama UML só quando há relações a mostrar.
- [ ] Criação: maior número de UC já usado + 1, documentos `Retired` inclusive; Status `Draft`; primeira entrada `Criação` com o ID da story.
- [ ] Atualização: documento lido por inteiro antes de qualquer edição; efeitos colaterais internos corrigidos ou sinalizados.
- [ ] Identificadores: nenhum `RN-N` ou `CA-N` renumerado ou reaproveitado; removidos viraram lápide; toda renumeração de passos declarada no delta.
- [ ] Uma entrada por story por documento. Reexecução → a entrada existente reescrita, nunca uma segunda — e só enquanto ela é a mais recente do documento; com outra por cima → reportado ao arquiteto.
- [ ] Documento `Reviewed` que recebeu alteração, reconciliação, revisão editorial ou marcador devolvido a `Draft`.
- [ ] Conformidade ou reconciliação: o arquiteto decidiu qual lado está certo. Conformidade sem mudança no corpo nem no Status; reconciliação com a entrada `reconciliação com o código`.
- [ ] Validação: marcadores listados no formato da Lista de perguntas; respostas aplicadas item a item, só as que a lista atual reproduz; só marcadores respondidos resolvidos; nenhuma entrada no histórico; nada promovido.
- [ ] Retirada: corpo inalterado; entrada `Retirada` com o ID da story; Status `Retired`; arquivo mantido no mesmo caminho; documento retirado do campo Casos de uso relacionados dos outros; documento cujo fluxo dependia dele levado ao mapeamento.
- [ ] Revisão editorial: só sobre documento `Reviewed`; nenhuma mudança de comportamento; itens movidos em lápide apontando o destino; mapa de identificadores no Resumo; documento absorvido em `Retired`; nunca junto com o delta de uma story.
- [ ] Diagrama (criado ou removido conforme haja relações a mostrar) e Casos de uso relacionados atualizados nos dois lados, sem entrada no histórico e sem mudança de Status no outro documento.
- [ ] Histórico de revisões com no máximo 5 entradas.

## Validação antes de entregar

- [ ] Regras de qualidade do formato verificadas uma a uma em todo documento escrito ou alterado. Violação corrigida ou, se depende do arquiteto, marcada com `[CONFIRM: ...]`.
- [ ] Toda entrada do Histórico de revisões num dos tipos do formato; as que são trabalho para o its-generator citam passo, extensão e seção.
- [ ] Consistência cruzada: nenhum conflito com outro caso de uso deixado em silêncio. Resolução que altera outro documento → de volta ao mapeamento.

## Entrega

- [ ] Delta resumido na resposta (alteração e conformidade); o que sai do sistema (retirada); o que mudou no corpo (reconciliação); o que mudou de redação ou de lugar e o mapa de identificadores (revisão editorial).
- [ ] Documentos que receberam apenas o link recíproco, ou que deixaram de citar um documento retirado, listados.
- [ ] Status resultante de cada documento informado. O que voltou a `Draft` só alimenta o its-generator depois da promoção; um `Retired` por retirada já o alimenta.
- [ ] Marcadores pendentes entregues como a Lista de perguntas do formato, com recomendação e evidência em cada item.
- [ ] Stories em espera (base em `Draft`) e dependências entre stories reportadas.

## Verificação de fronteira antes de entregar

- [ ] Nenhum status promovido — a promoção é por palavra do arquiteto.
- [ ] Nenhum documento de caso de uso apagado — o que deixa de descrever comportamento vivo vira `Retired`.
- [ ] Nenhum lado de uma divergência escolhido em nome do arquiteto.
- [ ] Nenhum código de aplicação escrito; nenhuma ITS gerada.
- [ ] Nenhum arquivo de configuração editado como efeito colateral.

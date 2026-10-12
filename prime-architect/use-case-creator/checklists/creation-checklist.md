# Caso de uso — passada operacional

A passada operacional do `prime-architect/use-case-creator`. **Nenhum template de documento vive aqui:** a estrutura do caso de uso, as regras de qualidade, os tipos de entrada do Histórico de revisões, a estabilidade dos identificadores e os marcadores são de propriedade do `prime-architect/use-case` (`references/use-case-template.md`) e nunca são copiados para esta camada. Este arquivo confere o *processo*; aquele arquivo fornece a *forma*.

## Configuração e formato

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Da configuração: localização e nomenclatura do repositório de casos de uso, template customizado, seções obrigatórias extras, formato do identificador de story.
- [ ] Formato `use-case` carregado por inteiro, incluindo as regras de qualidade; template customizado, quando declarado, no lugar do padrão.

## Roteamento

- [ ] Cada documento classificado: criação | atualização | conformidade ou reconciliação | validação.
- [ ] Mapeamento N-para-N (documentos existentes afetados e novos a nascer, com o modo de cada um) confirmado com o usuário antes de escrever.
- [ ] ID da story confirmado junto com o mapeamento. Sem story → origem seguida de `[CONFIRM: story de origem]`, documento em `Draft`.
- [ ] Nenhum delta de story aplicado sobre documento com marcadores pendentes — validação e promoção primeiro.
- [ ] Comportamento existente sem caso de uso → `use-case-extractor` recomendado. Nada improvisado.

## Escrita

- [ ] Checklist de elicitação respondido pela entrada, pelo repositório e pelos documentos vizinhos. Perguntas ao usuário restritas ao que muda a estrutura do documento, cada uma com a recomendação junto; o resto virou `[CONFIRM: ...]` no ponto exato.
- [ ] Nada inventado para preencher uma seção opcional.
- [ ] Criação: próximo número de UC livre; Status `Draft`; primeira entrada `Criação` com o ID da story.
- [ ] Atualização: documento lido por inteiro antes de qualquer edição; efeitos colaterais internos corrigidos ou sinalizados.
- [ ] Identificadores: nenhum `RN-N` ou `CA-N` renumerado ou reaproveitado; removidos viraram lápide; toda renumeração de passos declarada no delta.
- [ ] Uma entrada por story por documento. Reexecução → a entrada existente reescrita, nunca uma segunda.
- [ ] Documento `Reviewed` que recebeu alteração, reconciliação ou marcador devolvido a `Draft`.
- [ ] Conformidade ou reconciliação: o arquiteto decidiu qual lado está certo. Conformidade sem mudança no corpo nem no Status; reconciliação com a entrada `reconciliação com o código`.
- [ ] Validação: só marcadores respondidos resolvidos; nenhuma entrada no histórico; nada promovido.
- [ ] Diagrama e Casos de uso relacionados atualizados nos dois lados, sem entrada no histórico e sem mudança de Status no outro documento.
- [ ] Histórico de revisões com no máximo 5 entradas.

## Validação antes de entregar

- [ ] Regras de qualidade do formato verificadas uma a uma em todo documento escrito ou alterado. Violação corrigida ou, se depende do arquiteto, marcada com `[CONFIRM: ...]`.
- [ ] Toda entrada do Histórico de revisões num dos tipos do formato; as que são trabalho para o its-generator citam passo, extensão e seção.
- [ ] Consistência cruzada: nenhum conflito com outro caso de uso deixado em silêncio. Resolução que altera outro documento → de volta ao mapeamento.

## Entrega

- [ ] Delta resumido na resposta (alteração e conformidade); o que mudou no corpo (reconciliação).
- [ ] Documentos que receberam apenas o link recíproco listados.
- [ ] Status resultante de cada documento informado. O que voltou a `Draft` só alimenta o its-generator depois da promoção.
- [ ] Marcadores `[CONFIRM: ...]` pendentes listados por documento.

## Verificação de fronteira antes de entregar

- [ ] Nenhum status promovido — a promoção é por palavra do arquiteto.
- [ ] Nenhum lado de uma divergência escolhido em nome do arquiteto.
- [ ] Nenhum código de aplicação escrito; nenhuma ITS gerada.
- [ ] Nenhum arquivo de configuração editado como efeito colateral.

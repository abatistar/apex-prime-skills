# ITS — passada operacional

A passada operacional do `prime-architect/its-generator`. **Nenhum template de documento vive aqui:** a estrutura da ITS é de propriedade do `prime-core/its-contract` (`templates/its-template.md`) e nunca é copiada para esta camada. Este arquivo confere o *processo*; aquele arquivo fornece a *forma*.

## Configuração e contratos

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Da configuração: stack e versões, mapa de estrutura, *Convenções e restrições* por inteiro (registro de áreas, overrides de slots, migrações declaradas, postura do modelo de qualidade, regras do projeto), localizações de documentos e ADRs, comandos de verificação.
- [ ] Contratos do core carregados: `its-contract` (+ template), `use-case`, `coding-standards` (+ `references/convention-slots.md` e os padrões da stack), `quality-model` (+ `references/quality-criteria.md`).
- [ ] Slot de que o plano depende e sem valor → reportado como lacuna (`coding-standards`, Slots não preenchidos). Nunca improvisado.
- [ ] Divergência entre configuração e código → reportada, não resolvida em silêncio.

## Entradas

- [ ] Story identificada; casos de uso afetados listados, ou encontrados buscando o ID da story no Histórico de revisões.
- [ ] Todo documento afetado tem Status `Reviewed`. Qualquer outro → reportar e parar; rotear ao use-case-creator. A promoção é um ato humano.
- [ ] Todo documento afetado passa pelo formato `use-case`: nenhuma seção obrigatória ausente.
- [ ] Comportamento sem nenhum caso de uso → `use-case-extractor` recomendado para aquela área primeiro.
- [ ] ADRs Accepted que tocam a área afetada listados. Um delta que não pode ser satisfeito sem contradizer um deles → roteado ao passo de ADR, nunca absorvido no plano.

## Delta e cenário

- [ ] Por caso de uso, a entrada do Histórico de revisões para **esta** story localizada.
- [ ] Cenário classificado: criação | alteração.
- [ ] Nenhuma entrada para o ID da story → reportado e roteado ao use-case-creator; a única exceção é uma entrada que o limite de cinco entradas empurrou para fora, recuperada do controle de versão.
- [ ] Entradas de revisão mais antigas tratadas como estado somente leitura — nunca como trabalho pendente.
- [ ] Itens de delta numerados (`D1`, `D2`, ...), qualificados por caso de uso quando mais de um é afetado.
- [ ] Cenário de criação: o documento inteiro desdobrado em itens numerados ao longo do eixo que o plano satisfaz.

## Inspeção

- [ ] A inspeção realizada aqui por inteiro. Nenhum mapa do `impact-mapping` usado como entrada, por mais recente que seja.
- [ ] Nada planejado contra código que não foi aberto.
- [ ] Criação: pontos de entrada, camadas e modelos localizados; funcionalidades semelhantes encontradas para reaproveitar padrões; todo passo do fluxo principal e todo fluxo de exceção mapeado para um componente classificado como existe como está / modificar / criar.
- [ ] Criação: todo componente classificado como **modificar** carrega o teste de não regressão devido pela unidade que o toca.
- [ ] Alteração: apenas os itens de delta mapeados para código.
- [ ] Alteração: pontos de regressão numerados (`RG-1`, `RG-2`) a partir do corpo do documento, não do delta.
- [ ] Todo ponto com mais de um caminho de implementação viável anotado para a linha de alternativa descartada ou para o passo de ADR.

## Risco e fronteira de fora de escopo

- [ ] Todo componente previsto para modificação verificado contra o resto do repositório.
- [ ] **Áreas de risco** listadas: outros casos de uso documentados que compartilham o componente, elevando a atenção de teste que suas unidades devem.
- [ ] **Fronteiras** derivadas e separadas das áreas de risco, cada uma nomeando por que é uma borda: compartilhado mas intocado · superfície de contrato não migrada · legado deixado em paz.
- [ ] Nenhuma fronteira duplica um ponto de regressão. `RG-N` é código tocado que precisa continuar funcionando; uma fronteira é código que não deve ser tocado.
- [ ] Nada sob risco de alteração acidental → a seção diz isso explicitamente ("nenhuma identificada"), nunca omitida.

## Decisões (ADR)

- [ ] Cada ponto de decisão testado contra a fronteira de decisão do contrato: restringe implementações futuras · afeta mais de um caso de uso ou módulo · precisa de justificativa legível fora desta ITS.
- [ ] Candidato redigido conforme o `its-contract` (`templates/adr-template.md`), status `Proposed`, na localização configurada, com as alternativas consideradas e as consequências declarando custos além dos ganhos.
- [ ] Apresentado ao arquiteto. Nenhuma ITS entregue enquanto um ADR que ela referencia ainda estiver Proposed.
- [ ] Rejeitado como escopo de story → recai numa linha de alternativa descartada.
- [ ] Aprovado → referenciado por ID nos Metadados, e sua restrição declarada em toda unidade que ele vincula.
- [ ] Contradição com um ADR Accepted → ou o plano cabe sob ele, ou um registro substituto é roteado para aprovação. Nunca resolvida em silêncio.
- [ ] Nenhum ADR produzido para preencher uma seção. A maioria das stories rende zero.

## Qualidade e convenções

- [ ] Critérios `[NON-NEGOTIABLE]`: nenhum afastamento silencioso em qualquer ponto do plano (`QM-XX-N` citado por ID).
- [ ] Nível de cuidado calibrado à vida útil e à importância do código (`QM-MT-4`). Sub e over-engineering ambos sinalizados.
- [ ] Slots INVARIANT: nenhuma violação planejada (`CS-XX-N` citado por ID).
- [ ] Slots CONVENTIONAL: o valor corresponde ao estado registrado de cada área — padrão atual em `current`, padrão local em `legacy-maintained` e `strangler`, o novo valor dentro do escopo de uma migração declarada.
- [ ] Nenhum comportamento novo planejado para uma área `strangler`.
- [ ] Todo afastamento registrado em um dos veículos da ITS: linha de alternativa descartada · fronteira de fora de escopo · ADR referenciado.

## Escrita

- [ ] Escrita conforme o `its-contract`: nomenclatura, seções obrigatórias, nível de detalhe, "instrui, não implementa".
- [ ] Plano escrito em ordem de execução; a seção de comportamento carrega o delta e os pontos de regressão e nada que o plano repita.
- [ ] Toda referência citada carrega sua exigência na mesma linha.
- [ ] Nenhuma frase narra como o plano foi produzido. Notas de trabalho ficaram fora do documento.
- [ ] Glossário de referência preenchido a partir dos documentos já abertos, apenas metadados; a glosa do ADR para na Decisão.
- [ ] Sumário executivo e Metadados escritos por último.

## Rastreabilidade antes de entregar

- [ ] **Delta → plano:** todo item de delta nomeia sua unidade, ou carrega uma justificativa explícita de "já coberto".
- [ ] **Plano → delta:** toda unidade nomeia seus itens de delta ou uma consequência técnica declarada.
- [ ] **Regressão → plano:** todo `RG-N` reivindicado por exatamente uma unidade, com o teste de não regressão nomeado ali.
- [ ] **Alternativa descartada:** toda escolha real da inspeção está fechada por uma linha com sua razão decisiva, ou por um ADR referenciado.
- [ ] **Fronteira:** nenhuma decisão arquitetural embutida no corpo; nenhum ADR referenciado ainda Proposed.
- [ ] **Fora de escopo:** toda entrada declara por que é uma borda; nenhuma duplica um ponto de regressão.
- [ ] **Qualidade:** todo afastamento de um critério `QM-XX-N` ou de um slot `CS-XX-N` registrado como uma exceção nomeada. Nenhum inegociável silencioso e nenhuma violação INVARIANT silenciosa permanece.
- [ ] **Glossário:** todo identificador citado se resolve; nenhuma entrada carrega conteúdo onde cabem metadados.
- [ ] Os quatro testes pré-entrega do contrato executados sobre o documento pronto: implementador · leitor frio · colagem · autor.

## Ao revisar uma ITS entregue

- [ ] Reentrou no passo em que o problema vive, não no topo.
- [ ] Numeração das unidades preservada. Trabalho novo acrescentado como novas unidades; nada já implementado renumerado.
- [ ] Itens de delta de uma unidade descartada reivindicados de novo na verificação de rastreabilidade.
- [ ] Toda esta passada de rastreabilidade reexecutada por inteiro.
- [ ] Nenhuma seção de histórico de revisões inventada dentro da ITS — o controle de versão é esse registro.

## Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito ou proposto.
- [ ] Nenhum caso de uso remendado, nenhum status de caso de uso promovido.
- [ ] Nenhum arquivo de configuração editado como efeito colateral.
- [ ] Nada decidido em nome do arquiteto: as propostas foram apresentadas, não aplicadas.

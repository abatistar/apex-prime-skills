# ITS — passada operacional

A passada operacional do `prime-architect/its-generator`. **Nenhum template de documento vive aqui:** a estrutura da ITS é de propriedade do `prime-core/its-contract` (`templates/its-template.md`) e nunca é copiada para esta camada. Este arquivo confere o *processo*; aquele arquivo fornece a *forma*.

## Configuração e contratos

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Da configuração: stack e versões, mapa de estrutura, *Convenções e restrições* por inteiro (release fixada do Apex Prime, registro de áreas com estado, nível de criticidade e exclusões, overrides de slots, soluções e exemplos canônicos, migrações declaradas, postura do modelo de qualidade, regras do projeto), localizações de documentos e ADRs, comandos de verificação.
- [ ] Contratos carregados: `its-contract` (+ template), `use-case` (formato, no `prime-architect`), `coding-standards` (+ `references/convention-slots.md` e os padrões da stack na release fixada), `quality-model` (+ `references/quality-criteria.md` e `references/quality-triggers.md`).
- [ ] Slot de que o plano depende e sem valor → reportado como lacuna (`coding-standards`, Slots não preenchidos). Nunca improvisado.
- [ ] Divergência entre configuração e código → reportada, não resolvida em silêncio.

## Entradas

- [ ] Story identificada; casos de uso afetados listados, ou encontrados buscando o ID da story no Histórico de revisões.
- [ ] Todo documento afetado tem Status `Reviewed`. Qualquer outro → reportar e parar; marcadores pendentes → use-case-creator (modo validação); delta ainda não validado → arquiteto, para validar e promover. A promoção é um ato humano. Única exceção: `Retired` pela entrada de retirada desta story.
- [ ] Todo documento afetado passa pelo formato `use-case`: nenhuma seção obrigatória ausente.
- [ ] Comportamento sem nenhum caso de uso → `use-case-extractor` recomendado para aquela área primeiro.
- [ ] ADRs Accepted que tocam a área afetada listados. Um delta que não pode ser satisfeito sem contradizer um deles → roteado ao passo de ADR, nunca absorvido no plano.

## Delta e cenário

- [ ] Por caso de uso, a entrada do Histórico de revisões para **esta** story localizada.
- [ ] Cenário classificado: criação | alteração. Uma entrada de conformidade é alteração com o corpo inalterado: os identificadores que ela cita são o delta. Uma entrada de retirada é alteração com o documento inteiro como delta, cada item removido; a regressão vem dos outros casos de uso que compartilham o código.
- [ ] Nenhuma entrada para o ID da story → reportado e roteado ao use-case-creator; a única exceção é uma entrada que o limite de cinco entradas empurrou para fora, recuperada do controle de versão.
- [ ] Entradas de revisão mais antigas tratadas como estado somente leitura — nunca como trabalho pendente. Idem para entradas sem ID de story (mapeamento inicial, reconciliação com o código, revisão editorial), seja qual for sua posição.
- [ ] Itens de delta numerados (`D1`, `D2`, ...) em sequência contínua no documento inteiro, cada um anotado com o elemento da fonte de que vem (passo, extensão, `RN-N`, `CA-N`).
- [ ] Cenário de criação: o documento inteiro desdobrado em itens numerados ao longo do eixo que o plano satisfaz.

## Inspeção

- [ ] A inspeção realizada aqui por inteiro. Nenhum mapa do `impact-mapping` usado como entrada, por mais recente que seja.
- [ ] Nada planejado contra código que não foi aberto.
- [ ] Criação: pontos de entrada, camadas e modelos localizados; funcionalidades semelhantes encontradas para reaproveitar padrões; todo passo do fluxo principal e todo fluxo de exceção mapeado para um componente classificado como existe como está / modificar / criar.
- [ ] Criação: todo componente classificado como **modificar** levado à varredura do Passo 4, que transforma o comportamento que ele já atende em pontos de regressão.
- [ ] Alteração: apenas os itens de delta mapeados para código.
- [ ] Alteração: pontos de regressão numerados (`RG-1`, `RG-2`) em sequência contínua, a partir do corpo do caso de uso, não do delta, cada um anotado com sua origem.
- [ ] Todo ponto com mais de um caminho de implementação viável anotado para a linha de alternativa descartada ou para o passo de ADR.
- [ ] Anotados para o Passo 4.6: os gatilhos de especificação que a story dispara, o código que só comporta a mudança se for distorcido e o código sem testes que o plano altera.

## Risco e fronteira de fora de escopo

- [ ] Todo componente previsto para modificação verificado contra o resto do repositório.
- [ ] **Pontos de regressão de outros casos de uso**, em qualquer cenário: o comportamento que passa pelo código modificado numerado na mesma sequência `RG-N`, anotado com o caso de uso e o elemento de origem, e o caso de uso listado em Referências.
- [ ] **Riscos** só com o que não tem teste concreto a exigir (área quente, dependências de ambiente ou de dados, questões em aberto). Nenhum comportamento compartilhado deixado ali em vez de virar ponto de regressão.
- [ ] **Fronteiras** derivadas e separadas dos pontos de regressão, cada uma nomeando por que é uma borda: compartilhado mas intocado · superfície de contrato não migrada · legado deixado em paz.
- [ ] Nenhuma fronteira duplica um ponto de regressão. `RG-N` é código tocado que precisa continuar funcionando; uma fronteira é código que não deve ser tocado.
- [ ] Nada sob risco de alteração acidental → a seção diz isso explicitamente ("nenhuma identificada"), nunca omitida.

## Decisões (ADR)

- [ ] Cada ponto de decisão testado contra a fronteira de decisão do contrato: restringe implementações futuras · afeta mais de um caso de uso ou módulo · precisa de justificativa legível fora desta ITS.
- [ ] Candidato redigido conforme o `its-contract` (`templates/adr-template.md`), status `Proposed`, na localização configurada, com as alternativas consideradas e as consequências declarando custos além dos ganhos.
- [ ] Apresentado ao arquiteto. Nenhuma ITS entregue enquanto um ADR que ela referencia ainda estiver Proposed.
- [ ] Rejeitado como escopo de story → recai numa linha de alternativa descartada.
- [ ] Aprovado → listado em Referências, e sua restrição escrita como instrução em toda unidade que ele vincula.
- [ ] Contradição com um ADR Accepted → ou o plano cabe sob ele, ou um registro substituto é roteado para aprovação. Nunca resolvida em silêncio.
- [ ] Nenhum ADR produzido para preencher uma seção. A maioria das stories rende zero.

## Qualidade e convenções

- [ ] Estado e nível de criticidade de toda área que o plano altera lidos do registro e escritos nas premissas; área `efêmera` com a condição de remoção; área não registrada tratada como `current` e `padrão`.
- [ ] Todo gatilho de especificação disparado (`quality-triggers.md`) decidido na unidade que o implementa: valor concreto e teste ou medição que o prova.
- [ ] Valor de cada decisão tirado do slot efetivo da área (override da área, do nível, do projeto ou padrão do time na release fixada); valor próprio da story justificado na unidade; slot sem valor reportado como lacuna, nunca inventado.
- [ ] Decisão de gatilho que vale além da story roteada ao passo de ADR.
- [ ] Refatoração preparatória e testes de caracterização planejados como unidades próprias, antes das unidades de comportamento.
- [ ] Critérios `[NON-NEGOTIABLE]`: nenhum afastamento silencioso em qualquer ponto do plano (`QM-XX-N` citado por ID na análise).
- [ ] Nível de cuidado calibrado ao nível de criticidade declarado (`QM-MT-4`). Sub e over-engineering ambos sinalizados.
- [ ] Slots INVARIANT: nenhuma violação planejada (`CS-XX-N` citado por ID na análise).
- [ ] Slots CONVENTIONAL: o valor corresponde ao estado registrado de cada área — padrão atual em `current`, padrão local em `legacy-maintained` e `strangler`, o novo valor dentro do escopo de uma migração declarada.
- [ ] Nenhum comportamento novo planejado para uma área `strangler`.
- [ ] Valor de convenção escrito no documento só quando uma decisão de gatilho precisa dele ou quando a área segue valor diferente do padrão do time; sempre o valor, nunca o slot.
- [ ] Todo afastamento registrado em um dos veículos da ITS: linha de alternativa descartada na unidade · fronteira de fora de escopo · ADR listado em Referências. No documento, escrito por extenso — o que deixa de fazer, onde, por quê e a condição de saída; o `QM-XX-N` ou `CS-XX-N` só em Referências. Afastamento de segurança com o responsável de segurança do projeto; afastamento sem condição de saída vira ADR.

## Escrita

- [ ] Escrita conforme o `its-contract`: nomenclatura, as quatro seções (Descrição · O que muda · Plano de implementação · Referências), nível de detalhe, "instrui, não implementa".
- [ ] O que muda organizado por área de comportamento, nomeada pelo comportamento; cada item é a exigência inteira e verificável, não um apontamento.
- [ ] Marcação de wiki do Confluence conforme o template, nunca Markdown: títulos `hN.`, código em linha `{{ }}`, blocos `{code}` só em Trechos fixados e Verificação (conforme o contrato), nenhuma lista interrompida por linha em branco ou bloco de código, `[` e `{` literais escapados.
- [ ] Cada item de O que fazer é uma instrução: alvo exato, verbo no imperativo, condição e resultado verificável; um alvo com várias instruções em subitens.
- [ ] Migração de esquema planejada como unidade (arquivo em Arquivos, esquema em Trechos fixados); a seção de migrações só com ordem, compatibilidade e carga de dados.
- [ ] Plano escrito em ordem de execução, abrindo com as premissas técnicas (stack, versões, padrões do time) e as áreas tocadas (estado e nível); O que muda carrega as mudanças e o que continua valendo e nada que o plano repita.
- [ ] Toda exigência escrita no ponto em que é usada: regra como condição e resposta, critério de aceite como resultado verificável, ADR como o que exige do plano, convenção como a escolha concreta. Nenhum identificador de outro documento fora de Referências.
- [ ] Nenhuma frase narra como o plano foi produzido. Notas de trabalho ficaram fora do documento.
- [ ] Referências preenchidas a partir dos documentos já abertos: uma linha por fonte, `R1` = story, Usada em com o elemento interno da fonte; nenhuma glosa nem resumo.
- [ ] Descrição escrita por último.

## Rastreabilidade antes de entregar

- [ ] **Delta → plano:** todo item `D` atendido por pelo menos uma unidade, ou declarando na própria linha que já é atendido hoje e por quê.
- [ ] **Plano → delta:** toda unidade nomeia seus itens ou uma consequência técnica declarada.
- [ ] **Regressão → plano:** todo `RG-N` reivindicado por exatamente uma unidade, com o teste de não regressão nomeado ali.
- [ ] **Fonte → item:** todo item e todo ponto de regressão aparece em Referências, na linha da fonte de que veio.
- [ ] **Alternativa descartada:** toda escolha real da inspeção está fechada por uma linha na unidade, com sua razão decisiva, ou por um ADR listado em Referências.
- [ ] **Fronteira:** nenhuma decisão arquitetural tomada no corpo; nenhum ADR listado ainda Proposed.
- [ ] **Fora de escopo:** toda entrada declara por que é uma borda; nenhuma duplica um ponto de regressão.
- [ ] **Qualidade:** áreas tocadas declaradas com estado e nível; todo gatilho disparado decidido numa unidade; todo afastamento de um critério `QM-XX-N` ou de um slot `CS-XX-N` registrado como uma exceção nomeada, com condição de saída. Nenhum inegociável silencioso e nenhuma violação INVARIANT silenciosa permanece.
- [ ] **Autossuficiência:** nenhum identificador de outro documento fora de Referências; nenhuma instrução depende de abrir a fonte; toda linha de Referências diz onde foi usada e nenhuma carrega conteúdo que o corpo deveria carregar.
- [ ] Nenhuma tabela de rastreabilidade escrita no documento: a verificação roda sobre o que ele já declara.
- [ ] Os quatro testes pré-entrega do contrato executados sobre o documento pronto: implementador · leitor frio · colagem · autor.

## Ao revisar uma ITS entregue

- [ ] Reentrou no passo em que o problema vive, não no topo.
- [ ] Numeração das unidades preservada. Trabalho novo acrescentado como novas unidades; nada já implementado renumerado. Unidade nova que precisa rodar antes de uma existente declara Executar antes de.
- [ ] Unidade que deixou de se aplicar mantida com o número, declarada sem efeito na forma do template e apontando a substituta; seus itens no Atende da substituta; se já implementada, a substituta diz o que fazer com o código dela.
- [ ] Delta, regressão ou fontes mudaram → `D`, `RG` e `R` renumerados no documento inteiro, Atende/Testes/Usada em atualizados em todas as unidades, e a correspondência antiga → nova entregue ao implementador.
- [ ] Toda esta passada de rastreabilidade reexecutada por inteiro.
- [ ] Nenhuma seção de histórico de revisões inventada dentro da ITS — o controle de versão é esse registro.

## Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito ou proposto.
- [ ] Nenhum caso de uso remendado, nenhum status de caso de uso promovido.
- [ ] Nenhum arquivo de configuração editado como efeito colateral.
- [ ] Nada decidido em nome do arquiteto: as propostas foram apresentadas, não aplicadas.

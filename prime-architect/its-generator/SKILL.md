---
name: its-generator
description: Gera uma ITS (Instrução de Trabalho de Software) - o plano de implementação que mapeia uma user story e seus documentos de caso de uso para mudanças concretas de código, escrito contra o prime-core/its-contract. Skill da camada do arquiteto. Use sempre que o arquiteto pedir um plano de implementação, uma análise de impacto, "o que precisa mudar no código", "gere a ITS da story S-NNN", ou fornecer uma story mais documentos de caso de uso. Use também para revisar uma ITS que a implementação ou o code review devolveu. Exige o repositório de casos de uso como entrada. NÃO use para escrever ou atualizar documentos de caso de uso (use-case-creator, use-case-extractor), para revisar uma implementação (code-review), para mapear o que uma mudança alcança sem planejá-la (impact-mapping) nem para julgar se uma demanda pode ser absorvida (feasibility-analysis).
---

# ITS Generator (prime-architect)

Gera uma ITS por story: a instrução de trabalho a partir da qual o Desenvolvedor implementará. O formato da ITS NÃO é definido aqui — é de propriedade do **prime-core/its-contract** (leia seu SKILL.md e o `templates/its-template.md` antes de escrever). Esta skill define o *processo* de produzir uma ITS que honre esse contrato.

Disciplina central: **leia antes de propor**. Nunca planeje mudanças em código que você não inspecionou. E processe **exatamente um delta**: o que pertence à story em questão.

## Passo 0 — Carregar a configuração do projeto e os contratos

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, tratamento de divergências e o procedimento de bootstrap quando o arquivo está ausente vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa: a stack e as versões (respeite-as — não proponha recursos do Java 17 num projeto Java 11), a estrutura de pastas como mapa para a inspeção de código, a seção *Convenções e restrições* por inteiro — o registro de áreas, os overrides de slots, as migrações declaradas, a postura do modelo de qualidade e as regras do projeto —, as localizações dos documentos (incluindo o repositório de ADRs) e os comandos de verificação.

Em seguida carregue os contratos contra os quais esta skill escreve: o **prime-core/its-contract** (formato de saída e a fronteira de decisão ITS-vs-ADR), o **prime-architect/use-case** (formato de entrada), o **prime-core/coding-standards** com `references/convention-slots.md` e o arquivo de padrões da stack do projeto (as convenções concretas a que o plano se conforma) e o **prime-core/quality-model** com `references/quality-criteria.md` — consumido não como um livro de regras a satisfazer mecanicamente, mas como a *definição* contra a qual o plano é interrogado antes da entrega (Passo 4.6), honrando sua calibração e sua disciplina de exceção nomeada. Ele não aprova nem reprova o plano por si só.

Um slot de que o plano depende e que não tem valor — nem padrão da stack nem override da configuração — é uma **lacuna reportável** conforme o prime-core/coding-standards, nunca um valor que esta skill improvisa. Reporte-a e ofereça preenchê-la; não planeje uma mudança que se apoie nela.

## Passo 1 — Reunir as entradas e validar

Entradas obrigatórias: a story (ID + descrição) e os documentos de caso de uso que ela criou ou revisou. Se o arquiteto não listou os casos de uso afetados, encontre-os procurando no repositório de casos de uso as entradas do Histórico de revisões com o ID da story.

Valide cada documento contra o formato do prime-architect/use-case. Duas condições interrompem a execução, e ambas são reportadas em vez de contornadas — um plano construído sobre comportamento não validado é pior que nenhum plano.

- **O status não é `Reviewed`.** Conforme o prime-architect/use-case, somente um documento Reviewed é fonte de verdade e somente um documento Reviewed alimenta esta skill. Isso vale seja o que for que mantém o documento em `Draft` — um marcador `[CONFIRM: ...]` não resolvido em uma seção sem relação deixa o documento inteiro fora da fonte de verdade, porque o status é uma propriedade do documento e não da fatia dele que cabe à story. Nomeie o que o mantém em `Draft` e devolva conforme a causa: marcadores pendentes vão ao use-case-creator (modo validação); um delta ainda não validado vai ao arquiteto, para validar e promover. A promoção é um ato humano e nenhuma skill a realiza. A única exceção é um documento `Retired` cuja entrada de retirada carrega o ID desta story: o corpo dele foi validado antes da retirada e é exatamente o que sai do sistema. Um `Retired` sem essa entrada não alimenta esta skill.
- **Falta uma seção obrigatória.** Reporte a lacuna contra o formato e pare.

Se a story modifica comportamento cujo caso de uso não existe de forma alguma, recomende executar o use-case-extractor naquela área primeiro.

Examine também o repositório de ADRs em busca de ADRs Accepted que toquem a área afetada — eles restringem o plano do mesmo modo que as convenções da configuração. Um delta que não pode ser satisfeito sem contradizer um deles é uma decisão, não um detalhe de planejamento: roteia-se para o Passo 4.5 e nunca é absorvido no plano.

## Passo 2 — Localizar o delta e classificar o cenário

Para cada caso de uso afetado, encontre a entrada do Histórico de revisões que corresponde ao ID da story atual.

- A entrada é de **criação** (Resumo `Criação`) → **cenário de criação** para este caso de uso.
- A entrada lista itens adicionados/alterados/removidos → **cenário de alteração**; essa entrada é o delta.
- A entrada é de **conformidade** → **cenário de alteração** em que o corpo do documento não mudou: os identificadores que ela cita são o delta, e o comportamento que eles descrevem é o alvo que o código passa a cumprir.
- A entrada é de **retirada** (Resumo `Retirada`, Status `Retired`) → **cenário de alteração** em que todo o comportamento do documento sai do sistema: o documento inteiro é o delta, desdobrado como no cenário de criação, com cada item removido. Na análise de regressão, o que precisa continuar funcionando vem dos outros casos de uso que compartilham o código, não do corpo deste.
- **Nenhuma entrada carrega o ID da story** → o documento não foi atualizado para esta story. Não infira o delta a partir do texto da story: reporte e roteie o documento ao use-case-creator antes de planejar. A única exceção é uma entrada que o limite de cinco entradas do template empurrou para fora do histórico retido — recupere-a do controle de versão, onde vive o histórico completo, e prossiga; quando não for possível recuperá-la, reporte e pare.

**As entradas de revisão mais antigas são somente leitura.** Descrevem comportamento já implementado — são estado, não trabalho pendente. Nunca as trate como algo a implementar. Seu único uso legítimo é a verificação de área quente do Passo 4. O mesmo vale, seja qual for sua posição, para as entradas sem ID de story (mapeamento inicial, reconciliação com o código, revisão editorial): descrevem o que o código já faz, ou só mudam onde e como isso está escrito.

Numere os itens de delta conforme os localiza (`D1`, `D2`, ...), qualificados pelo caso de uso quando mais de um é afetado (`UC-042/D1`). No cenário de alteração, a entrada de revisão já os lista. No cenário de criação, o documento inteiro é o delta: desdobre-o em itens ao longo do eixo que o plano vai satisfazer — cada passo do fluxo principal, cada extensão e cada regra de negócio ou critério de aceite que não decorra de um desses (o rótulo de cada critério diz o que ele cobre) — para que toda unidade ainda nomeie o que satisfaz. Um critério `não funcional` é sempre item próprio, porque a meta não decorre do passo que ela mede; a unidade que o satisfaz nomeia como a meta é verificada (teste automatizado, teste de carga ou medição). A numeração é o que torna verificável o plano de eixo único: as unidades do plano citam esses identificadores e a verificação de rastreabilidade são duas listas deles.

## Passo 3 — Inspecionar a base de código (por caso de uso)

**A inspeção sempre acontece aqui.** Um mapa do `impact-mapping` não é uma entrada deste passo, mesmo quando existe um para a demanda de que esta story veio. Um mapa tem escopo de uma demanda em refinamento e uma ITS de exatamente uma story; o refinamento pode durar meses entre os dois, e, quando o plano existe, verificar o mapa custa o mesmo que derivar o alcance do zero. O `impact-mapping` declara a mesma fronteira do seu lado. O arquiteto pode, claro, ter lido o mapa; o que não acontece é um plano herdar um alcance que nunca verificou.

**Cenário de criação** — exploração ampla e dirigida:
- Localize pontos de entrada, camadas e modelos relacionados ao ator/ação, guiado pelo mapa de estrutura da configuração.
- Encontre funcionalidades existentes semelhantes para reaproveitar padrões (tratamento de erros, estilo de validação, organização de testes).
- Mapeie cada passo do fluxo principal e cada fluxo de exceção para um componente, classificando cada um como: existe como está / modificar / criar.
- Todo componente classificado como **modificar** já atende a comportamento que esta story não muda. Ele entra na varredura de risco do Passo 4, e a unidade que o modifica deve o teste de não regressão desse comportamento, nomeado na unidade como qualquer outro teste. Os pontos de regressão numerados (`RG-N`) pertencem ao cenário de alteração: aqui a cobertura é devida pela unidade, não rastreada como um identificador do lado do delta.

**Cenário de alteração** — análise estreita, guiada pelo delta:
1. Use o documento (seu corpo atual descreve o comportamento consolidado) para localizar os componentes que implementam este caso de uso hoje.
2. Mapeie **apenas os itens de delta**: para cada item adicionado/alterado/removido, identifique o código correspondente e o que precisa mudar.
3. **Análise de regressão** — exclusiva deste cenário: identifique o comportamento que *não* mudou mas compartilha código com o que vai mudar. O corpo completo do documento (não o delta) diz tudo o que precisa continuar funcionando. Numere esses pontos (`RG-1`, `RG-2`) — cada um será reivindicado pela unidade do plano que toca o código compartilhado, e a reivindicação é verificada no Passo 6.

Durante toda a inspeção, anote cada ponto em que existe mais de um caminho de implementação viável. Essas notas alimentam o Passo 5 (linhas de alternativa descartada) e o Passo 4.5 (candidatos a ADR).

## Passo 4 — Verificação de risco em todo o repositório e a fronteira de fora de escopo

Para cada componente previsto para modificação, verifique se ele também atende a outros casos de uso documentados (busque no repositório). Essa única varredura rende duas saídas diferentes, e fundi-las é o erro a evitar.

**Áreas de risco.** Os casos de uso que compartilham o componente e permanecem no caminho do plano. Liste-os; eles elevam a atenção de teste que as unidades afetadas devem. Opcionalmente, se um delta toca um passo que também aparece nas últimas 1–2 entradas de revisão do mesmo documento, sinalize-o como **área quente** (mudado com frequência → merece atenção extra de teste). É uma consulta direcionada, não uma releitura do histórico.

**Fronteiras de fora de escopo.** O contrato exige que o plano de implementação nomeie o que não deve ser tocado, e é aqui que essas bordas são derivadas. Três fontes, cada entrada nomeando *por que é uma borda*:

- **Compartilhado mas intocado.** Código que a inspeção alcançou, que atende a outro caso de uso e que o delta não exige alterar — o lugar mais provável onde uma melhoria não solicitada vai cair. Distinto de um ponto de regressão: `RG-N` é código que o plano **toca** e que precisa continuar funcionando; uma fronteira é código que o plano **não deve** tocar de forma alguma.
- **Superfícies de contrato que esta story não muda.** Formatos de API, esquema, payloads de eventos alcançados pela inspeção cujos consumidores a story não tem mandato para migrar. Nomeá-los é o que evita que uma mudança de assinatura conveniente chegue sem aviso.
- **Legado deliberadamente deixado em paz.** Código herdado numa área `legacy-maintained` ou `strangler` com que o plano convive sem corrigir — o veículo para o qual o Passo 4.6 roteia tais desvios.

Uma lista de fronteiras vazia é legítima e é escrita como tal ("nenhuma identificada"), nunca omitida: uma story genuinamente confinada a código que ninguém mais usa não tem bordas a nomear. O que não é legítimo é uma borda sem razão — o implementador precisa conseguir distinguir uma fronteira de um esquecimento, e o revisor confere a seção item a item.

## Passo 4.5 — Detectar e propor ADRs

Revise os pontos de decisão anotados no Passo 3 contra a fronteira de decisão do contrato: alguma escolha restringe implementações futuras, afeta mais de um caso de uso ou módulo, ou precisa de uma justificativa legível fora desta ITS? Se sim:

1. Redija o ADR conforme o `templates/adr-template.md` do contrato, status `Proposed`, na localização de ADRs configurada. As alternativas consideradas são o ponto do registro, não enchimento.
2. **Apresente-o ao arquiteto para aprovação antes de entregar a ITS.** O arquiteto decide; você propõe. Uma ITS não é entregue enquanto um ADR que ela referencia ainda estiver Proposed. Se rejeitado como "escopo de story", a decisão recai numa linha de alternativa descartada na ITS.
3. Referencie o ID do ADR aprovado nos metadados da ITS e, em cada unidade do plano que a decisão restringe, declare ali a restrição que ela impõe — conforme a regra de referência do contrato. O implementador não deve precisar abrir o ADR para saber o que fazer; ele o lê para saber por quê, e porque ADRs Accepted são contexto vinculante.

**Um delta que contradiz um ADR Accepted passa por este passo, sempre.** Nunca planeje contornando a contradição em silêncio, e nunca deixe as convenções da configuração resolvê-la — a regra de precedência do prime-core/prime-config é que um conflito com um ADR Accepted é reportado, não resolvido. Dois desfechos são legítimos: o plano cabe sob o ADR e a restrição é declarada nas unidades que ela vincula; ou a story genuinamente substitui a decisão, e o registro substituto é redigido e roteado exatamente como qualquer outro candidato. O ADR substituído assume `Superseded by ADR-NNN` somente quando o arquiteto aprova o substituto.

Não produza em excesso: a maioria das stories rende zero ADRs. Um ADR existe porque uma decisão real entre stories foi tomada, não porque a seção quer ser preenchida.

## Passo 4.6 — Interrogar o plano contra o modelo de qualidade e as convenções

Antes de escrever, passe o plano pretendido pelo **prime-core/quality-model**, consumindo-o como uma definição contra a qual questionar o entregável — não como um gate (aprovar é trabalho do revisor, depois). Cite critérios por ID. Três perguntas, da regra de consumo do its-generator no modelo:

- Alguma mudança proposta comete um pecado capital (um `[NON-NEGOTIABLE]`) **em silêncio**? Um inegociável pode ser desrespeitado, mas somente como uma exceção nomeada e com responsável — nunca por omissão.
- O nível de cuidado proposto está **calibrado** à vida útil esperada e à importância do código (QM-MT-4)? Sinalize tanto o sub quanto o over-engineering — o excesso é tão danoso quanto a deficiência.
- Onde o plano se afasta de um critério por legado ou dívida deliberada, esse afastamento está registrado em um dos veículos da própria ITS?

O modelo remete ao **prime-core/coding-standards** sempre que um critério precisa de uma convenção concreta para ser verificável, então a mesma passada faz mais duas perguntas ali, citando slots por ID (`CS-XX-N`):

- Alguma mudança planejada viola um slot **INVARIANT**? Eles valem para toda linha escrita ou alterada, independentemente do que a cerca, e uma violação silenciosa é o mesmo defeito que um inegociável silencioso — o revisor bloqueia em ambos.
- Para cada área que o plano toca, o plano segue o valor **convencional** que o estado registrado da área pede — o padrão atual numa área `current`, o padrão local em `legacy-maintained` e `strangler`, o novo valor dentro do escopo de uma migração declarada? Uma área `strangler` não recebe comportamento novo: capacidade nova planejada ali pertence ao módulo substituto que o registro nomeia.

Registre cada afastamento nomeado onde ele pertence, nunca como prosa solta:
- uma **linha de alternativa descartada** na Verificação de rastreabilidade, quando é uma escolha entre caminhos viáveis que morre com a story;
- uma **fronteira de fora de escopo / não alterar**, quando é legado herdado que você deliberadamente deixa intocado;
- um **ADR**, quando o afastamento sobrevive à story — roteie-o de volta pelo Passo 4.5 para a aprovação do arquiteto.

Este passo faz aflorar melhorias; nunca bloqueia a entrega por si só. Uma violação *silenciosa* de inegociável ou de slot INVARIANT, porém, é um defeito — nomeie-a ou corrija-a antes de escrever.

## Passo 5 — Escrever a ITS conforme o contrato

Escreva o documento exatamente conforme o **prime-core/its-contract**: nomenclatura de arquivo, seções obrigatórias, nível de detalhe, a regra "instrui, não implementa" e a regra da alternativa descartada vêm todas de lá. Escreva o plano em ordem de execução e deixe-o carregar o mapeamento único — a seção de comportamento declara o delta e os pontos de regressão e para aí. Sequenciar agora é um ato de escrita, não uma lista separada: a ordem que você escolhe é a ordem em que o implementador trabalha e a ordem em que o revisor percorre o diff. Duas das regras de escrita do contrato são onde uma ITS entregue mais falha com seu leitor, e ambas valem uma releitura antes da primeira linha: *referências se resolvem em conteúdo, não só em endereço*, e *a voz do autor*. O que esta skill acrescenta à segunda é apenas o seu alcance aqui — as notas tomadas ao longo dos Passos 3 a 4.6 são material de trabalho, e nenhuma delas pertence ao documento.

O **Glossário de referência** é escrito a partir dos documentos já abertos: os casos de uso carregados no Passo 1, as regras de negócio e os critérios de aceite que o plano cita, os ADRs aprovados no Passo 4.5 e os critérios e slots que o Passo 4.6 deixou registrados como afastamentos nomeados. Preencha cada entrada à medida que escreve a instrução que a cita, enquanto a fonte ainda está à sua frente — é isso que mantém a seção um snapshot tirado na entrega em vez de uma reconstrução de memória, e é por isso que ela não custa nada para produzir. Ela resolve *o que cada identificador é* e para aí: apenas metadados, e, para um ADR, a glosa para na Decisão.

## Passo 6 — Verificar a rastreabilidade antes de entregar

Execute as verificações do contrato e registre-as na seção de Metadados da ITS:
- Delta → plano: todo item de delta (`UC-NNN/D1`) nomeia a unidade que o satisfaz, ou uma justificativa explícita de "já coberto".
- Plano → delta: toda unidade nomeia seus itens de delta ou uma consequência técnica declarada.
- Regressão → plano: todo `RG-N` é reivindicado por exatamente uma unidade, com o teste de não regressão nomeado ali.
- Alternativa descartada: todo ponto em que o Passo 3 encontrou mais de um caminho viável está fechado — uma linha de alternativa descartada carregando a razão decisiva, ou um ADR referenciado. Uma unidade que não enfrentou escolha real não declara nada; o que esta verificação pega é uma escolha real deixada sem registro.
- Verificação de fronteira: nenhuma decisão arquitetural (conforme os critérios do contrato) embutida no corpo do documento — cada uma vive em um ADR referenciado, e nenhum ADR referenciado ainda está Proposed.
- Verificação de fora de escopo: toda entrada em "Fora de escopo — não alterar" declara por que é uma borda (compartilhado mas intocado · superfície de contrato não migrada · legado deixado em paz), e nenhuma entrada duplica um ponto de regressão — `RG-N` é código tocado que precisa continuar funcionando, uma fronteira é código que não deve ser tocado.
- Verificação de qualidade: todo afastamento de um critério do prime-core/quality-model ou de um slot do prime-core/coding-standards trazido pelo Passo 4.6 está registrado como uma exceção nomeada (linha de alternativa descartada, fronteira de fora de escopo ou ADR referenciado). Nenhuma violação silenciosa de inegociável e nenhuma violação silenciosa de slot INVARIANT permanece.
- Verificação do glossário: todo identificador que o documento cita se resolve no Glossário de referência, e nenhuma entrada carrega o conteúdo da fonte onde caberiam metadados.

Em seguida execute os quatro testes pré-entrega do contrato sobre o documento pronto — implementador, leitor frio, colagem, autor. Se qualquer verificação ou qualquer teste falhar, conserte o plano — não entregue uma ITS com escopo sem explicação ou decisões enterradas.

## Revisando uma ITS entregue

Uma ITS volta quando o plano não sobreviveu ao contato com o código: o implementador devolveu uma pergunta que o documento não consegue responder, ou o quarto veredito do code review devolveu a story ao arquiteto. A revisão é este mesmo processo sobre uma entrada mais estreita, sob três restrições.

- **Reentre no passo em que o problema vive.** Um delta errado ou ausente significa que o caso de uso mudou primeiro — roteie ao use-case-creator e depois retome a partir do Passo 1. Um delta mapeado para o código errado reexecuta os Passos 3 e 4. Uma decisão que o plano tomou sem registrar reexecuta o Passo 4.5.
- **A numeração das unidades é estável.** O implementador já trabalhou nela e o revisor percorre o diff nela. Trabalho novo chega como novas unidades ao final; nunca renumere uma unidade que alguém implementou. Onde uma unidade já não se aplica, seus itens de delta voltam à verificação de rastreabilidade reivindicados pela unidade que a substitui, sob a justificativa de "já coberto" que o contrato permite.
- **Reexecute o Passo 6 por inteiro.** Uma ITS revisada passa pelas mesmas verificações que uma nova. Um item de delta silenciosamente órfão pela revisão é a falha que esta execução existe para prevenir.

Uma ITS por story continua valendo: a revisão substitui o documento no lugar. O contrato não define histórico de revisão dentro da ITS — o controle de versão é esse registro, e nenhuma seção é inventada para guardá-lo.

## Saída

Um documento de ITS (nomeado conforme o contrato) na localização configurada, mais zero ou mais ADRs aprovados pelo arquiteto, rastreável de ponta a ponta: story → deltas dos casos de uso → decisões (ADRs) → mudanças de código → testes. Uma decisão candidata que o arquiteto rejeitou como escopo de story não deixa ADR: vive como uma linha de alternativa descartada na verificação de rastreabilidade.

A passada operacional vive em `checklists/its-checklist.md`. O template do próprio documento não: ele é de propriedade do `prime-core/its-contract` e é lido de lá.

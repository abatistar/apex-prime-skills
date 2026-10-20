---
name: its-generator
description: Gera a ITS (Instrução de Trabalho de Software) de uma story - o plano de implementação que leva a story e seus casos de uso a mudanças concretas de código. Use para "gere a ITS da S-NNN" e "o que precisa mudar no código", para uma story técnica (migração, dependência, refatoração) e para revisar uma ITS devolvida pela implementação ou pelo code review. NÃO use para escrever casos de uso (use-case-creator, use-case-extractor), para revisar uma implementação (code-review) nem para julgar se uma demanda cabe no sistema (feasibility-analysis).
---

# ITS Generator (prime-architect)

Gera uma ITS por story: a instrução de trabalho a partir da qual o Desenvolvedor implementará. O formato da ITS NÃO é definido aqui — é de propriedade do **prime-core/its-contract** (o SKILL.md entra no Passo 0; o template e as Regras de escrita, no Passo 5). Esta skill define o *processo* de produzir uma ITS que honre esse contrato.

Disciplina central: **leia antes de propor**. Nunca planeje mudanças em código que você não inspecionou. E processe **exatamente o delta** que pertence à story em questão.

## Passo 0 — Carregar a configuração do projeto e os contratos

Leia o `docs/prime-config.md` conforme as regras de consumo do **prime-core/prime-config** (`../prime-config/references/consumer-rules.md`). Da configuração esta skill usa: a stack e as versões (respeite-as — não proponha recursos do Java 17 num projeto Java 11), a estrutura de pastas como mapa para a inspeção de código, a seção *Convenções e restrições* por inteiro — a release fixada do Apex Prime, o registro de áreas (estado e nível de criticidade de cada área, e as exclusões), os overrides de slots, as soluções e exemplos canônicos, as migrações declaradas, a postura do modelo de qualidade e as regras do projeto —, as localizações dos documentos (incluindo o repositório de ADRs), os overrides de caso de uso (template customizado e seções obrigatórias extras) e os comandos de verificação.

Em seguida carregue os contratos contra os quais esta skill escreve: o **prime-core/its-contract** (formato de saída e a fronteira de decisão ITS-vs-ADR), as regras de consumo do **prime-architect/use-case** (`../use-case/references/consumer-rules.md` — o formato de entrada), as regras de consumo do **prime-core/coding-standards** (`../coding-standards/references/consumer-rules.md`) com o índice `../coding-standards/references/convention-slots.md` e o índice dos padrões da stack na release que o projeto fixou (`../coding-standards/references/defaults-<stack>.md`) (as convenções concretas a que o plano se conforma e de onde vêm os valores das decisões de qualidade) e as regras de consumo do **prime-core/quality-model** (`../quality-model/references/consumer-rules.md`) com o índice `../quality-model/references/quality-criteria.md` e `../quality-model/references/quality-triggers.md` — a definição de qualidade em que o plano se apoia: os gatilhos dizem que decisões de qualidade a story exige do plano, e o catálogo diz o piso e a calibração (Passo 4.6). Ele não aprova nem reprova o plano por si só. Dos catálogos, o arquivo de uma lente ou família entra quando um ID dela é citado ou aplicado, como cada índice diz — nunca o catálogo inteiro de antemão.

Um slot de que o plano depende e que não tem valor — nem padrão da stack nem override da configuração — é uma **lacuna reportável** conforme o prime-core/coding-standards, nunca um valor que esta skill improvisa. Reporte-a e ofereça preenchê-la; não planeje uma mudança que se apoie nela.

## Passo 1 — Reunir as entradas e validar

Entradas obrigatórias: a story (ID + descrição) e os documentos de caso de uso que ela criou ou revisou. Se o arquiteto não listou os casos de uso afetados, encontre-os procurando no repositório de casos de uso as entradas do Histórico de revisões com o ID da story.

**Story técnica.** Uma story que muda o código sem mudar o comportamento observável de nenhum ator — o avanço de uma migração declarada, a atualização de uma dependência ou da stack, uma refatoração, a remoção de uma flag cujo comportamento já é o definitivo — não deixa entrada em caso de uso nenhum (prime-architect/use-case, Regras do Histórico de revisões) e entra só com a story. Confirme com o arquiteto que nada observável muda antes de planejar: essa confirmação é o que dispensa o delta. Se ele discordar, algo observável muda, e o caso de uso muda primeiro, pelo use-case-creator. Confirmada, a story segue o cenário técnico (Passo 2), e as duas condições abaixo não se aplicam a ela — os casos de uso só entram pela regressão, no Passo 4.

Valide o status e as seções de cada documento contra as regras de consumo do prime-architect/use-case. Duas condições interrompem a execução, e ambas são reportadas em vez de contornadas — um plano construído sobre comportamento não validado é pior que nenhum plano.

- **O status não é `Reviewed`.** Conforme o prime-architect/use-case, somente um documento Reviewed é fonte de verdade e somente um documento Reviewed alimenta esta skill. Isso vale seja o que for que mantém o documento em `Draft` — um marcador `[CONFIRM: ...]` não resolvido em uma seção sem relação deixa o documento inteiro fora da fonte de verdade, porque o status é uma propriedade do documento e não da fatia dele que cabe à story. Nomeie o que o mantém em `Draft` e devolva conforme a causa: marcadores pendentes vão ao use-case-creator (modo validação); um delta ainda não validado vai ao arquiteto, para validar e promover. A promoção é um ato humano: nenhuma skill a decide, e a edição do Status só acontece por ordem explícita do arquiteto para aquele documento (prime-architect/use-case, Ciclo de vida do status). A única exceção é um documento `Retired` cuja entrada de retirada carrega o ID desta story: o corpo dele foi validado antes da retirada e é exatamente o que sai do sistema. Um `Retired` sem essa entrada não alimenta esta skill.
- **Falta uma seção obrigatória** — conforme as Seções do documento das regras de consumo do formato, que incluem as seções extras e o template customizado que a configuração declara. Reporte a lacuna contra o formato e pare.

Se a story modifica comportamento cujo caso de uso não existe de forma alguma, recomende executar o use-case-extractor naquela área primeiro.

Examine também o repositório de ADRs em busca de ADRs Accepted que toquem a área afetada — eles restringem o plano do mesmo modo que as convenções da configuração. Um delta que não pode ser satisfeito sem contradizer um deles é uma decisão, não um detalhe de planejamento: roteia-se para o Passo 4.5 e nunca é absorvido no plano.

## Passo 2 — Localizar o delta e classificar o cenário

Para cada caso de uso afetado, encontre a entrada do Histórico de revisões que corresponde ao ID da story atual.

- A entrada é de **criação** (Resumo `Criação`) → **cenário de criação** para este caso de uso.
- A entrada lista itens adicionados/alterados/removidos → **cenário de alteração**; essa entrada é o delta.
- A entrada é de **conformidade** → **cenário de alteração** em que o corpo do documento não mudou: os identificadores que ela cita são o delta, e o comportamento que eles descrevem é o alvo que o código passa a cumprir.
- A entrada é de **retirada** (Resumo `Retirada`, Status `Retired`) → **cenário de alteração** em que todo o comportamento do documento sai do sistema: o documento inteiro é o delta, desdobrado como no cenário de criação, com cada item removido. Na análise de regressão, o que precisa continuar funcionando vem dos outros casos de uso que compartilham o código, não do corpo deste.
- **Nenhuma entrada carrega o ID da story** → o documento não foi atualizado para esta story. Não infira o delta a partir do texto da story: reporte e roteie o documento ao use-case-creator antes de planejar. A única exceção é uma entrada que o limite de cinco entradas do template empurrou para fora do histórico retido — recupere-a do controle de versão, onde vive o histórico completo, e prossiga; quando não for possível recuperá-la, reporte e pare.

**Cenário técnico** — a story técnica confirmada no Passo 1. Não há entrada a localizar nem caso de uso afetado: o delta é o resultado técnico que a story declara. Cada item `D` é esse resultado, verificável por uma checagem nomeada — o teste de arquitetura, a contagem da detecção de uma migração declarada no escopo da story, a versão no arquivo de build, a ausência da flag no código e na configuração. Todo o comportamento observável que passa pelo código alterado é regressão (Passo 4), porque a story promete deixá-lo intacto.

**As entradas de revisão mais antigas são somente leitura.** Descrevem comportamento já implementado — são estado, não trabalho pendente. Nunca as trate como algo a implementar. Seu único uso legítimo é a verificação de área quente do Passo 4. O mesmo vale, seja qual for sua posição, para as entradas sem ID de story (mapeamento inicial, reconciliação com o código, revisão editorial): descrevem o que o código já faz, ou só mudam onde e como isso está escrito.

Numere os itens de delta conforme os localiza (`D1`, `D2`, ...), em sequência contínua no documento inteiro: com mais de um caso de uso afetado, a numeração segue de um para o outro e nunca reinicia. Ao numerar, anote de que elemento da fonte cada item vem (passo, extensão, `RN-N`, `CA-N`) — é essa anotação que a coluna Usada em das Referências registra, e é ela que mantém o item rastreável depois de reescrito por extenso. No cenário de alteração, a entrada de revisão já os lista. No cenário de criação, o documento inteiro é o delta: desdobre-o em itens ao longo do eixo que o plano vai satisfazer — cada passo do fluxo principal, cada extensão e cada regra de negócio ou critério de aceite que não decorra de um desses (o rótulo de cada critério diz o que ele cobre) — para que toda unidade ainda nomeie o que satisfaz. Um critério `não funcional` é sempre item próprio, porque a meta não decorre do passo que ela mede; a unidade que o satisfaz nomeia como a meta é verificada (teste automatizado, teste de carga ou medição). A numeração é o que torna verificável o plano de eixo único: as unidades do plano citam esses identificadores, e a verificação de rastreabilidade confere essas citações nas duas direções.

## Passo 3 — Inspecionar a base de código

**A inspeção sempre acontece aqui.** Um mapa do `impact-mapping` não é uma entrada deste passo, mesmo quando existe um para a demanda de que esta story veio. Um mapa tem escopo de uma demanda em refinamento e uma ITS de exatamente uma story; o refinamento pode durar meses entre os dois, e, quando o plano existe, verificar o mapa custa o mesmo que derivar o alcance do zero. O `impact-mapping` declara a mesma fronteira do seu lado. O arquiteto pode, claro, ter lido o mapa; o que não acontece é um plano herdar um alcance que nunca verificou.

**Cenário de criação** — exploração ampla e dirigida:
- Localize pontos de entrada, camadas e modelos relacionados ao ator/ação, guiado pelo mapa de estrutura da configuração.
- Encontre funcionalidades existentes semelhantes para reaproveitar padrões (tratamento de erros, estilo de validação, organização de testes).
- Mapeie cada passo do fluxo principal e cada fluxo de exceção para um componente, classificando cada um como: existe como está / modificar / criar.
- Todo componente classificado como **modificar** já atende a comportamento que esta story não muda. Ele entra na varredura do Passo 4, que transforma esse comportamento em pontos de regressão (`RG-N`), reivindicados pela unidade que o modifica como em qualquer outro cenário.

**Cenário de alteração** — análise estreita, guiada pelo delta:
1. Use o documento (seu corpo atual descreve o comportamento consolidado) para localizar os componentes que implementam este caso de uso hoje.
2. Mapeie **apenas os itens de delta**: para cada item adicionado/alterado/removido, identifique o código correspondente e o que precisa mudar.
3. **Análise de regressão no próprio caso de uso:** identifique o comportamento que *não* mudou mas compartilha código com o que vai mudar. O corpo completo do caso de uso (não o delta) diz tudo o que precisa continuar funcionando. Numere esses pontos (`RG-1`, `RG-2`), também em sequência contínua no documento, anotando o elemento da fonte de que cada um vem — cada um será reivindicado pela unidade do plano que toca o código compartilhado, e a reivindicação é verificada no Passo 6. O comportamento de outros casos de uso que passa pelo mesmo código vem da varredura do Passo 4, na mesma sequência.

**Cenário técnico** — análise guiada pelo resultado técnico:
1. Localize todo o código que a story altera, guiado pelo mapa de estrutura — numa migração declarada, as ocorrências que a detecção dela encontra no escopo da story; numa atualização de dependência ou de stack, os usos da API que muda.
2. Para cada componente, identifique o comportamento que ele serve hoje e leve-o à varredura do Passo 4: todo ponto de regressão deste cenário vem de lá.
3. O comportamento que o código alterado serve e que nenhum caso de uso descreve não vira ponto de regressão sem fonte. A cobertura dele é a unidade de testes de caracterização do Passo 4.6, quando o código não tem testes; a lacuna de documentação entra em Riscos e pontos de atenção, com o use-case-extractor como rota.

**Delta pendente de outra story.** Um caso de uso que o plano lê — o que ele altera ou um que fornece pontos de regressão — pode ter o delta de outra story ainda não entregue (prime-architect/use-case, Ciclo de vida do status): o corpo descreve o estado-alvo daquela story, e o código ainda faz o anterior nos itens dela. O plano nunca presume em silêncio qual dos dois estará no código quando ele for implementado:
- delta desta story escrito sobre o de outra, no mesmo caso de uso → o plano presume a outra entregue antes, porque foi escrito sobre o estado-alvo dela;
- delta pendente num caso de uso que só fornece regressão → confirme a ordem de entrega com o arquiteto; os pontos de regressão nos itens daquele delta descrevem o estado que a ordem confirmada presume.

Nos dois casos, a ordem presumida vai para as premissas técnicas do plano, e a outra story entra em Referências como dependência (prime-core/its-contract).

Durante toda a inspeção, anote cada ponto em que existe mais de um caminho de implementação viável. Essas notas alimentam o Passo 5 (linhas de alternativa descartada) e o Passo 4.5 (candidatos a ADR). Anote também, para o Passo 4.6, o que a story introduz que é gatilho de especificação do quality-model — uma entrada externa, uma chamada a outro sistema, uma escrita em mais de um recurso, estado disputado, um dado novo, um volume que cresce —, onde o código só comporta a mudança se for distorcido e onde o código que o plano altera não tem testes.

## Passo 4 — Verificação de risco em todo o repositório e a fronteira de fora de escopo

Para cada componente previsto para modificação, verifique se ele também atende a outros casos de uso documentados (busque no repositório). Essa única varredura rende duas saídas diferentes — pontos de regressão e fronteiras de fora de escopo —, e fundi-las é o erro a evitar.

**Pontos de regressão de outros casos de uso.** Vale para todo cenário — criação, alteração, retirada e técnico. O comportamento de outro caso de uso que passa pelo código que o plano modifica vira ponto de regressão, na mesma sequência `RG-N` do Passo 3, anotado com o caso de uso e o elemento de origem, e é reivindicado pela unidade que toca o código compartilhado como qualquer outro. Um caso de uso que usa o mesmo componente sem passar pelo código modificado não gera ponto: quando há risco de alteração acidental, ele é uma fronteira de fora de escopo (abaixo).

**Riscos.** O que merece atenção sem um teste concreto a exigir — dependências de ambiente ou de dados, questões em aberto —, escrito em Riscos e pontos de atenção. Opcionalmente, se um delta toca um passo que também aparece nas últimas 1–2 entradas de revisão do mesmo documento, sinalize-o como **área quente** (mudado com frequência → merece atenção extra de teste). É uma consulta direcionada, não uma releitura do histórico.

**Fronteiras de fora de escopo.** O contrato exige que o plano de implementação nomeie o que não deve ser tocado, e é aqui que essas bordas são derivadas. Três fontes, cada entrada nomeando *por que é uma borda*:

- **Compartilhado mas intocado.** Código que a inspeção alcançou, que atende a outro caso de uso e que o delta não exige alterar — o lugar mais provável onde uma melhoria não solicitada vai cair. Distinto de um ponto de regressão: `RG-N` é código que o plano **toca** e que precisa continuar funcionando; uma fronteira é código que o plano **não deve** tocar de forma alguma.
- **Superfícies de contrato que esta story não muda.** Formatos de API, esquema, payloads de eventos alcançados pela inspeção cujos consumidores a story não tem mandato para migrar. Nomeá-los é o que evita que uma mudança de assinatura conveniente chegue sem aviso.
- **Legado deliberadamente deixado em paz.** Código herdado numa área `legacy-maintained` ou `strangler` com que o plano convive sem corrigir — o veículo para o qual o Passo 4.6 roteia tais desvios.

Uma lista de fronteiras vazia é legítima e é escrita como tal ("nenhuma identificada"), nunca omitida: uma story genuinamente confinada a código que ninguém mais usa não tem bordas a nomear. O que não é legítimo é uma borda sem razão — o implementador precisa conseguir distinguir uma fronteira de um esquecimento, e o revisor confere a seção item a item.

## Passo 4.5 — Detectar e propor ADRs

Revise os pontos de decisão anotados no Passo 3 contra a fronteira de decisão do contrato: alguma escolha restringe implementações futuras, afeta mais de um caso de uso ou módulo, ou precisa de uma justificativa legível fora desta ITS? Se sim:

1. Leia o template de ADR do contrato (`../its-contract/templates/adr-template.md`) e redija o ADR conforme ele, status `Proposed`, na localização de ADRs configurada. As alternativas consideradas são o ponto do registro, não enchimento.
2. **Apresente-o ao arquiteto para aprovação antes de entregar a ITS.** O arquiteto decide; você propõe. Uma ITS não é entregue enquanto um ADR que ela referencia ainda estiver Proposed. Se recusado, o registro passa a `Rejected`, com a razão, conforme o ciclo de vida do template; recusado como "escopo de story", a decisão recai numa linha de alternativa descartada na ITS.
3. Ao escrever a ITS (Passo 5), liste o ADR aprovado em Referências e, em cada unidade do plano que a decisão restringe, escreva como instrução a restrição que ela impõe — conforme a regra *Conteúdo, não ponteiro* das Regras de escrita, lidas naquele passo. O implementador não deve precisar abrir o ADR para saber o que fazer; quem tem acesso a ele o lê para saber por quê.

**Um delta que contradiz um ADR Accepted passa por este passo, sempre.** Nunca planeje contornando a contradição em silêncio, e nunca deixe as convenções da configuração resolvê-la — a regra de precedência do prime-core/prime-config é que um conflito com um ADR Accepted é reportado, não resolvido. Dois desfechos são legítimos: o plano cabe sob o ADR e a restrição é declarada nas unidades que ela vincula; ou a story genuinamente substitui a decisão, e o registro substituto é redigido e roteado exatamente como qualquer outro candidato. O ADR substituído assume `Superseded by ADR-NNN` somente quando o arquiteto aprova o substituto.

Não produza em excesso: a maioria das stories rende zero ADRs. Um ADR existe porque uma decisão real entre stories foi tomada, não porque a seção quer ser preenchida.

## Passo 4.6 — Definir a qualidade do plano

A ITS é onde a qualidade da story é decidida. Antes de escrever, apoie o plano no **prime-core/quality-model** e no **prime-core/coding-standards** — não como um gate (aprovar é trabalho do revisor, depois), mas como a definição do que o plano precisa decidir. Os IDs servem a este passo e à conversa com o arquiteto; nunca entram no corpo do documento.

1. **Declare a calibração.** Leia no registro de áreas o estado e o nível de criticidade de cada área que o plano altera — área não registrada é `current` e `padrão` — e escreva-os nas premissas do plano, com a condição de remoção de uma área `efêmera`. O nível decide a intensidade dos critérios calibrados que os passos seguintes aplicam.
2. **Decida os gatilhos.** Para cada gatilho de `references/quality-triggers.md` que a story dispara (as notas do Passo 3), tome a decisão que o gatilho lista e escreva-a como instrução na unidade que a implementa, com o valor concreto e o teste ou a medição que a prova. O valor vem, nesta ordem:
   - dos slots que servem aos critérios do gatilho (o mapa Critério → slots do índice do catálogo diz quais são, e o arquivo da família de cada um entra aqui), no valor efetivo da área — override da área, do nível, do projeto ou o padrão do time na release fixada;
   - de uma decisão própria desta story, quando a dependência ou o caso pede outro valor — e então a unidade diz por quê;
   - de lugar nenhum: um slot de que a decisão precisa e que não tem valor é uma lacuna a reportar, nunca um valor a inventar.

   Uma decisão que vale além desta story — o primeiro outbox do sistema, uma política de idempotência para todos os consumidores — volta ao Passo 4.5 como candidato a ADR.
3. **Planeje a preparação.** Onde o Passo 3 encontrou código que só comporta a mudança se for distorcido, planeje uma unidade de refatoração preparatória, sem mudança de comportamento; onde encontrou código sem testes que o plano altera, uma unidade de testes de caracterização. As duas vêm antes das unidades de comportamento.
4. **Confira o piso e as convenções.**
   - Nenhuma unidade instrui algo que viole um critério `[NON-NEGOTIABLE]` ou um slot **INVARIANT**. Uma violação silenciosa de um ou de outro é o mesmo defeito, e o revisor bloqueia nos dois.
   - Em cada área, o plano segue o valor **CONVENTIONAL** que o estado registrado pede: o padrão atual numa área `current`, o padrão local em `legacy-maintained` e `strangler`, o novo valor dentro do escopo de uma migração declarada.
   - Uma área `strangler` não recebe comportamento novo: capacidade nova planejada ali pertence ao módulo substituto que o registro nomeia.
5. **Calibre ao nível.** O cuidado proposto corresponde ao nível declarado: sinalize tanto o sub quanto o over-engineering — estrutura especulativa é dívida (`QM-MT-4`).

**Quando um valor de convenção entra no documento.** Em dois casos, e só neles: quando uma decisão de gatilho precisa dele, ou quando a área segue um valor diferente do padrão do time — legado, migração em curso, override. Fora disso, a convenção é a base de quem implementa e não se repete. A unidade escreve o valor, nunca o slot; um exemplo canônico declarado na configuração pode ser apontado pelo caminho do arquivo.

**Registre cada afastamento onde ele pertence**, nunca como prosa solta:
- uma **linha de alternativa descartada** na unidade que o afastamento afeta, quando é uma escolha entre caminhos viáveis que morre com a story;
- uma **fronteira de fora de escopo / não alterar**, quando é legado herdado que você deliberadamente deixa intocado;
- um **ADR**, quando o afastamento sobrevive à story ou não tem condição de saída — roteie-o de volta pelo Passo 4.5 para a aprovação do arquiteto.

No documento, o afastamento é escrito por extenso com os elementos do registro de exceção do quality-model: o que o plano deixa de fazer, onde, por quê e quando isso é revisto. O responsável é quem assina a ITS; um afastamento de segurança exige também o responsável de segurança que o projeto declara. O critério ou slot de que ele se afasta entra apenas em Referências.

Este passo define a qualidade que o plano especifica; nunca aprova nem reprova. Duas coisas, porém, são defeitos a fechar antes de escrever: uma violação *silenciosa* de inegociável ou de slot INVARIANT, e um gatilho disparado sem decisão.

## Passo 5 — Escrever a ITS conforme o contrato

Só agora leia o template (`../its-contract/templates/its-template.md`) e as Regras de escrita (`../its-contract/references/writing-rules.md`): o plano está fechado, e os dois servem à escrita.

Escreva o documento exatamente conforme o **prime-core/its-contract**: nomenclatura de arquivo, as quatro seções obrigatórias, nível de detalhe, a regra "instrui, não implementa" e a regra da alternativa descartada vêm todas de lá. Escreva o plano em ordem de execução e deixe-o carregar o mapeamento único — O que muda declara as mudanças e o que continua valendo e para aí. Sequenciar agora é um ato de escrita, não uma lista separada: a ordem que você escolhe é a ordem em que o implementador trabalha e a ordem em que o revisor percorre o diff.

Duas das regras de escrita do contrato são onde uma ITS entregue mais falha com seu leitor, e ambas valem uma releitura antes da primeira linha: *conteúdo, não ponteiro* e *a voz do autor*. O que esta skill acrescenta é o alcance de cada uma aqui. Toda exigência que você leu numa fonte ao longo dos Passos 1 a 4.6 — a regra de negócio, o critério de aceite, a restrição do ADR, a convenção que governa a área — chega ao documento escrita, no ponto em que é usada, e o identificador da fonte vai para Referências; o leitor da ITS não tem os documentos que você teve abertos. E as notas tomadas ao longo dos Passos 3 a 4.6 são material de trabalho: nenhuma delas pertence ao documento.

A seção **Referências** é escrita a partir dos documentos já abertos: a story, os casos de uso carregados no Passo 1 e os que forneceram pontos de regressão no Passo 4, as stories de cuja entrega o plano depende (Passo 3, delta pendente), os ADRs aprovados no Passo 4.5 e os critérios e slots que o Passo 4.6 deixou registrados. Preencha cada linha à medida que escreve o item ou a unidade que a usa, com a anotação de origem que o Passo 2 e o Passo 3 deixaram, enquanto a fonte ainda está à sua frente — é isso que mantém a seção um snapshot tirado na entrega em vez de uma reconstrução de memória, e é por isso que ela não custa nada para produzir. Ela registra *de onde cada item veio* e para aí: nenhuma glosa, nenhum resumo da fonte — o conteúdo já está no corpo.

## Passo 6 — Verificar a rastreabilidade antes de entregar

Execute as verificações do contrato sobre o documento pronto. Elas não viram seção nem tabela: o documento já declara o que elas conferem — os itens de O que muda, o Atende e os Testes de cada unidade, a coluna Usada em das Referências.
- Delta → plano: todo item `D` é atendido por pelo menos uma unidade, ou declara na própria linha que já é atendido hoje e por quê.
- Plano → delta: toda unidade nomeia seus itens ou uma consequência técnica declarada.
- Regressão → plano: todo `RG-N` é reivindicado por exatamente uma unidade, com o teste de não regressão nomeado ali.
- Fonte → item: todo item e todo ponto de regressão aparece em Referências, na linha da fonte de que veio.
- Alternativa descartada: todo ponto em que o Passo 3 encontrou mais de um caminho viável está fechado — uma linha de alternativa descartada na unidade, carregando a razão decisiva, ou um ADR listado em Referências. Uma unidade que não enfrentou escolha real não declara nada; o que esta verificação pega é uma escolha real deixada sem registro.
- Verificação de fronteira: nenhuma decisão arquitetural (conforme os critérios do contrato) tomada no corpo do documento — cada uma vive em um ADR listado em Referências, e nenhum deles ainda está Proposed.
- Verificação de fora de escopo: toda entrada em "Fora de escopo — não alterar" declara por que é uma borda (compartilhado mas intocado · superfície de contrato não migrada · legado deixado em paz), e nenhuma entrada duplica um ponto de regressão — `RG-N` é código tocado que precisa continuar funcionando, uma fronteira é código que não deve ser tocado.
- Verificação de qualidade: as premissas declaram o estado e o nível de criticidade de toda área que o plano altera; todo gatilho disparado tem decisão concreta numa unidade, com o teste ou a medição que a prova; todo afastamento de um critério do prime-core/quality-model ou de um slot do prime-core/coding-standards trazido pelo Passo 4.6 está registrado como uma exceção nomeada (linha de alternativa descartada, fronteira de fora de escopo ou ADR listado em Referências), escrita por extenso e com a condição de saída. Nenhuma violação silenciosa de inegociável e nenhuma violação silenciosa de slot INVARIANT permanece.
- Verificação de dependência: todo delta pendente de outra story num caso de uso que o plano lê tem a ordem de entrega presumida declarada nas premissas, e a outra story está em Referências como dependência.
- Verificação de autossuficiência: nenhum identificador de outro documento aparece fora de Referências; nenhuma instrução depende de abrir a fonte para ser executada; toda linha de Referências diz onde foi usada e nenhuma carrega conteúdo que o corpo deveria carregar.

Em seguida execute os quatro testes pré-entrega do contrato sobre o documento pronto — implementador, leitor frio, colagem, autor. Se qualquer verificação ou qualquer teste falhar, conserte o plano — não entregue uma ITS com escopo sem explicação ou decisões enterradas.

## Revisando uma ITS entregue

Quando uma ITS entregue volta — o implementador devolveu uma pergunta que o documento não responde, ou o code review devolveu a story ao arquiteto —, a revisão segue `references/revising-an-its.md`. Numa ITS nova, ele não é lido.

## Saída

Um documento de ITS (nomeado conforme o contrato) na localização configurada, mais zero ou mais ADRs aprovados pelo arquiteto, rastreável de ponta a ponta: story → deltas dos casos de uso (numa story técnica, o resultado técnico) → decisões (ADRs) → mudanças de código → testes. Uma decisão candidata que o arquiteto recusou fica registrada como `Rejected`; recusada como escopo de story, vive na ITS como uma linha de alternativa descartada na unidade que ela afeta.

A passada operacional vive em `checklists/its-checklist.md`. Leia-a no Passo 6, para conferir a ITS antes de entregar — não no Passo 0. O template do próprio documento não: ele é de propriedade do `prime-core/its-contract` e é lido de lá.

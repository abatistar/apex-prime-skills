---
name: impact-mapping
description: Mapeia o alcance de uma mudança pretendida na base de código e na camada documentada, produzindo evidência ancorada e nunca um veredito. Skill da camada do arquiteto - responde o que uma mudança toca, o que depende dela, em quais áreas registradas ela entra, quais casos de uso a cobrem e quais ADRs incidem sobre ela. Use quando o arquiteto perguntar o que uma mudança alcança - "o que a mudança na regra de preço toca", "o que depende deste módulo", "mapeie o raio de impacto da S-131", "o que quebra se mudarmos este payload", "onde vive este comportamento" - e sempre como primeira passada da feasibility-analysis. NÃO use para decidir se a mudança deve ser feita (feasibility-analysis), para escrever ou revisar uma ITS (its-generator), para documentar casos de uso (use-case-creator, use-case-extractor), para revisar uma implementação (code-review), para escrever código de aplicação (camada do dev) nem para o impact mapping de produto (objetivo, atores, impactos, entregas).
---

# Impact Mapping (prime-architect)

Esta skill responde a uma pergunta e recusa a próxima: **o que esta mudança alcança?** Ela produz evidência — ancorada, delimitada e classificada por confiança — e a entrega a quem precisa decidir. Decidir é trabalho de outro: a `feasibility-analysis` transforma este mapa em um veredito, e o arquiteto pode simplesmente lê-lo.

A separação é a mesma que o repositório já traça entre o `prime-core/quality-model` e o `prime-architect/code-review`: definir e julgar são atos diferentes, com modos de falha diferentes. Um mapa que recomenda deixou de ser evidência, porque o leitor não consegue mais distinguir quais linhas são observações e quais são opiniões.

## O padrão de um mapa

Um mapa é bom quando um leitor que discorda de todas as conclusões ainda consegue usá-lo. Isso exige quatro propriedades, e cada uma delas é uma regra abaixo: toda linha é **ancorada ou explicitamente marcada como inferência**, todo grau de alcance é **nomeado** em vez de fundido numa lista só, a **revisão lida é registrada** e a **borda do mapa é declarada** em vez de subentendida.

**A proveniência é a disciplina.** Esta skill não produz nenhum documento governado por um contrato do core e não passa por nenhum gate, então a única coisa que a separa de um palpite confiante é que toda afirmação sobre comportamento se resolve em uma localização. Quatro estados, e toda linha carrega exatamente um:

- **Ancorada** — cita `caminho/Arquivo.ext:linha` ou um elemento de caso de uso (`UC-NNN/RN-N`, `UC-NNN/CA-N`, `UC-NNN` passo N ou extensão Na), aberto nesta execução, na revisão que o mapa registra, e dizendo o que a linha afirma. Lida, não lembrada nem presumida. O leitor pode verificá-la sem perguntar, e é o único estado capaz de sustentar uma conclusão bloqueante adiante.
- **`[INFERRED]`** — deduzida em vez de rastreada de ponta a ponta no código: despacho dinâmico, reflexão, ligação decidida por configuração ou por dados, convenção de framework, o efeito de uma integração cujo lado remoto não está no repositório, um padrão observado em outro ponto da base, um acoplamento que o histórico de mudanças sugere. O raciocínio vai declarado na linha. É o marcador do formato de caso de uso, com a mesma definição (prime-architect/use-case, Marcadores de incerteza), pelo mesmo motivo: uma inferência lida como fato é pior que uma lacuna, porque ninguém a investiga.
- **`[UNVERIFIED]`** — afirmada pela demanda ou pelo arquiteto e não conferida contra o código. Legítima de carregar, nunca promovida em silêncio a fato.
- **Lacuna** — não foi possível determinar nem por dedução, declarada com *o que a resolveria*.

Este vocabulário é definido aqui e **reutilizado, não redefinido**, por toda skill que consome este mapa. Uma inferência sem marca é o defeito que mais importa, porque o mapa é consumido por uma skill que emite vereditos. Um veredito construído sobre evidência de proveniência desconhecida é uma preferência vestida de relatório. **Uma âncora errada é o segundo**: passa por fato, e é sobre âncoras que um veredito bloqueia. Agentes de código citam com frequência arquivos que não existem e linhas deslocadas — por isso uma âncora só existe depois de aberta, nunca de memória (Passo 7).

## Passo 0 — Ler a configuração e registrar a revisão

Leia o `docs/prime-config.md` conforme o contrato **prime-core/prime-config** (as regras de localização, precedência, divergência e bootstrap vivem lá; não as repita). Dele esta skill consome:

- o **mapa de estrutura** — onde as coisas vivem;
- o **registro de áreas** — o estado de cada área (`current`, `legacy-maintained`, `strangler`), o seu nível de criticidade (`efêmera`, `padrão`, `crítica`) e as exclusões;
- as **migrações declaradas** — para uma área `strangler`, o módulo substituto e o ID da migração;
- as **regras do projeto** — as áreas proibidas e as restrições operacionais e de compliance que alcançam as áreas tocadas;
- as localizações do **repositório de documentos** para casos de uso e ADRs, sob a raiz de documentos;
- os **comandos de verificação** — a evidência de cobertura que a configuração dá: quais verificações o projeto sabe executar (suíte, teste de arquitetura, contrato, mutação). Eles não dizem quais testes exercitam o quê; isso vem da leitura dos testes, no Passo 3.

Uma área que o registro não lista é `current` e `padrão` — o padrão que o contrato da configuração declara, não uma lacuna —, e o mapa a escreve assim, marcada *não registrada*, para que o leitor distinga o padrão de uma classificação decidida. Lacuna é a subseção Registro de áreas ausente, ou um slot sem valor de que o mapa precise: reportada conforme o `coding-standards`, nunca improvisada.

**Registre a revisão.** Um mapa descreve o código numa revisão, e o alcance decai a partir dela. Anote o commit lido (`git rev-parse HEAD`) e, quando a árvore de trabalho tem mudanças não commitadas, declare-as — o mapa leu algo que nenhum commit guarda. Quando a raiz de documentos é uma pasta paralela, versionada à parte, anote também a revisão dela. Sem controle de versão acessível, a data é o único registro, e o mapa diz isso.

## Passo 1 — Reformular a mudança como comportamento

A reformulação é definida aqui e só aqui. A `feasibility-analysis` a executa no seu próprio Passo 1, com a confirmação do arquiteto, e a entrega a este mapa já pronta — nesse caminho este passo é pulado, e a reformulação vira a linha de assunto como está.

A entrada costuma chegar como uma solução: *"adicionar uma coluna"*, *"cachear a consulta de cliente"*, *"mudar o endpoint"*. Reformule-a como o delta de comportamento observável — o que um usuário, um chamador ou um sistema a jusante verá de diferente. Depois delimite: declare explicitamente o que **não** muda, nos mesmos termos. Quando a reformulação teve de escolher entre leituras da entrada, confirme-a com o arquiteto antes de mapear: mapear a leitura errada custa o mapa inteiro.

Dois desfechos são legítimos aqui:

- A reformulação se sustenta → ela vira a linha de assunto do mapa, e tudo o que for rastreado precisa remeter a ela.
- A reformulação não pode ser feita sem inventar intenção → **`Insufficient input`**: pare, sem mapa e sem veredito, e devolva as perguntas específicas em vez de mapear uma mudança que ninguém definiu. É um achado, não uma falha — mapear uma mudança adivinhada custa mais que perguntar. Quando é a `feasibility-analysis` que executa este passo, o mesmo desfecho encerra a execução dela antes de qualquer mapa ser comissionado; nada foi julgado, então também não há *Undecidable*.

Quando a entrada nomeia uma solução e o delta de comportamento admite outras, registre isso em uma linha. Não avalie as alternativas — isso é decisão do arquiteto, informada pelo mapa.

## Passo 2 — Encontrar os pontos de entrada

De onde o comportamento é disparado: endpoint, job agendado, handler de evento, CLI, ação de UI, migração. Ancore cada um. São as sementes; tudo no Passo 3 cresce a partir delas.

Um ponto de entrada que a busca direta não alcança — dispatch dinâmico, reflexão, ligação orientada por configuração, convenção de framework — entra como `[INFERRED]` quando há de onde deduzi-lo (a tabela de roteamento, a chave de configuração, a convenção nomeada), com o raciocínio na linha, e como lacuna quando não há, com sua resolução ("um trace em runtime resolveria isto"). Um mapa que perde um ponto de entrada em silêncio subestima o alcance exatamente do modo que torna errado um veredito de viabilidade.

## Passo 3 — Rastrear o alcance, em três graus

Alcance não é uma lista só. Fundir esses três é o que transforma um mapa em ruído:

- **Direto** — precisa mudar para que o comportamento mude. É o menor conjunto honesto; se ele for grande, isso já é o achado. Uma regra de negócio implementada em mais de um lugar tem **todas as cópias** neste grau — mudar uma só é a divergência que o `QM-CC-6` proíbe —, e a duplicação é registrada como fato.
- **Acoplado** — não muda, mas observa ou depende do que muda: chamadores, assinantes, relatórios, fixtures, testes, feature flags, qualquer coisa que leia o mesmo estado persistido. É onde o custo realmente se esconde, e onde um item não mapeado vira surpresa em produção. Os **testes** que exercitam o conjunto direto são sempre listados; o código direto que nenhum teste exercita é declarado como tal, por extenso.
- **Superfície de contrato** — visível fora desta base de código: formatos de requisição e resposta de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas públicas de funções em uma biblioteca compartilhada e a **telemetria consumida fora** — nomes de métricas, eventos de log estruturado, alertas e painéis que outro time ou sistema lê. Cruzar essa linha alcança consumidores que o mapa não enxerga. Nomeie a superfície e os consumidores conhecidos, inclusive serviços de outros projetos; não rastreie por dentro deles.

**Dados existentes.** Além dos três graus, o mapa declara o estado persistido que a mudança obriga a migrar, preencher ou reinterpretar: a forma e, quando o mapa tem acesso, o volume. Sem acesso ao volume, é uma lacuna. Uma coluna obrigatória nova sobre uma tabela com milhões de linhas não é a mesma mudança que sobre uma tabela vazia, e só o mapa está em posição de dizer qual das duas é.

**Como buscar.** O erro mais caro de um mapa é o item que ficou de fora: um falso positivo custa uma leitura; um falso negativo vira surpresa em produção. Por isso a busca é sistemática e fica registrada no relatório, para que o leitor saiba que tipo de omissão é plausível:

- **referências de símbolo** a partir das sementes — chamadores, implementações, sobrescritas, assinantes;
- **busca textual pelos nomes de contrato** — caminho de endpoint, nome de tópico, fila ou evento, tabela e coluna, chave de configuração, nome de flag — em todos os arquivos, não só no código-fonte: SQL dentro de strings, arquivos de configuração, migrações, scripts, infraestrutura como código, testes, definições de pipeline. O acoplamento por nome escapa a toda análise de referência;
- **leitores do mesmo estado persistido** — toda consulta, job ou relatório que lê a tabela ou a coleção que muda;
- **o histórico de mudanças** dos arquivos do conjunto direto (`git log`): arquivos que mudaram junto com eles na maior parte dos commits revelam um acoplamento que nenhuma análise estática vê. O histórico aponta onde inspecionar; não é evidência de comportamento. Inspecionado e confirmado, o item entra ancorado pelo código lido; não inspecionado, entra `[INFERRED]`, com a contagem na linha ("mudou junto com `X` em 7 de 9 commits").

Para cada item: localização, grau e uma linha sobre *por que está no mapa*. Uma entrada cuja razão não é declarada não pode ser contestada, e um mapa que não pode ser contestado não é evidência.

## Passo 4 — Sobrepor o registro de áreas

Toda área tocada carrega seu **estado** e seu **nível de criticidade** registrados na configuração — ou `current` e `padrão`, marcados *não registrada* (Passo 0). Os dois são elicitados, nunca inferidos do nome de um diretório ou da idade de um arquivo — o bootstrap do `prime-config` deixa isso explícito, e esta skill não tem licença para suavizá-lo. Código declarado como exclusão (gerado ou de terceiros) entra no mapa como tal: a mudança nele vai para a origem — o gerador ou o fornecedor.

Duas marcas acompanham a área quando a configuração as declara. Uma área `strangler` leva o módulo substituto e o ID da migração que as migrações declaradas nomeiam: é ali que comportamento novo nasce, e o mapa o diz como fato. Uma área que as regras do projeto proíbem ou restringem leva a regra citada.

A sobreposição importa porque o mesmo alcance custa de forma diferente conforme o estado e o nível: os mesmos três arquivos numa área `current` e numa `legacy-maintained`, ou numa área `padrão` e numa `crítica`, não são a mesma mudança. Registre os dois; não os precifique. Precificar é da `feasibility-analysis`.

## Passo 5 — Sobrepor a camada documentada

Cruze o alcance com o que o repositório afirma ser verdade.

- **Cobertura por casos de uso.** Quais `UC-NNN` cobrem o comportamento tocado, citados pelo elemento quando a cobertura é específica (`RN-N`, `CA-N`, passo, extensão), **cada um com seu status** — só um documento `Reviewed` é fonte de verdade (prime-architect/use-case):
  - `Reviewed` — cobertura.
  - `Draft` — cobertura ainda não validada. O mapa diz o que o mantém em `Draft` (marcadores pendentes, o delta de outra story aguardando promoção) e a rota: o `use-case-creator` (modo validação), ou o arquiteto, para promover.
  - `Retired` cobrindo código que ainda executa — a retirada não foi implementada, ou o código não a cumpriu. Registre-o como divergência.
  - Nenhum — comportamento tocado sem caso de uso é uma **lacuna de documentação**: registre-a, nomeie a área e anote que o `use-case-extractor` é a rota. Ela não bloqueia este mapa — o perfil de evidência e as lacunas mostram a confiança reduzida, e o mapa lista o que um caso de uso resolveria.
- **Divergência.** Onde o comportamento do código difere do caso de uso documentado, isso é um achado por si só, e muitas vezes a linha mais valiosa do relatório: o repositório deixou de ser a fonte de verdade para aquela área (`QM-DO-1`). Registre-a, citando o elemento do caso de uso e a âncora no código, e roteie-a ao `use-case-creator` (conformidade ou reconciliação). **Nunca remende um caso de uso de dentro desta skill.**
- **Incidência de ADR.** Quais ADRs `Accepted` incidem sobre as áreas tocadas. Onde a mudança pretendida parece contradizer um, declare a contradição e cite o ADR. Não a resolva: um conflito com um ADR Accepted é uma decisão, e decisões pertencem ao arquiteto e ao ciclo de vida do ADR, nunca a um mapa. Um ADR `Proposed` sobre a área também entra: é uma decisão em curso, que pode mudar o que a mudança pode fazer. Um `Superseded` não entra; o seu substituto, sim.

## Passo 6 — Delimitar o mapa e declarar a borda

O alcance é transitivo; um mapa útil não é. Pare deliberadamente e diga onde:

- Pare na **superfície de contrato** — nomeie o consumidor, não entre nele.
- Pare onde **não há dependência comportamental** — compartilhar um pacote não é alcance.
- Pare quando o próximo salto **não acrescenta nada em que uma decisão se apoie**.

Depois escreva a borda: o que deliberadamente não foi rastreado e o que justificaria rastrear. Um mapa sem limites é inutilizável; um truncado em silêncio é pior, porque seu leitor acredita que o alcance está completo. Declarar a borda é o que permite à `feasibility-analysis` devolver *Undecidable with current evidence* em vez de julgar sobre um quadro parcial — uma borda aquém do que um veredito exige é um dos fundamentos nomeados dessa skill para a indecidibilidade, e só pode ser lida se este mapa a declarou.

A borda vale na revisão registrada. Quem lê o mapa depois confere se ela ainda vale: quando os arquivos citados mudaram desde aquela revisão (`git diff <revisão>..HEAD -- <arquivos>`), as linhas deles envelheceram.

## Passo 7 — Verificar antes de entregar

Três verificações, cada uma corrigida no próprio mapa em vez de anotada:

- **Âncoras.** Toda âncora foi aberta nesta execução, na revisão registrada, e a linha citada diz o que a entrada afirma. A que não sobrevive à conferência é corrigida, ou rebaixada a `[INFERRED]` ou a lacuna — nunca mantida.
- **Proveniência.** Toda linha carrega exatamente um estado.
- **Perfil de evidência.** Conte, por grau, as linhas ancoradas, `[INFERRED]` e `[UNVERIFIED]`, e as lacunas. As contagens vão no cabeçalho: são a base de confiança do mapa, declarada como fato em vez de adjetivo — o leitor vê de relance quanto do alcance foi lido e quanto foi deduzido.

## Saída

Um relatório de mapa de impacto — um artefato de trabalho do arquiteto, não um documento do repositório. Ele é
arquivado onde a demanda vive (tracker, thread de refinamento, PRD), nunca na raiz de documentos: o repositório de
casos de uso é a fonte de verdade sobre o comportamento do sistema, e nada aqui compete com ele. Não
carrega número sequencial, não aparece em nenhuma configuração e não é mantido depois que a demanda segue adiante.

Seu cabeçalho é obrigatório, porque um mapa que não pode ser citado não pode ser consumido:

- **ID** — `IM-<demand-id>-N`, onde `<demand-id>` é o identificador da própria demanda no processo de refinamento do time e `N` distingue mapas sucessivos da mesma demanda. Derivado, nunca sequencial: o mapa tem o tempo de vida da demanda, não o do repositório.
- **Revisão** — o commit lido, as mudanças não commitadas quando houver e, com raiz de documentos paralela, a revisão dela (Passo 0). É o que torna o mapa verificável: o alcance decai a partir dela.
- **Data** — o dia da leitura.
- **Demanda** — o que foi mapeado, nos termos de quem pediu.
- **Perfil de evidência** — as contagens do Passo 7.

O corpo contém:

1. **A mudança**, reformulada como comportamento, com sua fronteira explícita.
2. **O mapa**, separado por grau — direto, acoplado, superfície de contrato — cada entrada ancorada, localizada e justificada em uma linha, mais os dados existentes.
3. **Como o alcance foi buscado** — as sementes e as buscas do Passo 3.
4. **Estados das áreas**, do registro.
5. **A camada documentada** — cobertura por casos de uso com o status de cada um, divergências encontradas, incidência de ADR.
6. **Lacunas e questões em aberto**, cada uma com o que a resolveria.
7. **Onde o mapa para**, e por quê.

Sem veredito, sem recomendação, sem estimativa. Se o leitor do relatório não consegue dizer se a mudança é uma boa ideia, a skill cumpriu seu papel.

A passada operacional e o template do relatório vivem em `checklists/impact-map-checklist.md`.

## Consumidores

- **`feasibility-analysis`** — executa este mapa primeiro e nunca julga sem ele, citando-o por ID e revisão. Lê graus, estados de área, a camada documentada, o perfil de evidência e a borda declarada; a borda é o que lhe permite devolver *Undecidable with current evidence* com honestidade, em vez de decidir sobre um quadro cujo fim ela não enxerga.
- **O arquiteto**, lendo-o diretamente para decidir onde olhar a seguir.

**Não é consumidor: o `its-generator`.** Um mapa tem escopo de uma *demanda* em refinamento; uma ITS tem escopo de *exatamente uma story*, e o refinamento pode durar meses entre os dois. Alimentar um plano de escopo de story com um mapa de escopo de demanda vai contra a única disciplina em que aquela skill se apoia — um delta, o da story — e, quando a ITS existe, o mapa já é velho o bastante para que verificá-lo custe o mesmo que derivá-lo do zero. O `its-generator` inspeciona o código ele mesmo, todas as vezes. O arquiteto pode, claro, ter lido este mapa; o que não acontece é um plano herdar um alcance que nunca verificou.

**Divergências encontradas aqui vão para as skills de caso de uso, nunca para uma ITS.** Uma divergência código × caso de uso é resolvida pelo `use-case-creator` ou pelo `use-case-extractor` antes da especificação, não carregada adiante para dentro de um plano de implementação.

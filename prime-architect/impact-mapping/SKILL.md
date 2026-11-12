---
name: impact-mapping
description: Mapeia o alcance de uma mudança pretendida no código e na camada documentada - o que ela toca, o que depende dela, o contexto do projeto, os casos de uso e os ADRs que incidem -, como evidência ancorada e nunca um veredito. Use quando o arquiteto perguntar o que uma mudança alcança - "o que a mudança na regra de preço toca", "mapeie o raio de impacto da S-131", "o que quebra se mudarmos este payload" - e como primeira passada da feasibility-analysis. NÃO use para decidir se a mudança deve ser feita (feasibility-analysis) nem para o impact mapping de produto.
context: fork
background: false
---

# Impact Mapping

Esta skill responde **o que esta mudança alcança** e recusa a pergunta seguinte. Ela entrega evidência ancorada, delimitada e classificada por confiança. Quem decide é outro: a `feasibility-analysis` transforma este mapa em veredito, e o arquiteto pode lê-lo direto.

Definir e julgar falham de modos diferentes — a mesma separação que o repositório traça entre o `quality-model` e o `code-review`. Um mapa que recomenda deixou de ser evidência: o leitor não distingue mais observação de opinião.

**Roda isolada.** Onde a plataforma permite (`context: fork` no Claude Code), esta skill roda num subagente. Ela não vê a conversa de quem a invocou: recebe só os argumentos — a demanda, ou a reformulação pronta e a fronteira declarada quando vem da `feasibility-analysis` — e devolve só o relatório. Por isso o relatório da Saída é a resposta final inteira, e uma pergunta ao arquiteto só sai como `Insufficient input`.

## O padrão de um mapa

Um mapa é bom quando um leitor que discorda de todas as conclusões ainda consegue usá-lo.

**A proveniência é a disciplina.** Esta skill não produz documento governado por contrato e não passa por gate. Só uma coisa a separa de um palpite confiante: toda afirmação sobre comportamento se resolve em uma localização. Quatro estados, e toda linha carrega exatamente um:

- **Ancorada** — cita `caminho/Arquivo.ext:linha` ou um elemento de caso de uso (`UC-NNN/RN-N`, `UC-NNN/CA-N`, `UC-NNN` passo N, extensão Na). Aberta nesta execução, na revisão registrada, e dizendo o que a linha afirma. Lida, nunca lembrada nem presumida. É o único estado que sustenta uma conclusão bloqueante adiante.
- **`[INFERRED]`** — deduzida em vez de rastreada de ponta a ponta: despacho dinâmico, reflexão, ligação decidida por configuração ou por dados, convenção de framework, integração cujo lado remoto não está no repositório, padrão observado em outro ponto da base, acoplamento que o histórico sugere. O raciocínio vai na própria linha. É o marcador do formato de caso de uso, com a mesma definição (use-case, Marcadores de incerteza), pelo mesmo motivo: uma inferência lida como fato é pior que uma lacuna, porque ninguém a investiga.
- **`[UNVERIFIED]`** — afirmada pela demanda ou pelo arquiteto, não conferida contra o código. Legítima de carregar, nunca promovida em silêncio a fato.
- **Lacuna** — não foi possível determinar nem deduzir. Declare *o que a resolveria*.

Este vocabulário é definido aqui e **reutilizado, nunca redefinido**, por toda skill que consome o mapa. Dois defeitos importam mais: uma inferência sem marca, que vira fundamento de veredito, e uma âncora errada, que passa por fato. Agentes de código citam arquivos que não existem e linhas deslocadas. Uma âncora só existe depois de aberta, nunca de memória (Passo 7).

## Passo 0 — Registrar a revisão

A configuração do projeto não é lida aqui. Cada fato dela é lido no passo que o usa, e só a seção que o carrega, conforme as regras de consumo do **prime-config** (`../prime-config/references/consumer-rules.md`):

- **Estrutura**, nos Passos 2 e 3 — onde as coisas vivem;
- **Comandos de verificação**, no Passo 3 — quais verificações o projeto sabe executar (suíte, teste de arquitetura, contrato, mutação). Eles não dizem quais testes exercitam o quê; isso vem da leitura dos testes;
- **Opções**, no Passo 4 — a opção Legado;
- **Repositório de documentos**, no Passo 5 — onde vivem os casos de uso e os ADRs.

A seção de que um passo precisa e que falta é uma lacuna: reporte-a conforme as mesmas regras, nunca improvise.

**Registre a revisão.** O alcance decai a partir dela. Anote o commit lido (`git rev-parse HEAD`). Declare as mudanças não commitadas quando houver: o mapa leu algo que nenhum commit guarda. Com raiz de documentos em pasta paralela, versionada à parte, anote a revisão dela também. Sem controle de versão acessível, a data é o único registro, e o mapa diz isso.

## Passo 1 — Reformular a mudança como comportamento

Siga `references/reformulation.md`, a definição única da reformulação. A `feasibility-analysis` também a lê e a executa no próprio Passo 1. Quando a chamada vem dela, com a reformulação pronta e a fronteira nos argumentos, pule este passo: a reformulação vira a linha de assunto como está. Não escolha entre leituras concorrentes da entrada — devolva `Insufficient input`, com as leituras candidatas e a recomendada.

## Passo 2 — Encontrar os pontos de entrada

Ancore cada gatilho do comportamento: endpoint, job agendado, handler de evento, CLI, ação de UI, migração. São as sementes; tudo no Passo 3 cresce a partir delas.

Ponto de entrada que a busca direta não alcança — dispatch dinâmico, reflexão, ligação orientada por configuração, convenção de framework — entra `[INFERRED]` quando há de onde deduzi-lo (a tabela de roteamento, a chave de configuração, a convenção nomeada), com o raciocínio na linha. Sem isso, entra como lacuna, com a sua resolução ("um trace em runtime resolveria isto"). Um ponto de entrada perdido em silêncio subestima o alcance e torna errado um veredito de viabilidade.

## Passo 3 — Rastrear o alcance, em três graus

Alcance não é uma lista só. Fundir os três graus transforma o mapa em ruído:

- **Direto** — precisa mudar para que o comportamento mude. É o menor conjunto honesto; se ele for grande, isso já é o achado. Uma regra de negócio implementada em mais de um lugar tem **todas as cópias** neste grau: mudar uma só é a divergência que o `QM-CC-6` proíbe. Registre a duplicação como fato.
- **Acoplado** — não muda, mas observa ou depende do que muda: chamadores, assinantes, relatórios, fixtures, testes, feature flags, qualquer coisa que leia o mesmo estado persistido. É onde o custo se esconde. Liste sempre os **testes** que exercitam o conjunto direto, e declare por extenso o código direto que nenhum teste exercita.
- **Superfície de contrato** — visível fora desta base de código: formatos de requisição e resposta de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas públicas de funções em uma biblioteca compartilhada e a **telemetria consumida fora** (nomes de métricas, eventos de log estruturado, alertas e painéis que outro time ou sistema lê). Cruzar essa linha alcança consumidores que o mapa não enxerga. Nomeie a superfície e os consumidores conhecidos, inclusive serviços de outros projetos. Não rastreie por dentro deles.

**Dados existentes.** Declare também o estado persistido que a mudança obriga a migrar, preencher ou reinterpretar: a forma e, quando o mapa tem acesso, o volume. Sem acesso ao volume, é uma lacuna. Uma coluna obrigatória nova é uma mudança diferente numa tabela com milhões de linhas e numa tabela vazia, e só o mapa pode dizer qual das duas é.

**Como buscar.** O item que ficou de fora é o erro mais caro: um falso positivo custa uma leitura, um falso negativo vira surpresa em produção. Busque de forma sistemática e registre a busca no relatório, para que o leitor saiba que tipo de omissão é plausível:

- **referências de símbolo** a partir das sementes — chamadores, implementações, sobrescritas, assinantes;
- **busca textual pelos nomes de contrato** — caminho de endpoint, nome de tópico, fila ou evento, tabela e coluna, chave de configuração, nome de flag — em todos os arquivos, não só no código-fonte: SQL dentro de strings, arquivos de configuração, migrações, scripts, infraestrutura como código, testes, definições de pipeline. O acoplamento por nome escapa a toda análise de referência;
- **leitores do mesmo estado persistido** — toda consulta, job ou relatório que lê a tabela ou a coleção que muda;
- **o histórico de mudanças** dos arquivos do conjunto direto (`git log`). Arquivos que mudaram junto na maior parte dos commits revelam um acoplamento que nenhuma análise estática vê. O histórico aponta onde inspecionar; não é evidência de comportamento. Inspecionado e confirmado, o item entra ancorado pelo código lido; não inspecionado, entra `[INFERRED]`, com a contagem na linha ("mudou junto com `X` em 7 de 9 commits").

**Busque antes de abrir.** A busca localiza; de cada resultado abre-se o trecho que decide se ele entra no mapa e que o ancora. O arquivo inteiro, só quando o trecho depende do que o cerca; um pacote inteiro, nunca. A borda do Passo 6 também limita a leitura: o que fica além dela não é aberto.

Para cada item: localização, grau e uma linha sobre *por que está no mapa*. Uma entrada sem razão declarada não pode ser contestada, e um mapa incontestável não é evidência.

## Passo 4 — Sobrepor o contexto do projeto

O mesmo alcance custa de forma diferente conforme o projeto e o peso do que a mudança faz. Registre quatro fatos, cada um lido, nunca inferido do nome de um diretório nem da idade de um arquivo:

- **Legado.** O valor da opção Legado da configuração. Num projeto legado, o código existente é a referência para o que for escrito (`coding-standards`, Projeto legado), e o mapa diz isso como fato.
- **Sinais de criticidade.** O que, no alcance, pesa para o nível de criticidade da demanda, conforme a Calibração do `quality-model`: dinheiro, dado pessoal ou sensível, autenticação e autorização, obrigação regulatória, código com muitos dependentes — ou um prazo de vida declarado na demanda. Cada sinal vai ancorado. O mapa não declara o nível: quem o declara é a ITS.
- **Migrações em curso.** Os ADRs `Accepted` que declaram migração (`coding-standards`, Migrações) cujo escopo cobre código do alcance, com o número do ADR e o valor de destino.
- **Código gerado ou de terceiros.** O que, no alcance, não é editado à mão: a mudança nele vai para a origem — o gerador ou o fornecedor.

Não precifique nenhum deles — precificar é da `feasibility-analysis`.

## Passo 5 — Sobrepor a camada documentada

Cruze o alcance com o que o repositório afirma ser verdade.

- **Cobertura por casos de uso.** Quais `UC-NNN` cobrem o comportamento tocado, citados pelo elemento quando a cobertura é específica (`RN-N`, `CA-N`, passo, extensão), **cada um com seu status**. O índice do repositório escolhe quais documentos abrir (regras de consumo do use-case); uma linha do índice nunca é âncora — a cobertura cita o documento aberto. Só um documento `Reviewed` é fonte de verdade (regras de consumo do use-case, `../use-case/references/consumer-rules.md`):
  - `Reviewed` — cobertura.
  - `Reviewed` com **delta pendente** — o documento descreve o estado-alvo de uma story ainda não entregue, e o código ainda faz, nos itens do delta, o que o documento descrevia antes dele (use-case, Ciclo de vida do status). É cobertura do estado-alvo, não divergência. Registre o ID da story: é outra demanda em curso sobre o mesmo comportamento, e a ordem de implementação importa. Sem como saber se a story já foi entregue, a linha é `[INFERRED]`, com o raciocínio (o código faz o estado anterior; a entrega da story não foi confirmada), e a pergunta vai para Lacunas.
  - `Draft` — cobertura ainda não validada. Diga o que o mantém em `Draft` (marcadores pendentes, o delta de outra story aguardando promoção) e a rota: o `use-case-creator` (modo validação), ou o arquiteto, para promover.
  - `Retired` cobrindo código que ainda executa — a retirada não foi implementada, ou o código não a cumpriu. Registre-o como divergência.
  - Nenhum — comportamento tocado sem caso de uso é uma **lacuna de documentação**. Registre-a, nomeie a área e anote o `use-case-extractor` como a rota. Ela não bloqueia este mapa: o perfil de evidência e as lacunas mostram a confiança reduzida, e o mapa lista o que um caso de uso resolveria.
- **Divergência.** Comportamento do código diferente do caso de uso documentado, sem ser delta pendente, é um achado por si só — muitas vezes a linha mais valiosa do relatório: o repositório deixou de ser a fonte de verdade para aquela área (`QM-DO-1`). Registre-a citando o elemento do caso de uso e a âncora no código, e roteie-a ao `use-case-creator` (conformidade ou reconciliação). **Nunca remende um caso de uso de dentro desta skill.**
- **Incidência de ADR.** Quais ADRs `Accepted` incidem sobre as áreas tocadas. Onde a mudança pretendida parece contradizer um, declare a contradição e cite o ADR. Não a resolva: um conflito com um ADR Accepted é uma decisão, e decisões pertencem ao arquiteto e ao ciclo de vida do ADR, nunca a um mapa. Um ADR `Proposed` sobre a área também entra — é uma decisão em curso, que pode mudar o que a mudança pode fazer. Um `Superseded` não entra; o seu substituto, sim. Um `Rejected` não entra.

## Passo 6 — Delimitar o mapa e declarar a borda

O alcance é transitivo; um mapa útil não é. Pare deliberadamente e diga onde:

- Pare na **superfície de contrato** — nomeie o consumidor, não entre nele.
- Pare onde **não há dependência comportamental** — compartilhar um pacote não é alcance.
- Pare quando o próximo salto **não acrescenta nada em que uma decisão se apoie**.

Depois escreva a borda: o que deliberadamente não foi rastreado, e o que justificaria rastrear. Um mapa truncado em silêncio é pior que um sem limites — o leitor acredita que o alcance está completo. A borda declarada é o que permite à `feasibility-analysis` devolver *Undecidable with current evidence*: uma borda aquém do que um veredito exige é um dos fundamentos nomeados dessa skill para a indecidibilidade.

A borda vale na revisão registrada. Quem lê o mapa depois confere se ela ainda vale: quando os arquivos citados mudaram desde aquela revisão (`git diff <revisão>..HEAD -- <arquivos>`), as linhas deles envelheceram.

## Passo 7 — Verificar antes de entregar

Três verificações. Corrija cada falha no próprio mapa, em vez de anotá-la:

- **Âncoras.** Toda âncora foi aberta nesta execução, na revisão registrada, e a linha citada diz o que a entrada afirma. A que não sobrevive à conferência é corrigida, ou rebaixada a `[INFERRED]` ou a lacuna. Nunca mantida.
- **Proveniência.** Toda linha carrega exatamente um estado.
- **Perfil de evidência.** Conte, por grau, as linhas ancoradas, `[INFERRED]` e `[UNVERIFIED]`, e as lacunas. As contagens vão no cabeçalho: são a base de confiança do mapa, declarada como fato em vez de adjetivo.

## Saída

Um relatório de mapa de impacto — artefato de trabalho do arquiteto, não documento do repositório. Arquive-o onde a demanda vive (tracker, thread de refinamento, PRD), nunca na raiz de documentos: o repositório de casos de uso é a fonte de verdade sobre o comportamento do sistema, e nada aqui compete com ele. Ele não carrega número sequencial, não aparece em nenhuma configuração e não é mantido depois que a demanda segue adiante.

O cabeçalho é obrigatório: um mapa que não pode ser citado não pode ser consumido.

- **ID** — `IM-<demand-id>-N`. `<demand-id>` é o identificador da demanda no processo de refinamento do time; `N` distingue mapas sucessivos da mesma demanda. Derivado, nunca sequencial: o mapa tem o tempo de vida da demanda, não o do repositório.
- **Revisão** — o commit lido, as mudanças não commitadas quando houver e, com raiz de documentos paralela, a revisão dela (Passo 0). É o que torna o mapa verificável.
- **Data** — o dia da leitura.
- **Demanda** — o que foi mapeado, nos termos de quem pediu.
- **Perfil de evidência** — as contagens do Passo 7.

O corpo contém:

1. **A mudança**, reformulada como comportamento, com sua fronteira explícita.
2. **O mapa**, separado por grau — direto, acoplado, superfície de contrato —, cada entrada ancorada, localizada e justificada em uma linha, mais os dados existentes.
3. **Como o alcance foi buscado** — as sementes e as buscas do Passo 3.
4. **Contexto do projeto** — legado, sinais de criticidade, migrações em curso, código gerado ou de terceiros.
5. **A camada documentada** — cobertura por casos de uso com o status de cada um, divergências encontradas, incidência de ADR.
6. **Lacunas e questões em aberto**, cada uma com o que a resolveria.
7. **Onde o mapa para**, e por quê.

Sem veredito, sem recomendação, sem estimativa.

A passada operacional e o template do relatório vivem em `checklists/impact-map-checklist.md`. Leia-o no Passo 7, para a verificação e o relatório — não no Passo 0. A mesma forma, vista do lado de quem consome o relatório, vive em `references/consumer-rules.md`, e é de lá que todo consumidor a lê. **Mudar a forma do relatório muda os dois arquivos, no mesmo PR.**

## Consumidores

O que um consumidor lê, o que cada estado de proveniência lhe sustenta e o que ele confere antes de julgar vivem em `references/consumer-rules.md` — a fonte única desse hand-off, que nenhum consumidor repete do seu lado.

- **`feasibility-analysis`** — executa este mapa primeiro e nunca julga sem ele, citando-o por ID e revisão. A borda declarada é o que lhe permite devolver *Undecidable with current evidence* com honestidade, em vez de decidir sobre um quadro cujo fim ela não enxerga.
- **O arquiteto**, lendo-o diretamente para decidir onde olhar a seguir.

**Não é consumidor: o `its-generator`.** Um mapa tem escopo de uma *demanda* em refinamento; uma ITS, de *exatamente uma story* — e o refinamento pode durar meses entre os dois. Um mapa de escopo de demanda contraria a única disciplina daquela skill: o delta de uma story. Quando a ITS existe, verificar o mapa custa o mesmo que derivar o alcance do zero. O `its-generator` inspeciona o código ele mesmo, todas as vezes, e nenhum plano herda alcance que não verificou.

**Divergências encontradas aqui vão para as skills de caso de uso, nunca para uma ITS.** Uma divergência código × caso de uso é resolvida pelo `use-case-creator` (conformidade ou reconciliação) e uma lacuna de documentação pelo `use-case-extractor`, antes da especificação. Nenhuma das duas é carregada adiante para dentro de um plano de implementação.

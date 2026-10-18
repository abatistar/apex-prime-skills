---
name: feasibility-analysis
description: Julga uma demanda contra o sistema que teria de absorvê-la, antes de existir qualquer especificação - produzindo achados classificados e exatamente um veredito. Skill da camada do arquiteto, invocada, nunca um gate obrigatório. Sempre executa o impact-mapping primeiro e julga sobre esse mapa. Use quando o arquiteto trouxer uma story, PRD, épico ou proposta informal e perguntar se é possível fazer, o que quebraria ou o que está no caminho - "isso é factível", "conseguimos absorver isto", "o que bloqueia esta story", "o product owner quer X, o que quebra". NÃO use para mapear o alcance sem julgá-lo (impact-mapping), para estimar esforço ou duração (custo é evidência, não critério), para escrever casos de uso (use-case-creator, use-case-extractor), para planejar uma mudança aprovada (its-generator), para julgar uma implementação (code-review) nem para escrever código de aplicação (camada do dev).
---

# Feasibility Analysis (prime-architect)

O `code-review` julga **código contra um plano, depois**. Esta skill julga **uma demanda contra o sistema, antes** — mesmo formato, extremo oposto do pipeline. Ambos transformam critérios versionados em achados classificados e exatamente um veredito; nenhum escreve o artefato que julga.

Ela existe porque o resto do processo presume que a demanda será construída. O `use-case-creator` elicita, o `its-generator` planeja, e a impossibilidade só aparece depois que os dois já foram pagos. Esta skill é o lugar barato para descobrir.

Ela é **invocada, nunca obrigatória**. Nada adiante exige um veredito de viabilidade, e um veredito nunca autoriza pular o pipeline de especificação: *Viable* significa que a demanda pode entrar no refinamento, não que está especificada.

## Evidência e julgamento são atos separados

Esta skill não deriva alcance. O `impact-mapping` produz a evidência — o que a demanda toca, em qual estado registrado, contra qual comportamento documentado — e esta skill decide sobre ela. A divisão é deliberada e é a mesma que o repositório já traça entre o `prime-core/quality-model` e o `prime-architect/code-review`: definir e julgar falham de modos diferentes, e uma skill que produz sua própria evidência e depois decide sobre ela não tem ninguém conferindo a primeira metade.

Na prática: **referencie o mapa, nunca o repita.** O relatório cita o mapa; não copia a superfície para dentro de si.

## O que esta skill não faz

- **Não estima esforço.** Sem horas, sem story points, sem contagem de sprints. Dimensionar pertence ao time que fará o trabalho. O que esta skill entrega são os **direcionadores de custo** — os fatos com que uma estimativa é construída — lidos do mapa.
- **Não projeta a solução.** Nomear um caminho viável faz parte do raciocínio do veredito; especificá-lo é trabalho do `its-generator`, e só depois que os casos de uso existirem.
- **Não decide se a demanda vale a pena.** Valor é decisão de quem demanda. Esta skill responde *pode ser absorvida, a que custo estrutural, e o que precisa ser verdade antes*. Das cinco dimensões clássicas de um estudo de viabilidade — técnica, econômica, legal, operacional e de prazo —, ela julga a técnica, a legal e a operacional; a econômica e a de prazo pertencem a quem demanda e ao time.

## Passo 0 — Carregar a configuração e os critérios

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, tratamento de divergências e bootstrap vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa:

- a **stack** e as versões — o teto sob o qual todo caminho proposto precisa caber;
- a seção **Convenções e restrições** por inteiro: a release fixada do Apex Prime, o registro de áreas, os overrides de slots, as migrações declaradas (responsável, escopo e módulo substituto de cada uma), a postura do modelo de qualidade e as **regras do projeto** — áreas proibidas, restrições operacionais e de compliance, janelas de deploy —, que são a entrada direta da lente Restrição;
- os **Responsáveis** — de onde vem o responsável de cada `Condition:` (Passo 5);
- o **Tracker** — o formato do item de backlog com que os follow-ups são redigidos;
- as localizações de documentos, incluindo o repositório de ADRs, e os comandos de verificação.

Em seguida carregue, como os critérios em que o julgamento se ancora: o **prime-core/quality-model** (`QM-XX-N`) com `references/quality-triggers.md` — os gatilhos que a lente de mesmo nome percorre —, o **prime-core/coding-standards** (`CS-XX-N`) e os **ADRs** `Accepted` e `Proposed`.

**Custo é evidência, nunca um critério.** O modelo de qualidade responde *o que é bom*, não *quanto isto custa*; não o estique até virar um vocabulário de custo que ele não possui. Onde a confrontação precisa de um critério que não existe — um slot de convenção sem padrão da stack nem override do projeto — **reporte a lacuna** conforme o `coding-standards` e nunca improvise o valor. Um critério de que a confrontação precisou e que o catálogo não tem vira follow-up ao dono do modelo de qualidade em toda execução que o encontrar (Passo 7): quem agrega as ocorrências e decide o PR de governança é ele, não esta skill.

## Passo 1 — Reformular a demanda como algo verificável

Execute o Passo 1 do `impact-mapping` — o resultado observável que a demanda afirma, em uma ou duas frases, e a fronteira do que ela **não** afirma — e confirme a reformulação com o arquiteto. A regra vive lá e não se repete aqui; a fronteira declarada neste passo é o que impede a análise de se expandir numa revisão do sistema inteiro.

Uma demanda que não se reduz a uma mudança observável no comportamento do sistema — que nomeia uma tecnologia, uma preferência ou uma aspiração em vez de um resultado — termina em **`Insufficient input`**: pare, devolva as perguntas e não emita veredito. Não há nada a julgar, e julgá-la mesmo assim é como esta skill degeneraria em opinião.

**Uma demanda, um projeto.** Uma demanda cujo resultado exige mudança em outro projeto é quebrada por projeto antes de ser julgada (prime-core/prime-config): esta execução julga a parte que cabe a este projeto. A parte do outro entra pela lente de contrato — o outro serviço como consumidor ou fornecedor — e, quando o resultado daqui depende dela, como uma `Condition:` roteada à demanda correspondente naquele projeto. Uma demanda cujo resultado vive quase todo fora deste projeto é devolvida para ser quebrada, sem veredito.

## Passo 2 — Executar o mapa

Execute o `impact-mapping` sobre a demanda **como reformulada no Passo 1** — essa reformulação é a linha de assunto do mapa, e o Passo 1 do próprio mapa não é reexecutado. O que esta skill consome dele:

- os **três graus** de alcance — direto, acoplado, superfície de contrato — e os **dados existentes**;
- a sobreposição de **estados de área** (`current`, `legacy-maintained`, `strangler`) e de **níveis de criticidade** (`efêmera`, `padrão`, `crítica`), com o substituto de cada área `strangler` e as regras do projeto que alcançam as áreas;
- a **camada documentada** — cobertura por casos de uso com o status de cada um, divergências encontradas, ADRs `Accepted` e `Proposed`;
- a **marcação de proveniência** em cada linha (ancorada, `[INFERRED]`, `[UNVERIFIED]`, lacuna), cujo vocabulário é definido por aquela skill e reutilizado aqui sem alteração;
- o **perfil de evidência** e **como o alcance foi buscado** — quanto foi lido, quanto foi deduzido e que tipo de omissão é plausível;
- e, decisivamente, a **borda declarada** — onde o mapa deliberadamente parou.

A borda é o que faz de *Undecidable* um veredito honesto em vez de uma evasiva. Decidir sobre um mapa que truncou o próprio alcance em silêncio produz um veredito confiante sobre um quadro parcial, que é a pior saída que esta skill pode produzir.

**O mapa é citado por ID e revisão.** Um mapa trazido pronto, de uma execução avulsa anterior, só é usado se ainda vale: quando os arquivos que ele cita mudaram desde a revisão que ele registra (`git diff <revisão>..HEAD -- <arquivos>`), refaça o mapa — ou ao menos as linhas desses arquivos — antes de julgar. Julgar sobre um mapa envelhecido é julgar um sistema que já não existe.

Um mapa avulso trazido pronto que parou em `Insufficient input` encerra esta execução do mesmo modo que o Passo 1: perguntas devolvidas, nenhum veredito.

### A baseline de cada área

Antes de qualquer lente rodar, classifique a baseline de cada área tocada — o comportamento documentado contra o qual a demanda é julgada —, porque ela muda o que um veredito pode significar:

- **documentada** — coberta por casos de uso `Reviewed`, sem divergência com o código. Um delta pendente que o mapa registrou não é divergência (prime-architect/use-case, Ciclo de vida do status): a demanda é julgada sobre o estado-alvo da story em curso, que entra como `Condition:` quando o resultado daqui depende da ordem de implementação — rota: a story em curso, responsável o arquiteto responsável — e como `FYI:` quando só convive com ela;
- **parcial** — sem caso de uso, coberta só por um documento `Draft`, coberta por um `Retired` que o código ainda executa, ou com divergência código × caso de uso. Onde código e documento discordam, **nenhum dos dois é um baseline seguro**, e um veredito apoiado no errado se dissolve ao primeiro contato;
- **green-field** — adição que não toca nenhum comportamento existente; dispensa baseline.

Toda baseline parcial segue uma regra só:

- **Em outro ponto** → uma `Condition:` com responsável e rota: o `use-case-extractor` para a área sem caso de uso; o `use-case-creator` para o `Draft` (modo validação) e para a divergência (conformidade ou reconciliação); o arquiteto para o `Retired` que o código ainda executa. Uma lacuna conhecida com rota conhecida é exatamente para o que serve uma condição.
- **Onde o veredito se apoia** — a área que carrega a restrição mais dura da demanda, onde um `Blocker:` se apoiaria → *Undecidable with current evidence*, nomeando a execução que decidiria. A ausência de um blocker carrega o mesmo ônus de evidência que um blocker: *Viable with conditions* afirma que nada bloqueia, e afirmar isso sobre comportamento que ninguém descreveu, ou descreveu de dois jeitos, é a falha que esta skill existe para prevenir. A escolha é declarada e justificada no relatório, nunca presumida em silêncio.

## Passo 3 — As lentes, em ordem decrescente do que mata uma demanda

Cada lente aponta para onde seu critério vive — nunca o redefine. Rode-as sobre o mapa; não reande o código que o mapa já andou. A intensidade segue o nível de criticidade de cada área tocada.

- **Restrição** — os tetos rígidos: stack e versão (configuração), plataforma, dados que não existem, uma dependência externa ou licença que o projeto não possui, uma fronteira regulatória e as **regras do projeto** que alcançam as áreas tocadas — uma área proibida, uma restrição de compliance ou de residência de dados, uma janela de deploy. Uma exclusão gerada a partir do contrato de um terceiro muda na origem, que o projeto pode não controlar. Esta lente produz os únicos achados que tornam algo genuinamente impossível, razão pela qual é lida primeiro e costuma ser a mais curta.
- **Encaixe estrutural** — a demanda briga com a forma do sistema? `QM-CC-1..7`, `CS-AR-1..5` e a incidência de ADR trazida do mapa.
  - Uma regra de negócio que o mapa encontrou replicada (`QM-CC-6`) é um `Cost driver:` — a mudança vai unificá-la ou alterar todas as cópias.
  - Numa área `strangler`, comportamento novo nasce no módulo substituto que o registro nomeia, e o caminho viável é julgado ali. Se o substituto ainda não comporta a demanda, isso é uma `Condition:` de responsabilidade do dono da migração.
  - **Uma demanda que contradiz um ADR Accepted não é inviável** — é uma questão de ADR. Ela vira uma `Condition:` nomeando o ADR, de responsabilidade do arquiteto e roteada ao ciclo de vida do ADR: a decisão precisa ser revisitada antes de a demanda entrar em especificação. Uma demanda que depende de uma decisão ainda `Proposed` recebe a mesma `Condition:`: a decisão é tomada antes da especificação. Esta skill não redige o ADR. Redigir exige uma Decisão, e esta skill não projeta nada — ela julga. O registro é arquivado pelo fluxo que o its-contract define: pelo arquiteto diretamente nesta etapa, em que ainda não existe plano, ou pelo its-generator quando um plano precisar se comprometer com ele. Nunca trate uma decisão registrada como um muro, e nunca deixe uma ser derrubada em silêncio dentro de uma análise.
- **Superfície de contrato** — de tudo que o mapa colocou fora desta base de código (formatos de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas compartilhadas, telemetria consumida fora), todo consumidor conhecido pode ser migrado sem quebra silenciosa (`QM-CC-7`, `CS-CT-1`, gatilho G2), e o conjunto de consumidores pode ser enumerado? Um conjunto de consumidores não enumerável é um achado por si só. Um consumidor noutro projeto é migrado pela demanda daquele projeto: uma `Condition:` roteada a ela (Passo 1).
- **Entrega e reversibilidade** — a mudança pode ser entregue em etapas e revertida? Uma mudança incompatível de contrato ou de esquema convive com a versão em produção por expansão, migração e contração (`QM-CC-7`, `CS-CT-1`; uma migração já aplicada nunca é editada, `CS-DA-4`); os dados existentes que o mapa trouxe têm caminho de migração ou de preenchimento; o comportamento novo pode sair atrás de uma flag com condição de remoção (`CS-EV-1`) quando o projeto ou o risco o pedem; as janelas e restrições de deploy das regras do projeto comportam a entrega. Sem caminho que conviva com a versão em produção, a entrega coordenada ou a indisponibilidade é uma `Condition:` — uma decisão com responsável —, e só um `Blocker:` quando uma regra do projeto, ancorada, proíbe o único caminho.
- **Gatilhos de especificação** — passe a demanda pelos gatilhos do `references/quality-triggers.md`: são as decisões de qualidade que a ITS vai precisar tomar, e este é o ponto barato de descobrir as que ninguém consegue tomar. Para cada gatilho disparado:
  - a decisão depende de um slot sem valor — nem padrão da stack nem override → `Condition:` de lacuna de slot, roteada à configuração (`coding-standards`, Slots não preenchidos);
  - a decisão vale além da story — o primeiro outbox do sistema, a política de idempotência de todos os consumidores → `Condition:` de ADR a levantar, responsável o arquiteto;
  - dependência de terceiros nova (G13) → `Condition:` de admissão (`CS-DP-1`; `CS-DP-2` quando já existe biblioteca sancionada para a mesma preocupação), responsável o arquiteto responsável;
  - operação sensível (G14), entrada externa nova com regra de acesso (G1) ou qualquer área `crítica` tocada → a fronteira de segurança (`QM-SR-*`, `CS-SC-*`, em especial o controle de acesso, `QM-SR-8`, e o dado protegido, `QM-SR-10`, `CS-SC-6`) é uma `Condition:` com o responsável de segurança — uma fronteira aberta não bloqueia por existir;
  - código sem testes no conjunto direto (G11) e estrutura que só comporta a mudança distorcida (G12) → `Cost driver:` — a caracterização e a refatoração preparatória entram no tamanho;
  - chamada externa (G3), falha parcial (G4), repetição (G5), concorrência (G6) e volume (G8) → `Cost driver:` quando o sistema já tem o mecanismo e o slot dá o valor; quando não, caem num dos casos acima.

  Não fabrique gatilhos que a demanda não dispara.
- **Verificação** — o resultado afirmado pode ser provado como entregue? Os comandos de verificação da configuração, a observabilidade que as áreas afetadas realmente têm (`QM-EO-7`) e a obrigação de teste que a mudança carregaria (`CS-TS-1`). Uma meta não funcional sem forma de ser medida (G10, `QM-EF-2`) — e, em geral, uma demanda que ninguém consegue verificar como entregue — é viável apenas sob a condição de que se construa uma forma de verificá-la.
- **Risco de erosão** — o caminho viável mais barato introduz uma *segunda* forma de fazer algo que o projeto já faz de uma só (`QM-CN-1`), ou aumenta a contagem de uma migração declarada em curso? Responder sim não bloqueia; nomeia a dívida que a demanda criaria, para que possa ser assumida deliberadamente (`QM-MT-1`) em vez de descoberta depois na revisão.

**Cobertura das lentes.** Toda lente termina num de três resultados, e o relatório registra qual: os achados que produziu; *examinada, nada encontrado*, com o que foi examinado em uma linha; ou *não se aplica*, com a razão. "Nada encontrado" e "não examinada" são fatos diferentes, e só o primeiro sustenta um *Viable* — é o não-risco que uma avaliação de arquitetura também registra. É também o que mantém a análise proporcional: numa demanda pequena, a maioria das lentes cabe numa linha.

## Passo 4 — Disciplina de evidência

Todo achado herda sua âncora do mapa e a carrega de forma visível. O vocabulário é o do `impact-mapping`; esta skill acrescenta duas regras próprias.

**Um `Blocker:` exige evidência ancorada.** Um blocker apoiado em evidência `[INFERRED]` ou `[UNVERIFIED]` não é um blocker — é o motivo pelo qual o veredito é *Undecidable with current evidence*. Qualquer coisa afirmada pela demanda e nunca conferida contra o código permanece `[UNVERIFIED]`, por mais plausível que soe.

**Um `Blocker:` sobrevive à refutação.** Antes de classificá-lo, tente derrubá-lo: existe outro caminho que entrega o mesmo resultado observável — outro módulo, outra forma de integração, outra sequência de entrega? O teto é rígido, ou é um valor de configuração ou um override que o projeto pode mudar? A regra do projeto alcança mesmo esta área? A âncora diz o que o achado afirma? O blocker que não sobrevive cai — vira `Condition:` ou deixa de existir. O que a tentativa não consegue confirmar nem derrubar é tratado como evidência não ancorada (Passo 6, regra 2). É a mesma disciplina que o `code-review` aplica a um `Blocking:`.

## Passo 5 — Classificar cada achado

Um achado declara **onde**, **o quê**, **por quê** — citando um ID ou uma âncora de evidência — e **o que implica para a demanda**.

- **`Blocker:`** — a demanda não pode ser absorvida como especificada. Uma restrição rígida, ou um resultado que contradiz um invariante sem caminho para contornar. Exige evidência ancorada que sobreviveu à refutação.
- **`Condition:`** — viável, mas só se algo for verdade antes. Toda condição carrega um **responsável** e uma **rota** (uma skill a executar, uma decisão a tomar, uma dependência a adquirir). O responsável vem dos Responsáveis da configuração: o arquiteto responsável por padrão; o responsável de segurança na fronteira de segurança; o responsável da migração numa área `strangler`; o arquiteto responsável do outro projeto numa dependência entre projetos. Um papel sem nome é escrito "não declarado ainda", e a lacuna vira follow-up (Passo 7). Uma condição sem rota é um `Blocker:` disfarçado.
- **`Cost driver:`** — não bloqueia e não condiciona; muda o tamanho. Estado da área, amplitude do conjunto acoplado, superfícies de contrato cruzadas, dados existentes a migrar, código sem testes, estrutura que não comporta a mudança, regra de negócio replicada, observabilidade ausente, dívida que o caminho criaria.
- **`FYI:`** — contexto que quem demanda deveria ter. Sem obrigação.

Agregação: vários achados causados por um único fato estrutural são um achado, declarado onde ele pode realmente ser endereçado.

## Passo 6 — O veredito, exatamente um

O veredito não é lido apenas dos achados. Ele se resolve a partir de duas entradas — os achados classificados no Passo 5 e o **estado da base de evidência** trazido do mapa —, aplicadas nesta ordem, vale a primeira que casar:

1. **Existe um `Blocker:` ancorado** → *Not viable as specified*. Um blocker ancorado é
   autossuficiente: lacunas em outros pontos da evidência não o suavizam, porque nada que ainda
   falte descobrir o dissolve — só uma mudança na demanda. Registre as lacunas como
   follow-ups e decida.
2. **Nenhum blocker ancorado, e a base de evidência não sustenta afirmar que nenhum existe**
   → *Undecidable with current evidence*. Um blocker apoiado em evidência `[INFERRED]` ou
   `[UNVERIFIED]`, ou que a refutação não confirmou nem derrubou, cai aqui, não na regra 1 (Passo 4).
3. **Caso contrário, pelo menos uma `Condition:`** → *Viable with conditions*.
4. **Caso contrário** → *Viable*.

`Cost driver:` e `FYI:` nunca movem o veredito. Não existe veredito *"viável mas caro"* —
tamanho é evidência entregue a quem decide, nunca um julgamento.

### Quando a base de evidência é insuficiente

A regra 2 dispara quando, e somente quando, uma destas condições se verifica:

- um **`Blocker:` candidato** se apoia em evidência `[INFERRED]` ou `[UNVERIFIED]`, ou a refutação não
  conseguiu confirmá-lo nem derrubá-lo (Passo 4);
- a **borda** do mapa para aquém do que o veredito exige;
- a **baseline é parcial onde o veredito se apoia** (Passo 2) — sem caso de uso, só `Draft`, `Retired`
  ainda executado ou com divergência; parcial em outro ponto é uma `Condition:`, não uma indecidibilidade;
- uma **dependência em que o resultado se apoia** nunca foi testada.

Esta lista é fechada. Uma execução que encontre um quinto caso legítimo o adiciona aqui por PR, com a
execução que o encontrou nomeada — nunca ampliando a regra localmente. É a mesma disciplina que o
`coding-standards` aplica a um slot não preenchido: a lacuna é reportada, não improvisada.

### O que cada veredito obriga você a entregar

- **Viable** — a demanda pode entrar no pipeline de especificação como escrita.
- **Viable with conditions** — toda condição nomeada, com responsável e rota. É o veredito comum
  e não é um hedge: é a lista do que fazer primeiro.
- **Not viable as specified** — blockers listados separadamente. Nunca entregue como uma recusa seca:
  declare **o que teria de mudar na demanda** para que o blocker se dissolva. Uma demanda
  devolvida sem uma porta é um obstáculo, não um gate.
- **Undecidable with current evidence** — nomeie a **única execução que decidiria** (extractor
  na área X, um spike com tempo limitado em Y, uma medição de Z) e o que a torna decisiva: a pergunta
  que ela responde, quem a executa e o veredito a que cada resultado leva — "p99 ≤ 300 ms → *Viable with
  conditions*; acima → *Not viable as specified*". Uma execução cujo resultado ninguém sabe ler não decide
  nada. Feita a execução, a análise roda de novo (`FA-<demand-id>-2`) sobre um mapa novo (`IM-<demand-id>-2`). Este veredito é
  um resultado, não uma falha — um veredito inventado custa mais que uma lacuna honesta.

**Em todo veredito, as premissas.** Liste as linhas não ancoradas — `[INFERRED]` e `[UNVERIFIED]` — de que
o veredito depende sem que sejam blockers, cada uma com o que mudaria se fosse falsa. São os pontos de
sensibilidade da análise: quem lê sabe o que conferir primeiro e o que reabriria o veredito. Sem premissas
desse tipo, escreva "nenhuma".

Nunca entregue um veredito sobre uma demanda que você não entendeu. "Provavelmente está bem" não é um veredito.

## Passo 7 — Follow-ups, por destino

Cada follow-up é redigido para o destino que o resolve. Esta skill não executa nenhum deles nem os registra no tracker.

- **Às skills de caso de uso** — a execução do extractor que estabelece um baseline; a validação de um `Draft` e a divergência (`QM-DO-1`), ao use-case-creator. Nunca remendadas de dentro desta skill.
- **Ao arquiteto** — a **decisão de ADR a levantar**: um ADR Accepted que a demanda desafia ou substituiria, ou uma decisão `Proposed` de que ela depende, levantada como uma `Condition:` com o arquiteto como responsável. O ADR em si é redigido pelo fluxo do its-contract, pelo arquiteto diretamente nesta etapa ou pelo its-generator quando um plano precisar se comprometer com ele, nunca aqui. Também o caso de uso `Retired` que o código ainda executa.
- **À configuração** — o slot não preenchido (`coding-standards`), o papel de Responsáveis sem nome e todo fato sobre o projeto de que a análise precisou e que o `docs/prime-config.md` não carrega. Nunca improvisados.
- **Ao outro projeto** — a demanda correspondente, quando o resultado daqui depende de mudança lá.
- **Ao backlog** — a dívida que o caminho viável criaria, com um responsável prospectivo (`QM-MT-1`), redigida como item no formato que o Tracker declara, para o arquiteto registrar.
- **Ao dono do modelo de qualidade** — o critério de que a confrontação precisou e que o catálogo não tem. Quem agrega as ocorrências entre execuções é ele.

## Saída

Um relatório de viabilidade — um artefato de trabalho do arquiteto dentro do refinamento do time, não um
documento do repositório. É arquivado onde a demanda vive (tracker, thread do PRD), nunca na
raiz de documentos, e não aparece em nenhuma configuração. Cabeçalho pela mesma regra do mapa: `FA-<demand-id>-N`,
a data, a demanda e o mapa em que se apoia, por ID e revisão.

Contém a demanda reformulada e sua fronteira, **a referência ao mapa de impacto — por ID e revisão**, a
baseline de cada área tocada, os achados, a cobertura das lentes, as premissas do veredito, o veredito com
sua razão de uma linha e os follow-ups por destino. Uma referência a um mapa sem a sua revisão não é uma
referência: a regra 2 do Passo 6 depende de onde aquele mapa específico parou, e só a revisão diz se a sua
borda ainda vale. A passada operacional e o template do relatório vivem em `checklists/feasibility-checklist.md`.

Nem este relatório nem o mapa que ele cita são obrigatórios para que uma demanda exista ou avance. O
time é dono da demanda; são ferramentas que o arquiteto usa dentro desse processo.

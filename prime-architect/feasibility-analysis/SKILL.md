---
name: feasibility-analysis
description: Julga se uma demanda pode ser absorvida pelo sistema, antes de qualquer especificação - executa o impact-mapping e emite achados classificados e exatamente um veredito. Use quando o arquiteto trouxer uma story, PRD, épico ou proposta e perguntar "isso é factível", "o que bloqueia esta story", "o product owner quer X, o que quebra". NÃO use para só mapear o alcance (impact-mapping), para estimar esforço nem para planejar uma mudança aprovada (its-generator).
---

# Feasibility Analysis

O `code-review` julga **código contra um plano, depois**. Esta skill julga **uma demanda contra o sistema, antes** — mesmo formato, extremo oposto do pipeline. Ambos transformam critérios versionados em achados classificados e exatamente um veredito; nenhum escreve o artefato que julga.

Ela existe porque o resto do processo presume que a demanda será construída. O `use-case-creator` elicita, o `its-generator` planeja, e a impossibilidade só aparece depois que os dois já foram pagos. Esta skill é o lugar barato para descobrir.

Ela é **invocada, nunca obrigatória**. Nada adiante exige um veredito de viabilidade, e um veredito nunca autoriza pular o pipeline de especificação: *Viable* significa que a demanda pode entrar no refinamento, não que está especificada.

## Evidência e julgamento são atos separados

Esta skill não deriva alcance. O `impact-mapping` produz a evidência — o que a demanda toca, em qual contexto do projeto, contra qual comportamento documentado — e esta skill decide sobre ela. A divisão é a mesma que o repositório traça entre o `quality-model` e o `code-review`: definir e julgar falham de modos diferentes, e uma skill que produz a própria evidência e depois decide sobre ela não tem ninguém conferindo a primeira metade.

**Referencie o mapa, nunca o repita:** o relatório cita o mapa, não copia a superfície para dentro de si.

## O que esta skill não faz

- **Não estima esforço.** Sem horas, sem story points, sem contagem de sprints. Dimensionar pertence ao time que fará o trabalho. O que esta skill entrega são os **direcionadores de custo** — os fatos com que uma estimativa é construída — lidos do mapa.
- **Não projeta a solução.** Nomear um caminho viável faz parte do raciocínio do veredito; especificá-lo é trabalho do `its-generator`, e só depois que os casos de uso existirem.
- **Não decide se a demanda vale a pena.** Valor é decisão de quem demanda. Esta skill responde *pode ser absorvida, a que custo estrutural, e o que precisa ser verdade antes*. Das cinco dimensões clássicas de um estudo de viabilidade — técnica, econômica, legal, operacional e de prazo —, ela julga a técnica, a legal e a operacional; a econômica e a de prazo pertencem a quem demanda e ao time.

## Passo 0 — Carregar os critérios

A configuração do projeto não é lida aqui. Cada fato dela é lido quando uma lente precisa dele, e só a seção que o carrega, conforme as regras de consumo do **prime-config** (`../prime-config/references/consumer-rules.md`):

- **Stack** — o teto de linguagem, framework e versões sob o qual todo caminho proposto precisa caber (lente Restrição);
- **Comandos de verificação** — o que o projeto sabe verificar (lente Verificação);
- **Repositório de documentos** — onde vivem os ADRs.

**O contexto do projeto não é relido aqui.** Se o projeto é legado, os sinais de criticidade, as migrações em curso e o código gerado ou de terceiros chegam pela sobreposição do mapa, que já diz o que a demanda toca (Passo 2). As restrições que não estão no código nem nos documentos chegam pela pergunta ao arquiteto, depois do mapa (Passo 2).

Carregue, como os critérios em que o julgamento se ancora: as regras de consumo do **quality-model** (`../quality-model/references/consumer-rules.md`) com `../quality-model/references/quality-triggers.md` — os gatilhos que a lente de mesmo nome percorre —, as regras de consumo do **coding-standards** (`../coding-standards/references/consumer-rules.md`) e os **ADRs** `Accepted` e `Proposed`.

Os catálogos desses contratos não são carregados inteiros. Quando uma lente aplica um ID, leia no catálogo do dono o índice e o arquivo da lente ou família daquele ID. Para `QM-XX-N`: `../quality-model/references/quality-criteria/XX.md`. Para `CS-XX-N`: `../coding-standards/references/convention-slots/XX.md` e, quando a lente precisa do valor do slot, o arquivo de mesmo nome nos padrões da stack. Os slots que servem a um critério — os que um gatilho alcança — estão no mapa Critério → slots do índice `../coding-standards/references/convention-slots.md`.

**Custo é evidência, nunca um critério.** O modelo de qualidade responde *o que é bom*, não *quanto isto custa*; não o estique até virar um vocabulário de custo que ele não possui. Onde a confrontação precisa de um critério que não existe — um slot de convenção sem padrão da stack nem ADR `Accepted` do projeto — **reporte a lacuna** conforme o `coding-standards` e nunca improvise o valor. Um critério de que a confrontação precisou e que o catálogo não tem vira follow-up ao dono do modelo de qualidade (Passo 7), em toda execução que o encontrar. Agregar as ocorrências e decidir o PR de governança é dele, não desta skill.

## Passo 1 — Reformular a demanda como algo verificável

Execute a reformulação do `impact-mapping` (`../impact-mapping/references/reformulation.md`) — o resultado observável que a demanda afirma, em uma ou duas frases, e a fronteira do que ela **não** afirma — e confirme a reformulação com o arquiteto, inclusive a escolha entre leituras concorrentes da entrada. A regra vive lá e não se repete aqui; a fronteira declarada neste passo é o que impede a análise de se expandir numa revisão do sistema inteiro.

Uma demanda que não se reduz a uma mudança observável no comportamento do sistema — que nomeia uma tecnologia, uma preferência ou uma aspiração em vez de um resultado — termina em **`Insufficient input`**: pare, devolva as perguntas e não emita veredito. Não há nada a julgar, e julgá-la mesmo assim é como esta skill degeneraria em opinião.

**Uma demanda, um projeto.** Uma demanda cujo resultado exige mudança em outro projeto é quebrada por projeto antes de ser julgada (prime-config): esta execução julga a parte que cabe a este projeto. A parte do outro entra pela lente de contrato, como consumidor ou fornecedor. Quando o resultado daqui depende dela, entra também como uma `Condition:` roteada à demanda correspondente naquele projeto. Uma demanda cujo resultado vive quase todo fora deste projeto é devolvida para ser quebrada, sem veredito.

## Passo 2 — Executar o mapa

Execute o `impact-mapping` sobre a demanda **como reformulada no Passo 1** — essa reformulação é a linha de assunto do mapa, e o Passo 1 do próprio mapa não é reexecutado. Passe nos argumentos da invocação a reformulação e a fronteira declarada: o mapa pode rodar isolado, sem ver esta conversa.

**O que o mapa entrega, o que cada estado de proveniência sustenta e o que conferir antes de julgar vivem em um lugar só:** as regras de consumo do mapa (`../impact-mapping/references/consumer-rules.md`). Leia-as aqui. Esta skill não repete essa lista do seu lado — duas cópias de um hand-off divergem, e a que divergir primeiro será a de quem julga.

Duas regras valem só para quem emite veredito. A **borda** é o que faz de *Undecidable* um veredito honesto em vez de evasiva: um veredito confiante sobre um quadro parcial é a pior saída desta skill. E um mapa avulso que parou em `Insufficient input` encerra esta execução como o Passo 1 — perguntas devolvidas, nenhum veredito, e nenhum *Undecidable*, porque nada foi julgado.

### A baseline de cada área

Antes de qualquer lente rodar, classifique a baseline de cada área tocada — o comportamento documentado contra o qual a demanda é julgada —, porque ela muda o que um veredito pode significar:

- **documentada** — coberta por casos de uso `Reviewed`, sem divergência com o código. Um delta pendente que o mapa registrou não é divergência (use-case, Ciclo de vida do status): julgue a demanda sobre o estado-alvo da story em curso. Essa story entra como `Condition:` quando o resultado daqui depende da ordem de implementação — rota: a própria story, responsável o arquiteto responsável. Quando apenas convive com ela, entra como `FYI:`;
- **parcial** — sem caso de uso, coberta só por um documento `Draft`, coberta por um `Retired` que o código ainda executa, ou com divergência código × caso de uso. Onde código e documento discordam, **nenhum dos dois é um baseline seguro**, e um veredito apoiado no errado se dissolve ao primeiro contato;
- **green-field** — adição que não toca nenhum comportamento existente; dispensa baseline.

Toda baseline parcial segue uma regra só:

- **Em outro ponto** → uma `Condition:` com responsável e rota: o `use-case-extractor` para a área sem caso de uso; o `use-case-creator` para o `Draft` (modo validação) e para a divergência (conformidade ou reconciliação); o arquiteto para o `Retired` que o código ainda executa. Uma lacuna conhecida com rota conhecida é exatamente para o que serve uma condição.
- **Onde o veredito se apoia** — a área que carrega a restrição mais dura da demanda, onde um `Blocker:` se apoiaria → *Undecidable with current evidence*, nomeando a execução que decidiria. A ausência de um blocker carrega o mesmo ônus de evidência que um blocker: *Viable with conditions* afirma que nada bloqueia, e ninguém afirma isso sobre comportamento que nenhum documento descreve, ou que dois descrevem de jeitos diferentes. Declare e justifique a escolha no relatório, nunca a presuma.

### As restrições que só o arquiteto conhece

Algumas restrições que tornam uma demanda inviável não estão no código nem nos documentos: só o arquiteto as conhece. Com o mapa lido, e antes das lentes, pergunte por elas — uma parada só, numa mensagem só.

- **A pergunta é dirigida pelo mapa.** Nomeie o que a demanda toca e pergunte se há restrição externa sobre isso que o código não mostra: "a demanda toca dado pessoal e a integração com o adquirente; há restrição regulatória, contratual ou de licença sobre isso?". Uma pergunta genérica recebe um "não" por reflexo.
- **O escopo é fechado: só o que limita o que pode ser construído.** Regulação ou contrato que proíbe um caminho; dependência externa ou licença que o projeto não tem nem pode ter; dado que não existe ou não pode ser usado; limite da plataforma. Prazo, esforço, janela de deploy e processo de aprovação não entram: não mudam o que o código pode vir a ser.
- **"Nenhuma" é resposta, e fica registrada.** O relatório distingue *perguntado, nada declarado* de *não perguntado*.
- **Não pergunte** quando o pedido já trouxe as restrições, nem quando o mapa não toca nada que as atraia — uma mudança de rótulo, um ajuste de validação. Diga no relatório por que não perguntou.

O que o arquiteto responde entra como **restrição declarada** (Passo 4) e alimenta a lente Restrição.

## Passo 3 — As lentes, em ordem decrescente do que mata uma demanda

Cada lente aponta para onde seu critério vive — nunca o redefine. Rode-as sobre o mapa; não reande o código que o mapa já andou. A intensidade segue os sinais de criticidade que o mapa trouxe: uma demanda com sinal de `crítica` é julgada com tudo o que cada lente lista. O nível em si é declarado adiante, na ITS.

- **Restrição** — os tetos rígidos: stack e versão (configuração), plataforma, dados que não existem, uma dependência externa ou licença que o projeto não possui, o que um ADR `Accepted` proíbe e as restrições que o arquiteto declarou (Passo 2) — uma fronteira regulatória ou contratual, um dado que não pode ser usado. Código gerado a partir do contrato de um terceiro muda na origem, que o projeto pode não controlar. Só esta lente produz achados que tornam algo genuinamente impossível. Por isso é lida primeiro, e costuma ser a mais curta.
- **Encaixe estrutural** — a demanda briga com a forma do sistema? `QM-CC-1..7`, `CS-AR-1..5` e a incidência de ADR trazida do mapa.
  - Uma regra de negócio que o mapa encontrou replicada (`QM-CC-6`) é um `Cost driver:` — a mudança vai unificá-la ou alterar todas as cópias.
  - Num projeto legado, o caminho viável é julgado contra a arquitetura que o código tem, não contra a do time. Quando o alcance está no escopo de uma migração em curso, o caminho segue o valor de destino dela; se a migração ainda não comporta a demanda, isso é uma `Condition:` de responsabilidade do responsável que o ADR da migração nomeia.
  - **Uma demanda que contradiz um ADR Accepted não é inviável** — é uma questão de ADR. Ela vira uma `Condition:` nomeando o ADR, de responsabilidade do arquiteto e roteada ao ciclo de vida do ADR: a decisão é revisitada antes da especificação. Uma demanda que depende de uma decisão ainda `Proposed` recebe a mesma `Condition:`. Esta skill não redige o ADR — redigir exige uma Decisão, e esta skill julga, não projeta. O registro é redigido pelo adr-generator, por palavra do arquiteto (adr-contract, Quem detecta, quem redige, quem aprova). Nunca trate uma decisão registrada como um muro, e nunca deixe uma cair em silêncio dentro de uma análise.
- **Superfície de contrato** — de tudo que o mapa pôs neste grau, todo consumidor conhecido pode ser migrado sem quebra silenciosa (`QM-CC-7`, `CS-CT-1`, gatilho G2), e o conjunto de consumidores pode ser enumerado? Um conjunto de consumidores não enumerável é um achado por si só. Um consumidor noutro projeto é migrado pela demanda daquele projeto: uma `Condition:` roteada a ela (Passo 1).
- **Entrega e reversibilidade** — a mudança pode ser entregue em etapas e revertida? Confira três coisas. Uma mudança incompatível de contrato ou de esquema convive com a versão em produção por expansão, migração e contração (`QM-CC-7`, `CS-CT-1`), e uma migração já aplicada nunca é editada (`CS-DA-4`). Os dados existentes que o mapa trouxe têm caminho de migração ou de preenchimento. O comportamento novo pode sair atrás de uma flag com condição de remoção (`CS-EV-1`), quando o projeto ou o risco o pedem. Sem caminho que conviva com a versão em produção, a entrega coordenada ou a indisponibilidade é uma `Condition:`, uma decisão com responsável. É um `Blocker:` só quando uma restrição ancorada ou declarada pelo arquiteto proíbe o único caminho.
- **Gatilhos de especificação** — passe a demanda pelos gatilhos do `../quality-model/references/quality-triggers.md`: são as decisões de qualidade que a ITS vai precisar tomar, e este é o ponto barato de descobrir as que ninguém consegue tomar. Para cada gatilho disparado:
  - a decisão depende de um slot sem valor — nem padrão da stack nem ADR do projeto → `Condition:` de lacuna de slot, de responsabilidade do arquiteto (`coding-standards`, Slots não preenchidos);
  - a decisão vale além da story — o primeiro outbox do sistema, a política de idempotência de todos os consumidores → `Condition:` de ADR a levantar, responsável o arquiteto;
  - dependência de terceiros nova (G13) → `Condition:` de admissão (`CS-DP-1`; `CS-DP-2` quando já existe biblioteca sancionada para a mesma preocupação), responsável o arquiteto responsável;
  - operação sensível (G14), entrada externa nova com regra de acesso (G1) ou qualquer sinal de `crítica` no mapa → a fronteira de segurança (`QM-SR-*`, `CS-SC-*`, em especial o controle de acesso, `QM-SR-8`, e o dado protegido, `QM-SR-10`, `CS-SC-6`) é uma `Condition:` com o responsável de segurança — uma fronteira aberta não bloqueia por existir;
  - código sem testes no conjunto direto (G11) e estrutura que só comporta a mudança distorcida (G12) → `Cost driver:` — a caracterização e a refatoração preparatória entram no tamanho;
  - chamada externa (G3), falha parcial (G4), repetição (G5), concorrência (G6) e volume (G8) → `Cost driver:` quando o sistema já tem o mecanismo e o slot dá o valor; quando não, caem num dos casos acima.

  Não fabrique gatilhos que a demanda não dispara.
- **Verificação** — o resultado afirmado pode ser provado como entregue? Os comandos de verificação da configuração, a observabilidade que as áreas afetadas realmente têm (`QM-EO-7`) e a obrigação de teste que a mudança carregaria (`CS-TS-1`). Uma meta não funcional sem forma de ser medida (G10, `QM-EF-2`) é viável só sob a condição de se construir essa medição. O mesmo vale para qualquer demanda que ninguém consegue verificar como entregue.
- **Risco de erosão** — o caminho viável mais barato introduz uma *segunda* forma de fazer algo que o projeto já faz de uma só (`QM-CN-1`), ou aumenta a contagem de uma migração em curso? Responder sim não bloqueia. Nomeia a dívida que a demanda criaria, para que o time a assuma deliberadamente (`QM-MT-1`) em vez de descobri-la na revisão.

**Cobertura das lentes.** Toda lente termina num de três resultados, e o relatório registra qual: os achados que produziu; *examinada, nada encontrado*, com o que foi examinado em uma linha; ou *não se aplica*, com a razão. "Nada encontrado" e "não examinada" são fatos diferentes, e só o primeiro sustenta um *Viable*. Isso também mantém a análise proporcional: numa demanda pequena, a maioria das lentes cabe numa linha.

## Passo 4 — Disciplina de evidência

Todo achado herda sua âncora do mapa e a carrega de forma visível. O vocabulário é o do `impact-mapping`; esta skill acrescenta um estado e duas regras próprias.

**Restrição declarada.** O que o arquiteto respondeu à pergunta do Passo 2 não tem âncora no código, e não precisa: ele é quem decide no processo, e a palavra dele sobre o ambiente do projeto é evidência. O achado a carrega como *declarada pelo arquiteto*, e o relatório a lista nas premissas do veredito, para que quem leia saiba em que o julgamento se apoia. Só a resposta do arquiteto tem esse peso: o que a story, o PRD ou outra pessoa afirmam continua `[UNVERIFIED]`.

**Um `Blocker:` exige evidência ancorada ou uma restrição declarada.** Um blocker apoiado em evidência `[INFERRED]` ou `[UNVERIFIED]` não é um blocker — é o motivo pelo qual o veredito é *Undecidable with current evidence*. Qualquer coisa afirmada pela demanda e nunca conferida contra o código permanece `[UNVERIFIED]`, por mais plausível que soe.

**Um `Blocker:` sobrevive à refutação.** Antes de classificá-lo, tente derrubá-lo: existe outro caminho que entrega o mesmo resultado observável — outro módulo, outra forma de integração, outra sequência de entrega? O teto é rígido, ou é um valor que o projeto pode mudar por decisão? A restrição alcança mesmo este código — e, quando é declarada, o arquiteto confirma que ela alcança este caminho, e não só o primeiro que a demanda sugeriu? A âncora diz o que o achado afirma? A tentativa trabalha sobre o mapa: no código, abre só a âncora que confere, e um caminho que exigiria rastrear além da borda dele não é rastreado aqui. O blocker que não sobrevive cai — vira `Condition:` ou deixa de existir. O que a tentativa não consegue confirmar nem derrubar, esse caminho inclusive, é tratado como evidência não ancorada (Passo 6, regra 2). É a mesma disciplina que o `code-review` aplica a um `Blocking:`.

## Passo 5 — Classificar cada achado

Um achado declara **onde**, **o quê**, **por quê** — citando um ID ou uma âncora de evidência — e **o que implica para a demanda**.

- **`Blocker:`** — a demanda não pode ser absorvida como especificada. Uma restrição rígida, ou um resultado que contradiz um invariante sem caminho para contornar. Exige evidência ancorada que sobreviveu à refutação.
- **`Condition:`** — viável, mas só se algo for verdade antes. Toda condição carrega um **responsável** e uma **rota** (uma skill a executar, uma decisão a tomar, uma dependência a adquirir). O responsável é escrito pelo papel: o arquiteto por padrão; o responsável de segurança na fronteira de segurança; o responsável que o ADR nomeia numa migração em curso; o arquiteto do outro projeto numa dependência entre projetos. O nome entra quando o arquiteto o informou ou um ADR o registra, nunca por suposição. Uma condição sem rota é um `Blocker:` disfarçado.
- **`Cost driver:`** — não bloqueia e não condiciona; muda o tamanho. Projeto legado, migração em curso no alcance, amplitude do conjunto acoplado, superfícies de contrato cruzadas, dados existentes a migrar, código sem testes, estrutura que não comporta a mudança, regra de negócio replicada, observabilidade ausente, dívida que o caminho criaria.
- **`FYI:`** — contexto que quem demanda deveria ter. Sem obrigação.

Agregação: vários achados causados por um único fato estrutural são um achado, declarado onde ele pode realmente ser endereçado.

## Passo 6 — O veredito, exatamente um

O veredito não é lido apenas dos achados. Ele se resolve a partir de duas entradas — os achados classificados no Passo 5 e o **estado da base de evidência** trazido do mapa —, aplicadas nesta ordem, vale a primeira que casar:

1. **Existe um `Blocker:` ancorado ou apoiado numa restrição declarada** → *Not viable as specified*. Esse blocker é
   autossuficiente: lacunas em outros pontos não o suavizam, porque só uma mudança na demanda o
   dissolve. Registre as lacunas como follow-ups e decida.
2. **Nenhum blocker da regra 1, e a base de evidência não sustenta afirmar que nenhum existe**
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
- **Undecidable with current evidence** — nomeie a **única execução que decidiria**: o extractor
  na área X, um spike com tempo limitado em Y, uma medição de Z. Diga o que a torna decisiva: a pergunta
  que ela responde, quem a executa e o veredito a que cada resultado leva — "p99 ≤ 300 ms → *Viable with
  conditions*; acima → *Not viable as specified*". Uma execução cujo resultado ninguém sabe ler não decide
  nada. Feita a execução, a análise roda de novo (`FA-<demand-id>-2`) sobre um mapa novo (`IM-<demand-id>-2`). Este veredito é
  um resultado, não uma falha — um veredito inventado custa mais que uma lacuna honesta.

**Em todo veredito, as premissas.** Liste as linhas não ancoradas — `[INFERRED]` e `[UNVERIFIED]` — de que
o veredito depende sem que sejam blockers, cada uma com o que mudaria se fosse falsa. São os pontos de
sensibilidade: quem lê sabe o que conferir primeiro e o que reabriria o veredito. Sem premissas
desse tipo, escreva "nenhuma".

Nunca entregue um veredito sobre uma demanda que você não entendeu. "Provavelmente está bem" não é um veredito.

## Passo 7 — Follow-ups, por destino

Cada follow-up é redigido para o destino que o resolve. Esta skill não executa nenhum deles nem os registra no tracker.

- **Às skills de caso de uso** — a execução do extractor que estabelece um baseline; a validação de um `Draft` e a divergência (`QM-DO-1`), ao use-case-creator. Nunca remendadas de dentro desta skill.
- **Ao arquiteto** — a **decisão de ADR a levantar**: um ADR Accepted que a demanda desafia ou substituiria, ou uma decisão `Proposed` de que ela depende, levantada como uma `Condition:` com o arquiteto como responsável. O ADR em si é redigido pelo adr-generator, por palavra do arquiteto, nunca aqui. Também o caso de uso `Retired` que o código ainda executa.
- **À configuração** — a seção do `docs/prime-config.md` de que a análise precisou e que falta ou diverge do código. O slot não preenchido (`coding-standards`) vai ao arquiteto. Nunca improvisados.
- **Ao outro projeto** — a demanda correspondente, quando o resultado daqui depende de mudança lá.
- **Ao backlog** — a dívida que o caminho viável criaria, com um responsável prospectivo (`QM-MT-1`), redigida como item para o arquiteto registrar.
- **Ao dono do modelo de qualidade** — o critério de que a confrontação precisou e que o catálogo não tem. Quem agrega as ocorrências entre execuções é ele.

## Saída

Um relatório de viabilidade — um artefato de trabalho do arquiteto dentro do refinamento do time, não um
documento do repositório. É arquivado onde a demanda vive (tracker, thread do PRD), nunca na
raiz de documentos, e não aparece em nenhuma configuração. Cabeçalho pela mesma regra do mapa: `FA-<demand-id>-N`,
a data, a demanda e o mapa em que se apoia, por ID e revisão.

Contém a demanda reformulada e sua fronteira, **a referência ao mapa de impacto — por ID e revisão**, a
baseline de cada área tocada, as restrições declaradas pelo arquiteto, os achados, a cobertura das lentes, as premissas do veredito, o veredito com
sua razão de uma linha e os follow-ups por destino. Um mapa citado sem a revisão não está citado: a regra 2 do
Passo 6 depende de onde aquele mapa parou, e só a revisão diz se a borda ainda vale. A passada operacional e o template do relatório vivem em `checklists/feasibility-checklist.md`. Leia-o depois do veredito, para conferir a análise e montar o relatório — não no Passo 0.

Nem este relatório nem o mapa que ele cita são obrigatórios para que uma demanda exista ou avance. O
time é dono da demanda; são ferramentas que o arquiteto usa dentro desse processo.

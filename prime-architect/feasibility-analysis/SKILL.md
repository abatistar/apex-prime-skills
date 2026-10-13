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
- **Não decide se a demanda vale a pena.** Valor é decisão de quem demanda. Esta skill responde *pode ser absorvida, a que custo estrutural, e o que precisa ser verdade antes*.

## Passo 0 — Carregar a configuração e os critérios

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, tratamento de divergências e bootstrap vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa: a stack e as versões (o teto sob o qual todo caminho proposto precisa caber), o **registro de áreas**, os **overrides de slots**, as localizações de documentos, incluindo o repositório de ADRs, e os comandos de verificação.

Em seguida carregue, como os critérios em que o julgamento se ancora: o **prime-core/quality-model** (`QM-XX-N`), o **prime-core/coding-standards** (`CS-XX-N`) e os **ADRs Accepted**.

**Custo é evidência, nunca um critério.** O modelo de qualidade responde *o que é bom*, não *quanto isto custa*; não o estique até virar um vocabulário de custo que ele não possui. Onde a confrontação precisa de um critério que não existe — um slot de convenção sem padrão da stack nem override do projeto — **reporte a lacuna** conforme o `coding-standards` e nunca improvise o valor. Um critério ausente em três execuções distintas é o gatilho para um PR de governança contra o core, não para uma invenção local.

## Passo 1 — Reformular a demanda como algo verificável

Declare em uma ou duas frases qual resultado observável a demanda afirma, e confirme com o arquiteto. Se a demanda não pode ser reduzida a uma mudança observável no comportamento do sistema — se nomeia uma tecnologia, uma preferência ou uma aspiração em vez de um resultado — **pare aqui** e devolva-a. Não há nada a julgar, e julgá-la mesmo assim é como esta skill degeneraria em opinião.

Registre explicitamente o que a demanda **não** afirma. Uma fronteira declarada neste passo é o que impede a análise de se expandir numa revisão do sistema inteiro.

## Passo 2 — Executar o mapa

Execute o `impact-mapping` sobre a demanda **como reformulada no Passo 1** — essa reformulação é a linha de assunto do mapa, e o Passo 1 do próprio mapa não é reexecutado. O que esta skill consome dele:

- os **três graus** de alcance — direto, acoplado, superfície de contrato;
- a sobreposição de **estados de área** (`current`, `legacy-maintained`, `strangler`);
- a **camada documentada** — cobertura por casos de uso, divergências encontradas, incidência de ADR;
- a **marcação de proveniência** em cada linha (ancorada, `[INFERRED]`, `[UNVERIFIED]`, lacuna), cujo vocabulário é definido por aquela skill e reutilizado aqui sem alteração;
- e, decisivamente, a **borda declarada** — onde o mapa deliberadamente parou.

A borda é o que faz de *Undecidable* um veredito honesto em vez de uma evasiva. Decidir sobre um mapa que truncou o próprio alcance em silêncio produz um veredito confiante sobre um quadro parcial, que é a pior saída que esta skill pode produzir.

**`Insufficient input` interrompe a execução sem veredito.** Neste caminho o mapa não consegue chegar a esse achado: ele é produzido pelo Passo 1 do mapa, que não roda aqui porque o Passo 1 acima forneceu a reformulação. Uma demanda que não pôde ser reformulada já foi devolvida no Passo 1, antes de qualquer mapa ser comissionado. O achado ainda chega de uma maneira — o arquiteto traz um mapa executado de forma avulsa que parou ali — e a resposta é a mesma: pare, devolva as perguntas e não reporte veredito. Não existe *Undecidable* em nenhum dos casos, porque nada foi julgado. Uma demanda que ninguém soube descrever como uma mudança no sistema ainda não chegou a esta skill.

Dois achados do mapa são lidos antes de qualquer lente rodar, porque mudam o que um veredito pode significar:

- **Área afetada não documentada** → uma `Condition:` com responsável e rota para o `use-case-extractor`, não uma incógnita a absorver. Viabilidade julgada contra código que ninguém descreveu é julgada no escuro, mas uma área não descrita é uma lacuna conhecida com rota conhecida — é para isso que serve uma condição. Adição green-field que não toca nenhum comportamento existente dispensa baseline; anote e prossiga.
- **A única exceção:** quando a área não documentada é onde um `Blocker:` se apoiaria — o mapa coloca a restrição mais dura da demanda dentro de comportamento que ninguém descreveu —, a execução é Undecidable with current evidence, nomeando a execução do extractor como a que decidiria. A ausência de um blocker carrega o mesmo ônus de evidência que um blocker: Viable with conditions afirma que nada bloqueia, e afirmar isso sobre código não lido é a falha que esta skill existe para prevenir. Essa exceção é declarada e justificada no relatório, nunca presumida em silêncio.
- **Divergência entre código e caso de uso** → onde os dois já discordam, **nenhum dos dois é um baseline seguro**, e um veredito apoiado no errado se dissolve ao primeiro contato. Isso sozinho pode levar a execução a *Undecidable*.

## Passo 3 — As lentes, em ordem decrescente do que mata uma demanda

Cada lente aponta para onde seu critério vive — nunca o redefine. Rode-as sobre o mapa; não reande o código que o mapa já andou.

- **Restrição** — os tetos rígidos: stack e versão (configuração), plataforma, dados que não existem, uma dependência externa ou licença que o projeto não possui, uma fronteira regulatória. Esta lente produz os únicos achados que tornam algo genuinamente impossível, razão pela qual é lida primeiro e costuma ser a mais curta.
- **Encaixe estrutural** — a demanda briga com a forma do sistema? `CS-AR-1..5`, `QM-CC-1..5` e a incidência de ADR trazida do mapa. **Uma demanda que contradiz um ADR Accepted não é inviável** — é uma questão de ADR. Ela vira uma `Condition:` nomeando o ADR, de responsabilidade do arquiteto e roteada ao ciclo de vida do ADR: a decisão precisa ser revisitada antes de a demanda entrar em especificação. Esta skill não redige o ADR. Redigir exige uma Decisão, e esta skill não projeta nada — ela julga. O registro é arquivado pelo fluxo que o its-contract define: pelo arquiteto diretamente nesta etapa, em que ainda não existe plano, ou pelo its-generator quando um plano precisar se comprometer com ele. Nunca trate uma decisão registrada como um muro, e nunca deixe uma ser derrubada em silêncio dentro de uma análise.
- **Superfície de contrato** — de tudo que o mapa colocou fora desta base de código (formatos de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas compartilhadas), todo consumidor conhecido pode ser migrado, e o conjunto de consumidores pode ser enumerado? Um conjunto de consumidores não enumerável é um achado por si só.
- **Verificação** — o resultado afirmado pode ser provado como entregue? Os comandos de verificação da configuração, a observabilidade que as áreas afetadas realmente têm e a obrigação de teste que a mudança carregaria (`CS-TS-1`). Uma demanda que ninguém consegue verificar como entregue é viável apenas sob a condição de que se construa uma forma de verificá-la.
- **Risco de erosão** — o caminho viável mais barato introduz uma *segunda* forma de fazer algo que o projeto já faz de uma só (`QM-CN-1`)? Responder sim não bloqueia; nomeia a dívida que a demanda criaria, para que possa ser assumida deliberadamente (`QM-MT-1`) em vez de descoberta depois na revisão.
- **Concorrência e escala** — apenas onde o resultado da demanda as implica (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`). Não fabrique esta lente para mudanças que não a carregam.
- **Superfície de segurança** — toda nova fronteira que a demanda abriria: `QM-SR-*`, `CS-SC-*`. Uma demanda que abre uma não é bloqueada por isso, mas a fronteira é uma condição com responsável.

## Passo 4 — Disciplina de evidência

Todo achado herda sua âncora do mapa e a carrega de forma visível. O vocabulário é o do `impact-mapping`; esta skill acrescenta uma regra própria:

**Um `Blocker:` exige evidência ancorada.** Um blocker apoiado em evidência `[INFERRED]` ou `[UNVERIFIED]` não é um blocker — é o motivo pelo qual o veredito é *Undecidable with current evidence*. Qualquer coisa afirmada pela demanda e nunca conferida contra o código permanece `[UNVERIFIED]`, por mais plausível que soe.

## Passo 5 — Classificar cada achado

Um achado declara **onde**, **o quê**, **por quê** — citando um ID ou uma âncora de evidência — e **o que implica para a demanda**.

- **`Blocker:`** — a demanda não pode ser absorvida como especificada. Uma restrição rígida, ou um resultado que contradiz um invariante sem caminho para contornar. Exige evidência ancorada.
- **`Condition:`** — viável, mas só se algo for verdade antes. Toda condição carrega um **responsável** e uma **rota** (uma skill a executar, uma decisão a tomar, uma dependência a adquirir). Uma condição sem rota é um `Blocker:` disfarçado.
- **`Cost driver:`** — não bloqueia e não condiciona; muda o tamanho. Estado da área, amplitude do conjunto acoplado, superfícies de contrato cruzadas, observabilidade ausente, dívida que o caminho criaria.
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
   `[UNVERIFIED]` cai aqui, não na regra 1 (Passo 4).
3. **Caso contrário, pelo menos uma `Condition:`** → *Viable with conditions*.
4. **Caso contrário** → *Viable*.

`Cost driver:` e `FYI:` nunca movem o veredito. Não existe veredito *"viável mas caro"* —
tamanho é evidência entregue a quem decide, nunca um julgamento.

### Quando a base de evidência é insuficiente

A regra 2 dispara quando, e somente quando, uma destas condições se verifica:

- a **borda** do mapa para aquém do que o veredito exige;
- uma **divergência código × caso de uso** não resolvida não deixa baseline seguro;
- uma **área não documentada carrega a restrição mais dura da demanda** (Passo 2) — uma área meramente
  não documentada é uma `Condition:`, não uma indecidibilidade;
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
  na área X, um spike com tempo limitado em Y, uma medição de Z). Este veredito é um resultado, não uma
  falha — um veredito inventado custa mais que uma lacuna honesta.

Nunca entregue um veredito sobre uma demanda que você não entendeu. "Provavelmente está bem" não é um veredito.

## Passo 7 — Follow-ups a registrar antes de encerrar

- Execução do extractor necessária para estabelecer um baseline.
- Divergência roteada às skills de caso de uso (`QM-DO-1`) — nunca remendada de dentro desta skill.
- **Decisão de ADR a levantar** — uma decisão registrada que a demanda desafia, incluindo um ADR Accepted que ela substituiria. Levantada como uma `Condition:` com o arquiteto como responsável. O ADR em si é redigido pelo fluxo do its-contract, pelo arquiteto diretamente nesta etapa ou pelo its-generator quando um plano precisar se comprometer com ele, nunca aqui.
- Slot não preenchido a reportar (`coding-standards`) — nunca improvisado.
- Lacuna de configuração: um fato sobre o projeto de que a análise precisou e que o `docs/prime-config.md` não carrega.
- Dívida que o caminho viável criaria, nomeada com um responsável prospectivo (`QM-MT-1`).

## Saída

Um relatório de viabilidade — um artefato de trabalho do arquiteto dentro do refinamento do time, não um
documento do repositório. É arquivado onde a demanda vive (tracker, thread do PRD), nunca sob
`docs/`, e não aparece em nenhuma configuração. Cabeçalho pela mesma regra do mapa: `FA-<demand-id>-N`,
a data e a demanda.

Contém a demanda reformulada e sua fronteira, **uma referência ao mapa de impacto — por ID e
data**, os achados, o veredito com sua razão de uma linha e os follow-ups. Uma referência a um
mapa sem sua data não é uma referência: a regra 2 do Passo 6 depende de onde aquele mapa específico
parou, e um mapa sem data não consegue responder se sua borda ainda vale. A passada operacional e o
template do relatório vivem em `checklists/feasibility-checklist.md`.

Nem este relatório nem o mapa que ele cita são obrigatórios para que uma demanda exista ou avance. O
time é dono da demanda; são ferramentas que o arquiteto usa dentro desse processo.

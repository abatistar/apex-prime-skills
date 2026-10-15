---
name: coding-standards
description: O contrato canônico das convenções concretas de código - o catálogo de slots de convenção que todo projeto precisa ter decidido, os padrões do time por stack, as duas classes de aplicação (invariante vs convencional) e as regras para conviver com código legado e com migrações declaradas. Esta skill é dona das respostas concretas a que os critérios do prime-core/quality-model remetem; os valores específicos do projeto vivem no docs/prime-config.md e têm precedência. Consulte sempre que for planejar, escrever, revisar ou validar código, sempre que um critério de qualidade precisar de uma convenção concreta para ser verificável e sempre que uma mudança tocar uma área registrada como legado. Nunca duplique seu conteúdo em outro lugar - referencie os slots por ID.
---

# Padrões de Código (prime-core)

O `quality-model` responde *o que é bom*. Esta skill responde *como o bom se parece aqui* — as convenções concretas a que os critérios dele remetem. Onde o modelo diz "nenhuma espera sem limite" (`QM-RB-1`), esta skill diz qual é o timeout padrão e onde ele é configurado; onde ele diz "o padrão local vence" (`QM-CN-2`), esta skill diz como uma área é classificada, em primeiro lugar, como território de padrão local.

A skill não guarda os valores de todos os projetos. Guarda três coisas:

1. **O catálogo de slots** (`references/convention-slots.md`) — a lista fechada de decisões que todo projeto precisa ter tomado, cada uma com um ID estável (`CS-XX-N`).
2. **Os padrões do time** (`references/defaults-<stack>.md`) — a resposta que o time usa quando um projeto nada diz, versionada. Java é a stack padrão: `references/defaults-java.md`.
3. **As regras de engajamento** — o que é um slot, classes de aplicação, legado, versões dos padrões, migrações e como cada papel usa a skill.

## Fronteiras

- O **prime-core/quality-model** é dono dos princípios, do piso inegociável, dos níveis de criticidade e dos gatilhos de especificação. Esta skill nunca repete um critério: cada slot declara a que critérios serve e fornece a forma concreta que os torna verificáveis.
- O **prime-core/prime-config** é dono do arquivo do projeto: onde ficam os overrides, o registro de áreas, a release fixada, os exemplos canônicos e as exclusões. A precedência é a do contrato da configuração: explícito vence detectado, a configuração sobrescreve padrões declarados, a configuração nunca dispensa uma regra do core.
- O **prime-core/its-contract** é dono das decisões que sobrevivem à story e do formato da ITS. Uma convenção que muda para o projeto inteiro é decidida num ADR antes de virar valor de slot; na ITS, uma convenção chega como a escolha concreta, nunca como o ID do slot.
- O **prime-architect/code-review** é dono do enforcement. Esta skill define a convenção; o revisor decide se uma dada mudança a cumpriu.

## O que é um slot

Um slot é **uma pergunta que o projeto precisa ter respondido**, não uma resposta. Só existe onde há uma escolha real: uma exigência sem alternativa — liberar todo recurso adquirido, por exemplo — é um critério do `quality-model`, verificado por ferramenta, e não vira slot. E nenhum slot exige um padrão de projeto pelo nome: cada um declara o problema, e a solução sancionada é o valor.

No catálogo, cada slot declara:

- **classe** — INVARIANT ou CONVENTIONAL (abaixo);
- **serve a** — os critérios do `quality-model` que ele torna concretos;
- **verificação** — `ferramenta`, `teste` ou `revisão`;
- **aplica-se a** — `serviço` ou `cliente`.

Num arquivo de padrões ou na configuração, cada **valor** carrega:

- **o valor** — a resposta concreta;
- **a razão** — uma linha com a falha que o valor evita. Uma regra sem razão é folclore: não resiste à primeira discordância e não pode ser revista quando o contexto muda;
- **a verificação concreta** — a regra de ferramenta, o teste ou "revisão";
- **o exemplo canônico**, para valores convencionais — o caminho de um arquivo do projeto que mostra a forma certa. É declarado pelo projeto, porque um padrão do time não conhece o código de ninguém. Quem implementa copia a forma, a ITS pode apontar para ele ("mesma forma de `PaymentClient`") e quem revisa compara.

"Não se aplica", com o motivo, é um valor válido. Um slot cujo tipo de componente o projeto não tem não precisa nem disso.

## Duas classes de aplicação

A classe diz **onde o valor vale**, e decide o que acontece quando o código ao redor discorda do padrão. Ela resolve a tensão entre o `QM-CN-2` (o padrão local vence a preferência) e o piso (cumprido em tudo o que se escreve): ambos estão certos, sobre slots diferentes.

**INVARIANT** — vale para toda linha escrita ou alterada, em qualquer área, independentemente do que a cerca. Dois tipos de slot são invariantes:

- as **proibições** que levam o piso do `quality-model` à forma concreta — erro engolido, segredo no código, entrada não validada, consulta concatenada. Não existe "o padrão local aqui é engolir a exceção";
- as **formas únicas do sistema** — o que um consumidor, outro serviço ou uma investigação enxerga como um todo: a forma das coleções na API, as representações de tempo e dinheiro, a propagação de correlação, a política de dependências.

O desvio de um invariante só existe como exceção registrada, conforme a disciplina do `quality-model` — nunca por herança. Uma forma única que o código legado ainda não segue não é corrigida pela mudança que passa ao lado: converge por migração declarada.

**CONVENTIONAL** — segue o estado registrado da área: numa área legada, o padrão local vence, sempre. Seguir o padrão atual num fragmento de código antigo introduz a segunda forma de fazer as coisas que o `QM-CN-1` proíbe. A consistência com o entorno é, ela mesma, o critério. O padrão atual chega ao código antigo por uma única via: uma migração declarada.

A consequência, dita às claras: **código antigo continuar antigo é correto, não é dívida.** Dívida é o código antigo que uma migração declarada abandonou pela metade.

## Legado: o registro de áreas

A classificação é declarada, não julgada a cada pull request. O `docs/prime-config.md` registra cada área numa linha; a forma do registro pertence ao `prime-core/prime-config`. A linha carrega duas dimensões, cada uma com seu dono:

- **o estado**, definido aqui;
- **o nível de criticidade**, definido pelo `quality-model` (`efêmera`, `padrão`, `crítica`).

Os três estados:

- **current** — o padrão completo se aplica: slots invariantes e convencionais.
- **legacy-maintained** — os slots invariantes se aplicam ao que você escreve e altera; os slots convencionais seguem o padrão local. A área é corrigida, estendida e mantida normalmente.
- **strangler** — como acima, mais: nenhum comportamento novo. A capacidade nova nasce no módulo substituto. Nomeie o substituto e o ID da migração, ou o rótulo não significa nada.

Nunca infira esses estados de nomes de diretórios ou da idade dos arquivos. Uma área não registrada é `current`, e um projeto que precisa de um quarto estado está dizendo que o registro está errado, não a regra.

**Exclusões não são áreas.** Código gerado (clientes e modelos gerados a partir de um contrato, por exemplo) e código de terceiros copiado para o repositório são declarados como exclusões na configuração. Não são editados à mão: a mudança vai para a entrada do gerador ou para a origem. Os slots e as ferramentas não os julgam; o código do projeto que os usa continua sob todos os slots.

## Padrões do time: versionados e fixados

Um arquivo de padrões é uma resposta compartilhada por todos os projetos que não a sobrescrevem. Se ele mudasse em silêncio, todos esses projetos mudariam de convenção de uma vez, e o código existente passaria a ser "o jeito antigo" sem nenhuma migração — a erosão do `QM-CN-1` em escala. Por isso:

- **A versão é a release.** Os arquivos de padrões não carregam número próprio: são versionados junto com o resto do Apex Prime, pela release — a tag — que o instalador usa e que o manifesto da instalação registra. Mudar um valor só chega aos projetos numa release nova; a anterior continua válida para quem a fixou.
- **O projeto fixa a release que segue** na configuração. Sem release fixada, vale a instalada, e a ausência da fixação é uma lacuna a reportar. Uma release instalada diferente da fixada é uma divergência, tratada como o `prime-core/prime-config` trata a configuração que contradiz o código: reportada, nunca resolvida em silêncio. A fixação importa sobretudo quando as skills são instaladas no perfil do usuário e servem a vários projetos ao mesmo tempo; um projeto que as instala no próprio repositório fixa a release também pelo que commita.
- **Subir a release é uma decisão do projeto.** A diferença dos arquivos de padrões entre as duas tags, no controle de versão, é a lista dos valores que mudaram, e para cada um a decisão diz o que acontece com o código existente:
  - num slot CONVENTIONAL, uma migração declarada, ou as áreas afetadas registradas como `legacy-maintained`;
  - num slot INVARIANT, sempre uma migração declarada.

O ciclo de vida de um valor é sempre o mesmo, em três passos:

1. **A decisão.** Para o padrão do time, o PR de governança. Para o projeto, um ADR quando a mudança alcança código que já existe.
2. **O valor.** Uma release nova com o arquivo de padrões alterado, ou o override na configuração.
3. **O código existente.** Uma migração declarada, ou o registro de áreas.

Um valor decidido sem o terceiro passo é erosão anunciada.

## Migrações declaradas

Uma migração é como um valor muda para código que já existe. Carrega cinco campos:

- **novo valor** — o slot e o valor de destino;
- **responsável**;
- **escopo** — as áreas ou os caminhos que ela cobre;
- **detecção** — a regra ou a busca que encontra as ocorrências da forma antiga; quando nenhuma busca as encontra, o inventário delas;
- **condição de conclusão** — normalmente, zero ocorrências no escopo.

Faltando qualquer um dos cinco, não é uma migração — é erosão com nome (`QM-CN-1`).

- **Deliberada e em bloco**, nunca oportunismo arquivo a arquivo. Onde a mudança é mecânica, uma receita de refatoração automatizada a executa e a revisão confere o resultado.
- **A contagem só cai.** A detecção roda no pipeline sobre o escopo; uma mudança que aumenta a contagem de ocorrências da forma antiga é erosão, e a contagem é o progresso visível da migração.
- **Dois valores corretos ao mesmo tempo.** O valor antigo continua válido dentro do escopo até a migração concluir; esta é a única situação em que isso é verdade.
- **Migração parada é cancelada explicitamente.** A área volta a `legacy-maintained`. Meio migrado é o pior estado; deixá-lo não declarado é pior do que reverter.

## Overrides por área e por nível

A configuração pode declarar o valor de um slot para o projeto inteiro, para uma área ou para um nível de criticidade — por exemplo, um padrão de segurança externo num nível mais alto nas áreas `crítica`. A precedência vai do mais específico ao mais geral: **área → nível → projeto → padrões do time na release fixada**.

Um override declara uma forma ou eleva a régua. Nunca dispensa em silêncio uma proibição: relaxar um invariante é uma exceção com responsável — um ADR quando vale para o projeto —, não uma linha de configuração.

## Slots não preenchidos

Um slot aplicável sem valor — nem padrão do time na release fixada, nem override — é uma **lacuna reportável**, não uma escolha livre. As skills consumidoras a expõem do jeito que o `prime-config` expõe uma seção obrigatória ausente: reportam e oferecem preencher, não improvisam um valor e não prosseguem em silêncio numa tarefa que dependa dele. O catálogo existe para que "ninguém nunca decidiu onde as transações começam" se torne visível em vez de virar trinta decisões inconsistentes.

"Não se aplica", com o motivo, não é lacuna: é uma resposta.

## Verificação

A atenção humana é cara e a de uma ferramenta é barata. Cada slot declara como é verificado, e a declaração organiza o trabalho de todos:

- **`ferramenta`** — o pipeline decide. Quem implementa roda os comandos de verificação antes do PR; quem revisa não rediscute (`QM-MT-7`). A ausência da regra na toolchain do projeto é uma lacuna a registrar, não um convite a revisar à mão.
- **`teste`** — a suíte prova. A ITS declara o teste quando a story aciona o slot; quem revisa confere que o teste existe e verifica o que diz.
- **`revisão`** — exige julgamento. É onde a atenção do revisor deve ser gasta.

Uma regra de ferramenta que produz falsos positivos com frequência treina o time a ignorá-la: é corrigida ou removida, nunca mantida por princípio.

## O sinal de saúde

A conformidade da base de código inteira é a medida errada: nunca chega a 100%, não é acionável e pune áreas que o registro já isentou. Um sinal faz o trabalho em seu lugar:

- **Conformidade por mudança.** Medida sobre o diff, nunca sobre o arquivo. Uma mudança é conforme quando cumpre todo slot invariante e o valor convencional aplicável à sua área. Binária, verificada no pull request — o que torna o legado irrelevante para a decisão de merge. É a forma concreta, para as convenções, do `QM-MT-6`.
- **A contagem de cada migração**, que só cai.

O sinal não aprova nem reprova nada por si só; o enforcement pertence ao `code-review`.

## Versionamento

A mesma disciplina do `quality-model`, pelo mesmo motivo: um desvio ou uma nota de melhoria precisa citar algo estável e datado.

- O catálogo de slots e os arquivos de padrões são versionados pela release do Apex Prime — a tag. Nenhum arquivo carrega número de versão próprio. Os **IDs dos slots são estáveis e nunca renumerados**; um slot aposentado mantém seu ID aposentado, listado no fim do catálogo.
- Acrescentar um slot ou mudar um valor de padrão muda a versão menor da release. Aposentar ou reclassificar um slot, ou mover conteúdo entre slots, muda a maior.
- Uma mudança no catálogo que altera um slot chega aos arquivos de padrões no mesmo PR de governança.
- Toda mudança no catálogo ou num arquivo de padrões passa pelo PR de governança, revisado pelo dono do modelo de qualidade. Esse PR é o registro da evolução, no controle de versão; a skill não mantém histórico paralelo.

## Regras de consumo

**Para o `its-generator`** — carregue o catálogo, os padrões do time na release fixada, os overrides e o registro de áreas antes de planejar. O plano se conforma aos valores efetivos das áreas que toca.

- **Valores para os gatilhos.** Para cada gatilho de especificação que a story dispara, os slots que servem aos critérios do gatilho dão o valor que a unidade escreve: o timeout, a chave de idempotência, o limite de página, a regra de autorização.
- **Quando a ITS escreve um valor de slot.** Em dois casos, e só neles:
  - quando um gatilho disparado precisa dele;
  - quando a área segue um valor diferente do padrão do time — legado, migração em curso ou override —, porque quem implementa conhece o padrão do time e o aplicaria.

  Fora disso, a convenção é a base de quem implementa e não se repete.
- **Valor, nunca ID.** A ITS escreve o valor, nunca o ID do slot. Um exemplo canônico pode ser apontado pelo caminho do arquivo.
- **Legado.** O legado com que o plano convive sem corrigir vira uma fronteira de fora de escopo. O slot só aparece nas Referências da ITS quando o plano se afasta dele por exceção registrada.
- **Lacuna.** Um slot de que o plano precisa e que não tem valor é uma lacuna a reportar, não a inventar.

**Para o `its-implementation`** — leia os valores efetivos dos slots que as áreas tocadas e os gatilhos da story acionam, não o catálogo inteiro.

- Siga o exemplo canônico quando houver.
- Cumpra todo slot invariante em código novo e alterado.
- Rode os comandos de verificação do projeto antes de dar a unidade por pronta: os slots de verificação `ferramenta` são garantidos ali.
- Onde um invariante já é violado no código que você toca, nomeie-o como dívida herdada, sem adotá-lo nem corrigi-lo fora do escopo.
- Ambiguidade sobre qual valor se aplica é uma pergunta devolvida ao arquiteto, nunca uma suposição.

**Para o `code-review`** — os achados citam IDs de slots junto com IDs de critérios (`CS-ER-4` / `QM-EO-2`), de modo que a conversa seja sobre uma decisão versionada em vez do gosto de um revisor.

- Julgue slots convencionais contra o estado registrado da área, não contra o padrão atual. Um achado convencional numa área `legacy-maintained` só é válido se a mudança introduziu um *terceiro* padrão — nem local, nem atual.
- Não rejulgue o que uma ferramenta verifica. Registre como lacuna de toolchain o slot de verificação `ferramenta` sem regra no pipeline.
- Uma mudança que aumenta a contagem de uma migração em curso é erosão.

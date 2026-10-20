# Regras para quem consome os padrões de código

Parte do contrato do `prime-core/coding-standards`, e a que as skills do fluxo leem: onde cada valor vale (as duas classes), o registro de áreas, as migrações declaradas, os overrides, as lacunas, a verificação e como cada papel usa os slots. O SKILL.md — o que é um slot, os padrões versionados, o sinal de saúde e a evolução — é lido por quem implementa, junto com este arquivo, e pelo dono do catálogo.

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

## Regras de consumo

**Para o `its-generator`** — carregue os índices do catálogo e dos padrões do time na release fixada, os overrides e o registro de áreas antes de planejar; o arquivo de uma família entra quando um slot dela é citado ou aplicado. O plano se conforma aos valores efetivos das áreas que toca.

- **Valores para os gatilhos.** Para cada gatilho de especificação que a story dispara, os slots que servem aos critérios do gatilho — o mapa Critério → slots do índice do catálogo diz quais são — dão o valor que a unidade escreve: o timeout, a chave de idempotência, o limite de página, a regra de autorização.
- **Quando a ITS escreve um valor de slot.** Em dois casos, e só neles:
  - quando um gatilho disparado precisa dele;
  - quando a área segue um valor diferente do padrão do time — legado, migração em curso ou override —, porque quem implementa conhece o padrão do time e o aplicaria.

  Fora disso, a convenção é a base de quem implementa e não se repete.
- **Valor, nunca ID.** A ITS escreve o valor, nunca o ID do slot. Um exemplo canônico pode ser apontado pelo caminho do arquivo.
- **Legado.** O legado com que o plano convive sem corrigir vira uma fronteira de fora de escopo. O slot só aparece nas Referências da ITS quando o plano se afasta dele por exceção registrada.
- **Lacuna.** Um slot de que o plano precisa e que não tem valor é uma lacuna a reportar, não a inventar.

**Para quem implementa** — leia os valores efetivos dos slots que as áreas tocadas e os gatilhos da story acionam, não o catálogo inteiro.

- Siga o exemplo canônico quando houver.
- Cumpra todo slot invariante em código novo e alterado.
- Rode os comandos de verificação do projeto antes de dar a unidade por pronta: os slots de verificação `ferramenta` são garantidos ali.
- Onde um invariante já é violado no código que você toca, nomeie-o como dívida herdada, sem adotá-lo nem corrigi-lo fora do escopo.
- Ambiguidade sobre qual valor se aplica é uma pergunta devolvida ao arquiteto, nunca uma suposição.

**Para o `code-review`** — os achados citam IDs de slots junto com IDs de critérios (`CS-ER-4` / `QM-EO-2`), de modo que a conversa seja sobre uma decisão versionada em vez do gosto de um revisor.

- Julgue slots convencionais contra o estado registrado da área, não contra o padrão atual. Um achado convencional numa área `legacy-maintained` só é válido se a mudança introduziu um *terceiro* padrão — nem local, nem atual.
- Não rejulgue o que uma ferramenta verifica. Registre como lacuna de toolchain o slot de verificação `ferramenta` sem regra no pipeline.
- Uma mudança que aumenta a contagem de uma migração em curso é erosão.

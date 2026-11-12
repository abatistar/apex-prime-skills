# Regras para quem consome os padrões de código

Parte do contrato do `coding-standards`, e a que as skills do fluxo leem: onde cada valor vale (as duas classes), o projeto legado, as migrações, os desvios do projeto, as lacunas, a verificação e como cada papel usa os slots. O SKILL.md — o que é um slot, os padrões versionados, o sinal de saúde e a evolução — é lido por quem implementa, junto com este arquivo, e pelo dono do catálogo.

## Duas classes de aplicação

A classe diz **onde o valor vale**, e decide o que acontece quando o código ao redor discorda do padrão. Ela resolve a tensão entre o `QM-CN-2` (o padrão local vence a preferência) e o piso (cumprido em tudo o que se escreve): ambos estão certos, sobre slots diferentes.

**INVARIANT** — vale para toda linha escrita ou alterada, em qualquer projeto, independentemente do que a cerca. Dois tipos de slot são invariantes:

- as **proibições** que levam o piso do `quality-model` à forma concreta — erro engolido, segredo no código, entrada não validada, consulta concatenada. Não existe "o padrão local aqui é engolir a exceção";
- as **formas únicas do sistema** — o que um consumidor, outro serviço ou uma investigação enxerga como um todo: a forma das coleções na API, as representações de tempo e dinheiro, a propagação de correlação, a política de dependências. O invariante é haver uma forma só.

O desvio de um invariante só existe como exceção registrada, conforme a disciplina do `quality-model` — nunca por herança.

**CONVENTIONAL** — segue o projeto: num projeto legado, o padrão local vence, sempre. Seguir o padrão do time num fragmento de código antigo introduz a segunda forma de fazer as coisas que o `QM-CN-1` proíbe. A consistência com o entorno é, ela mesma, o critério. O padrão do time chega ao código antigo por uma única via: uma migração.

A consequência, dita às claras: **código antigo continuar antigo é correto, não é dívida.** Dívida é o código antigo que uma migração abandonou pela metade.

## Projeto legado

Legado é um fato do projeto inteiro, declarado na opção **Legado** da configuração (`docs/prime-config.md` › Opções, lida conforme as regras de consumo do `prime-config`). Nunca é inferido de nomes de diretórios nem da idade dos arquivos, e não existe área legada dentro de um projeto: um projeto é um microsserviço ou um sistema legado.

- **`Legado: false`**, o padrão — o projeto nasceu sob os padrões do time. Slots invariantes e convencionais se aplicam por inteiro.
- **`Legado: true`** — o código existente é a referência. O projeto é corrigido, estendido e mantido normalmente, sob três regras:
  - os slots **convencionais** seguem o padrão que o código já tem, lido no entorno do que a mudança toca; a arquitetura é a que a Estrutura da configuração declara;
  - as **formas únicas do sistema** são as que o sistema já expõe. Um endpoint novo responde na forma dos existentes: a forma do time, ali, seria a segunda forma;
  - as **proibições** valem para toda linha escrita ou alterada, como em qualquer projeto.

Um projeto legado só passa a seguir o padrão do time, num slot, por uma migração.

**Código gerado e de terceiros não é julgado.** Clientes e modelos gerados a partir de um contrato e código de terceiros copiado para o repositório não são editados à mão: a mudança vai para a entrada do gerador ou para a origem. São reconhecidos pelo marcador de geração ou pela origem declarada no próprio arquivo ou no build. Os slots e as ferramentas não os julgam; o código do projeto que os usa continua sob todos os slots.

## Migrações

Uma migração é como um valor muda para código que já existe. É uma decisão, declarada num **ADR Accepted** e identificada pelo número dele. O ADR carrega cinco campos:

- **novo valor** — o slot e o valor de destino;
- **responsável**;
- **escopo** — os pacotes ou os caminhos que ela cobre;
- **detecção** — a regra ou a busca que encontra as ocorrências da forma antiga; quando nenhuma busca as encontra, o inventário delas;
- **condição de conclusão** — normalmente, zero ocorrências no escopo.

Faltando qualquer um dos cinco, não é uma migração — é erosão com nome (`QM-CN-1`).

- **Deliberada e em bloco**, nunca oportunismo arquivo a arquivo. Onde a mudança é mecânica, uma receita de refatoração automatizada a executa e a revisão confere o resultado.
- **A contagem só cai.** A detecção roda no pipeline sobre o escopo; uma mudança que aumenta a contagem de ocorrências da forma antiga é erosão, e a contagem é o progresso visível da migração.
- **Dois valores corretos ao mesmo tempo.** O valor antigo continua válido dentro do escopo até a migração concluir; esta é a única situação em que isso é verdade.
- **Migração parada é cancelada explicitamente**, por um ADR que substitui o dela e diz qual das duas formas passa a valer no escopo. Meio migrado é o pior estado; deixá-lo não declarado é pior do que reverter.

## Desvios do projeto

Os padrões do time são a regra. A configuração do projeto não carrega valor de slot: um projeto que precisa de um valor diferente o decide num **ADR Accepted**, com o valor, a razão e a verificação. A precedência é **ADR Accepted → padrões do time na release instalada**. Quando a decisão alcança código que já existe, o mesmo ADR declara a migração.

Um desvio declara uma forma ou eleva a régua. Relaxar um invariante é uma exceção com responsável, registrada no ADR conforme a disciplina do `quality-model`, nunca uma escolha feita na ITS nem no código.

Os valores que variam com o nível de criticidade — um padrão de segurança externo num nível mais alto, por exemplo — já estão nos padrões do time, e seguem o nível que a ITS declara para a demanda.

## Slots não preenchidos

Um slot aplicável sem valor — nem padrão do time, nem ADR do projeto — é uma **lacuna reportável**, não uma escolha livre. As skills consumidoras a expõem do jeito que o `prime-config` expõe uma seção ausente: reportam e oferecem preencher, não improvisam um valor e não prosseguem em silêncio numa tarefa que dependa dele. O catálogo existe para que "ninguém nunca decidiu onde as transações começam" se torne visível em vez de virar trinta decisões inconsistentes.

"Não se aplica", com o motivo, não é lacuna: é uma resposta.

## Verificação

A atenção humana é cara e a de uma ferramenta é barata. Cada slot declara como é verificado, e a declaração organiza o trabalho de todos:

- **`ferramenta`** — o pipeline decide. Quem implementa roda os comandos de verificação antes do PR; quem revisa não rediscute (`QM-MT-7`). A ausência da regra na toolchain do projeto é uma lacuna a registrar, não um convite a revisar à mão.
- **`teste`** — a suíte prova. A ITS declara o teste quando a story aciona o slot; quem revisa confere que o teste existe e verifica o que diz.
- **`revisão`** — exige julgamento. É onde a atenção do revisor deve ser gasta.

Uma regra de ferramenta que produz falsos positivos com frequência treina o time a ignorá-la: é corrigida ou removida, nunca mantida por princípio.

## Regras de consumo

**Para o `its-generator`** — carregue os índices do catálogo e dos padrões do time antes de planejar; o arquivo de uma família entra quando um slot dela é citado ou aplicado. Leia a opção Legado da configuração e os ADRs `Accepted` que decidem valor de slot ou declaram migração no código que o plano toca. O plano se conforma aos valores efetivos: o ADR, onde há um; o padrão local, num projeto legado; o padrão do time, no resto.

- **Valores para os gatilhos.** Para cada gatilho de especificação que a story dispara, os slots que servem aos critérios do gatilho — o mapa Critério → slots do índice do catálogo diz quais são — dão o valor que a unidade escreve: o timeout, a chave de idempotência, o limite de página, a regra de autorização.
- **Quando a ITS escreve um valor de slot.** Em dois casos, e só neles:
  - quando um gatilho disparado precisa dele;
  - quando o código tocado segue um valor diferente do padrão do time — projeto legado, migração em curso ou ADR do projeto —, porque quem implementa conhece o padrão do time e o aplicaria.

  Fora disso, a convenção é a base de quem implementa e não se repete.
- **Valor, nunca ID.** A ITS escreve o valor, nunca o ID do slot. Um exemplo canônico pode ser apontado pelo caminho do arquivo.
- **Legado.** O legado com que o plano convive sem corrigir vira uma fronteira de fora de escopo. O slot só aparece nas Referências da ITS quando o plano se afasta dele por exceção registrada.
- **Lacuna.** Um slot de que o plano precisa e que não tem valor é uma lacuna a reportar, não a inventar.

**Para quem implementa** — leia os valores efetivos dos slots que o código tocado e os gatilhos da story acionam, não o catálogo inteiro.

- Siga o exemplo canônico quando houver.
- Cumpra todo slot invariante em código novo e alterado.
- Rode os comandos de verificação do projeto antes de dar a unidade por pronta: os slots de verificação `ferramenta` são garantidos ali.
- Onde um invariante já é violado no código que você toca, nomeie-o como dívida herdada, sem adotá-lo nem corrigi-lo fora do escopo.
- Ambiguidade sobre qual valor se aplica é uma pergunta devolvida ao arquiteto, nunca uma suposição.

**Para o `code-review`** — os achados citam IDs de slots junto com IDs de critérios (`CS-ER-4` / `QM-EO-2`), de modo que a conversa seja sobre uma decisão versionada em vez do gosto de um revisor.

- Julgue slots convencionais contra o valor efetivo, não contra o padrão do time. Num projeto legado, um achado convencional só é válido se a mudança introduziu um padrão que o código não tinha; a forma do time, ali, também é um padrão novo.
- Não rejulgue o que uma ferramenta verifica. Registre como lacuna de toolchain o slot de verificação `ferramenta` sem regra no pipeline.
- Uma mudança que aumenta a contagem de uma migração em curso é erosão.

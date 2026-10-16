---
name: prime-config
description: O contrato canônico do docs/prime-config.md - o arquivo de configuração do projeto que toda skill do Apex Prime lê como primeiro passo. É dono da estrutura do arquivo, das seções obrigatórias e opcionais, da lista fechada de pontos de override que os contratos declaram, das regras de precedência e divergência e do procedimento de bootstrap quando o arquivo não existe. Consulte sempre que for ler, validar, fazer o bootstrap ou atualizar o prime-config.md de um projeto, e sempre que o Passo 0 de uma skill encontrar o arquivo ausente ou contradizendo o código. Nunca duplique suas regras em outro lugar - referencie-o.
---

# Contrato do Prime Config (prime-core)

O `prime-config.md` é o ponto de entrada de toda execução do Apex Prime: todas as skills, em todas as camadas, o leem como primeiro passo. Esta skill é dona do seu contrato — estrutura, pontos de override, precedência, divergências, ciclo de vida, validação e bootstrap. Como todo consumidor lê contra o mesmo contrato, uma mudança aqui atualiza todos de uma vez; nenhuma skill redefine o que a configuração significa.

A configuração responde a uma pergunta: **o que é verdade sobre este projeto que as skills não devem adivinhar?** Stack e versões, arquitetura e estrutura, comandos de verificação, onde vive a documentação, quem responde pelo quê, convenções e restrições, tracker e pipeline. Todo o resto pertence aos contratos (formatos, qualidade) ou às skills de papel (processo).

**Um arquivo por projeto.** Um projeto é uma unidade de código com seu próprio ciclo de entrega — um microsserviço ou um sistema legado. Uma demanda que atravessa vários projetos é quebrada em demandas por projeto antes de chegar ao Apex Prime, e cada uma corre no projeto que a recebe; nenhuma skill segue um fluxo para além da fronteira do projeto.

## Localização do arquivo e template

- O arquivo vive **no repositório do código**, porque descreve o código e muda no mesmo PR que muda o que descreve. Caminho canônico: `docs/prime-config.md`. Alternativa: raiz do repositório (`prime-config.md`) — a natural quando a documentação do projeto fica fora do repositório. Nenhum outro local, nem a raiz de documentos quando ela é uma pasta paralela.
- Template canônico: `references/prime-config-template.md`. Leia-o integralmente antes de fazer o bootstrap ou validar uma configuração.
- O arquivo é versionado com o código e muda por PR, como o código.
- **Nunca carrega segredo, credencial, endereço com credencial ou dado pessoal.** É versionado e lido por agentes; o que é sensível vive no cofre do projeto.

## Seções

**Obrigatórias** — uma configuração sem qualquer uma delas está incompleta (veja Divergências e lacunas):

- **Stack** — linguagem e versão, framework, ferramenta de build, banco de dados, migrações, mensageria (quando houver). As versões têm peso: as skills planejam e revisam contra elas. Um projeto com mais de um componente declara uma Stack por componente, cada uma com seu tipo (`serviço` ou `cliente`, conforme o prime-core/coding-standards).
- **Estrutura** — a arquitetura do projeto e o pacote que representa cada um dos seus elementos — no hexagonal, domínio, aplicação (portas de entrada, portas de saída, serviços), adaptadores de entrada e de saída e montagem. Os padrões do time definem os elementos e as regras entre eles, nunca os nomes dos pacotes: esse mapa é do projeto. Um projeto legado declara a arquitetura que tem de fato — camadas, por exemplo — e, quando ela difere da do padrão do time, sobrescreve o slot de arquitetura (`CS-AR-1`) com a sua. É o mapa que o teste de arquitetura verifica, o do its-generator para inspeção de código e o do extractor para o inventário de pontos de entrada.
- **Comandos de verificação** — como compilar, testar e rodar as verificações que o projeto tem: a suíte inteira, um teste isolado, o teste de arquitetura e, onde houver, mutação e contrato. Lidos por toda skill que planeja, julga ou verifica: o its-generator fecha o plano da ITS com eles, o impact-mapping e a feasibility-analysis os leem como evidência de cobertura, o pr-preparation os executa antes do PR e o code-review os executa como pré-condição de uma revisão em projetos que não declaram pipeline.
- **Repositório de documentos** — onde vive a documentação do Apex Prime do projeto: casos de uso, ITS e ADRs.
  - **Raiz de documentos:** `docs`, dentro do repositório do código e versionada com ele, ou uma pasta paralela ao projeto (padrão sugerido: `../<projeto>-docs`), com versionamento próprio. A escolha é do projeto e é declarada; sem a declaração, vale `docs` dentro do repositório.
  - A localização e a nomenclatura de casos de uso, ITS e ADRs, relativas à raiz.
  - Os dois overrides de caso de uso, que vivem aqui como campos: o caminho de um template customizado e as seções obrigatórias extras.

  Existem padrões nos contratos donos — o `prime-architect/use-case` e o `prime-core/its-contract` —, mas a configuração os declara explicitamente para que os overrides tenham um único endereço.
- **Responsáveis** — as pessoas a quem os contratos atribuem decisões neste projeto: o arquiteto responsável (aprova ADRs e a admissão de dependências, assina as ITS) e o responsável de segurança (concede com o arquiteto as exceções de segurança do prime-core/quality-model). Um papel sem nome é escrito como "não declarado ainda"; uma tarefa que precisa dele reporta a lacuna.
- **Convenções e restrições** — as regras do projeto que restringem todo plano e toda revisão. Esta seção é o lar de todo ponto de override que os contratos do core declaram sobre código (veja Pontos de override abaixo), e carrega sete subseções nomeadas, a última das quais guarda as regras em prosa livre que não se encaixam em nenhum slot:
  - **Padrões do time** — a release do Apex Prime (a tag) cujos catálogos e padrões do time o projeto segue, conforme o prime-core/coding-standards. Uma release nova só alcança o projeto quando ele a fixa aqui.
  - **Registro de áreas** — uma linha por área com duas dimensões: o estado (`current` | `legacy-maintained` | `strangler`, conforme o prime-core/coding-standards) e o nível de criticidade (`efêmera` | `padrão` | `crítica`, conforme o prime-core/quality-model; `efêmera` com a condição de remoção). Não registrada significa `current` e `padrão`; a classificação é declarada aqui, nunca inferida. A mesma subseção lista as **exclusões** — código gerado ou de terceiros, que não é área e não é editado à mão.
  - **Overrides de slots** — os slots de convenção (`CS-XX-N`) que este projeto decide de forma diferente dos padrões do time, cada um com seu alcance (o projeto, uma área ou um nível de criticidade) e sua razão. "Não se aplica", com o motivo, é um valor válido.
  - **Soluções e exemplos canônicos** — o registro de soluções canônicas do projeto (`CS-PR-1`) e, por slot convencional, o caminho do arquivo que mostra a forma certa.
  - **Migrações declaradas** — cada migração em andamento com seu novo valor de slot, responsável, escopo, detecção e condição de conclusão.
  - **Postura do modelo de qualidade** — inegociáveis específicos do projeto, critérios calibrados endurecidos e a postura permanente diante de legado e dívida, conforme o prime-core/quality-model.
  - **Regras do projeto** — o que restringe todo plano e toda revisão e não se mapeia em nenhum slot: áreas proibidas, exigências de aprovação, restrições operacionais e de compliance. Uma pergunta que o catálogo de slots já faz é respondida em Overrides de slots, nunca aqui também; duas cópias de uma decisão é justamente o que o catálogo existe para prevenir.

**Opcionais:**

- **Tracker** — onde vivem as stories e os itens de backlog:
  - o formato do identificador de story (padrão quando ausente: `S-NNN`);
  - o padrão do link da story, com `{id}` no lugar do identificador — a ITS o usa na linha da story em Referências; sem ele, a linha leva só o identificador e a lacuna é reportada;
  - o formato do item de backlog que os padrões pedem para dívida, teste desativado e flag (por exemplo, `ITEM-123`).
- **Pipeline** — a plataforma em que os PRs vivem, os estágios de CI/CD, a **lista das verificações obrigatórias antes do merge**, cada uma com a ferramenta que a executa, e as **políticas de PR** que a revisão precisa conhecer: os revisores obrigatórios e se a resolução de comentários é obrigatória. O code-review a lê para saber o que não precisa revisar à mão, para registrar como lacuna de toolchain o slot de verificação por ferramenta que nenhuma verificação da lista cobre e para saber como publicar a revisão; o pr-preparation, para saber o que precisa passar. Omita em projetos sem pipeline; onde for omitido, os Comandos de verificação ocupam seu lugar como pré-condição de uma revisão.

Projetos podem adicionar seções além destas (por exemplo, requisitos de compliance). Seções desconhecidas são preservadas, nunca apagadas por nenhuma skill.

Uma subseção vazia é escrita com um "nenhuma declarada ainda" (ou "nenhuma — valem os padrões do time") explícito, nunca omitida. Silêncio e ausência são fatos diferentes, e só um deles é uma decisão.

**O arquivo guarda fatos, não instruções.** O porquê de cada seção vive neste contrato e nos contratos donos; o arquivo do projeto carrega no máximo uma linha de ponteiro por seção. Toda skill o lê no primeiro passo, e cada parágrafo de explicação copiado para ele é lido em toda execução.

## Pontos de override (a lista fechada)

Um contrato declara um ponto de override quando nomeia um padrão que o projeto pode substituir. A configuração pode sobrescrever **apenas** o que aparece abaixo; qualquer outra coisa nos contratos é regra, não padrão.

Os contratos donos vivem no `prime-core`, com uma exceção: o formato de caso de uso vive no `prime-architect/use-case`, porque todas as skills que o escrevem e o leem são do arquiteto. Seus pontos de override ficam nesta mesma lista fechada, para que a configuração continue tendo um único endereço.

| Ponto de override | Contrato dono | Onde vive na configuração |
|---|---|---|
| Raiz de documentos (no repositório ou em pasta paralela) | este contrato | Repositório de documentos |
| Caminho do template de caso de uso | prime-architect/use-case | Repositório de documentos |
| Seções obrigatórias extras de caso de uso | prime-architect/use-case | Repositório de documentos |
| Localização e nomenclatura de documentos e ADRs | prime-architect/use-case, prime-core/its-contract | Repositório de documentos |
| Release do Apex Prime fixada (catálogos e padrões do time) | prime-core/coding-standards | Convenções e restrições › Padrões do time |
| Valores de slots de convenção (`CS-XX-N`), por projeto, área ou nível, inclusive "não se aplica" | prime-core/coding-standards | Convenções e restrições › Overrides de slots |
| Estado de área (`current` / `legacy-maintained` / `strangler`) | prime-core/coding-standards | Convenções e restrições › Registro de áreas |
| Exclusões (código gerado ou de terceiros) | prime-core/coding-standards | Convenções e restrições › Registro de áreas |
| Soluções canônicas (`CS-PR-1`) e exemplos canônicos por slot | prime-core/coding-standards | Convenções e restrições › Soluções e exemplos canônicos |
| Migrações declaradas | prime-core/coding-standards | Convenções e restrições › Migrações declaradas |
| Nível de criticidade de área (`efêmera` / `padrão` / `crítica`) | prime-core/quality-model | Convenções e restrições › Registro de áreas |
| Inegociáveis adicionados e critérios calibrados endurecidos | prime-core/quality-model | Convenções e restrições › Postura do modelo de qualidade |
| Postura permanente diante de legado e dívida deliberada | prime-core/quality-model | Convenções e restrições › Postura do modelo de qualidade |
| Formato do identificador de story | este contrato | Tracker |

Um contrato que queira um novo ponto de override adiciona uma linha aqui no mesmo PR que o declara. Dois contratos descrevendo o mesmo override em dois lugares é o descolamento que esta skill existe para prevenir.

**Somente o template de caso de uso é sobrescrevível, e isso é uma decisão, não uma omissão.** Um caso de uso descreve o comportamento de um projeto, e a forma que o descreve bem pode legitimamente variar. A ITS e o ADR são artefatos de passagem de bastão e de auditoria, lidos por um implementador, um revisor e por pessoas de fora do projeto e do repositório — sua estrutura é fixada pelo prime-core justamente para que um leitor que chega frio encontre sempre o mesmo documento. Um projeto que precise de um diferente está pedindo uma mudança no contrato, pelo PR de governança, não uma entrada de configuração.

## Regras de precedência

1. **Explícito vence detectado.** O que a configuração declara vence qualquer coisa que a skill infira de arquivos de build ou árvores de diretórios.
2. **A configuração sobrescreve os padrões dos contratos apenas nos pontos de override declarados** (a tabela acima). Nesses pontos, o valor da configuração vence de forma absoluta — um override de slot vence o padrão da stack, e o mais específico vence o mais geral (área → nível → projeto → padrões do time na release fixada); o estado registrado de uma área vence o padrão atual para slots convencionais.
3. **A configuração nunca sobrescreve uma regra de um contrato.** Não pode dispensar a rastreabilidade, o ciclo de vida de status do caso de uso, os gates de qualidade nem um critério `[NON-NEGOTIABLE]`. A configuração pode **elevar** a régua; relaxar um inegociável é uma decisão deliberada, com responsável, registrada em um ADR, nunca uma edição de configuração.
4. **A configuração não sobrescreve um ADR Accepted.** Um conflito entre eles é reportado, não resolvido em silêncio.

## Divergências e lacunas (regras para todo consumidor)

- **A configuração existe mas contradiz o código** (diz Java 21, o `pom.xml` diz 25; a Estrutura declara um pacote que o teste de arquitetura não verifica): reporte a divergência e pergunte qual está correta antes de prosseguir. Nunca confie em silêncio em qualquer um dos lados.
- **A configuração existe mas falta uma seção obrigatória:** prossiga só se a tarefa em andamento não precisar dessa seção; caso contrário, reporte a lacuna e ofereça completá-la pelo procedimento de bootstrap (restrito à seção ausente).
- **A configuração existe mas um slot de que a tarefa precisa não tem valor** — nem padrão da stack na release fixada nem override: é uma lacuna reportável conforme o prime-core/coding-standards (Slots não preenchidos). Reporte-a e ofereça preenchê-la; nunca improvise um valor e nunca prossiga em silêncio numa tarefa que dependa dele. Um slot declarado "não se aplica", com o motivo, não é lacuna.
- **A configuração não fixa a release do Apex Prime:** vale a instalada — a que o manifesto da instalação (`apex-prime.json`) registra —, e a ausência da fixação é uma lacuna a reportar: sem ela, uma release nova alcança o projeto sem que ninguém a tenha adotado.
- **A release instalada difere da fixada:** reporte a divergência e pergunte qual vale antes de prosseguir. Instalar a release fixada resolve; subir a fixação é uma decisão do projeto, conforme o prime-core/coding-standards, e nunca um efeito colateral de uma reinstalação.
- **A raiz de documentos declarada não existe ou não está acessível na sessão:** reporte. Se a pasta não existe, ofereça criá-la (Procedimento de bootstrap, passo 5); se existe fora da sessão, peça que ela seja aberta ou adicionada à sessão. Nunca escreva um documento do Apex Prime em outro lugar para contornar a ausência.
- **Um papel de Responsáveis de que a tarefa precisa não tem nome:** reporte a lacuna. Uma exceção de segurança, por exemplo, não é concedida sem o responsável de segurança.
- **A configuração não existe:** ofereça fazer o bootstrap (abaixo). As skills não prosseguem com pura detecção sem dar ao usuário uma configuração para revisar — fatos indetectáveis (convenções, áreas proibidas, classificação de áreas) estariam silenciosamente ausentes.

## Ciclo de vida da configuração

A configuração muda por ato explícito, nunca como efeito colateral de outra tarefa. Dois caminhos levam a uma mudança:

- **Por esta skill** — o bootstrap, uma validação ou uma atualização pedida pelo usuário — sempre entregue como rascunho para a revisão dele.
- **Pela ITS** — quando a story muda um fato que a configuração registra: uma área nova ou um nível de criticidade novo, um elemento ou pacote novo na Estrutura, o avanço ou a conclusão de uma migração, a remoção de código efêmero, um exemplo canônico novo, um comando novo. A ITS planeja a atualização como uma unidade, como qualquer outra mudança de arquivo; quem implementa a executa no mesmo PR, e o code-review a confere.

Fora desses dois caminhos, nenhuma skill edita a configuração. Uma skill que descobre um fato desatualizado o reporta.

## Validação

Execute quando o usuário pedir, depois de um bootstrap ou ao fixar uma release nova. Uma skill consumidora não executa a validação inteira: reporta apenas o que encontrar no que a sua tarefa usa. Cada achado é reportado com a correção sugerida; a correção é uma atualização explícita, revisada pelo usuário.

- As seções obrigatórias estão presentes, e toda subseção vazia diz isso explicitamente.
- A Stack confere com os arquivos de build; a release fixada, com o manifesto da instalação.
- Todo caminho declarado existe: pacotes da Estrutura, áreas, exclusões, exemplos canônicos e a raiz de documentos.
- Os pacotes da Estrutura são os que o teste de arquitetura verifica.
- Nenhuma área `efêmera` tem a condição de remoção vencida.
- Toda migração declarada tem contagem caindo; uma parada é cancelada ou retomada, conforme o prime-core/coding-standards.
- Nenhum override cita um slot ou critério aposentado ou reclassificado — a verificação obrigatória depois de subir a release.
- Nenhum marcador `[CONFIRM: ...]` ficou esquecido numa seção que as tarefas usam.
- Nada de segredo, credencial ou dado pessoal no arquivo.

## Procedimento de bootstrap

Execute quando a configuração estiver ausente, ou restrito a seções específicas quando elas estiverem ausentes.

1. **Detectar.** Leia arquivos de build (`pom.xml`, `build.gradle`, `package.json`, ...), árvore de diretórios, marcadores de framework, pastas de migração, definições de CI. Redija as seções Stack, Estrutura e Comandos de verificação a partir de evidência — cite a evidência (qual arquivo disse o quê) para que o usuário possa auditar a detecção. Na Estrutura, descreva a arquitetura que o código tem de fato; se ela não é a do padrão do time, proponha o override do slot de arquitetura e marque-o com `[CONFIRM: ...]`.
2. **Comparar com os padrões do time.** Carregue o `prime-core/coding-standards` (`references/convention-slots.md`) e o arquivo de padrões da stack detectada, e fixe em Padrões do time a release instalada, lida do manifesto da instalação. Não pergunte slot a slot: compare o código com os padrões e pergunte só onde a evidência diverge do padrão do time ou onde não existe padrão para a stack. Para cada divergência confirmada, registre o override com seu alcance e sua razão; para um slot sem sentido no projeto, "não se aplica" com o motivo; para um slot sem padrão nem decisão, o slot não preenchido com `[CONFIRM: ...]`. Proponha como exemplos canônicos os arquivos que a detecção encontrou seguindo a forma certa, marcados com `[CONFIRM: ...]`. O catálogo é uma lista fechada justamente para que "ninguém nunca decidiu onde as transações começam" se torne visível em vez de virar trinta decisões inconsistentes.
3. **Classificar as áreas.** Elicite o registro de áreas: o estado de cada caminho — `current`, `legacy-maintained` ou `strangler` (com o módulo substituto e o ID da migração) — e o nível de criticidade — `efêmera` (com a condição de remoção), `padrão` ou `crítica`. Nunca infira isso de nomes de diretórios ou da idade dos arquivos; a conformidade com a arquitetura declarada (as violações que o teste de arquitetura encontra) é evidência para propor um estado, marcado com `[CONFIRM: ...]`. Um projeto que não declara nada recebe `current` e `padrão` em tudo — escreva isso explicitamente em vez de deixar a subseção de fora. Proponha como exclusões o código gerado e o de terceiros que a detecção encontrou, marcados com `[CONFIRM: ...]`.
4. **Perguntar o que o código não conta.** Responsáveis, regras do projeto, áreas proibidas, postura do modelo de qualidade, tracker, estágios e verificações do pipeline são conhecimento humano. Elicite-os; nunca invente. Se o usuário não tem nada a declarar, escreva a subseção com um "nenhuma declarada ainda" explícito em vez de omiti-la.
5. **Definir o repositório de documentos.** Pergunte se a documentação fica no próprio repositório (`docs`) ou numa pasta paralela ao projeto, versionada à parte; se uma pasta `../<projeto>-docs` já existe, proponha-a com `[CONFIRM: ...]`. Dentro da raiz, use como padrão as convenções do core (`use-cases/`, `its/`, `adr/`) e ofereça criar as pastas ausentes. O versionamento de uma pasta paralela é do projeto — normalmente um repositório próprio.
6. **Ligar os arquivos de contexto do agente.** Se o projeto tem um `AGENTS.md`, um `CLAUDE.md` ou um `.github/copilot-instructions.md`, ofereça acrescentar uma linha que aponta para a configuração como fonte dos fatos do projeto (stack, estrutura, comandos, convenções) — sem copiar nenhum deles para lá. Duas cópias dos comandos de build divergem na primeira mudança.
7. **Entregar como rascunho para revisão.** O usuário valida antes de o arquivo ser commitado. Uma configuração que ninguém revisou é detecção, não configuração — e explícito-vence-detectado só significa algo se um humano o tornou explícito.
8. Marque tudo o que foi deduzido mas não confirmado com `[CONFIRM: ...]` (mesma disciplina de marcadores do prime-architect/use-case). Uma configuração com marcadores não resolvidos é utilizável, mas todo consumidor precisa expor o marcador relevante quando uma tarefa depender dele.

## Regra de consumo (para o Passo 0 de toda skill)

As skills referenciam este contrato em vez de descrever o procedimento: *"Leia o `docs/prime-config.md` conforme o prime-core/prime-config (as regras de alternativa, divergência e bootstrap vivem lá)."* As três frases hoje repetidas nos Passos 0 se reduzem a essa.

Os documentos do Apex Prime — casos de uso, ITS, ADRs — são lidos e escritos sob a raiz de documentos que a configuração declara. Quando ela é uma pasta paralela, a sessão precisa enxergar as duas pastas, e o PR do código cita a ITS e a revisão da documentação que implementou, para que a revisão julgue contra a versão certa.

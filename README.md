# Apex Prime

**Plataforma de skills para agentes de engenharia — entregando soluções no mais alto padrão, do entendimento da demanda ao deploy.**

[![Licença: AGPL v3](https://img.shields.io/badge/Licen%C3%A7a-AGPL%20v3-blue.svg)](LICENSE)

O Apex Prime é a fonte única de verdade dos padrões de qualidade, convenções e fluxos de trabalho que guiam os agentes de IA do time ao longo de todo o ciclo de entrega. Ele transforma o nosso processo — **o Arquiteto de Soluções entende a demanda e cria a ITS → o Dev implementa → o Arquiteto revisa e valida → a pipeline leva ao deploy** — em uma arquitetura de skills com fronteiras explícitas, na qual o arquiteto opera com o contexto certo e todos respondem ao mesmo padrão.

## Sumário

- [Por que existe](#por-que-existe)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Instalação](#instalação)
- [Primeiros passos](#primeiros-passos)
- [Montagem do agente](#montagem-do-agente)
- [Status de autoria](#status-de-autoria)
- [Os contratos do core](#os-contratos-do-core)
- [Identificadores estáveis](#identificadores-estáveis)
- [Princípios de design das skills](#princípios-de-design-das-skills)
- [Governança](#governança)
- [Como contribuir](#como-contribuir)
- [Licença](#licença)

## Por que existe

Quando os padrões de qualidade vivem espalhados — na cabeça das pessoas, em documentos soltos, duplicados entre ferramentas — eles divergem. O dev implementa contra uma versão do padrão, a revisão cobra outra, e o atrito aparece exatamente onde o processo deveria dar fluidez. O Apex Prime resolve isso com dois princípios:

1. **Fundação única.** O modelo de qualidade, as convenções de código, os contratos da ITS e do ADR e o contrato de configuração do projeto têm um único dono e um único endereço: a camada `prime-core`. Todo agente consome a mesma fundação — atualize o padrão uma vez, e ele se atualiza para todos.
2. **A ITS como especificação completa.** O arquiteto especifica e revisa; nunca implementa. A implementação fica com quem desenvolve — pessoa ou agente de codificação, com a ferramenta que o time preferir —, e a ITS basta para isso: é autossuficiente, e tudo o que a mudança exige está escrito nela. Os gates do fluxo — a ITS antes do código, o code review antes do merge — deixam de ser convenção e passam a ser arquitetura.

## Estrutura do repositório

```
apex-prime-skills/
├── README.md
├── LICENSE                                 # AGPL-3.0
├── install.ps1                             # instala e desinstala o Apex Prime
├── adapters/                               # prompt de entrada por plataforma
│   ├── README.md                           # regras dos adapters (os arquivos do Jarvis são cópias deliberadas)
│   ├── claude-code/
│   │   └── jarvis.md                       # prompt de entrada do arquiteto
│   └── copilot/
│       └── jarvis.agent.md
├── prime-core/                             # fundação — consumida por TODOS os agentes
│   ├── quality-model/
│   │   ├── SKILL.md                        # o que é "bom": as dez lentes, o que o modelo cobre, a prática de quem implementa, a evolução
│   │   └── references/
│   │       ├── consumer-rules.md           # o que as skills do fluxo leem: níveis, calibração, precedência, exceções
│   │       ├── quality-criteria.md         # índice do catálogo de critérios: níveis, o piso, os perfis de criticidade
│   │       ├── quality-criteria/           # uma lente por arquivo (RC.md, CC.md, ...), com os critérios QM-XX-N
│   │       └── quality-triggers.md         # os gatilhos que tornam critérios em decisões que a ITS precisa tomar
│   ├── coding-standards/
│   │   ├── SKILL.md                        # como o bom se parece aqui: o que é um slot, padrões versionados pela release, sinal de saúde
│   │   └── references/
│   │       ├── consumer-rules.md           # o que as skills do fluxo leem: classes, projeto legado, migrações, desvios, lacunas
│   │       ├── convention-slots.md         # índice do catálogo fechado de slots: os invariantes e o mapa critério → slots
│   │       ├── convention-slots/           # uma família por arquivo (AR.md, ER.md, ...), com os slots CS-XX-N
│   │       ├── defaults-java.md            # índice dos padrões do time para Java: plataforma e toolchain
│   │       └── defaults-java/              # os valores do time por família, com os mesmos nomes de arquivo
│   ├── prime-config/
│   │   ├── SKILL.md                        # contrato do docs/prime-config.md: as cinco seções, validação, bootstrap
│   │   └── references/
│   │       ├── consumer-rules.md           # o que cada skill segue ao ler um fato: leitura sob demanda, precedência, divergências, ciclo de vida
│   │       └── prime-config-template.md    # o template canônico de configuração do projeto
│   ├── its-contract/
│   │   ├── SKILL.md                        # o formato da ITS, o nível de detalhe e como ela cita um ADR
│   │   ├── references/
│   │   │   ├── writing-rules.md            # as regras de escrita, lidas só por quem escreve a ITS
│   │   │   └── implementer-rules.md        # o que quem implementa segue ao ler a ITS
│   │   └── templates/
│   │       ├── its-template-markdown.md    # a ITS canônica que o arquiteto escreve e o dev consome, em Markdown (o padrão)
│   │       └── its-template-confluence.md  # a mesma ITS na marcação de wiki do Confluence; a opção Template da ITS do prime-config escolhe
│   └── adr-contract/
│       ├── SKILL.md                        # o formato do ADR: quando uma decisão merece um, ciclo de vida do status, quem redige e quem aprova
│       └── templates/
│           └── adr-template.md             # o registro de decisão que uma ITS cita
└── prime-architect/                        # camada do Arquiteto de Soluções ("Jarvis Skills")
    ├── use-case/
    │   ├── SKILL.md                        # o formato de caso de uso: o que cada arquivo define e as regras inegociáveis, em resumo
    │   └── references/
    │       ├── consumer-rules.md           # o que quem só lê precisa: índice, seções, identificadores, status, histórico, marcadores
    │       └── use-case-template.md        # a estrutura do documento, o índice do repositório e as regras de qualidade
    ├── use-case-creator/
    │   ├── SKILL.md                        # como criar e atualizar casos de uso
    │   └── checklists/
    │       └── creation-checklist.md
    ├── use-case-extractor/
    │   ├── SKILL.md                        # engenharia reversa para criar casos de uso
    │   └── checklists/
    │       └── extraction-checklist.md
    ├── impact-mapping/
    │   ├── SKILL.md                        # o que uma mudança alcança: evidência ancorada, nunca um veredito
    │   ├── checklists/
    │   │   └── impact-map-checklist.md
    │   └── references/
    │       ├── reformulation.md            # a reformulação da mudança, lida também pela feasibility-analysis
    │       └── consumer-rules.md           # o que o mapa entrega a quem julga sobre ele: a fonte única do hand-off
    ├── feasibility-analysis/
    │   ├── SKILL.md                        # julga uma demanda contra o sistema, antes de qualquer especificação
    │   └── checklists/
    │       └── feasibility-checklist.md
    ├── its-generator/
    │   ├── SKILL.md                        # como escrever a ITS usando o contrato do core
    │   ├── checklists/
    │   │   └── its-checklist.md
    │   └── references/
    │       ├── revising-an-its.md          # lido só quando uma ITS entregue volta
    │       └── restarting-after-an-adr.md  # lido quando a ITS recomeça depois da decisão sobre um ADR
    ├── adr-generator/
    │   ├── SKILL.md                        # como redigir um ADR e conduzi-lo até a palavra do arquiteto
    │   └── checklists/
    │       └── adr-checklist.md
    ├── code-review/
    │   ├── SKILL.md                        # roteiro de revisão: valida a implementação contra a ITS + os padrões do core
    │   ├── checklists/
    │   │   └── review-checklist.md
    │   └── references/
    │       ├── next-rounds.md              # lido a partir da segunda rodada
    │       └── pr-delivery.md              # lido com o relatório pronto
    └── troubleshooting/
        └── SKILL.md                        # [stub] localiza a causa de um problema já existente e entrega o diagnóstico
```

**Caminhos entre skills.** Uma skill cita um arquivo de outra por um caminho relativo ao próprio diretório — `../quality-model/references/consumer-rules.md`. O caminho vale na instalação, em que o instalador põe as skills das duas camadas lado a lado num único diretório; neste repositório, onde `prime-core/` e `prime-architect/` são pastas separadas, o mesmo arquivo fica em `prime-core/quality-model/references/consumer-rules.md`.

**O que cada skill carrega.** Um contrato separa o que os consumidores leem (`references/consumer-rules.md`) do que só quem o escreve ou o mantém precisa (o SKILL.md). Os catálogos têm um índice, lido sempre, e um arquivo por lente ou família, lido quando um ID dela é citado ou aplicado. Checklists, templates e procedimentos de um caminho só são lidos no passo que os usa.

Toda skill é um diretório com um `SKILL.md` cujo frontmatter traz `name` e `description`. As skills do core mantêm seu material normativo em `references/` ou `templates/`; as skills de papel mantêm suas listas operacionais em `checklists/` e, em `references/`, os procedimentos que só um caminho lê.

## Instalação

O [`install.ps1`](install.ps1) achata `prime-core` + `prime-architect` em um único diretório de skills, instala o adapter do Jarvis no formato do agente e grava um manifesto com o hash de cada arquivo. Rodando de dentro de um clone, instala o próprio clone; baixado avulso, clona a versão pedida em um diretório temporário — veja [Sem clonar o repositório](#sem-clonar-o-repositório).

### Parâmetros

`-Local` escolhe o alcance: `usuario` (padrão) instala no perfil do usuário e não toca em repositório nenhum; um caminho instala na raiz daquele projeto, para ser commitado.

`-Agente` escolhe o formato: `copilot` (padrão) ou `claude`. O padrão é Copilot porque é o formato que não deixa rastro de outra ferramenta em um repositório corporativo.

| | `-Agente copilot` | `-Agente claude` |
|---|---|---|
| Skills no projeto | `.github/skills/` | `.claude/skills/` |
| Skills no usuário | `~/.copilot/skills/` | `~/.claude/skills/` |
| Adapter no projeto | `.github/agents/jarvis.agent.md` | `.claude/commands/jarvis.md` |
| Adapter no usuário | `~/.copilot/agents/jarvis.agent.md` | `~/.claude/commands/jarvis.md` |

O Copilot também lê `.claude/skills/` e `~/.claude/skills/`. Duas consequências: com `-Agente claude` o Copilot enxerga as skills, só não os agentes; e as duas instalações no mesmo local registram cada skill em dobro no Copilot — o instalador avisa quando encontra a outra e sugere manter uma só.

### Uso

Sempre confira antes, com `-WhatIf`:

```powershell
.\install.ps1 -WhatIf
```

Instalar no perfil do usuário, formato Copilot:

```powershell
.\install.ps1
```

Instalar no perfil do usuário para o Claude Code (`/jarvis`):

```powershell
.\install.ps1 -Agente claude
```

Vendorizar em um projeto, para commitar:

```powershell
.\install.ps1 -Local C:\repos\meu-projeto
```

Desinstalar — remove o que estiver instalado naquele local e agente:

```powershell
.\install.ps1 -Desinstalar -Agente claude
```

### Sem clonar o repositório

Baixado avulso, o `install.ps1` clona a versão pedida em um diretório temporário, instala a partir dele e remove o temporário ao final, mesmo em erro. São dois passos, deliberadamente — não há one-liner com `iex`:

```powershell
irm https://raw.githubusercontent.com/abatistar/apex-prime-skills/main/install.ps1 -OutFile install.ps1
```

```powershell
.\install.ps1 -Ref v1.0.0 -Agente claude
```

O `-Ref` aceita tag ou branch, e a tag é o que se deve usar: sem ele a cópia avulsa instala `main`, o topo do branch — justamente o que o versionamento existe para evitar. Dentro de um clone, um `-Ref` explícito também clona, em vez de instalar o próprio clone. O manifesto grava a versão instalada: a tag, ou o branch acompanhado do commit.

### Reinstalação e edições locais

O manifesto (`apex-prime.json`, na raiz do formato — `.github/`, `.claude/`, `~/.copilot/` ou `~/.claude/`) é o que torna a reinstalação segura. Arquivo cujo hash divergiu do gravado foi editado no destino e é **preservado**, com aviso; arquivo que já existia e não veio do Apex Prime também. `-Force` sobrescreve os dois. O que a instalação anterior trouxe e esta não traz — skill ou adapter removido em uma versão nova — é podado. O `-Desinstalar` remove exatamente o que o manifesto registra e nada além.

Instalações feitas pela v1.0.0 são reconhecidas. A de `-Target both` gravava o manifesto em `.claude/` e o adapter do Copilot em `.github/agents/` (ou `~/.copilot/agents/`): reinstalar com `-Agente claude` a assume e remove esse adapter do Copilot. Para passar dela ao Copilot, rode antes `.\install.ps1 -Desinstalar -Agente claude`.

> O instalador roda sob ConstrainedLanguage mode, o modo imposto por WDAC/AppLocker em Windows corporativo. Uma consequência: `-WhatIf` funciona, `-Confirm` não.

## Primeiros passos

Este repositório guarda as skills, não os projetos em que elas se aplicam. Configurá-lo significa tornar as camadas certas visíveis para um agente e, depois, dar ao projeto-alvo um arquivo de configuração.

**1. Instale o Apex Prime.** Veja [Instalação](#instalação). O instalador expõe as camadas `prime-core` e `prime-architect` e instala o adapter do Jarvis no formato do agente — no Claude Code o `jarvis.md`, cuja linha final `$ARGUMENTS` recebe a tarefa; no Copilot o `jarvis.agent.md`, como agente customizado. O adapter roteia para as skills; nunca repete os procedimentos delas.

**2. Faça o bootstrap da configuração do projeto.** As skills leem do `docs/prime-config.md` do *projeto-alvo* os fatos que não podem adivinhar — stack, estrutura, localização dos documentos, comandos de verificação e opções —, uma seção por vez, no passo que precisa dela. O template canônico é o [`prime-core/prime-config/references/prime-config-template.md`](prime-core/prime-config/references/prime-config-template.md), e o procedimento que o preenche — detectar a stack, a estrutura e os comandos, definir o repositório de documentos, elicitar as opções — pertence ao [`prime-core/prime-config`](prime-core/prime-config/SKILL.md). Peça ao agente arquiteto que o execute; o resultado é um rascunho que um humano valida antes do commit.

A partir daí, toque a pipeline: peça ao arquiteto para documentar como um módulo sem documentação se comporta hoje, para escrever os casos de uso de uma story, para gerar a ITS correspondente e, mais tarde, para revisar a implementação que voltar.

## Montagem do agente

| Agente | Camadas carregadas | Responsabilidade no fluxo |
|---|---|---|
| **Jarvis** (Arquiteto) | `prime-core` + `prime-architect` | Entende a demanda, documenta os casos de uso, cria a ITS, faz o code review e diagnostica problemas já existentes |

> Regra de ouro: o Jarvis especifica e revisa; **nunca** implementa. Seu entregável para quem implementa — pessoa ou agente de codificação — é a ITS.

Três capacidades do arquiteto ficam fora dessa linha e são invocadas, nunca obrigatórias: **impact-mapping**, que produz evidência sobre o que uma mudança alcançaria; **feasibility-analysis**, que julga uma demanda contra o sistema antes que ela entre em especificação; e **troubleshooting**, que localiza a causa de um problema já existente e entrega o diagnóstico, nunca a correção. Nenhuma delas é um gate; todas alimentam a mesma pipeline.

## Status de autoria

| Camada | Status |
|---|---|
| `prime-core` | Escrita — quality-model (catálogo de critérios e gatilhos), coding-standards (catálogo de slots e padrões Java), prime-config, its-contract, adr-contract |
| `prime-architect` | Escrita — use-case (formato), use-case-creator, use-case-extractor, impact-mapping, feasibility-analysis, its-generator, adr-generator, code-review. **Stub** — troubleshooting |

O Jarvis, portanto, é operável de ponta a ponta (documentação → ITS → revisão); só o diagnóstico de problemas já existentes espera pelo troubleshooting.

## Os contratos do core

**A ITS.** A peça central da plataforma. O formato da ITS (Instruções Técnicas de Sistema) vive em `prime-core/its-contract` e é consumido pelos dois lados: o arquiteto escreve contra ele, quem implementa — pessoa ou agente — lê a partir dele. Uma mudança no contrato atualiza a escrita e a leitura ao mesmo tempo, eliminando o descolamento entre especificação e implementação. O mesmo contrato diz como a ITS cita um ADR — uma decisão estrutural que sobrevive à story é referenciada por uma ITS, nunca embutida nela.

**O ADR.** O registro de uma decisão de arquitetura que sobrevive à story tem contrato próprio, o `prime-core/adr-contract`: quando uma decisão merece um registro, o ciclo de vida do status, quem redige e quem aprova, e o template. A decisão vem antes do plano: o `its-generator` detecta a decisão sem registro, para a ITS e a propõe; o `prime-architect/adr-generator` redige o ADR por palavra do arquiteto; e a ITS recomeça do início depois que ele aprova ou recusa. É também num ADR `Accepted` que um projeto registra um desvio dos padrões do time ou uma migração.

**O padrão: dois contratos, um único ponto de enforcement.** O `prime-core/quality-model` responde *o que é qualidade* — dez lentes, um piso inegociável com IDs estáveis (`QM-XX-N`), uma calibração por nível de criticidade da demanda, declarado na ITS, os gatilhos que dizem que decisões de qualidade cada ITS precisa tomar e uma disciplina de exceção que distingue dívida deliberada de atalho silencioso. O `prime-core/coding-standards` responde *como a qualidade se parece aqui* — o catálogo fechado de slots de convenção (`CS-XX-N`) que todo projeto precisa ter decidido, os padrões do time por stack, versionados pela release, e as regras do projeto legado, das migrações e dos desvios, que vivem em ADRs. Nenhum dos dois aprova ou reprova nada: o enforcement pertence ao `prime-architect/code-review`, que transforma ambos em achados classificados e um veredito, sempre citando um ID em vez de uma preferência.

**A configuração do projeto.** O `docs/prime-config.md` responde o que é verdade sobre o projeto e as skills não podem adivinhar. Seu contrato — as cinco seções (Stack, Estrutura, Repositório de documentos, Comandos de verificação e Opções), as regras de precedência, o tratamento de divergências e o procedimento de bootstrap — pertence ao `prime-core/prime-config`. Cada skill lê a seção de que precisa, no passo que precisa dela, seguindo só a parte do contrato escrita para quem consome — `references/consumer-rules.md`. A configuração guarda fatos, nunca regras: quem eleva ou relaxa a régua num projeto é um ADR `Accepted`, e nenhum inegociável do core é dispensado em silêncio.

## Identificadores estáveis

| ID | Significado | Dono |
|---|---|---|
| `QM-XX-N` | Critério de qualidade | `prime-core/quality-model` |
| `CS-XX-N` | Slot de convenção | `prime-core/coding-standards` |
| `UC-NNN` · `UC-NNN/RN-N` · `UC-NNN/CA-N` | Caso de uso · uma de suas regras de negócio · um de seus critérios de aceite | `prime-architect/use-case` |
| `ITS-<story-id>` | Instruções Técnicas de Sistema de uma story | `prime-core/its-contract` |
| `ADR-NNN` | Decisão estrutural que sobrevive à story | `prime-core/adr-contract` |

Todo achado, toda exceção e todo elo de rastreabilidade cita um desses. Uma afirmação que não cita nada é uma preferência.

## Princípios de design das skills

- **Referenciar, nunca duplicar.** As skills de papel apontam para o `prime-core` em vez de copiar seus critérios. O padrão tem um único dono e um único endereço.
- **Evidência e julgamento permanecem separados.** Um mapa declara alcance, a revisão do código que leu e onde parou, e nunca recomenda; um veredito julga sobre um mapa e nunca o refaz.
- **Ambiguidade volta, não é presumida.** Se a ITS é ambígua, quem implementa não preenche as lacunas por conta própria — devolve perguntas ao arquiteto.
- **Qualidade como gate, não como opinião.** O code review valida contra critérios versionados do `quality-model` e do `coding-standards`, não contra preferências do momento.
- **Não preenchido é lacuna, não escolha livre.** Uma decisão que ninguém tomou é reportada, nunca improvisada.
- **Contexto sob demanda.** Nada entra no contexto antes do passo que o usa: skill, seção da configuração, documento ou código. O código da aplicação é localizado por busca e aberto no trecho de que o passo precisa — nunca um módulo inteiro por garantia, nunca de novo quando já foi lido e não mudou. Cada skill declara em que passo o código entra e quanto dele.

## Governança

- Mudanças no `prime-core` afetam todos os agentes e passam por um PR revisado pelo dono do modelo de qualidade.
- A camada do arquiteto (`prime-architect`) evolui com mais liberdade, desde que respeite a fundação. A exceção é o formato de caso de uso (`prime-architect/use-case`): embora viva na camada do arquiteto, é um contrato — duas skills escrevem contra ele (use-case-creator e use-case-extractor) e três leem contra ele (its-generator, code-review e impact-mapping), e uma mudança nas suas regras muda a escrita e a leitura ao mesmo tempo. Por isso passa pela mesma revisão do `prime-core`.
- IDs de critérios e de slots são estáveis e nunca renumerados; um ID aposentado permanece aposentado.
- **A versão é a release.** Catálogos, gatilhos e padrões do time são versionados juntos pela tag do repositório — a mesma que o `-Ref` do instalador usa e que o manifesto registra —, e nenhum arquivo carrega número de versão próprio. Acrescentar um critério, um gatilho ou um slot, ou mudar um valor de padrão, sobe a versão menor; aposentar ou reclassificar sobe a maior.
- A release que vale para um projeto é a instalada. Uma release nova só o alcança quando ele a instala, e a diferença dos padrões entre as duas tags é o que ele decide como migrar.
- **O histórico do padrão é o controle de versão.** O PR de governança é o registro de cada evolução; o repositório deliberadamente não mantém um changelog paralelo, para que dois históricos não se descolem.

## Como contribuir

- Abra um PR contra a `main`. Qualquer coisa que toque o `prime-core` ou o `prime-architect/use-case` precisa da revisão do dono do modelo de qualidade.
- Mantenha o texto normativo na skill que é dona dele e referencie a partir de todo o resto.
- **Os dois adapters do Jarvis são cópias literais deliberadas** — alterar um é alterar os dois, no mesmo commit. O [`adapters/README.md`](adapters/README.md) explica o porquê e traz o comando de diff que verifica isso.
- Ao adicionar, mover ou remover um arquivo, atualize a seção [Estrutura do repositório](#estrutura-do-repositório) no mesmo commit.

## Licença

[GNU Affero General Public License v3.0](LICENSE).

---

*Apex Prime — a qualidade vem primeiro.*

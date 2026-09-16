# Apex Prime

**Plataforma de skills para agentes de engenharia — entregando soluções no mais alto padrão, do entendimento da demanda ao deploy.**

[![Licença: AGPL v3](https://img.shields.io/badge/Licen%C3%A7a-AGPL%20v3-blue.svg)](LICENSE)

O Apex Prime é a fonte única de verdade dos padrões de qualidade, convenções e fluxos de trabalho que guiam os agentes de IA do time ao longo de todo o ciclo de entrega. Ele transforma o nosso processo — **o Arquiteto de Soluções entende a demanda e cria a ITS → o Dev implementa → o Arquiteto revisa e valida → a pipeline leva ao deploy** — em uma arquitetura de skills com fronteiras explícitas, na qual cada papel opera com o contexto certo e todos respondem ao mesmo padrão.

## Sumário

- [Por que existe](#por-que-existe)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Instalação](#instalação)
- [Primeiros passos](#primeiros-passos)
- [Montagem dos agentes](#montagem-dos-agentes)
- [Status de autoria](#status-de-autoria)
- [Os contratos do core](#os-contratos-do-core)
- [Identificadores estáveis](#identificadores-estáveis)
- [Princípios de design das skills](#princípios-de-design-das-skills)
- [Governança](#governança)
- [Como contribuir](#como-contribuir)
- [Licença](#licença)

## Por que existe

Quando os padrões de qualidade vivem espalhados — na cabeça das pessoas, em documentos soltos, duplicados entre ferramentas — eles divergem. O dev implementa contra uma versão do padrão, a revisão cobra outra, e o atrito aparece exatamente onde o processo deveria dar fluidez. O Apex Prime resolve isso com dois princípios:

1. **Fundação única.** O modelo de qualidade, as convenções de código, o contrato da ITS e o contrato de configuração do projeto têm um único dono e um único endereço: a camada `prime-core`. Todo agente consome a mesma fundação — atualize o padrão uma vez, e ele se atualiza para todos.
2. **Fronteiras por papel.** Cada agente carrega apenas as camadas do seu papel mais a fundação. O agente do dev não escreve a ITS; o agente do arquiteto não implementa. Os gates do fluxo deixam de ser convenção e passam a ser arquitetura.

## Estrutura do repositório

```
apex-prime-skills/
├── README.md
├── LICENSE                                 # AGPL-3.0
├── install.ps1                             # bootstrap: clona a versão pedida e chama o instalador
├── scripts/
│   └── Install-ApexPrime.ps1               # instala e desinstala a camada Jarvis
├── adapters/                               # prompt de entrada por plataforma
│   ├── README.md                           # regras dos adapters (os arquivos do Jarvis são cópias deliberadas)
│   ├── claude-code/
│   │   ├── jarvis.md                       # prompt de entrada do arquiteto
│   │   └── friday.md                       # [stub] prompt de entrada do dev
│   └── copilot/
│       ├── jarvis.agent.md
│       └── friday.agent.md                 # [stub]
├── prime-core/                             # fundação — consumida por TODOS os agentes
│   ├── quality-model/
│   │   ├── SKILL.md                        # o que é "bom": as oito lentes, os níveis, a disciplina de exceção
│   │   └── references/
│   │       └── quality-criteria.md         # o catálogo versionado de critérios (QM-XX-N)
│   ├── coding-standards/
│   │   ├── SKILL.md                        # como o bom se parece aqui: classes de aplicação, registro de legado, migrações
│   │   └── references/
│   │       ├── convention-slots.md         # o catálogo fechado de slots (CS-XX-N)
│   │       └── defaults-java.md            # valores padrão do time para a stack Java
│   ├── prime-config/
│   │   ├── SKILL.md                        # contrato do docs/prime-config.md: seções, pontos de override, precedência, bootstrap
│   │   └── references/
│   │       └── prime-config-template.md    # o template canônico de configuração do projeto
│   ├── use-case/
│   │   ├── SKILL.md                        # o formato de caso de uso: regras de qualidade, regras de delta, marcadores de incerteza
│   │   └── references/
│   │       └── use-case-template.md
│   └── its-contract/
│       ├── SKILL.md                        # o formato da ITS, o nível de detalhe e a fronteira com os ADRs
│       └── templates/
│           ├── its-template.md             # a ITS canônica que o arquiteto escreve e o dev consome
│           └── adr-template.md             # os registros de decisão que uma ITS referencia
├── prime-architect/                        # camada do Arquiteto de Soluções ("Jarvis Skills")
│   ├── use-case-creator/
│   │   └── SKILL.md                        # como criar e atualizar casos de uso
│   ├── use-case-extractor/
│   │   └── SKILL.md                        # engenharia reversa para criar casos de uso
│   ├── impact-mapping/
│   │   ├── SKILL.md                        # o que uma mudança alcança: evidência ancorada, nunca um veredito
│   │   └── checklists/
│   │       └── impact-map-checklist.md
│   ├── feasibility-analysis/
│   │   ├── SKILL.md                        # julga uma demanda contra o sistema, antes de qualquer especificação
│   │   └── checklists/
│   │       └── feasibility-checklist.md
│   ├── its-generator/
│   │   ├── SKILL.md                        # como escrever a ITS usando o contrato do core
│   │   └── checklists/
│   │       └── its-checklist.md
│   └── code-review/
│       ├── SKILL.md                        # roteiro de revisão: valida a implementação contra a ITS + os padrões do core
│       └── checklists/
│           └── review-checklist.md
└── prime-dev/                              # camada do Dev ("Friday Skills") — STUBS, a serem escritos
    ├── its-implementation/
    │   └── SKILL.md                        # [stub] como ler a ITS, planejar e implementar seguindo o core
    ├── testing/
    │   └── SKILL.md                        # [stub] padrão de testes exigido antes do PR
    └── pr-preparation/
        └── SKILL.md                        # [stub] como preparar o PR para a revisão e a pipeline do Azure
```

Toda skill é um diretório com um `SKILL.md` cujo frontmatter traz `name` e `description`. As skills do core mantêm seu material normativo em `references/` ou `templates/`; as skills de papel mantêm suas listas operacionais em `checklists/`.

## Instalação

O [`scripts/Install-ApexPrime.ps1`](scripts/Install-ApexPrime.ps1) achata `prime-core` + `prime-architect` em um único diretório de skills, instala o adapter da plataforma e grava um manifesto com o hash de cada arquivo. O recorte é estrutural: a camada `prime-dev` e os adapters da Friday não são lidos pelo instalador.

### Onde cada plataforma descobre as skills

| Caminho | Claude Code | Copilot |
|---|---|---|
| `.claude/skills/<skill>/SKILL.md` | sim | sim |
| `.github/skills/<skill>/SKILL.md` | não | sim |
| `~/.claude/skills/<skill>/SKILL.md` | sim | sim |
| `~/.copilot/skills/<skill>/SKILL.md` | não | sim |
| `.claude/commands/jarvis.md` (`/jarvis`) | sim | não |
| `.github/agents/jarvis.agent.md` | não | sim |

O `.claude/skills/` é lido pelas duas plataformas — é por isso que `-Target both` instala a carga **uma única vez**, ali, e não em dois lugares: duas cópias das mesmas skills registrariam nomes duplicados no Copilot.

### Parâmetros

`-Target` escolhe o formato: `copilot` (padrão) usa `.github`/`~/.copilot`, `claude` usa `.claude`, e `both` instala as skills em `.claude` mais os dois adapters. O padrão é Copilot porque é o formato que não deixa rastro de outra ferramenta em um repositório corporativo; quem usa Claude Code precisa de `-Target both`.

`-Scope` escolhe o alcance: `user` (padrão) instala no perfil e não toca em repositório nenhum; `project` instala na raiz de `-Destination`, para ser commitado.

### Uso

Sempre confira antes, com `-WhatIf`:

```powershell
.\scripts\Install-ApexPrime.ps1 -WhatIf
```

Instalar no perfil, formato Copilot:

```powershell
.\scripts\Install-ApexPrime.ps1
```

Instalar no perfil servindo as duas plataformas:

```powershell
.\scripts\Install-ApexPrime.ps1 -Target both
```

Vendorizar em um projeto, para commitar:

```powershell
.\scripts\Install-ApexPrime.ps1 -Scope project -Destination C:\repos\meu-projeto
```

Desinstalar:

```powershell
.\scripts\Install-ApexPrime.ps1 -Uninstall -Target both
```

### Sem clonar o repositório

O [`install.ps1`](install.ps1) baixa a versão pedida em um diretório temporário, chama o instalador e limpa o temporário. São dois passos, deliberadamente — não há one-liner com `iex`:

```powershell
irm https://raw.githubusercontent.com/abatistar/apex-prime-skills/main/install.ps1 -OutFile install.ps1
```

```powershell
.\install.ps1 -Ref v1.0.0 -Target both
```

O `-Ref` aceita tag ou branch, e a tag é o que se deve usar: `main` instala o topo do branch, que é justamente o que o versionamento existe para evitar.

### Reinstalação e edições locais

O manifesto (`apex-prime.json`) é o que torna a reinstalação segura. Arquivo cujo hash divergiu do gravado foi editado no destino e é **preservado**, com aviso, a menos que `-Force`. Skill removida em uma versão nova é podada. O `-Uninstall` remove exatamente o que o manifesto registra e nada além — arquivos que não vieram do Apex Prime ficam intactos.

> O instalador roda sob ConstrainedLanguage mode, o modo imposto por WDAC/AppLocker em Windows corporativo. Uma consequência: `-WhatIf` funciona, `-Confirm` não.

## Primeiros passos

Este repositório guarda as skills, não os projetos em que elas se aplicam. Configurá-lo significa tornar as camadas certas visíveis para um agente e, depois, dar ao projeto-alvo um arquivo de configuração.

**1. Instale a camada do seu papel.** Veja [Instalação](#instalação). O instalador cobre o arquiteto: expõe `prime-core` + `prime-architect` e instala o adapter da plataforma — no Claude Code o `jarvis.md`, cuja linha final `$ARGUMENTS` recebe a tarefa; no Copilot o `jarvis.agent.md`, como agente customizado. Os adapters roteiam para as skills; nunca repetem os procedimentos delas. Nunca exponha as duas camadas de papel ao mesmo agente; veja [Montagem dos agentes](#montagem-dos-agentes).

**2. Faça o bootstrap da configuração do projeto.** Toda execução, em qualquer camada, começa lendo o `docs/prime-config.md` do *projeto-alvo* — stack, estrutura, convenções, registro de áreas, overrides de slots, localização dos documentos, comandos de verificação. O template canônico é o [`prime-core/prime-config/references/prime-config-template.md`](prime-core/prime-config/references/prime-config-template.md), e o procedimento que o preenche — detectar a stack, percorrer o catálogo de slots, classificar as áreas, elicitar o que o código não conta — pertence ao [`prime-core/prime-config`](prime-core/prime-config/SKILL.md). Peça ao agente arquiteto que o execute; o resultado é um rascunho que um humano valida antes do commit.

A partir daí, toque a pipeline: peça ao arquiteto para documentar como um módulo sem documentação se comporta hoje, para escrever os casos de uso de uma story, para gerar a ITS correspondente e, mais tarde, para revisar a implementação que voltar.

## Montagem dos agentes

| Agente | Camadas carregadas | Responsabilidade no fluxo |
|---|---|---|
| **Jarvis** (Arquiteto) | `prime-core` + `prime-architect` | Entende a demanda, documenta os casos de uso, cria a ITS, faz o code review |
| **Friday** (Dev) | `prime-core` + `prime-dev` | Implementa a partir da ITS, testa e prepara o PR |

> Regra de ouro: um agente **nunca** carrega a camada do outro papel. O Jarvis nunca carrega `prime-dev`; a Friday nunca carrega `prime-architect`.

Duas capacidades do arquiteto ficam fora dessa linha e são invocadas, nunca obrigatórias: **impact-mapping**, que produz evidência sobre o que uma mudança alcançaria, e **feasibility-analysis**, que julga uma demanda contra o sistema antes que ela entre em especificação. Nenhuma das duas é um gate; ambas alimentam a mesma pipeline.

## Status de autoria

| Camada | Status |
|---|---|
| `prime-core` | Escrita — quality-model (catálogo de critérios v1.0), coding-standards (catálogo de slots v1.0), prime-config, use-case, its-contract |
| `prime-architect` | Escrita — use-case-creator, use-case-extractor, impact-mapping, feasibility-analysis, its-generator, code-review |
| `prime-dev` | **Stubs.** As três skills e os adapters da Friday são placeholders para que a estrutura de camadas e as referências cruzadas continuem válidas |

O Jarvis, portanto, é operável de ponta a ponta (documentação → ITS → revisão); a Friday depende da camada de dev.

## Os contratos do core

**A ITS.** A peça central da plataforma. O formato da ITS (Instrução de Trabalho de Software) vive em `prime-core/its-contract` e é consumido pelos dois lados: o arquiteto escreve contra ele, o dev lê a partir dele. Uma mudança no contrato atualiza a escrita e a leitura ao mesmo tempo, eliminando o descolamento entre especificação e implementação. O mesmo contrato é dono da fronteira com os ADRs — uma decisão que sobrevive à story é referenciada por uma ITS, nunca embutida nela.

**O padrão: dois contratos, um único ponto de enforcement.** O `prime-core/quality-model` responde *o que é qualidade* — oito lentes, um piso inegociável com IDs estáveis (`QM-XX-N`) e uma disciplina de exceção que distingue dívida deliberada de atalho silencioso. O `prime-core/coding-standards` responde *como a qualidade se parece aqui* — o catálogo fechado de slots de convenção (`CS-XX-N`) que todo projeto precisa ter decidido, os padrões do time por stack e o registro de áreas legadas. Nenhum dos dois aprova ou reprova nada: o enforcement pertence ao `prime-architect/code-review`, que transforma ambos em achados classificados e um veredito, sempre citando um ID em vez de uma preferência.

**A configuração do projeto.** O `docs/prime-config.md` responde o que é verdade sobre o projeto e as skills não podem adivinhar. Seu contrato — seções obrigatórias, a lista fechada de pontos de override, as regras de precedência, o tratamento de divergências e o procedimento de bootstrap — pertence ao `prime-core/prime-config`; o Passo 0 de cada skill referencia esse contrato em vez de redescrever o procedimento. A configuração pode **elevar** a régua; nunca pode revogar em silêncio um inegociável do core.

## Identificadores estáveis

| ID | Significado | Dono |
|---|---|---|
| `QM-XX-N` | Critério de qualidade | `prime-core/quality-model` |
| `CS-XX-N` | Slot de convenção | `prime-core/coding-standards` |
| `UC-NNN` · `UC-NNN/CA-N` | Caso de uso · um de seus critérios de aceite | `prime-core/use-case` |
| `ITS-<story-id>` | Instrução de trabalho de uma story | `prime-core/its-contract` |
| ADR | Decisão que sobrevive à story | `prime-core/its-contract` |

Todo achado, toda exceção e todo elo de rastreabilidade cita um desses. Uma afirmação que não cita nada é uma preferência.

## Princípios de design das skills

- **Referenciar, nunca duplicar.** As skills de papel apontam para o `prime-core` em vez de copiar seus critérios. O padrão tem um único dono e um único endereço.
- **Evidência e julgamento permanecem separados.** Um mapa declara alcance e nunca recomenda; um veredito julga sobre um mapa e nunca o refaz.
- **Ambiguidade volta, não é presumida.** Se a ITS é ambígua, o agente do dev não preenche as lacunas por conta própria — devolve perguntas ao arquiteto.
- **Qualidade como gate, não como opinião.** O code review valida contra critérios versionados do `quality-model` e do `coding-standards`, não contra preferências do momento.
- **Não preenchido é lacuna, não escolha livre.** Uma decisão que ninguém tomou é reportada, nunca improvisada.

## Governança

- Mudanças no `prime-core` afetam todos os agentes e passam por um PR revisado pelo dono do modelo de qualidade.
- As camadas de papel (`prime-architect`, `prime-dev`) evoluem com mais liberdade, desde que respeitem a fundação.
- IDs de critérios e de slots são estáveis e nunca renumerados; um ID aposentado permanece aposentado.
- Os catálogos carregam a própria linha de versão — `quality-criteria.md` e `convention-slots.md`, ambos v1.0. Suba a versão ali quando o padrão mudar.
- **O histórico do padrão é o controle de versão.** O PR de governança é o registro de cada evolução; o repositório deliberadamente não mantém um changelog paralelo, para que dois históricos não se descolem.

## Como contribuir

- Abra um PR contra a `main`. Qualquer coisa que toque o `prime-core` precisa da revisão do dono do modelo de qualidade.
- Mantenha o texto normativo na skill que é dona dele e referencie a partir de todo o resto.
- **Os dois adapters do Jarvis são cópias literais deliberadas** — alterar um é alterar os dois, no mesmo commit. O [`adapters/README.md`](adapters/README.md) explica o porquê e traz o comando de diff que verifica isso.
- Ao adicionar, mover ou remover um arquivo, atualize a seção [Estrutura do repositório](#estrutura-do-repositório) no mesmo commit.

## Licença

[GNU Affero General Public License v3.0](LICENSE).

---

*Apex Prime — a qualidade vem primeiro.*

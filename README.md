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
├── install.ps1                             # instala e desinstala os perfis Jarvis, Friday e Full
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
│   │   ├── SKILL.md                        # o que é "bom": as dez lentes, os níveis, a calibração por criticidade, a disciplina de exceção
│   │   └── references/
│   │       ├── quality-criteria.md         # o catálogo versionado de critérios (QM-XX-N) e os perfis de criticidade
│   │       └── quality-triggers.md         # os gatilhos que tornam critérios em decisões que a ITS precisa tomar
│   ├── coding-standards/
│   │   ├── SKILL.md                        # como o bom se parece aqui: classes de aplicação, registro de legado, padrões versionados, migrações
│   │   └── references/
│   │       ├── convention-slots.md         # o catálogo fechado de slots (CS-XX-N)
│   │       └── defaults-java.md            # valores padrão do time para a stack Java, versionados
│   ├── prime-config/
│   │   ├── SKILL.md                        # contrato do docs/prime-config.md: seções, pontos de override, precedência, bootstrap
│   │   └── references/
│   │       └── prime-config-template.md    # o template canônico de configuração do projeto
│   └── its-contract/
│       ├── SKILL.md                        # o formato da ITS, o nível de detalhe e a fronteira com os ADRs
│       └── templates/
│           ├── its-template.md             # a ITS canônica que o arquiteto escreve e o dev consome
│           └── adr-template.md             # os registros de decisão que uma ITS referencia
├── prime-architect/                        # camada do Arquiteto de Soluções ("Jarvis Skills")
│   ├── use-case/
│   │   ├── SKILL.md                        # o formato de caso de uso: regras de qualidade, regras de delta, marcadores de incerteza
│   │   └── references/
│   │       └── use-case-template.md
│   ├── use-case-creator/
│   │   ├── SKILL.md                        # como criar e atualizar casos de uso
│   │   └── checklists/
│   │       └── creation-checklist.md
│   ├── use-case-extractor/
│   │   ├── SKILL.md                        # engenharia reversa para criar casos de uso
│   │   └── checklists/
│   │       └── extraction-checklist.md
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
    ├── pr-preparation/
    │   └── SKILL.md                        # [stub] como preparar o PR para a revisão e a pipeline do Azure
    └── troubleshooting/
        └── SKILL.md                        # [stub] localiza a causa de um problema já existente e entrega o diagnóstico
```

Toda skill é um diretório com um `SKILL.md` cujo frontmatter traz `name` e `description`. As skills do core mantêm seu material normativo em `references/` ou `templates/`; as skills de papel mantêm suas listas operacionais em `checklists/`.

## Instalação

O [`install.ps1`](install.ps1) achata as camadas do perfil escolhido em um único diretório de skills, instala o adapter de cada papel no formato do agente e grava um manifesto com o hash de cada arquivo. Rodando de dentro de um clone, instala o próprio clone; baixado avulso, clona a versão pedida em um diretório temporário — veja [Sem clonar o repositório](#sem-clonar-o-repositório).

### Parâmetros

`-Perfil` escolhe o que é instalado. O recorte é estrutural: camada fora do perfil não é lida.

| Perfil | Camadas | Adapters |
|---|---|---|
| `Full` (padrão) | `prime-core` + `prime-architect` + `prime-dev` | Jarvis e Friday |
| `Jarvis` | `prime-core` + `prime-architect` | Jarvis |
| `Friday` | `prime-core` + `prime-dev` | Friday |

No `Full`, as skills dos dois papéis dividem um único diretório e a plataforma as expõe a qualquer agente: a [regra de ouro](#montagem-dos-agentes) passa a ser sustentada pelos adapters, que declaram a fronteira de cada papel, e não pelo recorte. Onde a fronteira precisa ser estrutural, instale `Jarvis` ou `Friday`.

`-Local` escolhe o alcance: `usuario` (padrão) instala no perfil do usuário e não toca em repositório nenhum; um caminho instala na raiz daquele projeto, para ser commitado.

`-Agente` escolhe o formato: `copilot` (padrão) ou `claude`. O padrão é Copilot porque é o formato que não deixa rastro de outra ferramenta em um repositório corporativo.

| | `-Agente copilot` | `-Agente claude` |
|---|---|---|
| Skills no projeto | `.github/skills/` | `.claude/skills/` |
| Skills no usuário | `~/.copilot/skills/` | `~/.claude/skills/` |
| Adapters no projeto | `.github/agents/<papel>.agent.md` | `.claude/commands/<papel>.md` |
| Adapters no usuário | `~/.copilot/agents/<papel>.agent.md` | `~/.claude/commands/<papel>.md` |

O Copilot também lê `.claude/skills/` e `~/.claude/skills/`. Duas consequências: com `-Agente claude` o Copilot enxerga as skills, só não os agentes; e as duas instalações no mesmo local registram cada skill em dobro no Copilot — o instalador avisa quando encontra a outra e sugere manter uma só.

### Uso

Sempre confira antes, com `-WhatIf`:

```powershell
.\install.ps1 -WhatIf
```

Instalar no perfil do usuário — perfil `Full`, formato Copilot:

```powershell
.\install.ps1
```

Instalar no perfil do usuário para o Claude Code (`/jarvis`, `/friday`):

```powershell
.\install.ps1 -Agente claude
```

Vendorizar só a camada do arquiteto em um projeto, para commitar:

```powershell
.\install.ps1 -Perfil Jarvis -Local C:\repos\meu-projeto
```

Desinstalar — remove o que estiver instalado naquele local e agente, qualquer que seja o perfil:

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

O manifesto (`apex-prime.json`, na raiz do formato — `.github/`, `.claude/`, `~/.copilot/` ou `~/.claude/`) é o que torna a reinstalação segura. Arquivo cujo hash divergiu do gravado foi editado no destino e é **preservado**, com aviso; arquivo que já existia e não veio do Apex Prime também. `-Force` sobrescreve os dois. O que a instalação anterior trouxe e esta não traz — skill removida em uma versão nova, camada que saiu do perfil — é podado: trocar `Full` por `Jarvis` remove a camada `prime-dev` e o adapter do Friday. O `-Desinstalar` remove exatamente o que o manifesto registra e nada além.

Instalações feitas pela v1.0.0 são reconhecidas. A de `-Target both` gravava o manifesto em `.claude/` e o adapter do Copilot em `.github/agents/` (ou `~/.copilot/agents/`): reinstalar com `-Agente claude` a assume e remove esse adapter do Copilot. Para passar dela ao Copilot, rode antes `.\install.ps1 -Desinstalar -Agente claude`.

> O instalador roda sob ConstrainedLanguage mode, o modo imposto por WDAC/AppLocker em Windows corporativo. Uma consequência: `-WhatIf` funciona, `-Confirm` não.

## Primeiros passos

Este repositório guarda as skills, não os projetos em que elas se aplicam. Configurá-lo significa tornar as camadas certas visíveis para um agente e, depois, dar ao projeto-alvo um arquivo de configuração.

**1. Instale o perfil do seu papel.** Veja [Instalação](#instalação). O instalador expõe as camadas do perfil e instala o adapter de cada papel no formato do agente — no Claude Code o `jarvis.md` e o `friday.md`, cuja linha final `$ARGUMENTS` recebe a tarefa; no Copilot o `jarvis.agent.md` e o `friday.agent.md`, como agentes customizados. Os adapters roteiam para as skills; nunca repetem os procedimentos delas. O perfil padrão, `Full`, traz os dois papéis; quem atua em um só instala `Jarvis` ou `Friday` e mantém a fronteira estrutural — veja [Montagem dos agentes](#montagem-dos-agentes).

**2. Faça o bootstrap da configuração do projeto.** Toda execução, em qualquer camada, começa lendo o `docs/prime-config.md` do *projeto-alvo* — stack, estrutura, convenções, registro de áreas, overrides de slots, localização dos documentos, comandos de verificação. O template canônico é o [`prime-core/prime-config/references/prime-config-template.md`](prime-core/prime-config/references/prime-config-template.md), e o procedimento que o preenche — detectar a stack, percorrer o catálogo de slots, classificar as áreas, elicitar o que o código não conta — pertence ao [`prime-core/prime-config`](prime-core/prime-config/SKILL.md). Peça ao agente arquiteto que o execute; o resultado é um rascunho que um humano valida antes do commit.

A partir daí, toque a pipeline: peça ao arquiteto para documentar como um módulo sem documentação se comporta hoje, para escrever os casos de uso de uma story, para gerar a ITS correspondente e, mais tarde, para revisar a implementação que voltar.

## Montagem dos agentes

| Agente | Camadas carregadas | Responsabilidade no fluxo |
|---|---|---|
| **Jarvis** (Arquiteto) | `prime-core` + `prime-architect` | Entende a demanda, documenta os casos de uso, cria a ITS, faz o code review |
| **Friday** (Dev) | `prime-core` + `prime-dev` | Implementa a partir da ITS, testa, prepara o PR e diagnostica problemas já existentes |

> Regra de ouro: um agente **nunca** carrega a camada do outro papel. O Jarvis nunca carrega `prime-dev`; o Friday nunca carrega `prime-architect`.

Duas capacidades do arquiteto ficam fora dessa linha e são invocadas, nunca obrigatórias: **impact-mapping**, que produz evidência sobre o que uma mudança alcançaria, e **feasibility-analysis**, que julga uma demanda contra o sistema antes que ela entre em especificação. Nenhuma das duas é um gate; ambas alimentam a mesma pipeline. Do lado do dev, o **troubleshooting** do Friday também é invocado fora dessa linha: localiza a causa de um problema já existente e entrega o diagnóstico, nunca a correção.

## Status de autoria

| Camada | Status |
|---|---|
| `prime-core` | Escrita — quality-model (catálogo de critérios e gatilhos), coding-standards (catálogo de slots e padrões Java), prime-config, its-contract |
| `prime-architect` | Escrita — use-case (formato), use-case-creator, use-case-extractor, impact-mapping, feasibility-analysis, its-generator, code-review |
| `prime-dev` | **Stubs.** As quatro skills e os adapters do Friday são placeholders para que a estrutura de camadas e as referências cruzadas continuem válidas |

O Jarvis, portanto, é operável de ponta a ponta (documentação → ITS → revisão); o Friday depende da camada de dev.

## Os contratos do core

**A ITS.** A peça central da plataforma. O formato da ITS (Instrução de Trabalho de Software) vive em `prime-core/its-contract` e é consumido pelos dois lados: o arquiteto escreve contra ele, o dev lê a partir dele. Uma mudança no contrato atualiza a escrita e a leitura ao mesmo tempo, eliminando o descolamento entre especificação e implementação. O mesmo contrato é dono da fronteira com os ADRs — uma decisão que sobrevive à story é referenciada por uma ITS, nunca embutida nela.

**O padrão: dois contratos, um único ponto de enforcement.** O `prime-core/quality-model` responde *o que é qualidade* — dez lentes, um piso inegociável com IDs estáveis (`QM-XX-N`), uma calibração declarada por nível de criticidade, os gatilhos que dizem que decisões de qualidade cada ITS precisa tomar e uma disciplina de exceção que distingue dívida deliberada de atalho silencioso. O `prime-core/coding-standards` responde *como a qualidade se parece aqui* — o catálogo fechado de slots de convenção (`CS-XX-N`) que todo projeto precisa ter decidido, os padrões do time por stack, versionados e fixados por projeto, e o registro de áreas legadas. Nenhum dos dois aprova ou reprova nada: o enforcement pertence ao `prime-architect/code-review`, que transforma ambos em achados classificados e um veredito, sempre citando um ID em vez de uma preferência.

**A configuração do projeto.** O `docs/prime-config.md` responde o que é verdade sobre o projeto e as skills não podem adivinhar. Seu contrato — seções obrigatórias, a lista fechada de pontos de override, as regras de precedência, o tratamento de divergências e o procedimento de bootstrap — pertence ao `prime-core/prime-config`; o Passo 0 de cada skill referencia esse contrato em vez de redescrever o procedimento. A configuração pode **elevar** a régua; nunca pode revogar em silêncio um inegociável do core.

## Identificadores estáveis

| ID | Significado | Dono |
|---|---|---|
| `QM-XX-N` | Critério de qualidade | `prime-core/quality-model` |
| `CS-XX-N` | Slot de convenção | `prime-core/coding-standards` |
| `UC-NNN` · `UC-NNN/RN-N` · `UC-NNN/CA-N` | Caso de uso · uma de suas regras de negócio · um de seus critérios de aceite | `prime-architect/use-case` |
| `ITS-<story-id>` | Instrução de trabalho de uma story | `prime-core/its-contract` |
| ADR | Decisão que sobrevive à story | `prime-core/its-contract` |

Todo achado, toda exceção e todo elo de rastreabilidade cita um desses. Uma afirmação que não cita nada é uma preferência.

## Princípios de design das skills

- **Referenciar, nunca duplicar.** As skills de papel apontam para o `prime-core` em vez de copiar seus critérios. O padrão tem um único dono e um único endereço.
- **Evidência e julgamento permanecem separados.** Um mapa declara alcance, a revisão do código que leu e onde parou, e nunca recomenda; um veredito julga sobre um mapa e nunca o refaz.
- **Ambiguidade volta, não é presumida.** Se a ITS é ambígua, o agente do dev não preenche as lacunas por conta própria — devolve perguntas ao arquiteto.
- **Qualidade como gate, não como opinião.** O code review valida contra critérios versionados do `quality-model` e do `coding-standards`, não contra preferências do momento.
- **Não preenchido é lacuna, não escolha livre.** Uma decisão que ninguém tomou é reportada, nunca improvisada.

## Governança

- Mudanças no `prime-core` afetam todos os agentes e passam por um PR revisado pelo dono do modelo de qualidade.
- As camadas de papel (`prime-architect`, `prime-dev`) evoluem com mais liberdade, desde que respeitem a fundação. A exceção é o formato de caso de uso (`prime-architect/use-case`): embora viva na camada do arquiteto, é um contrato — duas skills escrevem contra ele e duas validam contra ele, e uma mudança nas suas regras muda a escrita e a leitura ao mesmo tempo. Por isso passa pela mesma revisão do `prime-core`.
- IDs de critérios e de slots são estáveis e nunca renumerados; um ID aposentado permanece aposentado.
- **A versão é a release.** Catálogos, gatilhos e padrões do time são versionados juntos pela tag do repositório — a mesma que o `-Ref` do instalador usa e que o manifesto registra —, e nenhum arquivo carrega número de versão próprio. Acrescentar um critério, um gatilho ou um slot, ou mudar um valor de padrão, sobe a versão menor; aposentar ou reclassificar sobe a maior.
- Cada projeto fixa no `docs/prime-config.md` a release que segue. Uma release nova só alcança um projeto quando ele a adota, e a diferença dos padrões entre as duas tags é o que ele decide como migrar.
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

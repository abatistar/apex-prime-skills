# Apex Prime

<<<<<<< HEAD
**Plataforma de skills para agents de engenharia — entregando soluções no padrão máximo, do entendimento da demanda ao deploy.**

O Apex Prime é a fonte única de verdade dos padrões de qualidade, convenções e fluxos de trabalho que guiam os agents de IA do time ao longo de todo o ciclo de entrega. Ele transforma o nosso processo — **Arquiteto de Soluções entende a demanda e cria o ITS → Dev implementa → Arquiteto revisa e valida → pipeline conclui até o deploy** — em uma arquitetura de skills com fronteiras explícitas, onde cada papel opera com o contexto certo e todos respondem ao mesmo padrão.

## Por que existe

Quando padrões de qualidade vivem espalhados — na cabeça das pessoas, em documentos soltos, duplicados entre ferramentas — eles divergem. O dev implementa contra uma versão do padrão, o review cobra outra, e o atrito aparece exatamente onde o processo deveria dar fluidez. O Apex Prime resolve isso com dois princípios:

1. **Fundação única.** O modelo de qualidade, as convenções de código e o contrato do ITS têm um dono e um endereço únicos: a camada `prime-core`. Todos os agents consomem a mesma fundação — atualizou o padrão, atualizou para todos.
2. **Fronteiras por papel.** Cada agent carrega apenas a camada do seu papel mais a fundação. O agent do dev não escreve ITS; o agent do arquiteto não implementa. Os gates do fluxo deixam de ser convenção e viram arquitetura.

## Arquitetura em camadas
=======
**Skills platform for engineering agents — delivering solutions at the highest standard, from demand understanding to deploy.**

Apex Prime is the single source of truth for the quality standards, conventions, and workflows that guide the team's AI agents across the entire delivery cycle. It turns our process — **Solution Architect understands the demand and creates the ITS → Dev implements → Architect reviews and validates → pipeline takes it to deploy** — into a skills architecture with explicit boundaries, where each role operates with the right context and everyone answers to the same standard.

## Why it exists

When quality standards live scattered — in people's heads, in loose documents, duplicated across tools — they diverge. The dev implements against one version of the standard, the review demands another, and friction appears exactly where the process should provide flow. Apex Prime solves this with two principles:

1. **Single foundation.** The quality model, the coding conventions, and the ITS contract have a single owner and a single address: the `prime-core` layer. Every agent consumes the same foundation — update the standard once, and it updates for everyone.
2. **Boundaries per role.** Each agent loads only its role's layer plus the foundation. The dev's agent doesn't write the ITS; the architect's agent doesn't implement. The workflow gates stop being convention and become architecture.

## Layered architecture
>>>>>>> 6f8ef54 (initial commit)

```
apex-prime-skills/
├── README.md
├── CHANGELOG.md
├── prime-config.example.md
<<<<<<< HEAD
├── adapters/                     # configuração dos agents por plataforma
│   ├── claude-code/
│   └── copilot/
├── prime-core/                   # fundação — consumida por TODOS os agents
│   ├── quality-model/
│   │   └── SKILL.md              # modelo de qualidade: critérios, o que é inegociável
│   ├── coding-standards/
│   │   └── SKILL.md              # convenções de código, nomenclatura, padrões de arquitetura
=======
├── adapters/                     # agent configuration per platform
│   ├── claude-code/
│   └── copilot/
├── prime-core/                   # foundation — consumed by ALL agents
│   ├── quality-model/
│   │   └── SKILL.md              # quality model: criteria, what is non-negotiable
│   ├── coding-standards/
│   │   └── SKILL.md              # coding conventions, naming, architecture patterns
>>>>>>> 6f8ef54 (initial commit)
│   ├── use-case/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── use-case-template.md
│   └── its-contract/
<<<<<<< HEAD
│       ├── SKILL.md              # o formato do ITS: seções obrigatórias, nível de detalhe
│       └── templates/
│           └── its-template.md   # o template canônico que arquiteto escreve e dev consome
├── prime-docs/                   # camada de documentação
│   ├── use-case-creator/
│   │   └── SKILL.md              # como criar e atualizar casos de uso
│   └── use-case-extractor/
│       └── SKILL.md              # engenharia reversa para criar casos de uso
├── prime-architect/              # camada do Arquiteto de Soluções ("Dr. Skills")
│   ├── its-generator/
│   │   └── SKILL.md              # como escrever o ITS usando o contrato do core
│   └── code-review/
│       ├── SKILL.md              # roteiro de review: valida implementação contra ITS + quality-model
│       └── checklists/
│           └── review-checklist.md
└── prime-dev/                    # camada do Dev ("Leo Skills")
    ├── its-implementation/
    │   └── SKILL.md              # como ler o ITS, planejar e implementar seguindo o core
    ├── testing/
    │   └── SKILL.md              # padrão de testes exigido antes do PR
    └── pr-preparation/
        └── SKILL.md              # como preparar o PR para o review e a pipeline do Azure
```

### Montagem dos agents

| Agent | Camadas carregadas | Responsabilidade no fluxo |
|---|---|---|
| **Arquiteto** | `prime-core` + `prime-architect` | Entende a demanda, cria o ITS, faz o code review |
| **Dev** | `prime-core` + `prime-dev` | Implementa a partir do ITS, testa e prepara o PR |

> Regra de ouro: um agent **nunca** carrega a camada do outro papel.

## O contrato do ITS

A peça central da plataforma. O formato do ITS vive no `prime-core` que é consumido pelos dois lados: o arquiteto escreve nele, o dev lê dele. Uma mudança no contrato atualiza a escrita e a leitura ao mesmo tempo, eliminando drift entre especificação e implementação.

## Princípios de design das skills

- **Referenciar, nunca duplicar.** Skills de papel apontam para o `prime-core` em vez de copiar seus critérios. O padrão tem um dono e um endereço únicos.
- **Ambiguidade volta, não se assume.** Se o ITS estiver ambíguo, o agent do dev não preenche lacunas por conta própria — ele devolve perguntas ao arquiteto.
- **Qualidade como gate, não como opinião.** O code review valida contra critérios versionados no `quality-model`, não contra preferências do momento.

## Governança

- Mudanças no `prime-core` afetam todos os agents e passam por PR revisado pelo dono do modelo de qualidade.
- As camadas de papel (`prime-architect`, `prime-dev`) evoluem com mais liberdade, desde que respeitem a fundação.
- O `CHANGELOG.md` do core registra toda evolução do padrão, para que o time saiba quando e por que ele mudou.

---

*Apex Prime — a qualidade vem primeiro.*
=======
│       ├── SKILL.md              # the ITS format: mandatory sections, level of detail
│       └── templates/
│           └── its-template.md   # the canonical template the architect writes and the dev consumes
├── prime-docs/                   # documentation layer
│   ├── use-case-creator/
│   │   └── SKILL.md              # how to create and update use cases
│   └── use-case-extractor/
│       └── SKILL.md              # reverse engineering to create use cases
├── prime-architect/              # Solution Architect layer ("Dr. Skills")
│   ├── its-generator/
│   │   └── SKILL.md              # how to write the ITS using the core contract
│   └── code-review/
│       ├── SKILL.md              # review script: validates implementation against ITS + quality-model
│       └── checklists/
│           └── review-checklist.md
└── prime-dev/                    # Dev layer ("Leo Skills")
    ├── its-implementation/
    │   └── SKILL.md              # how to read the ITS, plan, and implement following the core
    ├── testing/
    │   └── SKILL.md              # test standard required before the PR
    └── pr-preparation/
        └── SKILL.md              # how to prepare the PR for the review and the Azure pipeline
```

### Agent assembly

| Agent | Layers loaded | Responsibility in the workflow |
|---|---|---|
| **Architect** | `prime-core` + `prime-architect` | Understands the demand, creates the ITS, performs the code review |
| **Dev** | `prime-core` + `prime-dev` | Implements from the ITS, tests, and prepares the PR |

> Golden rule: an agent **never** loads the other role's layer.

## The ITS contract

The centerpiece of the platform. The ITS (Instrução de Trabalho de Software — Software Work Instruction) format lives in `prime-core` and is consumed by both sides: the architect writes to it, the dev reads from it. A change in the contract updates writing and reading at the same time, eliminating drift between specification and implementation.

## Skill design principles

- **Reference, never duplicate.** Role skills point to `prime-core` instead of copying its criteria. The standard has a single owner and a single address.
- **Ambiguity returns, it is not assumed.** If the ITS is ambiguous, the dev's agent does not fill the gaps on its own — it returns questions to the architect.
- **Quality as a gate, not as an opinion.** Code review validates against versioned criteria in the `quality-model`, not against preferences of the moment.

## Governance

- Changes to `prime-core` affect every agent and go through a PR reviewed by the quality model's owner.
- The role layers (`prime-architect`, `prime-dev`) evolve with more freedom, as long as they respect the foundation.
- The core's `CHANGELOG.md` records every evolution of the standard, so the team knows when and why it changed.

---

*Apex Prime — quality comes first.*
>>>>>>> 6f8ef54 (initial commit)

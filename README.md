# Apex Prime

**Plataforma de skills para agents de engenharia — entregando soluções no padrão máximo, do entendimento da demanda ao deploy.**

O Apex Prime é a fonte única de verdade dos padrões de qualidade, convenções e fluxos de trabalho que guiam os agents de IA do time ao longo de todo o ciclo de entrega. Ele transforma o nosso processo — **Arquiteto de Soluções entende a demanda e cria o ITS → Dev implementa → Arquiteto revisa e valida → pipeline conclui até o deploy** — em uma arquitetura de skills com fronteiras explícitas, onde cada papel opera com o contexto certo e todos respondem ao mesmo padrão.

## Por que existe

Quando padrões de qualidade vivem espalhados — na cabeça das pessoas, em documentos soltos, duplicados entre ferramentas — eles divergem. O dev implementa contra uma versão do padrão, o review cobra outra, e o atrito aparece exatamente onde o processo deveria dar fluidez. O Apex Prime resolve isso com dois princípios:

1. **Fundação única.** O modelo de qualidade, as convenções de código e o contrato do ITS têm um dono e um endereço únicos: a camada `prime-core`. Todos os agents consomem a mesma fundação — atualizou o padrão, atualizou para todos.
2. **Fronteiras por papel.** Cada agent carrega apenas a camada do seu papel mais a fundação. O agent do dev não escreve ITS; o agent do arquiteto não implementa. Os gates do fluxo deixam de ser convenção e viram arquitetura.

## Arquitetura em camadas

```
apex-prime-skills/
├── README.md
├── CHANGELOG.md
├── prime-config.example.md
├── adapters/                     # configuração dos agents por plataforma
│   ├── claude-code/
│   └── copilot/
├── prime-core/                   # fundação — consumida por TODOS os agents
│   ├── quality-model/
│   │   └── SKILL.md              # modelo de qualidade: critérios, o que é inegociável
│   ├── coding-standards/
│   │   └── SKILL.md              # convenções de código, nomenclatura, padrões de arquitetura
│   ├── use-case/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── use-case-template.md
│   └── its-contract/
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

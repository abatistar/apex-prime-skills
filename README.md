# Apex Prime

**Skills platform for engineering agents — delivering solutions at the highest standard, from demand understanding to deploy.**

Apex Prime is the single source of truth for the quality standards, conventions, and workflows that guide the team's AI agents across the entire delivery cycle. It turns our process — **Solution Architect understands the demand and creates the ITS → Dev implements → Architect reviews and validates → pipeline takes it to deploy** — into a skills architecture with explicit boundaries, where each role operates with the right context and everyone answers to the same standard.

## Why it exists

When quality standards live scattered — in people's heads, in loose documents, duplicated across tools — they diverge. The dev implements against one version of the standard, the review demands another, and friction appears exactly where the process should provide flow. Apex Prime solves this with two principles:

1. **Single foundation.** The quality model, the coding conventions, the ITS contract, and the project configuration contract have a single owner and a single address: the `prime-core` layer. Every agent consumes the same foundation — update the standard once, and it updates for everyone.
2. **Boundaries per role.** Each agent loads only its role's layer plus the foundation. The dev's agent doesn't write the ITS; the architect's agent doesn't implement. The workflow gates stop being convention and become architecture.

## Layered architecture

```
apex-prime-skills/
├── README.md
├── CHANGELOG.md
├── prime-config.example.md       # pointer to the canonical template (prime-core/prime-config)
├── adapters/                     # agent configuration per platform
│   ├── claude-code/
│   └── copilot/
├── prime-core/                   # foundation — consumed by ALL agents
│   ├── quality-model/
│   │   └── SKILL.md              # quality model: criteria, what is non-negotiable
│   ├── coding-standards/
│   │   └── SKILL.md              # coding conventions, naming, architecture patterns
│   ├── prime-config/
│   │   ├── SKILL.md              # contract for docs/prime-config.md: sections, precedence, divergence, bootstrap
│   │   └── references/
│   │       └── prime-config-template.md
│   ├── use-case/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── use-case-template.md
│   └── its-contract/
│       ├── SKILL.md              # the ITS format: mandatory sections, level of detail
│       └── templates/
│           └── its-template.md   # the canonical template the architect writes and the dev consumes
├── prime-docs/                   # documentation layer
│   ├── use-case-creator/
│   │   └── SKILL.md              # how to create and update use cases
│   └── use-case-extractor/
│       └── SKILL.md              # reverse engineering to create use cases
├── prime-architect/              # Solution Architect layer ("Jarvis Skills")
│   ├── its-generator/
│   │   └── SKILL.md              # how to write the ITS using the core contract
│   └── code-review/
│       ├── SKILL.md              # review script: validates implementation against ITS + quality-model
│       └── checklists/
│           └── review-checklist.md
└── prime-dev/                    # Dev layer ("Friday Skills")
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
| **Jarvis** (Architect) | `prime-core` + `prime-architect` | Understands the demand, creates the ITS, performs the code review |
| **Friday** (Dev) | `prime-core` + `prime-dev` | Implements from the ITS, tests, and prepares the PR |

> Golden rule: an agent **never** loads the other role's layer.

## The ITS contract

The centerpiece of the platform. The ITS (Instrução de Trabalho de Software — Software Work Instruction) format lives in `prime-core` and is consumed by both sides: the architect writes to it, the dev reads from it. A change in the contract updates writing and reading at the same time, eliminating drift between specification and implementation.

## The project configuration

Every run, in every layer, starts by reading `docs/prime-config.md` — the file that answers what is true about the project that the skills must not guess (stack, structure, conventions, document locations, verification commands). Its contract — mandatory sections, precedence rules, divergence handling, and the bootstrap procedure — is owned by `prime-core/prime-config`; every skill's Step 0 references that contract instead of re-describing the procedure.

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

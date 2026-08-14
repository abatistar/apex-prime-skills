# Apex Prime

**Skills platform for engineering agents — delivering solutions at the highest standard, from demand understanding to deploy.**

Apex Prime is the single source of truth for the quality standards, conventions, and workflows that guide the team's AI agents across the entire delivery cycle. It turns our process — **Solution Architect understands the demand and creates the ITS → Dev implements → Architect reviews and validates → pipeline takes it to deploy** — into a skills architecture with explicit boundaries, where each role operates with the right context and everyone answers to the same standard.

## Why it exists

When quality standards live scattered — in people's heads, in loose documents, duplicated across tools — they diverge. The dev implements against one version of the standard, the review demands another, and friction appears exactly where the process should provide flow. Apex Prime solves this with two principles:

1. **Single foundation.** The quality model, the coding conventions, the ITS contract, and the project configuration contract have a single owner and a single address: the `prime-core` layer. Every agent consumes the same foundation — update the standard once, and it updates for everyone.
2. **Boundaries per role.** Each agent loads only its role's layers plus the foundation. The dev's agent doesn't write the ITS; the architect's agent doesn't implement. The workflow gates stop being convention and become architecture.

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
│   │   ├── SKILL.md              # what "good" is: the eight lenses, tiers, exception discipline
│   │   └── references/
│   │       └── quality-criteria.md   # the versioned criteria catalog (QM-XX-N)
│   ├── coding-standards/
│   │   ├── SKILL.md              # what good looks like here: application classes, legacy register, migrations
│   │   └── references/
│   │       ├── convention-slots.md   # the closed slot catalog (CS-XX-N)
│   │       └── defaults-java.md      # team default values for the Java stack
│   ├── prime-config/
│   │   ├── SKILL.md              # contract for docs/prime-config.md: sections, override points, precedence, bootstrap
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
│       ├── SKILL.md              # review script: validates implementation against ITS + core standards
│       └── checklists/
│           └── review-checklist.md
└── prime-dev/                    # Dev layer ("Friday Skills") — STUBS, to be authored
    ├── its-implementation/
    │   └── SKILL.md              # [stub] how to read the ITS, plan, and implement following the core
    ├── testing/
    │   └── SKILL.md              # [stub] test standard required before the PR
    └── pr-preparation/
        └── SKILL.md              # [stub] how to prepare the PR for the review and the Azure pipeline
```

### Authoring status

| Layer | Status |
|---|---|
| `prime-core` | Authored — quality-model v1.0, coding-standards v1.0, prime-config, use-case, its-contract |
| `prime-docs` | Authored — use-case-creator, use-case-extractor |
| `prime-architect` | Authored — its-generator, code-review |
| `prime-dev` | **Stubs.** The three skills and the Friday adapters are placeholders so the layer structure and cross-references stay valid |

Jarvis is therefore operable end to end (documentation → ITS → review); Friday waits on the dev layer.

### Agent assembly

| Agent | Layers loaded | Responsibility in the workflow |
|---|---|---|
| **Jarvis** (Architect) | `prime-core` + `prime-architect` + `prime-docs` | Understands the demand, documents the use cases, creates the ITS, performs the code review |
| **Friday** (Dev) | `prime-core` + `prime-dev` | Implements from the ITS, tests, and prepares the PR |

> Golden rule: an agent **never** loads the other role's layer. Jarvis never loads `prime-dev`; Friday never loads `prime-architect` or `prime-docs`.

## The ITS contract

The centerpiece of the platform. The ITS (Instrução de Trabalho de Software — Software Work Instruction) format lives in `prime-core` and is consumed by both sides: the architect writes to it, the dev reads from it. A change in the contract updates writing and reading at the same time, eliminating drift between specification and implementation.

## The standard: two contracts, one enforcement point

`prime-core/quality-model` answers *what good is* — eight lenses, a non-negotiable floor with stable IDs (`QM-XX-N`), and an exception discipline that distinguishes deliberate debt from the silent shortcut. `prime-core/coding-standards` answers *what good looks like here* — the closed catalog of convention slots (`CS-XX-N`) every project must have decided, the team defaults per stack, and the legacy area register. Neither approves or rejects anything: enforcement is owned by `prime-architect/code-review`, which turns both into classified findings and one verdict, always citing an ID instead of a preference.

## The project configuration

Every run, in every layer, starts by reading `docs/prime-config.md` — the file that answers what is true about the project that the skills must not guess (stack, structure, conventions, area register, slot overrides, document locations, verification commands). Its contract — mandatory sections, the closed list of override points, precedence rules, divergence handling, and the bootstrap procedure — is owned by `prime-core/prime-config`; every skill's Step 0 references that contract instead of re-describing the procedure.

## Skill design principles

- **Reference, never duplicate.** Role skills point to `prime-core` instead of copying its criteria. The standard has a single owner and a single address.
- **Ambiguity returns, it is not assumed.** If the ITS is ambiguous, the dev's agent does not fill the gaps on its own — it returns questions to the architect.
- **Quality as a gate, not as an opinion.** Code review validates against versioned criteria in `quality-model` and `coding-standards`, not against preferences of the moment.
- **Unfilled is a gap, not a free choice.** A decision nobody took is reported, never improvised.

## Governance

- Changes to `prime-core` affect every agent and go through a PR reviewed by the quality model's owner.
- The role layers (`prime-architect`, `prime-dev`) evolve with more freedom, as long as they respect the foundation.
- Criterion and slot IDs are stable and never renumbered; a retired ID stays retired.
- The core's `CHANGELOG.md` records every evolution of the standard, so the team knows when and why it changed. The core skills keep no parallel history.

---

*Apex Prime — quality comes first.*

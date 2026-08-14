---
name: coding-standards
description: The canonical contract for concrete code conventions owned by prime-core - the catalog of convention slots every project must have decided, the team defaults per stack, the two application classes (invariant vs conventional), and the rules for living with legacy code and for declared migrations. This skill owns the concrete answers that prime-core/quality-model's criteria defer to; project-specific values live in docs/prime-config.md and take precedence. Consult whenever planning, writing, reviewing, or validating code, whenever a quality criterion needs a concrete convention to be checkable, and whenever a change touches an area registered as legacy. Never duplicate its content elsewhere - reference slots by ID.
---

# Coding Standards (prime-core)

`quality-model` answers *what good is*. This skill answers *what good looks like here* — the concrete conventions its criteria defer to. Where the model says "names must not lie" (`QM-RC-1`), this skill says which naming carries which promise; where it says "the local pattern wins" (`QM-CN-2`), this skill says how an area is classified as local-pattern territory in the first place.

The skill does not hold every project's values. It holds three things:

1. **The slot catalog** (`references/convention-slots.md`) — the closed list of decisions every project must have taken, each with a stable ID (`CS-XX-N`). A slot is a question, not an answer.
2. **The team defaults** (`references/defaults-<stack>.md`) — the answer the team uses when a project says nothing. Java is the default stack: `references/defaults-java.md`.
3. **The rules of engagement** — application classes, legacy handling, migration discipline, and how a departure is made.

Read the slot catalog before planning or reviewing code. Read the defaults file for the project's stack; where `docs/prime-config.md` states a value for a slot, that value wins.

## Boundaries

- **prime-core/quality-model** owns the principles and the non-negotiable floor. This skill never restates a criterion — it references `QM-XX-N` and supplies the concrete form that makes it checkable.
- **prime-core/prime-config** owns the project's values: the *Conventions and constraints* section holds slot overrides and the legacy area register. Precedence is the config contract's: explicit beats detected, config overrides declared defaults, config never waives a core rule.
- **prime-core/its-contract** owns decisions that outlive the story. A convention adopted repo-wide is an ADR that then updates a slot value — never a preference asserted inside an ITS.
- **prime-architect/code-review** owns enforcement. This skill defines the convention; the reviewer decides whether a given change met it.

## Two application classes

Every slot is tagged **INVARIANT** or **CONVENTIONAL**, and the tag decides what happens when the surrounding code disagrees with the standard. This resolves the tension between `QM-CN-2` (the local pattern beats your opinion) and the exception discipline (meet the floor in what you write): both are right, over different slots.

**INVARIANT** — applies to every line written or changed, regardless of what surrounds it. These are the slots that carry a `[NON-NEGOTIABLE]` criterion into concrete form: swallowed errors, leaked secrets, unvalidated boundary input, unparameterized queries. There is no such thing as "the local pattern here is to swallow the exception". Departure is possible only as a named, owned exception per the quality model's discipline — never by inheritance.

**CONVENTIONAL** — the local pattern wins, always. In an area written to an older convention, following the current standard in your fragment introduces the second way of doing things that `QM-CN-1` forbids. Consistency with the surroundings is itself the criterion. The current standard reaches old code through one route only: a declared migration.

The consequence, stated plainly so nobody has to infer it: **old code staying old is correct, not debt.** What is debt is old code that a declared migration abandoned halfway.

## Legacy: the area register

Classification is declared, not judged per pull request. `docs/prime-config.md` registers each area in one of three states; anything unregistered is `current`.

```markdown
## Conventions and constraints
### Area register
- `src/main/java/com/acme/app/**` — current
- `src/main/java/com/acme/app/billing` — legacy-maintained (pre-2023 conventions; invariants apply)
- `src/main/java/com/acme/app/legacy` — strangler (replaced by `billing.v2`; MIG-003)
```

- **current** — the full standard applies: invariant and conventional slots alike.
- **legacy-maintained** — invariant slots apply to what you write and change; conventional slots defer to the local pattern. The area is fixed, extended, and maintained normally.
- **strangler** — as above, plus: no new behavior. New capability is born in the replacement module. Name the replacement and the migration ID, or the label means nothing.

Never infer these states from directory names or file age. An unregistered area is `current`, and a project that needs a fourth state is telling you the register is wrong, not that the rule is.

## Declared migrations

A migration is how a conventional slot's value changes for code that already exists. It carries a **new slot value, an owner, a scope, and a completion condition**. Absent any of the four, it is not a migration — it is erosion with a name (`QM-CN-1`).

- Deliberate and wholesale, never file-by-file opportunism. Automated where the change is mechanical.
- The old value stays valid inside the scope until the migration completes; both values are correct simultaneously, and this is the only situation where that is true.
- A migration that stops advancing is cancelled explicitly and the area returns to `legacy-maintained`. Half-migrated is the worst state; leaving it undeclared is worse than reverting.

## Unfilled slots

A slot with no value — neither a stack default nor a config override — is a **reportable gap**, not a free choice. Consuming skills surface it the way `prime-config` surfaces a missing mandatory section: report and offer to fill, do not improvise a value and do not proceed silently on a task that depends on it. The catalog exists so that "nobody ever decided where transactions begin" becomes visible instead of becoming thirty inconsistent decisions.

## Health signals

Conformance of the whole codebase is the wrong measurement: it never reaches 100%, it is not actionable, and it punishes areas the register already exempted. Three signals, with distinct jobs:

- **Per-change conformance (gate).** Measured over the diff, never the file. A change is conformant when it meets every invariant slot and the applicable conventional value for its area. Binary, checked at the pull request — which makes legacy irrelevant to the merge decision.
- **Churn × non-conformance (priority).** The migration queue is the intersection of change frequency (repository history over the last months) and density of findings, normalized per line so that large old files do not monopolize the ranking. Legacy nobody touches costs nothing; legacy touched weekly is where the standard is actually paying or costing. **If only one signal is tracked, track this one.**
- **Migration monotonicity (honesty).** For each declared migration, the share of the scope on the new value only rises. Flat across two review cycles means the migration is dead and the honest move is to resume it or cancel it.

None of the three approves or rejects anything by itself; enforcement belongs to `code-review`.

## Versioning

Same discipline as the quality model, for the same reason — a departure or an improvement note must cite a stable, dated thing.

- The slot catalog carries a version; slot **IDs are stable and never renumbered**. A retired slot leaves its ID retired.
- Changing a slot's *value* in a defaults file is a normal change. Adding, retiring, or reclassifying a *slot* changes the contract and goes through the governance PR reviewed by the quality model's owner.
- Evolution is recorded in the repository `CHANGELOG.md`. This skill keeps no parallel history.

## Consumption rules

**For `its-generator`** — load the slot catalog and the project's effective values before planning. The plan conforms to the slots that govern the touched areas: a change landing in a `legacy-maintained` area plans against the local pattern, and saying so belongs in the ITS (an out-of-scope boundary or a discarded-alternative line), not in the implementer's head. A slot the plan needs and cannot resolve is a gap to report, not to invent.

**For `its-implementation`** — the effective value for the area you are touching is the value you follow, and the area register tells you which. Meet every invariant slot in new and changed code. Where an invariant is already violated around you, name it as inherited debt rather than adopt it. Ambiguity about which value applies is a question returned to the architect, never an assumption.

**For `code-review`** — findings cite slot IDs alongside criterion IDs (`CS-ER-4` / `QM-EO-2`), so the conversation is about a versioned decision instead of a reviewer's taste. Judge conventional slots against the area's registered state, not against the current standard. A conventional finding in a `legacy-maintained` area is only valid if the change introduced a *third* pattern — neither local nor current.

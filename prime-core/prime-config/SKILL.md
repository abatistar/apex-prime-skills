---
name: prime-config
description: The canonical contract for docs/prime-config.md - the project configuration file every Apex Prime skill reads as its first step. Owns the file's structure, the mandatory and optional sections, the closed list of override points the core contracts declare, the precedence and divergence rules, and the bootstrap procedure when the file does not exist. Consult whenever reading, validating, bootstrapping, or updating a project's prime-config.md, and whenever a skill's Step 0 finds the file missing or contradicting the codebase. Never duplicate its rules elsewhere - reference it.
---

# Prime Config Contract (prime-core)

`docs/prime-config.md` is the entry point of every Apex Prime run: all skills, in every layer, read it as their first step. This skill owns its contract — structure, override points, precedence, divergence handling, and bootstrap. Because every consumer reads against the same contract, a change here updates all of them at once; no skill re-defines what the config means.

The config answers one question: **what is true about this project that the skills must not guess?** Stack and versions, folder structure, conventions, document locations, verification commands, pipeline. Everything else belongs to the core contracts (formats, quality) or to the role skills (process).

## File location and template

- Canonical path: `docs/prime-config.md`. Fallback: repository root (`prime-config.md`). No other locations.
- Canonical template: `references/prime-config-template.md`. Read it in full before bootstrapping or validating a config.
- The file is versioned with the code it describes. It changes by PR, like the code.

## Sections

**Mandatory** — a config missing any of these is incomplete (see Divergence and gaps):

- **Stack** — language and version, framework, build tool, database, migrations, messaging (when present). Versions are load-bearing: skills plan and review against them.
- **Structure** — where each architectural layer lives. This is the its-generator's map for code inspection and the extractor's map for entry-point inventory.
- **Conventions and constraints** — the project rules that constrain every plan and review. This section is the home of every override point the core contracts declare about code (see Override points below), and carries four named subsections plus free-prose project rules:
  - **Area register** — each area classified `current` | `legacy-maintained` | `strangler`, per prime-core/coding-standards. Unregistered means `current`; classification is declared here, never inferred.
  - **Slot overrides** — the convention slots (`CS-XX-N`) this project decides differently from the team defaults.
  - **Declared migrations** — each in-flight migration with its new slot value, owner, scope, and completion condition.
  - **Quality model posture** — project-specific non-negotiables, tightened calibrated thresholds, and the standing posture toward legacy and debt, per prime-core/quality-model.
  - **Project rules** — layer rules, error handling, test requirements, forbidden areas, feature-flag policy, and anything else that maps onto no slot.
- **Document repository** — locations and naming for use cases, ITS, and ADRs. Defaults exist in the core contracts, but the config states them explicitly so overrides have one address.
- **Verification commands** — how to build and test. Referenced by test strategies and PR preparation.

**Optional:**

- **Story identifiers** — tracker ID format. Default when absent: `S-NNN`.
- **Pipeline** — CI/CD stages and required checks. Needed by pr-preparation and code-review when the project has a pipeline; omit for projects without one.
- **Custom use case template / extra mandatory sections** — overrides consumed per prime-core/use-case. Absent means the core defaults apply.

Projects may add sections beyond these (e.g., compliance requirements). Unknown sections are preserved, never deleted by any skill.

An empty subsection is written with an explicit "none declared yet" (or "none — team defaults apply"), never omitted. Silence and absence are different facts, and only one of them is a decision.

## Override points (the closed list)

A core contract declares an override point when it names a default the project may replace. The config may override **only** what appears below; anything else in the core is a rule, not a default.

| Override point | Owner contract | Where it lives in the config |
|---|---|---|
| Use case template path | prime-core/use-case | Document repository |
| Extra mandatory use case sections | prime-core/use-case | Document repository |
| Document and ADR locations and naming | prime-core/use-case, prime-core/its-contract | Document repository |
| Convention slot values (`CS-XX-N`) | prime-core/coding-standards | Conventions and constraints › Slot overrides |
| Area classification (`current` / `legacy-maintained` / `strangler`) | prime-core/coding-standards | Conventions and constraints › Area register |
| Declared migrations | prime-core/coding-standards | Conventions and constraints › Declared migrations |
| Added non-negotiables and tightened calibrated thresholds | prime-core/quality-model | Conventions and constraints › Quality model posture |
| Standing posture toward legacy and deliberate debt | prime-core/quality-model | Conventions and constraints › Quality model posture |
| Story identifier format | this contract | Story identifiers |

A core contract that wants a new override point adds a row here in the same PR that declares it. Two contracts describing the same override in two places is the drift this skill exists to prevent.

## Precedence rules

1. **Explicit beats detected.** What the config states wins over anything a skill infers from build files or directory trees.
2. **Config overrides core defaults at the declared override points only** (the table above). At those points the config's value wins outright — a slot override beats the stack default, a registered area state beats the current standard for conventional slots.
3. **Config never overrides a core rule.** It cannot waive traceability, the status lifecycle, the quality gates, or a `[NON-NEGOTIABLE]` criterion. The config may **raise** the bar; relaxing a non-negotiable is a deliberate, owned decision recorded in an ADR, never a config edit.
4. **Config does not override an Accepted ADR.** A conflict between them is reported, not resolved silently.

## Divergence and gaps (rules for every consumer)

- **Config exists but contradicts the codebase** (says Java 11, `pom.xml` says 17): report the divergence and ask which is correct before proceeding. Never silently trust either side.
- **Config exists but a mandatory section is missing:** proceed only if the running task does not need that section; otherwise report the gap and offer to complete it via the bootstrap procedure (scoped to the missing section).
- **Config exists but a slot the task needs has no value** — neither a stack default nor an override: that is a reportable gap per prime-core/coding-standards (Unfilled slots). Report it and offer to fill it; never improvise a value and never proceed silently on a task that depends on it.
- **Config does not exist:** offer to bootstrap it (below). Skills do not proceed on pure detection without giving the user a config to review — undetectable facts (conventions, forbidden areas, area classification) would be silently absent.
- **No skill edits the config as a side effect of another task.** Updating it is always an explicit act with user review, through this skill.

## Bootstrap procedure

Run when the config is missing, or scoped to specific sections when they are absent.

1. **Detect.** Read build files (`pom.xml`, `build.gradle`, `package.json`, ...), directory tree, framework markers, migration folders, CI definitions. Draft the Stack, Structure, and Verification commands sections from evidence — cite the evidence (which file told you what) so the user can audit the detection.
2. **Walk the slot catalog.** Load `prime-core/coding-standards` (`references/convention-slots.md`) and the defaults file for the detected stack. For each slot: if the team default answers it and the project agrees, nothing is written; if the project decides differently, record the override; if no default exists for the stack and the project has not decided, record it as an unfilled slot with `[CONFIRM: ...]`. The catalog is a closed list precisely so "nobody ever decided where transactions begin" becomes visible instead of becoming thirty inconsistent decisions — the bootstrap is where that list is walked.
3. **Classify the areas.** Elicit the area register: which paths are `current`, which are `legacy-maintained`, which are `strangler` (with the replacement module and migration ID). Never infer these from directory names or file age. A project that declares nothing gets `current` everywhere — write that explicitly rather than leaving the subsection out.
4. **Ask what code cannot tell.** Project rules, forbidden areas, feature-flag policy, quality model posture, story ID format, pipeline stages are human knowledge. Elicit them; never invent. If the user has nothing to declare, write the subsection with an explicit "none declared yet" rather than omitting it.
5. **Propose document locations.** Default to the core conventions (`docs/use-cases/`, `docs/its/`, `docs/adr/`). Offer to create the directories if absent.
6. **Deliver as draft for review.** The user validates before the file is committed. A config nobody reviewed is detection, not configuration — and explicit-beats-detected only means something if a human made it explicit.
7. Mark anything deduced but unconfirmed with `[CONFIRM: ...]` (same marker discipline as prime-core/use-case). A config with unresolved markers is usable, but every consumer must surface the relevant marker when a task depends on it.

## Consumption rule (for every skill's Step 0)

Skills reference this contract instead of describing the procedure: *"Read `docs/prime-config.md` per prime-core/prime-config (fallback, divergence, and bootstrap rules live there)."* The three sentences currently repeated across Step 0s collapse into that one.

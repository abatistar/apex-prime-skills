---
name: quality-model
description: The canonical quality model owned by prime-core - the versioned definition of what "high quality" means for this team, plus its non-negotiables and its exception discipline. It is a shared definition and reference, not an enforcement gate: new code is built against it, and its-generator and its-implementation reference it to question the artifacts they deliver and surface improvements. Enforcement (precise findings, approve/reject a PR) is owned later by code-review. Declares the boundary to coding-standards (concrete conventions live there) and to its-contract (ADRs live there). Never duplicate its criteria elsewhere - reference them by ID.
---

# Quality Model (prime-core)

This skill owns the team's definition of quality. It has one address and one owner; every other skill references it by criterion ID instead of restating it, so the standard new code is built against and the standard used to question a deliverable are the same standard, at the same version. A change here updates everyone at once.

## One definition, eight lenses

Quality is not a sum of properties you tick off a list. It is a single property — **the system is safe, predictable, and cheap to change over time** — observed from eight angles: readability (the property seen by the reader), tests (seen by whoever changes it), coupling and cohesion (seen by the structure), consistency (seen by the team), error handling and observability (seen under failure), maintainability (seen across time), documentation (seen by knowledge transfer), and security and robustness (seen under an adversary). They rise and fall together because they are symptoms of the same underlying cause: the system was cut at the right joints and that clarity was held against the entropy of time.

Two consequences follow, and they shape how this model is used:

- The core of quality is **irreducibly judgment** — where to draw boundaries, what to abstract versus duplicate, which debt to assume, how much care a given piece of code deserves. This skill **structures** that judgment; it does not replace it. A model that pretended to remove judgment would betray the thing it measures.
- Every dimension has a **cardinal sin** and an **honest tension**. The cardinal sins are the few failures that are almost never acceptable — the non-negotiables. The tension is that **excess is as harmful as deficiency**: the virtue is never maximizing a dimension, it is calibrating it to context. Applying a criterion without regard to the code's expected lifetime and importance is misapplying this model.

## A definition, not a verdict

This model defines the **target**. It is the base against which new code is built, and the reference `its-generator` and `its-implementation` use to interrogate the artifacts they deliver — an ITS, an implementation, a test strategy — and point out where they can be better. It does not, by itself, approve or reject anything.

Turning the model into precise findings and an approve/reject recommendation on a pull request is a distinct job, owned by `prime-architect/code-review`. Keep the two separated: this skill answers *what good is*; the reviewer answers *did this particular change clear the bar, given its context*. Collapsing them would make the definition carry enforcement decisions it should not own.

## How the criteria are classified

Each criterion in the catalog (`references/quality-criteria.md`) is tagged with one of three tiers. The tier is about the criterion's **nature**, not about any automatic consequence:

- **NON-NEGOTIABLE** — a cardinal sin: the floor for new code. "Non-negotiable" means *not silently negotiable* — you meet it, or you depart from it as a **named, deliberate, owned exception** (see Exceptions). Each carries a stable ID (`QM-XX-N`) so a discussion cites the criterion, not a mood.
- **CALIBRATED** — a judgment item, always paired with its honest tension. The model gives the criterion and the trade-off; the reader calibrates to context. It is never a rule to apply mechanically.
- **AUTOMATED** — a mechanical level (formatting, dependency scanning, coverage-as-signal, secret scanning) that belongs to tools. Human attention spent re-litigating it is waste; its absence from the toolchain is the thing worth raising.

Above all three sits the calibration rule: the bar is **proportional** to the code's expected lifetime and importance and to the realistic threat model. A throwaway prototype and a ten-year core are not held to the same standard. Maturity is knowing when a criterion stops applying — the catalog states each tension so the model calibrates instead of being read as absolute.

## Exceptions: legacy and deliberate debt

A quality model that admitted no exceptions would be useless in a real codebase, which always contains legacy written to a lower bar and debt the project chose to take on. The model handles this not by weakening the criteria but by governing **how a departure is made**. The distinction that runs through the whole model is *silent versus deliberate*:

- **Deliberate debt is legitimate.** Choosing a simplification consciously — to ship, to validate a market, to defer a decision until you know more — is a valid engineering move (the deliberate-and-prudent quadrant, `QM-MT-2`). What the model forbids is the **invisible** departure: the shortcut nobody named, the non-negotiable quietly skipped. A departure is acceptable when it is **deliberate, named, justified, and owned** — a comment at the site, a backlog item, or an ADR when it outlives the story (`QM-MT-1`). The sin is never the debt; it is the debt no one can see or discuss.
- **Legacy is not retroactively condemned.** The model applies to the code you **write and change**, not to every line that predates it. Adding a feature to a low-quality area does not oblige you to bring the whole area to standard; it obliges you to meet the bar in what you add, leave the area no worse, and — where a non-negotiable is already violated around you — name it as inherited debt rather than adopt it silently. In existing code, the local pattern also wins over preference (`QM-CN-2`): consistency with the surroundings is itself a quality criterion, so "improving" by introducing a second way is usually a net loss.
- **Not all exceptions cost the same.** Calibrated criteria bend readily to context. Non-negotiables bend only as explicit, owned exceptions — and the **security** criteria (`QM-SR-*`) carry the highest bar of all, because their asymmetry means a single silent gap can be fatal regardless of how good everything else is. A deliberate security exception is a threat-model decision with the owner in the loop, not a routine debt line.

The maturity this encodes is the one the source material closes on: knowing the rules is not the skill; knowing when each one stops applying, and saying so out loud, is.

## What this model is not

- **Not a substitute for judgment.** The non-negotiables are a floor, not a definition of good.
- **Not an enforcement gate.** It defines the bar; `code-review` decides, later, whether a given PR clears it and what to recommend.
- **Not the coding standards.** This skill owns *principles and non-negotiables*; `prime-core/coding-standards` owns the *concrete project conventions* — which naming, which layering, which idioms. When a criterion needs a concrete convention to be checkable, it points at `coding-standards`; it does not invent one.
- **Not the home of architectural decisions.** Decisions that outlive a story live in ADRs, owned by `prime-core/its-contract`'s decision boundary. The documentation dimension references ADRs; it does not redefine them.

## Versioning

"Versioned criteria, not preferences of the moment" is what lets a departure or an improvement note cite a stable, dated thing instead of an opinion.

- The catalog carries a **version** (e.g., `v1.0`).
- Criterion **IDs are stable and never renumbered**, like use case numbers and ADRs. A retired criterion leaves its ID retired, not reused.
- Changes go through the governance PR **reviewed by the quality model's owner**. The evolution is recorded in the repository `CHANGELOG.md` — the model keeps no parallel changelog, to avoid two histories drifting.

## Project overrides

`docs/prime-config.md` may **raise** the bar — add project-specific non-negotiables, or tighten a calibrated threshold — and may **record a standing posture** toward legacy or debt for the project (e.g., "module X is legacy under strangler-fig migration; match its local patterns, do not extend them"). It may **not silently waive** a core non-negotiable: relaxing one is a deliberate, owned decision (an ADR), not a quiet config edit. This mirrors the prime-config precedence rule — config overrides declared defaults, never core rules.

## Consumption rules

**Building new code** — the model is the base. Meet the non-negotiable floor; calibrate the rest to the code's context. Where the plan or the project takes a departure, make it a named, owned exception, never a silent one.

**For `its-generator` (questioning the ITS it delivers)** — reference the model to interrogate the plan before handing it off: does any proposed change commit a cardinal sin silently; is the proposed level of care calibrated to the code's lifetime and importance; where a criterion is departed from for legacy or debt, is that stated as a deliberate exception (a discarded-alternative line, an out-of-scope boundary, or an ADR)? The aim is to surface improvements in the deliverable, citing criteria by ID.

**For `its-implementation` (questioning the implementation it delivers)** — the same discipline on the code side: measure the implementation and its tests against the criteria, meet the floor in new and changed code, and where inherited legacy violates a non-negotiable, name it rather than adopt it silently. Ambiguity about which bar applies is a question to return to the architect, not an assumption.

**For `code-review` (later)** — the reviewer will turn these criteria into precise findings and an approve/reject recommendation for the PR, judging each against the change's context and its named exceptions. That enforcement role is owned there and defined when that skill is authored; this skill only supplies the versioned definition it will cite.

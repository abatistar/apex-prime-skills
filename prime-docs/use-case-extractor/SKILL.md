---
name: use-case-extractor
description: Reverse-engineer use case documents from an existing codebase, writing against the prime-core/use-case format. Docs-layer skill. Use whenever the user wants to document behavior that is already implemented but has no standardized use case documentation - mapping a module, a user journey, a set of endpoints, or a single flow. Also use when the its-generator reports a missing use case for a change story, or when the user says things like "document how X currently works", "map the use cases of module Y". Do NOT use for writing use cases for new/planned behavior (use-case-creator) or for generating an ITS (its-generator).
---

# Use Case Extractor (prime-docs)

Produce use case documents that describe behavior **already implemented** in the codebase, by reading the code — not by inventing intent. The output populates the project's use case repository, which the use-case-creator maintains and the its-generator consumes.

Core mindset: code tells you what the system *does*, not what it *should do*. Intent may be lost, and bugs may have been consecrated as behavior. Your job is to document faithfully and to confess every doubt explicitly, so a human can validate before the document becomes source of truth.

The document format is NOT defined here — it is owned by **prime-core/use-case** (template at `references/use-case-template.md` inside that skill), including the uncertainty markers this skill depends on. Read it in full before writing.

## Step 0 — Load project configuration and the core format

Read `docs/prime-config.md` per **prime-core/prime-config** — location, fallback, precedence (explicit beats detected), divergence handling (config contradicting the codebase), and the bootstrap procedure when the file is missing all live in that contract; never re-derive them here. From the config this skill uses: the stack, the folder structure as the map for the entry-point inventory, the conventions, and the document repository locations. Then load the prime-core/use-case format; if the config declares a custom template, it takes precedence.

## Step 1 — Delimit scope with the user

Never map "the whole system" in one run. Ask for a bounded slice: one module, one user journey, one set of endpoints. If the user gave a scope in their request, confirm your understanding of its boundaries. Each run must produce a reviewable amount of output — as a rule of thumb, no more than 3–5 use case documents per run.

## Step 2 — Inventory entry points

Within the scope, list every interaction surface: HTTP routes/controllers, message consumers, scheduled jobs, CLI commands, event handlers. Use the config's structure section to know where to look. Each entry point is a candidate use case (or a step within one). Present the inventory to the user and agree on which candidates become documents before writing anything.

## Step 3 — Reconstruct each scenario from the code

For each agreed candidate, trace the execution path and translate code into the template's elements:

- Input validations and guards → **preconditions** and **extensions** (failure handling)
- Business logic branches → **Main Success Scenario steps**, **extensions** (alternatives), and **business rules (RN-N)**
- Persisted effects, emitted events, external calls → **Success Guarantees**
- Effects that hold even when the operation fails (audit logs, rollbacks leaving no partial state, compensations) → **Minimal Guarantees**
- Error handling (exceptions caught, error responses, rollbacks) → **extensions** with their defined outcomes
- Authorization checks → **preconditions** or **extensions** (permission denied)

Stakeholders and Interests is optional: code rarely reveals stakeholder interests. Fill it only when the traced material genuinely exposes one (e.g., a compliance audit trail implies a regulator's interest), always marked `[INFERRED]`; otherwise omit the section.

Read existing tests for the traced code: well-written tests are near-ready acceptance criteria and often reveal intended behavior more clearly than the implementation.

## Step 4 — Mark every uncertainty

This is the critical discipline of this skill. Distinguish what you verified from what you deduced, using the markers defined in the core format:

- `[INFERRED]` for behavior deduced from structure but not confirmed by tests.
- `[CONFIRM: question]` for anything a human must decide — magic numbers, ambiguous branches, suspicious behavior that may be a bug (e.g., `[CONFIRM: on payment timeout the order stays in PENDING forever — intended?]`).

Never silently normalize odd behavior into a clean rule. If the code does something strange, document the strange thing and flag it.

## Step 5 — Write the documents and hand off for review

- Use the core template. Follow its quality rules and file naming convention; pick the next free UC number. Include the UML graphical summary scoped to the use case and its direct relations.
- Set Status to **Draft**.
- First Revision History entry: `Rev 1 | initial mapping from code | date | scope summary`.
- Fill Related use cases when scenarios within the run reference each other.

Close the run by listing, per document: the uncertainty markers that need resolution. State explicitly that the documents only become source of truth ("Reviewed" status) after a human resolves the markers. Do not promote the status yourself.

## Output

One or more `UC-NNN-title.md` files in the configured use case repository, each in Draft status with explicit uncertainty markers, plus a review checklist for the user.

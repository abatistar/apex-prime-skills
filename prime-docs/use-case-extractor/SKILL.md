---
name: use-case-extractor
description: Reverse-engineer use case documents from an existing codebase, writing against the prime-core/use-case format. Docs-layer skill. Use whenever the user wants to document behavior that is already implemented but has no standardized use case documentation - mapping a module, a user journey, a set of endpoints, or a single flow. Also use when the its-generator reports a missing use case for a change story, or when the user says things like "document how X currently works", "map the use cases of module Y". Do NOT use for writing use cases for new/planned behavior (use-case-creator) or for generating an ITS (its-generator).
---

# Use Case Extractor (prime-docs)

Produce use case documents that describe behavior **already implemented** in the codebase, by reading the code — not by inventing intent. The output populates the project's use case repository, which the use-case-creator maintains and the its-generator consumes.

Core mindset: code tells you what the system *does*, not what it *should do*. Intent may be lost, and bugs may have been consecrated as behavior. Your job is to document faithfully and to confess every doubt explicitly, so a human can validate before the document becomes source of truth.

The document format is NOT defined here — it is owned by **prime-core/use-case** (template at `references/use-case-template.md` inside that skill), including the uncertainty markers this skill depends on. Read it in full before writing.

## Step 0 — Load project configuration and the core format

Read `docs/prime-config.md` (fall back to repo root). It defines the stack, folder structure, conventions, and document repository locations.

- If it exists: follow it. If the config contradicts what you observe (e.g., config says Java 11, `pom.xml` says 17), report the divergence and ask which is correct before proceeding.
- If it does not exist: offer to bootstrap it. Detect what you can (build files, directory tree, framework markers), draft a config, and ask the user to review it. Explicit configuration always wins over detection.
- Load the prime-core/use-case format; if the config declares a custom template, it takes precedence.

## Step 1 — Delimit scope with the user

Never map "the whole system" in one run. Ask for a bounded slice: one module, one user journey, one set of endpoints. If the user gave a scope in their request, confirm your understanding of its boundaries. Each run must produce a reviewable amount of output — as a rule of thumb, no more than 3–5 use case documents per run.

## Step 2 — Inventory entry points

Within the scope, list every interaction surface: HTTP routes/controllers, message consumers, scheduled jobs, CLI commands, event handlers. Use the config's structure section to know where to look. Each entry point is a candidate use case (or a step within one). Present the inventory to the user and agree on which candidates become documents before writing anything.

## Step 3 — Reconstruct each flow from the code

For each agreed candidate, trace the execution path and translate code into use case elements:

- Input validations and guards → **preconditions** and **exception flows**
- Business logic branches → **main flow steps**, **alternative flows**, and **business rules**
- Persisted effects, emitted events, external calls → **postconditions**
- Error handling (exceptions caught, error responses, rollbacks) → **exception flows** with their outcomes
- Authorization checks → **preconditions** or **exception flows** (permission denied)

Read existing tests for the traced code: well-written tests are near-ready acceptance criteria and often reveal intended behavior more clearly than the implementation.

## Step 4 — Mark every uncertainty

This is the critical discipline of this skill. Distinguish what you verified from what you deduced, using the markers defined in the core format:

- `[INFERRED]` for behavior deduced from structure but not confirmed by tests.
- `[CONFIRM: question]` for anything a human must decide — magic numbers, ambiguous branches, suspicious behavior that may be a bug (e.g., `[CONFIRM: on payment timeout the order stays in PENDING forever — intended?]`).

Never silently normalize odd behavior into a clean rule. If the code does something strange, document the strange thing and flag it.

## Step 5 — Write the documents and hand off for review

- Use the core template. Follow its quality rules and file naming convention; pick the next free UC number.
- Set Status to **Draft**.
- First Revision History entry: `Rev 1 | initial mapping from code | date | scope summary`.
- Fill Related use cases when flows within the run reference each other.

Close the run by listing, per document: the uncertainty markers that need resolution. State explicitly that the documents only become source of truth ("Reviewed" status) after a human resolves the markers. Do not promote the status yourself.

## Output

One or more `UC-NNN-title.md` files in the configured use case repository, each in Draft status with explicit uncertainty markers, plus a review checklist for the user.

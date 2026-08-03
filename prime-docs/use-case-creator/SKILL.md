---
name: use-case-creator
description: Create new use case documents or update existing ones from user stories, PRDs, or informal change descriptions, writing against the prime-core/use-case format. Docs-layer skill. Use whenever the user wants to write, refine, derive, or maintain use cases - e.g., "write the use case for this story", "this story changes the checkout flow, update the docs", "derive use cases from this PRD", "add an exception to UC-042". The use case repository is the living source of truth for system behavior; this skill keeps it alive. Do NOT use for documenting already-implemented behavior with no prior docs (use-case-extractor) or for generating an ITS (its-generator).
---

# Use Case Creator (prime-docs)

Create and maintain the project's use case repository — the living documentation of system behavior. Stories are units of change; use cases are the state those changes apply to. Every story that alters behavior must leave the repository updated, with an explicit delta recorded so the its-generator can plan the implementation.

The document format is NOT defined here — it is owned by **prime-core/use-case** (template at `references/use-case-template.md` inside that skill). Read it in full, including its quality rules, before writing: they are part of this skill's contract.

## Step 0 — Load project configuration and the core format

Read `docs/prime-config.md` (fall back to repo root) for conventions, repository locations, and template overrides. If missing, offer to bootstrap it via auto-detection and user review. Explicit config wins over detection; report divergences. Then load the prime-core/use-case format; if the config declares a custom template, it takes precedence over the core default.

## Step 1 — Route: creation, update, or both

Read the input (user story, PRD excerpt, or informal description) and scan the use case repository (`docs/use-cases/` by default) to answer: does this change introduce behavior with no existing document (**creation mode**), modify documented behavior (**update mode**), or both?

The story-to-use-case relation is N-to-N. List every affected existing use case and every new one to be born, and **confirm this mapping with the user before writing**. A wrong mapping here corrupts everything downstream.

If the story clearly modifies existing behavior but no corresponding use case exists in the repository, do not improvise one from imagination: recommend running use-case-extractor on that area first, then re-running this skill.

## Step 2a — Creation mode

1. Elicit before writing. Walk through this checklist with the user for anything the story does not answer:
   - Who initiates the action? Any secondary actors or external systems?
   - What must be true before the flow can start (permissions, state, limits)?
   - What happens when validation fails? When the actor lacks permission? When a limit is hit? When an integration is down or times out? When two actors act concurrently?
   - What is guaranteed after success? After failure (partial state?)?
2. If a PRD is available, use it as context for the Goal and to respect declared non-scope — do not design behavior the PRD excludes.
3. Fill the core template completely. Pick the next free UC number. Status: Draft (or Reviewed, if the user validates in the same session).
4. First Revision History entry references the originating story ID and date.

## Step 2b — Update mode

1. Read the current document **in full** — never patch a document you have not read.
2. Apply the change described by the story to the affected steps, flows, rules, and criteria.
3. Check internal side effects: a change in step 3 may invalidate exception 5a, a postcondition, or an acceptance criterion. Fix or flag every inconsistency the change introduces.
4. Record the delta as a new Revision History entry: story ID, date, and a precise summary of what was **added / changed / removed**, referencing step and section numbers (e.g., "Added exception 3b (concurrent export limit); changed step 5; removed BR-4"). This entry is the its-generator's primary input — vagueness here becomes a bad ITS.
5. Keep only the 5 most recent Revision History entries; drop older ones (full history lives in version control).

## Step 3 — Cross-consistency check

Before finalizing, scan the repository for conflicts: does the new/changed behavior contradict a flow, rule, or postcondition documented in another use case (e.g., a new permission rule that another flow assumes absent)? If a conflict exists, report it to the user instead of silently proceeding. If the resolution requires changing the other document too, treat it as part of the same story's mapping (back to Step 1).

## Step 4 — Deliver

Present the created/updated documents. For updates, summarize the delta explicitly in your reply so the user can validate it — the delta is what the its-generator will turn into an ITS. Update Related use cases links in every touched document.

## Output

Created and/or revised `UC-NNN-title.md` files in the configured repository, each revision carrying a story-identified delta in its Revision History, plus a reported list of any cross-document conflicts.

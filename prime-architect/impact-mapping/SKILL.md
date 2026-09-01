---
name: impact-mapping
description: Map the reach of an intended change across the codebase and the documented layer, producing anchored evidence and never a verdict. Architect-layer skill - it answers what a change touches, what depends on it, which registered areas it enters, which use cases cover it, and which Accepted ADRs bear on it. Use whenever the architect asks what a change would reach or affect - "what does changing the pricing rule touch", "what depends on this module", "map the blast radius of S-131", "what breaks if we change this payload", "where does this behavior live" - and always as the first pass of feasibility-analysis, which never judges without this map. Do NOT use to decide whether a change should be made or is worth it (feasibility-analysis owns the verdict), to write or revise an ITS (its-generator), to document behavior as use cases (prime-docs skills), to review an implementation already written (code-review), or to write or fix application code (dev layer - this skill never writes code).
---

# Impact Mapping (prime-architect)

This skill answers one question and refuses the next one: **what does this change reach?** It produces evidence — anchored, bounded, and classified by confidence — and hands it to whoever must decide. Deciding is somebody else's job: `feasibility-analysis` turns this map into a verdict, `its-generator` turns it into scope and out-of-scope boundaries, and the architect may simply read it.

The separation is the same one the repository already draws between `prime-core/quality-model` and `prime-architect/code-review`: defining and judging are different acts with different failure modes. A map that recommends has stopped being evidence, because a reader can no longer tell which lines are observations and which are opinions.

## The standard of a map

A map is good when a reader who disagrees with every conclusion can still use it. That requires three properties, and each of them is a rule below: every line is **anchored or explicitly marked as inference**, every degree of reach is **named** rather than merged into one list, and the map's **edge is stated** instead of implied.

**Procedence is the discipline.** This skill produces no document governed by a core contract and passes no gate, so the only thing separating it from a confident guess is that every claim about behavior resolves to a location. Four states, and every line carries exactly one:

- **Anchored** — cites `path/File.ext:line` or `UC-NNN/CA-N`. Read, not assumed. The reader can verify it without asking, and it is the only state that can carry a blocking conclusion downstream.
- **`[INFERRED]`** — reasoned from a pattern observed elsewhere in the codebase, not from the affected code itself, with the reasoning stated on the line. Same marker the `use-case-extractor` uses, for the same reason: an inference read as a fact is worse than a gap, because nobody investigates it.
- **`[UNVERIFIED]`** — asserted by the demand or by the architect and not checked against the code. Legitimate to carry, never silently promoted to fact.
- **Gap** — could not be determined, stated with *what would resolve it*.

This vocabulary is defined here and **reused, not redefined**, by every skill consuming this map. An unmarked inference is the defect that matters most, because the map is consumed by a skill that emits verdicts. A verdict built on evidence of unknown provenance is a preference wearing a report's clothes.

## Step 0 — Read the configuration

Read `docs/prime-config.md` per the **prime-core/prime-config** contract (location, precedence, divergence, and bootstrap rules live there; do not restate them). From it this skill consumes: the **structure map** (where things live), the **area register** (each area's state — `current`, `legacy-maintained`, `strangler`), the **document repository** locations for use cases and ADRs, and the **verification commands** (which tests cover which surface).

A slot with no value or an area with no registered state is a **gap reported per `coding-standards`**, never improvised. In this skill the consequence is direct: an unregistered area cannot be overlaid in Step 4, and the map says so instead of guessing from the directory name.

## Step 1 — Restate the change as behavior

The input usually arrives as a solution: *"add a column"*, *"cache the customer lookup"*, *"change the endpoint"*. Restate it as the observable behavior delta — what a user, a caller, or a downstream system will see differently. Then bound it: state explicitly what is **not** changing, in the same terms.

Two outcomes are legitimate here:

- The restatement holds → it becomes the map's subject line, and everything traced must trace back to it.
- The restatement cannot be made without inventing intent → stop. **Insufficient input** is a finding, not a failure; return the specific questions rather than mapping a change nobody has defined. Mapping a guessed change costs more than asking.

When the input names a solution and the behavior delta admits others, note it in one line. Do not evaluate the alternatives — that is the architect's call, informed by the map.

## Step 2 — Find the entry points

Where is the behavior triggered from: endpoint, scheduled job, event handler, CLI, UI action, migration. Anchor each one. These are the seeds; everything in Step 3 grows from them.

If the behavior has entry points the search did not reach — dynamic dispatch, reflection, configuration-driven wiring, a framework convention — say so as a gap with its resolution ("a runtime trace or the routing table would settle this"). A map that silently misses an entry point understates reach in exactly the way that makes a feasibility verdict wrong.

## Step 3 — Trace the reach, in three degrees

Reach is not one list. Merging these three is what turns a map into noise:

- **Direct** — must change for the behavior to change. This is the smallest honest set; if it is large, that is itself the finding.
- **Coupled** — does not change, but observes or depends on what changes: callers, subscribers, reports, fixtures, tests, feature flags, anything reading the same persisted state. This is where cost actually hides, and where an unmapped item becomes a production surprise.
- **Contract surface** — visible outside this codebase: API request and response shapes, database schema, event payloads, exported files, public function signatures in a shared library. Crossing this line reaches consumers the map cannot see. Name the surface and name the known consumers; do not trace into them.

For each item: location, degree, and one line on *why it is in the map*. An entry whose reason is not stated cannot be challenged, and a map that cannot be challenged is not evidence.

## Step 4 — Overlay the area register

Every touched area carries its **registered state** from the configuration. The state is elicited, never inferred from a directory name or a file's age — the `prime-config` bootstrap makes that explicit, and this skill has no license to soften it.

The overlay matters because identical reach costs differently by state: the same three files in a `current` area and in a `legacy-maintained` one are not the same change. Record the state; do not price it. Pricing is `feasibility-analysis`.

## Step 5 — Overlay the documented layer

Cross the reach against what the repository claims to be true.

- **Use case coverage.** Which `UC-NNN` cover the touched behavior, cited by `CA-N` where the coverage is specific. Touched behavior with no use case is a **documentation gap**: record it, name the area, and note that `use-case-extractor` is the route. It does not block this map — the map states its own reduced confidence and lists what a use case would settle.
- **Divergence.** Where the code's behavior differs from the documented use case, that is a finding in its own right, and often the most valuable line in the report: the repository has stopped being the source of truth for that area (`QM-DO-1`). Record it and route it to prime-docs. **Never patch a use case from inside this skill.**
- **ADR incidence.** Which Accepted ADRs bear on the touched areas. Where the intended change appears to contradict one, state the contradiction and cite the ADR. Do not resolve it: a conflict with an Accepted ADR is a decision, and decisions belong to the architect and the ADR lifecycle, never to a map.

## Step 6 — Bound the map and state the edge

Reach is transitive; a useful map is not. Stop deliberately, and say where:

- Stop at the **contract surface** — name the consumer, do not enter it.
- Stop where there is **no behavioral dependence** — sharing a package is not reach.
- Stop when the next hop **adds nothing a decision would turn on**.

Then write the edge down: what was deliberately not traced, and what would justify tracing it. An unbounded map is unusable; a silently truncated one is worse, because its reader believes the reach is complete. Stating the edge is what lets `feasibility-analysis` return *Undecidable with current evidence* instead of ruling on a partial picture — an edge short of what a verdict turns on is one of that skill's named grounds for undecidability, and it can only be read if this map declared it.

## Output

An impact map report — a working artifact of the architect, not a repository document. It is
filed where the demand lives (tracker, refinement thread, PRD), never under `docs/`: the use
case repository is the source of truth about system behavior, and nothing here competes with
it. It carries no sequential number, appears in no configuration, and is not maintained after
the demand moves on.

Its header is mandatory, because a map that cannot be cited cannot be consumed:

- **ID** — `IM-<demand-id>-N`, where `<demand-id>` is the demand's own identifier in the team's
  refinement process and `N` distinguishes successive maps of the same demand. Derived, never
  sequential: the map has the demand's lifetime, not the repository's.
- **Date** — the day the code was read. A map without a date is not citable; reach decays.
- **Demand** — what was mapped, in the demander's own terms.

The body contains:

1. **The change**, restated as behavior, with its explicit boundary.
2. **The map**, separated by degree — direct, coupled, contract surface — each entry anchored, located, and justified in one line.
3. **Area states**, from the register.
4. **The documented layer** — use case coverage, divergences found, ADR incidence.
5. **Gaps and open questions**, each with what would resolve it.
6. **Where the map stops**, and why.

No verdict, no recommendation, no estimate. If the report's reader cannot tell whether the change is a good idea, the skill did its job.

The operational pass and the report template live in `checklists/impact-map-checklist.md`.

## Consumers

- **`feasibility-analysis`** — runs this map first and never judges without it. It reads degrees,
  area states, ADR incidence, and the stated edge; the edge is what lets it return *Undecidable
  with current evidence* honestly instead of ruling over a picture it cannot see the end of.
- **The architect**, reading it directly to decide where to look next.

**Not a consumer: `its-generator`.** A map is scoped to a *demand* under refinement; an ITS is
scoped to *exactly one story*, and refinement can run for months between the two. Feeding a
demand-scoped map into a story-scoped plan pushes against the one discipline that skill is built
on — one delta, the story's — and by the time the ITS exists the map is old enough that verifying
it costs what deriving it fresh would. The `its-generator` inspects the code itself, every time.
The architect may of course have read this map; what does not happen is a plan inheriting reach
it never verified.

**Divergences found here route to prime-docs, never to an ITS.** A code × use case divergence is
resolved by `use-case-creator` or `use-case-extractor` before specification, not carried forward
into an implementation plan.

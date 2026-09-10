---
name: feasibility-analysis
description: Judge a demand against the system that would have to absorb it, before any specification exists - producing classified findings and exactly one verdict. Architect-layer skill, invoked on the architect's demand, never as a mandatory gate. Always runs impact-mapping first and judges over that map instead of re-deriving reach. Use when the architect brings a story, PRD, epic, or informal proposal and asks whether it can be done, what it would break, or what stands in the way - "is this doable", "can we absorb this", "what blocks this story", "should we take this into refinement", "the product owner wants X, what breaks". Do NOT use to map reach without judging it (impact-mapping alone answers what a change touches), to estimate effort or duration (this skill never estimates - cost is evidence, not a criterion), to write use cases (use-case-creator, use-case-extractor), to plan an approved change (its-generator), to judge an implementation already written (code-review), or to write application code (dev layer - this skill never writes code).
---

# Feasibility Analysis (prime-architect)

`code-review` judges **code against a plan, after**. This skill judges **a demand against the system, before** — same shape, opposite end of the pipeline. Both turn versioned criteria into classified findings and exactly one verdict; neither writes the artifact it judges.

It exists because the rest of the process assumes the demand will be built. The `use-case-creator` elicits, the `its-generator` plans, and impossibility surfaces only after both have been paid for. This skill is the cheap place to find out.

It is **invoked, never obligatory**. Nothing downstream requires a feasibility verdict, and a verdict never authorizes skipping the specification pipeline: *Viable* means the demand may enter refinement, not that it is specified.

## Evidence and judgment are separate acts

This skill does not derive reach. `impact-mapping` produces the evidence — what the demand touches, in which registered state, against which documented behavior — and this skill rules on it. The split is deliberate and it is the same one the repository already draws between `prime-core/quality-model` and `prime-architect/code-review`: defining and judging fail in different ways, and a skill that produces its own evidence and then rules on it has no one checking the first half.

Practically: **reference the map, never restate it.** The report cites the map; it does not copy the surface into itself.

## What this skill does not do

- **It does not estimate effort.** No hours, no story points, no sprint counts. Sizing belongs to the team that will do the work. What this skill delivers is the **cost drivers** — the facts an estimate is built from — read off the map.
- **It does not design the solution.** Naming a viable path is part of the verdict's reasoning; specifying it is the `its-generator`'s job, and only after the use cases exist.
- **It does not decide whether the demand is worth doing.** Value is the demander's call. This skill answers *can it be absorbed, at what structural cost, and what must be true first*.

## Step 0 — Load the configuration and the criteria

Read `docs/prime-config.md` per **prime-core/prime-config** — location, fallback, precedence, divergence handling, and bootstrap all live in that contract; never re-derive them here. From the config this skill uses: the stack and versions (the ceiling every proposed path must fit under), the **area register**, the **slot overrides**, the document locations including the ADR repository, and the verification commands.

Then load, as the criteria the judgment is anchored in: **prime-core/quality-model** (`QM-XX-N`), **prime-core/coding-standards** (`CS-XX-N`), and the **Accepted ADRs**.

**Cost is evidence, never a criterion.** The quality model answers *what good is*, not *what this costs*; do not stretch it into a cost vocabulary it does not own. Where the confrontation needs a criterion that does not exist — a convention slot with neither a stack default nor a project override — **report the gap** per `coding-standards` and never improvise the value. A criterion missing in three separate runs is the trigger for a governance PR against the core, not for a local invention.

## Step 1 — Restate the demand as something checkable

State in one or two sentences what observable outcome the demand claims, and confirm it with the architect. If the demand cannot be reduced to an observable change in system behavior — if it names a technology, a preference, or an aspiration instead of an outcome — **stop here** and return it. There is nothing to judge, and judging it anyway is how this skill would degrade into opinion.

Record explicitly what the demand does **not** claim. A boundary asserted at this step is what keeps the analysis from expanding into a system-wide review.

## Step 2 — Run the map

Run `impact-mapping` on the demand **as restated in Step 1** — that restatement is the map's subject line, and the map's own Step 1 is not re-run. What this skill consumes from it:

- the **three degrees** of reach — direct, coupled, contract surface;
- the **area states** overlay (`current`, `legacy-maintained`, `strangler`);
- the **documented layer** — use case coverage, divergences found, ADR incidence;
- the **procedence marking** on every line (anchored, `[INFERRED]`, `[UNVERIFIED]`, gap), whose vocabulary is defined by that skill and reused here unchanged;
- and, decisively, the **stated edge** — where the map deliberately stopped.

The edge is what makes *Undecidable* an honest verdict instead of an evasion. Ruling over a map that silently truncated its reach produces a confident verdict on a partial picture, which is the worst output this skill can produce. If the map itself stops at **Insufficient input** — its Step 1 could not restate the change without inventing intent — this run stops too, and returns the map's questions. That is not a verdict and must not be reported as one: there is no *Undecidable* here, because nothing was judged. A demand nobody could describe as a change to the system has not reached this skill yet.

Two findings from the map are read before any lens runs, because they change what a verdict can mean:

- **Undocumented affected area** → a `Condition:` with an owner and a route to `use-case-extractor`, not an unknown to absorb. Feasibility judged against code nobody has described is judged in the dark, but an undescribed area is a known gap with a known route — that is what a condition is for. Green-field addition touching no existing behavior needs no baseline; note it and proceed.
- **The one exception:** when the undocumented area is where a `Blocker:` would rest — the map places the demand's hardest constraint inside behavior nobody has described — the run is Undecidable with current evidence, naming the extractor run as the one that would decide it. Absence of a blocker carries the same evidentiary burden as a blocker: Viable with conditions asserts that nothing blocks, and asserting that over unread code is the failure this skill exists to prevent. This exception is stated and justified in the report, never assumed silently.
- **Divergence between code and use case** → where the two already disagree, **neither is a safe baseline**, and a verdict resting on the wrong one dissolves on contact. This alone can carry the run to *Undecidable*.

## Step 3 — The lenses, in decreasing order of what kills a demand

Each lens points to where its criterion lives — never redefines it. Run them over the map; do not re-walk the code the map already walked.

- **Constraint** — the hard ceilings: stack and version (config), platform, data that does not exist, an external dependency or license the project does not hold, a regulatory boundary. This lens produces the only findings that make something genuinely impossible, which is why it is read first and why it is usually the shortest.
- **Structural fit** — does the demand fight the shape of the system? `CS-AR-1..5`, `QM-CC-1..5`, and the ADR incidence carried in from the map. **A demand that contradicts an Accepted ADR is not infeasible** — it is an ADR question. It becomes a `Condition:` naming the ADR, owned by the architect and routed to the ADR lifecycle: the decision must be revisited before the demand enters specification. This skill does not draft the ADR. Drafting requires a Decision, and this skill designs nothing — it judges. The ADR is proposed later, by whoever takes the decision, through the flow the its-contract defines. Never treat a recorded decision as a wall, and never let one be overturned silently inside an analysis.
- **Contract surface** — of everything the map placed outside this codebase (API shapes, database schema, event payloads, exported files, shared signatures), can every known consumer be migrated, and can the consumer set be enumerated at all? An unenumerable consumer set is a finding in its own right.
- **Verification** — can the claimed outcome be proven done? The config's verification commands, the observability the affected areas actually have, and the test obligation the change would carry (`CS-TS-1`). A demand nobody can verify as delivered is feasible only under the condition that a way to verify it is built.
- **Erosion risk** — does the cheapest viable path introduce a *second* way of doing something the project already does one way (`QM-CN-1`)? Answering yes does not block; it names the debt the demand would create, so it can be taken deliberately (`QM-MT-1`) rather than discovered later in review.
- **Concurrency and scale** — only where the demand's outcome implies them (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`). Do not manufacture this lens for changes that do not carry it.
- **Security surface** — every new boundary the demand would open: `QM-SR-*`, `CS-SC-*`. A demand that opens one is not blocked by it, but the boundary is a condition with an owner.

## Step 4 — Evidence discipline

Every finding inherits its anchor from the map and carries it visibly. The vocabulary is `impact-mapping`'s; this skill adds one rule of its own:

**A `Blocker:` requires anchored evidence.** A blocker resting on `[INFERRED]` or `[UNVERIFIED]` evidence is not a blocker — it is the reason the verdict is *Undecidable with current evidence*. Anything asserted by the demand and never checked against code stays `[UNVERIFIED]` no matter how plausible it sounds.

## Step 5 — Classify every finding

A finding states **where**, **what**, **why** — citing an ID or an evidence anchor — and **what it implies for the demand**.

- **`Blocker:`** — the demand cannot be absorbed as specified. A hard constraint, or an outcome that contradicts an invariant with no path around it. Requires anchored evidence.
- **`Condition:`** — feasible, but only if something is true first. Every condition carries an **owner** and a **route** (a skill to run, a decision to take, a dependency to acquire). A condition without a route is a `Blocker:` in disguise.
- **`Cost driver:`** — does not block and does not condition; changes the size. Area state, breadth of the coupled set, contract surfaces crossed, missing observability, debt the path would create.
- **`FYI:`** — context the demander should have. No obligation.

Aggregate: several findings caused by one structural fact are one finding, stated where it can actually be addressed.

## Step 6 — The verdict, exactly one

The verdict is not read off the findings alone. It resolves from two inputs — the findings
classified in Step 5 and the **state of the evidence base** carried in from the map — applied
in this order, first match wins:

1. **An anchored `Blocker:` exists** → *Not viable as specified*. An anchored blocker is
   self-sufficient: gaps elsewhere in the evidence do not soften it, because nothing still to
   be discovered dissolves it — only a change in the demand does. Register the gaps as
   follow-ups and rule.
2. **No anchored blocker, and the evidence base does not support asserting that none exists**
   → *Undecidable with current evidence*. A blocker resting on `[INFERRED]` or `[UNVERIFIED]`
   evidence lands here, not in rule 1 (Step 4).
3. **Otherwise, at least one `Condition:`** → *Viable with conditions*.
4. **Otherwise** → *Viable*.

`Cost driver:` and `FYI:` never move the verdict. There is no *"viable but expensive"* verdict —
size is evidence handed to whoever decides, never a ruling.

### When the evidence base is insufficient

Rule 2 fires when, and only when, one of these holds:

- the map's **edge** stops short of what the verdict turns on;
- an unresolved **code × use case divergence** leaves no safe baseline;
- an **undocumented area carries the demand's hardest constraint** (Step 2) — a merely
  undocumented area is a `Condition:`, not an undecidability;
- a **dependency the outcome rests on** has never been tested.

This list is closed. A run that meets a fifth legitimate case adds it here by PR, with the run
that found it named — never by widening the rule locally. Same discipline `coding-standards`
applies to an unfilled slot: the gap is reported, not improvised.

### What each verdict obliges you to deliver

- **Viable** — the demand may enter the specification pipeline as written.
- **Viable with conditions** — every condition named, owned, and routed. This is the common
  verdict and it is not a hedge: it is the list of what to do first.
- **Not viable as specified** — blockers listed separately. Never delivered as a bare refusal:
  state **what would have to change in the demand** for the blocker to dissolve. A demand
  returned without a door is an obstacle, not a gate.
- **Undecidable with current evidence** — name the **one run that would decide it** (extractor
  on area X, a timeboxed spike on Y, a measurement of Z). This verdict is a result, not a
  failure — an invented verdict costs more than an honest gap.

Never deliver a verdict on a demand you did not understand. "Probably fine" is not a verdict.

## Step 7 — Follow-ups to register before closing

- Extractor run required to establish a baseline.
- Divergence routed to the use case skills (`QM-DO-1`) — never patched from inside this skill.
- **ADR decision to raise** — a recorded decision the demand challenges, including an Accepted ADR it would supersede. Raised as a `Condition:` with the architect as owner; the ADR itself is drafted by whoever takes the decision, never here.
- Unfilled slot to report (`coding-standards`) — never improvised.
- Config gap: a fact about the project the analysis needed and `docs/prime-config.md` does not carry.
- Debt the viable path would create, named with a prospective owner (`QM-MT-1`).

## Output

A feasibility report — a working artifact of the architect inside the team's refinement, not a
repository document. It is filed where the demand lives (tracker, PRD thread), never under
`docs/`, and it appears in no configuration. Header per the same rule as the map: `FA-<demand-id>-N`,
the date, and the demand.

It contains the restated demand and its boundary, **a reference to the impact map — by ID and
date**, the findings, the verdict with its one-line reason, and the follow-ups. A reference to a
map without its date is not a reference: Step 6 rule 2 turns on where that specific map stopped,
and an undated map cannot answer whether its edge still holds. The operational pass and the
report template live in `checklists/feasibility-checklist.md`.

Neither this report nor the map it cites is mandatory for a demand to exist or to advance. The
team owns the demand; these are tools the architect uses inside that process.

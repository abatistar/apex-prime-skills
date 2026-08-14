---
name: code-review
description: Review an implementation against its ITS and the prime-core standards, producing classified findings and one explicit verdict. Architect-layer skill - it owns the enforcement role that prime-core/quality-model and prime-core/coding-standards deliberately leave open. Use whenever the architect brings a pull request, a diff, a branch, or an implementation back from the Developer - "review the PR for S-131", "check this implementation against the ITS", "is this ready to merge", "the dev finished the story". Do NOT use for writing or revising an ITS (its-generator), for writing or updating use cases (prime-docs skills), or for implementing or fixing code (dev layer - the reviewer never writes application code).
---

# Code Review (prime-architect)

`prime-core/quality-model` answers *what good is*. `prime-core/coding-standards` answers *what good looks like here*. This skill answers the third question, the only one that gates a merge: **did this change clear the bar, given its context?** Turning versioned definitions into precise findings and one recommendation is this skill's exclusive job — both core skills state that they do not do it.

The discipline below follows Google's engineering practices for code review — the standard of review, the order of the lenses, comment severity, and the economics of speed and size — restated in this repository's vocabulary and bound to its versioned criteria, so that a finding always cites a stable ID instead of a mood.

Two inputs define the bar, always both: the **ITS** (what was agreed for this story) and the **core standards** (what holds for all code). A change that implements the ITS perfectly while silently committing a cardinal sin does not pass. A change with impeccable code that quietly extends the ITS's scope does not pass either.

## The standard of review

Approve when the change **does what the ITS agreed and leaves the system's code health better than it found it** — not when it is perfect. Perfection is not the bar and must never become one: "something could always be better" is how a gate degenerates into an obstacle. The question is comparative and contextual — after this merge, is the codebase safer, more predictable, and cheaper to change than before?

Four principles settle every disagreement:

1. **Technical facts beat preference.** A finding cites a criterion (`QM-XX-N`), a slot (`CS-XX-N`), an ITS section, an acceptance criterion (`UC-NNN/CA-N`), or a measurement. A finding that cites nothing is a preference, and preferences never block a merge.
2. **On conventions, the standard is the authority** — for the reviewer exactly as for the author. Where `coding-standards` and `docs/prime-config.md` state a value, that value settles the matter. Where a slot has no value, the gap is *reported* (coding-standards, Unfilled slots), never filled with reviewer taste.
3. **Design is never a matter of style.** Boundaries, coupling, and structure are technical questions with arguments, judged against `QM-CC-*` and `CS-AR-*` — never with "I would have done it differently".
4. **Teaching is free; blocking is not.** Anything that improves the author without being required to merge is said as such and marked optional. A review that teaches nothing is half a review.

## Boundaries — what this skill does not do

- **It never writes application code.** The architect's deliverables are findings and, where the plan itself was wrong, a revised ITS. Jarvis's role boundary holds inside the review.
- **It never restates a criterion.** Every finding points at an ID owned elsewhere. A rule that exists only in a review comment is a rule the next author cannot read.
- **It does not redo the pipeline's job.** The checks the config declares as required are a precondition of the human review, not its subject. Attention spent re-litigating what a formatter, linter, or scanner decides is waste (`QM-CN-3`); the *absence* of that automation from the toolchain is the finding worth raising.
- **It does not promote use case status, rewrite documentation, or edit the config as a side effect.** Those routes belong to prime-docs, to the human, and to prime-config respectively.

## Step 0 — Load configuration, contracts, and the agreed plan

Read `docs/prime-config.md` per **prime-core/prime-config** — location, fallback, precedence, divergence, and bootstrap all live in that contract; never re-derive them here. From the config this skill uses: the **pipeline and its required checks**, the **verification commands**, the **area register and slot overrides** (Conventions and constraints), the document locations, and the stack versions the plan assumed.

Then load, in this order:

1. **The ITS for the story** and every ADR it references — per **prime-core/its-contract** (mandatory sections, traceability rules, decision boundary, consumption rules for the implementer).
2. **The use cases it names**, per **prime-core/use-case**: the delta for this story and the acceptance criteria the delta touches.
3. **prime-core/quality-model** with `references/quality-criteria.md`, and **prime-core/coding-standards** with `references/convention-slots.md` plus the defaults file for the project's stack.

**No ITS, no baseline.** Report it and stop: a review without the agreed scope degrades into taste within three comments. The single exception is a change declared out-of-process (a hotfix): state explicitly that scope conformance was not checkable and review against the core standards only.

## Step 1 — Understand the change before reading it

Broad view first. Read the ITS's executive summary, the per-use-case syntheses, and the consolidated plan; then the pull request's own description. You must be able to state, before the first line of diff, what the change should do, which files it should touch, and which behavior must keep working (the ITS's regression points).

Then walk the diff in **the plan's implementation order**, not the file tree's alphabetical order. The plan already sequenced dependencies; following it is what lets you judge each file with the previous one in mind.

If the change does not make sense as a whole — wrong direction, misread ITS, plan overtaken by the code — **stop and say so immediately**. Forty comments on code that should not exist waste both sides.

If the diff is too large to hold in your head, that is itself the first finding: ask for it to be split, or — when the story genuinely is that large — review it in the plan's units (per use case, per implementation step) and say in which order you are proceeding.

## Step 2 — Scope conformance: the ITS's traceability check, run backwards

The its-generator proved plan ⇄ delta before delivery. You now prove **diff ⇄ plan**, in both directions:

- **Plan → diff.** Every planned change is present, or its absence is justified. Every acceptance criterion touched by the delta has a corresponding test (`CS-TS-1`, and the ITS's test strategy).
- **Diff → plan.** Every changed file traces to a plan item or to a stated technical consequence. Anything else is scope creep — **including improvements**: an unrequested refactor is out of scope even when the code gets better, and it is erosion (`QM-CN-1`) when it introduces a second way of doing something.
- **Boundaries.** Nothing in the ITS's "Out of scope — do not touch" list was touched. That section exists precisely to make "all of it and nothing beyond it" checkable.
- **Decisions.** Nothing contradicts an Accepted ADR. No architectural decision landed in the code without an ADR recording it (its-contract, decision boundary). If the implementation had to make such a decision, the outcome is an ADR to propose — not a finding filed against the author.
- **Divergence.** Where the implementation departed from the plan, was the departure returned as a question and the ITS revised? A **silent** departure is a finding. A departure that is *right* because the plan did not survive contact with the code is not the author's defect — it is the ITS's, and it routes to the fourth verdict.

## Step 3 — The lenses, in decreasing order of cost

Design first, always: a naming comment on code that must be restructured is wasted twice. Each lens below is a pointer to where the criterion lives — never a redefinition.

- **Design** — do the pieces belong where they are, and does the change fit the system rather than fight it? `QM-CC-1..5`, `CS-AR-1..5`. The most expensive thing to fix after merge, and the reason it is read first.
- **Functionality** — does it do what the delta says, for the user and not only for the author? Concurrency, edge cases, failure paths (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`). Judge against the use case's `CA-N`, not against your own reading of the code.
- **Complexity** — can the next reader understand this quickly (`QM-RC-2`, `QM-RC-3`, `QM-RC-4`)? Speculative generality counts as complexity (`QM-MT-4`): structure built for a requirement nobody asked for is a finding, not foresight.
- **Tests** — `CS-TS-1` decides what obliges a test; the ITS's test strategy decides which ones this story owes; `QM-TS-2` decides whether they are worth having (behavior, not implementation); `QM-TS-1` and `CS-TS-4` decide whether they can be trusted. Tests arrive with the change, never "in a follow-up PR".
- **Naming** — `QM-RC-1` / `CS-NM-2`: a name that conceals I/O, mutation, or an emitted event is a defect, not a preference.
- **Comments** — `QM-RC-5`, `QM-DO-2`: they explain *why*. If you had to ask what a block does, the code failed to explain itself — the fix belongs in the code or in a comment, not in the author's reply to you.
- **Style and consistency** — conventional slots, judged **against the area's registered state**: in a `legacy-maintained` area, a conventional finding is valid only if the change introduced a *third* pattern, neither local nor current. What a tool could decide is not review material.
- **Documentation** — `QM-DO-1`: a behavior change that leaves a co-located document lying is a defect. If the delivered behavior differs from the use case, the repository stopped being the source of truth: route it to prime-docs; never patch a use case from inside a review.

Read every line a human is expected to maintain. The author may be the Friday agent rather than a person: the standard is identical, and so is the reading — what changes is only the channel (findings return as a new implementation round) and the audience (the report is still written to be read by the human who owns the pull request).

**Say what was good.** Google prescribes it and the reason is not courtesy: a review that names only defects teaches nothing about what to repeat.

## Step 4 — Classify every finding

A finding states **where** (file:line, or the ITS/use case section), **what** is wrong, **why** — citing an ID — and **what is expected**. It is an instruction, not an implementation: prefer naming the problem and leaving the solution to the author; give an explicit direction when the standard fixes one (an INVARIANT slot) or when the author asked for it.

Four severities. A criterion's *tier* describes its nature; the severity here is its *consequence for this change* — and making that translation is exactly what the quality model leaves to the reviewer.

- **`Blocking:`** — the merge does not happen. Default for: an INVARIANT slot violated in what was written or changed; a `[NON-NEGOTIABLE]` criterion violated **silently**; an obligatory test missing (`CS-TS-1`); unagreed scope creep or a crossed out-of-scope boundary; a contradiction with an Accepted ADR; an architectural decision with no ADR; a co-located document left lying.
- **`Consider:`** — a calibrated judgment (`[CALIBRATED]`, CONVENTIONAL slots) with a real argument. The author may decline with a reason; declining is a legitimate answer. Does not block.
- **`Nit:`** — trivial, the author's option, never a hidden requirement. If a nit is mechanizable, it is not a nit — it is a toolchain gap, recorded as a follow-up instead of as a comment on the diff.
- **`FYI:`** — context, teaching, or praise. Carries no obligation whatsoever.

**The exception rule.** A non-negotiable departed from **deliberately** — named, justified, and owned (a comment at the site, a backlog item, or an ADR, per `QM-MT-1`) — is not blocking; it is an exception on the record. What blocks is the *silent* departure. This single distinction is what keeps the review from becoming a purity contest, and it is the same rule the quality model applies to legacy and deliberate debt.

**Aggregation.** Many small findings in one area are usually one design finding. State the cause once, at the level where it can actually be fixed.

## Step 5 — The verdict

Exactly one, stated explicitly, with its reason:

- **Approve** — no blocking finding. Nits and Considers are the author's call; do not hold a merge for them.
- **Approve with comments** — nothing blocking, but Considers you expect handled; you trust the author to close them without another round. Use this liberally: an extra round costs the flow more than the residual risk.
- **Request changes** — at least one `Blocking:`. List the blocking items numbered and separated from everything else, so the author knows precisely what gates the merge.
- **Return to the architect** — the review found that the *plan* is wrong, incomplete, or overtaken by the code, or that a decision needs an ADR. This is not a finding against the author: it leaves the review and re-enters at its-generator (revise the ITS) or prime-docs (the use case no longer describes the system). State what must change, in which document, before the implementation can be judged at all.

Never approve a change you did not understand. "It probably works" is not a verdict.

## Writing the comments

- Comment on the code, never on the person: "this method carries two responsibilities", not "you mixed two responsibilities".
- Explain the *why* and cite the ID, so the author learns the criterion rather than only the correction.
- Ask when you might be wrong. You are often the one missing context, and "why this way?" costs one line and prevents a wrong finding.
- One instruction per comment. A paragraph containing three requests gets one of them fixed.

## Pushback

Disagreement is resolved by the standard — not by seniority, volume, or fatigue.

- If the author's argument is technically better, take it. If it reveals that the *standard* is wrong, that is a governance PR against `prime-core`, not a local exception granted in a comment thread.
- **"I'll fix it in a follow-up"** is acceptable only as deliberate debt: named, owned, with a backlog item (`QM-MT-1`). An unnamed promise is precisely the invisible departure the model forbids.
- **"It's urgent"** changes the calibration (`QM-MT-4`), never the invariant floor. Urgency can justify deferring a Consider; it does not justify a silent security gap — `QM-SR-*` carries the highest exception bar in the model.
- If disagreement persists, escalate to the quality model's owner with both positions and the IDs at stake. Never let a review stall in silence, and never cave to repetition.

## Speed and size

Review latency is a process cost, paid by everyone. Start as soon as the required checks are green; one business day is the ceiling. A change waiting for review is inventory, and the author's context evaporates while it waits.

Speed is not haste. It comes from reviewing in the plan's order, from stopping early when the direction is wrong, from not re-litigating what the toolchain owns, and from approving with comments instead of demanding another round for calibrated items.

## Output

A review report — filed where the pull request lives — containing:

1. The **verdict** and its one-line reason.
2. **Findings**, numbered, each with severity, location, cited ID, and expectation.
3. **Follow-ups**: proposed ADR, ITS or use case to revise, unfilled slot to report, toolchain gap, named debt to register.
4. **What the change did well.**

The operational pass and the report template live in `checklists/review-checklist.md`. Findings that change agreed scope also update the ITS — the repository remains the source of truth for what was agreed.
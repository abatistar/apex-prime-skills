# Quality Criteria — v1.0

Canonical criteria catalog owned by `prime-core/quality-model`. The SKILL.md defines the tiers, the exception discipline, the versioning, the boundaries, and the consumption rules — this file is the criteria. This is a **definition** of the target, not an enforcement gate: new code is built against it, and the role skills reference it to question their deliverables. Cite criteria by ID (`QM-XX-N`). IDs are stable and never renumbered; version changes go through the governance PR and are recorded in the repository `CHANGELOG.md`.

**North star.** Quality is one property — *the system is safe, predictable, and cheap to change over time* — seen from eight angles. The dimensions below are lenses on it, not an independent checklist.

**Tiers (the nature of a criterion, not an automatic consequence).**
- **[NON-NEGOTIABLE]** — a cardinal sin: the floor for new code. Not *silently* negotiable — met, or departed from as a named, deliberate, owned exception (see below).
- **[CALIBRATED]** — judgment against context, stated with its honest tension. The model gives the criterion and the trade-off; the reader calibrates. Never a rule to apply mechanically.
- **[AUTOMATE]** — owned by tooling. Human attention re-litigating it is waste; its absence from the toolchain is what's worth raising.

**The calibration rule (applies to every dimension).** Excess is as harmful as deficiency. The bar is proportional to the code's expected lifetime and importance and to the realistic threat model. Maturity is knowing when a criterion stops applying.

**Exceptions (legacy and deliberate debt).** The model describes the target; real code departs from it for legacy and for chosen debt, and that is legitimate. The rule is *silent versus deliberate*: a departure is acceptable when named, justified, and owned (a comment, a backlog item, or an ADR) — the sin is the invisible departure, not the debt. The model applies to code you **write and change**, not retroactively to all legacy; in existing code, matching the local pattern (`QM-CN-2`) is itself a criterion. Security criteria (`QM-SR-*`) carry the highest exception bar — a silent gap there can be fatal on its own.

---

## The core floor — cardinal sins at a glance

The non-negotiables, gathered for scanning. Each is the floor for new code and may be departed from only as a named, deliberate, owned exception. Everything else in the catalog is structured judgment.

- **QM-RC-1** — No lying names, no hidden side effects; code does what it appears to do.
- **QM-TS-1** — No flaky test left in the suite: fix immediately or remove.
- **QM-TS-2** — Tests verify behavior, not implementation.
- **QM-TS-4** — Coverage is never a merge gate; read only as a negative signal.
- **QM-CC-1** — No shared mutable state coupling between modules.
- **QM-CN-1** — No erosion: established patterns change deliberately and wholesale, never piecemeal.
- **QM-CN-2** — Consistency with the surrounding code beats personal preference.
- **QM-EO-1** — Never swallow an error silently.
- **QM-EO-2** — Never leak sensitive data in logs or error messages, or expose internals to end users.
- **QM-EO-3** — Preserve the cause chain and stack trace when propagating.
- **QM-MT-1** — No invisible deliberate debt: a shortcut taken on purpose is named when taken.
- **QM-DO-1** — Documentation must not lie; it lives beside what it describes.
- **QM-SR-1** — Never trust external input: validate at the boundary, keep data separated from code.
- **QM-SR-2** — No secrets in source or version control.
- **QM-SR-3** — Don't roll your own crypto; never store passwords plaintext or reversibly.
- **QM-SR-4** — Don't ship known-vulnerable dependencies.

---

## RC — Readability & clarity
*Unifying principle: minimize cognitive load — how much a reader must hold in working memory to understand a piece in isolation.*

- **QM-RC-1 [NON-NEGOTIABLE]** — Principle of least surprise. Code does what it appears to do. A name or signature must not conceal state mutation, I/O, or events (no `getX` that also writes; no "read" that mutates global state or fires an event). Names must not lie.
- **QM-RC-2 [CALIBRATED]** — Functions are short, do one thing, at a single level of abstraction (no byte-level detail mixed into high-level orchestration). *Tension: this is not a line-count rule; over-fragmentation into tiny functions harms readability as much as monoliths.*
- **QM-RC-3 [CALIBRATED]** — Flatten nesting with guard clauses / early returns; high cyclomatic complexity is the measurable symptom. *Tension: threshold, not absolute — judge by the reader's load.*
- **QM-RC-4 [CALIBRATED]** — Keep things that change together close (locality). Duplication is cheaper than the wrong abstraction; abstractions must be "deep" (simple interface hiding real complexity), not "shallow" (indirection that hides nothing). *Tension: DRY taken to the extreme destroys locality — a little duplication can be the right price.*
- **QM-RC-5 [CALIBRATED]** — Comments explain *why*, not *what*; self-explanatory code first, comments for the irreducible remainder (external constraint, avoided bug, non-obvious choice). *Tension: a comment restating the code rots into a lie; a comment explaining *what* a confusing block does usually signals the block should be rewritten.*
- **QM-RC-6 [CALIBRATED]** — No cleverness that optimizes the writer's ego over the reader's time (dense one-liners, language-trick golf). Optimize for the reader — the more frequent audience.
- **Audience note.** Readability is relative to the team that maintains the code; there is no absolute. The most reliable test is not a metric but review: every "what does this do?" / "why this way?" is a point where the code failed to explain itself.
- **[AUTOMATE]** — Complexity metrics as signals (not verdicts). Formatting belongs to CN.

## TS — Reliable automated tests
*Unifying principle: confidence to change. A test is worth the degree to which it lets you alter code knowing that a real break will be caught and a pass means behavior is preserved.*

- **QM-TS-1 [NON-NEGOTIABLE]** — A flaky test is fixed immediately or removed. Leaving it trains the team to ignore red, which destroys the authority of the whole suite.
- **QM-TS-2 [NON-NEGOTIABLE]** — Tests verify observable behavior, not internal implementation. Golden test: *if I rewrite the implementation preserving behavior, does this test still pass?* If not, it tests the wrong thing and punishes the refactoring it should enable.
- **QM-TS-4 [NON-NEGOTIABLE]** — A coverage percentage is never used as a merge gate (Goodhart). Coverage is read only as a negative signal: low coverage flags weak testing; high coverage proves nothing about assertions.
- **QM-TS-3 [CALIBRATED]** — Favor testing real code within the speed/stability budget; mock the boundaries you don't control, test the core you do. *Tension: pyramid vs. trophy is weight-tuning, not law; mocks buy speed and isolation at the price of realism — use where the price is worth it.*
- **QM-TS-5 [CALIBRATED]** — Test readability: one reason to fail, clear arrange-act-assert, names stating scenario and expected result. *Tension: a test asserting fifteen things tells you nothing when it fails.*
- **QM-TS-6 [CALIBRATED]** — Determinism and isolation: each test builds and tears down its own world, order-independent. Also cover error/failure paths, not just the happy path — untested error handling is usually code that has never run.
- **Governing question.** *Does this suite let me change the system with confidence and speed?* If touching code hurts because of the tests, something in them is wrong, however green. (Guard against "test-induced design damage": tests serve the code, not the reverse.)
- **[AUTOMATE]** — Suite in CI; flaky detection; mutation testing as the deeper signal of test quality.

## CC — Coupling & cohesion
*Unifying principle: contain the blast radius of a change — a business change should fit a small, predictable region of code.*

- **QM-CC-1 [NON-NEGOTIABLE]** — No coupling through shared mutable state (global or shared mutable memory) between modules. It is the worst kind because it is invisible in the interface — nothing in the signatures reveals the tie, and it surfaces as bugs at a distance. Hidden temporal coupling and shared-database-table coupling fall under the same prohibition when left implicit.
- **QM-CC-2 [CALIBRATED]** — Cohesion by "changes for the same reason, at the request of the same stakeholder" (SRP correctly understood). Prefer feature/domain grouping over technical-layer grouping. *Tension: a module serving two different stakeholders has two reasons to change and they will collide — but forcing unrelated things together to look tidy is worse.*
- **QM-CC-3 [CALIBRATED]** — Coupling *type* matters more than amount (zero is impossible). Avoid control coupling (flags that switch hidden behavior) and structure coupling; dependencies point toward stability (volatile depends on stable, never the reverse); apply dependency inversion where volatility differs. *Tension: the coupling you foresaw and contained at a clean boundary is rarely the problem.*
- **QM-CC-4 [CALIBRATED]** — Law of Demeter as a smell, not a law: long dot-chains (`a.b.c.d`) couple you to the internal shape of things you don't own. *Tension: chaining is fine for pure data structures — treat it as a reliable smell, not a ban.*
- **QM-CC-5 [CALIBRATED]** — Decouple by *probability of independent change*. Decoupling things that always change together is pure cost; every indirection is an enemy of locality. *Tension: premature abstraction / speculative generality is indistinguishable from debt — YAGNI.*
- **Signal.** "A change that should be small but spreads" is the map to a joint cut in the wrong place. These three dimensions (readability, tests, coupling) are consequences of the same act: cutting the system at the right joints.
- **[AUTOMATE]** — Dependency-direction / architecture-fitness checks (concrete layering rules live in `coding-standards`).

## CN — Consistency
*Unifying principle: make the code predictable — learn a pattern once and trust it everywhere. Inconsistency is systematized surprise.*

- **QM-CN-1 [NON-NEGOTIABLE]** — No erosion. You do not introduce a second way of doing something already established, one file at a time. Pattern migration is deliberate and repo-wide (ideally automated), or it does not happen. Half-old/half-new is the worst state.
- **QM-CN-2 [NON-NEGOTIABLE]** — In existing code, the local pattern beats your opinion of the "better" pattern. Writing your trecho the "better" way introduces a second convention and makes the base worse. First question on entering code: "how does *this* base do it?"
- **QM-CN-3 [CALIBRATED]** — Four levels: formatting → naming/conventions → idiomatic patterns → architectural/conceptual. The shallower, the more mechanizable and the less it matters; the deeper, the more it matters and the more it needs human judgment. Push the mechanizable to tools to free attention for the deep levels. *(Concrete conventions are owned by `coding-standards`; this criterion defers to it.)*
- **QM-CN-4 [CALIBRATED]** — Consistency is not blind uniformity: things that genuinely differ should look different (beware false symmetry — same-looking, different-behaving). A convention is uniform-at-a-moment, not permanent — it must not ossify the base. *Tension: the escape from "foolish consistency" is deliberate, wholesale change, never erosion.*
- **[AUTOMATE]** — Formatters, linters, type checkers, CI-enforced conventions. Style debate in review is process debt: the tool decides impersonally, and the reviewer's attention goes to logic and design.

## EO — Error handling & observability
*Unifying principle: preserve the ability to understand the system when it fails — diagnosability. You write error-handling code in calm and use it in panic.*

- **QM-EO-1 [NON-NEGOTIABLE]** — Never swallow an error silently: no empty catch, no caught-and-ignored, no returning null in place of signaling failure. It destroys information at the source and the failure re-emerges later, elsewhere, disguised. It is the maximum violation of predictability — the system lies about having worked.
- **QM-EO-2 [NON-NEGOTIABLE]** — Never leak sensitive data (passwords, tokens, PII, keys) in logs or error messages, and never expose internal detail or stack traces to end users. Error messages have two audiences: the user gets something generic and safe; the operator gets full detail in internal logs. (Cross-referenced by SR.)
- **QM-EO-3 [NON-NEGOTIABLE]** — Preserve the cause chain and original stack trace when propagating. Catching a rich exception and rethrowing a context-less generic one destroys the root cause.
- **QM-EO-4 [CALIBRATED]** — Fail fast on invalid/impossible state; validate at the system boundary so the core can trust its inputs. *Tension: shorten the distance between cause and symptom — that distance is what sets diagnosis cost.*
- **QM-EO-5 [CALIBRATED]** — Distinguish expected errors (domain situations — model as return values / `Result` / `Option` that the signature forces the caller to handle) from bugs (violated invariants — fail loud). Reserve exceptions for the exceptional. *Tension: treating the two alike either masks defects that should scream or floods alerts with routine events.*
- **QM-EO-6 [CALIBRATED]** — Concentrate recovery at a layer with enough context to decide (retry, default, degrade, notify); don't smear partial, uninformed handling across every layer.
- **QM-EO-7 [CALIBRATED]** — Observability: the three pillars answer different questions (logs = what happened here; metrics = overall health/trend; traces = a request across services) and are complementary, not substitutable. Instrument for the *unforeseen*, not only the predicted — the incidents that hurt are the ones you didn't foresee.
- **QM-EO-8 [CALIBRATED]** — Logs: disciplined, consistent levels; structured (key-value) context so you can search and aggregate; a correlation ID stitching a request's lines; respect signal-to-noise. *Tension: verbosity is not observability — the line that explained the bug drowns in ten thousand "processing..." lines. Instrument critical paths with intention; it has real cost.*
- **Governing question.** *When this breaks at 3am, can on-call find out why from what the system recorded?*

## MT — Maintainability & technical debt
*Unifying principle: keep the cost of change low over time — the effort per change must not grow with the system's age. This dimension is largely the others' effect seen on the time axis.*

- **QM-MT-1 [NON-NEGOTIABLE]** — No invisible deliberate debt. A shortcut taken on purpose is named when taken — honest comment, backlog item, or ADR. The debt that kills is the tacit one that lives as diffuse dread and never enters a prioritization conversation.
- **QM-MT-2 [CALIBRATED]** — Watch the effort-per-change curve: healthy is roughly flat (the 100th feature costs like the 10th); sick is exponential. The two regimes start identical — cutting corners is faster at first, which is why it's done. *Tension: debt is a legitimate instrument when deliberate and prudent (Fowler's quadrant); it is only damage when imprudent.*
- **QM-MT-3 [CALIBRATED]** — Pay debt continuously via in-place refactoring: boy-scout rule + "first make the change easy, then make the easy change." Cleanup is part of the feature's legitimate cost, not a separate project. *Tension: avoid big-bang refactoring mutirões and total rewrites (Spolsky) — prefer strangler-fig incremental replacement; and "better" must not mean imposing personal style piecemeal (see QM-CN-1).*
- **QM-MT-4 [CALIBRATED]** — Maintainability is a context choice: care must match expected lifetime and importance. A prototype discarded in two weeks and a ten-year core are not held to the same bar. *Tension: over-engineering / speculative flexibility (YAGNI) is its own debt — it raises today's cost of change for a future that never came.* **This is the calibration rule made concrete; every other criterion inherits it.**
- **QM-MT-5 [CALIBRATED]** — Non-code factors count: can a new dev run the project in minutes; are dependencies alive and patched; are build/CI times short. Maintainability is a property of the whole development system, not only the source text.
- **[AUTOMATE]** — Dependency freshness/health (shared with SR), build and CI time monitoring.

## DO — Proportional documentation
*Unifying principle: preserve the knowledge the code cannot carry — specifically the knowledge that does not fit in code.*

- **QM-DO-1 [NON-NEGOTIABLE]** — Documentation must not lie. Outdated docs are worse than none (an active trap versus an honest gap). Docs live as close as possible to what they describe — in the repo, versioned together, reviewed in the same PR — because physical distance is what permits desync. Prefer documentation that *cannot* lie: tests, types, examples that run in CI. A behavior change that leaves a co-located doc contradicting it is a defect.
- **QM-DO-2 [CALIBRATED]** — Document the *why*, not the *what*: the code is the source of truth for the *how* and, if readable, the *what*; the *why* (discarded alternatives, external constraints, avoided traps) is the sovereign territory of docs. Self-explanatory code first; a comment explaining a confusing block usually means the block should be rewritten. *Tension: the legitimate exception is essential complexity (a dense formula, a third-party workaround).*
- **QM-DO-3 [CALIBRATED]** — Triage: document only what the code cannot carry **and** what changes slowly enough to be worth syncing. *Tension: over-documentation drowns the important (signal-to-noise) and multiplies the surface that can rot; low-value, high-volatility docs are pure debt.*
- **QM-DO-4 [CALIBRATED]** — Write for a defined audience (user of the API / maintainer / newcomer / operator); don't mix Diátaxis modes (tutorial, how-to, reference, explanation). Newcomer onboarding (README, working "getting started") is the most neglected and highest-return. *(Decision records are ADRs, owned by `its-contract`'s decision boundary — this criterion references them, does not redefine them.)*
- **[AUTOMATE]** — Runnable-example tests in CI; link checkers.

## SR — Security & robustness
*Unifying principle: assume everything from outside is hostile until proven otherwise — disciplined distrust of the boundary. Security asymmetry: the defender must be right everywhere; the attacker needs one miss.*

- **QM-SR-1 [NON-NEGOTIABLE]** — Never trust external input (user, network, file, another service, even another part of your own system). Validate at the boundary and keep the data/code separation: parameterized queries against SQL injection, context-aware output encoding against XSS, never interpolate input into a command. Most classic vulnerabilities are the same sin: data crossed the data→code boundary un-neutralized.
- **QM-SR-2 [NON-NEGOTIABLE]** — No secrets (passwords, API keys, tokens, credentials) in source or version control. Git history is permanent; "private repo" is not protection. Secrets live in dedicated vaults or injected env vars, and must be rotatable.
- **QM-SR-3 [NON-NEGOTIABLE]** — Don't invent cryptography: use established, maintained libraries the standard way. Passwords are stored with a password-appropriate hash (slow, salted), never plaintext and never "encrypted" (reversible); sensitive traffic goes over encrypted channels.
- **QM-SR-4 [NON-NEGOTIABLE]** — Don't ship known-vulnerable dependencies. Your system is all the code you imported, transitively; an outdated dependency is an unlocked door whose location is published. Keep patched and scan automatically.
- **QM-SR-5 [CALIBRATED]** — Least privilege: every part (service, process, credential, user) gets only the access its function needs, to contain the blast radius when — not if — something is compromised. *Tension: as tight as practical without sabotaging work.*
- **QM-SR-6 [CALIBRATED]** — Defense in depth: multiple independent layers, so one breach is not total. Prefer several fences to one high wall.
- **QM-SR-7 [CALIBRATED]** — Robustness (the non-adversarial cousin): idempotency for operations that will be repeated (timeouts, retries), graceful degradation (reduced service over total collapse), timeouts and limits on every external wait and unbounded growth. *Tension: assume everything that can go wrong in the environment eventually will, without turning every local hiccup into a global failure.*
- **The mature question.** Not "is this secure?" (nothing is, absolutely) but "is this secure enough against the realistic threats for *this* system, without friction that sabotages use?" Security users bypass (the impossible password on a post-it) is worse than moderate security they follow. This is threat modeling, the opposite of security theater. Security must be systematic (forced by architecture), not heroic (depending on every dev remembering).

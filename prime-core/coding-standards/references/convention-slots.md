# Convention Slots — v1.0

Canonical slot catalog owned by `prime-core/coding-standards`. The SKILL.md defines the application classes, the legacy register, the migration discipline, and the consumption rules — this file is the slots.

**A slot is a question, not an answer.** Each entry states the decision a project must have taken, its application class, and the quality criterion it makes checkable. Values live in `references/defaults-<stack>.md` (team default) and in `docs/prime-config.md` (project override, which wins).

**Classes.** **[INVARIANT]** applies to every line written or changed regardless of surroundings. **[CONVENTIONAL]** defers to the local pattern in registered legacy areas.

**Unfilled is a gap, not a choice.** A slot with no value is reported, never improvised.

Cite slots by ID. IDs are stable and never renumbered.

---

## The invariant floor at a glance

The slots that hold regardless of what surrounds the change. Everything else in the catalog defers to the area's registered state.

`CS-AR-1` layer direction · `CS-AR-3` boundary types · `CS-NM-2` honest names · `CS-ER-4` two audiences · `CS-ER-5` cause chain · `CS-ER-6` no silent swallow · `CS-OB-3` logging denylist · `CS-DA-4` applied migrations immutable · `CS-CT-1` no silent breaking change · `CS-TS-1` what obliges a test · `CS-TS-4` deterministic tests · `CS-SC-1` authorization placement · `CS-SC-2` boundary validation · `CS-SC-3` secrets · `CS-SC-4` cryptography · `CS-DP-2` one library per concern · `CS-DP-3` vulnerable dependencies

---

## AR — Architecture and dependencies

*The slots with the longest half-life and the highest automation yield. Decide these first.*

- **CS-AR-1 [INVARIANT]** — **Permitted dependency direction.** Which layer or module may depend on which, and which direction is forbidden. Stated as a rule a tool can check, not as a diagram. Serves `QM-CC-3`.
- **CS-AR-2 [INVARIANT]** — **Where business rules may live.** The layer that owns decisions, and the layers that must contain none. The most common erosion is the rule that migrates into the controller or the query.
- **CS-AR-3 [INVARIANT]** — **Types that never cross a boundary.** Persistence types exposed by the API, framework annotations inside the domain, transport types reaching the core. Name the forbidden crossings explicitly.
- **CS-AR-4 [CONVENTIONAL]** — **Module grouping.** By feature/domain or by technical layer, and at which depth. Serves `QM-CC-2`.
- **CS-AR-5 [CONVENTIONAL]** — **Cross-module communication style.** Direct call, published interface, domain event, message. Which is the default and what justifies the others.

## NM — Naming and structure

- **CS-NM-1 [CONVENTIONAL]** — **Semantic suffixes.** Which suffixes exist and what each one promises about the type's responsibility. A suffix that means nothing is worse than none.
- **CS-NM-2 [INVARIANT]** — **Names that carry side effects.** Which prefixes assert purity and which announce I/O, mutation, or event emission. This is `QM-RC-1` made checkable: a name asserting one thing while doing another is a defect, not a style preference.
- **CS-NM-3 [CONVENTIONAL]** — **Where a concept lives.** The rule connecting a name to a location, so a reader finds a type without searching.

## ER — Errors

- **CS-ER-1 [CONVENTIONAL]** — **Expected error vs. bug: representation.** How a domain situation is signalled versus a violated invariant. Serves `QM-EO-5`.
- **CS-ER-2 [CONVENTIONAL]** — **Error taxonomy.** The base hierarchy or result type, and how a new error category is added.
- **CS-ER-3 [CONVENTIONAL]** — **Where errors are caught and translated.** The layer holding enough context to decide (`QM-EO-6`), and the layers that must only propagate.
- **CS-ER-4 [INVARIANT]** — **Two audiences.** What the caller receives versus what the operator receives. Concretizes `QM-EO-2`: generic and safe outward, full detail inward.
- **CS-ER-5 [INVARIANT]** — **Cause preservation.** Propagation carries the original cause and stack. Concretizes `QM-EO-3`.
- **CS-ER-6 [INVARIANT]** — **No silent swallow.** The concrete shapes forbidden in this stack — empty catch, ignored return, null in place of a failure signal. Concretizes `QM-EO-1`.

## OB — Observability

- **CS-OB-1 [CONVENTIONAL]** — **Log format and level semantics.** What each level actually means here, and the structured shape that makes lines searchable. Serves `QM-EO-8`.
- **CS-OB-2 [CONVENTIONAL]** — **Correlation propagation.** How a request identifier is created, carried across calls, and reaches every line.
- **CS-OB-3 [INVARIANT]** — **The logging denylist.** The closed list of what is never written to a log or an error message: credentials, tokens, personal data, payloads containing them. The highest-return single line in this catalog.
- **CS-OB-4 [CONVENTIONAL]** — **What must be instrumented.** The paths that carry metrics and traces by default, so instrumentation is systematic rather than remembered. Serves `QM-EO-7`.

## DA — Data and transactions

- **CS-DA-1 [CONVENTIONAL]** — **Transactional boundary.** Where a transaction opens and closes, and which layers must never open one.
- **CS-DA-2 [CONVENTIONAL]** — **Idempotency and retry.** Which operations must be safe to repeat and how repetition is detected. Serves `QM-SR-7`.
- **CS-DA-3 [CONVENTIONAL]** — **Migration convention.** Naming, ordering, and the compatibility rule for deploys that overlap versions.
- **CS-DA-4 [INVARIANT]** — **Applied migrations are immutable.** A migration that ran anywhere is never edited; correction is a new migration.
- **CS-DA-5 [CONVENTIONAL]** — **Loading discipline.** The default fetching strategy and how a query declares what it needs, so N+1 is prevented by convention rather than found in production.

## CT — External contracts

- **CS-CT-1 [INVARIANT]** — **No silent breaking change.** What counts as breaking for a published contract, and the versioning route a breaking change must take.
- **CS-CT-2 [CONVENTIONAL]** — **Collection shape.** Pagination, filtering, sorting, and the envelope — decided once, identical everywhere.
- **CS-CT-3 [CONVENTIONAL]** — **Serialization boundary.** The types that carry the contract, distinct from the domain model, and where translation happens.
- **CS-CT-4 [CONVENTIONAL]** — **Canonical representations.** Time, money, quantity, and identifiers. Each has exactly one representation across the system.

## TS — Tests

- **CS-TS-1 [INVARIANT]** — **What obliges a test.** The change categories that never merge untested. Everything else is judgment; this is not.
- **CS-TS-2 [CONVENTIONAL]** — **Layout and naming.** Where tests live, how the kinds are distinguished, and the naming that states scenario and expectation. Serves `QM-TS-5`.
- **CS-TS-3 [CONVENTIONAL]** — **What is mocked.** The boundaries replaced by doubles and the code exercised for real. Serves `QM-TS-3`.
- **CS-TS-4 [INVARIANT]** — **Determinism.** The concrete prohibitions that keep the suite trustworthy: no sleeping on timing, no order dependence, no state shared between tests. Serves `QM-TS-1` and `QM-TS-6` — a suite that is occasionally red teaches the team to ignore red.

## SC — Security

*Concrete placement only. The principles are `QM-SR-*`; the exhaustive control list belongs to an external standard the project targets (`CS-SC-5`), never to a rewritten copy here.*

- **CS-SC-1 [INVARIANT]** — **Where authorization is enforced.** The single layer that decides, and the explicit statement that no client-side check counts.
- **CS-SC-2 [INVARIANT]** — **Boundary validation.** Where external input is validated and neutralized, and the data/code separations that are never optional. Concretizes `QM-SR-1`.
- **CS-SC-3 [INVARIANT]** — **Secrets.** Where credentials live, how they reach the process, and the rotation expectation. Concretizes `QM-SR-2`.
- **CS-SC-4 [INVARIANT]** — **Cryptography and credential storage.** The sanctioned libraries and algorithms. Concretizes `QM-SR-3`.
- **CS-SC-5 [CONVENTIONAL]** — **External standard and level.** The security standard the project targets and at which level, referenced rather than transcribed.

## DP — Third-party dependencies

- **CS-DP-1 [CONVENTIONAL]** — **Admission criteria.** What a new dependency must satisfy — maintenance, licence, footprint — and who approves it.
- **CS-DP-2 [INVARIANT]** — **One library per concern.** A concern already served by a sanctioned library does not acquire a second one. This is `QM-CN-1` at the dependency level, and it is how a codebase ends up with three date libraries.
- **CS-DP-3 [INVARIANT]** — **Known-vulnerable dependencies.** The policy for shipping with an open advisory, and who owns the exception. Concretizes `QM-SR-4`.

## PR — Canonical solutions and prohibitions

*The only form of "design pattern" this catalog holds. Prescribing named patterns produces ceremony; cataloguing the agreed solution to a recurring problem produces consistency.*

- **CS-PR-1 [CONVENTIONAL]** — **Canonical solution register.** For each recurring problem in *this* system, the agreed solution and where an example lives. Calling an external service, publishing an event, scheduling work, handling partial failure. Grows by observation, not by anticipation.
- **CS-PR-2 [INVARIANT]** — **Prohibited patterns.** A short list, each with the concrete failure that earned it a place. A prohibition without a reason is folklore and will be violated the moment its author leaves.
- **CS-PR-3 [CONVENTIONAL]** — **No pattern prescribed by name.** Standards state the problem and the sanctioned solution; they never mandate a named pattern as such. Speculative structure is its own debt (`QM-MT-4`).

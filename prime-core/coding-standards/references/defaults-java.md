# Team Defaults — Java

Default slot values for the team's Java stack, owned by `prime-core/coding-standards`. Applied when `docs/prime-config.md` states nothing for the slot; any value the project declares wins. Slot definitions and application classes live in `convention-slots.md` — this file only supplies answers.

Entries marked **(Spring)** assume Spring Boot and are skipped by projects that do not use it; those projects declare the slot in their config instead. Baseline: Java 17.

---

## AR — Architecture and dependencies

- **CS-AR-1** — `api → service → domain`, `persistence → domain`. The domain depends on nothing. The API layer never reaches a repository directly; the persistence layer never calls a service. Enforced by an ArchUnit test that fails the build, not by review.
- **CS-AR-2** — Business decisions live in `domain`. A controller maps and delegates; a repository queries. A conditional expressing a business rule in either is a defect.
- **CS-AR-3** — JPA entities never leave the persistence and service layers: never a `@RequestBody`, never a `@ResponseBody`, never a field of a DTO. No `jakarta.persistence` or `org.springframework` import inside `domain`.
- **CS-AR-4** — Group by feature, then by layer inside the feature (`billing/api`, `billing/domain`). Technical-layer-first packaging is the legacy shape and is not extended.
- **CS-AR-5** — Default is a direct call through a published interface. Domain events for effects that must not block the originating transaction; messaging for cross-service work. Anything else is justified in the ITS.

## NM — Naming and structure

- **CS-NM-1** — `*Controller` (HTTP boundary), `*Service` (application orchestration), `*Repository` (persistence), `*Client` (external call), `*Mapper`, `*Config`, `*Properties`, `*Test`, `*IT`. No `*Manager`, `*Helper`, `*Util` in new code — each is a name for "I did not decide what this is".
- **CS-NM-2** — `getX()` and `isX()` are pure and cheap: no I/O, no mutation, no event. Anything that reaches storage or a network is `load*`, `fetch*`, or `find*`; anything that mutates is a verb naming the effect (`confirmOrder`, not `processOrder`). Absence is `Optional`, never `null`; a collection is empty, never `null`.
- **CS-NM-3** — One public type per file, named for the file. A type used by exactly one feature lives in that feature's package, not in a shared one.

## ER — Errors

- **CS-ER-1** — Expected domain situations are typed subclasses of `BusinessException` (unchecked). Violated invariants use `IllegalStateException` / `IllegalArgumentException` and are never caught for control flow. No checked exceptions in new code.
- **CS-ER-2** — Every `BusinessException` subclass carries a stable error code. A new category is a new subclass plus a code, never a string message parsed by the caller.
- **CS-ER-3** — Translation happens once, at the API boundary, in a `@RestControllerAdvice` **(Spring)**. Service and domain layers propagate. No `try/catch` whose only act is logging and rethrowing.
- **CS-ER-4** — Outward: RFC 7807 `ProblemDetail` with the error code and a safe message — no stack trace, no internal identifier, no SQL. Inward: full exception with cause, logged once at the boundary that translates it.
- **CS-ER-5** — Always `throw new SomethingException(message, cause)`. Never `new RuntimeException(e.getMessage())`, which discards the chain that `QM-EO-3` exists to protect.
- **CS-ER-6** — Forbidden: empty `catch`; `catch (Exception e)` outside the boundary advice; `catch` that returns `null` or a default in place of signalling; ignored `Future`/`CompletableFuture` results.

## OB — Observability

- **CS-OB-1** — SLF4J only, JSON-structured output, parameterized messages (`log.info("order confirmed {}", id)`) — never string concatenation. `ERROR` = needs a human tonight; `WARN` = degraded but handled; `INFO` = a business event happened; `DEBUG` = diagnosis, off in production.
- **CS-OB-2** — `traceId` and `spanId` in the MDC on every request and consumed message, propagated to outbound calls. Micrometer Tracing **(Spring)**.
- **CS-OB-3** — Never logged: passwords, tokens, API keys, authorization headers, full card numbers, CPF/CNPJ, addresses, complete request or response bodies of endpoints carrying any of the above. An entity or DTO holding a sensitive field never reaches a log through its `toString()` — the field is masked at the type.
- **CS-OB-4** — Every outbound integration is timed and counted. Every business event that a stakeholder would ask about gets one `INFO` line with the identifiers needed to correlate it.

## DA — Data and transactions

- **CS-DA-1** — `@Transactional` sits on the application service method and nowhere else **(Spring)**: never on a controller, never on a repository, never on a private method or a self-invoked one (the proxy will not apply it — a silent failure this rule exists to prevent). No external call inside a transaction.
- **CS-DA-2** — Every consumer of a message or webhook is idempotent, keyed on a business or delivery identifier. Retries are bounded, with backoff, and only for transient failures.
- **CS-DA-3** — Flyway, `V<n>__snake_case_description.sql`. Deploys overlap versions, so schema changes are backward compatible for one release: add before use, stop using before drop.
- **CS-DA-4** — A migration that ran in any environment is never edited. Correction is a new migration.
- **CS-DA-5** — All associations `LAZY`. Open Session In View disabled (`spring.jpa.open-in-view=false`) **(Spring)** — it hides N+1 behind lazy loading in the view layer. A query needing an association declares it with a join fetch or an `@EntityGraph`.

## CT — External contracts

- **CS-CT-1** — URI versioning (`/api/v1/...`). Additive changes only within a version: new optional fields yes, removed or renamed fields and narrowed types no. A breaking change is a new version with an announced sunset for the old one.
- **CS-CT-2** — Page-based pagination with `page`/`size`, `size` capped server-side. Sorting via `sort=field,direction`. Collections always return an envelope with the page metadata, never a bare array.
- **CS-CT-3** — Request and response DTOs are `record` types in the API layer, with Bean Validation annotations. Mapping is explicit and tested; no entity is ever serialized.
- **CS-CT-4** — `Instant` in UTC for instants, `LocalDate` for dates without time, ISO-8601 on the wire. `BigDecimal` for money, with the scale declared — never `double` or `float`. `UUID` for external identifiers; database sequence identifiers are never exposed.

## TS — Tests

- **CS-TS-1** — Never merged untested: a new or changed endpoint or consumer (integration test), a new or changed business rule (unit test on the domain), a fixed bug (a test that fails before the fix). Everything else is judgment.
- **CS-TS-2** — `*Test` for unit tests (no Spring context), `*IT` for integration tests (Testcontainers, real database). Method names state scenario and expectation: `should_rejectOrder_when_creditLimitExceeded`. JUnit 5 + AssertJ.
- **CS-TS-3** — Mock only boundaries the team does not control: external HTTP, message brokers, clocks. The database is real via Testcontainers — an in-memory substitute tests a dialect nobody runs. Never mock the type under test or its value objects.
- **CS-TS-4** — No `Thread.sleep` for synchronization; use Awaitility. No dependence on execution order, no state shared between tests, no reliance on `LocalDateTime.now()` — time is injected through a `Clock`.

## SC — Security

- **CS-SC-1** — Authorization is enforced at the application service, method-level (`@PreAuthorize` or an explicit check) **(Spring)**. A check performed only in the controller is insufficient; a check performed only in the client is not a check.
- **CS-SC-2** — Bean Validation on every boundary DTO, allowlist semantics. Queries are parameterized — never string concatenation into JPQL, native SQL, or Criteria. External input never reaches a file path, a command, or a deserializer without neutralization.
- **CS-SC-3** — No credential in `application.yml`, in a properties file, or in version control. Injected as environment variables or resolved from the project's vault, and rotatable without a rebuild.
- **CS-SC-4** — Passwords via Spring Security's `BCryptPasswordEncoder` or Argon2 **(Spring)**; JJWT or the platform library for tokens. No hand-rolled algorithm, no `MessageDigest` used as a password hash, no `Random` where `SecureRandom` is required.
- **CS-SC-5** — OWASP ASVS Level 2 as the reference control set; the project raises it in its config when the threat model warrants.

## DP — Third-party dependencies

- **CS-DP-1** — A new dependency states: the problem it solves, why the platform or an existing dependency does not, its release activity, and its licence. Approved by the architect.
- **CS-DP-2** — One library per concern: `java.time` for time, Jackson for JSON, SLF4J for logging, the platform HTTP client, Testcontainers for integration infrastructure. Joda-Time, Gson, `java.util.Date`, and Apache Commons date handling are not introduced.
- **CS-DP-3** — No release ships with an open high or critical advisory. Renovate keeps versions moving; the scan runs in the pipeline. An exception is time-boxed and owned, never a suppression comment nobody revisits.

## PR — Canonical solutions and prohibitions

- **CS-PR-1** — Register grows per project in `docs/prime-config.md`. Team-wide entries: outbound HTTP goes through a typed client with timeout, retry, and circuit breaker configured — never a bare `RestTemplate`/`WebClient` call at a call site; scheduled work is idempotent and guarded against concurrent instances; partial failure across an aggregate uses an outbox rather than a distributed transaction.
- **CS-PR-2** — Prohibited, each with its reason:
  - **Field injection** (`@Autowired` on a field) — hides dependencies and makes the type untestable without a container. Constructor injection only.
  - **`catch (Exception e)`** outside the boundary advice — catches what it did not anticipate and turns a bug into silence.
  - **Static mutable state** — the invisible coupling `QM-CC-1` names as the worst kind.
  - **Lombok `@Data` on entities** — generates `equals`/`hashCode` over mutable and lazily-loaded fields, producing collection corruption that surfaces far from its cause.
  - **Entity as `@RequestBody`** — makes the persistence model the public contract and opens mass assignment.
  - **Business logic in a database trigger or stored procedure** — invisible to the code, untestable in the suite, unversioned with the change.
- **CS-PR-3** — No pattern is mandated by name. `CS-PR-1` states the problem and the sanctioned solution; the structure follows from it.

---

## Automation map

Slots that a tool checks are not review material — a human re-litigating them is waste (`QM-CN-3`). What follows is a starting toolchain; a project missing an entry is what is worth raising.

| Slots | Tool |
|---|---|
| CS-AR-1, CS-AR-2, CS-AR-3 | ArchUnit test in the build |
| CS-NM-1, CS-NM-2 (partial) | Checkstyle / custom Semgrep rules |
| CS-ER-5, CS-ER-6, CS-PR-2 | Error Prone, SpotBugs, Semgrep |
| CS-DA-1, CS-DA-5 | Semgrep rules; `open-in-view` asserted in a config test |
| CS-SC-2 | Semgrep, SpotBugs (find-sec-bugs), SAST in the pipeline |
| CS-SC-3 | gitleaks in pre-commit and in CI |
| CS-DP-2, CS-DP-3 | Maven Enforcer (banned dependencies), Renovate, dependency scanning |
| CS-TS-4 | Flaky detection in CI; PIT for suite quality |

Semgrep is worth singling out: several slots in this file that read as prose rules ("never call a repository from a controller", "never concatenate into JPQL") are expressible as custom rules, which moves them out of review and into the build.

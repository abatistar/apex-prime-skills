# Prime Config Template

Canonical template owned by prime-core/prime-config. The SKILL.md defines which sections are mandatory, the precedence rules, and the bootstrap procedure — this file is the structure. Replace the example values (shown for a Java/Spring project) with the target project's facts; delete nothing mandatory.

````markdown
# Prime Configuration — [Project Name]

This file is read by every Apex Prime skill (all layers) as their first step, per the
prime-core/prime-config contract. Keep it versioned with the code it describes.
Explicit values here take precedence over anything the skills auto-detect; if this
file diverges from the build files, the skills will flag it.

## Stack
- Language: Java 17
- Framework: Spring Boot 3.2.x
- Build: Maven (`./mvnw`)
- Database: PostgreSQL 15
- Migrations: Flyway, at `src/main/resources/db/migration`, versioned `V<n>__description.sql`
- Messaging: RabbitMQ (spring-amqp)

## Structure
- Domain / business rules: `src/main/java/com/acme/app/domain`
- API layer (controllers, DTOs): `src/main/java/com/acme/app/api`
- Application services: `src/main/java/com/acme/app/service`
- Persistence (repositories, entities): `src/main/java/com/acme/app/persistence`
- Messaging consumers: `src/main/java/com/acme/app/messaging`
- Unit tests: `src/test/java`
- Integration tests: `src/test/java/**/*IT.java` (Testcontainers)

## Conventions and constraints

<!-- This section is the home of everything prime-core/coding-standards and
     prime-core/quality-model declare as a project override point. The four
     subsections below are read by its-generator, its-implementation and
     code-review; keep them even when empty, with an explicit "none declared yet".
     Free-prose project rules that fit no slot go under "Project rules". -->

### Area register
<!-- Per prime-core/coding-standards (Legacy: the area register). Classification is
     DECLARED here, never inferred from directory names or file age. Anything
     unregistered is `current`. Three states only:
       current            — full standard: invariant and conventional slots alike
       legacy-maintained  — invariants apply to what you write; conventional slots
                            defer to the local pattern
       strangler          — as legacy-maintained, plus no new behavior; name the
                            replacement module and the migration ID -->
- `src/main/java/com/acme/app/**` — current
- `src/main/java/com/acme/app/billing` — legacy-maintained (pre-2023 conventions; invariants apply)
- `src/main/java/com/acme/app/legacy` — strangler (replaced by `billing.v2`; MIG-003)

### Slot overrides
<!-- Per prime-core/coding-standards. One line per slot where this project decides
     differently from references/defaults-<stack>.md. Cite the slot ID — the value
     stated here wins over the team default. A slot with neither a default nor an
     override is a REPORTABLE GAP: consuming skills report and offer to fill it,
     never improvise a value. Write "none — team defaults apply" when that is true. -->
- `CS-CT-2` — cursor pagination (`cursor`/`limit`) on `/api/v1/events`; page-based everywhere else
- `CS-SC-5` — OWASP ASVS Level 3 for the payments module (regulatory threat model)
<!-- Or, if nothing is overridden: "none — team defaults apply (defaults-java.md)" -->

### Declared migrations
<!-- Per prime-core/coding-standards (Declared migrations). Four fields or it is not
     a migration, it is erosion with a name: new slot value, owner, scope,
     completion condition. A migration that stops advancing is cancelled explicitly
     and the area returns to legacy-maintained. -->
- **MIG-003** — slot `CS-AR-4`: technical-layer packaging → feature-first packaging.
  Owner: [name]. Scope: `src/main/java/com/acme/app/legacy` → `billing.v2`.
  Complete when: no production traffic reaches `legacy` and the package is deleted.
<!-- Or: "none in flight" -->

### Quality model posture
<!-- Per prime-core/quality-model (Project overrides). This project may RAISE the bar
     — add a project-specific non-negotiable, tighten a calibrated threshold — and may
     record a standing posture toward legacy or debt. It may NOT silently waive a core
     non-negotiable: relaxing one is a deliberate, owned decision (an ADR), never a
     config edit. -->
- Added non-negotiable: every endpoint touching payment data carries an audit log entry
- Standing posture: `billing` is under strangler-fig migration (MIG-003) — match its local
  patterns, do not extend them; new capability is born in `billing.v2`
<!-- Or: "none declared yet" -->

### Project rules
<!-- Rules that constrain every plan and review and do not map onto a slot. -->
- Layer rule: api → service → persistence. Controllers never call repositories directly.
- Business errors via `BusinessException` subclasses; never catch generic `Exception`.
- Every new endpoint requires an integration test.
- DTOs are records; entities are never exposed by the API layer.
- Feature flags via `@ConditionalOnProperty`; new user-facing behavior ships behind a flag.
<!-- If nothing is declared yet, write "none declared yet" — never omit the subsection. -->

## Document repository
- Use cases: `docs/use-cases/UC-NNN-title.md`
- ITS: `docs/its/ITS-<story-id>-title.md`
- ADRs (architecture decision records): `docs/adr/ADR-NNN-title.md`
  <!-- Sequential, never renumbered. Structure and lifecycle defined by prime-core/its-contract (decision boundary section) -->
- Custom use case template: none (use the skill's bundled default)
  <!-- To override: point to e.g. docs/use-cases/TEMPLATE.md and list extra mandatory sections -->
- Extra mandatory use case sections: none
  <!-- Example: "Audit requirements" for projects under compliance -->

## Verification commands
- Full build with tests: `./mvnw clean verify`
- Unit tests only: `./mvnw test`
- Single test class: `./mvnw test -Dtest=ClassName`

## Story identifiers
<!-- Optional section. Default when absent: S-NNN. -->
- Format: `S-NNN` (e.g., S-127), matching the tracker ID

## Pipeline (Azure DevOps)
<!-- Optional section. Omit for projects without a pipeline. -->
- PR validation build: [pipeline name / trigger]
- Required checks before merge: [build, tests, quality gates]
- Deploy flow after merge: [stages]
  <!-- Referenced by prime-dev/pr-preparation and prime-architect/code-review -->
````

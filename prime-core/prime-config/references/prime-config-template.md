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
     prime-core/quality-model declare as a project override point. The five
     subsections below are read by its-generator, its-implementation and
     code-review; keep them even when empty, with an explicit "none declared yet".
     Free-prose project rules that fit no slot go under "Project rules". -->

### Area register
<!-- Per prime-core/coding-standards › Legacy: the area register. Read it before
     filling this in: it defines the three states, the rule that classification is
     declared and never inferred, and what an unregistered area means. One line per
     area, the state named in its own words. -->
- `src/main/java/com/acme/app/**` — current
- `src/main/java/com/acme/app/billing` — legacy-maintained (pre-2023 conventions; invariants apply)
- `src/main/java/com/acme/app/legacy` — strangler (replaced by `billing.v2`; MIG-003)

### Slot overrides
<!-- Per prime-core/coding-standards. One line per slot where this project decides
     differently from references/defaults-<stack>.md. Cite the slot ID — the value
     stated here wins over the team default. A slot with neither a default nor an
     override is handled per that skill's "Unfilled slots" section. Write
     "none — team defaults apply" when that is true. -->
- `CS-CT-2` — cursor pagination (`cursor`/`limit`) on `/api/v1/events`; page-based everywhere else
- `CS-SC-5` — OWASP ASVS Level 3 for the payments module (regulatory threat model)
<!-- Or, if nothing is overridden: "none — team defaults apply (defaults-java.md)" -->

### Declared migrations
<!-- Per prime-core/coding-standards › Declared migrations, which defines the
     mandatory fields, what a missing one makes this entry instead, and what
     happens to a migration that stops advancing. One entry per migration in
     flight, following the shape below. -->
- **MIG-003** — slot `CS-AR-4`: technical-layer packaging → feature-first packaging.
  Owner: [name]. Scope: `src/main/java/com/acme/app/legacy` → `billing.v2`.
  Complete when: no production traffic reaches `legacy` and the package is deleted.
<!-- Or: "none in flight" -->

### Quality model posture
<!-- Per prime-core/quality-model › Project overrides, which states exactly what
     this section may add or tighten, what standing posture it may record, and what
     it may never waive here. Read it before adding a line. -->
- Added non-negotiable: every endpoint touching payment data carries an audit log entry
- Standing posture: `legacy` is under strangler-fig migration (MIG-003) — match its local
  patterns, do not extend them; new capability is born in `billing.v2`
<!-- Or: "none declared yet" -->

### Project rules
<!-- Rules that constrain every plan and review and map onto no slot. If the slot
     catalog already asks the question — layer direction, error representation, what
     obliges a test, the serialization boundary — the answer belongs under Slot
     overrides, or nowhere at all when the stack default already says it. Writing it
     here as well is how the two copies drift apart. -->
- Feature flags via `@ConditionalOnProperty`; new user-facing behavior ships behind a flag.
- `payments` is never changed without the security owner in the review.
- Customer data stays in the `sa-east-1` region; no test fixture carries production records.
- No deploy between the 25th and the 1st — the billing close window.
<!-- If nothing is declared yet, write "none declared yet" — never omit the subsection. -->

## Document repository
- Use cases: `docs/use-cases/UC-NNN-short-title.md`
- ITS: `docs/its/ITS-<story-id>-short-title.md`
- ADRs (architecture decision records): `docs/adr/ADR-NNN-short-title.md`
  <!-- Sequential, never renumbered. Structure, lifecycle, and who drafts are defined by
       prime-core/its-contract (decision boundary) and its templates/adr-template.md -->
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

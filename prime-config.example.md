# Prime Configuration — [Project Name]

This file is read by every Apex Prime skill (all layers) as their first step. Keep it versioned with the code it describes. Explicit values here take precedence over anything the skills auto-detect; if this file diverges from the build files, the skills will flag it.

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
- Layer rule: api → service → persistence. Controllers never call repositories directly.
- Business errors via `BusinessException` subclasses; never catch generic `Exception`.
- Every new endpoint requires an integration test.
- DTOs are records; entities are never exposed by the API layer.
- Never modify files under `src/main/java/com/acme/app/legacy` — scheduled for removal.
- Feature flags via `@ConditionalOnProperty`; new user-facing behavior ships behind a flag.

## Document repository
- Use cases: `docs/use-cases/UC-NNN-title.md`
- ITS: `docs/its/ITS-<story-id>-title.md`
- Custom use case template: none (use the skill's bundled default)
  <!-- To override: point to e.g. docs/use-cases/TEMPLATE.md and list extra mandatory sections -->
- Extra mandatory use case sections: none
  <!-- Example: "Audit requirements" for projects under compliance -->

## Verification commands
- Full build with tests: `./mvnw clean verify`
- Unit tests only: `./mvnw test`
- Single test class: `./mvnw test -Dtest=ClassName`

## Story identifiers
- Format: `S-NNN` (e.g., S-127), matching the tracker ID
  <!-- Adjust to your tracker: JIRA keys like PROJ-1234 also work -->

## Pipeline (Azure DevOps)
- PR validation build: [pipeline name / trigger]
- Required checks before merge: [build, tests, quality gates]
- Deploy flow after merge: [stages]
  <!-- Referenced by prime-dev/pr-preparation and prime-architect/code-review -->

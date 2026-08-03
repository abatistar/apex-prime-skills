---
name: use-case
description: The canonical use case document format owned by prime-core - template, quality rules, revision-history (delta) rules, and uncertainty markers. Consult whenever creating, updating, validating, or consuming a use case document. Writers (prime-docs/use-case-creator, prime-docs/use-case-extractor) write against this format; readers (prime-architect/its-generator, prime-architect/code-review) validate against it. Never duplicate its content elsewhere - reference it.
---

# Use Case Format (prime-core)

This skill owns the use case document format. It has one address and one owner; every other skill references it instead of copying it. A change here updates writing and reading at the same time.

## The canonical template

`references/use-case-template.md` defines: file naming (`docs/use-cases/UC-NNN-title.md`), document structure (metadata, goal, preconditions, main/alternative/exception flows, postconditions, business rules, acceptance criteria, revision history), the quality rules every document must satisfy, and the uncertainty markers (`[INFERRED]`, `[CONFIRM: ...]`) used for reverse-engineered content.

Read the template in full before writing or validating any use case document.

## Non-negotiable rules (summary — the template is authoritative)

- Use cases are the living source of truth for system behavior. Stories are diffs applied to them.
- Every revision carries a story-identified delta in the Revision History (max 5 entries; full history in version control). The delta is the its-generator's primary input.
- Documents with unresolved uncertainty markers stay in Draft status and are not source of truth.
- The project's `docs/prime-config.md` may override the template path or add mandatory sections; project configuration takes precedence.

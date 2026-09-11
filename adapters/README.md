# Adapters

Agent configuration per platform. Each file is the entry prompt one platform loads; the process itself lives in the skills, and an adapter routes to them instead of restating their procedures.

| Platform | Architect | Developer |
|---|---|---|
| Claude Code | `claude-code/jarvis.md` | `claude-code/friday.md` (stub) |
| Copilot | `copilot/jarvis.agent.md` | `copilot/friday.agent.md` (stub) |

## The two Jarvis files are deliberate copies

Neither platform can include a shared file, so the body of the architect prompt exists twice, verbatim. That duplication is accepted, and it is the one place in this repository where "reference, never duplicate" does not apply — there is nothing to reference from.

What follows from that:

- **A change to one is a change to both, in the same commit.** The bodies must stay byte-identical. A fix that lands in only one adapter is a silent fork, and the platform that missed it will route differently from the platform that got it.
- **Only the frontmatter and the invocation line may differ.** Claude Code carries `description` and closes with the `$ARGUMENTS` line; Copilot carries `name` and `description`, opens with an `#` title, and has no arguments line. Everything between is the same text.
- **Verify before committing.** `diff` the bodies past the frontmatter; the only expected differences are the ones listed above.

The Friday stubs carry the same rule once the dev layer is authored.

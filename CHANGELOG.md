# Changelog — Apex Prime

Toda evolução do padrão (especialmente do `prime-core`) é registrada aqui, para que o time saiba quando e por que ele mudou.

## 2026-08-05 — Renomeação dos agents: Dr → Jarvis, Leo → Friday

- Os agents dos papéis passam a se chamar **Jarvis** (Solution Architect) e **Friday** (Developer), em referência às IAs assistentes do MCU — coerente com a natureza dos agents e com a dinâmica sênior/sucessor entre os papéis.
- Arquivos renomeados: `adapters/claude-code/dr.md` → `jarvis.md`, `adapters/claude-code/leo.md` → `friday.md`, `adapters/copilot/dr.agent.md` → `jarvis.agent.md`, `adapters/copilot/leo.agent.md` → `friday.agent.md`.
- O tratamento **"Dr."** dirigido ao usuário permanece — é cultura do time, independente do nome do agent. O que muda é o nome pelo qual o agent responde.
- Nenhuma skill das camadas (`prime-core`, `prime-docs`, `prime-architect`, `prime-dev`) foi alterada: os nomes dos agents vivem apenas nos adapters e no README.

# Changelog — Apex Prime

Toda evolução do padrão (especialmente do `prime-core`) é registrada aqui, para que o time saiba quando e por que ele mudou.

## 2026-08-05 — Postura de copiloto no Jarvis + ADRs no ecossistema

**Adapters (fora da governança do core):**
- Jarvis (`adapters/claude-code/jarvis.md`, `adapters/copilot/jarvis.agent.md`) ganha a seção **"Copilot stance"**: explicitar premissas antes de pedir confirmação de mapeamento ou entregar ITS, nomear alternativas viáveis descartadas, no máximo uma pergunta provocativa por decisão estruturante, e confronto sempre contra critérios versionados (nunca improvisados). Novo gate 6: decisão que sobrevive à story vira ADR referenciado, nunca embutido no ITS.

**prime-core (requer PR revisado pelo dono do quality-model — entregue como draft):**
- `its-contract`: nova seção **"Decision boundary: ITS vs ADR"** — critérios de corte (restringe decisões futuras / afeta mais de um UC ou módulo / rationale precisa ser legível fora do ITS), local e estrutura mínima do ADR (Context, Decision, Consequences, Status), gatilho no its-generator (propõe) com aprovação do arquiteto. Metadata do ITS ganha campo **Referenced ADRs**. Traceability ganha a regra da **alternativa descartada em uma linha** (apenas quando houve mais de um caminho viável). Consumption rules: ADRs Accepted são contexto vinculante para o implementador; conflito ITS×ADR retorna como pergunta.
- `its-contract/templates/its-template.md`: campo Referenced ADRs no Metadata; nota da alternativa descartada no Traceability check.

**prime-architect:**
- `its-generator`: Step 0 e 1 passam a carregar/varrer o repositório de ADRs; Step 3 anota pontos de decisão com mais de um caminho; novo **Step 4.5 — Detect and propose ADRs** (detecta pelo critério do contrato, rascunha como Proposed, arquiteto aprova antes da entrega; rejeitado como story-scoped vira linha de alternativa descartada); Step 6 ganha o boundary check (nenhuma decisão arquitetural embutida no corpo do ITS).

**Configuração:**
- `prime-config.example.md`: entrada `ADRs: docs/adr/ADR-NNN-title.md` no Document repository.

Motivação: incorporar a postura de "copiloto cognitivo" (perguntas que não seriam feitas, premissas explícitas, decisões registradas e evolutivas) mantendo os princípios do repo — reference never duplicate (ADR referenciado, não embutido), decisão registrada com ciclo de vida próprio (Superseded), e gatilho no processo (its-generator propõe) em vez de depender de disciplina individual.

## 2026-08-05 — Renomeação dos agents: Dr → Jarvis, Leo → Friday

- Os agents dos papéis passam a se chamar **Jarvis** (Solution Architect) e **Friday** (Developer), em referência às IAs assistentes do MCU — coerente com a natureza dos agents e com a dinâmica sênior/sucessor entre os papéis.
- Arquivos renomeados: `adapters/claude-code/dr.md` → `jarvis.md`, `adapters/claude-code/leo.md` → `friday.md`, `adapters/copilot/dr.agent.md` → `jarvis.agent.md`, `adapters/copilot/leo.agent.md` → `friday.agent.md`.
- O tratamento **"Dr."** dirigido ao usuário permanece — é cultura do time, independente do nome do agent. O que muda é o nome pelo qual o agent responde.
- Nenhuma skill das camadas (`prime-core`, `prime-docs`, `prime-architect`, `prime-dev`) foi alterada: os nomes dos agents vivem apenas nos adapters e no README.

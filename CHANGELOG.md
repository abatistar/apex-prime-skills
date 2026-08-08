# Changelog — Apex Prime

Toda evolução do padrão (especialmente do `prime-core`) é registrada aqui, para que o time saiba quando e por que ele mudou.

## 2026-08-08 — Contrato prime-config no core + propagação aos consumidores

**prime-core (mudança efetiva — PR revisado pelo dono do quality-model):**
- Nova skill **`prime-core/prime-config`**: contrato canônico do `docs/prime-config.md` — seções obrigatórias e opcionais, regras de precedência (explícito vence detectado; config sobrescreve *defaults* do core apenas nos pontos de override declarados, nunca as *regras*; config não sobrescreve ADR Accepted), tratamento de divergência e lacunas, e o procedimento de bootstrap com disciplina de marcadores `[CONFIRM]`. Define a **Consumption rule**: todo Step 0 referencia o contrato em vez de redescrever o procedimento.
- Template canônico movido para o padrão do core: `prime-core/prime-config/references/prime-config-template.md` (alinha o caminho declarado no SKILL.md e a convenção `references/` do use-case).
- **`prime-config.example.md` da raiz reduzido a um ponteiro** para o contrato e o template canônicos — o conteúdo duplicado violava "reference, never duplicate": qualquer evolução divergiria entre as duas cópias.

**Propagação (consumidores realinhados na mesma entrega — sem deixar duas fontes descrevendo o mesmo procedimento):**
- `prime-docs/use-case-creator`, `prime-docs/use-case-extractor`, `prime-architect/its-generator`: Step 0 reescrito para referenciar **prime-core/prime-config** (fallback, divergência e bootstrap saem do corpo das skills; cada uma mantém apenas *o que* consome da config).
- Adapters do Jarvis (`adapters/claude-code/jarvis.md`, `adapters/copilot/jarvis.agent.md`): seção Knowledge referencia o contrato e o inclui na lista do prime-core.
- `README.md`: árvore atualizada (nova skill com `references/`; example.md anotado como ponteiro), princípio "Single foundation" e nova seção "The project configuration".

**Sem alteração:** `prime-core/use-case`, `prime-core/its-contract` (ambos continuam apenas declarando seus pontos de override, agora com a precedência formalizada no novo contrato) e a camada `prime-dev` (stubs; ao serem autorados, os Step 0 já nascem referenciando o contrato).

Motivação: o procedimento de leitura da config (fallback, divergência, bootstrap) estava repetido em três Step 0 e o exemplo completo vivia duplicado na raiz — exatamente a deriva que o prime-core existe para impedir. Esta entrada dá dono e endereço únicos ao contrato da configuração e realinha todos os consumidores na mesma entrega, para não repetir o descompasso corrigido em 2026-08-07 no formato de caso de uso.

## 2026-08-07 — Consolidação do formato de caso de uso no estilo Cockburn

**prime-core (mudança efetiva — PR revisado pelo dono do quality-model):**
- `use-case/references/use-case-template.md`: estrutura consolidada no vocabulário Cockburn — **Stakeholders and Interests** (opcional: preencher só quando o insumo revelar interesses; nunca inventar), **Conditions** (Preconditions + Minimal/Success Guarantees), **Main Success Scenario**, **Extensions** (fusão de fluxos alternativos e de exceção). Correções mecânicas na tabela de metadados (cabeçalho válido, linha de Status com duas células, pontuação uniforme). **Status "Active" removido** — ciclo de vida passa a ser Draft · Reviewed, com seção explícita: Reviewed é fonte de verdade e insumo válido para o its-generator; promoção de status é sempre ato humano. **Prefixo de regra de negócio fixado como RN-N.** Seção UML com regra de escopo: o diagrama mostra apenas o próprio UC e suas relações diretas («include»/«extend»), nunca um mapa do sistema; atualizações apenas de diagrama **não são itens de delta** na Revision History (o diagrama é derivado dos fluxos — o delta é a mudança de comportamento). Quality rules reescritas: toda extensão com desfecho definido; **Main Success Scenario e toda extensão exigem CA correspondente**; "Minimal Guarantees state what holds even on failure"; consistência do diagrama coberta por regra própria.
- `use-case/SKILL.md`: resumo estrutural realinhado ao novo vocabulário e ao ciclo Draft · Reviewed (o SKILL.md descrevia seções que deixaram de existir — Goal, Postconditions, exception flows).

**prime-docs:**
- `use-case-creator`: checklist de elicitação (Passo 2a) reescrito em termos de extensões e garantias, com item explícito sobre Stakeholders opcional (usar apenas se presente no insumo); Passo 2b atualizado para o vocabulário novo e regra do diagrama fora do delta; **exemplo canônico de delta corrigido de "removed BR-4" para "removed RN-4"** — o prefixo divergente contaminaria a rastreabilidade delta → ITS.
- `use-case-extractor`: Passo 3 retraduzido para o vocabulário do template (guards → preconditions/extensions; efeitos persistidos → Success Guarantees; efeitos que valem mesmo em falha → Minimal Guarantees; tratamento de erro → extensions com desfecho); orientação para Stakeholders em engenharia reversa (raro o código revelar — quando inferido, sempre `[INFERRED]`; caso contrário, omitir a seção).

**Sem alteração:** `prime-core/its-contract` (não referencia a estrutura interna do caso de uso) e `prime-architect/its-generator` (o gate "Draft com `[CONFIRM]` pendente bloqueia o ITS" permanece válido no ciclo de dois status).

Motivação: a atualização anterior do template introduziu a estrutura Cockburn sem propagar o vocabulário aos escritores (creator, extractor) e ao próprio resumo do SKILL.md, criando exatamente a deriva que o prime-core existe para impedir — quem escrevia e quem lia descreviam formatos diferentes. Esta entrada consolida uma direção única, define o ciclo de vida de status sem o estado "Active" (que ninguém no ecossistema sabia promover) e fecha as ambiguidades de delta (prefixo RN, diagrama fora do delta, CA obrigatório por extensão).

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

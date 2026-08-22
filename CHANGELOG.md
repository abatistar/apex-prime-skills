# Changelog — Apex Prime

Toda evolução do padrão (especialmente do `prime-core`) é registrada aqui, para que o time saiba quando e por que ele mudou.

## 2026-08-14 — Registro retroativo do padrão de qualidade + realinhamento dos consumidores da config

**Registro retroativo (dívida de governança paga nesta entrega):**

As duas maiores adições ao `prime-core` entraram no repositório sem entrada no changelog, embora ambas declarem, na própria seção *Versioning*, que sua evolução é registrada aqui. O registro é feito agora, nomeado como retroativo em vez de datado para trás:

- **`prime-core/quality-model`** (catálogo `references/quality-criteria.md` **v1.0**): definição de qualidade como uma propriedade única vista por oito lentes; três tiers (`[NON-NEGOTIABLE]`, `[CALIBRATED]`, `[AUTOMATE]`) que descrevem a *natureza* do critério, não uma consequência automática; a regra de calibração (excesso é tão nocivo quanto deficiência; a barra é proporcional ao tempo de vida e à importância do código); e a disciplina de exceção *silencioso versus deliberado* — o pecado é a partida invisível, não a dívida. IDs `QM-XX-N` estáveis, nunca renumerados. A skill declara explicitamente que **não é gate**: aprovação e rejeição pertencem a `code-review`.
- **`prime-core/coding-standards`** (catálogo `references/convention-slots.md` **v1.0** + `references/defaults-java.md`): o *slot* como pergunta e o default como resposta; as duas classes de aplicação (**INVARIANT** vale para toda linha escrita ou alterada; **CONVENTIONAL** cede ao padrão local em área registrada), que resolvem a tensão entre `QM-CN-2` e a disciplina de piso; o **area register** declarado (`current` / `legacy-maintained` / `strangler`); migrações declaradas com quatro campos obrigatórios; e *unfilled slot* como lacuna reportável, nunca escolha livre. IDs `CS-XX-N` estáveis.
- **`prime-architect/code-review`** e `checklists/review-checklist.md`: o ponto de enforcement que as duas skills do core deixam deliberadamente em aberto — severidades, veredito único, e a regra de exceção (a partida deliberada e nomeada não bloqueia; a silenciosa bloqueia).

**prime-core (mudança efetiva — PR revisado pelo dono do quality-model):**

- **`prime-config`, seção Conventions and constraints reestruturada**: passa a declarar as quatro subseções que `coding-standards` e `quality-model` já assumiam existir — **Area register**, **Slot overrides**, **Declared migrations**, **Quality model posture** — mais **Project rules** para o que não mapeia em slot. O template canônico ganha as quatro com formato, comentários de uso e exemplos. Antes desta entrega, um projeto bootstrapado nascia sem a estrutura que `code-review` (Step 0) e `its-generator` liam: a lacuna aparecia só no primeiro PR revisado.
- **`prime-config`, nova seção "Override points (the closed list)"**: tabela única com ponto de override, contrato dono e endereço no arquivo. Três skills faziam afirmações sobre o mesmo arquivo e só uma é dona do contrato — exatamente a deriva corrigida em 2026-08-08. Regra de manutenção: um contrato do core que declara um novo ponto de override acrescenta a linha aqui no mesmo PR.
- **`prime-config`, precedência reescrita em quatro regras**: explícito vence detectado; config vence **apenas nos pontos declarados**; config **nunca** sobrescreve regra do core — pode **elevar** a barra, e relaxar um `[NON-NEGOTIABLE]` é ADR, nunca edição de config; config não sobrescreve ADR Accepted.
- **`prime-config`, divergência e gaps**: novo caso explícito para *slot sem valor* — lacuna reportável per `coding-standards`, nunca improvisada.
- **`prime-config`, bootstrap de 5 para 7 passos**: novo **Passo 2 — Walk the slot catalog** (percorrer `convention-slots.md` contra o defaults da stack; override quando o projeto diverge, `[CONFIRM]` quando ninguém decidiu) e novo **Passo 3 — Classify the areas** (o area register é elicitado, nunca inferido de nome de diretório ou idade de arquivo). O mecanismo de *unfilled slot* existia no papel sem nenhum momento do processo que o exercitasse.
- Regra transversal registrada: subseção vazia é escrita com "none declared yet" explícito, nunca omitida — silêncio e ausência são fatos diferentes e só um deles é decisão.

**Propagação (consumidores realinhados na mesma entrega):**

- **Adapters do Jarvis** (`adapters/claude-code/jarvis.md`, `adapters/copilot/jarvis.agent.md`): **gate 5** passa a citar ITS + `quality-model` **+ `coding-standards`**, com a exigência de que todo achado cite ID (`QM-XX-N` / `CS-XX-N` / seção do ITS / `UC-NNN/CA-N`) — o gate governava uma skill que já julgava contra os dois contratos. A seção *Knowledge* explicita o que a config fornece (area register, slot overrides) e a *Copilot stance* passa a nomear a lacuna de slot como caso de "critério que ainda não existe".
- **`README.md`**: tabela de *Agent assembly* corrigida — o Jarvis carrega `prime-core` + `prime-architect` + **`prime-docs`**, como os dois adapters sempre disseram; a árvore ganha os `references/` de `quality-model` e `coding-standards` (que hoje carregam o conteúdo real) e marca `prime-dev` como stub; nova tabela de *Authoring status*; nova seção "The standard: two contracts, one enforcement point".

**Sem alteração:** `prime-core/use-case`, `prime-core/its-contract`, `prime-docs/*` e `prime-architect/*` — seus Step 0 já referenciam o contrato da config e continuam válidos sem edição. A camada `prime-dev` segue em stub.

Motivação: fechar a lacuna entre um `prime-core` que já descrevia um padrão completo e uma configuração de projeto que não tinha onde guardar as respostas desse padrão. O `coding-standards` exigia um area register e overrides de slot que o template não previa; o `quality-model` afirmava poder elevar a barra em um arquivo cuja regra de precedência não conhecia esse ponto. Enquanto isso, a governança do próprio changelog estava sendo violada pelas duas maiores adições ao core. Esta entrada paga a dívida de registro e dá endereço único a cada ponto de override, para que a próxima skill do core não precise negociar com o contrato da config por conta própria.

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

## 2026-08-21 — Referência resolvida em conteúdo + voz de autor no ITS

**prime-core (mudança efetiva — PR revisado pelo dono do quality-model):**

- **`its-contract`, nova regra em Writing rules — "References resolve in content, not only in address"**: toda referência citada dentro de uma instrução passa a carregar a exigência na própria linha, com o identificador como procedência. A regra anterior ("referências sempre resolvíveis em lugar") garantia ausência de deixis — resolvia o *endereço*, nunca o *conteúdo*. Um implementador que conhece o código pesa o custo de abrir outro documento contra o ganho esperado e pula; com identificador nu, ele pula corretamente. A paráfrase é de exigência em uma linha (a obrigação da regra, o desfecho verificável do critério, a restrição operacional do ADR), nunca o conteúdo da fonte. Quando a exigência não cabe em uma linha sem arrastar o rationale, a referência está no lugar errado — ou a decisão é story-scoped, ou o documento de origem é o que precisa de conserto. A regra vale em todo campo de unidade do plano e nas fronteiras de fora de escopo; não se estende a Metadados nem ao glossário, que têm limites próprios.
- **Correção de dono.** A entrega anterior levou a prática da exigência em linha para o `its-template.md` (preâmbulo do plano, campos *O que fazer*, *Testes* e *Fora de escopo*) sem que o `SKILL.md` declarasse a regra. A norma passou a viver como exemplo dentro de comentário do template — não citável por `code-review`, não versionada como critério, e a cópia governando o dono. Esta entrada devolve a regra ao `SKILL.md`; o template não precisa de mudança, porque já a pratica.
- **`its-contract`, nova regra em Writing rules — "Author's voice"**: lista fechada de marcas proibidas (narração do processo de produção, auto-referência ao documento, hedge dentro de instrução, seção preenchida por cerimônia, endereçamento a quem encomendou o plano). Não é estilo a imitar: é resíduo de processo a remover. A regra declara explicitamente que explicar *por que* um caminho foi escolhido é instrução e permanece, e que ela não instrui a ocultar como o documento foi redigido.
- **`its-contract`, glossário**: a glosa de ADR passa a incluir uma paráfrase de uma linha da **Decisão**, além de título e status — a mesma licença que `RN-N` e `CA-N` já tinham. O limite fica onde o dono único importa: Contexto, Consequências e alternativas consideradas continuam fora. Antes desta entrega, `ADR-NNN` era o único identificador do documento cujo conteúdo o contrato proibia tanto no corpo quanto no glossário, o que tornava o teste do leitor frio estruturalmente insatisfazível para ele.
- **`its-contract`, Pre-delivery test de três para quatro perguntas**: novo *Author test* — alguma frase descreve como o documento foi produzido em vez do que deve ser feito; alguma instrução hesita sobre decisão já fechada.
- **`its-contract/templates/its-template.md`**: linha de ADR no glossário ganha a glosa da decisão. Nenhuma outra edição — o restante da prática já entrou na entrega anterior.

**Propagação (consumidores realinhados na mesma entrega):**

- **`prime-architect/its-generator`**: Step 4.5 passa a exigir que a restrição imposta pelo ADR seja enunciada em cada unidade do plano que ela governa, não apenas o ID no metadata; Step 5 nomeia as duas regras onde um ITS entregue mais falha com seu leitor.

**Sem alteração:** `prime-architect/code-review` (nenhum passo lê o texto alterado; achados continuam citando ID), `prime-core/use-case`, `prime-core/quality-model`, `prime-core/coding-standards`, `prime-core/prime-config`, `prime-docs/*`. A camada `prime-dev` segue em stub e nasce já sob as regras novas.

Motivação: um ITS entregue foi lido, compreendido e teve suas referências ignoradas por um desenvolvedor que já conhecia o código — a implementação saiu correta por conhecimento prévio dele, não por adesão ao plano. O documento não foi aproveitado, e o modo de falha que isso esconde é o da story seguinte: quando a intuição divergir do plano, a divergência não aparece na implementação, aparece no code review. A entrega anterior corrigiu o eixo do documento; esta corrige o custo de cada referência dentro dele, e devolve ao contrato uma regra que havia se instalado apenas no template.
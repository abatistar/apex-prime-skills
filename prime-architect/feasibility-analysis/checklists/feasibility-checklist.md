# Análise de viabilidade — passada operacional

Passada operacional de propriedade do `prime-architect/feasibility-analysis`. O SKILL.md define a baseline, as lentes, as severidades, o veredito e as fronteiras — este arquivo é a sequência e a forma do relatório.

## 0. Entradas carregadas

- [ ] `docs/prime-config.md` lido conforme as regras de consumo do `prime-core/prime-config`, com o que o Passo 0 do SKILL.md usa dele.
- [ ] Regras de consumo do `prime-core/quality-model` + `references/quality-triggers.md`.
- [ ] Regras de consumo do `prime-core/coding-standards`.
- [ ] Catálogos não carregados inteiros: cada ID aplicado é lido no arquivo da sua lente ou família, com o índice do catálogo (SKILL, Passo 0).
- [ ] ADRs `Accepted` e `Proposed` examinados.

## 1. A demanda, reformulada

- [ ] Reformulação do `impact-mapping` executada (`../impact-mapping/references/reformulation.md`): o **resultado observável** afirmado, em uma ou duas frases, e o que a demanda explicitamente **não** afirma.
- [ ] Confirmada com o arquiteto, inclusive a escolha entre leituras concorrentes da entrada.
- [ ] Nenhum resultado observável declarável → **Insufficient input**: perguntas devolvidas, nenhum veredito, nada mais julgado.
- [ ] Resultado que exige mudança em outro projeto → só a parte deste projeto é julgada; a outra entra como superfície de contrato e, quando o resultado daqui depende dela, como `Condition:` roteada à demanda daquele projeto. Resultado quase todo fora deste projeto → devolvida para ser quebrada, sem veredito.

## 2. O mapa

- [ ] `impact-mapping` executado sobre a demanda reformulada.
- [ ] Mapa avulso trazido já parado em **Insufficient input** → esta execução para como no §1.
- [ ] Mapa citado por **ID e revisão**. Mapa trazido pronto cujos arquivos mudaram desde a revisão registrada → refeito, ao menos nas linhas desses arquivos, antes de julgar.
- [ ] Três graus e dados existentes lidos.
- [ ] Estados de área lidos da sobreposição do registro do mapa, com o substituto das áreas `strangler` e as regras do projeto que alcançam as áreas.
- [ ] Camada documentada lida: cobertura com o status de cada caso de uso, divergências, ADRs `Accepted` e `Proposed`.
- [ ] Perfil de evidência e "como o alcance foi buscado" lidos.
- [ ] **Borda declarada** lida — onde o mapa parou, e se o veredito depende de algo além dela.
- [ ] Baseline de cada área tocada classificada: documentada (`Reviewed`, sem divergência) · parcial (sem caso de uso, só `Draft`, `Retired` ainda executado, divergência) · green-field.
- [ ] Delta pendente registrado pelo mapa → baseline documentada, julgada sobre o estado-alvo da story em curso; dependência da ordem de implementação → `Condition:` (responsável o arquiteto responsável); só convivência → `FYI:`.
- [ ] Baseline parcial em outro ponto → `Condition:` com responsável e rota (`use-case-extractor`; `use-case-creator` em validação, conformidade ou reconciliação; o arquiteto para o `Retired`). Baseline parcial onde o veredito se apoia → Undecidable, declarado e justificado.

## 3. Lentes, em ordem

- [ ] **Restrição** — teto de stack/versão, plataforma, dados ausentes, dependência externa, licença, regulação, **regras do projeto** (área proibida, compliance, residência de dados, janela de deploy), exclusão gerada de contrato de terceiro. A única fonte de impossibilidade verdadeira.
- [ ] **Encaixe estrutural** — `QM-CC-1..7`, `CS-AR-1..5`, incidência de ADR do mapa. Regra replicada (`QM-CC-6`) → `Cost driver:`. Área `strangler` → caminho julgado no substituto; substituto que não comporta → `Condition:` do dono da migração. Contradizer um ADR Accepted, ou depender de um `Proposed`, é uma **questão de ADR**, não um blocker: `Condition:` nomeando o ADR, responsável o arquiteto, rota para o ciclo de vida do ADR. Nenhum ADR redigido aqui.
- [ ] **Superfície de contrato** — todo consumidor conhecido pode ser migrado sem quebra silenciosa (`QM-CC-7`, `CS-CT-1`, G2)? O conjunto de consumidores é enumerável? Consumidor noutro projeto → `Condition:` roteada à demanda daquele projeto.
- [ ] **Entrega e reversibilidade** — expansão, migração e contração para contrato e esquema (`QM-CC-7`, `CS-CT-1`, `CS-DA-4`); caminho para os dados existentes; flag com condição de remoção quando pedida (`CS-EV-1`); janelas e restrições de deploy. Sem convivência com a versão em produção → `Condition:`; `Blocker:` só se uma regra ancorada proíbe o único caminho.
- [ ] **Gatilhos de especificação** — a demanda passada pelo G1–G15. Slot sem valor → `Condition:` de lacuna de slot. Decisão que vale além da story → `Condition:` de ADR. G13 → `Condition:` de admissão (`CS-DP-1`, `CS-DP-2`). G14, G1 com regra de acesso ou área `crítica` → `Condition:` do responsável de segurança (`QM-SR-*`, `CS-SC-*`; `QM-SR-8`, `QM-SR-10`, `CS-SC-6`). G11, G12 → `Cost driver:`. G3–G6, G8 → `Cost driver:` quando o mecanismo e o valor existem. Nenhum gatilho fabricado.
- [ ] **Verificação** — comandos de verificação, observabilidade presente (`QM-EO-7`), obrigação de teste (`CS-TS-1`), meta não funcional mensurável (G10, `QM-EF-2`).
- [ ] **Risco de erosão** — o caminho mais barato cria uma segunda forma de fazer algo (`QM-CN-1`) ou aumenta a contagem de uma migração em curso?
- [ ] Nenhum reandar de código que o mapa já andou.
- [ ] **Cobertura das lentes** registrada: cada lente com seus achados, *examinada, nada encontrado* (com o que foi examinado) ou *não se aplica* (com a razão).

## 4. Evidência

- [ ] Todo achado carrega sua âncora do mapa: **ancorada**, `[INFERRED]` ou `[UNVERIFIED]`.
- [ ] Vocabulário reutilizado do `impact-mapping`, não redefinido aqui.
- [ ] Nenhum `Blocker:` apoiado em evidência `[INFERRED]` ou `[UNVERIFIED]`.
- [ ] Todo `Blocker:` passou pela refutação: caminho alternativo para o mesmo resultado, teto que é na verdade configuração, regra que não alcança a área, âncora que não diz o que o achado afirma. O que não sobreviveu caiu; o que não foi confirmado nem derrubado vai para a regra 2.

## 5. Classificação

As severidades e o que cabe em cada uma são os do Passo 5 do SKILL.md; a tabela é só a consulta rápida do efeito. Ela não decide o veredito: a base de evidência pode sobrepor as regras 3 e 4 (§6).

| Severidade | Exige | Contribui para |
|---|---|---|
| `Blocker:` | evidência ancorada que sobreviveu à refutação | Not viable as specified |
| `Condition:` | responsável + rota | Viable with conditions |
| `Cost driver:` | — | nenhum |
| `FYI:` | — | nenhum |

- [ ] Todo achado cita um ID ou uma âncora de evidência.
- [ ] Toda `Condition:` tem responsável e rota (uma condição sem rota é um blocker disfarçado). Responsável tirado dos Responsáveis da configuração — arquiteto responsável, responsável de segurança, responsável da migração, arquiteto responsável do outro projeto; papel sem nome escrito "não declarado ainda" e reportado.
- [ ] Achados causados por um único fato estrutural agregados nesse fato.
- [ ] Nenhuma estimativa de esforço em horas, pontos ou sprints em qualquer parte do relatório.

## 6. Veredito — exatamente um, conforme o Passo 6

- [ ] Resolvido pelas quatro regras do Passo 6, em ordem, valendo a primeira que casar — um só: **Viable** · **Viable with conditions** · **Not viable as specified** · **Undecidable with current evidence**, com a razão em uma linha.
- [ ] Undecidable → apoiado num dos casos da lista fechada do Passo 6, nomeado no relatório.
- [ ] Not viable → blockers listados separadamente e o que teria de mudar na demanda; lacunas em outros pontos registradas como follow-ups, nunca usadas para suavizar o julgamento.
- [ ] Undecidable → a única execução que decidiria, a pergunta que ela responde, quem a executa e o veredito a que cada resultado leva.
- [ ] Viable with conditions → cada condição com responsável e rota.
- [ ] `Cost driver:` e `FYI:` não moveram o veredito.
- [ ] Premissas do veredito listadas — as linhas não ancoradas de que ele depende, cada uma com o que mudaria se fosse falsa — ou "nenhuma".

*Nunca entregue um veredito sobre uma demanda que você não entendeu.*
*Viable autoriza o refinamento, nunca pular o pipeline de especificação.*

## 7. Follow-ups, por destino

- [ ] **Skills de caso de uso** — execução do extractor para um baseline; validação de `Draft` e divergência (`QM-DO-1`) ao use-case-creator. Nunca remendadas aqui.
- [ ] **Arquiteto** — decisão de ADR a levantar (`Accepted` desafiado ou `Proposed` de que a demanda depende), como `Condition:`. O ADR é redigido pelo fluxo do its-contract, pelo arquiteto nesta etapa ou pelo its-generator quando um plano se comprometer com ele, nunca neste relatório. Caso de uso `Retired` que o código ainda executa.
- [ ] **Configuração** — slot não preenchido (`coding-standards`), papel de Responsáveis sem nome, fato do projeto de que a análise precisou e que a configuração não carrega. Nunca improvisados.
- [ ] **Outro projeto** — a demanda correspondente, quando o resultado daqui depende dela.
- [ ] **Backlog** — dívida que o caminho viável criaria, com responsável prospectivo (`QM-MT-1`), no formato do Tracker.
- [ ] **Dono do modelo de qualidade** — critério de que a confrontação precisou e que o catálogo não tem.

## 8. Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito ou proposto.
- [ ] Nenhuma solução projetada: um caminho viável pode ser nomeado dentro do raciocínio do veredito, nunca especificado.
- [ ] Nenhum julgamento sobre se a demanda vale a pena — valor é decisão de quem demanda.
- [ ] Nenhum esforço em lugar algum: nem em horas, pontos ou sprints, nem como uma faixa disfarçada de direcionador de custo.
- [ ] Nenhum caso de uso, ITS, ADR ou arquivo de configuração modificado; nenhum item registrado no tracker.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o arquiteto arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — `FA-<demand-id>-N`, `IM-<demand-id>-N`, os quatro vereditos, as quatro severidades, os marcadores de proveniência (`[INFERRED]`, `[UNVERIFIED]`), os status de caso de uso (`Draft`, `Reviewed`, `Retired`) e de ADR (`Proposed`, `Accepted`), `UC-NNN`, `ADR-NNN`, `QM-XX-N`, `CS-XX-N`, os gatilhos (`G1`…`G15`), caminhos de arquivo e identificadores — nunca são traduzidos.

````markdown
# Viabilidade — FA-<demand-id>-N
**Data:** [data] · **Demanda:** [nos termos de quem pediu]
**Mapa:** IM-<demand-id>-N, revisão [commit] — [referência; não reproduzir aqui]
**Veredito:** Viable | Viable with conditions | Not viable as specified | Undecidable with current evidence
**Razão:** [uma linha]

## A demanda, como julgada
- Resultado observável: [uma ou duas frases]
- Explicitamente fora do escopo: [fronteira]
- Outros projetos: [nenhum | a parte que cabe a [projeto], tratada como superfície de contrato e condição]

## Base de evidência
| Área | Baseline | Consequência |
|---|---|---|
| [área] | documentada · parcial ([sem caso de uso / Draft / Retired executado / divergência em UC-NNN]) · green-field | [nenhuma · Condition n.º · Undecidable — onde o veredito se apoia] |

- Borda do mapa: [o veredito depende de algo além dela? sim/não — se sim, o veredito é Undecidable (§6, regra 2)]

## Achados
| # | Severidade | Onde | Critério / evidência | Achado e implicação |
|---|---|---|---|---|
| 1 | Blocker | `pom.xml` (ancorado) | teto de stack — config | [o que é impossível e por quê; a refutação tentada e por que não o derrubou] |
| 2 | Condition | UC-042 ausente (ancorado) | baseline | [o que precisa ser verdade antes] · responsável: [nome, dos Responsáveis] · rota: use-case-extractor |
| 3 | Condition | `POST /payments` (ancorado) | G1, `QM-SR-8` | [fronteira de acesso nova] · responsável: [responsável de segurança] · rota: avaliação antes da especificação |
| 4 | Cost driver | `billing/legacy` (ancorado) | registro de áreas | [o que aumenta o tamanho] |
| 5 | FYI | `[INFERRED]` [o que foi deduzido] | [o raciocínio, na própria linha] | [contexto; evidência assim nunca sustenta um Blocker — §6, regra 2] |

## Cobertura das lentes
| Lente | Resultado |
|---|---|
| Restrição | [achados n.º · examinada, nada encontrado: o que foi examinado · não se aplica: razão] |
| Encaixe estrutural | [...] |
| Superfície de contrato | [...] |
| Entrega e reversibilidade | [...] |
| Gatilhos de especificação | [gatilhos disparados e o resultado de cada um] |
| Verificação | [...] |
| Risco de erosão | [...] |

## Premissas do veredito
- [linha `[INFERRED]` ou `[UNVERIFIED]` de que o veredito depende] — [o que mudaria se fosse falsa]
- [ou: nenhuma]

## Se Not viable — o que teria de mudar na demanda
- [a porta de saída]

## Se Undecidable — a execução que decidiria
- **Execução:** [extractor na área X | spike com tempo limitado em Y | medição de Z] · **quem executa:** [responsável]
- **Pergunta:** [o que ela responde]
- **Resultado → veredito:** [resultado A → veredito] · [resultado B → veredito]

## Follow-ups
- **Skills de caso de uso:** [extractor na área X / validação do UC-NNN / divergência no UC-NNN]
- **Arquiteto:** [decisão de ADR a levantar / caso de uso Retired ainda executado]
- **Configuração:** [slot não preenchido / papel sem nome / fato ausente]
- **Outro projeto:** [demanda correspondente]
- **Backlog:** [dívida, no formato do Tracker, com responsável prospectivo]
- **Dono do modelo de qualidade:** [critério ausente]
````

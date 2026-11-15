# Análise de viabilidade — conferência antes de entregar

A conferência final da `feasibility-analysis`, feita sobre o relatório pronto, depois do veredito, e o template do relatório. O SKILL.md define a baseline, as lentes, as severidades e o veredito. Esta lista não os repete: confere se o relatório os cumpre. Quando um item falha, volte ao passo que o produz.

## 1. O relatório

- [ ] Cabeçalho com `FA-<demand-id>-N`, a data, a demanda e o mapa citado por **ID e revisão**. O relatório cita o mapa; não o reproduz.
- [ ] A demanda como julgada: o resultado observável e a fronteira, como o arquiteto os confirmou.
- [ ] Base de evidência: a baseline de cada área tocada (documentada · parcial · green-field) com a consequência, e a borda do mapa confrontada com o veredito.
- [ ] Restrições declaradas pelo arquiteto: a resposta registrada, inclusive "nenhuma", ou a razão de a pergunta não ter sido feita.
- [ ] Cobertura das lentes: as sete, cada uma com os achados, *examinada, nada encontrado* (com o que foi examinado) ou *não se aplica* (com a razão).
- [ ] Premissas do veredito: as linhas não ancoradas de que ele depende, cada uma com o que mudaria se fosse falsa, ou "nenhuma".

## 2. Cada achado

- [ ] Cita um ID ou uma âncora e carrega a sua evidência: ancorada, `[INFERRED]`, `[UNVERIFIED]` ou declarada pelo arquiteto. O que a story, o PRD ou outra pessoa afirmam é `[UNVERIFIED]`.
- [ ] Nenhum `Blocker:` apoiado em evidência `[INFERRED]` ou `[UNVERIFIED]`. Todo `Blocker:` sobreviveu à refutação do Passo 4.
- [ ] Toda `Condition:` tem responsável, escrito pelo papel, e rota. Nome só quando o arquiteto o informou ou um ADR o registra.
- [ ] Contradizer um ADR `Accepted`, ou depender de um `Proposed`, é `Condition:`, não `Blocker:`. Nenhum ADR redigido aqui.
- [ ] Achados causados por um único fato estrutural foram agregados nesse fato.

## 3. O veredito

- [ ] Um só — **Viable** · **Viable with conditions** · **Not viable as specified** · **Undecidable with current evidence** —, resolvido pelas quatro regras do Passo 6, na ordem, com a razão em uma linha. `Cost driver:` e `FYI:` não o moveram.
- [ ] Not viable → os blockers listados separadamente e o que teria de mudar na demanda. Lacunas em outros pontos são follow-ups; não suavizam o julgamento.
- [ ] Undecidable → o caso da lista fechada do Passo 6 que o sustenta, a única execução que decidiria, a pergunta que ela responde, quem a executa e o veredito a que cada resultado leva.
- [ ] Viable with conditions → cada condição com responsável e rota.

## 4. Follow-ups e fronteira

- [ ] Cada follow-up está no destino que o resolve (Passo 7).
- [ ] Nenhuma estimativa de esforço em parte alguma: nem horas, pontos ou sprints, nem uma faixa disfarçada de direcionador de custo.
- [ ] Nenhuma solução projetada: um caminho viável pode ser nomeado no raciocínio do veredito, nunca especificado. Nenhum julgamento sobre se a demanda vale a pena.
- [ ] Nenhum código escrito. Nenhum caso de uso, ITS, ADR ou configuração modificado. Nenhum item registrado no tracker.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o arquiteto arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — `FA-<demand-id>-N`, `IM-<demand-id>-N`, os quatro vereditos, as quatro severidades, os marcadores de proveniência (`[INFERRED]`, `[UNVERIFIED]`), os status de caso de uso (`Draft`, `Reviewed`, `Retired`) e de ADR (`Proposed`, `Accepted`), `UC-NNN`, `ADR-NNN`, `QM-XX-N`, `CS-XX-N`, os gatilhos (`G1`…`G16`), caminhos de arquivo e identificadores — nunca são traduzidos.

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

- Borda do mapa: [o veredito depende de algo além dela? sim/não — se sim, o veredito é Undecidable (Passo 6, regra 2)]

## Restrições declaradas pelo arquiteto
- [a restrição, nas palavras dele, e o que ela proíbe]
- [ou: perguntado, nenhuma declarada · ou: não perguntado — a razão]

## Achados
| # | Severidade | Onde | Critério / evidência | Achado e implicação |
|---|---|---|---|---|
| 1 | Blocker | `pom.xml` (ancorado) | teto de stack — config | [o que é impossível e por quê; a refutação tentada e por que não o derrubou] |
| 2 | Condition | `caminho/Arquivo.ext:42` — comportamento sem caso de uso (ancorado) | baseline | [o que precisa ser verdade antes] · responsável: [papel, e o nome quando informado] · rota: use-case-extractor |
| 3 | Condition | `POST /payments` (ancorado) | G1, `QM-SR-8` | [fronteira de acesso nova] · responsável: [responsável de segurança] · rota: avaliação antes da especificação |
| 4 | Cost driver | `billing/legacy` (ancorado) | contexto do projeto, do mapa | [o que aumenta o tamanho] |
| 5 | FYI | `[INFERRED]` [o que foi deduzido] | [o raciocínio, na própria linha] | [contexto; evidência assim nunca sustenta um Blocker — Passo 6, regra 2] |

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
- [linha `[INFERRED]` ou `[UNVERIFIED]`, ou restrição declarada pelo arquiteto, de que o veredito depende] — [o que mudaria se fosse falsa]
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
- **Backlog:** [dívida, com responsável prospectivo]
- **Dono do modelo de qualidade:** [critério ausente]
````

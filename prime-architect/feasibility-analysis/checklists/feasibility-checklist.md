# Análise de viabilidade — passada operacional

## 0. Entradas carregadas

- [ ] `docs/prime-config.md` lido conforme o `prime-core/prime-config`: stack e versões, mapa de estrutura, **registro de áreas**, overrides de slots, localizações de documentos, comandos de verificação.
- [ ] `prime-core/quality-model` + `references/quality-criteria.md`.
- [ ] `prime-core/coding-standards` + `references/convention-slots.md` e os padrões da stack.
- [ ] ADRs Accepted examinados.

## 1. A demanda, reformulada

- [ ] Uma ou duas frases nomeando o **resultado observável** afirmado.
- [ ] Confirmada com o arquiteto.
- [ ] O que a demanda explicitamente **não** afirma está escrito.
- [ ] Se nenhum resultado observável pôde ser declarado → devolvida neste passo, nada mais julgado.

## 2. O mapa

- [ ] `impact-mapping` executado sobre a demanda reformulada.
- [ ] Mapa trazido já parado em **Insufficient input** → esta execução para e devolve suas perguntas. Nenhum veredito é emitido — *Undecidable* é um julgamento, e nada foi julgado. No caminho em que esta skill comissiona o mapa, essa parada acontece no §1, antes de o mapa ser executado.
- [ ] Mapa citado por **ID e data**. Um mapa sem data não é uma referência citável.
- [ ] Três graus lidos: direto, acoplado, superfície de contrato.
- [ ] Estados de área lidos da sobreposição do registro do mapa.
- [ ] Camada documentada lida: cobertura, divergências, incidência de ADR.
- [ ] **Borda declarada** lida — onde o mapa parou, e se o veredito depende de algo além dela.
- [ ] Área afetada não documentada → `Condition:` com responsável e rota para o `use-case-extractor`. Exceção: a área não documentada é onde um `Blocker:` se apoiaria → Undecidable, exceção declarada e justificada. Green-field sem tocar nada existente → anotado, sem baseline exigido.
- [ ] Divergência código × caso de uso → registrada; nenhum dos lados é um baseline seguro. Pode levar a execução a *Undecidable*.

## 3. Lentes, em ordem

- [ ] **Restrição** — teto de stack/versão, plataforma, dados ausentes, dependência externa, licença, regulação. A única fonte de impossibilidade verdadeira.
- [ ] **Encaixe estrutural** — `CS-AR-1..5`, `QM-CC-1..5`, incidência de ADR do mapa. Contradizer um ADR é uma **questão de ADR**, não um blocker: `Condition:` nomeando o ADR, responsável o arquiteto, rota para o ciclo de vida do ADR. Nenhum ADR redigido aqui.
- [ ] **Superfície de contrato** — todo consumidor conhecido pode ser migrado? O conjunto de consumidores é enumerável?
- [ ] **Verificação** — comandos de verificação, observabilidade presente, obrigação de teste (`CS-TS-1`).
- [ ] **Risco de erosão** — o caminho mais barato cria uma segunda forma de fazer algo (`QM-CN-1`)?
- [ ] **Concorrência e escala** — apenas se o resultado as implica (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`).
- [ ] **Superfície de segurança** — toda nova fronteira (`QM-SR-*`, `CS-SC-*`).
- [ ] Nenhum reandar de código que o mapa já andou.

## 4. Evidência

- [ ] Todo achado carrega sua âncora do mapa: **ancorada**, `[INFERRED]` ou `[UNVERIFIED]`.
- [ ] Vocabulário reutilizado do `impact-mapping`, não redefinido aqui.
- [ ] Nenhum `Blocker:` apoiado em evidência `[INFERRED]` ou `[UNVERIFIED]`.

## 5. Classificação

| Severidade | Usar para | Contribui para |
|---|---|---|
| `Blocker:` | restrição rígida; invariante contradito sem caminho para contornar. Exige evidência ancorada | Not viable as specified |
| `Condition:` | viável uma vez que algo seja verdade antes. **Responsável + rota obrigatórios** | Viable with conditions |
| `Cost driver:` | muda o tamanho, não a resposta: estado da área, amplitude do conjunto acoplado, superfícies de contrato cruzadas, observabilidade ausente, dívida criada | nenhum |
| `FYI:` | contexto para quem demanda | nenhum |

*Esta tabela classifica achados; não decide o veredito. A resolução do veredito é o §6 —
a base de evidência pode sobrepor as regras 3 e 4, independentemente do que foi classificado aqui.*

- [ ] Todo achado cita um ID ou uma âncora de evidência.
- [ ] Toda `Condition:` tem responsável e rota (uma condição sem rota é um blocker disfarçado).
- [ ] Achados causados por um único fato estrutural agregados nesse fato.
- [ ] Nenhuma estimativa de esforço em horas, pontos ou sprints em qualquer parte do relatório.

## 6. Veredito — exatamente um

Resolva em ordem, vale a primeira que casar:

- [ ] **1. `Blocker:` ancorado presente** → *Not viable as specified*. Blockers listados separadamente
      **e** o que teria de mudar na demanda. Lacunas de evidência em outros pontos registradas como
      follow-ups, nunca usadas para suavizar o julgamento.
- [ ] **2. Nenhum blocker ancorado + base de evidência insuficiente** → *Undecidable with current evidence*.
      Insuficiente significa exatamente uma entre: borda aquém do que o veredito exige · divergência aberta,
      sem baseline seguro · área não documentada carregando a restrição mais dura da demanda · dependência
      não testada em que o resultado se apoia. Nomeia a única execução que decidiria. Um blocker apoiado
      em evidência `[INFERRED]` ou `[UNVERIFIED]` cai aqui, não na regra 1.
- [ ] **3. Pelo menos uma `Condition:`** → *Viable with conditions*, cada condição com responsável e rota.
- [ ] **4. Nenhuma das anteriores** → *Viable*.

- [ ] `Cost driver:` e `FYI:` não moveram o veredito.

*Nunca entregue um veredito sobre uma demanda que você não entendeu.*
*Viable autoriza o refinamento, nunca pular o pipeline de especificação.*

## 7. Follow-ups a registrar antes de encerrar

- [ ] Execução do extractor necessária para um baseline.
- [ ] Divergência roteada às skills de caso de uso (`QM-DO-1`) — nunca remendada aqui.
- [ ] Decisão de ADR a levantar (`Condition:`, responsável o arquiteto). O ADR é redigido pelo fluxo do its-contract, pelo arquiteto nesta etapa ou pelo its-generator quando um plano se comprometer com ele, nunca neste relatório.
- [ ] Slot não preenchido a reportar (`coding-standards`) — nunca improvisado.
- [ ] Lacuna de configuração: um fato do projeto de que a análise precisou e que a configuração não carrega.
- [ ] Dívida que o caminho viável criaria, com um responsável prospectivo (`QM-MT-1`).

## 8. Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito ou proposto.
- [ ] Nenhuma solução projetada: um caminho viável pode ser nomeado dentro do raciocínio do veredito, nunca especificado.
- [ ] Nenhum julgamento sobre se a demanda vale a pena — valor é decisão de quem demanda.
- [ ] Nenhum esforço em lugar algum: nem em horas, pontos ou sprints, nem como uma faixa disfarçada de direcionador de custo.
- [ ] Nenhum caso de uso, ITS, ADR ou arquivo de configuração modificado.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o arquiteto arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — `FA-<demand-id>-N`, `IM-<demand-id>-N`, os quatro vereditos, as quatro severidades, os marcadores de proveniência (`[INFERRED]`, `[UNVERIFIED]`), `UC-NNN`, `ADR-NNN`, `QM-XX-N`, `CS-XX-N`, caminhos de arquivo e identificadores — nunca são traduzidos.

````markdown
# Viabilidade — FA-<id-da-demanda>-N
**Data:** [data] · **Demanda:** [nos termos de quem pediu]
**Veredito:** Viable | Viable with conditions | Not viable as specified | Undecidable with current evidence
**Razão:** [uma linha]

## A demanda, como julgada
- Resultado observável: [uma ou duas frases]
- Explicitamente fora do escopo: [fronteira]

## Base de evidência
- **Mapa de impacto:** IM-<id>-N de [data] — [referência; não reproduzir aqui]
- Baseline: [documentada | parcial — extractor exigido em X | divergência aberta em UC-NNN | green-field]
- Borda do mapa: [o veredito depende de algo além dela? sim/não — se sim, veredito é Undecidable (§6, regra 2)]

## Achados
| # | Severidade | Onde | Critério / evidência | Achado e implicação |
|---|---|---|---|---|
| 1 | Blocker | `pom.xml` (ancorado) | teto de stack — config | [o que é impossível e por quê] |
| 2 | Condition | UC-042 ausente (ancorado) | baseline | [o que precisa ser verdade antes] · responsável: [x] · rota: use-case-extractor |
| 3 | Cost driver | `billing/legacy` (ancorado) | area register | [o que aumenta o tamanho] |
| 4 | FYI | `[INFERRED]` [o que foi deduzido] | [o raciocínio, na própria linha] | [contexto; evidência assim nunca sustenta um Blocker — §6, regra 2] |

## Se Not viable — o que teria de mudar na demanda
- [a porta de saída]

## Se Undecidable — a corrida que decidiria
- [extractor na área X | spike em Y | medição de Z]

## Follow-ups
- [corrida do extractor / divergência para as skills de caso de uso / decisão de ADR a levantar / lacuna de slot / lacuna de config / dívida com responsável]
````

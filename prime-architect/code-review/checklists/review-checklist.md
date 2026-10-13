# Checklist de Revisão

Passada operacional de propriedade do `prime-architect/code-review`. O SKILL.md define o padrão, as severidades, os vereditos e as fronteiras — este arquivo é a sequência e a forma do relatório.

**Este checklist não guarda critérios.** Todo item aponta para o ID onde a resposta vive (`QM-XX-N` no `prime-core/quality-model`, `CS-XX-N` no `prime-core/coding-standards`, a seção da ITS ou `UC-NNN/CA-N`). Um item que você não consegue resolver em um ID não é um achado — é uma preferência, ou uma lacuna a reportar.

---

## 0. Pré-condições — não comece sem elas

- [ ] A **ITS da story** está localizada e lida, junto com todo ADR listado em suas Referências.
- [ ] Os **casos de uso** listados nas Referências da ITS estão lidos: o delta desta story e os critérios de aceite que o delta toca.
- [ ] `docs/prime-config.md` está carregado (pipeline e verificações obrigatórias, comandos de verificação, registro de áreas, overrides de slots).
- [ ] As **verificações obrigatórias estão verdes**, conforme o Passo 0. Nenhum pipeline declarado → os comandos de verificação da configuração rodaram em seu lugar. Vermelho por causa de um teste instável → a revisão começa e isso é um achado `Blocking:` por si só (`QM-TS-1`).
- [ ] O diff é revisável de uma só sentada. Se não for: peça uma divisão, ou declare as unidades do plano que você revisará e em que ordem.

*Sem ITS → reporte e pare, a menos que a mudança seja declarada fora do processo; então declare que a conformidade de escopo não pôde ser verificada.*

## 1. Primeira passada — a mudança faz sentido como um todo?

- [ ] Consigo dizer o que esta mudança deveria fazer antes de ler o diff?
- [ ] A direção tomada corresponde ao plano, ou o autor resolveu um problema diferente?
- [ ] Quais arquivos deveriam ter sido tocados — lidos das unidades do plano — e qual comportamento precisa continuar funcionando (os pontos de regressão e a unidade que reivindicou cada um)?

*Direção errada → pare aqui e diga isso. Não anote código que não deveria existir.*

## 2. Conformidade de escopo (diff ⇄ plano, nas duas direções)

- [ ] **Plano → diff**: toda unidade do plano está presente, ou sua ausência está justificada; todo teste que uma unidade deve existe.
- [ ] **Diff → plano**: todo arquivo alterado remonta a uma unidade ou a uma consequência técnica declarada. Melhorias não solicitadas contam como escopo excedido (`QM-CN-1`).
- [ ] **Fronteiras**: nada em "Fora de escopo — não alterar" foi tocado.
- [ ] **ADRs**: nenhuma contradição com um ADR Accepted; nenhuma decisão arquitetural chegou sem um.
- [ ] **Divergência**: afastamentos do plano foram devolvidos como perguntas e a ITS revisada — não aplicados em silêncio.

## 3. Lentes, em ordem (design primeiro)

- [ ] **Design** — fronteiras, acoplamento, encaixa no sistema? `QM-CC-1..5`, `CS-AR-1..5`.
- [ ] **Funcionalidade** — comportamento contra o resultado de cada item de O que muda da ITS e o `UC-NNN/CA-N` de onde ele veio (coluna Usada em das Referências); concorrência, casos de borda, caminhos de falha (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`).
- [ ] **Complexidade** — legível rapidamente (`QM-RC-2/3/4`); generalidade especulativa é complexidade (`QM-MT-4`).
- [ ] **Testes** — obrigação `CS-TS-1`; escopo a partir dos testes declarados em cada unidade do plano; comportamento, não implementação `QM-TS-2`; confiáveis `QM-TS-1`, `CS-TS-4`. Pontos de regressão cobertos.
- [ ] **Nomenclatura** — `QM-RC-1`, `CS-NM-2`: nenhum nome ocultando I/O, mutação ou um evento.
- [ ] **Comentários** — `QM-RC-5`, `QM-DO-2`: *porquê*, não *quê*.
- [ ] **Estilo e consistência** — slots convencionais julgados contra o estado registrado da área (`current` / `legacy-maintained` / `strangler`). Em legacy-maintained, um achado convencional só é válido se um **terceiro** padrão foi introduzido.
- [ ] **Segurança** — `QM-SR-*` e `CS-SC-*` em toda nova fronteira: entrada validada, segredos ausentes, autorização na camada certa, nada sensível em logs (`CS-OB-3`).
- [ ] **Documentação** — `QM-DO-1`: nenhum documento co-localizado deixado mentindo pela mudança. Comportamento entregue divergindo do caso de uso roteia para as skills de caso de uso, nunca remendado aqui.
- [ ] **Cada linha** que um humano vai manter foi realmente lida.
- [ ] **Uma coisa bem feita** foi identificada e nomeada.

## 4. Classificação

Para cada achado: **onde · o quê · por quê (ID) · o que se espera**.

| Severidade | Usar para | Bloqueia o merge |
|---|---|---|
| `Blocking:` | slot INVARIANT violado; `[NON-NEGOTIABLE]` violado **em silêncio**; teste obrigatório ausente; escopo excedido sem acordo ou fronteira cruzada; conflito com um ADR Accepted; decisão sem ADR; documento deixado mentindo | sim |
| `Consider:` | critérios `[CALIBRATED]` e slots CONVENTIONAL com um argumento real; o autor pode declinar com uma razão | não |
| `Nit:` | trivial, opção do autor. Mecanizável → não é um nit: registre uma lacuna de toolchain | não |
| `FYI:` | contexto, ensino, elogio — sem obrigação | não |

- [ ] Todo achado cita um ID.
- [ ] Afastamentos nomeados, com responsável e justificados foram classificados como exceções registradas, não como blockers (`QM-MT-1`).
- [ ] Achados pequenos repetidos numa área foram agregados no achado de design que os causa.

## 5. Veredito — exatamente um

- [ ] **Approve** — nenhum achado bloqueante.
- [ ] **Approve with comments** — nada bloqueante; Considers deixados ao autor, nenhuma segunda rodada exigida.
- [ ] **Request changes** — pelo menos um `Blocking:`, listado separadamente de todo o resto.
- [ ] **Return to the architect** — o plano está errado, incompleto ou ultrapassado; ou uma decisão precisa de um ADR. Roteia de volta ao its-generator ou às skills de caso de uso.

*Nunca aprove uma mudança que você não entendeu.*

## 6. Follow-ups a registrar antes de encerrar

- [ ] ADR a propor (its-generator, o arquiteto aprova).
- [ ] ITS ou caso de uso a revisar, com a seção nomeada.
- [ ] Slot não preenchido a reportar (`coding-standards`, Slots não preenchidos) — nunca improvisado.
- [ ] Lacuna de toolchain (uma verificação que um humano fez e que uma ferramenta deveria possuir — `QM-CN-3`).
- [ ] Dívida deliberada a registrar, com um responsável (`QM-MT-1`).

## 7. Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito: os entregáveis são achados e, onde o próprio plano estava errado, uma ITS revisada.
- [ ] Nenhum critério repetido num comentário. Todo achado aponta para um ID de propriedade de outro lugar.
- [ ] Nenhum status de caso de uso promovido, nenhuma documentação reescrita, nenhum arquivo de configuração editado como efeito colateral.
- [ ] Nada rediscutido que a toolchain já possui (`QM-CN-3`); sua ausência registrada como lacuna.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o revisor arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — os quatro vereditos, as quatro severidades, `QM-XX-N`, `CS-XX-N`, `UC-NNN`, `ADR-NNN`, `ITS-<story-id>`, caminhos de arquivo e identificadores — nunca são traduzidos.

````markdown
# Revisão — [PR / branch] · ITS-<story-id>

**Veredito:** Approve | Approve with comments | Request changes | Return to the architect
**Razão:** [uma linha]

## Conformidade de escopo
- Plano → diff: [completo | lacunas listadas abaixo]
- Diff → plano: [limpo | escopo excedido listado abaixo]
- Fronteiras de fora de escopo: [respeitadas | cruzadas em ...]
- ADRs: [consistente | conflito com ADR-NNN | ADR a propor]

## Achados
| # | Severidade | Local | Critério | Achado e expectativa |
|---|---|---|---|---|
| 1 | Blocking | `caminho/Arquivo.java:42` | QM-EO-1 / CS-ER-6 | [o que está errado e o que se espera] |
| 2 | Blocking | `caminho/Novo.java` (arquivo inteiro) | ITS › Plano, unidade 4 | [nenhuma unidade do plano pede este arquivo: escopo excedido] |
| 3 | Blocking | `caminho/Pedido.java:120` | UC-042/CA-2 | [o comportamento entregue diverge do critério de aceite] |
| 4 | Consider | `caminho/Outro.java:88` | QM-RC-4 | [argumento; o autor pode declinar com uma razão] |
| 5 | Nit | `caminho/Terceiro.java:12` | CS-NM-1 | [trivial, opção do autor] |

## Follow-ups
- [ADR a propor / seção do ITS a revisar / lacuna de slot / lacuna de toolchain / dívida registrada com responsável]

## Feito bem
- [o que deve ser repetido]
````

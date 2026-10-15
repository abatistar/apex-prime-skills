# Checklist de Revisão

Passada operacional de propriedade do `prime-architect/code-review`. O SKILL.md define o padrão, as severidades, os vereditos e as fronteiras — este arquivo é a sequência e a forma do relatório.

**Este checklist não guarda critérios.** Todo item aponta para o ID onde a resposta vive (`QM-XX-N` no `prime-core/quality-model`, `CS-XX-N` no `prime-core/coding-standards`, a seção da ITS ou `UC-NNN/CA-N`). Um item que você não consegue resolver em um ID não é um achado — é uma preferência, ou uma lacuna a reportar.

---

## 0. Pré-condições — não comece sem elas

- [ ] A **ITS da story** está localizada e lida, junto com todo ADR listado em suas Referências.
- [ ] Os **casos de uso** listados nas Referências da ITS estão lidos: o delta desta story e os critérios de aceite que o delta toca.
- [ ] `docs/prime-config.md` está carregado (pipeline e verificações obrigatórias, comandos de verificação, release fixada do Apex Prime, registro de áreas com estado, nível e exclusões, overrides de slots, exemplos canônicos, migrações declaradas).
- [ ] O estado e o nível de criticidade de cada área tocada foram lidos nas premissas da ITS — não rejulgados.
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
- [ ] **Diff → plano**: todo arquivo alterado remonta a uma unidade ou a uma consequência técnica declarada. Melhorias não solicitadas contam como escopo excedido (`QM-CN-1`); só a arrumação mecânica nas linhas que a unidade já altera, em commit separado, é aceita (`QM-MT-3`).
- [ ] **Decisões de qualidade**: toda decisão de gatilho da ITS chegou ao código com o valor declarado e com o teste ou a medição devida. Gatilho disparado sem decisão na ITS → defeito do plano, não do autor.
- [ ] **Migrações**: nenhuma contagem de migração em curso aumentou (`QM-CN-1`).
- [ ] **Fronteiras**: nada em "Fora de escopo — não alterar" foi tocado.
- [ ] **ADRs**: nenhuma contradição com um ADR Accepted; nenhuma decisão arquitetural chegou sem um.
- [ ] **Divergência**: afastamentos do plano foram devolvidos como perguntas e a ITS revisada — não aplicados em silêncio.

## 3. Lentes, em ordem (design primeiro)

- [ ] **Design** — fronteiras, acoplamento, encaixa no sistema? `QM-CC-1..7`, `CS-AR-1..5`; regra de negócio num lugar só (`QM-CC-6`); contrato publicado sem quebra silenciosa (`QM-CC-7`, `CS-CT-1`).
- [ ] **Funcionalidade** — comportamento contra o resultado de cada item de O que muda da ITS e o `UC-NNN/CA-N` de onde ele veio (coluna Usada em das Referências); concorrência (`QM-RB-5`, `CS-DA-7`), falha parcial (`QM-RB-4`, `CS-DA-6`), repetição (`QM-RB-3`), dependências lentas ou fora (`QM-RB-1`, `QM-RB-6`, `CS-RS-1`, `CS-RS-2`), recursos liberados (`QM-RB-2`), casos de borda e caminhos de falha (`QM-EO-4`, `QM-EO-5`).
- [ ] **Eficiência** — nenhum trabalho ilimitado sobre dado que cresce (`QM-EF-1`, `CS-CT-2`, `CS-DA-5`); meta não funcional medida como a ITS declarou (`QM-EF-2`).
- [ ] **Complexidade** — legível rapidamente (`QM-RC-2/3/4`); generalidade especulativa é complexidade (`QM-MT-4`), na régua do nível declarado.
- [ ] **Testes** — obrigação `CS-TS-1`, `QM-TS-7`; escopo a partir dos testes declarados em cada unidade do plano, inclusive caracterização; comportamento, não implementação `QM-TS-2`; confiáveis `QM-TS-1`, `CS-TS-4`, `CS-TS-5`; nenhum teste existente enfraquecido sem mudança de comportamento decidida (`QM-TS-8`). Pontos de regressão cobertos.
- [ ] **Nomenclatura** — `QM-RC-1`, `CS-NM-2`: nenhum nome ocultando I/O, mutação ou um evento.
- [ ] **Comentários** — `QM-RC-5`, `QM-DO-2`: *porquê*, não *quê*.
- [ ] **Estilo e consistência** — slots convencionais julgados contra o estado registrado da área (`current` / `legacy-maintained` / `strangler`) e contra o exemplo canônico, quando declarado. Em legacy-maintained, um achado convencional só é válido se um **terceiro** padrão foi introduzido. Slots de verificação `ferramenta` não são rediscutidos.
- [ ] **Segurança** — `QM-SR-*` e `CS-SC-*` em toda nova fronteira: entrada validada, segredos ausentes, autorização no servidor negando por padrão e conferindo a titularidade (`QM-SR-8`, `CS-SC-1`), dependência nova admitida e conferida (`CS-DP-1`), dado protegido conforme sua classe (`CS-SC-6`), nada sensível em logs (`CS-OB-3`), eventos de segurança registrados (`CS-OB-5`).
- [ ] **Documentação** — `QM-DO-1`: nenhum documento co-localizado deixado mentindo pela mudança. Comportamento entregue divergindo do caso de uso roteia para as skills de caso de uso, nunca remendado aqui.
- [ ] **Cada linha** que um humano vai manter foi realmente lida.
- [ ] **Uma coisa bem feita** foi identificada e nomeada.

## 4. Classificação

Para cada achado: **onde · o quê · por quê (ID) · o que se espera**.

| Severidade | Usar para | Bloqueia o merge |
|---|---|---|
| `Blocking:` | slot INVARIANT violado; `[NON-NEGOTIABLE]` violado **em silêncio** (inclusive teste enfraquecido e área piorada); teste obrigatório ausente; decisão de qualidade da ITS não cumprida; escopo excedido sem acordo ou fronteira cruzada; contagem de migração aumentada; conflito com um ADR Accepted; decisão sem ADR; documento deixado mentindo | sim |
| `Consider:` | critérios `[CALIBRATED]` e slots CONVENTIONAL com um argumento real; o autor pode declinar com uma razão | não |
| `Nit:` | trivial, opção do autor. Mecanizável → não é um nit: registre uma lacuna de toolchain | não |
| `FYI:` | contexto, ensino, elogio — sem obrigação | não |

- [ ] Todo achado cita um ID.
- [ ] Afastamentos com o registro de exceção completo (critério, onde, por quê, responsável, condição de saída) num veículo legítimo — ITS, ADR ou, para dívida herdada, descrição do PR — classificados como exceções registradas, não como blockers (`QM-MT-1`). Afastamento novo registrado só por quem implementou → divergência, não exceção.
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
- [ ] Lacuna de toolchain (uma verificação que um humano fez e que uma ferramenta deveria possuir, ou um slot de verificação `ferramenta` sem regra no pipeline — `QM-MT-7`).
- [ ] Dívida deliberada a registrar, com responsável e condição de saída (`QM-MT-1`).

## 7. Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito: os entregáveis são achados e, onde o próprio plano estava errado, uma ITS revisada.
- [ ] Nenhum critério repetido num comentário. Todo achado aponta para um ID de propriedade de outro lugar.
- [ ] Nenhum status de caso de uso promovido, nenhuma documentação reescrita, nenhum arquivo de configuração editado como efeito colateral.
- [ ] Nada rediscutido que a toolchain já possui (`QM-MT-7`); sua ausência registrada como lacuna.

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

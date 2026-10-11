# Mapa de impacto — passada operacional

## Configuração

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Mapa de estrutura, registro de áreas, localizações de documentos (UC, ADR) e comandos de verificação carregados.
- [ ] Slot sem valor ou área não registrada registrados como lacuna (`coding-standards`, Slots não preenchidos) — nunca improvisados.

## A mudança, como comportamento

*Apenas em execuções avulsas. Quando comissionado pela `feasibility-analysis`, a reformulação e sua fronteira chegam já feitas e todo este bloco é pulado, **Insufficient input** incluído.*

- [ ] Reformulada como um delta de comportamento observável, não como uma solução.
- [ ] Fronteira declarada: o que explicitamente **não** está mudando.
- [ ] Se a reformulação exigiu inventar intenção → **Insufficient input**, com as perguntas específicas. Pare aqui.
- [ ] Solução nomeada na entrada enquanto existem outros deltas de comportamento → anotado em uma linha, não avaliado.

## Pontos de entrada

- [ ] Todo gatilho localizado e ancorado: endpoint, job, handler de evento, CLI, ação de UI, migração.
- [ ] Pontos de entrada que a busca não conseguiu alcançar (dispatch dinâmico, reflexão, ligação orientada por configuração, convenção de framework) registrados como lacuna com sua resolução.

## Alcance, em três graus

- [ ] **Direto** — precisa mudar para que o comportamento mude. O menor conjunto honesto.
- [ ] **Acoplado** — chamadores, assinantes, relatórios, fixtures, testes, flags, leitores do mesmo estado persistido.
- [ ] **Superfície de contrato** — formatos de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas compartilhadas. Consumidores conhecidos nomeados, não adentrados.
- [ ] Toda entrada carrega localização, grau e uma linha de *por que está no mapa*.

## Sobreposição do registro de áreas

- [ ] Cada área tocada carrega seu estado registrado: `current` / `legacy-maintained` / `strangler`.
- [ ] Estado tirado da configuração — nunca inferido do nome do diretório ou da idade do arquivo.
- [ ] Estado registrado, **não** precificado.

## Sobreposição da camada documentada

- [ ] Cobertura por casos de uso listada (`UC-NNN`, `CA-N` quando específica).
- [ ] Comportamento tocado sem caso de uso → lacuna de documentação, área nomeada, `use-case-extractor` anotado como a rota.
- [ ] Divergência código × caso de uso registrada como achado e roteada às skills de caso de uso (`QM-DO-1`). Nenhum caso de uso remendado aqui.
- [ ] ADRs Accepted que incidem sobre as áreas tocadas listados; contradição aparente declarada e citada, **não resolvida**.

## Proveniência

- [ ] Toda linha é exatamente uma entre: **ancorada** (`caminho/Arquivo.ext:linha` ou `UC-NNN/CA-N`, lida), **`[INFERRED]`** com o raciocínio na linha, **`[UNVERIFIED]`** (afirmada, não conferida) ou **lacuna** com o que a resolveria.
- [ ] Nenhuma inferência sem marca em qualquer ponto do relatório.
- [ ] Este vocabulário é definido por esta skill e reutilizado sem alteração por seus consumidores.

## A borda

- [ ] Parou na superfície de contrato; consumidores nomeados, não rastreados por dentro.
- [ ] Parou onde não há dependência comportamental.
- [ ] O que deliberadamente não foi rastreado está escrito, com o que justificaria rastrear.

## Verificação de fronteira antes de entregar

- [ ] Nenhum veredito, nenhuma recomendação, nenhuma estimativa em qualquer ponto do relatório.
- [ ] Nenhum código de aplicação escrito ou proposto.
- [ ] Nenhum caso de uso, ITS, ADR ou arquivo de configuração modificado.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o arquiteto arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — `IM-<demand-id>-N`, os marcadores de proveniência (`[INFERRED]`, `[UNVERIFIED]`), os estados de área (`current`, `legacy-maintained`, `strangler`), `UC-NNN`, `CA-N`, `ADR-NNN`, `QM-XX-N`, caminhos de arquivo e identificadores — nunca são traduzidos.

````markdown
# Mapa de impacto — IM-<id-da-demanda>-N
**Data:** [dia em que o código foi lido] · **Demanda:** [nos termos de quem pediu]

## A mudança
**Delta de comportamento:** [o que ficará observavelmente diferente, e para quem]
**Não muda:** [fronteira explícita, nos mesmos termos]
**Observação:** [somente se a entrada nomeou uma solução e havia outros deltas viáveis — uma linha, sem avaliação]

## Alcance

[Toda linha carrega exatamente um estado, e o estado vai na coluna Local: ancorada
(`caminho/Arquivo.ext:linha` ou UC-NNN/CA-N, lida), `[INFERRED]` com o raciocínio escrito na
própria linha, ou `[UNVERIFIED]` (afirmado pela demanda, não conferido no código). O que não foi
possível determinar não entra aqui — vai para Lacunas.]

### Direto — precisa mudar
| Local | Por que está no mapa |
|---|---|
| `caminho/Arquivo.ext:42` | [uma linha] |
| `[INFERRED]` `caminho/Outro.ext` | [uma linha, com o raciocínio: o padrão em `caminho/Terceiro.ext:70` indica que...] |

### Acoplado — não muda, mas depende do que muda
| Local | Relação | Por que está no mapa |
|---|---|---|
| `caminho/Outro.ext:88` | chamador / assinante / teste / estado compartilhado | [uma linha] |
| `[UNVERIFIED]` [o componente que a demanda citou] | [relação afirmada] | [uma linha; afirmado na demanda e não conferido — nunca sustenta conclusão bloqueante] |

### Superfície de contrato — visível fora desta base de código
| Superfície | Consumidores conhecidos | Por que está no mapa |
|---|---|---|
| formato da resposta de `POST /orders` | [consumidores nomeados, não rastreados por dentro] | [uma linha] |

## Estados das áreas
| Área | Estado registrado |
|---|---|
| [área] | current / legacy-maintained / strangler |

## Camada documentada
- **Cobertura:** UC-NNN (CA-N, CA-N) cobre [o quê]
- **Lacuna de documentação:** [área] — sem caso de uso para [comportamento]. Rota: `use-case-extractor`.
- **Divergência:** UC-NNN/CA-N afirma [X]; `caminho/Arquivo.ext:120` faz [Y] (`QM-DO-1`). Rota: `use-case-creator`.
- **Incidência de ADR:** ADR-NNN incide sobre [área]. [Contradição aparente, declarada e citada — não resolvida.]

## Lacunas e questões em aberto
| Lacuna | O que resolveria |
|---|---|
| [o que não foi possível determinar] | [o artefato, rastreio ou resposta que fecha a questão] |

## Onde este mapa para
- [o que deliberadamente não foi rastreado, e o que justificaria rastrear]
````

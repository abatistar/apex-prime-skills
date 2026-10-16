# Mapa de impacto — passada operacional

Passada operacional de propriedade do `prime-architect/impact-mapping`. O SKILL.md define os estados de proveniência, os graus, as regras de busca e a borda — este arquivo é a sequência e a forma do relatório.

## Configuração e revisão

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Mapa de estrutura, registro de áreas, migrações declaradas, regras do projeto, localizações de documentos (UC, ADR) e comandos de verificação carregados.
- [ ] Área que o registro não lista escrita como `current` · `padrão`, marcada *não registrada* — o padrão do contrato, não uma lacuna.
- [ ] Subseção Registro de áreas ausente ou slot sem valor de que o mapa precisa registrados como lacuna (`coding-standards`, Slots não preenchidos) — nunca improvisados.
- [ ] Revisão registrada: o commit lido, as mudanças não commitadas declaradas e, com raiz de documentos paralela, a revisão dela. Sem controle de versão acessível, isso dito.

## A mudança, como comportamento

*Definida só aqui. Quando a `feasibility-analysis` comissiona o mapa, ela já executou este bloco no seu §1, e a reformulação chega pronta.*

- [ ] Reformulada como um delta de comportamento observável, não como uma solução.
- [ ] Fronteira declarada: o que explicitamente **não** está mudando.
- [ ] Reformulação que escolheu entre leituras da entrada confirmada com o arquiteto.
- [ ] Se a reformulação exigiu inventar intenção → **Insufficient input**: sem mapa e sem veredito, com as perguntas específicas. Pare aqui.
- [ ] Solução nomeada na entrada enquanto o delta admite outras → anotado em uma linha, não avaliado.

## Pontos de entrada

- [ ] Todo gatilho localizado e ancorado: endpoint, job, handler de evento, CLI, ação de UI, migração.
- [ ] Ponto de entrada que a busca direta não alcança (dispatch dinâmico, reflexão, ligação orientada por configuração, convenção de framework) → `[INFERRED]` com o raciocínio quando há de onde deduzi-lo; lacuna com sua resolução quando não há.

## Alcance, em três graus

- [ ] **Direto** — precisa mudar para que o comportamento mude. O menor conjunto honesto. Regra de negócio replicada: todas as cópias aqui, a duplicação registrada como fato (`QM-CC-6`).
- [ ] **Acoplado** — chamadores, assinantes, relatórios, fixtures, testes, flags, leitores do mesmo estado persistido. Testes que exercitam o conjunto direto listados; código direto sem nenhum teste declarado como tal.
- [ ] **Superfície de contrato** — formatos de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas compartilhadas, telemetria consumida fora (métricas, eventos de log, alertas, painéis). Consumidores conhecidos, inclusive de outros projetos, nomeados, não adentrados.
- [ ] **Dados existentes** — o estado persistido a migrar, preencher ou reinterpretar: forma e, quando acessível, volume; sem acesso ao volume, lacuna.
- [ ] Toda entrada carrega localização, grau e uma linha de *por que está no mapa*.

## Como o alcance foi buscado

- [ ] Referências de símbolo a partir das sementes: chamadores, implementações, sobrescritas, assinantes.
- [ ] Busca textual pelos nomes de contrato (endpoint, tópico, fila, evento, tabela, coluna, chave de configuração, flag) em todos os arquivos: SQL em strings, configuração, migrações, scripts, infraestrutura como código, testes, pipeline.
- [ ] Leitores do mesmo estado persistido procurados.
- [ ] Histórico de mudanças dos arquivos diretos consultado: o que mudou junto foi inspecionado e ancorado, ou entra `[INFERRED]` com a contagem — nunca como evidência de comportamento.
- [ ] Sementes e buscas registradas no relatório.

## Sobreposição do registro de áreas

- [ ] Cada área tocada carrega seu estado registrado (`current` / `legacy-maintained` / `strangler`) e seu nível de criticidade (`efêmera` / `padrão` / `crítica`), ou `current` · `padrão` *não registrada*; código de exclusão marcado como tal.
- [ ] Estado tirado da configuração — nunca inferido do nome do diretório ou da idade do arquivo.
- [ ] Área `strangler` com o módulo substituto e o ID da migração; área proibida ou restrita pelas regras do projeto com a regra citada.
- [ ] Estado registrado, **não** precificado.

## Sobreposição da camada documentada

- [ ] Cobertura por casos de uso listada (`UC-NNN`, com `RN-N`, `CA-N`, passo ou extensão quando específica), **cada um com seu status**.
- [ ] `Draft` → o que o mantém em `Draft` e a rota (`use-case-creator` modo validação, ou o arquiteto para promover). `Retired` cobrindo código que ainda executa → divergência.
- [ ] Comportamento tocado sem caso de uso → lacuna de documentação, área nomeada, `use-case-extractor` anotado como a rota.
- [ ] Divergência código × caso de uso registrada como achado, com o elemento do caso de uso e a âncora no código, e roteada ao `use-case-creator` (`QM-DO-1`). Nenhum caso de uso remendado aqui.
- [ ] ADRs `Accepted` que incidem sobre as áreas tocadas listados; contradição aparente declarada e citada, **não resolvida**. ADRs `Proposed` sobre as áreas listados como decisão em curso.

## A borda

- [ ] Parou na superfície de contrato; consumidores nomeados, não rastreados por dentro.
- [ ] Parou onde não há dependência comportamental.
- [ ] O que deliberadamente não foi rastreado está escrito, com o que justificaria rastrear.

## Verificação antes de entregar

- [ ] Toda âncora aberta nesta execução, na revisão registrada, e a linha citada diz o que a entrada afirma. A que não sobreviveu foi corrigida ou rebaixada a `[INFERRED]` ou a lacuna.
- [ ] Toda linha é exatamente uma entre: **ancorada**, **`[INFERRED]`** com o raciocínio na linha, **`[UNVERIFIED]`** (afirmada, não conferida) ou **lacuna** com o que a resolveria. Nenhuma inferência sem marca.
- [ ] Vocabulário definido por esta skill, com a definição de `[INFERRED]` do formato de caso de uso, e reutilizado sem alteração por seus consumidores.
- [ ] Perfil de evidência contado por grau e escrito no cabeçalho.
- [ ] Nenhum veredito, nenhuma recomendação, nenhuma estimativa em qualquer ponto do relatório.
- [ ] Nenhum código de aplicação escrito ou proposto.
- [ ] Nenhum caso de uso, ITS, ADR ou arquivo de configuração modificado.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o arquiteto arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — `IM-<demand-id>-N`, os marcadores de proveniência (`[INFERRED]`, `[UNVERIFIED]`), os estados de área (`current`, `legacy-maintained`, `strangler`), os níveis de criticidade (`efêmera`, `padrão`, `crítica`), os status de caso de uso (`Draft`, `Reviewed`, `Retired`) e de ADR (`Proposed`, `Accepted`), `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`, `MIG-NNN`, `QM-XX-N`, caminhos de arquivo e identificadores — nunca são traduzidos.

````markdown
# Mapa de impacto — IM-<demand-id>-N
**Revisão:** [commit lido] · [mudanças não commitadas, se houver] · [documentação: revisão, se pasta paralela]
**Data:** [dia da leitura] · **Demanda:** [nos termos de quem pediu]
**Perfil de evidência:** direto [n ancoradas · n INFERRED · n UNVERIFIED] · acoplado [...] · contrato [...] · lacunas [n]

## A mudança
**Delta de comportamento:** [o que ficará observavelmente diferente, e para quem]
**Não muda:** [fronteira explícita, nos mesmos termos]
**Observação:** [somente se a entrada nomeou uma solução e o delta admite outras — uma linha, sem avaliação]

## Alcance

[Toda linha carrega exatamente um estado, e o estado vai na coluna Local: ancorada
(`caminho/Arquivo.ext:linha` ou UC-NNN/RN-N, UC-NNN/CA-N, passo ou extensão — aberta nesta
execução, na revisão do cabeçalho), `[INFERRED]` com o raciocínio escrito na própria linha, ou
`[UNVERIFIED]` (afirmado pela demanda, não conferido no código). O que não foi possível determinar
não entra aqui — vai para Lacunas.]

### Direto — precisa mudar
| Local | Por que está no mapa |
|---|---|
| `caminho/Arquivo.ext:42` | [uma linha] |
| `caminho/Copia.ext:17` | [segunda cópia da mesma regra de negócio — muda junto; duplicação registrada] |
| `[INFERRED]` `caminho/Outro.ext` | [uma linha, com o raciocínio: o padrão em `caminho/Terceiro.ext:70` indica que...] |

### Acoplado — não muda, mas depende do que muda
| Local | Relação | Por que está no mapa |
|---|---|---|
| `caminho/Outro.ext:88` | chamador / assinante / teste / estado compartilhado | [uma linha] |
| `caminho/ArquivoTest.ext:30` | teste | [exercita `caminho/Arquivo.ext:42`] |
| `caminho/Arquivo.ext:90` | sem teste | [código direto que nenhum teste exercita] |
| `[INFERRED]` `caminho/Vizinho.ext` | histórico de mudanças | [mudou junto com `caminho/Arquivo.ext` em 7 de 9 commits; não inspecionado] |
| `[UNVERIFIED]` [o componente que a demanda citou] | [relação afirmada] | [uma linha; afirmado na demanda e não conferido — nunca sustenta conclusão bloqueante] |

### Superfície de contrato — visível fora desta base de código
| Superfície | Consumidores conhecidos | Por que está no mapa |
|---|---|---|
| formato da resposta de `POST /orders` | [consumidores nomeados, inclusive de outros projetos, não rastreados por dentro] | [uma linha] |
| métrica `orders_confirmed_total` | [painel ou alerta que a lê] | [uma linha] |

### Dados existentes
| Estado persistido | Forma e volume | Por que está no mapa |
|---|---|---|
| [tabela ou coleção] | [forma; volume, ou "volume: lacuna"] | [o que a mudança obriga a migrar, preencher ou reinterpretar] |

## Como o alcance foi buscado
- **Sementes:** [os pontos de entrada do Passo 2]
- **Buscas:** [referências de símbolo; nomes de contrato procurados e onde; leitores do estado persistido; histórico consultado]

## Estados das áreas
| Área | Estado registrado | Nível de criticidade | Marcas |
|---|---|---|---|
| [área] | current / legacy-maintained / strangler / exclusão — ou current *não registrada* | efêmera / padrão / crítica — ou padrão *não registrada* | [strangler: substituto e MIG-NNN · regra do projeto citada · nenhuma] |

## Camada documentada
- **Cobertura:** UC-NNN (`Reviewed`; RN-N, CA-N) cobre [o quê]
- **Cobertura não validada:** UC-NNN (`Draft` — [o que o mantém em Draft]) cobre [o quê]. Rota: `use-case-creator` (modo validação) ou o arquiteto, para promover.
- **Lacuna de documentação:** [área] — sem caso de uso para [comportamento]. Rota: `use-case-extractor`.
- **Divergência:** UC-NNN/RN-N afirma [X]; `caminho/Arquivo.ext:120` faz [Y] (`QM-DO-1`). Rota: `use-case-creator` (conformidade ou reconciliação).
- **Divergência:** UC-NNN (`Retired`) — `caminho/Arquivo.ext:200` ainda executa o comportamento retirado.
- **Incidência de ADR:** ADR-NNN (`Accepted`) incide sobre [área]. [Contradição aparente, declarada e citada — não resolvida.]
- **Decisão em curso:** ADR-NNN (`Proposed`) sobre [área] — [o que ela decidiria].

## Lacunas e questões em aberto
| Lacuna | O que resolveria |
|---|---|
| [o que não foi possível determinar] | [o artefato, rastreio ou resposta que fecha a questão] |

## Onde este mapa para
- [o que deliberadamente não foi rastreado, e o que justificaria rastrear]
````

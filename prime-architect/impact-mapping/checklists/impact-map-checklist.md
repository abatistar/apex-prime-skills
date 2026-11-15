# Mapa de impacto — conferência antes de entregar

A conferência final do `impact-mapping`, feita no Passo 7 sobre o mapa pronto, e o template do relatório. O SKILL.md define os estados de proveniência, os graus, as buscas e a borda. Esta lista não os repete: confere se o mapa os cumpre. Corrija cada falha no próprio mapa, em vez de anotá-la.

## 1. A evidência

- [ ] Toda âncora foi aberta nesta execução, na revisão registrada, e a linha citada diz o que a entrada afirma. A que não sobreviveu foi corrigida, ou rebaixada a `[INFERRED]` ou a lacuna.
- [ ] Toda linha carrega exatamente um estado: ancorada, `[INFERRED]` com o raciocínio na linha, `[UNVERIFIED]` ou lacuna com o que a resolveria. Nenhuma inferência sem marca.
- [ ] Nenhuma linha do índice de casos de uso usada como âncora: a cobertura cita o documento aberto.
- [ ] Perfil de evidência contado por grau e escrito no cabeçalho.

## 2. O mapa

- [ ] Cabeçalho completo: ID, revisão (o commit, as mudanças não commitadas e, com raiz de documentos paralela, a revisão dela), data, demanda e perfil de evidência.
- [ ] A mudança escrita como delta de comportamento, com a fronteira do que não muda.
- [ ] Os três graus separados, e toda entrada com o local e uma linha de por que está no mapa. Regra de negócio replicada com todas as cópias no grau direto. Testes do conjunto direto listados, e o código direto sem teste declarado como tal.
- [ ] Dados existentes com forma e volume, ou o volume como lacuna.
- [ ] As quatro buscas do Passo 3 feitas e registradas, com as sementes.
- [ ] Contexto do projeto: os quatro fatos do Passo 4, lidos e não precificados. O nível de criticidade não foi declarado.
- [ ] Camada documentada: cada caso de uso com o seu status; delta pendente conferido antes de registrar divergência; divergências e lacunas de documentação com a rota; ADRs `Accepted` e `Proposed` que incidem, com a contradição declarada e não resolvida.
- [ ] A borda escrita: o que deliberadamente não foi rastreado e o que justificaria rastrear.

## 3. Fronteira

- [ ] Nenhum veredito, nenhuma recomendação, nenhuma estimativa em ponto algum do relatório.
- [ ] Nenhum código escrito. Nenhum caso de uso, ITS, ADR ou configuração modificado.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o arquiteto arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — `IM-<demand-id>-N`, os marcadores de proveniência (`[INFERRED]`, `[UNVERIFIED]`), os níveis de criticidade (`efêmera`, `padrão`, `crítica`), os status de caso de uso (`Draft`, `Reviewed`, `Retired`) e de ADR (`Proposed`, `Accepted`), `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`, `QM-XX-N`, caminhos de arquivo e identificadores — nunca são traduzidos.

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

## Contexto do projeto
- **Legado:** [true / false, da opção Legado da configuração]
- **Sinais de criticidade:** [o que no alcance pesa para o nível da demanda, cada sinal com a âncora — ou nenhum encontrado]
- **Migrações em curso:** [ADR-NNN — valor de destino, código do alcance que o escopo cobre — ou nenhuma]
- **Código gerado ou de terceiros:** [caminho e origem — ou nenhum]

## Camada documentada
- **Cobertura:** UC-NNN (`Reviewed`; RN-N, CA-N) cobre [o quê]
- **Delta pendente:** UC-NNN (`Reviewed`) descreve o estado-alvo de S-NNN, ainda não entregue; `caminho/Arquivo.ext:80` ainda faz o anterior nos itens do delta. Não é divergência.
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

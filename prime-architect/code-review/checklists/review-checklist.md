# Revisão — conferência antes de entregar

A conferência final do `code-review`, feita sobre o relatório pronto, depois do Passo 6, e o template do relatório. O SKILL.md define o padrão, os passos, as severidades e os vereditos. Esta lista não os repete e não guarda critérios: confere se o relatório os cumpre. Quando um item falha, volte ao passo que o produz.

## 1. O relatório

- [ ] Um veredito só — **Approve** · **Approve with comments** · **Request changes** · **Return to the architect** —, com a razão em uma linha. Ou `Not reviewable`, com a pré-condição que falta e quem a resolve, e mais nada.
- [ ] Request changes → os itens que governam o merge numerados e separados de todo o resto.
- [ ] Return to the architect → o que precisa mudar, em qual documento e por qual rota: its-generator, skills de caso de uso ou adr-generator.
- [ ] Demanda `crítica` ou exceção de segurança → aprovação pendente do responsável de segurança, que o arquiteto informa.
- [ ] A conformidade de escopo responde a cada verificação do Passo 2: plano → diff, diff → plano, trechos fixados, alternativas descartadas, decisões de qualidade, migrações de esquema e de convenção, código gerado ou de terceiros, configuração, fronteiras, decisões e divergência.
- [ ] A varredura do piso rodou inteira (Passo 3): os inegociáveis do catálogo, os que o projeto acrescentou por ADR e os slots invariantes.
- [ ] Todas as lentes do Passo 4 foram percorridas, na ordem.
- [ ] A Cobertura diz o que foi lido linha a linha, o que foi só percorrido e o que ficou fora.
- [ ] Uma coisa bem feita está nomeada.
- [ ] Rodada seguinte → o estado de cada item que governava o merge na rodada anterior.

## 2. Cada achado

- [ ] Declara onde, o quê, por quê e o que se espera. O porquê cita um ID e diz, em uma linha, o que ele exige naquele ponto. Achado de comportamento cita o item da ITS (`D3`, `RG-1`, unidade 4), não o caso de uso de origem.
- [ ] A coluna Base carrega o ID exato, sem paráfrase.
- [ ] Todo `Blocking:` cabe num dos casos do Passo 5 e tem evidência ancorada: o local e o cenário concreto de falha, ou, em escopo, a unidade e o arquivo que não se correspondem.
- [ ] Todo `Blocking:` sobreviveu à tentativa de refutação. O que não pôde ser verificado é `Question:`.
- [ ] O que o perfil do nível exige não foi rebaixado a `Consider:`. Nit mecanizável virou lacuna de toolchain.
- [ ] Afastamento com o registro de exceção completo, num veículo legítimo, é exceção registrada, não blocker. Afastamento novo registrado só por quem implementou é divergência.
- [ ] Achados pequenos repetidos numa área foram agregados no achado de design que os causa.

## 3. Follow-ups e fronteira

- [ ] Cada follow-up tem o seu destino: arquiteto, its-generator, skills de caso de uso, configuração, backlog ou dono do modelo de qualidade. Item de backlog redigido com responsável e condição de saída.
- [ ] Nenhum código de aplicação escrito. Nenhuma ITS, caso de uso, status ou configuração editado.
- [ ] Nenhum critério redefinido num comentário, e nada rediscutido que a toolchain já possui.
- [ ] Nada publicado, votado nem registrado no tracker sem o arquiteto ter visto. A entrega no pull request segue `references/pr-delivery.md`.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o revisor arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — os quatro vereditos, `Not reviewable`, as cinco severidades, `QM-XX-N`, `CS-XX-N`, `UC-NNN`, `ADR-NNN`, `ITS-<story-id>`, os identificadores da ITS (`D1`, `RG-1`), caminhos de arquivo e identificadores de código — nunca são traduzidos.

Os trechos entre `[` e `]` são orientação de preenchimento. Quando o resultado é `Not reviewable`, o relatório tem só o cabeçalho, a pré-condição que falta e quem a resolve. No pull request, o relatório se desdobra conforme Entrega no pull request: cada linha de Achados vira um comentário, e o resto forma o resumo.

````markdown
# Revisão — [PR / branch] · ITS-<story-id> · rodada [N]

**Veredito:** Approve | Approve with comments | Request changes | Return to the architect | Not reviewable
**Razão:** [uma linha — ou, em Not reviewable, a pré-condição que falta e quem a resolve]
**Pendente de:** [revisão do responsável de segurança, quando o Passo 6 a exige — senão, omita a linha]

## Rodada anterior
[Só a partir da segunda rodada: cada item que governava o merge, com o estado.]
- Achado 1 (rodada [N-1]): [resolvido | resolvido em parte: o que falta | não tratado]

## Conformidade de escopo
- Plano → diff: [completo | lacunas listadas abaixo]
- Diff → plano: [limpo | escopo excedido listado abaixo]
- Trechos fixados e alternativas descartadas: [respeitados | violados em ...]
- Fronteiras de fora de escopo: [respeitadas | cruzadas em ...]
- ADRs: [consistente | conflito com ADR-NNN | decisão de arquitetura sem registro]

## Achados
| # | Severidade | Local | Base | O que exige aqui · o que está errado · o que se espera |
|---|---|---|---|---|
| 1 | Blocking | `caminho/Arquivo.java:42` | QM-EO-1 / CS-ER-6 | Nenhum erro engolido. O catch registra em DEBUG e devolve sucesso: com o broker fora, o pedido é dado como publicado e some sem rastro. Esperado: propagar a falha ou tratá-la com o motivo escrito no ponto. |
| 2 | Blocking | `caminho/Novo.java` (arquivo inteiro) | ITS › Plano | Nenhuma unidade do plano pede este arquivo, e ele não implementa instrução de nenhuma: escopo excedido. Esperado: remover, ou devolver ao arquiteto a pergunta que o motivou. |
| 3 | Blocking | `caminho/Pedido.java:120` | ITS › D3 | D3 exige recusar a confirmação acima do limite de crédito sem gravar o pedido; com total = limite + 0,01, o pedido é gravado antes da recusa. Esperado: validar antes de persistir. |
| 4 | Question | `caminho/Conta.java:57` | QM-SR-8 / CS-SC-1 | Toda operação confere se o recurso pertence ao chamador. O método não confere a titularidade, e não achei a regra na configuração de segurança: ela existe em outro lugar? |
| 5 | Consider | `caminho/Outro.java:88` | QM-RC-4 | [o que o critério pede aqui e o argumento; o autor pode declinar com uma razão] |
| 6 | Nit | `caminho/Terceiro.java:12` | CS-NM-1 | [trivial, opção do autor] |

## Cobertura
- Lido linha a linha: [unidades e arquivos]
- Só percorrido: [código gerado, dados — e por quê]
- Fora desta revisão: [o que, e por quê]
- Revisão de especialista pendente: [responsável de segurança | nenhuma]

## Follow-ups
- Arquiteto: [decisão de arquitetura sem registro] · its-generator: [seção da ITS a revisar]
- Casos de uso: [UC-NNN contradito pelo comportamento entregue, e em quê]
- Configuração: [seção ausente ou divergente] · Arquiteto: [slot não preenchido]
- Backlog, a registrar pelo arquiteto: [título; lacuna de toolchain ou dívida; responsável; condição de saída]
- Dono do modelo de qualidade: [critério que voltou a bloquear no mesmo ponto]

## Feito bem
- [o que deve ser repetido]
````

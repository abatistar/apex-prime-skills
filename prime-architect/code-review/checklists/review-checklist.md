# Checklist de Revisão

Passada operacional de propriedade do `prime-architect/code-review`. O SKILL.md define o padrão, as severidades, os vereditos e as fronteiras — este arquivo é a sequência e a forma do relatório.

**Este checklist não guarda critérios.** Todo item aponta para onde a resposta vive: o catálogo (`QM-XX-N` no `prime-core/quality-model`, `CS-XX-N` no `prime-core/coding-standards`), o item ou a unidade da ITS, ou o passo do SKILL.md — o Passo 4 é o único mapa de lentes para IDs. Um item que você não consegue resolver em um ID não é um achado — é uma preferência, ou uma lacuna a reportar.

---

## 0. Pré-condições — não comece sem elas

- [ ] A **ITS da story** está localizada e lida, junto com todo ADR listado em suas Referências. Documentação em pasta paralela → lida na revisão que o PR cita.
- [ ] Os **casos de uso** listados nas Referências da ITS estão lidos — para a lente Documentação; o julgamento funcional é contra os itens da ITS.
- [ ] `docs/prime-config.md` está carregado: pipeline e verificações obrigatórias, comandos de verificação, Responsáveis, Tracker e a seção Convenções e restrições por inteiro — release fixada, registro de áreas com estado, nível e exclusões, overrides de slots, soluções e exemplos canônicos, migrações declaradas, postura do modelo de qualidade e regras do projeto.
- [ ] O estado e o nível de criticidade de cada área tocada foram lidos nas premissas da ITS — não rejulgados —, junto com o que o perfil de cada nível exige.
- [ ] As **verificações obrigatórias estão verdes**, conforme o Passo 0. Nenhum pipeline declarado → os comandos de verificação da configuração rodaram em seu lugar. Vermelho por causa de um teste instável → a revisão começa e isso é um achado `Blocking:` por si só (`QM-TS-1`).
- [ ] O diff é revisável de uma só sentada. Se não for: peça uma divisão, ou declare as unidades do plano que você revisará e em que ordem.
- [ ] A **rodada** está identificada. Rodada seguinte → aplique também a seção 7.

*Sem ITS, PR sem a revisão da documentação em pasta paralela, ou verificações vermelhas por outra causa → `Not reviewable`, sem veredito: reporte a pré-condição que falta e quem a resolve. Exceção: mudança declarada fora do processo → declare que a conformidade de escopo não pôde ser verificada e revise só contra o core.*

## 1. Primeira passada — a mudança faz sentido como um todo?

- [ ] Consigo dizer o que esta mudança deveria fazer antes de ler o diff?
- [ ] A direção tomada corresponde ao plano, ou o autor resolveu um problema diferente?
- [ ] Quais arquivos deveriam ter sido tocados — lidos das unidades do plano — e qual comportamento precisa continuar funcionando (os pontos de regressão e a unidade que reivindicou cada um)?
- [ ] Onde o plano pede atenção redobrada (Riscos e pontos de atenção da ITS)?
- [ ] Percurso unidade por unidade, na ordem do plano, com os testes de cada unidade lidos antes do código de produção.
- [ ] Fora do diff, onde o defeito mora fora dele: autorização (configuração de segurança, chamadores), concorrência, transação.

*Direção errada → pare aqui e diga isso. Não anote código que não deveria existir.*

## 2. Conformidade de escopo (diff ⇄ plano, nas duas direções)

- [ ] **Plano → diff**: toda unidade do plano está presente, ou sua ausência está justificada; todo teste que uma unidade deve existe.
- [ ] **Diff → plano**: todo arquivo alterado remonta a uma unidade ou a uma consequência técnica declarada. Melhorias não solicitadas contam como escopo excedido (`QM-CN-1`); só a arrumação mecânica nas linhas que a unidade já altera, em commit separado, é aceita (`QM-MT-3`).
- [ ] **Trechos fixados**: assinaturas, contratos e esquemas chegaram exatamente como fixados.
- [ ] **Alternativas descartadas**: nenhuma unidade tomou o caminho que a sua alternativa descartada recusou.
- [ ] **Decisões de qualidade**: toda decisão de gatilho da ITS chegou ao código com o valor declarado e com o teste ou a medição devida. Gatilho disparado sem decisão na ITS → defeito do plano, não do autor.
- [ ] **Migrações de esquema**: na ordem que a ITS declara, convivendo com a versão em produção (`QM-CC-7`, `CS-CT-1`); nenhuma migração aplicada editada (`CS-DA-4`).
- [ ] **Migrações declaradas**: nenhuma contagem de migração de convenção em curso aumentou (`QM-CN-1`).
- [ ] **Registro de áreas**: nenhum comportamento novo numa área `strangler`; nenhuma exclusão editada à mão.
- [ ] **Configuração**: a atualização do `docs/prime-config.md` que a ITS planejou está no PR; nenhuma mudança na configuração sem unidade que a peça.
- [ ] **Fronteiras**: nada em "Fora de escopo — não alterar" foi tocado.
- [ ] **ADRs**: nenhuma contradição com um ADR Accepted; nenhuma decisão arquitetural chegou sem um.
- [ ] **Divergência**: afastamentos do plano foram devolvidos como perguntas e a ITS revisada — não aplicados em silêncio.

## 3. Varredura do piso — inteira, independentemente das pistas

- [ ] Cada inegociável de "O piso num relance" (`references/quality-criteria.md`), com o seu teste de *Violação*.
- [ ] Os inegociáveis acrescentados pela postura do modelo de qualidade do projeto.
- [ ] Cada slot de "Os invariantes num relance" (`references/convention-slots.md`), no valor efetivo da área. Slots de verificação `ferramenta` cobertos pelo pipeline não são reverificados; os não cobertos são varridos e viram lacuna de toolchain.
- [ ] Atenção redobrada aos pontos em que o código gerado mais falha (quality-model, Código gerado).

## 4. Lentes, em ordem — o mapa de IDs é o Passo 4 do SKILL.md

- [ ] **Design** — as peças pertencem aonde estão; a mudança se encaixa no sistema.
- [ ] **Funcionalidade** — o resultado de cada item de O que muda; o comportamento sob o ambiente que falha; os caminhos de erro.
- [ ] **Segurança** — toda fronteira aberta ou tocada. Área `crítica` → responsável de segurança na revisão (Passo 6).
- [ ] **Eficiência** — nenhum trabalho ilimitado; acesso a dados para o volume de produção; meta não funcional medida como a ITS declarou.
- [ ] **Observabilidade** — o comportamento novo se explica em produção, na intensidade do nível.
- [ ] **Complexidade** — legível rapidamente; nada especulativo, na régua do nível declarado.
- [ ] **Testes** — obrigatórios presentes, por unidade, inclusive caracterização e não regressão; comportamento, não implementação; confiáveis; cada um falharia sem a mudança; nenhum teste existente enfraquecido sem mudança de comportamento decidida.
- [ ] **Nomenclatura** — nenhum nome ocultando I/O, mutação ou um evento.
- [ ] **Comentários** — *porquê*, não *quê*.
- [ ] **Documentação** — nenhum documento co-localizado deixado mentindo; divergência com o caso de uso roteada às skills de caso de uso, nunca remendada aqui.
- [ ] **Estilo e consistência** — slots convencionais contra o estado registrado da área (`current` / `legacy-maintained` / `strangler`) e contra o exemplo canônico, quando declarado. Em legacy-maintained, um achado convencional só é válido se um **terceiro** padrão foi introduzido.
- [ ] **Cada linha** que um humano vai manter foi realmente lida; o que foi só percorrido está na Cobertura.
- [ ] **Uma coisa bem feita** foi identificada e nomeada.

## 5. Classificação

Para cada achado: **onde · o quê · por quê (ID e o que ele exige ali) · o que se espera**.

As severidades e o que cabe em cada uma são os do Passo 5 do SKILL.md; a tabela é só a consulta rápida do efeito.

| Severidade | Pede resposta | Bloqueia o merge |
|---|---|---|
| `Blocking:` | sim | sim |
| `Question:` | sim | só quando a resposta pode tornar um achado bloqueante |
| `Consider:` | sim — aceitar, ou declinar com uma razão | não |
| `Nit:` | não | não |
| `FYI:` | não | não |

- [ ] Cada `Blocking:` cabe num dos casos do Passo 5; o que o perfil do nível exige não foi rebaixado a `Consider:`; nit mecanizável virou lacuna de toolchain.
- [ ] Todo achado cita um ID e diz, em uma linha, o que ele exige naquele ponto. Achados de comportamento citam o item da ITS (`D3`, `RG-1`, unidade 4), não o caso de uso de origem.
- [ ] Todo `Blocking:` tem evidência ancorada: o local e o cenário concreto de falha (entrada ou estado → resultado errado), ou, em escopo, a unidade e o arquivo que não se correspondem.
- [ ] Todo `Blocking:` passou pela tentativa de refutação: guarda em outro ponto, teste que já cobre, chamador que trata, configuração que impede. O que não sobreviveu caiu; o que não pôde ser verificado virou `Question:`.
- [ ] Afastamentos com o registro de exceção completo (critério, onde, por quê, responsável, condição de saída) num veículo legítimo — ITS, ADR ou, para dívida herdada, descrição do PR — classificados como exceções registradas, não como blockers (`QM-MT-1`). Exceção de segurança → com o responsável de segurança. Afastamento novo registrado só por quem implementou → divergência, não exceção.
- [ ] Achados pequenos repetidos numa área foram agregados no achado de design que os causa.

## 6. Veredito — exatamente um, ou `Not reviewable`, conforme o Passo 6

- [ ] Um só: **Approve** · **Approve with comments** · **Request changes** · **Return to the architect** — com a razão em uma linha.
- [ ] Request changes → os itens que governam o merge numerados e separados de todo o resto.
- [ ] Return to the architect → o que precisa mudar e em qual documento, roteado ao its-generator ou às skills de caso de uso; a ITS não é editada aqui.
- [ ] Área `crítica` ou exceção de segurança → aprovação pendente da revisão do responsável de segurança; sem responsável declarado → lacuna reportada e veredito pendente.

*Nunca aprove uma mudança que você não entendeu.*

## 7. Rodadas seguintes — só a partir da segunda

- [ ] Cada `Blocking:` e cada `Question:` que segurava o veredito anterior conferido: resolvido, em parte, não tratado.
- [ ] Lido o delta desde a rodada anterior e o código que ele toca — não o PR inteiro.
- [ ] Nenhum `Consider:` ou `Nit:` novo sobre código que já estava lá; achado novo só se o conserto o introduziu, ou `Blocking:` que escapou — marcado como novo, com a razão.
- [ ] Depois de *Return to the architect*: julgado contra a revisão nova da ITS, citando a numeração nova (`D`, `RG`, `R`) pela correspondência que o its-generator entregou; unidade sem efeito não cobrada, e o destino do código que ela produziu conferido na substituta.

## 8. Follow-ups a registrar antes de encerrar — cada um com o seu destino

- [ ] **its-generator**: ADR a propor (o arquiteto aprova); ITS a revisar, com a seção nomeada.
- [ ] **Skills de caso de uso**: caso de uso que o comportamento entregue contradiz.
- [ ] **Configuração**: slot não preenchido (`coding-standards`, Slots não preenchidos) — nunca improvisado; papel de Responsáveis sem nome de que a revisão precisou.
- [ ] **Backlog**, redigido como item no formato do Tracker, com responsável e condição de saída, para o arquiteto registrar: lacuna de toolchain (uma verificação que um humano fez e que uma ferramenta deveria possuir, ou um slot de verificação `ferramenta` sem regra no pipeline — `QM-MT-7`); dívida deliberada (`QM-MT-1`).
- [ ] **Dono do modelo de qualidade**: `Blocking:` que repete o que revisões anteriores já bloquearam — critério cobrado tarde demais.
- [ ] A coluna de base de cada achado carrega o ID exato, sem paráfrase.

## 9. Verificação de fronteira antes de entregar

- [ ] Nenhum código de aplicação escrito; nenhuma ITS editada — o que o plano precisa mudar está declarado e roteado.
- [ ] Nenhum critério redefinido num comentário: todo achado se apoia num ID de propriedade de outro lugar e diz o que ele exige ali.
- [ ] Nenhum status de caso de uso promovido, nenhuma documentação reescrita, nenhum arquivo de configuração editado como efeito colateral.
- [ ] Nada rediscutido que a toolchain já possui (`QM-MT-7`); sua ausência registrada como lacuna.
- [ ] A Cobertura diz o que não foi lido linha a linha.

## 10. Entrega no pull request — conforme a seção do SKILL.md

- [ ] Plataforma e políticas de PR lidas da seção Pipeline da configuração; sem elas, o relatório inteiro vai ao arquiteto.
- [ ] Um comentário por achado com local, na linha ou no arquivo, começando pelo token da severidade; achados sem local e o resumo na conversa geral.
- [ ] Nenhum comentário com código pronto para aplicar, nem como sugestão de alteração.
- [ ] `Blocking:`, `Question:` e `Consider:` ativos; `Nit:` e `FYI:` publicados já fechados.
- [ ] Voto conforme a tabela da seção; Reject não usado. Aprovação pendente do responsável de segurança → ele incluído como revisor obrigatório.
- [ ] Nada publicado, votado nem registrado no tracker sem o arquiteto ter visto.

---

## Template do relatório

**Idioma.** O bloco abaixo é o artefato que o revisor arquiva, e é escrito no idioma de documento que os templates do core usam: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis — os quatro vereditos, `Not reviewable`, as cinco severidades, `QM-XX-N`, `CS-XX-N`, `UC-NNN`, `ADR-NNN`, `ITS-<story-id>`, os identificadores da ITS (`D1`, `RG-1`, `R1`), caminhos de arquivo e identificadores de código — nunca são traduzidos.

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
- ADRs: [consistente | conflito com ADR-NNN | ADR a propor]

## Achados
| # | Severidade | Local | Base | O que exige aqui · o que está errado · o que se espera |
|---|---|---|---|---|
| 1 | Blocking | `caminho/Arquivo.java:42` | QM-EO-1 / CS-ER-6 | Nenhum erro engolido. O catch registra em DEBUG e devolve sucesso: com o broker fora, o pedido é dado como publicado e some sem rastro. Esperado: propagar a falha ou tratá-la com o motivo escrito no ponto. |
| 2 | Blocking | `caminho/Novo.java` (arquivo inteiro) | ITS › Plano | Nenhuma unidade do plano pede este arquivo: escopo excedido. Esperado: remover, ou devolver ao arquiteto a pergunta que o motivou. |
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
- its-generator: [ADR a propor | seção da ITS a revisar]
- Casos de uso: [UC-NNN contradito pelo comportamento entregue, e em quê]
- Configuração: [slot não preenchido | papel de Responsáveis sem nome]
- Backlog, a registrar pelo arquiteto: [item no formato do Tracker — título; lacuna de toolchain ou dívida; responsável; condição de saída]
- Dono do modelo de qualidade: [critério que voltou a bloquear no mesmo ponto]

## Feito bem
- [o que deve ser repetido]
````

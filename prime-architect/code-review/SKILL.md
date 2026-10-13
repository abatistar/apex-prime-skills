---
name: code-review
description: Revisa uma implementação contra a sua ITS e os padrões do prime-core, produzindo achados classificados e um veredito explícito. Skill da camada do arquiteto - é dona do papel de enforcement que o prime-core/quality-model e o prime-core/coding-standards deliberadamente deixam em aberto. Use sempre que o arquiteto trouxer um pull request, um diff, um branch ou uma implementação de volta do Desenvolvedor - "revise o PR da S-131", "confira esta implementação contra a ITS", "isto está pronto para merge", "o dev terminou a story". NÃO use para escrever ou revisar uma ITS (its-generator), para escrever ou atualizar casos de uso (use-case-creator, use-case-extractor) nem para implementar ou corrigir código (camada do dev - o revisor nunca escreve código de aplicação).
---

# Code Review (prime-architect)

O `prime-core/quality-model` responde *o que é bom*. O `prime-core/coding-standards` responde *como o bom se parece aqui*. Esta skill responde à terceira pergunta, a única que governa um merge: **esta mudança superou a régua, dado o seu contexto?** Transformar definições versionadas em achados precisos e uma recomendação é o trabalho exclusivo desta skill — as duas skills do core declaram que não o fazem.

A disciplina abaixo segue as práticas de engenharia do Google para code review — o padrão de revisão, a ordem das lentes, a severidade dos comentários e a economia de velocidade e tamanho —, reescritas no vocabulário deste repositório e atadas aos seus critérios versionados, de modo que um achado sempre cite um ID estável em vez de um humor.

Duas entradas definem a régua, sempre as duas: a **ITS** (o que foi acordado para esta story) e os **padrões do core** (o que vale para todo código). Uma mudança que implementa a ITS à perfeição enquanto comete em silêncio um pecado capital não passa. Uma mudança com código impecável que estende discretamente o escopo da ITS também não passa.

## O padrão de revisão

Aprove quando a mudança **faz o que a ITS acordou e deixa a saúde do código do sistema melhor do que encontrou** — não quando é perfeita. Perfeição não é a régua e nunca pode virar uma: "sempre dá para melhorar" é como um gate degenera em obstáculo. A pergunta é comparativa e contextual — depois deste merge, a base de código está mais segura, mais previsível e mais barata de mudar do que antes?

Quatro princípios resolvem toda discordância:

1. **Fatos técnicos vencem preferência.** Um achado cita um critério (`QM-XX-N`), um slot (`CS-XX-N`), uma seção da ITS, um critério de aceite (`UC-NNN/CA-N`) ou uma medição. Um achado que não cita nada é uma preferência, e preferências nunca bloqueiam um merge.
2. **Em convenções, o padrão é a autoridade** — para o revisor exatamente como para o autor. Onde o `coding-standards` e o `docs/prime-config.md` declaram um valor, esse valor encerra o assunto. Onde um slot não tem valor, a lacuna é *reportada* (coding-standards, Slots não preenchidos), nunca preenchida com o gosto do revisor.
3. **Design nunca é questão de estilo.** Fronteiras, acoplamento e estrutura são questões técnicas com argumentos, julgadas contra `QM-CC-*` e `CS-AR-*` — nunca com "eu teria feito diferente".
4. **Ensinar é de graça; bloquear não é.** Tudo o que melhora o autor sem ser exigido para o merge é dito como tal e marcado como opcional. Uma revisão que não ensina nada é meia revisão.

## Fronteiras — o que esta skill não faz

- **Nunca escreve código de aplicação.** Os entregáveis do arquiteto são achados e, onde o próprio plano estava errado, uma ITS revisada. A fronteira de papel do Jarvis vale dentro da revisão.
- **Nunca repete um critério.** Todo achado aponta para um ID de propriedade de outro lugar. Uma regra que existe apenas num comentário de revisão é uma regra que o próximo autor não consegue ler.
- **Não refaz o trabalho do pipeline.** As verificações que a configuração declara como obrigatórias são pré-condição da revisão humana, não seu objeto. A atenção gasta rediscutindo o que um formatador, linter ou scanner decide é desperdício (`QM-CN-3`); a *ausência* dessa automação na toolchain é o achado que vale levantar.
- **Não promove status de caso de uso, não reescreve documentação nem edita a configuração como efeito colateral.** Essas rotas pertencem às skills de caso de uso, ao humano e ao prime-config, respectivamente.

## Passo 0 — Carregar a configuração, os contratos e o plano acordado

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, divergência e bootstrap vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa: o **pipeline e suas verificações obrigatórias** onde o projeto declara um, os **comandos de verificação**, o **registro de áreas e os overrides de slots** (Convenções e restrições), as localizações de documentos e as versões da stack que o plano assumiu.

**As verificações automatizadas rodam antes da revisão, não durante ela.** Um pipeline vermelho é a rodada do autor, não a do revisor: a revisão humana começa quando as verificações obrigatórias da configuração estão verdes. Pipeline é uma seção opcional da configuração, e um projeto sem um substitui pelos **comandos de verificação** da configuração — execute-os, ou peça ao autor que reporte o resultado, antes de começar. A única exceção à espera é o vermelho causado por um teste instável: ele não volta para outra rodada, é um achado `Blocking:` por si só (`QM-TS-1`), porque uma suíte ocasionalmente vermelha é o que treina um time a ignorar o vermelho.

Em seguida carregue, nesta ordem:

1. **A ITS da story** e todo ADR listado em suas Referências — conforme o **prime-core/its-contract**. A rastreabilidade plano ⇄ delta que o its-generator já verificou está na estrutura do documento — os itens de O que muda, o Atende e os Testes de cada unidade, a coluna Usada em das Referências —, e é a base sobre a qual a sua própria verificação (diff ⇄ plano) se constrói.
2. **Os casos de uso listados nas Referências da ITS**, conforme o **prime-architect/use-case**: o delta desta story e os critérios de aceite que o delta toca.
3. **prime-core/quality-model** com `references/quality-criteria.md`, e **prime-core/coding-standards** com `references/convention-slots.md` mais o arquivo de padrões da stack do projeto.

**Sem ITS, sem baseline.** Reporte e pare: uma revisão sem o escopo acordado degenera em gosto em três comentários. A única exceção é uma mudança declarada fora do processo (um hotfix): declare explicitamente que a conformidade de escopo não pôde ser verificada e revise apenas contra os padrões do core.

## Passo 1 — Entender a mudança antes de lê-la

Visão ampla primeiro. Leia a Descrição da ITS, a seção O que muda e o plano de implementação; depois a própria descrição do pull request. Você precisa conseguir dizer, antes da primeira linha do diff, o que a mudança deveria fazer, quais arquivos deveria tocar e qual comportamento precisa continuar funcionando (os pontos de regressão da ITS).

Depois percorra o diff **unidade por unidade, na ordem do plano**, não na ordem alfabética da árvore de arquivos. O plano já sequenciou as dependências, e cada unidade declara os arquivos que deveria ter tocado — a resposta para "quais arquivos esta mudança deveria conter" é o próprio percurso, não uma lista separada.

Se a mudança não faz sentido como um todo — direção errada, ITS mal lida, plano ultrapassado pelo código — **pare e diga isso imediatamente**. Quarenta comentários sobre código que não deveria existir desperdiçam o tempo dos dois lados.

Se o diff é grande demais para caber na cabeça, esse é o primeiro achado: peça que seja dividido ou — quando a story realmente é tão grande — revise-o em blocos de unidades do plano, na ordem de execução, e diga quais blocos cada rodada cobre.

## Passo 2 — Conformidade de escopo: a verificação de rastreabilidade da ITS, executada de trás para frente

O its-generator provou plano ⇄ delta antes da entrega. Agora você prova **diff ⇄ plano**, nas duas direções:

- **Plano → diff.** Toda unidade do plano está presente no diff, ou sua ausência está justificada. Todo teste que uma unidade deve existe — os critérios de aceite que seus itens de delta tocam (`CS-TS-1`) e a cobertura de não regressão do ponto de regressão que ela reivindicou.
- **Diff → plano.** Todo arquivo alterado remonta a uma unidade ou a uma consequência técnica declarada. Qualquer outra coisa é escopo excedido — **inclusive melhorias**: um refactor não solicitado está fora de escopo mesmo quando o código melhora, e é erosão (`QM-CN-1`) quando introduz uma segunda forma de fazer algo.
- **Fronteiras.** Nada da lista "Fora de escopo — não alterar" da ITS foi tocado. Essa seção existe justamente para tornar verificável o "tudo e nada além".
- **Decisões.** Nada contradiz um ADR Accepted. Nenhuma decisão arquitetural chegou ao código sem um ADR que a registre (its-contract, fronteira de decisão). Se a implementação precisou tomar essa decisão, o resultado é um ADR a propor — não um achado registrado contra o autor.
- **Divergência.** Onde a implementação se afastou do plano, o afastamento foi devolvido como pergunta e a ITS revisada? Um afastamento **silencioso** é um achado. Um afastamento que está *certo* porque o plano não sobreviveu ao contato com o código não é defeito do autor — é da ITS, e roteia para o quarto veredito.

## Passo 3 — As lentes, em ordem decrescente de custo

Design primeiro, sempre: um comentário de nomenclatura sobre código que precisa ser reestruturado é desperdício duas vezes. Cada lente abaixo é um ponteiro para onde o critério vive — nunca uma redefinição.

- **Design** — as peças pertencem aonde estão, e a mudança se encaixa no sistema em vez de brigar com ele? `QM-CC-1..5`, `CS-AR-1..5`. A coisa mais cara de consertar depois do merge, e a razão de ser lida primeiro.
- **Funcionalidade** — faz o que o delta diz, para o usuário e não apenas para o autor? Concorrência, casos de borda, caminhos de falha (`QM-EO-4`, `QM-EO-5`, `QM-SR-7`). Julgue contra o resultado que cada item de O que muda declara e o `CA-N` de onde ele veio (a coluna Usada em das Referências da ITS diz qual), não contra a sua própria leitura do código.
- **Complexidade** — o próximo leitor consegue entender isto rapidamente (`QM-RC-2`, `QM-RC-3`, `QM-RC-4`)? Generalidade especulativa conta como complexidade (`QM-MT-4`): estrutura construída para um requisito que ninguém pediu é um achado, não previsão.
- **Testes** — o `CS-TS-1` decide o que obriga um teste; a ITS decide quais esta story deve, unidade por unidade, cada unidade do plano declarando os testes que seus itens de delta exigem mais a cobertura de não regressão do ponto de regressão que reivindicou; o `QM-TS-2` decide se vale a pena tê-los (comportamento, não implementação); o `QM-TS-1` e o `CS-TS-4` decidem se podem ser confiáveis. Os testes chegam com a mudança, nunca "num PR de follow-up".
- **Nomenclatura** — `QM-RC-1` / `CS-NM-2`: um nome que oculta I/O, mutação ou um evento emitido é um defeito, não uma preferência.
- **Comentários** — `QM-RC-5`, `QM-DO-2`: explicam o *porquê*. Se você precisou perguntar o que um bloco faz, o código falhou em se explicar — o conserto pertence ao código ou a um comentário, não à resposta do autor para você.
- **Estilo e consistência** — slots convencionais, julgados **contra o estado registrado da área**: numa área `legacy-maintained`, um achado convencional só é válido se a mudança introduziu um *terceiro* padrão, nem local nem atual. O que uma ferramenta poderia decidir não é material de revisão.
- **Segurança** — toda fronteira que a mudança abre ou toca, contra `QM-SR-*` e `CS-SC-*`: entrada validada e neutralizada na fronteira, autorização imposta na camada que a possui, nenhuma credencial no código-fonte, nada da denylist chegando a um log (`CS-OB-3`). Esta dimensão carrega a régua de exceção mais alta do modelo, então uma lacuna aqui nunca é um item calibrado a pesar contra a entrega.
- **Documentação** — `QM-DO-1`: uma mudança de comportamento que deixa um documento co-localizado mentindo é um defeito. Se o comportamento entregue difere do caso de uso, o repositório deixou de ser a fonte de verdade: roteie para as skills de caso de uso; nunca remende um caso de uso de dentro de uma revisão.

Leia cada linha que um humano deverá manter. O autor pode ser o agente Friday em vez de uma pessoa: o padrão é idêntico, e a leitura também — muda apenas o canal (os achados voltam como uma nova rodada de implementação) e a audiência (o relatório continua sendo escrito para ser lido pelo humano dono do pull request).

**Diga o que foi bom.** O Google prescreve isso e o motivo não é cortesia: uma revisão que nomeia apenas defeitos não ensina nada sobre o que repetir.

## Passo 4 — Classificar cada achado

Um achado declara **onde** (arquivo:linha, ou a seção da ITS/caso de uso), **o que** está errado, **por quê** — citando um ID — e **o que se espera**. É uma instrução, não uma implementação: prefira nomear o problema e deixar a solução ao autor; dê uma direção explícita quando o padrão fixa uma (um slot INVARIANT) ou quando o autor a pediu.

Quatro severidades. O *nível* de um critério descreve sua natureza; a severidade aqui é sua *consequência para esta mudança* — e fazer essa tradução é exatamente o que o modelo de qualidade deixa ao revisor.

- **`Blocking:`** — o merge não acontece. Padrão para: um slot INVARIANT violado no que foi escrito ou alterado; um critério `[NON-NEGOTIABLE]` violado **em silêncio**; um teste obrigatório ausente (`CS-TS-1`); escopo excedido sem acordo ou uma fronteira de fora de escopo cruzada; uma contradição com um ADR Accepted; uma decisão arquitetural sem ADR; um documento co-localizado deixado mentindo.
- **`Consider:`** — um julgamento calibrado (`[CALIBRATED]`, slots CONVENTIONAL) com um argumento real. O autor pode declinar com uma razão; declinar é uma resposta legítima. Não bloqueia.
- **`Nit:`** — trivial, opção do autor, nunca uma exigência escondida. Se um nit é mecanizável, não é um nit — é uma lacuna de toolchain, registrada como follow-up em vez de comentário no diff.
- **`FYI:`** — contexto, ensino ou elogio. Não carrega obrigação alguma.

**A regra da exceção.** Um inegociável desrespeitado **deliberadamente** — nomeado, justificado e com responsável (um comentário no ponto, um item de backlog ou um ADR, conforme o `QM-MT-1`) — não é bloqueante; é uma exceção registrada. O que bloqueia é o desvio *silencioso*. Essa distinção única é o que impede a revisão de virar um concurso de pureza, e é a mesma regra que o modelo de qualidade aplica ao legado e à dívida deliberada.

**Agregação.** Muitos achados pequenos numa área costumam ser um único achado de design. Declare a causa uma vez, no nível em que ela pode realmente ser consertada.

## Passo 5 — O veredito

Exatamente um, declarado explicitamente, com sua razão:

- **Approve** — nenhum achado bloqueante. Nits e Considers ficam a critério do autor; não segure um merge por eles.
- **Approve with comments** — nada bloqueante, mas Considers que você espera ver tratados; você confia que o autor os fechará sem outra rodada. Use-o à vontade: uma rodada extra custa mais ao fluxo do que o risco residual.
- **Request changes** — pelo menos um `Blocking:`. Liste os itens bloqueantes numerados e separados de todo o resto, para que o autor saiba exatamente o que governa o merge.
- **Return to the architect** — a revisão descobriu que o *plano* está errado, incompleto ou ultrapassado pelo código, ou que uma decisão precisa de um ADR. Não é um achado contra o autor: sai da revisão e reentra no its-generator (revisar a ITS) ou nas skills de caso de uso (o caso de uso já não descreve o sistema). Declare o que precisa mudar, em qual documento, antes que a implementação possa sequer ser julgada.

Nunca aprove uma mudança que você não entendeu. "Provavelmente funciona" não é um veredito.

## Escrevendo os comentários

- Comente sobre o código, nunca sobre a pessoa: "este método carrega duas responsabilidades", não "você misturou duas responsabilidades".
- Explique o *porquê* e cite o ID, para que o autor aprenda o critério e não apenas a correção.
- Pergunte quando puder estar errado. Muitas vezes é você quem não tem contexto, e "por que assim?" custa uma linha e evita um achado errado.
- Uma instrução por comentário. Um parágrafo com três pedidos tem um deles atendido.

## Pushback

A discordância é resolvida pelo padrão — não por senioridade, volume ou cansaço.

- Se o argumento do autor é tecnicamente melhor, aceite-o. Se revela que o *padrão* está errado, isso é um PR de governança contra o `prime-core`, não uma exceção local concedida numa thread de comentários.
- **"Eu corrijo num follow-up"** é aceitável apenas como dívida deliberada: nomeada, com responsável, com um item de backlog (`QM-MT-1`). Uma promessa sem nome é precisamente o desvio invisível que o modelo proíbe.
- **"É urgente"** muda a calibração (`QM-MT-4`), nunca o piso invariante. A urgência pode justificar adiar um Consider; não justifica uma lacuna de segurança silenciosa — o `QM-SR-*` carrega a régua de exceção mais alta do modelo.
- Se a discordância persiste, escale ao dono do modelo de qualidade com as duas posições e os IDs em jogo. Nunca deixe uma revisão estagnar em silêncio, e nunca ceda à repetição.

## Velocidade e tamanho

A latência de revisão é um custo de processo, pago por todos. Comece assim que as verificações obrigatórias estiverem verdes; um dia útil é o teto. Uma mudança esperando revisão é estoque, e o contexto do autor evapora enquanto ela espera.

Velocidade não é pressa. Vem de revisar na ordem do plano, de parar cedo quando a direção está errada, de não rediscutir o que a toolchain possui e de aprovar com comentários em vez de exigir outra rodada para itens calibrados.

## Saída

Um relatório de revisão — arquivado onde o pull request vive — contendo:

1. O **veredito** e sua razão de uma linha.
2. **Achados**, numerados, cada um com severidade, local, ID citado e expectativa.
3. **Follow-ups**: ADR proposto, ITS ou caso de uso a revisar, slot não preenchido a reportar, lacuna de toolchain, dívida nomeada a registrar.
4. **O que a mudança fez bem.**

A passada operacional e o template do relatório vivem em `checklists/review-checklist.md`. Achados que mudam o escopo acordado também atualizam a ITS — o repositório continua sendo a fonte de verdade do que foi acordado.

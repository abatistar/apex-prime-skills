---
name: code-review
description: Revisa uma implementação contra a sua ITS e os padrões do prime-core, produzindo achados classificados e um veredito explícito. Skill da camada do arquiteto - é dona do papel de enforcement que o prime-core/quality-model e o prime-core/coding-standards deliberadamente deixam em aberto. Use sempre que o arquiteto trouxer um pull request, um diff, um branch ou uma implementação de volta do Desenvolvedor, inclusive a rodada seguinte de um PR já revisado - "revise o PR da S-131", "confira esta implementação contra a ITS", "isto está pronto para merge", "o dev terminou a story", "o dev corrigiu os apontamentos". NÃO use para escrever ou revisar uma ITS (its-generator), para escrever ou atualizar casos de uso (use-case-creator, use-case-extractor) nem para implementar ou corrigir código (camada do dev - o revisor nunca escreve código de aplicação).
---

# Code Review (prime-architect)

O `prime-core/quality-model` responde *o que é bom*. O `prime-core/coding-standards` responde *como o bom se parece aqui*. Esta skill responde à terceira pergunta, a única que governa um merge: **esta mudança superou a régua, dado o seu contexto?** Transformar definições versionadas em achados precisos e uma recomendação é o trabalho exclusivo desta skill — as duas skills do core declaram que não o fazem.

A disciplina abaixo segue as práticas de engenharia do Google para code review — o padrão de revisão, a ordem das lentes, a severidade dos comentários e a economia de velocidade e tamanho —, reescritas no vocabulário deste repositório e atadas aos seus critérios versionados, de modo que um achado sempre se apoie num ID estável em vez de um humor, e diga por extenso o que esse ID exige ali.

Duas entradas definem a régua, sempre as duas: a **ITS** (o que foi acordado para esta story) e os **padrões do core** (o que vale para todo código). Uma mudança que implementa a ITS à perfeição enquanto comete em silêncio um pecado capital não passa. Uma mudança com código impecável que estende discretamente o escopo da ITS também não passa.

## O padrão de revisão

Aprove quando a mudança **faz o que a ITS acordou e deixa a saúde do código do sistema melhor do que encontrou** — não quando é perfeita. Perfeição não é a régua e nunca pode virar uma: "sempre dá para melhorar" é como um gate degenera em obstáculo. A pergunta é comparativa e contextual — depois deste merge, a base de código está mais segura, mais previsível e mais barata de mudar do que antes? O piso dessa comparação é inegociável: a mudança não deixa pior a área que toca (`QM-MT-6`). E o contexto não é julgado de novo aqui: o nível de criticidade de cada área é o que a ITS declara nas premissas.

Quatro princípios resolvem toda discordância:

1. **Fatos técnicos vencem preferência.** Um achado cita um critério (`QM-XX-N`), um slot (`CS-XX-N`), um item ou uma unidade da ITS (`D3`, `RG-1`, unidade 4), uma regra do projeto ou uma medição — e diz o que esse item exige no ponto do código em que o achado está. Um achado que não cita nada é uma preferência, e preferências nunca bloqueiam um merge.
2. **Em convenções, o padrão é a autoridade** — para o revisor exatamente como para o autor. Onde o `coding-standards` e o `docs/prime-config.md` declaram um valor, esse valor encerra o assunto. Onde um slot não tem valor, a lacuna é *reportada* (coding-standards, Slots não preenchidos), nunca preenchida com o gosto do revisor.
3. **Design nunca é questão de estilo.** Fronteiras, acoplamento e estrutura são questões técnicas com argumentos, julgadas contra `QM-CC-*` e `CS-AR-*` — nunca com "eu teria feito diferente".
4. **Ensinar é de graça; bloquear não é.** Tudo o que melhora o autor sem ser exigido para o merge é dito como tal e marcado como opcional. Uma revisão que não ensina nada é meia revisão.

## Fronteiras — o que esta skill não faz

- **Nunca escreve código de aplicação.** Os entregáveis desta skill são achados e um veredito. Onde o próprio plano estava errado, ela declara o que precisa mudar e em qual documento, e roteia — a ITS revisada é produzida pelo its-generator, nunca editada aqui. A fronteira de papel do Jarvis vale dentro da revisão.
- **Nunca redefine um critério; aplica-o.** Todo achado se apoia num ID de propriedade de outro lugar e escreve, em uma linha, o que esse ID exige no ponto do código em que o achado está — nunca o enunciado do catálogo, nunca o ID sozinho. Uma regra que existe apenas num comentário de revisão é uma regra que o próximo autor não consegue ler; um ID solto é uma resposta que ele não consegue abrir. Quem lê o relatório pode não ter os catálogos nem os casos de uso à mão: o vocabulário que ele tem com certeza é o da ITS.
- **Não refaz o trabalho do pipeline.** As verificações que a configuração declara como obrigatórias são pré-condição da revisão humana, não seu objeto. A atenção gasta rediscutindo o que um formatador, linter ou scanner decide é desperdício (`QM-MT-7`) — e todo slot que o `coding-standards` declara com verificação `ferramenta` é desse tipo. A *ausência* dessa automação na toolchain é o achado que vale levantar.
- **Não edita a ITS, não promove status de caso de uso, não reescreve documentação nem edita a configuração como efeito colateral.** Essas rotas pertencem ao its-generator, às skills de caso de uso, ao humano e ao prime-config, respectivamente. A atualização da configuração que a ITS planejou é conferida aqui como qualquer outra unidade (Passo 2) — conferida, nunca feita.
- **Não publica nem vota sozinha, nem registra itens no tracker.** Redige os comentários, o voto e os itens de backlog; publicá-los é ato do arquiteto (Entrega no pull request).

## Passo 0 — Carregar a configuração, os contratos e o plano acordado

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, divergência e bootstrap vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa:

- o **pipeline**, onde o projeto declara um — as verificações obrigatórias, a plataforma em que o PR vive e as políticas de PR (revisores obrigatórios, resolução de comentários) —, e os **comandos de verificação**;
- os **Responsáveis** — o responsável de segurança entra na revisão nos casos do Passo 6;
- o **Tracker**, pelo formato do item de backlog que dívida, teste desativado e flag precisam carregar;
- a seção **Convenções e restrições por inteiro**: a release fixada do Apex Prime, o registro de áreas (estado, nível e exclusões), os overrides de slots, as soluções e exemplos canônicos, as migrações declaradas com sua detecção, a **postura do modelo de qualidade** (inegociáveis acrescentados pelo projeto e critérios calibrados endurecidos) e as **regras do projeto**;
- as localizações de documentos e as versões da stack que o plano assumiu.

**As verificações automatizadas rodam antes da revisão, não durante ela.** Um pipeline vermelho é a rodada do autor, não a do revisor: a revisão humana começa quando as verificações obrigatórias da configuração estão verdes. Pipeline é uma seção opcional da configuração, e um projeto sem um substitui pelos **comandos de verificação** da configuração — execute-os, ou peça ao autor que reporte o resultado, antes de começar. A única exceção à espera é o vermelho causado por um teste instável: ele não volta para outra rodada, é um achado `Blocking:` por si só (`QM-TS-1`), porque uma suíte ocasionalmente vermelha é o que treina um time a ignorar o vermelho.

Em seguida carregue, nesta ordem:

1. **A ITS da story** e todo ADR listado em suas Referências — conforme o **prime-core/its-contract**, sob a raiz de documentos que a configuração declara. Quando ela é uma pasta paralela, versionada à parte, leia a ITS na revisão que o PR cita. A rastreabilidade plano ⇄ delta que o its-generator já verificou está na estrutura do documento — os itens de O que muda, o Atende e os Testes de cada unidade, a coluna Usada em das Referências —, e é a base sobre a qual a sua própria verificação (diff ⇄ plano) se constrói.
2. **Os casos de uso listados nas Referências da ITS**, conforme o **prime-architect/use-case**: o delta desta story e o corpo que ele altera. Eles servem à lente Documentação — conferir que o comportamento entregue não deixa o caso de uso mentindo. O julgamento funcional é contra os itens da ITS, que já carregam por extenso o que os critérios de aceite exigem. Numa ITS técnica — a story que muda o código sem mudar comportamento observável —, os casos de uso listados são só os que forneceram pontos de regressão, e qualquer mudança no comportamento que eles descrevem é escopo excedido.
3. **prime-core/quality-model** com `references/quality-criteria.md` (inclusive "O piso num relance" e os Perfis de criticidade) e `references/quality-triggers.md`, e **prime-core/coding-standards** com `references/convention-slots.md` (inclusive "Os invariantes num relance") mais o arquivo de padrões da stack na release que o projeto fixou.

**Sem pré-condição, sem revisão.** Três faltas impedem a revisão de começar, e a saída é *Not reviewable* (Passo 6), não um veredito: não existe ITS para a story; a descrição do PR não declara a ITS que implementa — nem, quando a documentação vive em pasta paralela, a revisão da documentação implementada; as verificações obrigatórias estão vermelhas por outra causa que não um teste instável. Uma revisão sem o escopo acordado degenera em gosto em três comentários. A única exceção é uma mudança declarada fora do processo (um hotfix): declare explicitamente que a conformidade de escopo não pôde ser verificada e revise apenas contra os padrões do core.

Se esta não é a primeira rodada sobre o PR, a revisão segue também as regras de Rodadas seguintes.

## Passo 1 — Entender a mudança antes de lê-la

Visão ampla primeiro. Leia a Descrição da ITS, a seção O que muda e o plano de implementação; depois a descrição do pull request, que o **prime-core/its-contract** define para o PR de entrega — as unidades implementadas, as perguntas devolvidas e a revisão da ITS que as respondeu, a dívida herdada encontrada, os commits de arrumação, as verificações executadas. Uma descrição incompleta além da ITS citada não impede a revisão: o que faltar e fizer falta vira `Question:`. Você precisa conseguir dizer, antes da primeira linha do diff:

- o que a mudança deveria fazer e quais arquivos deveria tocar;
- qual comportamento precisa continuar funcionando — os pontos de regressão da ITS e a unidade que reivindicou cada um;
- com que nível de cuidado — o estado e o nível de criticidade das áreas tocadas, nas premissas da ITS, e o que o perfil desse nível exige (Perfis de criticidade, no catálogo);
- onde o plano pede atenção redobrada — a seção Riscos e pontos de atenção da ITS.

Depois percorra o diff **unidade por unidade, na ordem do plano**, não na ordem alfabética da árvore de arquivos. O plano já sequenciou as dependências, e cada unidade declara os arquivos que deveria ter tocado — a resposta para "quais arquivos esta mudança deveria conter" é o próprio percurso, não uma lista separada. Dentro de cada unidade, **leia os testes antes do código de produção**: eles mostram o que o autor entendeu do item que a unidade atende, antes que o código convença você de outra coisa.

**O diff não é o perímetro.** Abra o arquivo inteiro quando o trecho alterado depende do que o cerca, e siga o código além do diff onde o defeito costuma morar fora dele: a autorização (a configuração de segurança, quem chama o método), a concorrência (quem mais escreve o mesmo estado), a transação (onde ela abre e fecha). Uma operação sem verificação de autorização no próprio método pode estar protegida na configuração — ou não; só a leitura de fora do diff decide.

Se a mudança não faz sentido como um todo — direção errada, ITS mal lida, plano ultrapassado pelo código — **pare e diga isso imediatamente**. Quarenta comentários sobre código que não deveria existir desperdiçam o tempo dos dois lados.

Se o diff é grande demais para caber na cabeça, esse é o primeiro achado: peça que seja dividido ou — quando a story realmente é tão grande — revise-o em blocos de unidades do plano, na ordem de execução, e diga quais blocos cada rodada cobre.

## Passo 2 — Conformidade de escopo: a verificação de rastreabilidade da ITS, executada de trás para frente

O its-generator provou plano ⇄ delta antes da entrega. Agora você prova **diff ⇄ plano**, nas duas direções, e confere que o código respeitou tudo o que o plano fixou:

- **Plano → diff.** Toda unidade do plano está presente no diff, ou sua ausência está justificada. Todo teste que uma unidade deve existe — os que verificam o resultado dos itens que ela atende (`CS-TS-1`) e a cobertura de não regressão do ponto de regressão que ela reivindicou.
- **Diff → plano.** Todo arquivo alterado remonta a uma unidade ou a uma consequência técnica declarada. Qualquer outra coisa é escopo excedido — **inclusive melhorias**: um refactor não solicitado está fora de escopo mesmo quando o código melhora, e é erosão (`QM-CN-1`) quando introduz uma segunda forma de fazer algo. A única arrumação fora de unidade aceita é a mecânica, confinada às linhas que a unidade já altera, em commit separado e sem mudar nada que outro código use (`QM-MT-3`).
- **Trechos fixados.** Toda assinatura, contrato ou esquema que uma unidade fixou em Trechos fixados chegou ao código exatamente como fixado.
- **Alternativas descartadas.** Nenhuma unidade foi implementada pelo caminho que a sua linha de alternativa descartada recusou — mesmo quando esse caminho funciona. A alternativa descartada é uma fronteira, como o fora de escopo.
- **Decisões de qualidade.** Toda decisão de gatilho que a ITS tomou — timeout, tentativas, mecanismo de consistência, regra de autorização, limite de leitura — chegou ao código com o valor declarado e com o teste ou a medição que a unidade deve. Um gatilho que o código dispara e que a ITS não decidiu é defeito do plano, não do autor: se o autor devolveu a pergunta, a ITS é revisada; se decidiu em silêncio, é a divergência abaixo.
- **Migrações de esquema.** As migrações seguem a ordem que a ITS declara em relação às outras unidades e ao deploy, e convivem com a versão em produção durante o deploy (`QM-CC-7`, `CS-CT-1`). Nenhuma migração já aplicada foi editada (`CS-DA-4`).
- **Migrações declaradas.** Nenhuma mudança aumenta a contagem de ocorrências da forma antiga de uma migração de convenção em curso — isso é erosão (`QM-CN-1`), seja qual for a área.
- **Registro de áreas.** Uma área `strangler` não recebeu comportamento novo: a capacidade nova pertence ao módulo substituto que o registro nomeia. Uma exclusão — código gerado ou de terceiros — não foi editada à mão: a mudança está na entrada do gerador ou na origem.
- **Configuração.** Quando a ITS planejou a atualização do `docs/prime-config.md` — área ou nível novo, pacote novo na Estrutura, avanço ou conclusão de migração, remoção de código efêmero, exemplo canônico ou comando novo —, a unidade chegou no mesmo PR, como qualquer outra. Uma mudança na configuração que nenhuma unidade pede é escopo excedido.
- **Fronteiras.** Nada da lista "Fora de escopo — não alterar" da ITS foi tocado. Essa seção existe justamente para tornar verificável o "tudo e nada além".
- **Decisões.** Nada contradiz um ADR Accepted. Nenhuma decisão arquitetural chegou ao código sem um ADR que a registre (its-contract, fronteira de decisão). Se a implementação precisou tomar essa decisão, o resultado é um ADR a propor — não um achado registrado contra o autor.
- **Divergência.** Onde a implementação se afastou do plano, o afastamento foi devolvido como pergunta e a ITS revisada? Um afastamento **silencioso** é um achado. Um afastamento que está *certo* porque o plano não sobreviveu ao contato com o código não é defeito do autor — é da ITS, e roteia para o quarto veredito.

## Passo 3 — A varredura do piso

Antes de julgar, verifique. O piso é binário, e por isso é varrido, não ponderado: percorra contra o diff, item a item,

- os inegociáveis de "O piso num relance" (`references/quality-criteria.md`), cada um com o seu teste de *Violação*;
- os inegociáveis que o projeto acrescentou na postura do modelo de qualidade;
- os slots de "Os invariantes num relance" (`references/convention-slots.md`), no valor efetivo da área.

As listas pertencem aos catálogos e não se repetem aqui; a varredura percorre cada uma inteira, não uma seleção. Os slots de verificação `ferramenta` que o pipeline cobre não são reverificados — o que ele não cobre é varrido, e a ausência da regra vira follow-up de toolchain.

**A varredura roda inteira, seja qual for o ponto para onde as pistas apontam** — a descrição do PR, um comentário anterior, o resultado de uma ferramenta, as suas próprias suspeitas. Uma revisão guiada pelas pistas encontra mais problemas leves onde elas estão e não encontra mais problemas graves; a varredura completa é o que neutraliza essa ancoragem.

**Código gerado.** O autor é muitas vezes um agente — o Friday, ou uma pessoa assistida por um. A varredura dá atenção redobrada aos pontos em que o código gerado mais falha, listados no quality-model (Código gerado, na seção do its-implementation): lógica duplicada, dependência inventada ou com nome não conferido, saída sem codificação, teste ajustado para passar, estrutura especulativa, comentário que narra o código, captura genérica que engole o erro. É a mesma lista que o implementador percorreu na autoverificação; aqui se confere que ela foi cumprida.

## Passo 4 — As lentes, em ordem decrescente de custo

A varredura diz se a mudança fica acima do piso; as lentes julgam o resto — o calibrado, na intensidade que o nível da área pede. Design primeiro, sempre: um comentário de nomenclatura sobre código que precisa ser reestruturado é desperdício duas vezes. Cada lente abaixo é um ponteiro para onde o critério vive — nunca uma redefinição — e esta lista é o único mapa de lentes para IDs desta skill; o checklist aponta para ela.

- **Design** — as peças pertencem aonde estão, e a mudança se encaixa no sistema em vez de brigar com ele? `QM-CC-1..7`, `CS-AR-1..5`: uma regra de negócio num lugar só (`QM-CC-6`), nenhum contrato publicado quebrado em silêncio (`QM-CC-7`, `CS-CT-1`). A coisa mais cara de consertar depois do merge, e a razão de ser lida primeiro.
- **Funcionalidade** — faz o que o delta diz, para o usuário e não apenas para o autor? Julgue contra o resultado que cada item de O que muda declara — a exigência inteira está escrita no item; o critério de aceite de onde ele veio é procedência, não régua —, não contra a sua própria leitura do código. Depois, o comportamento sob o ambiente que falha: concorrência (`QM-RB-5`, `CS-DA-7`), falha parcial entre recursos (`QM-RB-4`, `CS-DA-6`), idempotência onde há repetição (`QM-RB-3`, `CS-DA-2`), dependências lentas ou fora do ar (`QM-RB-1`, `QM-RB-6`, `CS-RS-1`, `CS-RS-2`), recursos liberados (`QM-RB-2`). E os caminhos de erro: nada engolido, nada interno devolvido a quem chama, a causa preservada (`QM-EO-1`, `QM-EO-2`, `QM-EO-3`, `CS-ER-4`, `CS-ER-5`, `CS-ER-6`); falhar rápido e erro esperado tratado como resultado (`QM-EO-4`, `QM-EO-5`, `CS-ER-1`).
- **Segurança** — toda fronteira que a mudança abre ou toca, contra `QM-SR-*` e `CS-SC-*`: entrada validada e neutralizada na fronteira (`QM-SR-1`, `CS-SC-2`); autorização imposta no servidor, negando por padrão e conferindo a titularidade do recurso (`QM-SR-8`, `CS-SC-1`); nenhuma credencial no código-fonte (`QM-SR-2`, `CS-SC-3`); criptografia só a sancionada (`QM-SR-3`, `CS-SC-4`); dependência nova admitida e conferida (`QM-SR-4`, `CS-DP-1`); dado protegido tratado conforme sua classe e no mínimo necessário (`QM-SR-10`, `CS-SC-6`); nada da denylist chegando a um log (`CS-OB-3`); eventos de segurança registrados (`QM-SR-9`, `CS-OB-5`). Esta dimensão carrega a régua de exceção mais alta do modelo, então uma lacuna aqui nunca é um item calibrado a pesar contra a entrega — e, numa área `crítica`, a revisão inclui o responsável de segurança (Passo 6).
- **Eficiência** — nenhum trabalho ilimitado sobre dado que cresce: consulta sem limite, coleção inteira em memória, consulta por item em laço (`QM-EF-1`, `CS-CT-2`, `CS-DA-5`). O acesso a dados desenhado para o volume de produção (`QM-EF-3`). Uma meta não funcional é medida como a ITS declarou (`QM-EF-2`).
- **Observabilidade** — o comportamento novo se explica em produção: funcionou, quantas vezes, em quanto tempo, para quem falhou (`QM-EO-7`, `CS-OB-4`), na intensidade do nível — um sinal por comportamento novo no `padrão`; métrica e alerta para cada meta e cada caminho de erro no `crítica`. Logs estruturados, com a semântica de nível do projeto e a correlação propagada (`QM-EO-8`, `CS-OB-1`, `CS-OB-2`).
- **Complexidade** — o próximo leitor consegue entender isto rapidamente (`QM-RC-2`, `QM-RC-3`, `QM-RC-4`)? Generalidade especulativa conta como complexidade (`QM-MT-4`): estrutura construída para um requisito que ninguém pediu é um achado, não previsão. A régua é a do nível de criticidade que a ITS declara.
- **Testes** — o `CS-TS-1` decide o que obriga um teste e o `QM-TS-7` que ele chega com a mudança, nunca "num PR de follow-up"; a ITS decide quais esta story deve, unidade por unidade, cada unidade do plano declarando os testes que seus itens de delta exigem mais a cobertura de não regressão do ponto de regressão que reivindicou, e os testes de caracterização que planejou (`QM-TS-9`); o `QM-TS-2` decide se vale a pena tê-los (comportamento, não implementação); o `QM-TS-1`, o `CS-TS-4` e o `CS-TS-5` decidem se podem ser confiáveis. Cada teste **falharia sem a mudança** (`QM-TS-7`): uma asserção que passaria também sobre o código anterior não verifica o item. Na dúvida, numa área `crítica`, a prova é rodar o teste contra o código anterior à mudança; sem como rodar, a dúvida vira `Question:`. Um teste existente apagado, desativado ou afrouxado sem que o plano tenha mudado o comportamento que ele verifica é o `QM-TS-8` violado.
- **Nomenclatura** — `QM-RC-1` / `CS-NM-2`: um nome que oculta I/O, mutação ou um evento emitido é um defeito, não uma preferência.
- **Comentários** — `QM-RC-5`, `QM-DO-2`: explicam o *porquê*. Se você precisou perguntar o que um bloco faz, o código falhou em se explicar — o conserto pertence ao código ou a um comentário, não à resposta do autor para você.
- **Documentação** — `QM-DO-1`: uma mudança de comportamento que deixa um documento co-localizado mentindo é um defeito. Comportamento entregue que difere da ITS é achado de Funcionalidade, contra o autor. Se ele cumpre a ITS e ainda assim difere do caso de uso, o defeito está nos documentos, e o veredito é *Return to the architect*: a ITS que traduziu mal o caso de uso volta ao its-generator; o caso de uso que já não descreve o sistema vai às skills de caso de uso. O delta pendente de outra story no mesmo caso de uso não é defeito de documentação (prime-architect/use-case, Ciclo de vida do status): julgue contra a ordem de entrega que a ITS declara nas premissas. Nunca remende um documento de dentro de uma revisão.
- **Estilo e consistência** — slots convencionais, julgados **contra o estado registrado da área**: numa área `legacy-maintained`, um achado convencional só é válido se a mudança introduziu um *terceiro* padrão, nem local nem atual. Onde o projeto declara um exemplo canônico, a forma dele é a referência. O que uma ferramenta poderia decidir não é material de revisão.

Leia cada linha que um humano deverá manter; código gerado e arquivos de dados podem ser só percorridos, e a Cobertura do relatório diz isso. Quando o autor é o agente Friday, o padrão é idêntico, e a leitura também — muda apenas o canal (os achados voltam como uma nova rodada de implementação) e a audiência (o relatório continua sendo escrito para ser lido pelo humano dono do pull request).

**Diga o que foi bom.** O Google prescreve isso e o motivo não é cortesia: uma revisão que nomeia apenas defeitos não ensina nada sobre o que repetir.

## Passo 5 — Classificar cada achado

Um achado declara **onde** (arquivo:linha, ou o item, a unidade ou a seção da ITS), **o que** está errado, **por quê** — citando um ID e escrevendo, em uma linha, o que ele exige naquele ponto — e **o que se espera**. É uma instrução, não uma implementação: prefira nomear o problema e deixar a solução ao autor; dê uma direção explícita quando o padrão fixa uma (um slot INVARIANT) ou quando o autor a pediu.

**Evidência.** Um `Blocking:` exige evidência ancorada: o local e o **cenário concreto de falha** — com tal entrada ou tal estado, tal resultado errado —, ou, num achado de escopo, a unidade e o arquivo que não se correspondem. Antes de publicar um `Blocking:`, tente refutá-lo: existe uma guarda em outro ponto do caminho, um teste que já cobre o caso, um chamador que o trata, uma configuração que o impede? O achado que não sobrevive à tentativa cai. O que você não conseguiu verificar — porque depende de execução, de dado ou de código que você não leu — não é `Blocking:`: é `Question:`. É a mesma distinção que o impact-mapping marca como `[INFERRED]` (deduzido em vez de rastreado de ponta a ponta) e `[UNVERIFIED]` (afirmado e não conferido), e a mesma refutação que a feasibility-analysis exige de um `Blocker:`. Uma suspeita publicada como certeza é o defeito mais caro desta skill: ensina o autor a ignorar também os achados certos.

Cinco severidades. O *nível* de um critério descreve sua natureza; a severidade aqui é sua *consequência para esta mudança* — e fazer essa tradução é exatamente o que o modelo de qualidade deixa ao revisor.

- **`Blocking:`** — o merge não acontece. Padrão para:
  - um slot INVARIANT violado no que foi escrito ou alterado;
  - um critério `[NON-NEGOTIABLE]` — do core ou acrescentado pelo projeto — violado **em silêncio**, inclusive um teste enfraquecido para ficar verde (`QM-TS-8`) e uma área deixada pior do que estava (`QM-MT-6`);
  - uma exigência do perfil de criticidade da área, um critério calibrado que o projeto endureceu ou uma regra do projeto descumpridos sem registro de exceção;
  - um teste obrigatório ausente (`CS-TS-1`, `QM-TS-7`) ou uma decisão de qualidade da ITS não cumprida;
  - escopo excedido sem acordo, uma fronteira de fora de escopo cruzada, um trecho fixado alterado, o caminho de uma alternativa descartada tomado, comportamento novo numa área `strangler`, uma exclusão editada à mão;
  - a contagem de uma migração declarada aumentada;
  - uma contradição com um ADR Accepted ou uma decisão arquitetural sem ADR;
  - um documento co-localizado deixado mentindo.
- **`Question:`** — você pode estar errado, e a resposta decide: uma suspeita que a leitura não confirmou nem refutou, ou um porquê que o código não diz. Uma pergunta cuja resposta pode tornar um achado bloqueante segura o veredito; uma que só busca entender, não. Pergunta retórica — um pedido disfarçado — não é `Question:`: é o achado que ela esconde, com a severidade dele.
- **`Consider:`** — um julgamento calibrado com um argumento real: um critério `[CALIBRATED]` acima do que o nível da área exige, ou um slot CONVENTIONAL. O autor pode declinar com uma razão; declinar é uma resposta legítima. Não bloqueia. O que o perfil do nível *exige* não é `Consider:` — é exigência, e o seu descumprimento sem registro é `Blocking:`.
- **`Nit:`** — trivial, opção do autor, nunca uma exigência escondida. Se um nit é mecanizável, não é um nit — é uma lacuna de toolchain (`QM-MT-7`), registrada como follow-up em vez de comentário no diff.
- **`FYI:`** — contexto, ensino ou elogio. Não carrega obrigação alguma.

**A regra da exceção.** Um inegociável desrespeitado **deliberadamente** não é bloqueante; é uma exceção registrada. Registrada significa os cinco elementos do registro de exceção do modelo de qualidade — critério, onde, por quê, responsável e condição de saída — num veículo legítimo: a ITS, quando o plano o decidiu; um ADR, quando vale além da story; ou, para a dívida herdada que quem implementou encontrou e nomeou, a descrição do PR. Uma exceção de segurança só é registrada com o responsável de segurança que o projeto declara, junto com o arquiteto. O que bloqueia é o desvio *silencioso*. Um afastamento novo que só quem implementou registrou não é exceção: quem implementa não concede exceções, e o desvio é tratado como a divergência do Passo 2. Essa distinção é o que impede a revisão de virar um concurso de pureza, e é a mesma regra que o modelo de qualidade aplica ao legado e à dívida deliberada.

**Agregação.** Muitos achados pequenos numa área costumam ser um único achado de design. Declare a causa uma vez, no nível em que ela pode realmente ser consertada.

## Passo 6 — O veredito

**Antes do veredito: *Not reviewable*.** Quando falta uma pré-condição do Passo 0, a revisão não começou e não há veredito. A saída é uma linha com a pré-condição que falta e quem a resolve. Não é um julgamento contra a mudança — ninguém a julgou.

Uma revisão que começou termina em exatamente um veredito, declarado explicitamente, com sua razão:

- **Approve** — nenhum achado bloqueante e nada que peça resposta. Nits ficam a critério do autor; não segure um merge por eles.
- **Approve with comments** — nada bloqueante, mas Considers ou Questions que pedem resposta — aceitar ou declinar com uma razão — antes do merge, sem outra rodada de revisão. Use-o à vontade: uma rodada extra custa mais ao fluxo do que o risco residual.
- **Request changes** — pelo menos um `Blocking:`, ou uma `Question:` cuja resposta pode tornar um achado bloqueante. Liste os itens que governam o merge numerados e separados de todo o resto, para que o autor saiba exatamente o que precisa fazer.
- **Return to the architect** — a revisão descobriu que o *plano* está errado, incompleto ou ultrapassado pelo código, ou que uma decisão precisa de um ADR. Não é um achado contra o autor: sai da revisão e reentra no its-generator (caminho de revisão da ITS) ou nas skills de caso de uso (o caso de uso já não descreve o sistema). Declare o que precisa mudar, em qual documento, antes que a implementação possa sequer ser julgada. Esta skill não edita o documento.

**O responsável de segurança.** Numa mudança que toca uma área `crítica` ou que carrega uma exceção de segurança, a revisão inclui o responsável de segurança que a configuração declara: *Approve* e *Approve with comments* saem pendentes da revisão dele, e o relatório diz isso. Sem responsável declarado, a lacuna é reportada (prime-config, Responsáveis) e o veredito fica pendente até que o papel seja preenchido.

Nunca aprove uma mudança que você não entendeu. "Provavelmente funciona" não é um veredito.

## Rodadas seguintes

A segunda rodada não é uma revisão nova da mesma mudança. Ela começa quando o autor responde à anterior e segue quatro regras:

1. **Primeiro, o que governava o merge.** Cada `Blocking:` e cada `Question:` que segurava o veredito é conferido um a um: resolvido, resolvido em parte ou não tratado. Um `Consider:` declinado com razão é uma resposta, não uma pendência.
2. **Só o que mudou.** Leia o delta desde a rodada anterior e o código que ele toca, não o PR inteiro de novo. As verificações obrigatórias voltam a ser pré-condição.
3. **Sem mover a trave.** Um achado novo só entra se o conserto o introduziu, ou se é um `Blocking:` que a rodada anterior deixou passar — e então é marcado como novo, com a razão de não ter aparecido antes. Um `Consider:` ou `Nit:` novo sobre código que já estava lá na rodada anterior não entra.
4. **Contra a ITS em vigor.** Depois de um *Return to the architect*, a rodada julga contra a revisão nova da ITS. Os números das unidades são estáveis; `D`, `RG` e `R` podem ter sido renumerados — use a correspondência entre a numeração antiga e a nova que o its-generator entregou, e cite a nova. Uma unidade declarada sem efeito não é cobrada; se ela já tinha sido implementada, confira o destino que a unidade substituta deu ao código.

O relatório da rodada diz qual rodada é e o estado de cada item que governava o merge na rodada anterior.

## Escrevendo os comentários

- Comente sobre o código, nunca sobre a pessoa: "este método carrega duas responsabilidades", não "você misturou duas responsabilidades".
- Escreva o que o critério exige ali, em uma linha, e cite o ID — o autor aprende o critério sem precisar abrir o catálogo, e não apenas a correção.
- Pergunte quando puder estar errado, com `Question:`. Muitas vezes é você quem não tem contexto, e "por que assim?" custa uma linha e evita um achado errado.
- Uma instrução por comentário. Um parágrafo com três pedidos tem um deles atendido.

## Pushback

A discordância é resolvida pelo padrão — não por senioridade, volume ou cansaço.

- Se o argumento do autor é tecnicamente melhor, aceite-o. Se revela que o *padrão* está errado, isso é um PR de governança contra o `prime-core`, não uma exceção local concedida numa thread de comentários.
- **"Eu corrijo num follow-up"** é aceitável apenas como dívida deliberada: nomeada, com responsável, com um item de backlog no formato do Tracker do projeto e uma condição de saída (`QM-MT-1`). Uma promessa sem nome é precisamente o desvio invisível que o modelo proíbe.
- **"É urgente"** pode justificar adiar um Consider; não muda o nível de criticidade que a ITS declarou nem o piso invariante (`QM-MT-4`). Não justifica uma lacuna de segurança silenciosa — o `QM-SR-*` carrega a régua de exceção mais alta do modelo.
- Se a discordância persiste, escale ao dono do modelo de qualidade com as duas posições e os IDs em jogo. Nunca deixe uma revisão estagnar em silêncio, e nunca ceda à repetição.

## Velocidade e tamanho

A latência de revisão é um custo de processo, pago por todos. Comece assim que as verificações obrigatórias estiverem verdes; um dia útil é o teto. Uma mudança esperando revisão é estoque, e o contexto do autor evapora enquanto ela espera.

Velocidade não é pressa. Vem de revisar na ordem do plano, de parar cedo quando a direção está errada, de não rediscutir o que a toolchain possui e de aprovar com comentários em vez de exigir outra rodada para itens calibrados.

## Saída

Um relatório de revisão — o registro completo, publicado no pull request conforme Entrega no pull request — contendo:

1. O **veredito** e sua razão de uma linha — ou *Not reviewable* e a pré-condição que falta, e o relatório para aí.
2. A **rodada** e, a partir da segunda, o estado de cada item que governava o merge na anterior.
3. A **conformidade de escopo**.
4. **Achados**, numerados, cada um com severidade, local, ID citado, o que ele exige ali e a expectativa.
5. A **cobertura**: o que foi lido linha a linha, o que foi só percorrido (código gerado, dados), o que ficou fora e por quê, e a revisão de especialista pendente — o responsável de segurança, quando o Passo 6 o exige.
6. **Follow-ups**, cada um com o seu destino:
   - ao its-generator — o ADR a propor, a seção da ITS a revisar;
   - às skills de caso de uso — o caso de uso que o comportamento entregue contradiz;
   - à configuração — o slot não preenchido, o papel de Responsáveis sem nome;
   - ao backlog — a lacuna de toolchain e a dívida nomeada, cada uma redigida como item no formato que o Tracker declara, com responsável e condição de saída, para o arquiteto registrar;
   - ao dono do modelo de qualidade — o critério cobrado tarde demais (abaixo).
7. **O que a mudança fez bem.**

**Os achados são dado.** O dono do modelo de qualidade agrega os achados de revisão por critério para decidir o que sobe no fluxo (quality-model, Sinais e evolução). Por isso a coluna de base de cada achado carrega o ID exato, sem paráfrase, e a severidade usa os tokens estáveis. Quando você reconhece um `Blocking:` que repete o que revisões anteriores do projeto já bloquearam, registre-o como follow-up ao dono do modelo: um critério que bloqueia sempre no mesmo ponto é cobrado tarde demais, e deve virar gatilho, para a ITS decidir, ou ferramenta, para o pipeline verificar.

A passada operacional e o template do relatório vivem em `checklists/review-checklist.md`. Achados que mudam o escopo acordado roteiam ao its-generator, que revisa a ITS — o repositório continua sendo a fonte de verdade do que foi acordado, e esta skill não o edita.

## Entrega no pull request

O relatório é o registro completo; no pull request, ele se desdobra para que cada achado tenha a sua conversa e o veredito governe o merge pelas políticas da plataforma. A plataforma e as políticas de PR são as que a configuração declara em Pipeline. Sem elas declaradas, o relatório é entregue inteiro ao arquiteto, que decide onde publicá-lo.

**Quem publica.** Esta skill redige os comentários, o voto e os itens de backlog; publicá-los, votar e registrar os itens é ato do arquiteto — ou do agente, por ordem explícita dele para aquela revisão. Um comentário publicado chega ao autor e fica no histórico do PR: nada sai sem que o arquiteto tenha visto o que sai.

**Os comentários.**

- Cada achado com local vira um comentário na linha — ou no arquivo, quando vale para o arquivo inteiro —, começando pelo token da severidade (`Blocking:`, `Question:`, ...) e com o mesmo texto do relatório.
- O achado sem local no código — de escopo, de ITS, de documentação — vai na conversa geral do PR.
- O resumo é um comentário só, na conversa geral: o veredito e a razão, a rodada, a conformidade de escopo, a cobertura, os follow-ups, o que foi bem feito e a lista numerada do que governa o merge, cada item apontando para o seu comentário.
- Nenhum comentário traz código pronto para aplicar — nem pelo recurso de sugestão de alteração da plataforma: seria escrever código de aplicação. O comentário instrui.

**O que pede resposta fica aberto.** Os comentários de `Blocking:`, `Question:` e `Consider:` abrem ativos: todos pedem resposta antes do merge. `Nit:` e `FYI:` são publicados já fechados — não pedem nada, e um comentário ativo sem pedido vira bloqueio por acidente quando a política exige a resolução de todos. O autor responde e marca o desfecho: o corrigido como resolvido; o `Consider:` declinado, com a razão, como não corrigido. Quem confirma que um `Blocking:` foi resolvido é o revisor, na rodada seguinte; o que não foi resolvido volta a ficar ativo.

**O voto, no Azure DevOps.**

| Resultado da revisão | Voto | Observação |
|---|---|---|
| Approve | Approve | |
| Approve with comments | Approve with suggestions | os comentários ativos seguram a conclusão do PR até a resposta, quando a resolução de comentários é obrigatória |
| Request changes | Wait for author | |
| Return to the architect | Wait for author | o resumo diz que a espera é pela revisão da ITS, não por um conserto; o autor devolve o PR a rascunho até ela chegar |
| Not reviewable | Wait for author | o resumo diz a pré-condição que falta e quem a resolve |

Reject não é usado: nenhum resultado desta skill diz que a mudança não deve existir — direção errada é Request changes ou Return to the architect. Quando a aprovação fica pendente do responsável de segurança (Passo 6), ele é incluído no PR como revisor obrigatório, e o voto do arquiteto, sozinho, não conclui o merge. Em outra plataforma, o desenho é o mesmo, com os votos e os estados de comentário equivalentes.

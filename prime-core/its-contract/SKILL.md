---
name: its-contract
description: O contrato canônico da ITS (Instrução de Trabalho de Software) - seções obrigatórias, nível de detalhe, regras de escrita, nomenclatura, regras de rastreabilidade e a fronteira com os registros de decisão (ADR). É o artefato de passagem de bastão entre o Arquiteto de Soluções e o Desenvolvedor, autossuficiente - legível por quem implementa, por lideranças técnicas e por compliance. O its-generator do arquiteto escreve contra este contrato; o its-implementation do dev lê contra ele. Consulte sempre que for produzir, validar ou consumir uma ITS. Nunca duplique seu conteúdo em outro lugar - referencie-o.
---

# Contrato da ITS (prime-core)

A ITS é o artefato de passagem de bastão do fluxo: o Arquiteto de Soluções a escreve, o Desenvolvedor implementa a partir dela, e o code review do arquiteto valida contra ela. Esta skill é dona do seu formato. Como quem escreve e quem lê consomem o mesmo contrato, uma mudança aqui atualiza os dois lados de uma vez — sem descolamento entre especificação e implementação.

A ITS tem um lar canônico (o repositório) e mais de um leitor: o implementador (dev humano e/ou o agente), o revisor, lideranças técnicas e compliance. Boa parte deles a lê **fora do contexto em que foi escrita** — na plataforma de documentação da empresa, ou numa sessão que não carrega o repositório de casos de uso, os ADRs nem os catálogos do prime-core. Por isso a ITS é **autossuficiente**: tudo o que ela exige está escrito nela, e os documentos de que foi derivada aparecem apenas como procedência, na seção Referências (veja Regras de escrita). Um único documento atende a todos por meio da **leitura em camadas**: leitores não técnicos param na Descrição e nas frases de síntese de O que muda; o implementador consome toda a profundidade técnica. O documento é escrito uma vez — nunca em versões por audiência.

## Nomenclatura de arquivo

`docs/its/ITS-<story-id>-titulo-curto.md` (ou conforme sobrescrito pelo `docs/prime-config.md`). Uma ITS por story.

## Templates canônicos

Este contrato é dono de dois: `templates/its-template.md`, para a ITS, e `templates/adr-template.md`, para os registros de que uma ITS deriva restrições, cujas regras vivem junto à fronteira de decisão abaixo. Leia integralmente o que você está prestes a escrever ou validar.

As quatro seções obrigatórias da ITS, nesta ordem:

- **Descrição** — o sumário executivo: 3–5 linhas em linguagem de negócio dizendo o que a story muda, para quem e com que efeito observável. Sem identificadores de código nem de outros documentos. A única seção que leitores que não implementam precisam ler. Escrita por último, depois de fechado o plano, para permanecer fiel.
- **O que muda** — o delta da story, escrito por extenso. Uma subseção por área de comportamento afetada, nomeada pelo comportamento e nunca pelo identificador do caso de uso de origem, carregando apenas o que existe neste eixo: uma frase de síntese em linguagem de comportamento, as mudanças como **itens numerados** (`D1`, `D2`, ...) e, quando a story altera comportamento que já existe, o que continua valendo como **pontos de regressão numerados** (`RG-1`, `RG-2`, ...). Cada item é a exigência inteira e verificável — condição, resposta do sistema e resultado observável —, nunca um apontamento para onde ela está escrita. Nenhum mapeamento para arquivos aqui: o plano é dono do mapeamento único.
- **Plano de implementação** — a espinha do documento, escrita em ordem de execução. Abre com as premissas técnicas: a stack e as versões que o plano assume. Uma unidade numerada por passo de trabalho, cada uma declarando: os arquivos que cria, modifica ou remove; o que fazer, com toda exigência escrita na instrução; os trechos fixados, quando uma assinatura, um contrato ou um esquema precisa ser exato; os itens que atende (`D1`) ou a consequência técnica que a justifica; os testes que deve; e, só quando havia mais de um caminho viável, a alternativa descartada. Uma unidade que toca código compartilhado com um ponto de regressão declara o teste de não regressão que deve. O plano fecha com as alterações de esquema e migração, as fronteiras de fora de escopo, os riscos e pontos de atenção e os comandos de verificação do projeto.
- **Referências** — a procedência do documento: a story, os casos de uso, os ADRs e os critérios de qualidade ou slots de convenção de que ele foi derivado, cada um com um identificador local (`R1`, `R2`, ...) e com os itens e as unidades em que foi usado. É a única seção em que identificadores de outros documentos aparecem. Nada nela é necessário para executar o plano: serve ao revisor, à auditoria e a quem tem acesso às fontes. Veja Regras de escrita.
- **Um eixo só.** O mapeamento de comportamento para código existe uma vez, no plano de implementação, no eixo em que o implementador trabalha: a ordem de execução. O que muda carrega o que o plano não pode — as mudanças e o que precisa continuar funcionando — e nada que o plano vá repetir. Duas seções descrevendo a mesma mudança em dois eixos obrigam o leitor a refazer uma fusão que o documento já fez, e a seção que ele pula é justamente a que não foi escrita no eixo dele.

## Nível de detalhe

- Toda mudança planejada nomeia arquivos ou componentes concretos. "Ajustar a camada de serviço" não é grau ITS; `OrderService.confirm(): adicionar validação de limite antes de persistir` é.
- A ITS instrui; não implementa. Sem listagens completas de código — trechos apenas quando uma assinatura, um contrato ou um esquema precisa ser fixado exatamente.
- Escreva para eliminar perguntas. A política de ambiguidade do implementador é devolver perguntas, não presumir — cada pergunta devolvida é um buraco na ITS. Isso vale identicamente para o dev humano e para o agente de IA: uma instrução que admite duas implementações é um defeito, não uma questão de estilo.
- As convenções do projeto chegam como instrução concreta. O plano aplica o quality-model, o coding-standards e a configuração do projeto; não os cita. Onde uma convenção decide algo que o implementador poderia fazer de outro jeito — o tipo de exceção, o formato do erro, o padrão local de uma área legada, o nome de um recurso —, a unidade escreve a escolha concreta ("lançar `BusinessException` com o código `CREDIT_LIMIT_EXCEEDED`"), nunca o slot que a define. O que vale para todo código, em qualquer story, não se repete em cada ITS: é a base de quem implementa.
- Os testes são declarados por unidade do plano, não em um bloco de estratégia separado: cada unidade deve os testes que verificam o resultado observável dos itens que atende, mais a cobertura de não regressão de qualquer ponto de regressão que compartilhe código com ela. Todo ponto de regressão listado em O que muda é reivindicado por exatamente uma unidade — um ponto de regressão sem dono é uma falha de rastreabilidade.

## Regras de escrita

As mesmas regras servem a todo leitor — humano ou agente. O que torna uma instrução inequívoca para um LLM é o que a torna verificável para um revisor e legível para compliance.

**Separação de registro — comportamento em prosa, código em listas de instrução.**
- A prosa (descrição, frases de síntese, itens de O que muda, justificativa, riscos) usa linguagem de comportamento: "o sistema passa a rejeitar pedidos acima do limite de crédito". Sem nomes de classes na prosa, salvo se inevitável.
- As listas do plano (Arquivos, O que fazer, Testes) usam linguagem de código. Cada item de O que fazer é uma instrução: o alvo exato (arquivo, `Classe.metodo(Tipo)`, endpoint ou coluna), o verbo no imperativo, a condição em que vale e o resultado verificável, com nomes, códigos e valores concretos. Um alvo com mais de uma instrução vira um item com subitens, uma instrução por subitem.
- Uma assinatura, um contrato ou um esquema que precisa ser fixado exatamente vai num trecho curto em bloco de código, no campo Trechos fixados da unidade, precedido pela instrução que o exige — depois da lista, nunca dentro dela, onde o bloco interrompe a numeração.
- Tabela só para conteúdo de fato tabular, uma linha por registro e células de uma linha, como Referências. Uma célula que precisa de condição e resultado é uma instrução, e pertence à lista.

**Voz do autor — o documento instrui; não narra a própria produção.**
A ITS leva a assinatura do arquiteto e se lê como instrução dele. Um documento que narra deliberação convida a renegociar o que já foi decidido, e um hedge chega ao implementador como ambiguidade — que volta como pergunta, o vaivém que este contrato existe para evitar. A regra é uma lista fechada de marcas, não um estilo a imitar:

- Sem narração de como o plano foi produzido: o que foi inspecionado, buscado, considerado ou descartado pelo caminho.
- Sem autorreferência ao documento ou à sua redação.
- Sem hedge dentro de uma instrução ("provavelmente", "talvez", "sugere-se", "seria interessante"). A decisão está fechada quando a ITS é entregue.
- Sem seção preenchida por cerimônia. Havendo nada a declarar, a seção declara isso ("nenhuma identificada").
- Sem endereçamento a quem encomendou o plano ("conforme solicitado"). O leitor é o implementador.

Isso governa resíduo de processo, nunca a substância do plano: declarar por que um caminho foi escolhido é instrução e pertence ao documento — é o que a linha de alternativa descartada faz. Tampouco é uma instrução para ocultar como o documento foi redigido — o arquiteto o aprova e o assina, e responder a essa pergunta com honestidade não é afetado por esta regra.

**Disciplina de frase.**
- Uma instrução por frase. Voz ativa, tempo presente. Frases compostas escondem instruções que o implementador pode perder e que o revisor não consegue conferir item a item.
- Toda menção se resolve dentro do documento: um item (`D3`), um ponto de regressão (`RG-1`), uma unidade ("unidade 4"), um caminho completo de arquivo. Nunca "a regra acima", "como discutido", "o ajuste de sempre" — dêixis e pressuposição são o principal ponto de falha tanto para agentes quanto para leitores que entram no meio do documento. O que não está escrito na ITS não existe para o leitor.
- Todo critério é verificável: números, condições, valores nomeados ("timeout de 30s", nunca "um timeout adequado").
- Jargão e siglas do projeto são expandidos na primeira ocorrência por seção. O documento será lido fora do contexto da story.
- **Numeração no escopo do documento.** `D`, `RG`, `R` e as unidades são numerados de forma contínua no documento inteiro e nunca reiniciam por subseção, mesmo quando mais de um caso de uso é afetado — nenhum identificador do documento precisa de qualificação. Os identificadores das fontes (`UC-042`, `RN-3`, `CA-2`) nunca são reaproveitados como identificadores do documento: pertencem a outro escopo, que o leitor não tem como resolver.

**Conteúdo, não ponteiro — o documento é autossuficiente.**
Um identificador diz ao leitor qual documento guarda a resposta; não diz a resposta. Quem lê a ITS fora do repositório não tem como seguir o identificador, e quem a lê dentro dele pesa o custo da consulta contra o valor esperado e a pula — corretamente, diante de um identificador solto. A ITS, portanto, escreve a exigência, nunca o apontamento para ela: `OrderService.confirm — aplicar UC-042/RN-3` é um apontamento; `OrderService.confirm — rejeitar quando o total do pedido exceder o limite de crédito vigente do cliente` é uma instrução.

- **Identificadores de outros documentos aparecem só em Referências.** `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`, `QM-XX-N` e `CS-XX-N` não entram no corpo, e o ID da story aparece apenas no título. O corpo também não cita as próprias Referências: a ligação vai da tabela para o corpo, pela coluna Usada em, nunca do corpo para a tabela.
- **O que cada fonte entrega ao corpo.** Uma regra de negócio entra como sua condição e sua resposta, restritas ao que esta story precisa — já é escrita como exigência, na forma que o formato de caso de uso define. Um critério de aceite entra como o resultado verificável de um item e como o teste que a unidade deve. Um ADR entra como o que ficou decidido e o que isso exige deste plano, na unidade que ele vincula — nunca o contexto, a justificativa ou as alternativas, que permanecem no ADR. Um critério de qualidade ou um slot de convenção entra como a escolha concreta que impõe, ou como o afastamento que o plano registra por extenso.
- **O limite da cópia.** A ITS escreve o que esta story precisa, e só isso: as mudanças, o que continua valendo e as restrições que vinculam o plano. Nunca reproduz um fluxo inteiro, uma regra que o plano não toca, a justificativa de um ADR ou o enunciado de um critério. O caso de uso continua sendo a fonte viva do comportamento e o ADR o único dono da justificativa; a ITS é um derivado datado — um snapshot na entrega, como as premissas técnicas — e não compete com eles como fonte de verdade.
- Onde a exigência não pode ser escrita em uma ou duas linhas sem arrastar a justificativa junto, a fonte é que está no lugar errado. Ou a decisão tem escopo de story — uma linha de alternativa descartada —, ou o documento-fonte é o que precisa de conserto. Resumir a justificativa dentro da ITS não é nenhuma das duas coisas.

A regra vale no documento inteiro: Descrição, O que muda, todo campo de uma unidade do plano — o que fazer, o que atende, os testes que deve, a alternativa descartada — e as fronteiras de fora de escopo. A única seção fora dela é Referências, que existe justamente para guardar o que o corpo não carrega.

**Referências — a procedência, não o conteúdo.**
A seção Referências liga o documento às fontes de que foi derivado, para quem revisa, para a auditoria e para quem tem acesso aos repositórios. Ela não completa o corpo: um leitor que nunca a lê executa o mesmo plano.
- Uma tabela simples, `Ref · Fonte · Usada em`, com uma linha por documento de origem: a story, cada caso de uso, cada ADR e cada critério de qualidade ou slot de convenção que fundamenta uma escolha ou um afastamento registrado. Numere `R1`, `R2`, ... na ordem em que a fonte entra no documento; a story é sempre `R1`.
- **Fonte** identifica o documento por extenso: o tipo escrito por extenso ("Caso de uso", "ADR", "Critério de qualidade", "Slot de convenção"), o identificador, o nome ou título e o estado que a ITS assume — o cenário do caso de uso (criação, alteração, conformidade, retirada), o status do ADR, o nível do critério ou a classe do slot — e, para a story, o link resolvível para o item no tracker.
- **Usada em** diz onde a fonte entrou no documento, com o elemento interno da fonte entre parênteses: `D1 (RN-3, CA-2) · D2 (extensão 4a) · RG-1 (passo 5)`, `unidade 3`. É aí que vive a trilha de auditoria item a item.
- **Apenas procedência, nunca conteúdo.** Uma linha de Referências não glosa nem resume a fonte: o que a fonte exige já está escrito no corpo, onde é usado.
- É um snapshot na entrega, mesma disciplina das premissas técnicas: quem escreve a preenche a partir dos documentos já abertos durante o planejamento, de modo que não custa nada e não pode ser inventada.

**Escopo negativo explícito.**
O plano de implementação declara o que **não** deve mudar: uma linha por área intocável, com a razão e a cobertura de regressão que a protege ("Não modificar `PaymentService` — fluxo de estorno inalterado, coberto por testes de não regressão"). Para o implementador, é uma fronteira rígida ("tudo e nada além" exige bordas nomeadas); para o revisor, um checklist; para compliance, evidência de contenção de risco.

**Formatação pronta para publicação.**
A ITS precisa sobreviver à inserção na plataforma de documentação da empresa sem retrabalho — e essas restrições melhoram a legibilidade em qualquer lugar:
- A ITS é escrita na marcação de wiki do Confluence, conforme o template, que lista a sintaxe e as armadilhas. Só a ITS: casos de uso e ADRs seguem em Markdown.
- No máximo 3 níveis de título e 2 níveis de aninhamento de lista.
- Apenas tabelas simples: sem células de várias linhas, sem HTML embutido, sem colunas mescladas.
- Blocos de código são simples, nunca aninhados e nunca dentro de uma lista; usados apenas onde o contrato permite trechos.
- Sem diagramas no corpo da ITS (os documentos de caso de uso são donos dos diagramas).

**Teste pré-entrega.** Antes de entregar, responda quatro perguntas sobre o documento pronto:
1. *Teste do implementador:* alguma instrução admite duas implementações diferentes? Se sim, é uma pergunta que o implementador devolverá — feche-a agora.
2. *Teste do leitor frio:* alguém que nunca viu a story — sem acesso aos casos de uso, aos ADRs nem aos catálogos do prime-core — entende o documento inteiro e consegue executar o plano sem abrir outro documento? Algum identificador de outro documento aparece fora de Referências?
3. *Teste da colagem:* inserido como marcação na plataforma de documentação, tabelas, hierarquia de títulos e numeração das listas sobrevivem?
4. *Teste do autor:* alguma frase descreve como o documento foi produzido em vez do que deve ser feito? Alguma instrução faz hedge de uma decisão que já está fechada?

Um documento que falha em qualquer um dos quatro não é entregável.

## Regras de rastreabilidade (bidirecional, por item e unidade do plano)

A rastreabilidade não é uma seção: está na estrutura do documento. Os itens vivem em O que muda, cada unidade declara o que atende e os testes que deve, e Referências liga cada item à sua fonte. Quem escreve executa as verificações abaixo antes de entregar, e o revisor as refaz a partir do próprio documento — nenhuma tabela de evidência é escrita para isso.

- Delta → plano: todo item `D` é atendido por pelo menos uma unidade, ou declara, na própria linha, que já é atendido hoje e por quê.
- Plano → delta: toda unidade nomeia os itens que atende, ou declara a consequência técnica que a justifica.
- Regressão → plano: todo ponto de regressão (`RG-N`) é reivindicado nos testes de exatamente uma unidade, que nomeia o teste de não regressão que deve.
- Fonte → item: todo item e todo ponto de regressão aparece em Referências, na linha da fonte de que veio.
- **Alternativa descartada:** quando uma unidade tinha mais de um caminho de implementação viável, a própria unidade declara, em uma linha, a alternativa descartada e a razão decisiva — uma fronteira para quem implementa, que não deve "melhorar" o plano pelo caminho descartado. Sem alternativa viável → nada a declarar; é um registro de escolhas reais, não um campo de formulário.
- **Verificação de fronteira:** nenhuma decisão arquitetural tomada no corpo do documento — cada uma vive em um ADR listado em Referências, e o corpo escreve apenas o que ela exige do plano.

Uma ITS que falha em qualquer um desses pontos não é entregável.

## Fronteira de decisão: ITS vs ADR

A ITS registra decisões que **morrem com a story** (escolhas entre caminhos de implementação equivalentes — capturadas pela regra da alternativa descartada acima). Decisões que **sobrevivem à story** não são tomadas na ITS; vão para um Architecture Decision Record (ADR), e a ITS lista o ADR em Referências e escreve, nas unidades que ele vincula, o que ele exige deste plano.

Uma decisão sobrevive à story quando pelo menos uma destas vale:
- ela restringe escolhas futuras de implementação (padrão, biblioteca, estilo de integração, estratégia de persistência);
- afeta mais de um caso de uso ou módulo;
- alguém que nunca leu esta ITS precisará da justificativa mais tarde.

O `templates/adr-template.md` é a estrutura canônica do ADR, de propriedade deste contrato pelo mesmo motivo que o template da ITS: um endereço, lido por quem redige e por quem valida. Leia-o integralmente antes de redigir ou aprovar um registro. A localização e a nomenclatura dos ADRs vêm do `docs/prime-config.md`, com padrão `docs/adr/ADR-NNN-titulo-curto.md`, sequencial e nunca renumerado. O its-generator detecta decisões candidatas e **propõe** o ADR; o arquiteto aprova antes de a ITS ser entregue. Uma ITS que toma uma decisão arquitetural no corpo em vez de registrá-la num ADR não é entregável — mesma gravidade de uma falha de rastreabilidade. A detecção não é exclusiva do its-generator: qualquer skill da camada do arquiteto pode levantar que uma decisão é devida — a `feasibility-analysis` faz isso como uma `Condition:` quando uma demanda desafia uma decisão registrada. **A redação pertence ao ponto em que a decisão se torna concreta.** Um ADR é redigido pela skill cujo próprio entregável precisa se comprometer com a decisão, razão pela qual o its-generator é a única skill que redige um: é a única que precisa escrever um plano que a decisão vincula, unidade por unidade. Ele redige como `Proposed`; o arquiteto decide e aprova. Uma skill que julga ou mapeia não se compromete com nada, então levanta a questão e a roteia; nunca arquiva um ADR Proposed com base em uma análise cujos próprios artefatos vivem fora do repositório.

**O arquiteto nunca é bloqueado por essa regra.** Ela governa qual *skill* pode redigir, não se uma decisão pode ser registrada. Uma decisão tomada onde não existe plano para se comprometer com ela — em aconselhamento arquitetural, ou no refinamento antes de qualquer story — é redigida diretamente pelo arquiteto, contra este template e este ciclo de vida, e não precisa de story para existir. O que a regra proíbe é uma skill arquivar um registro com base em uma análise sobre a qual nunca teve de construir nada. Quem tomou a decisão é exatamente quem deve o registro, e uma decisão que vincula trabalho futuro enquanto espera uma story para carregá-la é a partida invisível que o `QM-MT-1` nomeia.

## Regras de consumo (para o implementador)

- A ITS é o escopo. Implemente toda ela e nada além — incluindo respeitar as fronteiras de fora de escopo e as alternativas descartadas declaradas no plano de implementação.
- As restrições de ADR escritas nas unidades são vinculantes; nunca contradiga um ADR Accepted. Com acesso ao repositório, leia os ADRs listados em Referências antes de implementar — para saber o porquê; o quê já está na unidade. Um conflito entre a ITS e um ADR é ambiguidade — devolva-o como pergunta.
- Ambiguidade, contradição ou detalhe ausente → não preencha a lacuna por suposição; devolva perguntas ao arquiteto referenciando a seção da ITS e a unidade ou o item.
- Desvios descobertos durante a implementação (o plano não sobrevive ao contato com o código) → reporte; o arquiteto revisa a ITS. O documento permanece como fonte de verdade do que foi acordado. Cópias publicadas em outros lugares são visões; validar a divergência entre elas e o repositório é responsabilidade do arquiteto, não do implementador.

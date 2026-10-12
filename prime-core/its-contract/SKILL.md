---
name: its-contract
description: O contrato canônico da ITS (Instrução de Trabalho de Software), de propriedade do prime-core - seções obrigatórias, nível de detalhe, regras de escrita, nomenclatura, regras de rastreabilidade e a fronteira com os registros de decisão (ADR). É o artefato de passagem de bastão entre o Arquiteto de Soluções e o Desenvolvedor, legível também por lideranças técnicas e compliance sem tradução. O its-generator do arquiteto escreve contra este contrato; o its-implementation do dev lê contra ele. Consulte sempre que for produzir, validar ou consumir uma ITS. Nunca duplique seu conteúdo em outro lugar - referencie-o.
---

# Contrato da ITS (prime-core)

A ITS é o artefato de passagem de bastão do fluxo: o Arquiteto de Soluções a escreve, o Desenvolvedor implementa a partir dela, e o code review do arquiteto valida contra ela. Esta skill é dona do seu formato. Como quem escreve e quem lê consomem o mesmo contrato, uma mudança aqui atualiza os dois lados de uma vez — sem descolamento entre especificação e implementação.

A ITS tem um lar canônico (o repositório) e mais de um leitor: o implementador (dev humano e/ou o agente Friday), o revisor, lideranças técnicas e compliance — incluindo leitores que encontram o documento fora do repositório, na plataforma de documentação da empresa. Um único documento atende a todos por meio da **leitura em camadas** (veja Regras de escrita): leitores não técnicos param no sumário executivo e nas frases de síntese por caso de uso; o implementador consome toda a profundidade técnica. O documento é escrito uma vez — nunca em versões por audiência.

## Nomenclatura de arquivo

`docs/its/ITS-<story-id>-titulo-curto.md` (ou conforme sobrescrito pelo `docs/prime-config.md`). Uma ITS por story.

## Templates canônicos

Este contrato é dono de dois: `templates/its-template.md`, para a ITS, e `templates/adr-template.md`, para os registros que uma ITS referencia, cujas regras vivem junto à fronteira de decisão abaixo. Leia integralmente o que você está prestes a escrever ou validar.

As seções obrigatórias da ITS:

- **Metadados** — ID da story, resumo e um link resolvível para a story no tracker; casos de uso afetados com o cenário (criação | alteração); snapshot de configuração (stack e versões que o plano assume); ADRs referenciados, se houver; e a **verificação de rastreabilidade** (veja Regras de rastreabilidade). Escrita por último, junto com o sumário executivo. Esta seção carrega os fatos do documento e sua evidência de auditoria — as duas coisas dirigidas a leitores que não estão implementando.
- **Sumário executivo** — 3–5 linhas em linguagem de negócio: o que a story muda, em quais casos de uso e o efeito observável. A única seção que leitores que não implementam precisam ler. Escrita por último, depois de fechado o plano, para permanecer fiel.
- **O que muda no comportamento** — uma seção por caso de uso afetado, carregando apenas o que existe neste eixo: uma frase de síntese em linguagem de comportamento, o delta como **itens numerados** (`D1`, `D2`, ... — qualificados como `UC-NNN/D1` quando mais de um caso de uso é afetado) tirados da entrada do Histórico de revisões do caso de uso para esta story, e os pontos de regressão como **itens numerados** (`RG-1`, `RG-2`, ... — qualificados como `UC-NNN/RG-1` sob a mesma regra), somente em cenário de alteração. Nenhum mapeamento para arquivos aqui: o plano é dono do mapeamento único.
- **Plano de implementação** — a espinha do documento, escrita em ordem de execução. Uma unidade numerada por passo de trabalho, cada uma declarando: os arquivos que cria, modifica ou remove; o que fazer, com toda exigência citada escrita em linha; os itens de delta que atende (`UC-NNN/D1`) ou a consequência técnica que a justifica; e os testes que deve. Uma unidade que toca código compartilhado com um ponto de regressão declara o teste de não regressão que deve. O plano fecha com as alterações de esquema e migração, as fronteiras de fora de escopo, os riscos e pontos de atenção e os comandos de verificação do projeto.
- **Glossário de referência** — resolve todo identificador citado cuja definição vive em outro documento: `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN` e o `QM-XX-N` ou `CS-XX-N` que um desvio registrado cita. Para leitores sem esses documentos à mão, mais a tabela fixa de termos do processo. Itens de delta e pontos de regressão não precisam de entrada: este documento os define e eles se resolvem no próprio texto. Apenas metadados (ID + nome + uma linha) — nunca o conteúdo referenciado. Veja Regras de escrita.
- **Um eixo só.** O mapeamento de comportamento para código existe uma vez, no plano de implementação, no eixo em que o implementador trabalha: a ordem de execução. A seção de comportamento carrega o que o plano não pode — o delta e o que precisa continuar funcionando — e nada que o plano vá repetir. Duas seções descrevendo a mesma mudança em dois eixos obrigam o leitor a refazer uma fusão que o documento já fez, e a seção que ele pula é justamente a que não foi escrita no eixo dele.

## Nível de detalhe

- Toda mudança planejada nomeia arquivos ou componentes concretos. "Ajustar a camada de serviço" não é grau ITS; `OrderService.confirm(): adicionar validação de limite antes de persistir` é.
- A ITS instrui; não implementa. Sem listagens completas de código — trechos apenas quando uma assinatura, um contrato ou um esquema precisa ser fixado exatamente.
- Escreva para eliminar perguntas. A política de ambiguidade do implementador é devolver perguntas, não presumir — cada pergunta devolvida é um buraco na ITS. Isso vale identicamente para o dev humano e para o agente Friday: uma instrução que admite duas implementações é um defeito, não uma questão de estilo.
- Os testes são declarados por unidade do plano, não em um bloco de estratégia separado: cada unidade deve os testes derivados dos critérios de aceite que seus itens de delta tocam, mais a cobertura de não regressão de qualquer ponto de regressão que compartilhe código com ela. Todo ponto de regressão listado na seção de comportamento é reivindicado por exatamente uma unidade — um ponto de regressão sem dono é uma falha de rastreabilidade.

## Regras de escrita

As mesmas regras servem a todo leitor — humano ou agente. O que torna uma instrução inequívoca para um LLM é o que a torna verificável para um revisor e legível para compliance.

**Separação de registro — comportamento em prosa, código em tabelas.**
- A prosa (sumário executivo, frases de síntese, justificativa, riscos) usa linguagem de comportamento: "o sistema passa a rejeitar pedidos acima do limite de crédito". Sem nomes de classes na prosa, salvo se inevitável.
- Tabelas e listas técnicas (mapeamento, arquivos afetados, ordem de implementação) usam linguagem de código: caminhos exatos, assinaturas, identificadores. Sem vagueza em tabelas — se uma célula precisa de um parágrafo, o conteúdo pertence à prosa.

**Voz do autor — o documento instrui; não narra a própria produção.**
A ITS leva a assinatura do arquiteto e se lê como instrução dele. Um documento que narra deliberação convida a renegociar o que já foi decidido, e um hedge chega ao implementador como ambiguidade — que volta como pergunta, o vaivém que este contrato existe para evitar. A regra é uma lista fechada de marcas, não um estilo a imitar:

- Sem narração de como o plano foi produzido: o que foi inspecionado, buscado, considerado ou descartado pelo caminho.
- Sem autorreferência ao documento ou à sua redação.
- Sem hedge dentro de uma instrução ("provavelmente", "talvez", "sugere-se", "seria interessante"). A decisão está fechada quando a ITS é entregue.
- Sem seção preenchida por cerimônia. Havendo nada a declarar, a seção declara isso ("nenhuma identificada").
- Sem endereçamento a quem encomendou o plano ("conforme solicitado"). O leitor é o implementador.

Isso governa resíduo de processo, nunca a substância do plano: declarar por que um caminho foi escolhido é instrução e pertence ao documento. Tampouco é uma instrução para ocultar como o documento foi redigido — o arquiteto o aprova e o assina, e responder a essa pergunta com honestidade não é afetado por esta regra.

**Disciplina de frase.**
- Uma instrução por frase. Voz ativa, tempo presente. Frases compostas escondem instruções que o implementador pode perder e que o revisor não consegue conferir item a item.
- As referências são sempre resolvíveis no próprio lugar: `UC-042`, `RN-3`, `CA-2`, caminhos completos de arquivo. Nunca "a regra acima", "como discutido", "o ajuste de sempre" — dêixis e pressuposição são o principal ponto de falha tanto para agentes quanto para leitores que entram no meio do documento. O que não está na ITS ou em um ADR referenciado não existe para o leitor. Resolver o *endereço* é o piso; a regra abaixo diz o que a referência precisa carregar além disso.
- Todo critério é verificável: números, condições, regras nomeadas ("timeout de 30s conforme RN-5", nunca "um timeout adequado").
- Jargão e siglas do projeto são expandidos na primeira ocorrência por seção. O documento será lido fora do contexto da story.
- Quando mais de um caso de uso é afetado, qualifique todo identificador escopado a um caso de uso com esse caso de uso: `RN-N` e `CA-N`, que o documento possui, e `D1` e `RG-1`, que esta ITS atribui por caso de uso (`UC-042/RN-3`, `UC-042/RG-1`). Uma referência sem qualificação é ambígua no instante em que um segundo documento entra em jogo.

**Referências se resolvem em conteúdo, não só em endereço.**
Um identificador diz ao leitor qual documento guarda a resposta; não diz a resposta. Um implementador que conhece o código pesa o custo da consulta contra seu valor esperado e a pula — corretamente, diante de um identificador solto. Toda referência citada dentro de uma instrução, portanto, carrega, na mesma linha, a exigência que impõe a este plano; o identificador permanece como procedência para o revisor e para a auditoria.

- `OrderService.confirm — aplicar UC-042/RN-3` é um endereço. `OrderService.confirm — rejeitar quando o total do pedido exceder o limite de crédito vigente do cliente (UC-042/RN-3)` é uma instrução.
- O texto em linha é uma linha de *exigência*: a obrigação de uma regra, o resultado verificável de um critério de aceite, a restrição operacional de um ADR sobre este plano. Uma regra de negócio já é escrita como exigência — condição e resposta, na forma que o formato de caso de uso define —, e por isso a linha reproduz a condição e a resposta da regra, restritas ao que esta unidade implementa. Fora isso, nunca é o conteúdo da fonte — copiar um fluxo ou a justificativa de um ADR é duplicação e quebra o princípio de dono único.
- Onde a exigência não pode ser declarada em uma linha sem arrastar a justificativa junto, a referência está no lugar errado. Ou a decisão tem escopo de story — uma linha de alternativa descartada —, ou o documento-fonte é o que precisa de conserto. Resumir a justificativa dentro da ITS não é nenhuma das duas coisas.

A regra vale onde quer que uma instrução cite um identificador: todo campo de uma unidade do plano — o que fazer, os itens de delta que atende, os testes que deve — e as fronteiras de fora de escopo. Não se estende aos Metadados nem ao Glossário de referência, que são dirigidos a leitores que não estão implementando e cujos limites estão declarados em suas próprias regras.

**Referências autocontidas — o glossário.**
As referências são resolvíveis no repositório, mas o documento também é lido onde os documentos referenciados não existem (a plataforma de documentação da empresa). O Glossário de referência fecha essa lacuna:
- Uma tabela listando todo identificador citado: ID, tipo, nome e uma glosa de uma linha. Para casos de uso, o campo Nome; para regras de negócio e critérios de aceite, uma paráfrase de uma linha da intenção; para ADRs, o título, o status e uma paráfrase de uma linha da **Decisão** — o que foi decidido, nunca o porquê; para um critério de qualidade ou um slot de convenção, seu nome no catálogo e seu nível ou classe, nunca seu enunciado.
- A glosa do ADR para na decisão. Contexto, Consequências e alternativas consideradas permanecem no ADR: a justificativa é o que o registro existe para possuir, e copiá-la em toda ITS que o cita é a duplicação que esta regra previne. Quem precisa da justificativa vai ao ADR — a glosa diz se precisa.
- Como o resto do glossário, a glosa do ADR é um snapshot na entrega: declara a decisão como estava quando o plano fechou, e o campo de status diz se ela ainda vale.
- **Apenas metadados, nunca conteúdo.** O glossário resolve *o que o identificador é*, não *o que o documento diz* — copiar fluxos, regras na íntegra ou a justificativa de ADRs para o glossário é duplicação e quebra o princípio de dono único. Quem precisa do conteúdo vai à fonte; o glossário diz qual fonte.
- O glossário é um snapshot no momento da entrega, mesma disciplina do snapshot de configuração: quem escreve o preenche a partir dos documentos reais já carregados durante o planejamento, de modo que não custa nada e não pode ser inventado.
- A tabela fixa de termos do processo (ITS, UC, RN, CA, ADR, delta) acompanha o template como boilerplate — o leitor frio aprende o vocabulário sem sair da página.

**Escopo negativo explícito.**
O plano de implementação declara o que **não** deve mudar: uma linha por área intocável, com a razão e a cobertura de regressão que a protege ("Não modificar `PaymentService` — fluxo de estorno inalterado, coberto por testes de não regressão"). Para o implementador, é uma fronteira rígida ("tudo e nada além" exige bordas nomeadas); para o revisor, um checklist; para compliance, evidência de contenção de risco.

**Formatação pronta para publicação.**
A ITS precisa sobreviver ao copiar e colar na plataforma de documentação da empresa sem retrabalho — e essas restrições melhoram a legibilidade em qualquer lugar:
- No máximo 3 níveis de título e 2 níveis de aninhamento de lista.
- Apenas tabelas simples: sem células de várias linhas, sem HTML embutido, sem colunas mescladas.
- Blocos de código são simples e nunca aninhados; usados apenas onde o contrato permite trechos.
- Sem diagramas no corpo da ITS (os documentos de caso de uso são donos dos diagramas).

**Teste pré-entrega.** Antes de entregar, responda quatro perguntas sobre o documento pronto:
1. *Teste do implementador:* alguma instrução admite duas implementações diferentes? Se sim, é uma pergunta que o implementador devolverá — feche-a agora.
2. *Teste do leitor frio:* alguém que nunca viu a story — e sem acesso ao repositório de casos de uso — entende o sumário executivo e as frases de síntese, e resolve todo identificador citado pelo Glossário de referência, sem abrir outro documento?
3. *Teste da colagem:* colado na plataforma de documentação, tabelas e hierarquia de títulos sobrevivem?
4. *Teste do autor:* alguma frase descreve como o documento foi produzido em vez do que deve ser feito? Alguma instrução faz hedge de uma decisão que já está fechada?

Um documento que falha em qualquer um dos quatro não é entregável.

## Regras de rastreabilidade (bidirecional, por item de delta e unidade do plano)

A verificação vive nos **Metadados**, escrita por último com o sumário executivo. É evidência, não prosa: duas listas de identificadores mais as linhas de alternativa descartada. Seus leitores são o revisor e a auditoria — o implementador não depende dela para trabalhar, e é por isso que ela não fica no corpo.

- Delta → plano: todo item de delta (`UC-NNN/D1`) nomeia a unidade que o atende, ou carrega uma justificativa explícita de "já coberto".
- Plano → delta: toda unidade nomeia os itens de delta que atende, ou declara a consequência técnica que a justifica.
- Regressão → plano: todo ponto de regressão (`RG-N`) é reivindicado por exatamente uma unidade, que nomeia o teste de não regressão que deve.
- **Alternativa descartada:** quando uma unidade tinha mais de um caminho de implementação viável, uma linha declara a alternativa descartada e a razão decisiva. Sem alternativa viável → nada a declarar; é um registro de escolhas reais, não um campo de formulário.
- **Verificação de fronteira:** nenhuma decisão arquitetural embutida no corpo do documento — cada uma vive em um ADR referenciado.

Uma ITS que falha em qualquer um desses pontos não é entregável.

## Fronteira de decisão: ITS vs ADR

A ITS registra decisões que **morrem com a story** (escolhas entre caminhos de implementação equivalentes — capturadas pela regra da alternativa descartada acima). Decisões que **sobrevivem à story** não pertencem ao corpo da ITS; vão para um Architecture Decision Record (ADR), e a ITS apenas referencia o ID do ADR.

Uma decisão sobrevive à story quando pelo menos uma destas vale:
- ela restringe escolhas futuras de implementação (padrão, biblioteca, estilo de integração, estratégia de persistência);
- afeta mais de um caso de uso ou módulo;
- alguém que nunca leu esta ITS precisará da justificativa mais tarde.

O `templates/adr-template.md` é a estrutura canônica do ADR, de propriedade deste contrato pelo mesmo motivo que o template da ITS: um endereço, lido por quem redige e por quem valida. Leia-o integralmente antes de redigir ou aprovar um registro. A localização e a nomenclatura dos ADRs vêm do `docs/prime-config.md`, com padrão `docs/adr/ADR-NNN-titulo-curto.md`, sequencial e nunca renumerado. O its-generator detecta decisões candidatas e **propõe** o ADR; o arquiteto aprova antes de a ITS ser entregue. Uma ITS que embute uma decisão arquitetural em vez de referenciar um ADR não é entregável — mesma gravidade de uma falha de rastreabilidade. A detecção não é exclusiva do its-generator: qualquer skill da camada do arquiteto pode levantar que uma decisão é devida — a `feasibility-analysis` faz isso como uma `Condition:` quando uma demanda desafia uma decisão registrada. **A redação pertence ao ponto em que a decisão se torna concreta.** Um ADR é redigido pela skill cujo próprio entregável precisa se comprometer com a decisão, razão pela qual o its-generator é a única skill que redige um: é a única que precisa escrever um plano que a decisão vincula, unidade por unidade. Ele redige como `Proposed`; o arquiteto decide e aprova. Uma skill que julga ou mapeia não se compromete com nada, então levanta a questão e a roteia; nunca arquiva um ADR Proposed com base em uma análise cujos próprios artefatos vivem fora do repositório.

**O arquiteto nunca é bloqueado por essa regra.** Ela governa qual *skill* pode redigir, não se uma decisão pode ser registrada. Uma decisão tomada onde não existe plano para se comprometer com ela — em aconselhamento arquitetural, ou no refinamento antes de qualquer story — é redigida diretamente pelo arquiteto, contra este template e este ciclo de vida, e não precisa de story para existir. O que a regra proíbe é uma skill arquivar um registro com base em uma análise sobre a qual nunca teve de construir nada. Quem tomou a decisão é exatamente quem deve o registro, e uma decisão que vincula trabalho futuro enquanto espera uma story para carregá-la é a partida invisível que o `QM-MT-1` nomeia.

## Regras de consumo (para o implementador)

- A ITS é o escopo. Implemente toda ela e nada além — incluindo respeitar as fronteiras de fora de escopo declaradas no plano de implementação.
- Os ADRs referenciados são contexto vinculante: leia-os antes de implementar; nunca contradiga um ADR Accepted. Um conflito entre a ITS e um ADR é ambiguidade — devolva-o como pergunta.
- Ambiguidade, contradição ou detalhe ausente → não preencha a lacuna por suposição; devolva perguntas ao arquiteto referenciando a seção da ITS.
- Desvios descobertos durante a implementação (o plano não sobrevive ao contato com o código) → reporte; o arquiteto revisa a ITS. O documento permanece como fonte de verdade do que foi acordado. Cópias publicadas em outros lugares são visões; validar a divergência entre elas e o repositório é responsabilidade do arquiteto, não do implementador.

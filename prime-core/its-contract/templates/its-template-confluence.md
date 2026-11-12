# Template da ITS — Confluence

Template canônico de propriedade do its-contract para o formato de saída `Confluence`, um dos dois valores da opção `Template da ITS` na configuração do projeto. O formato `Markdown` tem o seu, `its-template-markdown.md`, com as mesmas seções, os mesmos campos e a mesma orientação: só a marcação muda, e uma mudança de conteúdo é feita nos dois. O its-generator lê só o template do formato do projeto, no passo em que escreve a ITS. Quem implementa e o code review leem a ITS pronta, nunca este arquivo: o documento entregue já tem a forma daqui. Veja o SKILL.md do its-contract para as regras de nível de detalhe, rastreabilidade e fronteira entre ITS e ADR, e o `references/writing-rules.md` dele para as regras de escrita.

**Idioma.** O bloco abaixo é o artefato e é escrito no idioma de documento deste formato: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis citados aqui — os identificadores do próprio documento (`D1`, `RG-1`), `ITS-<story-id>`, `ADR-NNN`, os níveis de criticidade (`efêmera`, `padrão`, `crítica`), caminhos de arquivo e identificadores de código — nunca são traduzidos. Cada token continua pertencendo ao contrato que o declara; esta nota apenas afirma que nenhum deles é traduzido.

**Marcação.** O bloco abaixo é escrito na marcação de wiki do Confluence, não em Markdown, e o documento inteiro usa só ela. O que o template usa:

| Elemento | Marcação |
|---|---|
| Título de seção | `h1.` a `h3.` no início da linha |
| Negrito | `*texto*` |
| Código em linha | `{{texto}}` |
| Lista numerada · subitem | `#` · `#*` |
| Lista com marcadores | `*` (asterisco e espaço) |
| Tabela | cabeçalho `\|\|A\|\|B\|\|`, linha `\|a\|b\|` |
| Bloco de código | `{code:language=java}` … `{code}`, cada um na própria linha |
| Link | `[url]` ou `[texto\|url]` |
| Escape de caractere especial | `\` antes dele: `\[`, `\{` |

Armadilhas que o documento precisa evitar:
- `#` no início da linha é lista numerada, nunca título.
- `[` abre um link e `{` abre uma macro: escape quando forem literais (`\[NON-NEGOTIABLE\]`).
- `-texto-` vira tachado e `_texto_` vira itálico quando delimitados por espaço; identificadores com sublinhado ficam dentro de `{{ }}`.
- Uma quebra de linha simples já é quebra no documento: cada parágrafo e cada item ocupa uma linha só.
- Uma linha em branco ou um bloco de código no meio de uma lista encerra a lista, e a seguinte recomeça do 1. Por isso os blocos de código ficam depois da lista, no campo Trechos fixados, e toda lista termina com uma linha em branco antes do campo seguinte.

Os trechos entre `<` e `>` são orientação de preenchimento e não ficam no documento entregue.

**Nível de detalhe.** O bloco abaixo mostra a unidade no nível `detalhista`, que tem todos os campos. A orientação de cada campo diz a partir de que nível ele existe e o que muda nele; um campo sem essa marca é igual nos três níveis (SKILL.md do its-contract, Nível de detalhe). Depois do bloco, a mesma unidade aparece escrita nos três. Sob o título, o documento leva a linha do seu nível, copiada inteira — é ela que diz a quem lê fora deste contrato o que o plano fixa e o que delega:

| Nível | Linha do documento |
|---|---|
| `simplificado` | `*Nível de detalhe:* simplificado — o plano fixa as exigências, as restrições, os contratos e os testes de cada unidade; os passos para chegar a eles, os arquivos e os nomes internos ficam a cargo de quem implementa, dentro das convenções do projeto.` |
| `médio` | `*Nível de detalhe:* médio — o plano fixa também a sequência de cada unidade, os pontos de integração com o código existente e os casos de borda a tratar; os passos dentro de cada componente ficam a cargo de quem implementa, dentro das convenções do projeto.` |
| `detalhista` | `*Nível de detalhe:* detalhista — o plano fixa o passo a passo de cada unidade, os arquivos a criar e a alterar, o comportamento esperado em cada caso de borda e como verificar cada unidade.` |

Restrições de formatação (das regras de escrita do contrato): no máximo 3 níveis de título, 2 níveis de aninhamento de lista, tabelas simples (sem células de várias linhas, sem HTML embutido), blocos de código simples, não aninhados e fora das listas, sem diagramas. O documento precisa sobreviver à inserção como marcação na plataforma de documentação da empresa sem alterações.

````text
h1. ITS-<story-id> — <Título da story>

<A linha do nível de detalhe do documento, copiada inteira da nota Nível de detalhe deste template.>

h2. Descrição
<Sumário executivo: 3 a 5 frases em linguagem de negócio, sem identificadores de código nem de outros documentos. O que a story muda, para quem e o efeito observável — numa story técnica, que nada muda para quem usa o sistema e o que a mudança interna garante. Escreva esta seção POR ÚLTIMO, depois de fechado o plano. É a porta de entrada para lideranças técnicas e compliance.>

h2. O que muda
<Uma subseção por área de comportamento afetada, nomeada pelo comportamento — nunca pelo identificador do documento de origem. Tudo por extenso: quem lê aqui não tem acesso aos casos de uso. Numeração contínua no documento inteiro: D1, D2, ... e RG-1, RG-2, ... nunca reiniciam por subseção. Nenhum mapeamento para código: o plano é dono dele. Numa story técnica, uma subseção só, nomeada pelo resultado técnico: a frase de síntese diz que o comportamento observável não muda, e cada D é o resultado técnico com a checagem que o prova — ex.: D1: nenhuma classe sob {{service/pedido}} depende de um adaptador; o teste de arquitetura passa com a contagem da migração zerada nesse escopo.>

h3. <Nome do comportamento — ex.: Confirmação de pedido>
<Uma frase em linguagem de comportamento: o que o sistema passa a fazer de diferente aqui.>

*Mudanças*
* *D1:* <a exigência inteira e verificável — condição, resposta do sistema e resultado observável. Ex.: Quando o total do pedido excede o limite de crédito vigente do cliente, o sistema recusa a confirmação com a mensagem "Limite de crédito excedido" e não grava o pedido.>
* *D2:* <...> — já atendido hoje: <por que nenhuma unidade é necessária, em uma linha. Somente quando o comportamento atual já cumpre o item.>

*Continua valendo* <somente quando o plano modifica código que já serve outro comportamento, em qualquer cenário: o que não muda mas compartilha código com as mudanças, venha do mesmo caso de uso ou de outro. Um ponto de outro caso de uso entra na subseção da mudança que toca o código compartilhado. Cada ponto é reivindicado por exatamente uma unidade do plano.>
* *RG-1:* <comportamento que precisa continuar funcionando, por extenso, com a condição em que vale — nunca "como hoje", que o leitor não tem como conferir. Ex.: Um pedido com total igual ou inferior ao limite de crédito vigente do cliente continua sendo confirmado e gravado.>
* *RG-2:* <ex., vindo de outro caso de uso: A consulta de pedidos em aberto continua listando os pedidos pendentes de aprovação.>

h2. Plano de implementação
<A espinha do documento, em ordem de execução. Quem implementa lê daqui até o fim sem sair do documento: toda exigência é escrita na instrução — a regra, o resultado esperado, a restrição de uma decisão registrada, a convenção do projeto como escolha concreta —, nunca apontada.>

*Premissas técnicas:* <stack e versões que o plano assume — ex.: Java 25 · Spring Boot 4.1 · PostgreSQL 17>
*Calibração:* <o nível de criticidade da demanda, com a razão em uma linha; uma demanda efêmera leva a condição de remoção; num projeto legado, a linha diz que o plano segue o padrão do código existente — ex.: crítica — altera a regra que libera crédito ao cliente · ex.: efêmera — campanha promocional, remover após 2026-12-15 · ex.: padrão · projeto legado: o plano segue o padrão do código existente>
*Ordem de entrega:* <somente quando um caso de uso que o plano lê tem a mudança de outra story ainda não entregue: a mudança que o plano presume já no código, ou não, por extenso — ex.: o plano presume entregue a recusa de pedidos acima do limite de crédito; implementar depois dela.>
*Decisões registradas:* <somente quando um ADR aprovado vincula o plano: o identificador, o título e as unidades que ele restringe; mais de um, separados por ·. É a única citação de um ADR no documento: a restrição em si é escrita como instrução nessas unidades, sem o identificador. Ex.: ADR-012 — Publicação de eventos de pedido pelo outbox — unidade 1>

h3. 1. <Título da unidade — o resultado que ela entrega, não a atividade. Ex.: Recusar a confirmação acima do limite de crédito>
*Executar antes de:* <somente numa ITS revisada, quando esta unidade foi acrescentada ao fim do plano mas precisa rodar antes de uma unidade existente: unidade N>
*Arquivos:* <a partir do nível médio; no simplificado o campo não existe. Médio: só os arquivos existentes que a unidade modifica ou remove — os pontos de integração. Detalhista: também os arquivos a criar, pelo caminho completo e com o nome, quando já definido.>
# {{<caminho/Arquivo.java>}} (modificar)
# {{<caminho/Novo.java>}} (criar)

*O que fazer:* <uma instrução por item, nesta ordem: o alvo exato em código em linha (arquivo, Classe.metodo(Tipo), endpoint ou coluna), o verbo de ação no infinitivo, a condição em que vale e o resultado verificável, com nomes, códigos e valores concretos. Um alvo com mais de uma instrução vira item com subitens, uma instrução por subitem. O nível de detalhe decide quantas instruções há, nunca a forma de cada uma. Simplificado: só as instruções que carregam uma exigência, uma restrição, um contrato ou uma decisão de qualidade. Médio: uma instrução por componente que a unidade cria ou altera, em ordem de execução, nomeando o ponto de integração com o código existente. Detalhista: também os passos dentro de cada componente, como subitens.>
# {{<alvo>}} — <instrução. Ex.: {{OrderController}} — mapear {{CREDIT_LIMIT_EXCEEDED}} para HTTP 422 com {{ErrorResponse(code, message)}} e a mensagem "Limite de crédito excedido".>
# {{<alvo>}} — <o momento ou a condição comum aos subitens. Ex.: {{ConfirmOrderService.confirm(ConfirmOrderCommand)}} — antes de {{saveOrderPort.save}}:>
#* <subinstrução. Ex.: comparar {{order.getTotal()}} com {{creditPolicy.availableLimit(customerId)}};>
#* <subinstrução. Ex.: quando o total for maior, lançar {{BusinessException}} com o código {{CREDIT_LIMIT_EXCEEDED}} e não gravar o pedido.>
# {{<alvo>}} — <restrição de uma decisão registrada, escrita como instrução. Ex.: {{ConfirmOrderService.confirm(ConfirmOrderCommand)}} — publicar {{PedidoConfirmado}} pela porta {{PublishOrderEventPort}}, cujo adaptador grava no outbox na mesma transação; nunca direto no broker.>
# {{<alvo>}} — <decisão de qualidade da story, com o valor concreto, uma por subitem. Ex.: {{CardNetworkClient.authorize(Payment)}} (criar) — seguir a forma de {{src/main/java/com/acme/app/adapter/out/http/AcquirerClient.java}}:>
#* <ex.: usar timeout de leitura de 15 s;>
#* <ex.: repetir no máximo 3 vezes, com espera de 200 ms, 400 ms e 800 ms, só em erro de conexão e em HTTP 503;>
#* <ex.: enviar a mesma chave de idempotência {{payment.id}} em todas as tentativas.>
# {{<alvo>}} — <instrução que depende de um trecho exato, apontando-o. Ex.: {{CreditPolicy}} (criar) — expor {{availableLimit}} com a assinatura de Trechos fixados.>

*Trechos fixados:* <somente quando uma assinatura, um contrato ou um esquema precisa ser fixado exatamente. Um bloco por trecho, precedido pela instrução que o exige, sempre depois da lista. Em language=, a linguagem do trecho: java, sql, json, ...>
Instrução <N> — <o que o trecho fixa. Ex.: assinatura de {{CreditPolicy.availableLimit}}>:
{code:language=java}
BigDecimal availableLimit(CustomerId customerId)
{code}

*Casos de borda:* <a partir do nível médio, e somente quando a unidade tem algum: a entrada ou o estado em que duas implementações razoáveis da instrução se comportariam de modo diferente. Médio: o caso, nomeado. Detalhista: o caso, o comportamento esperado e o item, o ponto de regressão ou a decisão de qualidade de que ele decorre — o campo nunca cria exigência.>
* <ex., médio: total do pedido igual ao limite>
* <ex., detalhista: total do pedido igual ao limite → o pedido é confirmado e gravado (RG-1)>

*Atende:* D1 <ou: consequência técnica — a justificativa em uma linha. Ex.: refatoração preparatória, sem mudança de comportamento; a suíte existente passa sem alteração>
*Testes:* <um por resultado observável dos itens que esta unidade atende, mais o teste de não regressão quando a unidade toca código compartilhado com um ponto de regressão. Cada teste declara o resultado que se observa, com os mesmos códigos e valores do item. A lista é a mesma nos três níveis.>
# <ex.: pedido com total acima do limite recebe HTTP 422 com o código {{CREDIT_LIMIT_EXCEEDED}} e a mensagem "Limite de crédito excedido", e nenhum pedido é gravado (D1)>
# <ex.: pedido com total igual ao limite é confirmado e gravado (RG-1)>

*Como verificar:* <somente no nível detalhista: o comando ou a checagem que prova que a unidade está pronta, tirado dos comandos de verificação do projeto e restrito à unidade, e o resultado esperado. O comando vai em código em linha, nunca em bloco. Ex.: executar {{./mvnw test -Dtest=ConfirmOrderServiceTest}}; os testes desta unidade passam.>

*Alternativa descartada:* <somente quando havia mais de um caminho viável: o caminho descartado e o motivo decisivo, em uma linha>

h3. 2. <Título da unidade>
<...>

h3. <N>. <Título da unidade> — sem efeito
<Somente numa ITS revisada, para uma unidade que deixou de se aplicar: ela mantém o número e o título, e o corpo vira a linha abaixo. Se ela já foi implementada, a unidade substituta diz o que fazer com o código que ela produziu.>
*Sem efeito:* substituída pela unidade <M>, que passa a atender <os itens que esta atendia — ex.: D2, D3>.

h3. Alterações de esquema / migrações
<A migração em si é uma unidade do plano: o arquivo em Arquivos e o esquema em Trechos fixados. Aqui ficam só a ordem em relação às outras unidades e ao deploy, a compatibilidade com a versão em produção e a carga ou correção de dados. Se nenhuma, "nenhuma".>

h3. Fora de escopo — não alterar
<Um item por área intocável: componente ou caminho, a razão e a cobertura de não regressão que a protege. Se nada estiver sob risco de alteração acidental, escreva "nenhuma identificada".>
* <ex.: Não modificar {{PaymentService}} — o fluxo de estorno depende do estado atual e não é tocado por esta story; coberto pela suíte de não regressão de estorno.>
* <ex., afastamento registrado: Não corrigir a captura genérica de exceção em {{LegacyInvoiceService.post}} — dívida herdada da área legada, fora do escopo desta story; revista na migração do módulo para {{billing.v2}}.>

h3. Riscos e pontos de atenção
<O que merece atenção sem um teste concreto a exigir, por extenso: partes alteradas com frequência, dependências de ambiente ou de dados, questões em aberto. Comportamento que divide código com a mudança não entra aqui: é ponto de regressão, em Continua valendo.>

h3. Verificação
<Comandos de build e teste, da configuração do projeto. Ex.:>
{code:language=bash}
./mvnw verify
{code}
````

## A mesma unidade nos três níveis

Exemplo da unidade que atende ao item `D1` do bloco acima. Só os campos que o nível muda aparecem em cada bloco; os que são iguais nos três aparecem uma vez, no fim. As exigências são as mesmas em todos: a condição da recusa, o código do erro, o HTTP 422, a assinatura fixada e os dois testes.

`simplificado` — só o que carrega exigência; sem Arquivos, sem Casos de borda, sem Como verificar:

````text
h3. 1. Recusar a confirmação acima do limite de crédito
*O que fazer:*
# {{CreditPolicy}} (criar) — expor {{availableLimit}} com a assinatura de Trechos fixados.
# {{ConfirmOrderService.confirm(ConfirmOrderCommand)}} — quando o total do pedido exceder {{creditPolicy.availableLimit(customerId)}}, lançar {{BusinessException}} com o código {{CREDIT_LIMIT_EXCEEDED}} e não gravar o pedido.
# {{OrderController}} — mapear {{CREDIT_LIMIT_EXCEEDED}} para HTTP 422 com {{ErrorResponse(code, message)}} e a mensagem "Limite de crédito excedido".
````

`médio` — a sequência por componente, os pontos de integração e os casos de borda nomeados:

````text
h3. 1. Recusar a confirmação acima do limite de crédito
*Arquivos:*
# {{src/main/java/com/acme/app/application/ConfirmOrderService.java}} (modificar)
# {{src/main/java/com/acme/app/adapter/in/web/OrderController.java}} (modificar)
# {{src/test/java/com/acme/app/application/ConfirmOrderServiceTest.java}} (modificar)

*O que fazer:*
# {{CreditPolicy}} (criar) — expor {{availableLimit}} com a assinatura de Trechos fixados, lendo o limite pela porta existente {{LoadCustomerCreditPort}}.
# {{ConfirmOrderService.confirm(ConfirmOrderCommand)}} — antes de {{saveOrderPort.save}}, quando o total do pedido exceder {{creditPolicy.availableLimit(customerId)}}, lançar {{BusinessException}} com o código {{CREDIT_LIMIT_EXCEEDED}} e não gravar o pedido.
# {{OrderController}} — mapear {{CREDIT_LIMIT_EXCEEDED}} para HTTP 422 com {{ErrorResponse(code, message)}} e a mensagem "Limite de crédito excedido", no tratador de {{BusinessException}} que o controlador já tem.

*Casos de borda:*
* total do pedido igual ao limite
* limite do cliente alterado depois da criação do pedido
````

`detalhista` — o passo a passo, todos os arquivos, o comportamento de cada caso de borda e a verificação:

````text
h3. 1. Recusar a confirmação acima do limite de crédito
*Arquivos:*
# {{src/main/java/com/acme/app/application/ConfirmOrderService.java}} (modificar)
# {{src/main/java/com/acme/app/adapter/in/web/OrderController.java}} (modificar)
# {{src/main/java/com/acme/app/domain/CreditPolicy.java}} (criar)
# {{src/test/java/com/acme/app/application/ConfirmOrderServiceTest.java}} (modificar)

*O que fazer:*
# {{CreditPolicy}} (criar) — expor {{availableLimit}} com a assinatura de Trechos fixados:
#* receber {{LoadCustomerCreditPort}} pelo construtor;
#* devolver o limite que {{LoadCustomerCreditPort.load(customerId)}} retorna.
# {{ConfirmOrderService}} — receber {{CreditPolicy}} pelo construtor.
# {{ConfirmOrderService.confirm(ConfirmOrderCommand)}} — antes de {{saveOrderPort.save}}:
#* comparar {{order.getTotal()}} com {{creditPolicy.availableLimit(customerId)}};
#* quando o total for maior, lançar {{BusinessException}} com o código {{CREDIT_LIMIT_EXCEEDED}} e não gravar o pedido.
# {{OrderController}} — no tratador de {{BusinessException}} que o controlador já tem, mapear {{CREDIT_LIMIT_EXCEEDED}} para HTTP 422 com {{ErrorResponse(code, message)}} e a mensagem "Limite de crédito excedido".

*Casos de borda:*
* total do pedido igual ao limite → o pedido é confirmado e gravado (RG-1)
* limite do cliente alterado depois da criação do pedido → vale o limite lido no momento da confirmação (D1)

*Como verificar:* executar {{./mvnw test -Dtest=ConfirmOrderServiceTest}}; os testes desta unidade passam.
````

Iguais nos três. No documento, cada campo ocupa a posição que o bloco principal mostra: Trechos fixados logo depois de O que fazer, Atende e Testes depois de Casos de borda, Como verificar depois de Testes.

````text
*Trechos fixados:*
Instrução 1 — assinatura de {{CreditPolicy.availableLimit}}:
{code:language=java}
BigDecimal availableLimit(CustomerId customerId)
{code}

*Atende:* D1
*Testes:*
# pedido com total acima do limite recebe HTTP 422 com o código {{CREDIT_LIMIT_EXCEEDED}} e a mensagem "Limite de crédito excedido", e nenhum pedido é gravado (D1)
# pedido com total igual ao limite é confirmado e gravado (RG-1)
````

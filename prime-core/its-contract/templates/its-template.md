# Template da ITS

Template canônico de propriedade do prime-core/its-contract. O arquiteto o escreve; o desenvolvedor implementa a partir dele; o code review valida contra ele. Veja o SKILL.md do its-contract para as regras de nível de detalhe, escrita, rastreabilidade e fronteira entre ITS e ADR.

**Idioma.** O bloco abaixo é o artefato e é escrito no idioma de documento deste formato: `pt-BR`. Os títulos de seção são traduzidos; os tokens estáveis citados aqui — os identificadores do próprio documento (`D1`, `RG-1`, `R1`), `ITS-<story-id>` e, somente na seção Referências, os identificadores das fontes (`S-NNN`, `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`, `QM-XX-N`, `CS-XX-N`), os valores de status de ADR (`Proposed`, `Accepted`, `Superseded by ADR-NNN`), os níveis e classes do catálogo, caminhos de arquivo e identificadores de código — nunca são traduzidos. Cada token continua pertencendo ao contrato que o declara; esta nota apenas afirma que nenhum deles é traduzido.

**Marcação.** O bloco abaixo é escrito na marcação de wiki do Confluence, não em Markdown — só a ITS; casos de uso e ADRs seguem em Markdown. O que o template usa:

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

Restrições de formatação (das regras de escrita do contrato): no máximo 3 níveis de título, 2 níveis de aninhamento de lista, tabelas simples (sem células de várias linhas, sem HTML embutido), blocos de código simples, não aninhados e fora das listas, sem diagramas. O documento precisa sobreviver à inserção como marcação na plataforma de documentação da empresa sem alterações.

````text
h1. ITS-<story-id> — <Título da story>

h2. Descrição
<Sumário executivo: 3–5 linhas em linguagem de negócio, sem identificadores de código nem de outros documentos. O que a story muda, para quem e o efeito observável. Escreva esta seção POR ÚLTIMO, depois de fechado o plano. É a porta de entrada para lideranças técnicas e compliance.>

h2. O que muda
<Uma subseção por área de comportamento afetada, nomeada pelo comportamento — nunca pelo identificador do documento de origem. Tudo por extenso: quem lê aqui não tem acesso aos casos de uso. Numeração contínua no documento inteiro: D1, D2, ... e RG-1, RG-2, ... nunca reiniciam por subseção. Nenhum mapeamento para código: o plano é dono dele.>

h3. <Nome do comportamento — ex.: Confirmação de pedido>
<Uma frase em linguagem de comportamento: o que o sistema passa a fazer de diferente aqui.>

*Mudanças*
* *D1:* <a exigência inteira e verificável — condição, resposta do sistema e resultado observável. Ex.: Quando o total do pedido excede o limite de crédito vigente do cliente, o sistema recusa a confirmação com a mensagem "Limite de crédito excedido" e não grava o pedido.>
* *D2:* <...> — já atendido hoje: <por que nenhuma unidade é necessária, em uma linha. Somente quando o comportamento atual já cumpre o item.>

*Continua valendo* <somente quando o plano modifica código que já serve outro comportamento, em qualquer cenário: o que não muda mas compartilha código com as mudanças, venha do mesmo caso de uso ou de outro. Um ponto de outro caso de uso entra na subseção da mudança que toca o código compartilhado. Cada ponto é reivindicado por exatamente uma unidade do plano.>
* *RG-1:* <comportamento que precisa continuar funcionando, por extenso. Ex.: Pedidos dentro do limite continuam sendo confirmados e gravados como hoje.>
* *RG-2:* <ex., vindo de outro caso de uso: A consulta de pedidos em aberto continua listando os pedidos pendentes de aprovação como hoje.>

h2. Plano de implementação
<A espinha do documento, em ordem de execução. Quem implementa lê daqui até o fim sem sair do documento: toda exigência é escrita na instrução — a regra, o resultado esperado, a restrição de uma decisão registrada, a convenção do projeto como escolha concreta —, nunca apontada.>

*Premissas técnicas:* <stack e versões que o plano assume — ex.: Java 11 · Spring Boot 2.7 · PostgreSQL 13>

h3. 1. <Título da unidade>
*Executar antes de:* <somente numa ITS revisada, quando esta unidade foi acrescentada ao fim do plano mas precisa rodar antes de uma unidade existente: unidade N>
*Arquivos:*
# {{<caminho/Arquivo.java>}} (modificar)
# {{<caminho/Novo.java>}} (criar)

*O que fazer:* <uma instrução por item, nesta ordem: o alvo exato em código em linha (arquivo, Classe.metodo(Tipo), endpoint ou coluna), o verbo no imperativo, a condição em que vale e o resultado verificável, com nomes, códigos e valores concretos. Um alvo com mais de uma instrução vira item com subitens, uma instrução por subitem.>
# {{<alvo>}} — <instrução. Ex.: {{OrderController}} — mapear {{CREDIT_LIMIT_EXCEEDED}} para HTTP 422 com {{ErrorResponse(code, message)}}.>
# {{<alvo>}} — <o momento ou a condição comum aos subitens. Ex.: {{OrderService.confirm(Order)}} — antes de {{orderRepository.save}}:>
#* <subinstrução. Ex.: comparar {{order.getTotal()}} com {{creditPolicy.availableLimit(customerId)}};>
#* <subinstrução. Ex.: quando o total for maior, lançar {{BusinessException}} com o código {{CREDIT_LIMIT_EXCEEDED}} e não gravar o pedido.>
# {{<alvo>}} — <restrição de uma decisão registrada, escrita como instrução. Ex.: {{OrderService.confirm(Order)}} — publicar {{PedidoConfirmado}} pelo outbox transacional, nunca direto no broker dentro da transação.>
# {{<alvo>}} — <instrução que depende de um trecho exato, apontando-o. Ex.: {{CreditPolicy}} (criar) — expor {{availableLimit}} com a assinatura de Trechos fixados.>

*Trechos fixados:* <somente quando uma assinatura, um contrato ou um esquema precisa ser fixado exatamente. Um bloco por trecho, precedido pela instrução que o exige, sempre depois da lista. Em language=, a linguagem do trecho: java, sql, json, ...>
Instrução <N> — <o que o trecho fixa. Ex.: assinatura de {{CreditPolicy.availableLimit}}>:
{code:language=java}
BigDecimal availableLimit(CustomerId customerId)
{code}

*Atende:* D1 <ou: consequência técnica — a justificativa em uma linha>
*Testes:* <um por resultado observável dos itens que esta unidade atende, mais o teste de não regressão quando a unidade toca código compartilhado com um ponto de regressão>
# <ex.: pedido acima do limite retorna erro de negócio e nada é gravado (D1)>
# <ex.: pedido dentro do limite continua sendo confirmado (RG-1)>

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

h3. Riscos e pontos de atenção
<O que merece atenção sem um teste concreto a exigir, por extenso: partes alteradas com frequência, dependências de ambiente ou de dados, questões em aberto. Comportamento que divide código com a mudança não entra aqui: é ponto de regressão, em Continua valendo.>

h3. Verificação
<Comandos de build e teste, da configuração do projeto. Ex.:>
{code:language=bash}
./mvnw verify
{code}

h2. Referências
<A procedência do documento. Nada aqui é necessário para executar o plano: o conteúdo já está no corpo, e o corpo não cita esta seção. Uma linha por documento de origem, R1 sempre a story. É a única seção em que identificadores de outros documentos aparecem. Usada em liga cada fonte aos itens e unidades em que entrou, com o elemento interno da fonte entre parênteses. Nunca glose nem resuma a fonte. Snapshot no momento da entrega, preenchido a partir dos documentos já abertos durante o planejamento.>
||Ref||Fonte||Usada em||
|R1|Story S-NNN — <resumo em uma linha> — [<url do item no tracker>]|todo o documento|
|R2|Caso de uso UC-NNN — <Nome> (alteração)|D1 (RN-3, CA-2) · D2 (extensão 4a) · RG-1 (passo 5)|
|R3|Caso de uso UC-NNN — <Nome> (regressão)|RG-2 (passo 2)|
|R4|ADR-NNN — <Título> (Accepted)|unidade 1|
|R5|Critério de qualidade QM-XX-N — <nome no catálogo> (\[NON-NEGOTIABLE\])|Fora de escopo — afastamento registrado|
````

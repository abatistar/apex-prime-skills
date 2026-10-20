# Regras de escrita da ITS

Parte do contrato do `prime-core/its-contract`, lida por quem escreve uma ITS — o its-generator, no passo em que escreve —, junto com o SKILL.md e o template. Quem só lê uma ITS — o revisor, quem implementa — não precisa deste arquivo: a ITS entregue já cumpre estas regras, e o SKILL.md diz como lê-la.

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
- **O que cada fonte entrega ao corpo.** Uma regra de negócio entra como sua condição e sua resposta, restritas ao que esta story precisa — já é escrita como exigência, na forma que o formato de caso de uso define. Um critério de aceite entra como o resultado verificável de um item e como o teste que a unidade deve. Um ADR entra como o que ficou decidido e o que isso exige deste plano, na unidade que ele vincula — nunca o contexto, a justificativa ou as alternativas, que permanecem no ADR. Um critério de qualidade ou um slot de convenção entra como a escolha concreta que impõe, ou como o afastamento que o plano registra por extenso: o que o plano deixa de fazer, onde, por quê e quando isso é revisto — a condição de saída que o registro de exceção do quality-model exige. O responsável pelo afastamento é quem assina a ITS.
- **O limite da cópia.** A ITS escreve o que esta story precisa, e só isso: as mudanças, o que continua valendo e as restrições que vinculam o plano. Nunca reproduz um fluxo inteiro, uma regra que o plano não toca, a justificativa de um ADR ou o enunciado de um critério. O caso de uso continua sendo a fonte viva do comportamento e o ADR o único dono da justificativa; a ITS é um derivado datado — um snapshot na entrega, como as premissas técnicas — e não compete com eles como fonte de verdade.
- Onde a exigência não pode ser escrita em uma ou duas linhas sem arrastar a justificativa junto, a fonte é que está no lugar errado. Ou a decisão tem escopo de story — uma linha de alternativa descartada —, ou o documento-fonte é o que precisa de conserto. Resumir a justificativa dentro da ITS não é nenhuma das duas coisas.

A regra vale no documento inteiro: Descrição, O que muda, todo campo de uma unidade do plano — o que fazer, o que atende, os testes que deve, a alternativa descartada — e as fronteiras de fora de escopo. A única seção fora dela é Referências, que existe justamente para guardar o que o corpo não carrega.

**Referências — a procedência, não o conteúdo.**
A seção Referências liga o documento às fontes de que foi derivado, para quem revisa, para a auditoria e para quem tem acesso aos repositórios. Ela não completa o corpo: um leitor que nunca a lê executa o mesmo plano.
- Uma tabela simples, `Ref · Fonte · Usada em`, com uma linha por documento de origem: a story, cada caso de uso — inclusive o que só fornece pontos de regressão —, cada outra story de cuja entrega o plano depende, cada ADR e cada critério de qualidade ou slot de convenção de que o plano se afasta por exceção registrada. A convenção que o plano apenas segue não entra: já está escrita como escolha concreta na instrução. Numere `R1`, `R2`, ... na ordem em que a fonte entra no documento; a story é sempre `R1`.
- **Fonte** identifica o documento por extenso: o tipo escrito por extenso ("Caso de uso", "ADR", "Critério de qualidade", "Slot de convenção"), o identificador, o nome ou título e o estado que a ITS assume — o cenário do caso de uso (criação, alteração, conformidade, retirada, ou regressão quando ele só fornece pontos de regressão), `dependência` para a outra story de cuja entrega o plano depende, o status do ADR, o nível do critério ou a classe do slot — e, para a story, o link resolvível para o item no tracker, montado pelo padrão que a configuração do projeto declara em Tracker — sem esse padrão, a linha leva só o identificador e a lacuna é reportada.
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
- Blocos de código são simples, nunca aninhados e nunca dentro de uma lista; usados apenas nos Trechos fixados de uma unidade e nos comandos de Verificação.
- Sem diagramas no corpo da ITS (os documentos de caso de uso são donos dos diagramas).

**Teste pré-entrega.** Antes de entregar, responda quatro perguntas sobre o documento pronto:
1. *Teste do implementador:* alguma instrução admite duas implementações diferentes? Se sim, é uma pergunta que o implementador devolverá — feche-a agora.
2. *Teste do leitor frio:* alguém que nunca viu a story — sem acesso aos casos de uso, aos ADRs nem aos catálogos do prime-core — entende o documento inteiro e consegue executar o plano sem abrir outro documento, exceto os padrões gerais do time, que são a base de quem implementa (veja Nível de detalhe)? Algum identificador de outro documento aparece fora de Referências?
3. *Teste da colagem:* inserido como marcação na plataforma de documentação, tabelas, hierarquia de títulos e numeração das listas sobrevivem?
4. *Teste do autor:* alguma frase descreve como o documento foi produzido em vez do que deve ser feito? Alguma instrução faz hedge de uma decisão que já está fechada?

Um documento que falha em qualquer um dos quatro não é entregável.

---
name: use-case-extractor
description: Faz engenharia reversa de casos de uso a partir do código existente - documenta o comportamento já implementado de um módulo, uma jornada, um conjunto de endpoints ou um fluxo. Use para "documente como X funciona hoje", "mapeie os casos de uso do módulo Y" e quando o its-generator reportar que falta o caso de uso de uma story de mudança. NÃO use para comportamento novo ou planejado (use-case-creator) nem para gerar uma ITS (its-generator).
---

# Use Case Extractor

Produz documentos de caso de uso que descrevem o comportamento **já implementado** na base de código, lendo o código — não inventando intenção. A saída popula o repositório de casos de uso do projeto, que o use-case-creator mantém e o its-generator consome.

Mentalidade central: o código diz o que o sistema *faz*, não o que ele *deveria fazer*. A intenção pode ter se perdido, e bugs podem ter sido consagrados como comportamento. Documente com fidelidade e confesse cada dúvida, para que um humano valide antes de o documento virar fonte de verdade.

O formato do documento NÃO é definido aqui — é de propriedade do **use-case** (template em `../use-case/references/use-case-template.md` e regras de consumo em `../use-case/references/consumer-rules.md`), incluindo os marcadores de incerteza de que esta skill depende. Leia-o por inteiro antes de escrever.

## Passo 0 — Carregar o formato de caso de uso

Carregue o formato do **use-case** por inteiro, incluindo as regras de qualidade e os marcadores.

A configuração do projeto não é lida aqui. Quando precisar de um fato dela, leia só a seção que o carrega do `docs/prime-config.md`, conforme as regras de consumo do **prime-config** (`../prime-config/references/consumer-rules.md`). Esta skill precisa de duas seções, ambas no Passo 2: **Estrutura**, como mapa do inventário de pontos de entrada, e **Repositório de documentos**, para achar os casos de uso já escritos. A **Stack** entra só quando o framework não é evidente no código que você abriu.

## Passo 1 — Delimitar o escopo com o usuário

Nunca mapeie "o sistema inteiro" em uma execução. Peça uma fatia delimitada: um módulo, uma jornada de usuário, um conjunto de endpoints. Com um escopo já indicado no pedido, confirme seu entendimento das fronteiras. Cada execução produz uma saída revisável — como regra prática, no máximo 3–5 documentos de caso de uso. Mais que isso, divida o trabalho em execuções e confirme cada fatia com o usuário.

## Passo 2 — Inventariar os pontos de entrada

Dentro do escopo, liste toda superfície de interação: rotas/controllers HTTP, consumidores de mensagens, jobs agendados, comandos de CLI, handlers de eventos. Leia a seção **Estrutura** da configuração para saber onde procurar — ela dá o pacote de cada elemento da arquitetura. Se o framework não for evidente no código que você abriu, leia também a **Stack**. Os pontos de entrada não são os candidatos: agrupe-os pelo objetivo do ator, conforme a Granularidade do formato. Cada objetivo é um caso de uso candidato, e cada ponto de entrada cabe num deles, como passo ou extensão. Um ponto técnico sem objetivo de ator (health check, rotina de manutenção) fica fora e é listado como tal. Apresente ao usuário o inventário agrupado — os objetivos e os pontos de entrada de cada um — e acorde quais candidatos viram documentos antes de escrever qualquer coisa.

Confira os candidatos contra o repositório de casos de uso. Para achá-lo, leia a seção **Repositório de documentos** da configuração: a raiz de documentos e a localização e a nomenclatura dos casos de uso. A forma do documento não vem da configuração — o template do formato é o único.

Um candidato que já tem caso de uso no repositório fica fora. Se o documento diverge do código, a rota é o use-case-creator (conformidade ou reconciliação), nunca um documento novo. A exceção é um delta pendente (formato, Ciclo de vida do status): não é divergência, e só é mencionado ao arquiteto, com o ID da story. Um candidato coberto por um documento `Retired` também fica fora: ou a retirada ainda não foi implementada, ou o código não a cumpriu — reporte ao arquiteto.

## Passo 3 — Reconstruir cada cenário a partir do código

Para cada candidato acordado, trace o caminho de execução e traduza o código para os elementos do template:

- Validações de entrada e guardas que o fluxo executa → **extensões** (tratamento de falha). Só vira **pré-condição** o que este fluxo não verifica porque já chega garantido — por outro caso de uso ou por um controle transversal anterior ao ponto de entrada, como o filtro de autenticação
- Ramificações de lógica de negócio → **passos do Cenário principal de sucesso**, **extensões** (alternativas) e **regras de negócio (RN-N)**
- Cada regra encontrada → o padrão da **Forma das regras de negócio** que a forma do código indica: cálculo, derivação ou constante → ubíquo; handler, consumidor ou listener → `Quando`; guarda sobre o estado de uma entidade → `Enquanto`; exceção, rejeição ou ramo de erro → `Se … então`, citada pela extensão que trata a falha; feature flag, configuração ou variante por tenant → `Onde`, com `[INFERRED]`, como todo comportamento decidido por configuração
- Efeitos persistidos, eventos emitidos, chamadas externas → **Garantias de sucesso**
- Efeitos que se mantêm mesmo quando a operação falha (logs de auditoria, rollbacks que não deixam estado parcial, compensações) → **Garantias mínimas**
- Tratamento de erros (exceções capturadas, respostas de erro, rollbacks) → **extensões** com seus desfechos definidos
- Verificações de autorização → **extensões** (permissão negada) quando o fluxo as executa; **pré-condição** quando são transversais e anteriores a ele
- Timeouts, limites de volume ou de paginação, janelas de execução, rotinas de expurgo → candidatos a **critério de aceite `não funcional`**, sempre com `[CONFIRM: ...]` perguntando se o valor é requisito ou restrição técnica — o código mostra o número, não por que ele existe

Envolvidos e Interesses são **opcionais**: o código raramente revela interesses de envolvidos. Preencha a seção só quando o material rastreado expuser um — uma trilha de auditoria de compliance implica o interesse de um regulador —, sempre marcado com `[INFERRED]`; caso contrário, omita-a.

Leia os testes existentes do código rastreado. Testes bem escritos são critérios de aceite quase prontos: rotule cada critério com o passo, a extensão ou a regra que o teste exercita. Eles muitas vezes revelam o comportamento pretendido com mais clareza que a implementação. Um teste que contradiz o código, ou que está desligado, é uma dúvida: marque-a com `[CONFIRM: ...]`.

## Passo 4 — Marcar toda incerteza

Esta é a disciplina crítica desta skill. Distinga o que você verificou do que deduziu, com os marcadores definidos no formato de caso de uso:

- `[INFERRED]` para o que você deduziu em vez de rastrear de ponta a ponta — despacho dinâmico, comportamento decidido por configuração ou por dados, reflexão, o efeito de uma integração cujo lado remoto não está no repositório. O que você rastreou no código é fato sobre o que o sistema faz, mesmo sem teste que o cubra: não o marque por falta de teste. Marcar o que foi rastreado dilui o marcador e transforma a validação numa conferência linha a linha.
- `[CONFIRM: pergunta]` para qualquer coisa que um humano precise decidir — números mágicos, ramificações ambíguas, comportamento suspeito que pode ser um bug (por exemplo, `[CONFIRM: no timeout do pagamento o pedido fica em PENDING para sempre — é intencional?]`).

Nunca normalize em silêncio um comportamento estranho numa regra limpa. Se o código faz algo estranho, documente o estranho e sinalize-o.

## Passo 5 — Escrever os documentos e passar para revisão

- Use o template do formato. Siga suas regras de qualidade e a convenção de nomenclatura de arquivo. Numere cada documento a partir do maior número de UC já usado no repositório + 1 — documentos `Retired` contam, e um número nunca é reaproveitado. Inclua o resumo gráfico em UML quando o caso de uso tem relações a mostrar, restrito a ele e às suas relações diretas; sem relações, omita a seção.
- Defina o Status como **Draft**.
- Primeira entrada do Histórico de revisões: `Rev 1 | mapeamento inicial a partir do código | data | resumo do escopo`.
- Preencha Casos de uso relacionados quando os cenários se referenciarem — entre documentos desta execução ou com documentos já existentes —, nos dois lados. Acrescentar o link recíproco a um documento existente é uma atualização derivada, sem entrada no histórico e sem mudança de Status.

Encerre a execução com a Lista de perguntas do formato: todos os marcadores pendentes, por documento, cada um com a recomendação e a evidência `arquivo:linha`. Declare explicitamente que os documentos só se tornam fonte de verdade (status "Reviewed") depois que um humano resolver os marcadores; a resolução passa pelo modo validação do use-case-creator, com as respostas do arquiteto. Não promova o status por conta própria: a edição só acontece por ordem explícita do arquiteto para aquele documento. Liste também os documentos existentes que receberam apenas o link recíproco em Casos de uso relacionados.

A passada operacional vive em `checklists/extraction-checklist.md`. Leia-a depois de escrever, para conferir antes de entregar — não no Passo 0. O template do próprio documento não: ele é de propriedade do `use-case` e é lido de lá.

## Saída

Um ou mais arquivos `UC-NNN-titulo-curto.md` no repositório de casos de uso configurado, cada um em status Draft e com marcadores de incerteza explícitos. Mais a lista de perguntas dos marcadores, por documento: é o que o arquiteto precisa responder antes de promovê-lo.

---
name: use-case-extractor
description: Faz engenharia reversa de documentos de caso de uso a partir de uma base de código existente, escrevendo contra o formato do prime-core/use-case. Skill da camada do arquiteto. Use sempre que o usuário quiser documentar comportamento já implementado mas sem documentação padronizada de caso de uso - mapeando um módulo, uma jornada de usuário, um conjunto de endpoints ou um único fluxo. Use também quando o its-generator reportar a ausência de um caso de uso para uma story de mudança, ou quando o usuário disser algo como "documente como X funciona hoje", "mapeie os casos de uso do módulo Y". NÃO use para escrever casos de uso de comportamento novo/planejado (use-case-creator) nem para gerar uma ITS (its-generator).
---

# Use Case Extractor (prime-architect)

Produz documentos de caso de uso que descrevem o comportamento **já implementado** na base de código, lendo o código — não inventando intenção. A saída popula o repositório de casos de uso do projeto, que o use-case-creator mantém e o its-generator consome.

Mentalidade central: o código diz o que o sistema *faz*, não o que ele *deveria fazer*. A intenção pode ter se perdido, e bugs podem ter sido consagrados como comportamento. Seu trabalho é documentar com fidelidade e confessar explicitamente cada dúvida, para que um humano valide antes de o documento virar fonte de verdade.

O formato do documento NÃO é definido aqui — é de propriedade do **prime-core/use-case** (template em `references/use-case-template.md` dentro dessa skill), incluindo os marcadores de incerteza dos quais esta skill depende. Leia-o integralmente antes de escrever.

## Passo 0 — Carregar a configuração do projeto e o formato do core

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência (explícito vence detectado), tratamento de divergências (configuração contradizendo o código) e o procedimento de bootstrap quando o arquivo está ausente vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa: a stack, a estrutura de pastas como mapa para o inventário de pontos de entrada, as convenções e as localizações do repositório de documentos. Em seguida carregue o formato do prime-core/use-case; se a configuração declarar um template customizado, ele tem precedência.

## Passo 1 — Delimitar o escopo com o usuário

Nunca mapeie "o sistema inteiro" em uma execução. Peça uma fatia delimitada: um módulo, uma jornada de usuário, um conjunto de endpoints. Se o usuário indicou um escopo no pedido, confirme seu entendimento das fronteiras. Cada execução deve produzir uma quantidade revisável de saída — como regra prática, não mais que 3–5 documentos de caso de uso por execução.

## Passo 2 — Inventariar os pontos de entrada

Dentro do escopo, liste toda superfície de interação: rotas/controllers HTTP, consumidores de mensagens, jobs agendados, comandos de CLI, handlers de eventos. Use a seção de estrutura da configuração para saber onde procurar. Cada ponto de entrada é um caso de uso candidato (ou um passo dentro de um). Apresente o inventário ao usuário e acorde quais candidatos viram documentos antes de escrever qualquer coisa.

## Passo 3 — Reconstruir cada cenário a partir do código

Para cada candidato acordado, trace o caminho de execução e traduza o código para os elementos do template:

- Validações de entrada e guardas → **pré-condições** e **extensões** (tratamento de falha)
- Ramificações de lógica de negócio → **passos do Cenário principal de sucesso**, **extensões** (alternativas) e **regras de negócio (RN-N)**
- Efeitos persistidos, eventos emitidos, chamadas externas → **Garantias de sucesso**
- Efeitos que se mantêm mesmo quando a operação falha (logs de auditoria, rollbacks que não deixam estado parcial, compensações) → **Garantias mínimas**
- Tratamento de erros (exceções capturadas, respostas de erro, rollbacks) → **extensões** com seus desfechos definidos
- Verificações de autorização → **pré-condições** ou **extensões** (permissão negada)

Envolvidos e Interesses é opcional: o código raramente revela interesses de envolvidos. Preencha-o apenas quando o material rastreado realmente expuser um (p. ex., uma trilha de auditoria de compliance implica o interesse de um regulador), sempre marcado com `[INFERRED]`; caso contrário, omita a seção.

Leia os testes existentes do código rastreado: testes bem escritos são critérios de aceite quase prontos e muitas vezes revelam o comportamento pretendido com mais clareza que a implementação.

## Passo 4 — Marcar toda incerteza

Esta é a disciplina crítica desta skill. Distinga o que você verificou do que você deduziu, usando os marcadores definidos no formato do core:

- `[INFERRED]` para comportamento deduzido da estrutura mas não confirmado por testes.
- `[CONFIRM: pergunta]` para qualquer coisa que um humano precise decidir — números mágicos, ramificações ambíguas, comportamento suspeito que pode ser um bug (p. ex., `[CONFIRM: no timeout do pagamento o pedido fica em PENDING para sempre — é intencional?]`).

Nunca normalize em silêncio um comportamento estranho transformando-o numa regra limpa. Se o código faz algo estranho, documente a coisa estranha e sinalize-a.

## Passo 5 — Escrever os documentos e passar para revisão

- Use o template do core. Siga suas regras de qualidade e a convenção de nomenclatura de arquivo; escolha o próximo número de UC livre. Inclua o resumo gráfico em UML restrito ao caso de uso e suas relações diretas.
- Defina o Status como **Draft**.
- Primeira entrada do Histórico de revisões: `Rev 1 | mapeamento inicial a partir do código | data | resumo do escopo`.
- Preencha Casos de uso relacionados quando cenários dentro da execução se referenciarem.

Encerre a execução listando, por documento: os marcadores de incerteza que precisam de resolução. Declare explicitamente que os documentos só se tornam fonte de verdade (status "Reviewed") depois que um humano resolver os marcadores. Não promova o status você mesmo.

## Saída

Um ou mais arquivos `UC-NNN-titulo-curto.md` no repositório de casos de uso configurado, cada um em status Draft com marcadores de incerteza explícitos, mais a lista de marcadores por documento que o arquiteto precisa resolver antes de promovê-lo.

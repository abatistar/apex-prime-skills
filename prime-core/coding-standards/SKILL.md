---
name: coding-standards
description: O contrato canônico das convenções concretas de código, de propriedade do prime-core - o catálogo de slots de convenção que todo projeto precisa ter decidido, os padrões do time por stack, as duas classes de aplicação (invariante vs convencional) e as regras para conviver com código legado e com migrações declaradas. Esta skill é dona das respostas concretas a que os critérios do prime-core/quality-model remetem; os valores específicos do projeto vivem no docs/prime-config.md e têm precedência. Consulte sempre que for planejar, escrever, revisar ou validar código, sempre que um critério de qualidade precisar de uma convenção concreta para ser verificável e sempre que uma mudança tocar uma área registrada como legado. Nunca duplique seu conteúdo em outro lugar - referencie os slots por ID.
---

# Padrões de Código (prime-core)

O `quality-model` responde *o que é bom*. Esta skill responde *como o bom se parece aqui* — as convenções concretas a que os critérios dele remetem. Onde o modelo diz "nomes não podem mentir" (`QM-RC-1`), esta skill diz qual nomenclatura carrega qual promessa; onde ele diz "o padrão local vence" (`QM-CN-2`), esta skill diz como uma área é classificada, em primeiro lugar, como território de padrão local.

A skill não guarda os valores de todos os projetos. Guarda três coisas:

1. **O catálogo de slots** (`references/convention-slots.md`) — a lista fechada de decisões que todo projeto precisa ter tomado, cada uma com um ID estável (`CS-XX-N`). Um slot é uma pergunta, não uma resposta.
2. **Os padrões do time** (`references/defaults-<stack>.md`) — a resposta que o time usa quando um projeto nada diz. Java é a stack padrão: `references/defaults-java.md`.
3. **As regras de engajamento** — classes de aplicação, tratamento de legado, disciplina de migração e como um desvio é feito.

Leia o catálogo de slots antes de planejar ou revisar código. Leia o arquivo de padrões da stack do projeto; onde o `docs/prime-config.md` declara um valor para um slot, esse valor vence.

## Fronteiras

- O **prime-core/quality-model** é dono dos princípios e do piso inegociável. Esta skill nunca repete um critério — ela referencia o `QM-XX-N` e fornece a forma concreta que o torna verificável.
- O **prime-core/prime-config** é dono dos valores do projeto: a seção *Convenções e restrições* guarda os overrides de slots e o registro de áreas legadas. A precedência é a do contrato da configuração: explícito vence detectado, a configuração sobrescreve padrões declarados, a configuração nunca dispensa uma regra do core.
- O **prime-core/its-contract** é dono das decisões que sobrevivem à story. Uma convenção adotada em todo o repositório é um ADR que então atualiza o valor de um slot — nunca uma preferência afirmada dentro de uma ITS.
- O **prime-architect/code-review** é dono do enforcement. Esta skill define a convenção; o revisor decide se uma dada mudança a cumpriu.

## Duas classes de aplicação

Todo slot é marcado como **INVARIANT** ou **CONVENTIONAL**, e a marca decide o que acontece quando o código ao redor discorda do padrão. Isso resolve a tensão entre o `QM-CN-2` (o padrão local vence a sua opinião) e a disciplina de exceção (cumpra o piso no que você escreve): ambos estão certos, sobre slots diferentes.

**INVARIANT** — vale para toda linha escrita ou alterada, independentemente do que a cerca. São os slots que levam um critério `[NON-NEGOTIABLE]` à forma concreta: erros engolidos, segredos vazados, entrada de fronteira não validada, queries não parametrizadas. Não existe "o padrão local aqui é engolir a exceção". O desvio só é possível como uma exceção nomeada e com responsável, conforme a disciplina do modelo de qualidade — nunca por herança.

**CONVENTIONAL** — o padrão local vence, sempre. Numa área escrita sob uma convenção mais antiga, seguir o padrão atual no seu fragmento introduz a segunda forma de fazer as coisas que o `QM-CN-1` proíbe. A consistência com o entorno é, ela mesma, o critério. O padrão atual chega ao código antigo por uma única via: uma migração declarada.

A consequência, dita às claras para que ninguém precise inferi-la: **código antigo continuar antigo é correto, não é dívida.** Dívida é o código antigo que uma migração declarada abandonou pela metade.

## Legado: o registro de áreas

A classificação é declarada, não julgada a cada pull request. O `docs/prime-config.md` registra cada área em um dos três estados abaixo, em *Convenções e restrições › Registro de áreas*. A forma dessa seção e seu exemplo trabalhado pertencem ao prime-core/prime-config e ao seu template; o que pertence aqui é o que os três estados significam.

- **current** — o padrão completo se aplica: slots invariantes e convencionais.
- **legacy-maintained** — os slots invariantes se aplicam ao que você escreve e altera; os slots convencionais seguem o padrão local. A área é corrigida, estendida e mantida normalmente.
- **strangler** — como acima, mais: nenhum comportamento novo. A capacidade nova nasce no módulo substituto. Nomeie o substituto e o ID da migração, ou o rótulo não significa nada.

Nunca infira esses estados de nomes de diretórios ou da idade dos arquivos. Uma área não registrada é `current`, e um projeto que precisa de um quarto estado está dizendo que o registro está errado, não a regra.

## Migrações declaradas

Uma migração é como o valor de um slot convencional muda para código que já existe. Carrega um **novo valor de slot, um responsável, um escopo e uma condição de conclusão**. Faltando qualquer um dos quatro, não é uma migração — é erosão com nome (`QM-CN-1`).

- Deliberada e em bloco, nunca oportunismo arquivo a arquivo. Automatizada onde a mudança for mecânica.
- O valor antigo continua válido dentro do escopo até a migração concluir; os dois valores estão corretos simultaneamente, e esta é a única situação em que isso é verdade.
- Uma migração que para de avançar é cancelada explicitamente e a área volta a `legacy-maintained`. Meio migrado é o pior estado; deixá-lo não declarado é pior do que reverter.

## Slots não preenchidos

Um slot sem valor — nem padrão da stack nem override da configuração — é uma **lacuna reportável**, não uma escolha livre. As skills consumidoras a expõem do jeito que o `prime-config` expõe uma seção obrigatória ausente: reportam e oferecem preencher, não improvisam um valor e não prosseguem em silêncio numa tarefa que dependa dele. O catálogo existe para que "ninguém nunca decidiu onde as transações começam" se torne visível em vez de virar trinta decisões inconsistentes.

## O sinal de saúde

A conformidade da base de código inteira é a medida errada: nunca chega a 100%, não é acionável e pune áreas que o registro já isentou. Um sinal faz o trabalho em seu lugar:

- **Conformidade por mudança.** Medida sobre o diff, nunca sobre o arquivo. Uma mudança é conforme quando cumpre todo slot invariante e o valor convencional aplicável à sua área. Binária, verificada no pull request — o que torna o legado irrelevante para a decisão de merge.

O sinal não aprova nem reprova nada por si só; o enforcement pertence ao `code-review`.

## Versionamento

A mesma disciplina do modelo de qualidade, pelo mesmo motivo — um desvio ou uma nota de melhoria precisa citar algo estável e datado.

- O catálogo de slots carrega uma versão; os **IDs dos slots são estáveis e nunca renumerados**. Um slot aposentado deixa seu ID aposentado.
- Mudar o *valor* de um slot em um arquivo de padrões é uma mudança normal. Adicionar, aposentar ou reclassificar um *slot* muda o contrato e passa pelo PR de governança revisado pelo dono do modelo de qualidade.
- A evolução é registrada pelo próprio PR de governança, no controle de versão. Esta skill não mantém histórico paralelo.

## Regras de consumo

**Para o `its-generator`** — carregue o catálogo de slots e os valores efetivos do projeto antes de planejar. O plano se conforma aos slots que governam as áreas tocadas: uma mudança que cai numa área `legacy-maintained` planeja contra o padrão local, e dizê-lo pertence à ITS (uma fronteira de fora de escopo ou uma linha de alternativa descartada), não à cabeça do implementador. Um slot de que o plano precisa e que não consegue resolver é uma lacuna a reportar, não a inventar.

**Para o `its-implementation`** — o valor efetivo para a área que você está tocando é o valor que você segue, e o registro de áreas diz qual. Cumpra todo slot invariante em código novo e alterado. Onde um invariante já é violado ao seu redor, nomeie-o como dívida herdada em vez de adotá-lo. Ambiguidade sobre qual valor se aplica é uma pergunta devolvida ao arquiteto, nunca uma suposição.

**Para o `code-review`** — os achados citam IDs de slots junto com IDs de critérios (`CS-ER-4` / `QM-EO-2`), de modo que a conversa seja sobre uma decisão versionada em vez do gosto de um revisor. Julgue slots convencionais contra o estado registrado da área, não contra o padrão atual. Um achado convencional numa área `legacy-maintained` só é válido se a mudança introduziu um *terceiro* padrão — nem local, nem atual.

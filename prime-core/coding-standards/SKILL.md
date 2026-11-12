---
name: coding-standards
description: O contrato das convenções concretas de código - o catálogo de slots (CS-XX-N), os padrões do time por stack, as classes invariante e convencional, o projeto legado e as migrações. Consulte ao planejar, escrever ou revisar código e quando um critério de qualidade precisar de uma convenção concreta; um desvio do projeto vive num ADR Accepted e tem precedência. Referencie os slots por ID, nunca os duplique.
---

# Padrões de Código

O `quality-model` responde *o que é bom*. Esta skill responde *como o bom se parece aqui* — as convenções concretas a que os critérios dele remetem. Onde o modelo diz "nenhuma espera sem limite" (`QM-RB-1`), esta skill diz qual é o timeout padrão e onde ele é configurado; onde ele diz "o padrão local vence" (`QM-CN-2`), esta skill diz quando o padrão local é a regra: no projeto que a configuração declara legado.

A skill não guarda os valores de todos os projetos. Guarda três coisas:

1. **O catálogo de slots** — o índice `references/convention-slots.md` e um arquivo por família em `references/convention-slots/` — a lista fechada de decisões que todo projeto precisa ter tomado, cada uma com um ID estável (`CS-XX-N`).
2. **Os padrões do time** — o índice `references/defaults-<stack>.md` e um arquivo por família em `references/defaults-<stack>/` — a resposta que o time usa quando um projeto nada diz, versionada. Java é a stack padrão: `references/defaults-java.md`.
3. **As regras de engajamento** — o que é um slot, as versões dos padrões e a evolução, neste arquivo; as classes de aplicação, o projeto legado, as migrações, os desvios do projeto, as lacunas, a verificação e como cada papel usa a skill em `references/consumer-rules.md`, a parte que as skills do fluxo leem sem este arquivo. Quem implementa lê os dois.

Os índices do catálogo e dos padrões são lidos sempre; o arquivo de uma família, quando um slot dela é citado ou aplicado.

## Fronteiras

- O **quality-model** é dono dos princípios, do piso inegociável, dos níveis de criticidade e dos gatilhos de especificação. Esta skill nunca repete um critério: cada slot declara a que critérios serve e fornece a forma concreta que os torna verificáveis.
- O **prime-config** é dono do arquivo do projeto, que guarda fatos: a stack, a Estrutura e a opção Legado, que esta skill lê. A configuração não carrega valor de slot nenhum. Um valor diferente do padrão do time é uma decisão, e vive num ADR Accepted (Desvios do projeto, em `references/consumer-rules.md`).
- O **adr-contract** é dono do registro das decisões que sobrevivem à story. Uma convenção que muda para o projeto inteiro é decidida num ADR, e é o ADR `Accepted` que carrega o valor.
- O **its-contract** é dono do formato da ITS. Nela, uma convenção chega como a escolha concreta, nunca como o ID do slot.
- O **code-review** é dono do enforcement. Esta skill define a convenção; o revisor decide se uma dada mudança a cumpriu.

## O que é um slot

Um slot é **uma pergunta que o projeto precisa ter respondido**, não uma resposta. Só existe onde há uma escolha real: uma exigência sem alternativa — liberar todo recurso adquirido, por exemplo — é um critério do `quality-model`, verificado por ferramenta, e não vira slot. E nenhum slot exige um padrão de projeto pelo nome: cada um declara o problema, e a solução sancionada é o valor.

No catálogo, cada slot declara:

- **classe** — INVARIANT ou CONVENTIONAL (Duas classes de aplicação, em `references/consumer-rules.md`);
- **serve a** — os critérios do `quality-model` que ele torna concretos;
- **verificação** — `ferramenta`, `teste` ou `revisão`;
- **aplica-se a** — `serviço` ou `cliente`.

Num arquivo de padrões ou num ADR do projeto, cada **valor** carrega:

- **o valor** — a resposta concreta;
- **a razão** — uma linha com a falha que o valor evita. Uma regra sem razão é folclore: não resiste à primeira discordância e não pode ser revista quando o contexto muda;
- **a verificação concreta** — a regra de ferramenta, o teste ou "revisão";
- **o exemplo canônico**, para valores convencionais — o caminho de um arquivo do projeto que mostra a forma certa. É código do projeto, localizado pela Estrutura da configuração, porque um padrão do time não conhece o código de ninguém. Quem implementa copia a forma, a ITS pode apontar para ele ("mesma forma de `PaymentClient`") e quem revisa compara.

"Não se aplica", com o motivo, é um valor válido. Um slot cujo tipo de componente o projeto não tem não precisa nem disso.

## Padrões do time: versionados pela release

Um arquivo de padrões é uma resposta compartilhada por todos os projetos que não decidiram outra. Se ele mudasse em silêncio, todos esses projetos mudariam de convenção de uma vez, e o código existente passaria a ser "o jeito antigo" sem nenhuma migração — a erosão do `QM-CN-1` em escala. Por isso:

- **A versão é a release.** Os arquivos de padrões não carregam número próprio: são versionados junto com o resto do Apex Prime, pela release — a tag — que o instalador usa e que o manifesto da instalação registra. Mudar um valor só chega aos projetos numa release nova. A release que vale é a instalada.
- **Subir a release é uma decisão do projeto.** A diferença dos arquivos de padrões entre as duas tags, no controle de versão, é a lista dos valores que mudaram, e para cada um a decisão diz o que acontece com o código existente:
  - num slot CONVENTIONAL, uma migração, ou um ADR que mantém no projeto o valor anterior;
  - num slot INVARIANT, sempre uma migração.

O ciclo de vida de um valor é sempre o mesmo, em três passos:

1. **A decisão.** Para o padrão do time, o PR de governança. Para o projeto, um ADR.
2. **O valor.** Uma release nova com o arquivo de padrões alterado, ou o valor que o ADR do projeto declara.
3. **O código existente.** Uma migração, declarada num ADR (Migrações, em `references/consumer-rules.md`).

Um valor decidido sem o terceiro passo é erosão anunciada.

## O sinal de saúde

A conformidade da base de código inteira é a medida errada: nunca chega a 100%, não é acionável e pune o código que um projeto legado ou uma migração em curso já isentou. Um sinal faz o trabalho em seu lugar:

- **Conformidade por mudança.** Medida sobre o diff, nunca sobre o arquivo. Uma mudança é conforme quando cumpre todo slot invariante e o valor convencional que vale no projeto. Binária, verificada no pull request — o que torna o legado irrelevante para a decisão de merge. É a forma concreta, para as convenções, do `QM-MT-6`.
- **A contagem de cada migração**, que só cai.

O sinal não aprova nem reprova nada por si só; o enforcement pertence ao `code-review`.

## Versionamento

A mesma disciplina do `quality-model`, pelo mesmo motivo: um desvio ou uma nota de melhoria precisa citar algo estável e datado.

- O catálogo de slots e os arquivos de padrões são versionados pela release do Apex Prime — a tag. Nenhum arquivo carrega número de versão próprio. Os **IDs dos slots são estáveis e nunca renumerados**; um slot aposentado mantém seu ID aposentado, listado no fim do catálogo.
- Acrescentar um slot ou mudar um valor de padrão muda a versão menor da release. Aposentar ou reclassificar um slot, ou mover conteúdo entre slots, muda a maior.
- Uma mudança no catálogo que altera um slot chega aos arquivos de padrões e ao mapa Critério → slots do índice no mesmo PR de governança.
- Toda mudança no catálogo ou num arquivo de padrões passa pelo PR de governança, revisado pelo dono do modelo de qualidade. Esse PR é o registro da evolução, no controle de versão; a skill não mantém histórico paralelo.

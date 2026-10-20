---
name: coding-standards
description: O contrato das convenções concretas de código - o catálogo de slots (CS-XX-N), os padrões do time por stack, as classes invariante e convencional, o legado e as migrações declaradas. Consulte ao planejar, escrever ou revisar código e quando um critério de qualidade precisar de uma convenção concreta; os valores do projeto, no docs/prime-config.md, têm precedência. Referencie os slots por ID, nunca os duplique.
---

# Padrões de Código (prime-core)

O `quality-model` responde *o que é bom*. Esta skill responde *como o bom se parece aqui* — as convenções concretas a que os critérios dele remetem. Onde o modelo diz "nenhuma espera sem limite" (`QM-RB-1`), esta skill diz qual é o timeout padrão e onde ele é configurado; onde ele diz "o padrão local vence" (`QM-CN-2`), esta skill diz como uma área é classificada, em primeiro lugar, como território de padrão local.

A skill não guarda os valores de todos os projetos. Guarda três coisas:

1. **O catálogo de slots** — o índice `references/convention-slots.md` e um arquivo por família em `references/convention-slots/` — a lista fechada de decisões que todo projeto precisa ter tomado, cada uma com um ID estável (`CS-XX-N`).
2. **Os padrões do time** — o índice `references/defaults-<stack>.md` e um arquivo por família em `references/defaults-<stack>/` — a resposta que o time usa quando um projeto nada diz, versionada. Java é a stack padrão: `references/defaults-java.md`.
3. **As regras de engajamento** — o que é um slot, as versões dos padrões e a evolução, neste arquivo; as classes de aplicação, o legado, as migrações, os overrides, as lacunas, a verificação e como cada papel usa a skill em `references/consumer-rules.md`, a parte que as skills do fluxo leem sem este arquivo. Quem implementa lê os dois.

Os índices do catálogo e dos padrões são lidos sempre; o arquivo de uma família, quando um slot dela é citado ou aplicado.

## Fronteiras

- O **prime-core/quality-model** é dono dos princípios, do piso inegociável, dos níveis de criticidade e dos gatilhos de especificação. Esta skill nunca repete um critério: cada slot declara a que critérios serve e fornece a forma concreta que os torna verificáveis.
- O **prime-core/prime-config** é dono do arquivo do projeto: onde ficam os overrides, o registro de áreas, a release fixada, os exemplos canônicos e as exclusões. A precedência é a do contrato da configuração: explícito vence detectado, a configuração sobrescreve padrões declarados, a configuração nunca dispensa uma regra do core.
- O **prime-core/its-contract** é dono das decisões que sobrevivem à story e do formato da ITS. Uma convenção que muda para o projeto inteiro é decidida num ADR antes de virar valor de slot; na ITS, uma convenção chega como a escolha concreta, nunca como o ID do slot.
- O **prime-architect/code-review** é dono do enforcement. Esta skill define a convenção; o revisor decide se uma dada mudança a cumpriu.

## O que é um slot

Um slot é **uma pergunta que o projeto precisa ter respondido**, não uma resposta. Só existe onde há uma escolha real: uma exigência sem alternativa — liberar todo recurso adquirido, por exemplo — é um critério do `quality-model`, verificado por ferramenta, e não vira slot. E nenhum slot exige um padrão de projeto pelo nome: cada um declara o problema, e a solução sancionada é o valor.

No catálogo, cada slot declara:

- **classe** — INVARIANT ou CONVENTIONAL (Duas classes de aplicação, em `references/consumer-rules.md`);
- **serve a** — os critérios do `quality-model` que ele torna concretos;
- **verificação** — `ferramenta`, `teste` ou `revisão`;
- **aplica-se a** — `serviço` ou `cliente`.

Num arquivo de padrões ou na configuração, cada **valor** carrega:

- **o valor** — a resposta concreta;
- **a razão** — uma linha com a falha que o valor evita. Uma regra sem razão é folclore: não resiste à primeira discordância e não pode ser revista quando o contexto muda;
- **a verificação concreta** — a regra de ferramenta, o teste ou "revisão";
- **o exemplo canônico**, para valores convencionais — o caminho de um arquivo do projeto que mostra a forma certa. É declarado pelo projeto, porque um padrão do time não conhece o código de ninguém. Quem implementa copia a forma, a ITS pode apontar para ele ("mesma forma de `PaymentClient`") e quem revisa compara.

"Não se aplica", com o motivo, é um valor válido. Um slot cujo tipo de componente o projeto não tem não precisa nem disso.

## Padrões do time: versionados e fixados

Um arquivo de padrões é uma resposta compartilhada por todos os projetos que não a sobrescrevem. Se ele mudasse em silêncio, todos esses projetos mudariam de convenção de uma vez, e o código existente passaria a ser "o jeito antigo" sem nenhuma migração — a erosão do `QM-CN-1` em escala. Por isso:

- **A versão é a release.** Os arquivos de padrões não carregam número próprio: são versionados junto com o resto do Apex Prime, pela release — a tag — que o instalador usa e que o manifesto da instalação registra. Mudar um valor só chega aos projetos numa release nova; a anterior continua válida para quem a fixou.
- **O projeto fixa a release que segue** na configuração. Sem release fixada, vale a instalada, e a ausência da fixação é uma lacuna a reportar. Uma release instalada diferente da fixada é uma divergência, tratada como o `prime-core/prime-config` trata a configuração que contradiz o código: reportada, nunca resolvida em silêncio. A fixação importa sobretudo quando as skills são instaladas no perfil do usuário e servem a vários projetos ao mesmo tempo; um projeto que as instala no próprio repositório fixa a release também pelo que commita.
- **Subir a release é uma decisão do projeto.** A diferença dos arquivos de padrões entre as duas tags, no controle de versão, é a lista dos valores que mudaram, e para cada um a decisão diz o que acontece com o código existente:
  - num slot CONVENTIONAL, uma migração declarada, ou as áreas afetadas registradas como `legacy-maintained`;
  - num slot INVARIANT, sempre uma migração declarada.

O ciclo de vida de um valor é sempre o mesmo, em três passos:

1. **A decisão.** Para o padrão do time, o PR de governança. Para o projeto, um ADR quando a mudança alcança código que já existe.
2. **O valor.** Uma release nova com o arquivo de padrões alterado, ou o override na configuração.
3. **O código existente.** Uma migração declarada, ou o registro de áreas.

Um valor decidido sem o terceiro passo é erosão anunciada.

## O sinal de saúde

A conformidade da base de código inteira é a medida errada: nunca chega a 100%, não é acionável e pune áreas que o registro já isentou. Um sinal faz o trabalho em seu lugar:

- **Conformidade por mudança.** Medida sobre o diff, nunca sobre o arquivo. Uma mudança é conforme quando cumpre todo slot invariante e o valor convencional aplicável à sua área. Binária, verificada no pull request — o que torna o legado irrelevante para a decisão de merge. É a forma concreta, para as convenções, do `QM-MT-6`.
- **A contagem de cada migração**, que só cai.

O sinal não aprova nem reprova nada por si só; o enforcement pertence ao `code-review`.

## Versionamento

A mesma disciplina do `quality-model`, pelo mesmo motivo: um desvio ou uma nota de melhoria precisa citar algo estável e datado.

- O catálogo de slots e os arquivos de padrões são versionados pela release do Apex Prime — a tag. Nenhum arquivo carrega número de versão próprio. Os **IDs dos slots são estáveis e nunca renumerados**; um slot aposentado mantém seu ID aposentado, listado no fim do catálogo.
- Acrescentar um slot ou mudar um valor de padrão muda a versão menor da release. Aposentar ou reclassificar um slot, ou mover conteúdo entre slots, muda a maior.
- Uma mudança no catálogo que altera um slot chega aos arquivos de padrões e ao mapa Critério → slots do índice no mesmo PR de governança.
- Toda mudança no catálogo ou num arquivo de padrões passa pelo PR de governança, revisado pelo dono do modelo de qualidade. Esse PR é o registro da evolução, no controle de versão; a skill não mantém histórico paralelo.

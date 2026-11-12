---
name: adr-generator
description: Redige um ADR (Architecture Decision Record) - o registro de uma decisão de arquitetura que sobrevive à story -, entrega-o como Proposed e o conduz até a palavra do arquiteto, escrito contra o adr-contract. Use para "registre esta decisão", "escreva o ADR sobre X", "ajuste o ADR-012", e quando o its-generator parar numa decisão de arquitetura e o arquiteto aceitar a proposta de ADR. NÃO use para escrever ou continuar uma ITS (its-generator), para registrar uma regra de negócio (use-case-creator) nem para julgar se uma demanda cabe no sistema (feasibility-analysis).
---

# ADR Generator

Redige um ADR por decisão e o conduz até a palavra do arquiteto: aprovado, ajustado ou recusado. O formato do ADR NÃO é definido aqui — é de propriedade do **adr-contract** (o SKILL.md entra no Passo 0; o template, no Passo 3). Esta skill define o *processo*.

A skill roda sozinha. Quem a invoca é o arquiteto, com uma decisão para registrar, ou o its-generator, quando a geração de uma ITS para numa decisão de arquitetura e o arquiteto aceita a proposta. O resultado é o mesmo documento nos dois casos, e esta skill nunca escreve nem continua uma ITS.

Disciplina central: **o arquiteto decide; esta skill redige**. Ela recomenda um caminho e mostra o custo de cada um, mas não inicia um registro que ele não pediu, não presume a aprovação e não muda um status sem ordem dele.

## Passo 0 — Carregar a configuração e o contrato

Leia, do `docs/prime-config.md`, a seção Repositório de documentos — a localização e a nomenclatura dos ADRs —, conforme as regras de consumo do **prime-config** (`../prime-config/references/consumer-rules.md`). Carregue o **adr-contract** (`../adr-contract/SKILL.md`): a fronteira que diz quando uma decisão merece um ADR, o ciclo de vida do status e quem redige e quem aprova.

## Passo 1 — Receber a decisão

Para redigir, a skill precisa de quatro coisas:

- **A decisão** — o que está sendo decidido, em uma frase.
- **Os caminhos em jogo** — os que foram considerados e, quando houver, o que o arquiteto escolheu ou o que quem invoca recomenda.
- **A origem** — `ITS-<story-id>`, quando a decisão vem da geração de uma ITS; `demanda em refinamento` ou `aconselhamento arquitetural`, quando vem direto do arquiteto.
- **A evidência** — o que se sabe do código e das restrições que pesam na escolha.

Invocada pelo its-generator, a skill recebe as quatro nos argumentos da invocação e redige a partir deles, nunca da conversa da ITS: o registro tem de se entender sem ela (Passo 4). Invocada pelo arquiteto, pergunte só o que faltar da decisão e dos caminhos; a evidência a skill reúne no Passo 3. Nunca colete requisitos: o registro é de uma decisão, não de uma demanda.

Um pedido de ajuste sobre um registro `Proposed` que já existe ("ajuste o ADR-012") entra direto no Passo 6.

## Passo 2 — Conferir que é um ADR, e um só

- **Passe a decisão pela fronteira do contrato** (adr-contract, Quando uma decisão merece um ADR). Uma regra de negócio não é ADR: diga isso e roteie ao use-case-creator, sem redigir. Uma decisão de arquitetura que não atende a nenhum dos três critérios é detalhe de implementação: diga isso uma vez, com a razão, e redija só se o arquiteto mantiver o pedido — a palavra é dele. Uma decisão que chega do its-generator com a proposta aceita já passou por essa conferência com o arquiteto, e ela não é rediscutida.
- **Examine o repositório de ADRs** antes de numerar:
  - um `Proposed` sobre a mesma decisão → não abra outro; ajuste aquele (Passo 6);
  - um `Accepted` que a decisão contradiz ou troca → o registro novo o substitui, e o campo Substitui o nomeia;
  - um `Rejected` sobre a mesma decisão → mostre ao arquiteto a razão daquela recusa antes de redigir. A proposta nova é um registro novo, com número novo.
- **Mais de uma decisão no pedido** → um registro por decisão, cada um com o seu ciclo.

## Passo 3 — Redigir o registro

Leia o template (`../adr-contract/templates/adr-template.md`) integralmente e redija o registro conforme ele, na localização que a configuração declara, com o próximo número livre do repositório.

- Status `Proposed` e a Origem recebida no Passo 1. Quando a origem é uma ITS, é a Origem que liga o registro à story: o its-generator encontra por ela o registro de que a geração depende.
- **Alternativas reais.** Cada alternativa é um caminho que o sistema comporta, com o motivo decisivo do descarte. Confira cada uma contra o que a decisão alcança — a Stack e a Estrutura da configuração, os ADRs `Accepted`, o código do Escopo —, lendo o suficiente para escrever alternativas e custos verdadeiros, e nada além do Escopo. Invocada pelo its-generator, a evidência já vem da inspeção dele: use-a, e leia o código só onde ela não cobre uma alternativa. Um caminho que a stack ou um ADR `Accepted` já impede não entra como alternativa viável.
- **Consequências com custo.** Os ganhos, os custos e o que a decisão passa a impedir.
- **Decisão e Vincula na voz de quem instrui.** A obrigação concreta que a decisão impõe a quem planeja e a quem implementa. São as partes que um plano reproduz, e por isso não levam hedge nem justificativa.
- **O caminho da Decisão** é o que o arquiteto escolheu. Sem escolha dele, é o recomendado, e a entrega diz que é uma recomendação: a escolha se fecha na aprovação ou num ajuste.

## Passo 4 — Conferir o registro antes de entregar

- Uma decisão só, e ela passa pela fronteira do contrato.
- Toda seção do template preenchida; campo sem valor diz isso ("nenhum", "sem gatilho previsto").
- Ao menos uma alternativa viável descartada, com motivo decisivo e não preferência.
- Custos declarados, e não só ganhos.
- O Vincula é uma obrigação que um plano consegue escrever como instrução.
- Nenhuma contradição com um ADR `Accepted` sem o campo Substitui.
- O registro se entende sem a ITS, a story ou a conversa de onde veio: além da Origem, nenhum identificador de ITS.

## Passo 5 — Entregar e esperar

Entregue o registro ao arquiteto com o caminho do arquivo, a decisão em uma frase, se o caminho é escolha dele ou recomendação, e o que ele pode responder: aprovar, pedir ajustes ou recusar. Depois, pare.

Esta parada é intencional. Um ADR `Proposed` não vincula ninguém, e o que depende dele — a ITS de origem, quando há uma — fica parado até a decisão. Enquanto o registro estiver `Proposed`:

- não presuma a aprovação, por mais provável que pareça, e não mude o Status por conta própria;
- não escreva, não continue e não adiante nenhuma ITS;
- responda ao que o arquiteto perguntar sobre o registro. Responder não é aprovar.

**O que é aprovação.** Uma ordem explícita do arquiteto para aquele registro: "aprove o ADR-012", "ADR-012 aprovado". Com um único registro à espera, vale a resposta que o aprova sem nomeá-lo ("aprovado", "pode aceitar"); com mais de um, pergunte qual. Não é aprovação: o silêncio, um comentário sobre o conteúdo, um pedido de ajuste, nem uma ordem genérica de continuar ("segue", "continue a ITS"). Diante de uma ordem genérica, diga que o registro espera a decisão dele e pergunte qual é ela. Aplicar uma ordem ambígua como aprovação é tomar a decisão de arquitetura no lugar de quem a detém.

A parada sobrevive à sessão: o registro `Proposed` no repositório é a marca dela.

## Passo 6 — Ajustar

Pedido de ajuste → revise o registro no lugar, com o mesmo número e ainda `Proposed`, entregue de novo dizendo o que mudou e volte a esperar. Um ajuste nunca traz a aprovação embutida, mesmo quando o pedido soa final ("troque X e pode seguir"): o arquiteto aprova o texto revisado, que ainda não viu. O ciclo se repete quantas vezes ele pedir.

Só um registro `Proposed` é ajustado. Mudar uma decisão `Accepted` é uma decisão nova: um registro novo, que substitui o anterior.

## Passo 7 — Aplicar a decisão do arquiteto

- **Aprovação** → edite o Status para `Accepted`. Quando o registro substitui outro, edite o do substituído para `Superseded by ADR-NNN` na mesma ordem.
- **Recusa** → edite o Status para `Rejected`, com a razão do arquiteto em uma linha na própria célula. O registro fica no lugar e o número não volta a ser usado.

Nos dois casos, a edição só acontece com a ordem explícita dele para aquele registro (adr-contract, Ciclo de vida do status).

## Saída

Um arquivo de ADR por decisão, na localização configurada, e, depois da palavra do arquiteto, o status que ela definiu.

Quando a Origem é uma ITS, feche dizendo o que acontece com ela: a geração parou à espera deste registro e, com ele decidido — aprovado ou recusado —, **recomeça do início** pelo its-generator, que revalida o plano contra a decisão. Devolva o controle a ele; esta skill não retoma a ITS de onde parou nem escreve parte dela.

## Fronteiras

- Nenhuma ITS, caso de uso ou arquivo de configuração escrito ou editado; nenhum código de aplicação.
- Nenhum registro iniciado sem a palavra do arquiteto, e nenhum status movido sem ordem dele.
- Nenhuma decisão tomada pelo arquiteto: a skill recomenda, mostra o custo e redige.

A passada operacional vive em `checklists/adr-checklist.md`. Leia-a no Passo 4, para conferir o registro antes de entregar.

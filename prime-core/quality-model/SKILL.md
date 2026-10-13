---
name: quality-model
description: O modelo de qualidade canônico de propriedade do prime-core - a definição versionada do que "alta qualidade" significa para este time, mais seus inegociáveis e sua disciplina de exceção. É uma definição e uma referência compartilhadas, não um gate de enforcement - o código novo é construído contra ele, e o its-generator e o its-implementation o referenciam para questionar os artefatos que entregam e apontar melhorias. O enforcement (achados precisos, aprovar/reprovar um PR) pertence ao code-review. Declara a fronteira com o coding-standards (as convenções concretas vivem lá) e com o its-contract (os ADRs vivem lá). Nunca duplique seus critérios em outro lugar - referencie-os por ID.
---

# Modelo de Qualidade (prime-core)

Esta skill é dona da definição de qualidade do time. Tem um endereço e um dono; toda outra skill a referencia pelo ID do critério em vez de repeti-la, de modo que o padrão contra o qual o código novo é construído e o padrão usado para questionar um entregável sejam o mesmo padrão, na mesma versão. Uma mudança aqui atualiza todos de uma vez.

## Uma definição, oito lentes

Qualidade não é uma soma de propriedades que se marcam em uma lista. É uma única propriedade — **o sistema é seguro, previsível e barato de mudar ao longo do tempo** — observada de oito ângulos: legibilidade (a propriedade vista por quem lê), testes (vista por quem muda), acoplamento e coesão (vistos pela estrutura), consistência (vista pelo time), tratamento de erros e observabilidade (vistos sob falha), manutenibilidade (vista ao longo do tempo), documentação (vista pela transferência de conhecimento) e segurança e robustez (vistas sob um adversário). Sobem e descem juntas porque são sintomas da mesma causa de fundo: o sistema foi cortado nas juntas certas e essa clareza foi mantida contra a entropia do tempo.

Duas consequências decorrem disso, e moldam como este modelo é usado:

- O núcleo da qualidade é **irredutivelmente julgamento** — onde traçar fronteiras, o que abstrair em vez de duplicar, que dívida assumir, quanto cuidado um dado trecho de código merece. Esta skill **estrutura** esse julgamento; não o substitui. Um modelo que fingisse eliminar o julgamento trairia aquilo que mede.
- Toda dimensão tem um **pecado capital** e uma **tensão honesta**. Os pecados capitais são as poucas falhas quase nunca aceitáveis — os inegociáveis. A tensão é que **o excesso é tão danoso quanto a deficiência**: a virtude nunca é maximizar uma dimensão, é calibrá-la ao contexto. Aplicar um critério sem considerar a vida útil esperada e a importância do código é aplicar mal este modelo.

## Uma definição, não um veredito

Este modelo define o **alvo**. É a base contra a qual o código novo é construído e a referência que o `its-generator` e o `its-implementation` usam para interrogar os artefatos que entregam — uma ITS, uma implementação, uma estratégia de testes — e apontar onde podem ser melhores. Ele não aprova nem reprova nada por si só.

Transformar o modelo em achados precisos e numa recomendação de aprovar/reprovar um pull request é um trabalho distinto, de propriedade do `prime-architect/code-review`. Mantenha os dois separados: esta skill responde *o que é bom*; o revisor responde *esta mudança em particular superou a régua, dado o seu contexto*. Fundi-los faria a definição carregar decisões de enforcement que ela não deve possuir.

## Como os critérios são classificados

Cada critério do catálogo (`references/quality-criteria.md`) é marcado com um de três níveis. O nível diz respeito à **natureza** do critério, não a qualquer consequência automática:

- **NON-NEGOTIABLE** — um pecado capital: o piso para código novo. "Inegociável" significa *não negociável em silêncio* — você o cumpre, ou se desvia dele como uma **exceção nomeada, deliberada e com responsável** (veja Exceções). Cada um carrega um ID estável (`QM-XX-N`) para que uma discussão cite o critério, não um humor.
- **CALIBRATED** — um item de julgamento, sempre pareado com sua tensão honesta. O modelo dá o critério e o trade-off; o leitor calibra ao contexto. Nunca é uma regra a aplicar mecanicamente.
- **AUTOMATED** — um nível mecânico (formatação, varredura de dependências, cobertura como sinal, varredura de segredos) que pertence a ferramentas. A atenção humana gasta rediscutindo-o é desperdício; o que vale levantar é a sua ausência na toolchain.

Acima dos três está a regra de calibração: a régua é **proporcional** à vida útil esperada e à importância do código e ao modelo de ameaças realista. Um protótipo descartável e um núcleo de dez anos não são cobrados pelo mesmo padrão. Maturidade é saber quando um critério deixa de se aplicar — o catálogo declara cada tensão para que o modelo calibre em vez de ser lido como absoluto.

## Exceções: legado e dívida deliberada

Um modelo de qualidade que não admitisse exceções seria inútil num código real, que sempre contém legado escrito para uma régua mais baixa e dívida que o projeto escolheu assumir. O modelo trata disso não enfraquecendo os critérios, mas governando **como um desvio é feito**. A distinção que atravessa o modelo inteiro é *silencioso versus deliberado*:

- **A dívida deliberada é legítima.** Escolher conscientemente uma simplificação — para entregar, para validar um mercado, para adiar uma decisão até saber mais — é uma jogada de engenharia válida (o quadrante deliberado-e-prudente, `QM-MT-2`). O que o modelo proíbe é o desvio **invisível**: o atalho que ninguém nomeou, o inegociável silenciosamente pulado. Um desvio é aceitável quando é **deliberado, nomeado, justificado e com responsável** — um comentário no ponto, um item de backlog, ou um ADR quando sobrevive à story (`QM-MT-1`). O pecado nunca é a dívida; é a dívida que ninguém consegue ver ou discutir.
- **O legado não é condenado retroativamente.** O modelo se aplica ao código que você **escreve e altera**, não a toda linha que o antecede. Adicionar uma funcionalidade a uma área de baixa qualidade não obriga você a levar a área inteira ao padrão; obriga você a cumprir a régua no que adiciona, deixar a área não pior e — onde um inegociável já é violado ao seu redor — nomeá-lo como dívida herdada em vez de adotá-lo em silêncio. No código existente, o padrão local também vence a preferência (`QM-CN-2`): a consistência com o entorno é, ela mesma, um critério de qualidade, então "melhorar" introduzindo uma segunda forma costuma ser perda líquida.
- **Nem toda exceção custa o mesmo.** Critérios calibrados se curvam facilmente ao contexto. Inegociáveis só se curvam como exceções explícitas e com responsável — e os critérios de **segurança** (`QM-SR-*`) carregam a régua mais alta de todas, porque a assimetria deles faz com que uma única lacuna silenciosa possa ser fatal, por melhor que todo o resto seja. Uma exceção deliberada de segurança é uma decisão de modelo de ameaças com o responsável no circuito, não uma linha rotineira de dívida.

A maturidade que isto codifica é aquela com que o material de origem se encerra: conhecer as regras não é a habilidade; saber quando cada uma deixa de se aplicar, e dizê-lo em voz alta, é.

## O que este modelo não é

- **Não é um substituto do julgamento.** Os inegociáveis são um piso, não uma definição de bom.
- **Não é um gate de enforcement.** Define a régua; o `code-review` decide, depois, se um dado PR a supera e o que recomendar.
- **Não são os padrões de código.** Esta skill é dona de *princípios e inegociáveis*; o `prime-core/coding-standards` é dono das *convenções concretas do projeto* — qual nomenclatura, qual divisão em camadas, quais idiomas. Quando um critério precisa de uma convenção concreta para ser verificável, ele aponta para o `coding-standards`; não inventa uma.
- **Não é o lar de decisões arquiteturais.** Decisões que sobrevivem a uma story vivem em ADRs, de propriedade da fronteira de decisão do `prime-core/its-contract`. A dimensão de documentação referencia ADRs; não os redefine.

## Versionamento

"Critérios versionados, não preferências do momento" é o que permite que um desvio ou uma nota de melhoria cite algo estável e datado em vez de uma opinião.

- O catálogo carrega uma **versão** (p. ex., `v1.0`).
- Os **IDs dos critérios são estáveis e nunca renumerados**, como números de casos de uso e ADRs. Um critério aposentado deixa seu ID aposentado, não reutilizado.
- As mudanças passam pelo PR de governança **revisado pelo dono do modelo de qualidade**. Esse PR é o registro da evolução, no controle de versão — o modelo não mantém histórico paralelo, para evitar dois históricos se descolando.

## Overrides do projeto

O `docs/prime-config.md` pode **elevar** a régua — adicionar inegociáveis específicos do projeto ou endurecer um limiar calibrado — e pode **registrar uma postura permanente** diante de legado ou dívida para o projeto (p. ex., "o módulo X é legado sob migração strangler-fig; siga seus padrões locais, não os estenda"). Não pode **dispensar em silêncio** um inegociável do core: relaxar um é uma decisão deliberada e com responsável (um ADR), não uma edição silenciosa de configuração. Isso espelha a regra de precedência do prime-config — a configuração sobrescreve padrões declarados, nunca regras do core.

## Regras de consumo

**Construindo código novo** — o modelo é a base. Cumpra o piso inegociável; calibre o resto ao contexto do código. Onde o plano ou o projeto adotar um desvio, torne-o uma exceção nomeada e com responsável, nunca silenciosa.

**Para o `its-generator` (questionando a ITS que entrega)** — referencie o modelo para interrogar o plano antes de passá-lo adiante: alguma mudança proposta comete um pecado capital em silêncio; o nível de cuidado proposto está calibrado à vida útil e à importância do código; onde um critério é desrespeitado por legado ou dívida, isso está declarado como uma exceção deliberada (uma linha de alternativa descartada, uma fronteira de fora de escopo ou um ADR)? O objetivo é fazer aflorar melhorias no entregável, citando critérios por ID na análise apresentada ao arquiteto. No documento, a exceção é escrita por extenso, e o critério aparece só nas Referências da ITS.

**Para o `its-implementation` (questionando a implementação que entrega)** — a mesma disciplina do lado do código: meça a implementação e seus testes contra os critérios, cumpra o piso em código novo e alterado e, onde o legado herdado viola um inegociável, nomeie-o em vez de adotá-lo em silêncio. Ambiguidade sobre qual régua se aplica é uma pergunta a devolver ao arquiteto, não uma suposição.

**Para o `code-review`** — o revisor transforma esses critérios em achados precisos e numa recomendação de aprovar/reprovar o PR, julgando cada um contra o contexto da mudança e suas exceções nomeadas. Esse papel de enforcement pertence a ele; esta skill apenas fornece a definição versionada que ele cita.

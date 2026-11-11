---
name: adr-contract
description: O contrato do ADR (Architecture Decision Record), o registro de uma decisão de arquitetura que sobrevive à story - quando uma decisão merece um ADR, a nomenclatura, o ciclo de vida do status, quem redige e quem aprova, e o template. Consulte para decidir se uma decisão deve um ADR e para escrever, aprovar ou ler um. Referencie-o, nunca o duplique.
---

# Contrato do ADR

O ADR registra uma decisão sobre como o sistema é construído: tomada uma vez, aprovada pelo arquiteto e vinculante para todo plano posterior. Esta skill é dona do seu formato — quando uma decisão merece um registro, o ciclo de vida do status, quem redige e quem aprova, e o template. O adr-generator escreve contra este contrato; quem planeja, quem implementa e quem revisa leem contra ele.

O ADR é um documento próprio, com o seu template, o seu fluxo de escrita e a sua aprovação. Uma ITS depende de um ADR, nunca o contrário: ela o cita e escreve o que ele exige do plano (its-contract, Fronteira de decisão), e a justificativa vive só no registro. O nível de detalhe e o formato de saída da ITS não se aplicam a ele: o ADR é sempre Markdown e tem uma forma só.

## Nomenclatura de arquivo

`adr/ADR-NNN-titulo-curto.md` sob a raiz de documentos do projeto, ou conforme sobrescrito pela configuração do projeto › Repositório de documentos. `NNN` é sequencial em todo o repositório e nunca é renumerado nem reaproveitado; uma decisão aposentada mantém seu número e assume o status `Superseded by ADR-NNN`, e uma proposta recusada mantém o seu e assume `Rejected`. O slug segue o idioma do documento; o prefixo `ADR-NNN` não.

## Template canônico

`templates/adr-template.md`. Quem redige ou aprova um registro lê o template integralmente. Quem só lê um ADR — para planejar sob ele, implementar ou revisar — não precisa do template: o que vincula está na seção Decisão e na linha Vincula, e o campo Escopo diz onde. Contexto, Alternativas consideradas e Consequências explicam a decisão e não são reproduzidos fora do registro.

## Quando uma decisão merece um ADR

**O assunto vem antes dos critérios.** Um ADR registra uma decisão sobre **como o sistema é construído** — estrutura, tecnologia, padrão, estratégia técnica, fronteira entre partes. O que o negócio decide nunca é um ADR, por duradouro e abrangente que seja: uma regra de negócio vive no documento de caso de uso, como `RN-N`, sob o histórico de revisão de lá. A fronteira cai onde a decisão deixa de ser sobre o que o produto faz e passa a ser sobre a solução que o faz: *pedido acima de um limite exige aprovação* é regra de negócio; *a aprovação é modelada como máquina de estados no domínio, e não como um campo no pedido* é ADR. Os critérios abaixo só são aplicados depois que a decisão passa por essa porta — uma regra que vale para vários módulos e cuja justificativa alguém vai querer mais tarde continua sendo caso de uso, não ADR.

Passada essa porta, uma decisão **sobrevive à story**, e merece um ADR, quando pelo menos uma destas vale:
- ela restringe escolhas futuras de implementação (padrão, biblioteca, estilo de integração, estratégia de persistência);
- afeta mais de um caso de uso ou módulo;
- alguém que não participou da decisão precisará da justificativa mais tarde.

Não merece ADR a decisão que não atende a nenhuma das três — um detalhe de implementação, por mais trabalho que dê. Ela **morre com a story** e fica no plano que a tomou:
- a escolha entre caminhos equivalentes cujo efeito termina no código de uma story;
- a aplicação de uma convenção, de um padrão do time ou de um ADR `Accepted` que já existe — não é decisão nova;
- uma decisão de qualidade cujo valor vem de um slot com valor — o timeout, as tentativas, o limite de leitura;
- o nome, a assinatura ou a divisão interna de um componente que só uma story usa.

Na dúvida entre os dois lados, o teste é o da próxima story: se outra story, em outro módulo ou caso de uso, teria de seguir a mesma escolha, ou se desfazê-la depois exigiria mudar código fora da story que a tomou, é ADR. Se a escolha pode ser refeita sem consequência fora daquele código, não é.

A maioria das stories rende zero ADRs. Um ADR existe porque uma decisão real entre stories foi tomada, não porque um campo quer ser preenchido.

## Ciclo de vida do status

- **Proposed** — redigido, ainda não aprovado. Não vincula ninguém, mas segura o plano que depende dele: nenhuma ITS é escrita nem entregue sobre uma decisão `Proposed`, porque ela pode mudar a solução que a ITS descreve.
- **Accepted** — aprovado pelo arquiteto. Contexto vinculante para todo implementador e todo plano posterior, dentro do Escopo declarado. A configuração do projeto não o sobrescreve; um conflito entre os dois é reportado, não resolvido em silêncio.
- **Rejected** — o arquiteto recusou a decisão proposta. O registro permanece no lugar, com a razão da recusa em uma linha na própria célula de Status (`Rejected — escopo de story`), para que o número não volte a ser usado e a discussão não recomece do zero. Não volta a outro status: uma proposta nova é um registro novo. Não incide sobre nenhum plano.
- **Superseded by ADR-NNN** — substituído. O registro permanece no lugar com a justificativa intacta, apontando para seu substituto. O status só muda quando o arquiteto aprova o substituto.

Só o arquiteto move um ADR entre status, quem quer que tenha escrito o registro. Mover é a decisão, não a edição do campo: por ordem explícita do arquiteto para aquele registro ("aprove o ADR-007"), quem está na sessão aplica a edição; nunca por julgamento próprio nem por uma ordem genérica.

## Quem detecta, quem redige, quem aprova

- **Detectar está aberto a qualquer skill da camada do arquiteto.** O its-generator para a geração da ITS e propõe o ADR quando o plano depende da decisão; a feasibility-analysis a levanta como uma `Condition:` quando uma demanda desafia uma decisão registrada; o code-review a devolve ao arquiteto quando ela chegou ao código sem registro. Detectar não é redigir: a skill que detecta leva a questão ao arquiteto e para aí.
- **Redigir é do adr-generator, e só pela palavra do arquiteto.** Ele o invoca diretamente — no refinamento ou em aconselhamento arquitetural, sem story nenhuma — ou aceita a proposta de uma skill que detectou a decisão. Nenhuma skill inicia um registro por julgamento próprio: um ADR arquivado sem a palavra do arquiteto é uma decisão que ninguém com autoridade tomou. O campo Origem nomeia de onde veio a decisão.
- **Aprovar é do arquiteto**, conforme o ciclo de vida acima.
- **O arquiteto nunca é bloqueado.** Uma decisão não precisa de story, de plano nem de skill para ser registrada: ele também pode redigir o registro à mão, contra o template. Quem tomou a decisão é quem deve o registro, e uma decisão que vincula trabalho futuro enquanto espera uma story para carregá-la é a partida invisível que o `QM-MT-1` nomeia.

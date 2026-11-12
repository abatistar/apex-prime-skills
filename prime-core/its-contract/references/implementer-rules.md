# Regras de quem implementa a partir da ITS

Parte do contrato do `its-contract`, lida por quem implementa — pessoa ou agente — e pelo code-review, que confere o pull request contra elas. Quem escreve a ITS não precisa deste arquivo.

- A ITS é o escopo. Implemente toda ela e nada além — incluindo respeitar as fronteiras de fora de escopo e as alternativas descartadas declaradas no plano de implementação.
- As restrições de ADR escritas nas unidades são vinculantes; nunca contradiga um ADR Accepted. Com acesso ao repositório, leia os ADRs citados nas premissas do plano, em Decisões registradas, antes de implementar — para saber o porquê; o quê já está na unidade. Um conflito entre a ITS e um ADR é ambiguidade — devolva-o como pergunta.
- Ambiguidade, contradição ou exigência ausente → não preencha a lacuna por suposição; devolva perguntas ao arquiteto referenciando a seção da ITS e a unidade ou o item.
- O que o nível de detalhe do documento deixa a cargo de quem implementa não é lacuna. A linha de nível, sob o título, diz o que o plano fixa e o que delega: no `simplificado`, os passos, os arquivos e os nomes internos; no `médio`, os passos dentro de cada componente. Decida o que foi delegado dentro das convenções do projeto e de tudo o que o documento fixa — o que está escrito vincula em qualquer nível. Devolva pergunta só quando a decisão delegada depender de uma exigência que o documento não traz.
- **A descrição do PR de entrega** é a passagem de bastão de volta ao arquiteto: o revisor a lê antes do diff, e a revisão não começa sem a primeira linha abaixo. Ela declara:
  - a ITS que o PR implementa e, quando a documentação do projeto vive numa pasta paralela, versionada à parte, a revisão da documentação implementada — é contra essa revisão que a implementação é julgada;
  - as unidades implementadas, pelo número, e a unidade que ficou de fora, com o motivo;
  - as perguntas devolvidas ao arquiteto durante a implementação e a revisão da ITS que as respondeu;
  - a dívida herdada encontrada no código tocado, com os elementos do registro de exceção do quality-model e o identificador do item de backlog que a registra;
  - os commits de arrumação mecânica, separados dos que mudam comportamento;
  - os comandos de verificação executados e o resultado, ou a execução do pipeline.
- Desvios descobertos durante a implementação (o plano não sobrevive ao contato com o código) → reporte; o arquiteto revisa a ITS. O documento permanece como fonte de verdade do que foi acordado. Cópias publicadas em outros lugares são visões; validar a divergência entre elas e o repositório é responsabilidade do arquiteto, não do implementador.

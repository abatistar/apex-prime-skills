# Gatilhos de Especificação

Referência de propriedade do `prime-core/quality-model`. Um gatilho é algo que uma story introduz ou altera e que transforma critérios do catálogo (`references/quality-criteria.md`) em decisões de projeto. A qualidade do que a ITS especifica depende de essas decisões estarem tomadas, por extenso, antes de o código existir: uma decisão que a ITS não toma é tomada pelo implementador, sob pressão, ou por ninguém.

Três papéis leem esta lista. O `its-generator` passa a story por ela e escreve cada decisão disparada na unidade que a implementa. O `its-implementation` a usa para reconhecer, no código que escreve, um gatilho que a ITS deixou sem decisão. O `code-review` confere contra ela: um gatilho disparado e não decidido é defeito do plano, não do autor.

**Como ler.** Cada gatilho traz quando dispara, os critérios que ativa, o que a especificação decide e a verificação esperada. A intensidade segue o nível de criticidade da área tocada (Perfis de criticidade, no catálogo): numa área `efêmera`, o gatilho exige o que o piso exige; numa área `crítica`, tudo o que ele lista. Os gatilhos são numerados para a conversa; o que se cita num achado ou nas Referências de uma ITS é o critério.

**Três regras.**
- A decisão chega à ITS como instrução, na unidade que a implementa, com o valor concreto — "timeout de 2 s; no máximo 3 tentativas, com espera de 200 ms, 400 ms e 800 ms, só para erro de conexão e HTTP 503" —, nunca como "um timeout adequado" nem como o ID do critério.
- Onde o `prime-core/coding-standards` ou a configuração do projeto já decide o valor, a ITS escreve esse valor. Onde ninguém decidiu, a lacuna é reportada, não inventada.
- Uma decisão que vale além desta story — o primeiro outbox do sistema, a política de idempotência de todos os consumidores — é um ADR, conforme a fronteira de decisão do `prime-core/its-contract`.

---

## G1 — Entrada externa nova ou alterada
*Dispara quando:* a story cria ou altera um endpoint, um consumidor de mensagem, um job que lê arquivo ou dado de outro sistema, ou um formulário que envia dados.
*Critérios:* `QM-SR-1`, `QM-SR-8`, `QM-EO-2`, `QM-EF-1`.
*A especificação decide:*
- a validação de cada campo na fronteira: tipo, tamanho, formato, obrigatoriedade;
- quem pode chamar e sobre quais recursos, inclusive a regra de titularidade ("somente o titular da conta");
- a resposta de erro a quem chama e o que fica só no log;
- o limite ou a paginação, quando a resposta é uma coleção.

*Verificação:* entrada inválida é rejeitada; acesso é negado a quem não pode, inclusive a recurso de outro titular; o erro não expõe detalhe interno.

## G2 — Contrato publicado alterado
*Dispara quando:* a story altera uma API, um evento, um arquivo ou um esquema que outro sistema consome.
*Critérios:* `QM-CC-7`, `QM-DO-1`.
*A especificação decide:*
- a forma retrocompatível da mudança, ou a nova versão e o período em que as duas convivem;
- os consumidores afetados e o que cada um precisa fazer, quando estão fora desta story;
- a documentação do contrato atualizada na mesma mudança.

*Verificação:* teste de contrato do consumidor, ou comparação do contrato entre a versão anterior e a nova, sem quebra.

## G3 — Chamada a sistema externo
*Dispara quando:* a story passa a chamar uma API, uma fila, um banco ou um arquivo de outro sistema, ou altera uma chamada existente.
*Critérios:* `QM-RB-1`, `QM-RB-3`, `QM-RB-6`, `QM-EO-5`, `QM-EO-6`, `QM-EO-7`.
*A especificação decide:*
- o timeout;
- as tentativas, a espera entre elas e quais falhas são repetidas;
- se a operação chamada é idempotente — e, se não for, que ela não é repetida;
- o comportamento quando a dependência está fora: o que o usuário vê, o que fica pendente;
- a camada que traduz o erro da dependência;
- o sinal que acompanha a chamada em produção.

*Verificação:* timeout e indisponibilidade simulados produzem o comportamento declarado.

## G4 — Escrita em mais de um recurso
*Dispara quando:* uma operação grava no banco e publica um evento, grava em dois bancos, ou grava no banco e em arquivo ou serviço.
*Critérios:* `QM-RB-4`.
*A especificação decide:*
- o mecanismo — transação única, outbox, compensação;
- o estado do sistema quando a falha acontece entre as escritas.

*Verificação:* falha simulada entre as escritas deixa o estado declarado.

## G5 — Operação que pode ser repetida
*Dispara quando:* consumidor de mensagem, endpoint que o cliente repete, job reexecutável, ação que o usuário pode disparar duas vezes.
*Critérios:* `QM-RB-3`.
*A especificação decide:*
- a chave que identifica a repetição;
- o que acontece na segunda execução.

*Verificação:* duas execuções produzem um único efeito.

## G6 — Estado compartilhado sob concorrência
*Dispara quando:* duas execuções podem alterar o mesmo dado ao mesmo tempo — saldo, estoque, contador, status de um fluxo, reserva.
*Critérios:* `QM-RB-5`, `QM-CC-1`.
*A especificação decide:*
- o protocolo — versão otimista, lock, operação atômica, isolamento da transação;
- a resposta ao conflito.

*Verificação:* o cenário de conflito produz a resposta declarada.

## G7 — Dado persistido novo ou esquema alterado
*Dispara quando:* a story cria ou altera tabela, coluna, coleção ou índice.
*Critérios:* `QM-CC-7`, `QM-EO-2`, `QM-SR-10`, `QM-EF-3`.
*A especificação decide:*
- as etapas da migração, compatíveis com a versão em produção;
- se o dado é pessoal ou sensível, e o que isso impõe: fora dos logs, mascaramento, retenção;
- os índices que as consultas novas exigem.

*Verificação:* a migração é aplicada sobre a versão anterior, com a versão anterior ainda funcionando.

## G8 — Leitura ou processamento de volume que cresce
*Dispara quando:* listagem, busca, relatório, exportação, processamento em lote, sincronização.
*Critérios:* `QM-EF-1`, `QM-EF-3`, `QM-RB-2`.
*A especificação decide:*
- o limite, a paginação ou o tamanho do lote;
- como os dados relacionados são carregados sem consulta por item.

*Verificação:* o número de consultas não cresce com o número de itens; um volume representativo é processado dentro do limite.

## G9 — Regra de negócio nova ou alterada
*Dispara quando:* o delta traz uma regra — condição e resposta — nova ou alterada.
*Critérios:* `QM-CC-6`, `QM-TS-7`.
*A especificação decide:*
- o único lugar em que a regra vive e os pontos que passam a chamá-lo;
- onde uma cópia antiga da regra é removida.

*Verificação:* um teste por condição e resposta da regra.

## G10 — Meta não funcional
*Dispara quando:* o caso de uso traz um critério de aceite não funcional — tempo de resposta, volume, disponibilidade.
*Critérios:* `QM-EF-2`, `QM-EO-7`.
*A especificação decide:*
- como a meta é verificada antes do merge — teste automatizado, teste de carga, medição;
- a métrica que acompanha a meta em produção.

*Verificação:* a medição declarada, com o resultado comparado à meta.

## G11 — Alteração em código sem testes
*Dispara quando:* a story altera código que nenhum teste exercita, em especial quando ele sustenta um ponto de regressão.
*Critérios:* `QM-TS-9`, `QM-MT-6`.
*A especificação decide:* uma unidade de testes de caracterização, antes da unidade que altera o código.
*Verificação:* os testes de caracterização passam antes e depois da mudança, exceto onde o delta muda o comportamento de propósito.

## G12 — Estrutura que não comporta a mudança
*Dispara quando:* a inspeção mostra que a mudança só cabe distorcendo o código — duplicando, acrescentando uma flag de controle, alargando uma função já sobrecarregada.
*Critérios:* `QM-MT-3`, `QM-CC-2`, `QM-RC-2`.
*A especificação decide:* uma unidade de refatoração preparatória, sem mudança de comportamento, antes das unidades de comportamento, dizendo o que muda de forma e o que fica igual.
*Verificação:* a suíte existente passa sem nenhuma alteração depois da refatoração (`QM-TS-8`).

## G13 — Dependência de terceiros nova
*Dispara quando:* a story precisa de uma biblioteca, um SDK ou uma imagem que o projeto ainda não usa.
*Critérios:* `QM-SR-4`, `QM-CN-1`.
*A especificação decide:*
- a dependência exata: coordenada e versão;
- por que a biblioteca já sancionada para a mesma preocupação não basta.

*Verificação:* varredura de dependências limpa; admissão registrada.

## G14 — Operação sensível
*Dispara quando:* a story movimenta dinheiro, altera dado pessoal ou sensível, concede ou remove privilégio, ou cria uma ação administrativa.
*Critérios:* `QM-SR-8`, `QM-SR-9`, `QM-SR-5`.
*A especificação decide:*
- os eventos registrados e quem é alertado;
- o privilégio mínimo com que a operação roda.

*Verificação:* o evento é registrado sem o dado sensível; o acesso indevido é negado.

## G15 — Comportamento novo em produção
*Dispara quando:* a story entrega comportamento novo, exceto numa área `efêmera` cuja pergunta não pede medição.
*Critérios:* `QM-EO-7`, `QM-EO-8`.
*A especificação decide:*
- o sinal que mostra em produção que o comportamento funciona — a métrica ou o evento de log estruturado;
- o nível de log dos caminhos de erro.

*Verificação:* revisão do sinal no diff; numa área `crítica`, um teste confere que ele é emitido.

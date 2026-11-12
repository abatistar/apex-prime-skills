# NM — Nomenclatura e estrutura (Java)

Leia com o índice, `references/defaults-java.md`; as definições estão em `references/convention-slots/`, mesmo nome.

- **CS-NM-1** — Os nomes dizem a peça do hexágono:
  - porta de entrada: `<Ação>UseCase` (interface), com a entrada num `<Ação>Command` (`record`) — `ConfirmOrderUseCase`, `ConfirmOrderCommand`;
  - serviço de aplicação: `<Ação>Service`, que implementa a porta de entrada;
  - porta de saída: `<Verbo><Objeto>Port` — `LoadOrderPort`, `SaveOrderPort`, `PublishOrderEventPort`;
  - adaptador de entrada: `*Controller` (HTTP), `*Listener` (mensageria), `*Job` (agendamento);
  - adaptador de saída: `*PersistenceAdapter` (implementa as portas de persistência sobre um `*Repository` do Spring Data e as `*JpaEntity`), `*Client` (HTTP, sobre a interface de cliente de serviço HTTP), `*Publisher` (mensageria);
  - de apoio: `*Mapper`, `*Config`, `*Properties`, `*Test`, `*IT`.

  Nenhum `*Manager`, `*Helper`, `*Util` em código novo. *Razão:* cada um desses é um nome para "eu não decidi o que isto é", e o nome da peça diz em que lado do hexágono ela está. *Verificação:* regra de nomenclatura no ArchUnit.
- **CS-NM-2** — `getX()` e `isX()` são puros e baratos: sem I/O, sem mutação, sem evento. Tudo o que alcança armazenamento ou rede é `load*`, `fetch*` ou `find*`; tudo o que muta é um verbo que nomeia o efeito (`confirmOrder`, não `processOrder`). *Razão:* quem chama um `get` não espera uma consulta ao banco num laço. *Verificação:* revisão; regra Semgrep para I/O dentro de `get*`.
- **CS-NM-3** — Um tipo vive no pacote do elemento do hexágono a que pertence (`CS-AR-4`) e, onde o elemento se subdivide por agregado, no pacote do agregado que o usa. Um tipo usado por um só agregado nunca vai para um pacote compartilhado. *Razão:* o pacote compartilhado vira depósito do que ninguém quis decidir. *Verificação:* revisão.

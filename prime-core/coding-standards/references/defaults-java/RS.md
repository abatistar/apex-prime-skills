# RS — Resiliência (Java)

Leia com o índice, `references/defaults-java.md`; as definições estão em `references/convention-slots/`, mesmo nome.

- **CS-RS-1** — Timeouts padrão, configurados em propriedades e nunca no ponto de chamada:
  - HTTP de saída: conexão 2 s, leitura 5 s — `spring.http.clients.connect-timeout` e `spring.http.clients.read-timeout` para todos os clientes, e `spring.http.serviceclient.<grupo>.*` para o grupo que precisa de outro valor **(Boot 4)**; no Boot 3, no `*Properties` de cada cliente;
  - obtenção de conexão do pool do banco: 5 s (`spring.datasource.hikari.connection-timeout=5000`) **(Spring)**;
  - transação: 30 s (`spring.transaction.default-timeout=30s`) **(Spring)**;
  - confirmação de publicação no broker: 5 s;
  - lock distribuído: sempre com prazo de espera, nunca indefinido.

  Repetição: até 3 novas tentativas, com espera de 200 ms, 400 ms e 800 ms e variação aleatória, somente para falhas transitórias — erro de conexão, timeout, HTTP 429, 502, 503 e 504 — e somente em operação idempotente ou com chave de idempotência (`CS-DA-2`). O mecanismo é o `@Retryable` do Spring Framework 7, habilitado por `@EnableResilientMethods` **(Boot 4)**, sempre com as exceções transitórias declaradas — sem elas, ele repete qualquer exceção; no Boot 3, o Retry do Resilience4j. A ITS declara outro valor quando a dependência pede. *Razão:* vários clientes HTTP da plataforma têm timeout de leitura infinito por padrão, e uma dependência lenta sem timeout esgota a capacidade de todo o resto. *Verificação:* regra Semgrep para cliente construído sem os builders auto-configurados e para `@Retryable` sem exceções declaradas; teste com servidor lento (WireMock) por cliente.
- **CS-RS-2** — Toda dependência externa não essencial passa por circuit breaker (Resilience4j) com o comportamento degradado declarado na ITS. Numa demanda `crítica`, toda dependência externa que ela toca tem circuit breaker e limite de concorrência — `@ConcurrencyLimit` do Spring Framework 7 **(Boot 4)**, ou o bulkhead do Resilience4j. Valores iniciais do circuit breaker: janela de 20 chamadas, abertura com 50% de falha, meia-abertura após 30 s. *Razão:* uma dependência fora do ar não pode derrubar o que não depende dela — e, com threads virtuais, nenhum pool de threads limita mais a pressão sobre ela. *Verificação:* revisão; teste com a dependência indisponível.

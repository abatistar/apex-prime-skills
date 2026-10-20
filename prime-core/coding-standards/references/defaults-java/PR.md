# PR — Soluções canônicas e proibições (Java)

Padrões do time para a stack Java nesta família de slots, de propriedade do `prime-core/coding-standards`. Lidos junto com o índice, `references/defaults-java.md`, que guarda como ler as marcas (Spring), (Boot 4) e (Java 21+), a Plataforma e a Toolchain do time. As definições dos slots estão no arquivo de mesmo nome em `references/convention-slots/`.

- **CS-PR-1** — O registro cresce por projeto no `docs/prime-config.md`, cada entrada com seu exemplo canônico. Entradas válidas para o time todo:
  - chamada a outro serviço: um adaptador de saída `*Client` que implementa a porta de saída sobre uma interface de cliente de serviço HTTP (`@HttpExchange`), registrada com `@ImportHttpServices` e configurada por grupo **(Boot 4)** — no Boot 3, sobre o `RestClient` —, com os valores de `CS-RS-1` e `CS-RS-2` e a tradução de erro de `CS-ER-3`;
  - consumo de mensagem: um adaptador de entrada `*Listener` que desserializa, confere a idempotência (`CS-DA-2`) e chama a porta de entrada;
  - trabalho agendado: um adaptador `*Job` que chama a porta de entrada, conforme `CS-DA-2` e `CS-DA-7`;
  - evento publicado conforme `CS-DA-6`.

  *Razão:* um problema recorrente resolvido de um jeito só. *Verificação:* revisão.
- **CS-PR-2** — Proibidos, cada um com sua razão:
  - **Injeção por campo** (`@Autowired` num campo) — esconde dependências e torna o tipo intestável sem um container (`QM-TS-3`). Somente injeção por construtor.
  - **`catch (Exception e)`** fora do advice de fronteira — captura o que não antecipou e transforma um defeito em silêncio (`QM-EO-1`).
  - **Estado mutável estático** — o acoplamento invisível que o `QM-CC-1` nomeia como o pior tipo.
  - **Lombok `@Data` em entidades** — gera `equals`/`hashCode` sobre campos mutáveis e carregados de forma lazy, produzindo corrupção de coleções que aflora longe da causa (`QM-RC-1`).
  - **Entidade como `@RequestBody`** — faz do modelo de persistência o contrato público e abre mass assignment (`QM-SR-1`).
  - **Lógica de negócio em trigger de banco ou stored procedure** — invisível para o código, intestável na suíte, sem versionamento junto com a mudança (`QM-CC-6`).
  - **Thread ou executor criado sem ciclo de vida gerenciado** (`new Thread`, `Executors.new*` fora de um bean com encerramento) — vaza recursos e sobrevive ao contexto (`QM-RB-2`).
  - **Desserialização nativa do Java** (`ObjectInputStream`) de dado externo — execução de código a partir da entrada (`QM-SR-1`).
  - **Cliente HTTP construído à mão** (`new RestTemplate()`, `RestClient.create()`, `HttpClient.newHttpClient()` no ponto de chamada) — escapa dos timeouts e da observação configurados para todos (`QM-RB-1`, `QM-EO-7`).
  - **Adaptador injetado no núcleo** — um `*Repository` do Spring Data, um `*Client` ou um `*Publisher` usado direto por um serviço de aplicação, em vez da porta de saída — amarra o caso de uso à tecnologia e impede testá-lo sem ela (`QM-CC-3`).

  *Verificação:* Error Prone, SpotBugs, Semgrep, ArchUnit.

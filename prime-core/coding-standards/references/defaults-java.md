# Padrões do Time — Java

Valores padrão de slots para a stack Java do time, de propriedade do `prime-core/coding-standards`. Aplicados quando o `docs/prime-config.md` nada declara para o slot; qualquer valor que o projeto declare vence. As definições dos slots e as classes de aplicação vivem em `convention-slots.md` — este arquivo apenas fornece respostas.

Uma marca **(Spring)** delimita o mecanismo que ela acompanha, nunca a entrada que a carrega. `@RestControllerAdvice`, `@Transactional`, `@PreAuthorize`, `spring.jpa.open-in-view` e afins são como um projeto Spring Boot atende ao slot; um projeto em outro framework substitui por um mecanismo equivalente e mantém tudo o mais que a entrada diz — a camada a que a decisão pertence, as proibições e as alternativas não Spring nomeadas ao lado. Nenhuma entrada marcada perde sua substância sob essa substituição, de modo que nenhuma delas manda um projeto declarar o slot do zero na sua configuração. Um tipo Spring citado *sem* a marca é ilustração, não uma dependência: a regra ao redor dele vale como escrita. Baseline: Java 17.

---

## AR — Arquitetura e dependências

- **CS-AR-1** — `api → service → domain`, `persistence → domain`. O domínio não depende de nada. A camada de API nunca alcança um repositório diretamente; a camada de persistência nunca chama um serviço. Imposto por um teste ArchUnit que quebra o build, não pela revisão.
- **CS-AR-2** — As decisões de negócio vivem em `domain`. Um controller mapeia e delega; um repositório consulta. Uma condicional que expressa uma regra de negócio em qualquer um dos dois é um defeito.
- **CS-AR-3** — Entidades JPA nunca saem das camadas de persistência e de serviço: nunca um `@RequestBody`, nunca um `@ResponseBody`, nunca um campo de DTO. Nenhum import de `jakarta.persistence` ou `org.springframework` dentro de `domain`.
- **CS-AR-4** — Agrupe por feature, depois por camada dentro da feature (`billing/api`, `billing/domain`). O empacotamento com camada técnica primeiro é a forma legada e não é estendido.
- **CS-AR-5** — O padrão é chamada direta por uma interface publicada. Eventos de domínio para efeitos que não devem bloquear a transação de origem; mensageria para trabalho entre serviços. Qualquer outra coisa é justificada na ITS.

## NM — Nomenclatura e estrutura

- **CS-NM-1** — `*Controller` (fronteira HTTP), `*Service` (orquestração de aplicação), `*Repository` (persistência), `*Client` (chamada externa), `*Mapper`, `*Config`, `*Properties`, `*Test`, `*IT`. Nenhum `*Manager`, `*Helper`, `*Util` em código novo — cada um é um nome para "eu não decidi o que isto é".
- **CS-NM-2** — `getX()` e `isX()` são puros e baratos: sem I/O, sem mutação, sem evento. Tudo o que alcança armazenamento ou rede é `load*`, `fetch*` ou `find*`; tudo o que muta é um verbo que nomeia o efeito (`confirmOrder`, não `processOrder`). Ausência é `Optional`, nunca `null`; uma coleção é vazia, nunca `null`.
- **CS-NM-3** — Um tipo público por arquivo, com o nome do arquivo. Um tipo usado por exatamente uma feature vive no pacote dessa feature, não em um compartilhado.

## ER — Erros

- **CS-ER-1** — Situações de domínio esperadas são subclasses tipadas de `BusinessException` (não verificada). Invariantes violados usam `IllegalStateException` / `IllegalArgumentException` e nunca são capturados como fluxo de controle. Sem exceções verificadas em código novo.
- **CS-ER-2** — Toda subclasse de `BusinessException` carrega um código de erro estável. Uma nova categoria é uma nova subclasse mais um código, nunca uma mensagem em string interpretada pelo chamador.
- **CS-ER-3** — A tradução acontece uma vez, na fronteira da API, em um `@RestControllerAdvice` **(Spring)**. As camadas de serviço e de domínio propagam. Nenhum `try/catch` cujo único ato seja registrar em log e relançar.
- **CS-ER-4** — Para fora: `ProblemDetail` da RFC 7807 com o código de erro e uma mensagem segura — sem stack trace, sem identificador interno, sem SQL. Para dentro: a exceção completa com a causa, registrada uma vez na fronteira que a traduz.
- **CS-ER-5** — Sempre `throw new SomethingException(message, cause)`. Nunca `new RuntimeException(e.getMessage())`, que descarta a cadeia que o `QM-EO-3` existe para proteger.
- **CS-ER-6** — Proibido: `catch` vazio; `catch (Exception e)` fora do advice de fronteira; `catch` que retorna `null` ou um valor padrão no lugar de sinalizar; resultados de `Future`/`CompletableFuture` ignorados.

## OB — Observabilidade

- **CS-OB-1** — Somente SLF4J, saída estruturada em JSON, mensagens parametrizadas (`log.info("order confirmed {}", id)`) — nunca concatenação de strings. `ERROR` = precisa de um humano esta noite; `WARN` = degradado mas tratado; `INFO` = aconteceu um evento de negócio; `DEBUG` = diagnóstico, desligado em produção.
- **CS-OB-2** — `traceId` e `spanId` no MDC em toda requisição e mensagem consumida, propagados para as chamadas de saída. Micrometer Tracing **(Spring)**.
- **CS-OB-3** — Nunca registrado em log: senhas, tokens, chaves de API, headers de autorização, números completos de cartão, CPF/CNPJ, endereços, corpos completos de requisição ou resposta de endpoints que carreguem qualquer um dos itens anteriores. Uma entidade ou DTO que guarda um campo sensível nunca chega a um log pelo seu `toString()` — o campo é mascarado no tipo.
- **CS-OB-4** — Toda integração de saída é cronometrada e contada. Todo evento de negócio sobre o qual um envolvido perguntaria recebe uma linha `INFO` com os identificadores necessários para correlacioná-lo.

## DA — Dados e transações

- **CS-DA-1** — `@Transactional` fica no método do serviço de aplicação e em nenhum outro lugar **(Spring)**: nunca em um controller, nunca em um repositório, nunca em um método privado ou autoinvocado (o proxy não o aplicará — uma falha silenciosa que esta regra existe para prevenir). Nenhuma chamada externa dentro de uma transação.
- **CS-DA-2** — Todo consumidor de uma mensagem ou webhook é idempotente, com chave em um identificador de negócio ou de entrega. Os retries são limitados, com backoff, e somente para falhas transitórias.
- **CS-DA-3** — Flyway, `V<n>__descricao_em_snake_case.sql`. Os deploys sobrepõem versões, então as mudanças de esquema são retrocompatíveis por um release: adicione antes de usar, pare de usar antes de remover.
- **CS-DA-4** — Uma migração que rodou em qualquer ambiente nunca é editada. A correção é uma nova migração.
- **CS-DA-5** — Todas as associações `LAZY`. Open Session In View desabilitado (`spring.jpa.open-in-view=false`) **(Spring)** — ele esconde o N+1 atrás do carregamento lazy na camada de view. Uma query que precisa de uma associação a declara com um join fetch ou um `@EntityGraph`.

## CT — Contratos externos

- **CS-CT-1** — Versionamento na URI (`/api/v1/...`). Apenas mudanças aditivas dentro de uma versão: novos campos opcionais sim; campos removidos ou renomeados e tipos estreitados não. Uma quebra de contrato é uma nova versão com um sunset anunciado para a antiga.
- **CS-CT-2** — Paginação por página com `page`/`size`, com `size` limitado no servidor. Ordenação via `sort=campo,direcao`. Coleções sempre retornam um envelope com os metadados da página, nunca um array puro.
- **CS-CT-3** — DTOs de requisição e resposta são tipos `record` na camada de API, com anotações do Bean Validation. O mapeamento é explícito e testado; nenhuma entidade é jamais serializada.
- **CS-CT-4** — `Instant` em UTC para instantes, `LocalDate` para datas sem hora, ISO-8601 no fio. `BigDecimal` para dinheiro, com a escala declarada — nunca `double` ou `float`. `UUID` para identificadores externos; identificadores de sequência do banco nunca são expostos.

## TS — Testes

- **CS-TS-1** — Nunca entra em merge sem teste: um endpoint ou consumidor novo ou alterado (teste de integração), uma regra de negócio nova ou alterada (teste unitário no domínio), um bug corrigido (um teste que falha antes da correção). Todo o resto é julgamento.
- **CS-TS-2** — `*Test` para testes unitários (sem contexto Spring), `*IT` para testes de integração (Testcontainers, banco real). Os nomes dos métodos declaram cenário e expectativa: `should_rejectOrder_when_creditLimitExceeded`. JUnit 5 + AssertJ.
- **CS-TS-3** — Faça mock apenas das fronteiras que o time não controla: HTTP externo, brokers de mensagens, relógios. O banco de dados é real via Testcontainers — um substituto em memória testa um dialeto que ninguém roda. Nunca faça mock do tipo sob teste nem de seus value objects.
- **CS-TS-4** — Sem `Thread.sleep` para sincronização; use Awaitility. Sem dependência da ordem de execução, sem estado compartilhado entre testes, sem depender de `LocalDateTime.now()` — o tempo é injetado por um `Clock`.

## SC — Segurança

- **CS-SC-1** — A autorização é imposta no serviço de aplicação, em nível de método (`@PreAuthorize` ou uma verificação explícita) **(Spring)**. Uma verificação feita apenas no controller é insuficiente; uma verificação feita apenas no cliente não é uma verificação.
- **CS-SC-2** — Bean Validation em todo DTO de fronteira, com semântica de allowlist. As queries são parametrizadas — nunca concatenação de strings em JPQL, SQL nativo ou Criteria. A entrada externa nunca chega a um caminho de arquivo, a um comando ou a um desserializador sem neutralização.
- **CS-SC-3** — Nenhuma credencial em `application.yml`, em arquivo de propriedades ou no controle de versão. Injetadas como variáveis de ambiente ou resolvidas a partir do cofre do projeto, e rotacionáveis sem rebuild.
- **CS-SC-4** — Senhas via `BCryptPasswordEncoder` do Spring Security ou Argon2 **(Spring)**; JJWT ou a biblioteca da plataforma para tokens. Nenhum algoritmo artesanal, nenhum `MessageDigest` usado como hash de senha, nenhum `Random` onde `SecureRandom` é exigido.
- **CS-SC-5** — OWASP ASVS Nível 2 como conjunto de controles de referência; o projeto o eleva em sua configuração quando o modelo de ameaças justificar.

## DP — Dependências de terceiros

- **CS-DP-1** — Uma nova dependência declara: o problema que resolve, por que a plataforma ou uma dependência existente não o resolve, sua atividade de releases e sua licença. Aprovada pelo arquiteto.
- **CS-DP-2** — Uma biblioteca por preocupação: `java.time` para tempo, Jackson para JSON, SLF4J para logging, o cliente HTTP da plataforma, Testcontainers para infraestrutura de integração. Joda-Time, Gson, `java.util.Date` e o tratamento de datas do Apache Commons não são introduzidos.
- **CS-DP-3** — Nenhum release sai com um advisory alto ou crítico aberto. O Renovate mantém as versões andando; a varredura roda no pipeline. Uma exceção tem prazo e responsável, nunca um comentário de supressão que ninguém revisita.

## PR — Soluções canônicas e proibições

- **CS-PR-1** — O registro cresce por projeto no `docs/prime-config.md`. Entradas válidas para o time todo: HTTP de saída passa por um cliente tipado com timeout, retry e circuit breaker configurados — nunca uma chamada `RestTemplate`/`WebClient` solta no ponto de chamada; trabalho agendado é idempotente e protegido contra instâncias concorrentes; falha parcial em um agregado usa um outbox em vez de transação distribuída.
- **CS-PR-2** — Proibidos, cada um com sua razão:
  - **Injeção por campo** (`@Autowired` em um campo) — esconde dependências e torna o tipo intestável sem um container. Somente injeção por construtor.
  - **`catch (Exception e)`** fora do advice de fronteira — captura o que não antecipou e transforma um bug em silêncio.
  - **Estado mutável estático** — o acoplamento invisível que o `QM-CC-1` nomeia como o pior tipo.
  - **Lombok `@Data` em entidades** — gera `equals`/`hashCode` sobre campos mutáveis e carregados de forma lazy, produzindo corrupção de coleções que aflora longe da causa.
  - **Entidade como `@RequestBody`** — faz do modelo de persistência o contrato público e abre mass assignment.
  - **Lógica de negócio em trigger de banco ou stored procedure** — invisível para o código, intestável na suíte, sem versionamento junto com a mudança.
- **CS-PR-3** — Nenhum padrão é exigido pelo nome. O `CS-PR-1` declara o problema e a solução sancionada; a estrutura decorre disso.

---

## Mapa de automação

Slots que uma ferramenta verifica não são material de revisão — um humano rediscutindo-os é desperdício (`QM-CN-3`). O que segue é uma toolchain inicial; um projeto que não tem uma entrada é o que vale levantar.

| Slots | Ferramenta |
|---|---|
| CS-AR-1, CS-AR-2, CS-AR-3 | Teste ArchUnit no build |
| CS-NM-1, CS-NM-2 (parcial) | Checkstyle / regras customizadas de Semgrep |
| CS-ER-5, CS-ER-6, CS-PR-2 | Error Prone, SpotBugs, Semgrep |
| CS-DA-1, CS-DA-5 | Regras de Semgrep; `open-in-view` verificado em um teste de configuração |
| CS-SC-2 | Semgrep, SpotBugs (find-sec-bugs), SAST no pipeline |
| CS-SC-3 | gitleaks no pre-commit e no CI |
| CS-DP-2, CS-DP-3 | Maven Enforcer (dependências banidas), Renovate, varredura de dependências |
| CS-TS-4 | Detecção de testes instáveis no CI; PIT para a qualidade da suíte |

O Semgrep merece destaque: vários slots deste arquivo que parecem regras em prosa ("nunca chame um repositório a partir de um controller", "nunca concatene em JPQL") são expressáveis como regras customizadas, o que os tira da revisão e os coloca no build.

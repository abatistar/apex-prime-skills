# Padrões do Time — Java

Valores padrão de slots para a stack Java do time, de propriedade do `prime-core/coding-standards`. Aplicados quando o `docs/prime-config.md` nada declara para o slot; qualquer valor que o projeto declare vence. Estes padrões são versionados pela release do Apex Prime que os traz: o projeto fixa na configuração a release que segue, e uma release nova só o alcança quando ele a adota (SKILL.md, Padrões do time). As definições dos slots e as classes de aplicação vivem em `convention-slots.md` — este índice e os arquivos de família em `references/defaults-java/` apenas fornecem respostas.

Cada entrada traz o valor, a **razão** — a falha que ele evita — e a **verificação** concreta. Os exemplos canônicos são do projeto, declarados na configuração: um padrão do time não conhece o código de ninguém.

Uma marca **(Spring)** delimita o mecanismo que ela acompanha, nunca a entrada que a carrega. `@RestControllerAdvice`, `@Transactional`, `@PreAuthorize`, `spring.jpa.open-in-view` e afins são como um projeto Spring Boot atende ao slot; um projeto em outro framework substitui por um mecanismo equivalente e mantém tudo o mais que a entrada diz — a camada a que a decisão pertence, as proibições e as alternativas não Spring nomeadas ao lado. Nenhuma entrada marcada perde sua substância sob essa substituição, de modo que nenhuma delas manda um projeto declarar o slot do zero na sua configuração. Um tipo Spring citado *sem* a marca é ilustração, não uma dependência: a regra ao redor dele vale como escrita.

Uma marca **(Boot 4)** ou **(Java 21+)** delimita um mecanismo que só existe a partir dessa versão. Abaixo dela, vale a alternativa nomeada na mesma entrada, e a regra ao redor continua valendo.

## Plataforma

- **Referência para projeto novo:** Java 25, a versão LTS corrente, e Spring Boot 4 — com Spring Framework 7, Spring Security 7, Jakarta EE 11, Hibernate 7 e Jackson 3. O time segue versões LTS do Java; uma versão intermediária só entra quando a Stack do projeto a declara.
- **Mínimo:** Java 17, o mínimo do Spring Boot 4. Um recurso de linguagem ou de framework acima da versão que a Stack do projeto declara nunca é usado nem planejado.
- **Spring Boot 3:** fora do suporte de código aberto desde 30 de junho de 2026. Um projeto nele trata a subida para o Boot 4 como migração declarada; as receitas do OpenRewrite executam a parte mecânica (Boot, Jackson 2 → 3, anotações de teste).
- **Threads virtuais (Java 21+):** o modelo padrão para I/O bloqueante, com `spring.threads.virtual.enabled=true` **(Spring)**. Sem um pool de threads limitando o paralelismo, o limite passa a ser declarado onde o recurso é escasso: o pool de conexões do banco tem tamanho explícito, e uma dependência que não aguenta carga recebe limite de concorrência (`CS-RS-2`). Até o Java 23, um bloco `synchronized` em volta de I/O prende a thread portadora; a partir do Java 24 não prende mais.

---

## As famílias

Os valores de cada família vivem no seu arquivo, em `references/defaults-java/`, com o mesmo nome do arquivo da família no catálogo de slots: `AR.md` arquitetura e dependências · `NM.md` nomenclatura e estrutura · `ER.md` erros · `OB.md` observabilidade · `DA.md` dados e transações · `RS.md` resiliência · `CT.md` contratos externos · `TS.md` testes · `SC.md` segurança · `DP.md` dependências de terceiros · `EV.md` evolução e dívida · `PR.md` soluções canônicas e proibições.

Este índice é lido sempre que um valor do time é necessário; o arquivo de uma família, quando o valor de um slot dela é necessário — nunca todos de antemão.

---

## Toolchain do time

As ferramentas que as verificações das famílias nomeiam. Um projeto que não tem uma delas tem uma lacuna de toolchain a registrar — não um slot a revisar à mão.

- **Build:** Spotless com um formatador de Java (google-java-format ou palantir-java-format) · ArchUnit, com a regra de arquitetura hexagonal e as regras de nomenclatura e de import · Error Prone com NullAway em modo JSpecify · SpotBugs com find-sec-bugs · Checkstyle · Maven Enforcer (`banDynamicVersions` e dependências banidas) · `flyway validate` · CycloneDX para o SBOM.
- **Regras do time:** Semgrep. Vários slots que parecem regras em prosa ("nunca chame um repositório a partir de um controller", "nunca concatene em JPQL", "cliente HTTP sem os builders auto-configurados", "`@Retryable` sem exceções declaradas") são expressáveis como regras customizadas, o que os tira da revisão e os coloca no build.
- **Testes:** JUnit Jupiter (JUnit 6 no Boot 4) · AssertJ · `MockMvcTester` · `RestTestClient` · Testcontainers com `@ServiceConnection` · WireMock · Spring Cloud Contract ou Pact para os contratos entre serviços · Awaitility · Hibernate Statistics para contagem de consultas · PIT para teste de mutação nas áreas `crítica`.
- **Pipeline:** gitleaks · varredura de dependências · Renovate · comparação de OpenAPI · detecção de testes instáveis · regra de `@Disabled` sem item.
- **Migrações mecânicas:** receitas do OpenRewrite (subida de Spring Boot, Jackson 2 → 3, JUnit, anotações de teste), executadas em bloco conforme as migrações declaradas.

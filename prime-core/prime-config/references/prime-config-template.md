# Template do Prime Config

Template canônico de propriedade do prime-core/prime-config. O SKILL.md define quais seções são obrigatórias, a validação e o procedimento de bootstrap, e o `references/consumer-rules.md` define a precedência, as divergências e o ciclo de vida — este arquivo é a estrutura. Substitua os valores de exemplo (mostrados para um microsserviço Java/Spring) pelos fatos do projeto-alvo; não apague nada obrigatório.

O arquivo do projeto guarda fatos. Os comentários abaixo são ponteiros de uma linha para o contrato que define cada seção; não acrescente explicações a eles — toda skill lê este arquivo no primeiro passo.

````markdown
# Configuração do Prime — [Nome do Projeto]

Lido por toda skill do Apex Prime como primeiro passo, conforme o prime-core/prime-config.
Versionado com o código. Explícito aqui vence o que as skills detectam; divergência com os
arquivos de build é reportada.

## Stack
<!-- prime-core/prime-config › Seções. Mais de um componente: uma Stack por componente, cada uma com seu tipo. -->
- Tipo de componente: serviço
- Linguagem: Java 25
- Framework: Spring Boot 4.1
- Build: Maven (`./mvnw`)
- Banco de dados: PostgreSQL 17
- Migrações: Flyway, em `src/main/resources/db/migration`
- Mensageria: RabbitMQ (spring-amqp)

## Estrutura
<!-- prime-core/coding-standards › CS-AR-1. Um elemento por linha, com o pacote que o representa; é o que o teste de arquitetura verifica. -->
- Arquitetura: hexagonal (portas e adaptadores)
- Domínio: `src/main/java/com/acme/app/domain`
- Aplicação: `src/main/java/com/acme/app/application` — portas de entrada em `port/in`, portas de saída em `port/out`, serviços em `service`
- Adaptadores de entrada: `src/main/java/com/acme/app/adapter/in` — `web`, `messaging`, `scheduling`
- Adaptadores de saída: `src/main/java/com/acme/app/adapter/out` — `persistence`, `http`, `messaging`
- Montagem: `src/main/java/com/acme/app/config`
- Testes unitários: `src/test/java`; de integração: `src/test/java/**/*IT.java`
<!-- Projeto legado: declare a arquitetura que existe (por exemplo, camadas controller → service → repository) e o override de CS-AR-1 em Overrides de slots. -->

## Comandos de verificação
- Build completo com testes: `./mvnw clean verify`
- Apenas testes unitários: `./mvnw test`
- Uma única classe de teste: `./mvnw test -Dtest=NomeDaClasse`
- Teste de arquitetura: `./mvnw test -Dtest=ArchitectureTest`
- Mutação (áreas críticas): `./mvnw org.pitest:pitest-maven:mutationCoverage`

## Repositório de documentos
<!-- prime-core/prime-config › Repositório de documentos. Raiz: `docs` (no repositório) ou pasta paralela, versionada à parte. -->
- Raiz de documentos: `../app-docs` (pasta paralela ao projeto, com repositório próprio)
- Casos de uso: `use-cases/UC-NNN-titulo-curto.md`
- ITS: `its/ITS-<story-id>-titulo-curto.wiki`
- ADRs: `adr/ADR-NNN-titulo-curto.md`
- Template de caso de uso customizado: nenhum
- Seções obrigatórias extras de caso de uso: nenhuma

## Responsáveis
<!-- prime-core/prime-config › Responsáveis. Papel sem nome: "não declarado ainda". -->
- Arquiteto responsável: [nome]
- Responsável de segurança: [nome]

## Convenções e restrições

### Padrões do time
<!-- prime-core/coding-standards › Padrões do time: versionados e fixados. -->
- Release do Apex Prime: [tag]

### Registro de áreas
<!-- prime-core/coding-standards › Legado (estado) e prime-core/quality-model › Calibração (nível). Caminho — estado — nível. Não registrada: current e padrão. -->
- `src/main/java/com/acme/app/**` — current — padrão
- `src/main/java/com/acme/app/**/pagamento/**` — current — crítica
- `src/main/java/com/acme/app/batch/**` — legacy-maintained (jobs anteriores ao padrão; os invariantes se aplicam) — padrão
- `src/main/java/com/acme/app/service/**` — strangler (camadas anteriores ao hexágono, substituídas pelos casos de uso em `application`; MIG-007) — padrão
- `src/main/java/com/acme/app/promo/blackfriday/**` — current — efêmera (remover após 2026-12-15; ITEM-482)

Exclusões:
- `src/main/java/com/acme/app/adapter/out/http/parceiro/generated/**` — gerado pelo openapi-generator a partir de `api/parceiro.yaml`
<!-- Ou: "nenhuma" -->

### Overrides de slots
<!-- prime-core/coding-standards › Overrides por área e por nível. Slot — alcance — valor — razão. -->
- `CS-SC-5` — nível `crítica` — OWASP ASVS 5.0 Nível 3 — modelo de ameaças regulatório dos pagamentos
- `CS-RS-1` — área `**/pagamento/**` — leitura HTTP de 15 s no cliente do adquirente — o adquirente responde em até 12 s (p99), por contrato
- `CS-EV-1` — projeto — todo comportamento novo voltado ao usuário sai atrás de uma flag — o produto libera por região
<!-- Ou: "nenhum — valem os padrões do time" -->

### Soluções e exemplos canônicos
<!-- prime-core/coding-standards › CS-PR-1. Problema ou slot — arquivo que mostra a forma certa. -->
- Chamada a outro serviço (`CS-PR-1`, `CS-RS-1`) — `src/main/java/com/acme/app/adapter/out/http/AcquirerClient.java`
- Consumidor idempotente (`CS-DA-2`) — `src/main/java/com/acme/app/adapter/in/messaging/OrderPaidListener.java`
- Publicação por outbox (`CS-DA-6`) — `src/main/java/com/acme/app/adapter/out/messaging/OrderEventPublisher.java`
- Tradução de erro na fronteira (`CS-ER-3`) — `src/main/java/com/acme/app/adapter/in/web/ApiExceptionHandler.java`
- Caso de uso com portas (`CS-NM-1`, `CS-AR-1`) — `src/main/java/com/acme/app/application/service/ConfirmOrderService.java`
<!-- Ou: "nenhum declarado ainda" -->

### Migrações declaradas
<!-- prime-core/coding-standards › Migrações declaradas: os cinco campos. -->
- **MIG-007** — slot `CS-AR-1`: camadas (controller → service → repository) → hexagonal.
  Responsável: [nome]. Escopo: `src/main/java/com/acme/app/service/**`.
  Detecção: teste ArchUnit congelado (`FreezingArchRule`) que conta as violações da arquitetura hexagonal no escopo; a contagem só cai.
  Concluída quando: zero violações e o pacote `service` removido.
<!-- Ou: "nenhuma em andamento" -->

### Postura do modelo de qualidade
<!-- prime-core/quality-model › Overrides do projeto. O nível de cada área fica no Registro de áreas. -->
- Inegociável adicionado: nenhum relatório consulta o banco primário — relatórios leem da réplica de leitura
- Calibrado endurecido: em todos os níveis, cada meta não funcional tem métrica e alerta em produção
- Postura permanente: `service` está em migração (MIG-007) — siga seus padrões locais, não os estenda; capacidade nova nasce nos casos de uso de `application`
<!-- Ou: "nenhuma declarada ainda" -->

### Regras do projeto
<!-- prime-core/prime-config › Regras do projeto. Só o que nenhum slot pergunta. -->
- Mudanças em `**/pagamento/**` têm o responsável de segurança na revisão.
- Dados de clientes permanecem na região `sa-east-1`; nenhuma fixture de teste carrega registros de produção.
- Sem deploy entre os dias 25 e 1º — a janela de fechamento do faturamento.
<!-- Ou: "nenhuma declarada ainda" -->

## Tracker
<!-- Seção opcional. prime-core/prime-config › Tracker. -->
- Identificador de story: `S-NNN` (por exemplo, S-127)
- Link da story: `https://dev.azure.com/acme/app/_workitems/edit/{id}`
- Item de backlog (dívida, teste desativado, flag): `ITEM-NNN`

## Pipeline (Azure DevOps)
<!-- Seção opcional. prime-core/prime-config › Pipeline. Omita em projetos sem pipeline. -->
- Plataforma dos PRs: Azure DevOps (Azure Repos)
- Validação de PR: [nome do pipeline]
- Verificações obrigatórias antes do merge:
  - build e testes (`./mvnw clean verify`), com o teste de arquitetura (ArchUnit)
  - formatação (Spotless)
  - análise estática: Error Prone com NullAway, SpotBugs com find-sec-bugs, Semgrep
  - Maven Enforcer (`banDynamicVersions`, dependências banidas)
  - varredura de segredos (gitleaks) e de dependências; SBOM (CycloneDX)
  - comparação do OpenAPI e testes de contrato
  - `@Disabled` sem item do tracker
- Políticas de PR: revisor obrigatório — o arquiteto responsável; resolução de comentários — obrigatória
- Fluxo de deploy após o merge: [estágios]
````

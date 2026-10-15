# Template do Prime Config

Template canônico de propriedade do prime-core/prime-config. O SKILL.md define quais seções são obrigatórias, as regras de precedência e o procedimento de bootstrap — este arquivo é a estrutura. Substitua os valores de exemplo (mostrados para um projeto Java/Spring) pelos fatos do projeto-alvo; não apague nada obrigatório.

````markdown
# Configuração do Prime — [Nome do Projeto]

Este arquivo é lido por toda skill do Apex Prime (todas as camadas) como primeiro passo,
conforme o contrato prime-core/prime-config. Mantenha-o versionado junto com o código que
descreve. Os valores explícitos aqui têm precedência sobre tudo o que as skills detectam
automaticamente; se este arquivo divergir dos arquivos de build, as skills vão sinalizar.

## Stack
<!-- Um projeto com mais de um componente declara uma Stack por componente
     (### Serviço, ### Cliente web, ...), cada uma com seu tipo. -->
- Tipo de componente: serviço
- Linguagem: Java 17
- Framework: Spring Boot 3.2.x
- Build: Maven (`./mvnw`)
- Banco de dados: PostgreSQL 15
- Migrações: Flyway, em `src/main/resources/db/migration`, versionadas `V<n>__descricao.sql`
- Mensageria: RabbitMQ (spring-amqp)

## Estrutura
- Arquitetura: hexagonal (portas e adaptadores), um contexto delimitado por serviço
- Domínio (modelo e regras de negócio): `src/main/java/com/acme/app/domain`
- Aplicação (casos de uso): `src/main/java/com/acme/app/application` — portas de entrada em `port/in`, portas de saída em `port/out`, serviços em `service`
- Adaptadores de entrada: `src/main/java/com/acme/app/adapter/in` — `web` (controllers, DTOs), `messaging` (listeners), `scheduling` (jobs)
- Adaptadores de saída: `src/main/java/com/acme/app/adapter/out` — `persistence` (repositórios, entidades JPA), `http` (clientes de outros serviços), `messaging` (publishers, outbox)
- Montagem do hexágono: `src/main/java/com/acme/app/config`
- Testes unitários: `src/test/java`
- Testes de integração: `src/test/java/**/*IT.java` (Testcontainers)

## Convenções e restrições

<!-- Esta seção é o lar de tudo o que o prime-core/coding-standards e o
     prime-core/quality-model declaram como ponto de override do projeto. As sete
     subseções abaixo são lidas pelo its-generator, pelo its-implementation e pelo
     code-review; mantenha-as mesmo vazias, com um "nenhuma declarada ainda" explícito.
     Regras do projeto em prosa livre que não se encaixam em nenhum slot ficam em
     "Regras do projeto". -->

### Padrões do time
<!-- Conforme prime-core/coding-standards › Padrões do time: versionados e fixados. A
     release do Apex Prime (a tag) cujos catálogos e padrões do time o projeto segue —
     a mesma que o manifesto da instalação (apex-prime.json) registra. Subir a release é
     uma decisão do projeto: para cada valor de padrão que mudou entre as duas tags,
     declare uma migração ou registre as áreas afetadas como legacy-maintained. -->
- Release do Apex Prime: [tag]

### Registro de áreas
<!-- Conforme prime-core/coding-standards › Legado: o registro de áreas (o estado) e
     prime-core/quality-model › Calibração (o nível de criticidade). Leia os dois antes de
     preencher. Uma linha por área: caminho — estado — nível. Área não registrada é
     current e padrão. Um nível efêmera leva a condição de remoção. Nunca infira estado
     nem nível de nomes de diretórios ou da idade dos arquivos. -->
- `src/main/java/com/acme/app/**` — current — padrão
- `src/main/java/com/acme/app/payments` — current — crítica
- `src/main/java/com/acme/app/billing` — legacy-maintained (convenções pré-2023; os invariantes se aplicam) — padrão
- `src/main/java/com/acme/app/legacy` — strangler (substituído por `billing.v2`; MIG-003) — padrão
- `src/main/java/com/acme/app/promo/blackfriday` — current — efêmera (remover após 2026-12-15; ITEM-482)

Exclusões — código gerado ou de terceiros, não editado à mão; a mudança vai para a origem:
- `src/main/java/com/acme/app/partner/client/**` — gerado pelo openapi-generator a partir de `api/partner.yaml`
<!-- Ou: "nenhuma" -->

### Overrides de slots
<!-- Conforme prime-core/coding-standards › Overrides por área e por nível. Uma linha por
     slot em que este projeto decide diferente dos padrões do time da release fixada: o ID
     do slot, o alcance (projeto, uma área ou um nível de criticidade), o valor e a razão.
     O mais específico vence. "Não se aplica — motivo" é um valor válido. Um slot sem
     padrão nem override é tratado conforme a seção "Slots não preenchidos" dessa skill.
     Escreva "nenhum — valem os padrões do time" quando for o caso. -->
- `CS-SC-5` — nível `crítica` — OWASP ASVS 5.0 Nível 3 — modelo de ameaças regulatório dos pagamentos
- `CS-RS-1` — área `payments` — leitura HTTP de 15 s no cliente do adquirente — o adquirente responde em até 12 s (p99), por contrato
- `CS-EV-1` — projeto — todo comportamento novo voltado ao usuário sai atrás de uma flag — o produto libera por região
<!-- Ou, se nada for sobrescrito: "nenhum — valem os padrões do time (defaults-java, na release fixada)" -->

### Soluções e exemplos canônicos
<!-- Conforme prime-core/coding-standards (CS-PR-1 e "O que é um slot"). O registro de
     soluções canônicas do projeto e, por slot convencional, o arquivo que mostra a forma
     certa. Quem implementa copia a forma; a ITS pode apontar para o arquivo. -->
- Chamada a outro serviço (`CS-PR-1`, `CS-RS-1`) — `src/main/java/com/acme/app/adapter/out/http/AcquirerClient.java`
- Consumidor idempotente (`CS-DA-2`) — `src/main/java/com/acme/app/adapter/in/messaging/OrderPaidListener.java`
- Publicação por outbox (`CS-DA-6`) — `src/main/java/com/acme/app/adapter/out/messaging/OrderEventPublisher.java`
- Tradução de erro na fronteira (`CS-ER-3`) — `src/main/java/com/acme/app/adapter/in/web/ApiExceptionHandler.java`
- Caso de uso com portas (`CS-NM-1`, `CS-AR-1`) — `src/main/java/com/acme/app/application/service/ConfirmOrderService.java`
<!-- Ou: "nenhum declarado ainda" -->

### Migrações declaradas
<!-- Conforme prime-core/coding-standards › Migrações declaradas, que define os cinco
     campos obrigatórios, no que a ausência de um deles transforma esta entrada e o que
     acontece com uma migração que para de avançar. Uma entrada por migração em
     andamento, no formato abaixo. -->
- **MIG-003** — slot `CS-AR-4`: empacotamento por camada técnica → empacotamento por feature.
  Responsável: [nome]. Escopo: `src/main/java/com/acme/app/legacy` → `billing.v2`.
  Detecção: teste ArchUnit que conta as classes sob `com.acme.app.legacy`; a contagem só cai.
  Concluída quando: nenhum tráfego de produção alcançar `legacy` e o pacote for removido.
<!-- Ou: "nenhuma em andamento" -->

### Postura do modelo de qualidade
<!-- Conforme prime-core/quality-model › Overrides do projeto, que declara exatamente o
     que esta seção pode adicionar ou endurecer, que postura permanente ela pode
     registrar e o que ela nunca pode dispensar aqui. O nível de criticidade de cada área
     fica no Registro de áreas, não aqui. Leia-o antes de adicionar uma linha. -->
- Inegociável adicionado: nenhum relatório consulta o banco primário — relatórios leem da réplica de leitura
- Calibrado endurecido: em todos os níveis, cada meta não funcional tem métrica e alerta em produção
- Postura permanente: `legacy` está em migração strangler-fig (MIG-003) — siga seus padrões
  locais, não os estenda; capacidade nova nasce em `billing.v2`
<!-- Ou: "nenhuma declarada ainda" -->

### Regras do projeto
<!-- Regras que restringem todo plano e toda revisão e não se mapeiam em nenhum slot. Se o
     catálogo de slots já faz a pergunta — direção das camadas, representação de erros, o
     que obriga um teste, a fronteira de serialização, feature flags — a resposta pertence
     a Overrides de slots, ou a lugar nenhum quando o padrão da stack já a diz. Escrevê-la
     também aqui é como as duas cópias se descolam. -->
- `payments` nunca é alterado sem o responsável de segurança na revisão.
- Dados de clientes permanecem na região `sa-east-1`; nenhuma fixture de teste carrega registros de produção.
- Sem deploy entre os dias 25 e 1º — a janela de fechamento do faturamento.
<!-- Se nada foi declarado ainda, escreva "nenhuma declarada ainda" — nunca omita a subseção. -->

## Repositório de documentos
- Casos de uso: `docs/use-cases/UC-NNN-titulo-curto.md`
- ITS: `docs/its/ITS-<story-id>-titulo-curto.wiki`
- ADRs (registros de decisão de arquitetura): `docs/adr/ADR-NNN-titulo-curto.md`
  <!-- Sequenciais, nunca renumerados. Estrutura, ciclo de vida e quem redige são definidos pelo
       prime-core/its-contract (fronteira de decisão) e seu templates/adr-template.md -->
- Template de caso de uso customizado: nenhum (usar o padrão que acompanha a skill)
  <!-- Para sobrescrever: aponte para p. ex. docs/use-cases/TEMPLATE.md e liste as seções obrigatórias extras -->
- Seções obrigatórias extras de caso de uso: nenhuma
  <!-- Exemplo: "Requisitos de auditoria" para projetos sob compliance -->

## Comandos de verificação
- Build completo com testes: `./mvnw clean verify`
- Apenas testes unitários: `./mvnw test`
- Uma única classe de teste: `./mvnw test -Dtest=NomeDaClasse`

## Identificadores de story
<!-- Seção opcional. Padrão quando ausente: S-NNN. -->
- Formato: `S-NNN` (p. ex., S-127), igual ao ID do tracker

## Pipeline (Azure DevOps)
<!-- Seção opcional. Omita em projetos sem pipeline. -->
- Build de validação de PR: [nome do pipeline / gatilho]
- Verificações obrigatórias antes do merge: [build, testes, quality gates]
- Fluxo de deploy após o merge: [estágios]
  <!-- Referenciado por prime-dev/pr-preparation e prime-architect/code-review -->
````

# Template do Prime Config

Template canônico de propriedade do prime-core/prime-config. O SKILL.md define quais seções são obrigatórias, as regras de precedência e o procedimento de bootstrap — este arquivo é a estrutura. Substitua os valores de exemplo (mostrados para um projeto Java/Spring) pelos fatos do projeto-alvo; não apague nada obrigatório.

````markdown
# Configuração do Prime — [Nome do Projeto]

Este arquivo é lido por toda skill do Apex Prime (todas as camadas) como primeiro passo,
conforme o contrato prime-core/prime-config. Mantenha-o versionado junto com o código que
descreve. Os valores explícitos aqui têm precedência sobre tudo o que as skills detectam
automaticamente; se este arquivo divergir dos arquivos de build, as skills vão sinalizar.

## Stack
- Linguagem: Java 17
- Framework: Spring Boot 3.2.x
- Build: Maven (`./mvnw`)
- Banco de dados: PostgreSQL 15
- Migrações: Flyway, em `src/main/resources/db/migration`, versionadas `V<n>__descricao.sql`
- Mensageria: RabbitMQ (spring-amqp)

## Estrutura
- Domínio / regras de negócio: `src/main/java/com/acme/app/domain`
- Camada de API (controllers, DTOs): `src/main/java/com/acme/app/api`
- Serviços de aplicação: `src/main/java/com/acme/app/service`
- Persistência (repositórios, entidades): `src/main/java/com/acme/app/persistence`
- Consumidores de mensageria: `src/main/java/com/acme/app/messaging`
- Testes unitários: `src/test/java`
- Testes de integração: `src/test/java/**/*IT.java` (Testcontainers)

## Convenções e restrições

<!-- Esta seção é o lar de tudo o que o prime-core/coding-standards e o
     prime-core/quality-model declaram como ponto de override do projeto. As cinco
     subseções abaixo são lidas pelo its-generator, pelo its-implementation e pelo
     code-review; mantenha-as mesmo vazias, com um "nenhuma declarada ainda" explícito.
     Regras do projeto em prosa livre que não se encaixam em nenhum slot ficam em
     "Regras do projeto". -->

### Registro de áreas
<!-- Conforme prime-core/coding-standards › Legado: o registro de áreas. Leia-o antes
     de preencher: ele define os três estados, a regra de que a classificação é
     declarada e nunca inferida, e o que significa uma área não registrada. Uma linha
     por área, com o estado nomeado em suas próprias palavras. -->
- `src/main/java/com/acme/app/**` — current
- `src/main/java/com/acme/app/billing` — legacy-maintained (convenções pré-2023; os invariantes se aplicam)
- `src/main/java/com/acme/app/legacy` — strangler (substituído por `billing.v2`; MIG-003)

### Overrides de slots
<!-- Conforme prime-core/coding-standards. Uma linha por slot em que este projeto decide
     diferente de references/defaults-<stack>.md. Cite o ID do slot — o valor declarado
     aqui vence o padrão do time. Um slot sem padrão nem override é tratado conforme a
     seção "Slots não preenchidos" dessa skill. Escreva "nenhum — valem os padrões do
     time" quando for o caso. -->
- `CS-CT-2` — paginação por cursor (`cursor`/`limit`) em `/api/v1/events`; paginação por página em todo o resto
- `CS-SC-5` — OWASP ASVS Nível 3 para o módulo de pagamentos (modelo de ameaças regulatório)
<!-- Ou, se nada for sobrescrito: "nenhum — valem os padrões do time (defaults-java.md)" -->

### Migrações declaradas
<!-- Conforme prime-core/coding-standards › Migrações declaradas, que define os campos
     obrigatórios, no que a ausência de um deles transforma esta entrada e o que
     acontece com uma migração que para de avançar. Uma entrada por migração em
     andamento, no formato abaixo. -->
- **MIG-003** — slot `CS-AR-4`: empacotamento por camada técnica → empacotamento por feature.
  Responsável: [nome]. Escopo: `src/main/java/com/acme/app/legacy` → `billing.v2`.
  Concluída quando: nenhum tráfego de produção alcançar `legacy` e o pacote for removido.
<!-- Ou: "nenhuma em andamento" -->

### Postura do modelo de qualidade
<!-- Conforme prime-core/quality-model › Overrides do projeto, que declara exatamente o
     que esta seção pode adicionar ou endurecer, que postura permanente ela pode
     registrar e o que ela nunca pode dispensar aqui. Leia-o antes de adicionar uma linha. -->
- Inegociável adicionado: todo endpoint que toca dados de pagamento carrega uma entrada de log de auditoria
- Postura permanente: `legacy` está em migração strangler-fig (MIG-003) — siga seus padrões
  locais, não os estenda; capacidade nova nasce em `billing.v2`
<!-- Ou: "nenhuma declarada ainda" -->

### Regras do projeto
<!-- Regras que restringem todo plano e toda revisão e não se mapeiam em nenhum slot. Se o
     catálogo de slots já faz a pergunta — direção das camadas, representação de erros, o
     que obriga um teste, a fronteira de serialização — a resposta pertence a Overrides
     de slots, ou a lugar nenhum quando o padrão da stack já a diz. Escrevê-la também aqui
     é como as duas cópias se descolam. -->
- Feature flags via `@ConditionalOnProperty`; todo comportamento novo voltado ao usuário sai atrás de uma flag.
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

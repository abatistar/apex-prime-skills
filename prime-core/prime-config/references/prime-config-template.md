# Template do Prime Config

Template canônico de propriedade do prime-config. O SKILL.md define as seções, a validação e o bootstrap; o `references/consumer-rules.md` define a leitura sob demanda, a precedência, as divergências e o ciclo de vida. Este arquivo é a estrutura.

Substitua os valores de exemplo — mostrados para um microsserviço Java/Spring — pelos fatos do projeto-alvo. Não apague nenhuma das cinco seções: Stack, Estrutura, Repositório de documentos, Comandos de verificação e Opções.

O arquivo do projeto guarda fatos. Os comentários abaixo são ponteiros de uma linha para o contrato que define cada seção. Não acrescente explicações a eles.

````markdown
# Configuração do Prime — [Nome do Projeto]

Fatos deste projeto, conforme o prime-config. As skills leem a seção de que precisam,
quando precisam. Versionado com o código. Explícito aqui vence o que as skills detectam;
divergência com os arquivos de build é reportada.

## Stack
<!-- prime-config › Seções. Mais de um componente: uma Stack por componente, cada uma com seu tipo. -->
- Tipo de componente: serviço
- Linguagem: Java 25
- Framework: Spring Boot 4.1
- Build: Maven (`./mvnw`)
- Banco de dados: PostgreSQL 17
- Migrações: Flyway, em `src/main/resources/db/migration`
- Mensageria: RabbitMQ (spring-amqp)

## Estrutura
<!-- prime-config › Seções. Um elemento por linha, com o pacote que o representa; é o que o teste de arquitetura verifica. -->
- Arquitetura: hexagonal (portas e adaptadores)
- Domínio: `src/main/java/com/acme/app/domain`
- Aplicação: `src/main/java/com/acme/app/application` — portas de entrada em `port/in`, portas de saída em `port/out`, serviços em `service`
- Adaptadores de entrada: `src/main/java/com/acme/app/adapter/in` — `web`, `messaging`, `scheduling`
- Adaptadores de saída: `src/main/java/com/acme/app/adapter/out` — `persistence`, `http`, `messaging`
- Montagem: `src/main/java/com/acme/app/config`
- Testes unitários: `src/test/java`; de integração: `src/test/java/**/*IT.java`
<!-- Legado (Opções): declare a arquitetura que existe de fato, por exemplo camadas controller → service → repository. -->

## Repositório de documentos
<!-- prime-config › Seções. Raiz: `docs` (no repositório) ou pasta paralela, versionada à parte. -->
- Raiz de documentos: `../app-docs` (pasta paralela ao projeto, com repositório próprio)
- Casos de uso: `use-cases/UC-NNN-titulo-curto.md`
- ITS: `its/ITS-<story-id>-titulo-curto.md`
- ADRs: `adr/ADR-NNN-titulo-curto.md`
- Template de caso de uso customizado: nenhum
- Seções obrigatórias extras de caso de uso: nenhuma

## Comandos de verificação
<!-- prime-config › Seções. Só comandos que o projeto tem de fato. -->
- Build completo com testes: `./mvnw clean verify`
- Apenas testes unitários: `./mvnw test`
- Uma única classe de teste: `./mvnw test -Dtest=NomeDaClasse`
- Teste de arquitetura: `./mvnw test -Dtest=ArchitectureTest`
- Mutação: `./mvnw org.pitest:pitest-maven:mutationCoverage`

## Opções
<!-- prime-config › Opções. Valores fechados; uma opção ausente vale o padrão. -->
- Legado: false
- Template da ITS: Markdown
````

Projetos podem acrescentar seções próprias depois destas. Nenhuma skill as apaga.

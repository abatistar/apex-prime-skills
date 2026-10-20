# DP — Dependências de terceiros (Java)

Padrões do time para a stack Java nesta família de slots, de propriedade do `prime-core/coding-standards`. Lidos junto com o índice, `references/defaults-java.md`, que guarda como ler as marcas (Spring), (Boot 4) e (Java 21+), a Plataforma e a Toolchain do time. As definições dos slots estão no arquivo de mesmo nome em `references/convention-slots/`.

- **CS-DP-1** — Uma nova dependência declara o problema que resolve, por que a plataforma ou uma dependência existente não o resolve, sua atividade de releases e sua licença. As coordenadas são copiadas da página oficial do projeto e conferidas no Maven Central — nunca digitadas de memória. A versão é fixa: sem faixas, sem `LATEST`/`RELEASE`, sem SNAPSHOT em artefato entregue; quando o Spring Boot gerencia a dependência, vale a versão dele. Aprovada pelo arquiteto. *Razão:* geradores de código inventam nomes de pacote plausíveis, e versão dinâmica muda o artefato sem mudar o código. *Verificação:* Maven Enforcer (`banDynamicVersions`); revisão da admissão.
- **CS-DP-2** — Uma biblioteca por preocupação:
  - tempo: `java.time`;
  - JSON: Jackson — o Jackson 3 (`tools.jackson`) no Boot 4; a passagem do Jackson 2 para o 3 é uma migração declarada, nunca uma convivência sem prazo;
  - logging: SLF4J;
  - HTTP de saída: `RestClient` e os clientes de serviço HTTP do Spring; o `RestTemplate` não entra em código novo — está descontinuado a partir do Spring Framework 7.1;
  - infraestrutura de teste de integração: Testcontainers;
  - resiliência: o suporte nativo do Spring Framework 7 para repetição e limite de concorrência **(Boot 4)**, e o Resilience4j para circuit breaker — e também para repetição no Boot 3.

  Joda-Time, Gson, `java.util.Date` e o tratamento de datas do Apache Commons não são introduzidos. *Razão:* é assim que uma base acaba com três bibliotecas de data. *Verificação:* Maven Enforcer (dependências banidas).
- **CS-DP-3** — Nenhum release sai com um alerta alto ou crítico aberto. O Renovate mantém as versões andando; a varredura roda no pipeline. O build gera o SBOM CycloneDX (`cyclonedx-maven-plugin`, com a versão gerenciada pelo Spring Boot), empacotado no artefato **(Spring)**. Uma exceção segue o registro de exceção do `quality-model` — com prazo e responsável —, nunca um comentário de supressão que ninguém revisita. *Razão:* a localização de uma dependência vulnerável é pública, e sem SBOM ninguém responde rápido "onde usamos isto?". *Verificação:* varredura de dependências e geração do SBOM no pipeline.

# Template da ITS — Markdown: a mesma unidade nos três níveis

Parte do template `its-template-markdown.md`, de propriedade do its-contract. O its-generator lê este arquivo só quando o nível de detalhe pedido é `simplificado` ou `médio`: no `detalhista`, o bloco principal do template já mostra a unidade com todos os campos. Uma mudança de conteúdo aqui é feita também no arquivo de níveis do outro formato.

Exemplo da unidade que atende ao item `D1` do bloco principal do template. Só os campos que o nível muda aparecem em cada bloco; os que são iguais nos três aparecem uma vez, no fim. As exigências são as mesmas em todos: a condição da recusa, o código do erro, o HTTP 422, a assinatura fixada e os dois testes.

`simplificado` — só o que carrega exigência; sem Arquivos, sem Casos de borda, sem Como verificar:

````text
### 1. Recusar a confirmação acima do limite de crédito

**O que fazer:**

1. `CreditPolicy` (criar), no domínio — expor `allows` com a assinatura de Trechos fixados.
2. `ConfirmOrderService.confirm(ConfirmOrderCommand)` — quando `creditPolicy.allows` recusar o total do pedido contra o limite de crédito vigente do cliente, lançar `BusinessException` com o código `CREDIT_LIMIT_EXCEEDED` e não gravar o pedido.
3. `ApiExceptionHandler` — mapear `CREDIT_LIMIT_EXCEEDED` para HTTP 422, em `ProblemDetail` com o membro `code` e o detalhe "Limite de crédito excedido".
````

`médio` — a sequência por componente, os pontos de integração e os casos de borda nomeados:

````text
### 1. Recusar a confirmação acima do limite de crédito

**Arquivos:**

1. `src/main/java/com/acme/app/application/service/ConfirmOrderService.java` (modificar)
2. `src/main/java/com/acme/app/adapter/in/web/ApiExceptionHandler.java` (modificar)
3. `src/test/java/com/acme/app/application/service/ConfirmOrderServiceTest.java` (modificar)

**O que fazer:**

1. `CreditPolicy` (criar), no domínio — expor `allows` com a assinatura de Trechos fixados, sem depender de nada fora do domínio.
2. `ConfirmOrderService.confirm(ConfirmOrderCommand)` — antes de `saveOrderPort.save`, ler o limite vigente pela porta existente `LoadCustomerCreditPort` e, quando `creditPolicy.allows` recusar o total do pedido, lançar `BusinessException` com o código `CREDIT_LIMIT_EXCEEDED` e não gravar o pedido.
3. `ApiExceptionHandler` — no tratador de `BusinessException` que a classe já tem, mapear `CREDIT_LIMIT_EXCEEDED` para HTTP 422, em `ProblemDetail` com o membro `code` e o detalhe "Limite de crédito excedido".

**Casos de borda:**

- total do pedido igual ao limite
- limite do cliente alterado depois da criação do pedido
````

`detalhista` — o passo a passo, todos os arquivos, o comportamento de cada caso de borda e a verificação:

````text
### 1. Recusar a confirmação acima do limite de crédito

**Arquivos:**

1. `src/main/java/com/acme/app/application/service/ConfirmOrderService.java` (modificar)
2. `src/main/java/com/acme/app/adapter/in/web/ApiExceptionHandler.java` (modificar)
3. `src/main/java/com/acme/app/domain/CreditPolicy.java` (criar)
4. `src/test/java/com/acme/app/application/service/ConfirmOrderServiceTest.java` (modificar)

**O que fazer:**

1. `CreditPolicy` (criar), no domínio — expor `allows` com a assinatura de Trechos fixados:
   - devolver verdadeiro quando o total for menor ou igual ao limite;
   - não depender de nenhum tipo fora do domínio.
2. `ConfirmOrderService` — receber `LoadCustomerCreditPort` pelo construtor e manter uma instância de `CreditPolicy`.
3. `ConfirmOrderService.confirm(ConfirmOrderCommand)` — antes de `saveOrderPort.save`:
   - ler o limite vigente com `loadCustomerCreditPort.load(customerId)`;
   - quando `creditPolicy.allows(order.getTotal(), limit)` for falso, lançar `BusinessException` com o código `CREDIT_LIMIT_EXCEEDED` e não gravar o pedido.
4. `ApiExceptionHandler` — no tratador de `BusinessException` que a classe já tem, mapear `CREDIT_LIMIT_EXCEEDED` para HTTP 422, em `ProblemDetail` com o membro `code` e o detalhe "Limite de crédito excedido".

**Casos de borda:**

- total do pedido igual ao limite → o pedido é confirmado e gravado (RG-1)
- limite do cliente alterado depois da criação do pedido → vale o limite lido no momento da confirmação (D1)

**Como verificar:** executar `./mvnw test -Dtest=ConfirmOrderServiceTest`; os testes desta unidade passam.
````

Iguais nos três. No documento, cada campo ocupa a posição que o bloco principal mostra: Trechos fixados logo depois de O que fazer, Atende e Testes depois de Casos de borda, Como verificar depois de Testes.

````text
**Trechos fixados:**

Instrução 1 — assinatura de `CreditPolicy.allows`:

```java
boolean allows(BigDecimal orderTotal, BigDecimal creditLimit)
```

**Atende:** D1

**Testes:**

1. pedido com total acima do limite recebe HTTP 422 com o código `CREDIT_LIMIT_EXCEEDED` e a mensagem "Limite de crédito excedido", e nenhum pedido é gravado (D1)
2. pedido com total igual ao limite é confirmado e gravado (RG-1)
````

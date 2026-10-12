# Template de Caso de Uso

Este é o template canônico — a cópia única, de propriedade do prime-architect/use-case. Se o `prime-config.md` do projeto declarar um caminho de template customizado ou seções obrigatórias adicionais, a configuração do projeto tem precedência.

**Idioma.** O bloco do artefato abaixo é o documento que quem escreve produz, e é escrito no idioma de documento deste formato: `pt-BR`. Os títulos de seção fazem parte do artefato e por isso são traduzidos; os **tokens estáveis** que este formato declara — identificadores (`UC-NNN`, `RN-N`, `CA-N`, `S-NNN`), valores de status (`Draft`, `Reviewed`), os marcadores de incerteza (`[INFERRED]`, `[CONFIRM: ...]`), padrões de nomenclatura de arquivo e caminhos — nunca são traduzidos, em nenhum idioma.

## Convenção de nomenclatura de arquivo

`docs/use-cases/UC-NNN-titulo-curto.md` (p. ex., `UC-042-exportar-relatorio-pdf.md`). `NNN` é um número sequencial com zeros à esquerda, estável durante toda a vida do documento. Nunca renumere casos de uso existentes. O slug segue o idioma do documento; o prefixo `UC-NNN` não.

## Estabilidade dos identificadores internos

Os identificadores de dentro do documento são citados de fora dele — pelo delta, pela ITS (`UC-042/RN-3`), pelo code review (`UC-042/CA-2`) e por outros casos de uso. Por isso:

- **`RN-N` e `CA-N` nunca são renumerados nem reaproveitados.** Uma regra ou um critério removido permanece na seção como lápide — `**RN-4:** removida (S-NNN)` —, para que o número não volte a ser usado e citações antigas continuem resolvendo. Um item novo recebe o número seguinte ao maior já usado no documento.
- **Passos e extensões são posicionais.** Podem ser renumerados quando a sequência muda, e o rótulo de cada extensão acompanha o passo a que se liga. Toda renumeração é declarada na entrada do Histórico de revisões, e o delta cita a numeração resultante (ex.: "Adicionado passo 4; passos 4–6 renumerados para 5–7; extensão 4a passa a 5a"). Renumerar passos exige verificar as referências a eles em outros casos de uso.

## Document structure

````markdown
# UC-NNN — [Título do caso de uso]

| Campo | Valor |
|---|---|
| **ID** | UC-NNN |
| **Nome** | O objetivo do ator principal, em verbo + objeto (ex.: *Comprar mercadoria*) |
| **Escopo** | O sistema em consideração (sistema de software, subsistema ou organização) |
| **Nível** | Resumo · Objetivo de usuário · Subfunção |
| **Atores** | Quem tem o objetivo que este caso de uso satisfaz (ator principal; atores secundários, se houver) |
| **Casos de uso relacionados** | Links UC-XXX, ou "nenhum". Recíproco: todo UC-XXX citado aqui também cita este documento |
| **Status** | Draft · Reviewed |

## Envolvidos e interesses

[OPCIONAL — inclua apenas quando o insumo (story, PRD, elicitação, código) revelar interesses dos envolvidos. Omita a seção inteira em vez de inventar conteúdo.]

- **<Envolvido 1>**: <o que espera que o sistema proteja ou garanta>
- **<Envolvido 2>**: <interesse>

## Condições

**Pré-condições**
<O que precisa ser verdade antes de o caso de uso começar — e que o caso de uso não precisa verificar.>

**Garantias mínimas**
<O que o sistema garante aos envolvidos mesmo se o caso de uso falhar. Ex.: registro de auditoria.>

**Garantias de sucesso**
<O estado do mundo depois que o caso de uso termina com sucesso.>

## Cenário principal de sucesso

1. <Ator> <ação no presente simples, voz ativa>.
2. <Sistema> <ação, citando a regra que a governa quando houver — ex.: conforme RN-1>.
3. <Ator> <ação>.
4. <Sistema> <ação>.
5. <Sistema> <ação que conclui o objetivo>.

## Extensões

[Toda extensão fecha com um desfecho explícito: retorna a um passo numerado ou encerra o caso
de uso, em sucesso ou em falha. Extensão sem desfecho é defeito, não abreviação.]

- **2a.** <Condição alternativa ou de falha no passo 2>:
  - 2a1. <Ação de tratamento>.
  - 2a2. <Retorna ao passo X | Caso de uso termina em falha>.
- **4a.** <Condição>:
  - 4a1. <Ação>.
  - 4a2. <Retorna ao passo X | Caso de uso termina em falha>.
- ***a.** <Condição que pode ocorrer a qualquer momento>:
  - *a1. <Ação>.
  - *a2. <Retorna ao passo X | Caso de uso termina em falha>.

## Regras de negócio
- **RN-1:** [Regra referenciada pelos fluxos, enunciada de forma precisa e testável]
[Uma regra removida permanece como lápide — **RN-N:** removida (S-NNN). Números nunca são reaproveitados.]

## Critérios de aceite
- **CA-1:** Dado [contexto], quando [ação], então [resultado verificável]
[Todo critério precisa ser objetivamente verificável. Cubra o Cenário principal de sucesso e todas as extensões. Um critério removido permanece como lápide, como nas regras de negócio.]

## Diagrama UML (resumo gráfico)

[Regra de escopo: o diagrama mostra ESTE caso de uso, seus atores e suas relações diretas
apenas («include»/«extend» e casos de uso diretamente relacionados). Nunca é um mapa do
sistema inteiro — o repositório como um todo é o mapa. Atualize o diagrama sempre que uma
mudança nos fluxos alterar atores ou relações; atualizações apenas de diagrama NÃO são
itens de delta no Histórico de revisões (o diagrama é derivado dos fluxos — o delta é a
mudança de comportamento).]

```mermaid
flowchart LR
    ator([Ator principal])
    apoio([Ator de apoio])

    subgraph sistema["Escopo: <Sistema>"]
        uc(["UC-NNN <Este caso de uso>"])
        sub(["<Subfunção incluída>"])
    end

    ator --> uc
    uc -. «include» .-> sub
    uc --> apoio
```

## Histórico de revisões
| Rev | Story | Data | Resumo das alterações |
|-----|-------|------|-----------------------|
| 1 | S-NNN, "mapeamento inicial a partir do código" ou "reconciliação com o código" | AAAA-MM-DD | [Conforme o tipo da entrada — veja Regras do Histórico de revisões. Numa alteração: itens adicionados/alterados/removidos, referenciando identificadores de passo, extensão e seção — ex.: "Adicionada extensão 3b; alterado passo 5; removida RN-4"] |
[Uma entrada por story. Mantenha apenas as 5 entradas mais recentes. O histórico completo vive no controle de versão.]
````

## Ciclo de vida do status

- **Draft** — em elaboração, ou contendo marcadores de incerteza não resolvidos. Não é fonte de verdade.
- **Reviewed** — validado por um humano; todos os marcadores de incerteza resolvidos. Fonte de verdade do comportamento do sistema; entrada válida para o ITS Generator.

A promoção de Draft para Reviewed é sempre um ato humano — nenhuma skill promove o status por conta própria. Os valores de status são tokens estáveis: escrevem-se `Draft` e `Reviewed` seja qual for o idioma do documento.

O caminho inverso é regra, não julgamento: um documento `Reviewed` volta a `Draft` quando recebe uma entrada de alteração ou de reconciliação, ou um marcador de incerteza — o conteúdo novo ainda não foi validado. Quem escreve faz o rebaixamento; o arquiteto promove de novo depois de validar a mudança. Uma entrada de conformidade não rebaixa, porque o corpo do documento não muda; uma atualização apenas de diagrama ou do campo Casos de uso relacionados também não.

## Regras do Histórico de revisões

Toda entrada é de um dos tipos abaixo. O tipo decide o que vai nas colunas Story e Resumo e se a entrada é trabalho para o ITS Generator.

| Tipo | Quem escreve | Story | Resumo das alterações | Trabalho para o ITS Generator |
|---|---|---|---|---|
| Criação | Use Case Creator | ID da story | `Criação` | Sim — o documento inteiro é o delta |
| Alteração | Use Case Creator | ID da story | Itens adicionados/alterados/removidos, com os identificadores de passo, extensão e seção | Sim — os itens são o delta |
| Conformidade | Use Case Creator | ID da story | `Conformidade:` seguido dos identificadores que o código passa a cumprir — ex.: "Conformidade: o código passa a cumprir o passo 5 e o CA-3" | Sim — o corpo não muda; os identificadores citados são o delta |
| Mapeamento inicial | Use Case Extractor | `mapeamento inicial a partir do código` | O escopo mapeado | Não — é estado |
| Reconciliação | Use Case Creator | `reconciliação com o código` | O que mudou no corpo para descrever o código, como numa alteração | Não — o código já faz isso |

- **Uma entrada por story por documento.** Uma nova execução para a mesma story (p. ex., o ITS Generator devolveu o delta) reescreve a entrada existente com o delta consolidado contra o estado anterior à story; nunca acrescenta uma segunda. Uma entrada de criação continua `Criação`.
- **Story de origem ainda inexistente.** Quando o documento nasce ou muda a partir de um PRD ou de uma descrição sem story, a coluna Story leva o identificador da origem seguido de `[CONFIRM: story de origem]`. O documento fica em `Draft` até o ID da story substituir o marcador.
- **Não geram entrada:** atualizações apenas de diagrama ou do campo Casos de uso relacionados (derivadas dos fluxos e das relações entre documentos — valem inclusive para um documento fora do mapeamento da story, que recebe só o link recíproco) e a resolução de marcadores de incerteza (esclarece um documento que ainda não é fonte de verdade).

## Regras de qualidade

Aplique todas estas antes de considerar um documento pronto:

1. Nível de intenção, não de interface. Sem nomes de widgets de UI em cenários ou extensões.
2. Toda extensão tem um desfecho definido: ou retorna a um passo numerado ou encerra o caso de uso (em sucesso ou em falha). Sem extensões soltas.
3. Todo critério de aceite é verificável. Nada de "o sistema deve ser rápido" sem uma métrica.
4. O `Cenário principal de sucesso` e toda extensão têm um critério de aceite correspondente.
5. Toda regra de negócio (RN-N) referenciada em um cenário ou extensão existe na seção `Regras de negócio`, e toda regra da seção, exceto as lápides, é referenciada. Nenhum fluxo referencia uma lápide.
6. As `Garantias mínimas` declaram o que se mantém mesmo em caso de falha.
7. O diagrama UML cobre apenas este caso de uso e suas relações diretas, e é consistente com os campos `Atores` e `Casos de uso relacionados` e com as `Extensões`.
8. Toda entrada do `Histórico de revisões` segue um dos tipos das Regras do Histórico de revisões. As que são trabalho para o ITS Generator carregam o ID da story de origem e referenciam os identificadores de passo, extensão e seção afetados — o ITS Generator depende disso para localizar o delta. Atualizações apenas de diagrama nunca são itens de delta.
9. O documento é escrito de ponta a ponta no idioma de documento do formato, sem nenhum token estável traduzido (`RN-N` nunca vira `BR-N`, `Draft` nunca vira `Rascunho`).
10. O campo `Casos de uso relacionados` é recíproco: todo UC-XXX citado também cita este documento.
11. Nenhum `RN-N` ou `CA-N` foi renumerado ou reaproveitado, e toda renumeração de passos está declarada no Histórico de revisões (veja Estabilidade dos identificadores internos).

## Marcadores de incerteza

Marque todo conteúdo não verificado. Os marcadores em si são tokens estáveis e permanecem em inglês; o conteúdo deles segue o idioma do documento:

- `[INFERRED]` — exclusivo do Use Case Extractor: comportamento deduzido da estrutura do código, mas não confirmado por testes ou por envolvidos.
- `[CONFIRM: pergunta]` — uma pergunta em aberto que um humano precisa responder. O Use Case Extractor o usa para dúvidas sobre o código (p. ex., `[CONFIRM: o limite de 10 itens é regra de negócio ou restrição técnica?]`); o Use Case Creator, para o que a entrada e o arquiteto ainda não responderam (p. ex., a story de origem de um documento derivado de um PRD).

Um documento que contém marcadores de incerteza tem Status `Draft` e não deve ser tratado como fonte de verdade até que um humano resolva os marcadores e o promova a `Reviewed`. A resolução — aplicar as respostas do arquiteto ao documento — é feita pelo Use Case Creator, não gera entrada no Histórico de revisões e não promove o documento.
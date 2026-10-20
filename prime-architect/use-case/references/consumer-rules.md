# Regras para quem lê um caso de uso

Parte do formato do `prime-architect/use-case`, e a única que quem só lê um caso de uso precisa — o its-generator, o code-review e o impact-mapping: que seções um documento precisa ter, que identificadores são estáveis, o que cada status significa, como ler o Histórico de revisões e os marcadores de incerteza. Quem escreve um documento, ou o valida contra as regras de qualidade, lê também o template (`references/use-case-template.md`).

## Seções do documento

O template dá a forma de cada seção; esta lista diz quais um documento precisa ter. É o que quem só lê confere ao aceitar um documento como entrada.

- **Obrigatórias:** a tabela de metadados (ID, Nome, Escopo, Nível, Atores, Casos de uso relacionados, Status), Condições (Pré-condições, Garantias mínimas, Garantias de sucesso), Cenário principal de sucesso, Extensões, Regras de negócio, Critérios de aceite e Histórico de revisões.
- **Opcionais:** Envolvidos e interesses, só quando o insumo revela interesses; o Diagrama UML, só quando há relações a mostrar.
- **Do projeto:** as seções obrigatórias extras que a configuração declara em Repositório de documentos são obrigatórias como as de cima. Com um template customizado declarado ali, valem as seções dele.

## Estabilidade dos identificadores internos

Os identificadores de dentro do documento são citados de fora dele — pelo delta, pelas Referências da ITS, pelo code review (`UC-042/CA-2`) e por outros casos de uso. Por isso:

- **`RN-N` e `CA-N` nunca são renumerados nem reaproveitados.** Uma regra ou um critério removido permanece na seção como lápide — `**RN-4:** removida (S-NNN)` —, para que o número não volte a ser usado e citações antigas continuem resolvendo; o parêntese leva a origem da entrada que o removeu (o ID da story, ou `reconciliação com o código`). Um item que passa a outro documento numa reorganização também vira lápide, apontando o novo endereço — `**RN-4:** movida para UC-060/RN-1 (revisão editorial)`. Um item novo recebe o número seguinte ao maior já usado no documento.
- **Passos e extensões são posicionais.** Podem ser renumerados quando a sequência muda, e o rótulo de cada extensão acompanha o passo a que se liga. Toda renumeração é declarada na entrada do Histórico de revisões, e o delta cita a numeração resultante (ex.: "Adicionado passo 4; passos 4–6 renumerados para 5–7; extensão 4a passa a 5a"). Uma renumeração leva junto os rótulos dos critérios de aceite deste documento — atualização derivada, que não é item de delta — e exige verificar as referências aos passos em outros casos de uso.

## Ciclo de vida do status

- **Draft** — em elaboração, ou contendo marcadores de incerteza não resolvidos. Não é fonte de verdade.
- **Reviewed** — validado por um humano; todos os marcadores de incerteza resolvidos. Fonte de verdade do comportamento do sistema; entrada válida para o ITS Generator.
- **Retired** — deixou de descrever um comportamento vivo: o comportamento sai do sistema (entrada de retirada) ou passou a ser descrito por outro documento (incorporação). Não é fonte de verdade do comportamento atual. Permanece no mesmo caminho para que o número nunca seja reaproveitado e as citações antigas continuem resolvendo; seu corpo não é mais editado e ele não volta a outro status — comportamento reintroduzido nasce em um caso de uso novo.

A promoção de Draft para Reviewed é sempre um ato humano — nenhuma skill promove o status por conta própria. O ato humano é a decisão, não a edição do campo: por ordem explícita do arquiteto para aquele documento ("promova o UC-042"), quem está na sessão aplica a edição; nunca por julgamento próprio de que o documento parece pronto, nunca por uma ordem genérica e nunca com marcador de incerteza pendente — nesse caso, aponte o marcador em vez de promover. Os valores de status são tokens estáveis: escrevem-se `Draft`, `Reviewed` e `Retired` seja qual for o idioma do documento.

O caminho inverso é regra, não julgamento: um documento `Reviewed` volta a `Draft` quando recebe uma entrada de alteração, de reconciliação ou de revisão editorial, ou um marcador de incerteza — o conteúdo novo ainda não foi validado. Quem escreve faz o rebaixamento; o arquiteto promove de novo depois de validar a mudança. Uma entrada de conformidade não rebaixa, porque o corpo do documento não muda; uma atualização apenas de diagrama ou do campo Casos de uso relacionados também não.

A passagem a `Retired` também é regra: quem escreve a faz junto com a entrada de retirada ou com a incorporação, ambas decididas pelo arquiteto ao confirmar o mapeamento. Ela só parte de um documento `Reviewed` e, como o corpo não muda, não pede nova validação. Um documento `Retired` por uma entrada de retirada é a única exceção ao gate do ITS Generator: seu corpo validado é exatamente o que sai do sistema.

**Delta pendente.** `Reviewed` diz que o documento foi validado, não que o código já o cumpre. Entre a promoção e a entrega da story, um documento com uma entrada de criação, alteração ou conformidade cuja story ainda não foi entregue — em regra a mais recente, mas não necessariamente: uma revisão editorial pode ter sido registrada por cima — descreve o estado-alvo daquela story, e o código ainda faz o que fazia antes dela — com deltas empilhados, antes de cada um deles. Essa diferença é um **delta pendente**, não uma divergência. Quem compara um documento com o código — o Impact Mapping, a Feasibility Analysis, o Use Case Extractor, o Use Case Creator ao tratar uma divergência, o ITS Generator ao planejar e ao derivar pontos de regressão e o Code Review na lente de documentação — confere isso antes de registrar divergência: o código diverge só nos itens do delta e faz ali o que o documento descrevia antes dele (o corpo anterior está no controle de versão). Sendo delta pendente, registra-o com o ID da story e nunca o roteia como divergência — reconciliar o documento com o código apagaria a mudança planejada. É divergência quando o código não corresponde nem ao estado anterior nem ao alvo, ou quando a story já foi entregue (a ITS dela citada num PR já integrado, por exemplo); quando não dá para saber se foi, a pergunta vai ao arquiteto. O equivalente de um `Retired` é o código que ainda executa o comportamento retirado.

## Regras do Histórico de revisões

Toda entrada é de um dos tipos abaixo. O tipo decide o que vai nas colunas Story e Resumo e se a entrada é trabalho para o ITS Generator.

| Tipo | Quem escreve | Story | Resumo das alterações | Trabalho para o ITS Generator |
|---|---|---|---|---|
| Criação | Use Case Creator | ID da story | `Criação` | Sim — o documento inteiro é o delta |
| Alteração | Use Case Creator | ID da story | Itens adicionados/alterados/removidos, com os identificadores de passo, extensão e seção | Sim — os itens são o delta |
| Conformidade | Use Case Creator | ID da story | `Conformidade:` seguido dos identificadores que o código passa a cumprir — ex.: "Conformidade: o código passa a cumprir o passo 5 e o CA-3" | Sim — o corpo não muda; os identificadores citados são o delta |
| Retirada | Use Case Creator | ID da story | `Retirada` | Sim — o documento inteiro é o delta, todo item removido |
| Mapeamento inicial | Use Case Extractor | `mapeamento inicial a partir do código` | O escopo mapeado | Não — é estado |
| Reconciliação | Use Case Creator | `reconciliação com o código` | O que mudou no corpo para descrever o código, como numa alteração | Não — o código já faz isso |
| Revisão editorial | Use Case Creator | `revisão editorial` | O que mudou de redação ou de lugar, com os identificadores; numa reorganização, o documento de origem ou de destino e o mapa de identificadores antigos para novos | Não — o comportamento não muda |

- **Uma entrada por story por documento.** Uma nova execução para a mesma story (por exemplo, o ITS Generator devolveu o delta) reescreve a entrada existente com o delta consolidado contra o estado anterior à story; nunca acrescenta uma segunda. Uma entrada de criação continua `Criação`. A reescrita só vale enquanto essa é a entrada mais recente do documento: com outra registrada por cima, o delta consolidado deixaria de ser separável, e a correção passa a precisar de uma story própria.
- **Uma story por vez sobre cada documento.** Alteração, conformidade e retirada partem de um documento `Reviewed`. Enquanto o documento está em `Draft` — com marcadores pendentes ou com o delta de outra story aguardando a promoção —, a story seguinte espera: registrado antes, o delta dela se misturaria a conteúdo ainda não validado. Um delta registrado sobre o de outra story é escrito sobre o estado-alvo daquela, e depende dela enquanto ela não for implementada.
- **Story de origem ainda inexistente.** Quando o documento nasce ou muda a partir de um PRD ou de uma descrição sem story, a coluna Story leva o identificador da origem seguido de `[CONFIRM: story de origem]`. O documento fica em `Draft` até o ID da story substituir o marcador.
- **Não geram entrada:** atualizações apenas de diagrama ou do campo Casos de uso relacionados (derivadas dos fluxos e das relações entre documentos — valem inclusive para um documento fora do mapeamento da story, que recebe só o link recíproco), a resolução de marcadores de incerteza (esclarece um documento que ainda não é fonte de verdade) e ajustes de redação num documento que já está em `Draft` (entram no trabalho ainda não validado).
- **Story técnica.** Uma story que muda o código sem mudar o comportamento observável de nenhum ator — o avanço de uma migração declarada, a atualização de uma dependência ou da stack, uma refatoração, a remoção de uma flag cujo comportamento já é o definitivo — não muda nenhum caso de uso e não deixa entrada em nenhum. A ITS dela é planejada no cenário técnico do ITS Generator, depois de o arquiteto confirmar que nada observável muda. Se a story muda o que algum ator observa — inclusive ao remover um comportamento —, não é técnica.

## Marcadores de incerteza

Marque todo conteúdo não verificado. Os marcadores em si são tokens estáveis e permanecem em inglês; o conteúdo deles segue o idioma do documento:

- `[INFERRED]` — exclusivo do Use Case Extractor: conteúdo deduzido em vez de rastreado de ponta a ponta no código — despacho dinâmico, comportamento decidido por configuração ou por dados, reflexão, o efeito de uma integração cujo lado remoto não está no repositório, o interesse de um envolvido. Comportamento rastreado no código é fato sobre o que o sistema faz, mesmo sem teste que o cubra, e não leva marcador; se parecer errado, a dúvida é um `[CONFIRM: ...]`.
- `[CONFIRM: pergunta]` — uma pergunta em aberto que um humano precisa responder. O Use Case Extractor o usa para dúvidas sobre o código (por exemplo, `[CONFIRM: o limite de 10 itens é regra de negócio ou restrição técnica?]`); o Use Case Creator, para o que a entrada e o arquiteto ainda não responderam (por exemplo, a story de origem de um documento derivado de um PRD).

Um documento que contém marcadores de incerteza tem Status `Draft` e não deve ser tratado como fonte de verdade até que um humano resolva os marcadores e o promova a `Reviewed`. A resolução — aplicar as respostas do arquiteto ao documento — é feita pelo Use Case Creator, não gera entrada no Histórico de revisões e não promove o documento.

# Passo 2f — Modo revisão editorial

Parte do `use-case-creator`, lida só quando o Passo 1 classifica um documento no modo revisão editorial. Os passos citados abaixo — Passo 1, Passo 2a, Passo 2b, Passo 4 — são os do SKILL.md.

Muda a redação ou o lugar em que o comportamento está descrito, sem mudar o comportamento. Exemplos: reescrever um passo ambíguo; converter regras anteriores à Forma das regras de negócio; corrigir uma violação das regras de qualidade; dividir um caso de uso que cresceu demais (veja os sinais de tamanho da Granularidade do formato); incorporar um a outro; mover uma regra para o documento a que ela pertence. Se a mudança altera o que o sistema faz, não é editorial: é atualização (com story) ou reconciliação (com o código).

1. Parta de um documento `Reviewed`. Num documento em `Draft`, o ajuste entra no trabalho que o mantém ali — a reexecução da story ou a validação —, sem entrada própria.
2. Leia **por inteiro** cada documento envolvido. Numa divisão ou incorporação, siga a Reorganização entre documentos do formato: lápides que apontam o destino, numeração dos itens recebidos, o documento absorvido em `Retired`.
3. Faça as verificações de efeito colateral do item 3 do Passo 2b.
4. Registre uma entrada de revisão editorial em cada documento alterado: `revisão editorial` na coluna Story e, no Resumo, o que mudou de redação ou de lugar, com os identificadores — numa reorganização, o documento de origem ou de destino e o mapa de identificadores antigos para novos. Num documento nascido de uma divisão, essa é a primeira entrada, e ele nasce em `Draft`.
5. Devolva a `Draft` todo documento `Reviewed` cujo corpo mudou; o absorvido numa incorporação vai a `Retired`. Não há ITS: o comportamento não muda.
6. Nunca junto com o delta de uma story. Se a story pede também uma reorganização, faça-a primeiro, como revisão editorial; o delta entra depois que o arquiteto promover a base reorganizada.

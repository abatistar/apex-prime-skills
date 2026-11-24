# Passo 2d — Modo validação

Parte do `use-case-creator`, lida só quando o Passo 1 classifica um documento no modo validação. Os passos citados abaixo — Passo 1, Passo 2a, Passo 2b, Passo 4 — são os do SKILL.md.

Resolve os marcadores de incerteza de um documento em `Draft` — tipicamente a saída do use-case-extractor, ou um documento que o its-generator devolveu por ter marcadores pendentes.

1. Leia o documento **por inteiro** e liste os marcadores pendentes no formato da Lista de perguntas do formato. Se não houver nenhum, não há o que resolver: o documento aguarda apenas a promoção do arquiteto.
2. Aplique as respostas do arquiteto, item a item da lista: uma recomendação aceita ou uma correção vira conteúdo afirmado e o `[CONFIRM: ...]` sai; um `[INFERRED]` confirmado perde a marca, e um refutado tem o conteúdo corrigido. Se as respostas citam números que a lista refeita não reproduz — o documento mudou desde a entrega —, não as aplique: mostre a lista atual e peça as respostas de novo. Uma resposta que revela um bug não vira regra limpa — o documento continua descrevendo o que o código faz, e a correção é uma story.
3. Um marcador sem resposta permanece.
4. Faça as verificações de efeito colateral do item 3 do Passo 2b: uma resposta pode mudar um passo, uma extensão, uma regra ou um critério.
5. Não registre entrada no Histórico de revisões — a resolução esclarece um documento que ainda não é fonte de verdade — e não promova o documento. Quando não restar marcador, diga ao arquiteto que ele pode promovê-lo.

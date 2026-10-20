# Reformular a mudança como comportamento

Parte do `prime-architect/impact-mapping`, e a única definição da reformulação. O impact-mapping a executa no seu Passo 1. A `feasibility-analysis` a executa no seu próprio Passo 1, na conversa com o arquiteto, e entrega a reformulação pronta ao mapa — nesse caminho o Passo 1 do mapa é pulado, e a reformulação vira a linha de assunto como está.

A entrada costuma chegar como uma solução: *"adicionar uma coluna"*, *"cachear a consulta de cliente"*, *"mudar o endpoint"*. Reformule-a como o delta de comportamento observável — o que um usuário, um chamador ou um sistema a jusante verá de diferente. Depois delimite: declare explicitamente o que **não** muda, nos mesmos termos.

**Leituras concorrentes.** Quando a entrada admite mais de uma leitura, a escolha é confirmada com o arquiteto antes de mapear: mapear a leitura errada custa o mapa inteiro. Confirma quem conversa com ele — a `feasibility-analysis`, no próprio Passo 1. O impact-mapping não escolhe: ele pode estar rodando isolado, sem canal para perguntar (SKILL.md, Roda isolada), e devolve `Insufficient input` com as leituras candidatas e a que recomendaria; o arquiteto o invoca de novo com a leitura escolhida.

Dois desfechos são legítimos:

- A reformulação se sustenta → ela vira a linha de assunto do mapa, e tudo o que for rastreado precisa remeter a ela.
- A reformulação não pode ser feita sem inventar intenção — inclusive escolher sozinho entre leituras concorrentes → **`Insufficient input`**: pare, sem mapa e sem veredito, e devolva as perguntas específicas em vez de mapear uma mudança que ninguém definiu. É um achado, não uma falha — mapear uma mudança adivinhada custa mais que perguntar. Quando é a `feasibility-analysis` que executa a reformulação, o mesmo desfecho encerra a execução dela antes de qualquer mapa ser comissionado; nada foi julgado, então também não há *Undecidable*.

Quando a entrada nomeia uma solução e o delta de comportamento admite outras, registre isso em uma linha. Não avalie as alternativas — isso é decisão do arquiteto, informada pelo mapa.

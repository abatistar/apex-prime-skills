# Rodadas seguintes

Parte do `prime-architect/code-review`, lida a partir da segunda rodada sobre o mesmo pull request, antes do Passo 1.

A segunda rodada não é uma revisão nova da mesma mudança. Ela começa quando o autor responde à anterior e segue quatro regras:

1. **Primeiro, o que governava o merge.** Cada `Blocking:` e cada `Question:` que segurava o veredito é conferido um a um: resolvido, resolvido em parte ou não tratado. Um `Consider:` declinado com razão é uma resposta, não uma pendência.
2. **Só o que mudou.** Leia o delta desde a rodada anterior e o código que ele toca, não o PR inteiro de novo. As verificações obrigatórias voltam a ser pré-condição.
3. **Sem mover a trave.** Um achado novo só entra se o conserto o introduziu, ou se é um `Blocking:` que a rodada anterior deixou passar — e então é marcado como novo, com a razão de não ter aparecido antes. Um `Consider:` ou `Nit:` novo sobre código que já estava lá na rodada anterior não entra.
4. **Contra a ITS em vigor.** Depois de um *Return to the architect*, a rodada julga contra a revisão nova da ITS. Os números das unidades são estáveis; `D`, `RG` e `R` podem ter sido renumerados — use a correspondência entre a numeração antiga e a nova que o its-generator entregou, e cite a nova. Uma unidade declarada sem efeito não é cobrada; se ela já tinha sido implementada, confira o destino que a unidade substituta deu ao código.

O relatório da rodada diz qual rodada é e o estado de cada item que governava o merge na rodada anterior.

# Revisando uma ITS entregue

Parte do `prime-architect/its-generator`, lida só quando uma ITS entregue volta para revisão.

Uma ITS volta quando o plano não sobreviveu ao contato com o código: o implementador devolveu uma pergunta que o documento não consegue responder, ou o quarto veredito do code review devolveu a story ao arquiteto. A revisão é este mesmo processo sobre uma entrada mais estreita, sob quatro restrições.

- **Reentre no passo em que o problema vive.** Um delta errado ou ausente significa que o caso de uso mudou primeiro — roteie ao use-case-creator e depois retome a partir do Passo 1; numa story técnica, o resultado técnico é revisto com o arquiteto e a execução retoma do Passo 2 — ou, se a story deixou de ser técnica, do use-case-creator. Um delta mapeado para o código errado reexecuta os Passos 3 e 4. Uma decisão que o plano tomou sem registrar reexecuta o Passo 4.5.
- **A numeração das unidades é estável.** O implementador já trabalhou nela e o revisor percorre o diff nela. Trabalho novo chega como novas unidades ao final; nunca renumere uma unidade que alguém implementou. Uma unidade nova que precisa rodar antes de uma existente declara isso no campo Executar antes de. Onde uma unidade já não se aplica, ela mantém o número e é declarada sem efeito na forma do template, apontando a unidade que a substitui; os itens que ela atendia passam ao Atende da substituta, e, se ela já foi implementada, a substituta diz o que fazer com o código que ela produziu.
- **`D`, `RG` e `R` acompanham o conteúdo, não a história.** Quando a revisão muda o delta, a regressão ou as fontes, a sequência é refeita no documento inteiro, como numa ITS nova, e o Atende, os Testes e a coluna Usada em de todas as unidades — inclusive as já implementadas — passam à numeração nova. A resposta ao implementador declara a correspondência entre a numeração antiga e a nova, para que ele reconcilie o que já escreveu citando-a.
- **Reexecute o Passo 6 por inteiro.** Uma ITS revisada passa pelas mesmas verificações que uma nova. Um item de delta silenciosamente órfão pela revisão é a falha que esta execução existe para prevenir.

Uma ITS por story continua valendo: a revisão substitui o documento no lugar. O contrato não define histórico de revisão dentro da ITS — o controle de versão é esse registro, e nenhuma seção é inventada para guardá-lo.

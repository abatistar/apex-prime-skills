# RS — Resiliência

Leia com o índice, `references/convention-slots.md`; os valores estão em `references/defaults-<stack>/`, mesmo nome.

*Aplica-se a: todos.*

- **CS-RS-1 [INVARIANT] — Timeouts e repetição.** Os timeouts padrão por tipo de dependência, onde são configurados, quais falhas são repetidas, quantas vezes e com que espera. Os valores existem para que a ITS e o código tenham de onde tirá-los em vez de inventá-los. *Serve a:* `QM-RB-1`. *Verificação:* ferramenta + teste.
- **CS-RS-2 [CONVENTIONAL] — Isolamento e degradação.** O mecanismo que contém a falha de uma dependência, quando ele é obrigatório por nível de criticidade e como a degradação é declarada. *Serve a:* `QM-RB-6`. *Verificação:* revisão + teste.

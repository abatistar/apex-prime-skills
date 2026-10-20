# EV — Evolução e dívida

Leia com o índice, `references/convention-slots.md`; os valores estão em `references/defaults-<stack>/`, mesmo nome.

*Aplica-se a: todos.*

- **CS-EV-1 [INVARIANT] — Feature flags.** O mecanismo, a nomenclatura, o valor padrão e a condição de remoção que toda flag carrega desde que nasce. Uma flag sem condição de remoção é dívida permanente com interruptor. *Serve a:* `QM-MT-1`, `QM-MT-4`. *Verificação:* revisão.
- **CS-EV-2 [INVARIANT] — Marcação de dívida no código.** O formato de um marcador de dívida — com o item de backlog que o acompanha — e os marcadores que não são usados. Um marcador sem item é dívida invisível com enfeite. *Serve a:* `QM-MT-1`. *Verificação:* ferramenta.

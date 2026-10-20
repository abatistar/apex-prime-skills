# PR — Soluções canônicas e proibições

Leia com o índice, `references/convention-slots.md`; os valores estão em `references/defaults-<stack>/`, mesmo nome.

*Aplica-se a: todos. A única forma de "padrão de projeto" que este catálogo guarda: nenhum slot exige um padrão pelo nome; cada um declara o problema e a solução sancionada, e a estrutura decorre disso.*

- **CS-PR-1 [CONVENTIONAL] — Registro de soluções canônicas.** Para cada problema recorrente *neste* sistema, a solução acordada e o exemplo canônico no repositório. Chamar um serviço externo, publicar um evento, agendar trabalho, tratar falha parcial. Cresce por observação, não por antecipação. *Serve a:* `QM-CN-1`, `QM-CN-3`. *Verificação:* revisão.
- **CS-PR-2 [INVARIANT] — Padrões proibidos.** Uma lista curta, cada item com a falha concreta que lhe valeu um lugar e o critério que protege. Uma proibição sem razão é folclore e será violada no momento em que seu autor sair. *Serve a:* conforme cada item. *Verificação:* ferramenta.

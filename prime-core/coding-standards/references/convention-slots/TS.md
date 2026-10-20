# TS — Testes

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-TS-1 [INVARIANT] — O que obriga um teste.** As categorias de mudança que nunca entram em merge sem teste, e o tipo de teste que cada uma exige. Todo o resto é julgamento; isto não é. *Serve a:* `QM-TS-7`. *Verificação:* revisão.
- **CS-TS-2 [CONVENTIONAL] — Organização e nomenclatura.** Onde os testes vivem, como os tipos são distinguidos e a nomenclatura que declara cenário e expectativa. *Serve a:* `QM-TS-5`. *Verificação:* ferramenta.
- **CS-TS-3 [CONVENTIONAL] — O que é substituído por dublê.** As fronteiras substituídas e o código exercitado de verdade. *Serve a:* `QM-TS-2`, `QM-TS-3`. *Verificação:* revisão.
- **CS-TS-4 [INVARIANT] — Determinismo.** As proibições concretas que mantêm a suíte confiável: sem dormir esperando timing, sem dependência de ordem, sem estado compartilhado entre testes, sem relógio real. *Serve a:* `QM-TS-1`, `QM-TS-6`. *Verificação:* ferramenta.
- **CS-TS-5 [INVARIANT] — Desativação de teste.** Como um teste sai da suíte — a marca, o motivo, o item de backlog que o traz de volta —, o que nunca é feito em seu lugar e como a alteração de uma asserção existente é justificada na mudança. *Serve a:* `QM-TS-1`, `QM-TS-8`. *Verificação:* ferramenta.

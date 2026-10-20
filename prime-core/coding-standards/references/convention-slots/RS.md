# RS — Resiliência

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-RS-1 [INVARIANT] — Timeouts e repetição.** Os timeouts padrão por tipo de dependência, onde são configurados, quais falhas são repetidas, quantas vezes e com que espera. Os valores existem para que a ITS e o código tenham de onde tirá-los em vez de inventá-los. *Serve a:* `QM-RB-1`. *Verificação:* ferramenta + teste.
- **CS-RS-2 [CONVENTIONAL] — Isolamento e degradação.** O mecanismo que contém a falha de uma dependência, quando ele é obrigatório por nível de criticidade e como a degradação é declarada. *Serve a:* `QM-RB-6`. *Verificação:* revisão + teste.

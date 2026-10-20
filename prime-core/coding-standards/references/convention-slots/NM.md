# NM — Nomenclatura e estrutura

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-NM-1 [CONVENTIONAL] — Sufixos semânticos.** Quais sufixos existem e o que cada um promete sobre a responsabilidade do tipo. Um sufixo que não significa nada é pior que nenhum. *Serve a:* `QM-CN-3`. *Verificação:* ferramenta.
- **CS-NM-2 [INVARIANT] — Nomes que carregam efeitos colaterais.** Quais prefixos afirmam pureza e quais anunciam I/O, mutação ou emissão de evento. Um nome que afirma uma coisa enquanto faz outra é um defeito, não uma preferência de estilo. *Serve a:* `QM-RC-1`. *Verificação:* revisão + ferramenta.
- **CS-NM-3 [CONVENTIONAL] — Onde um conceito vive.** A regra que liga um nome a um local, para que o leitor encontre um tipo sem precisar procurar. *Serve a:* `QM-RC-4`, `QM-CC-2`. *Verificação:* revisão.

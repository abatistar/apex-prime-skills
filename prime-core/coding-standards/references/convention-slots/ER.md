# ER — Erros

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-ER-1 [CONVENTIONAL] — Erro esperado vs. defeito: representação.** Como uma situação de domínio é sinalizada versus um invariante violado. *Serve a:* `QM-EO-5`. *Verificação:* revisão.
- **CS-ER-2 [CONVENTIONAL] — Taxonomia de erros.** A hierarquia base ou o tipo de resultado, e como uma nova categoria de erro é adicionada. *Serve a:* `QM-EO-5`, `QM-CN-3`. *Verificação:* revisão.
- **CS-ER-3 [CONVENTIONAL] — Onde os erros são capturados e traduzidos.** A camada com contexto suficiente para decidir e as camadas que apenas propagam. *Serve a:* `QM-EO-6`. *Verificação:* revisão + ferramenta.
- **CS-ER-4 [INVARIANT] — Duas audiências.** O que quem chama recebe — formato e conteúdo do erro no fio — versus o que o operador recebe. Genérico e seguro para fora, detalhe completo para dentro. *Serve a:* `QM-EO-2`. *Verificação:* teste.
- **CS-ER-5 [INVARIANT] — Preservação da causa.** Como a propagação carrega a causa original e o stack nesta stack. *Serve a:* `QM-EO-3`. *Verificação:* ferramenta.
- **CS-ER-6 [INVARIANT] — Sem engolir em silêncio.** As formas concretas proibidas nesta stack — catch vazio, retorno ignorado, nulo no lugar de um sinal de falha. *Serve a:* `QM-EO-1`. *Verificação:* ferramenta.
- **CS-ER-7 [CONVENTIONAL] — Ausência de valor.** Como "não há valor" é representado — tipo opcional, nulidade declarada no tipo, objeto vazio —, onde o nulo nunca cruza e qual ferramenta verifica. *Serve a:* `QM-RC-1`, `QM-EO-1`. *Verificação:* ferramenta.

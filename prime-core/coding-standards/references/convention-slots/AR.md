# AR — Arquitetura e dependências

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos. Os slots de maior meia-vida e maior rendimento de automação — decida-os primeiro.*

- **CS-AR-1 [INVARIANT] — Direção permitida das dependências.** Qual camada ou módulo pode depender de qual, e qual direção é proibida, declarada como regra que uma ferramenta consegue verificar, não como diagrama. *Serve a:* `QM-CC-3`. *Verificação:* ferramenta.
- **CS-AR-2 [INVARIANT] — Onde as regras de negócio vivem.** A camada que é dona das decisões, as camadas que não devem conter nenhuma e como uma regra é exposta para que todo ponto que precisa dela a chame em vez de reimplementá-la. A erosão mais comum é a regra que migra para o controller ou para a consulta. *Serve a:* `QM-CC-6`. *Verificação:* revisão + ferramenta.
- **CS-AR-3 [INVARIANT] — Tipos que nunca cruzam uma fronteira.** Tipos de persistência expostos pela API, anotações de framework dentro do domínio, tipos de transporte chegando ao núcleo. Nomeie explicitamente os cruzamentos proibidos. *Serve a:* `QM-CC-3`, `QM-CC-7`. *Verificação:* ferramenta.
- **CS-AR-4 [CONVENTIONAL] — Agrupamento de módulos.** Por feature ou domínio, ou por camada técnica, em qual profundidade e o que um módulo expõe aos outros. *Serve a:* `QM-CC-2`. *Verificação:* ferramenta + revisão.
- **CS-AR-5 [CONVENTIONAL] — Estilo de comunicação entre módulos e entre serviços.** Chamada direta, interface publicada, evento de domínio, mensagem, chamada síncrona entre serviços. Qual é o padrão e o que justifica os demais. *Serve a:* `QM-CC-1`, `QM-CC-3`. *Verificação:* revisão.

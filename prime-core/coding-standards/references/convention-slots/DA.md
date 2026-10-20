# DA — Dados e transações

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: `serviço`.*

- **CS-DA-1 [CONVENTIONAL] — Fronteira transacional.** Onde uma transação abre e fecha, quais camadas nunca abrem uma e o que nunca acontece dentro dela. *Serve a:* `QM-RB-4`. *Verificação:* ferramenta + revisão.
- **CS-DA-2 [CONVENTIONAL] — Idempotência.** Quais operações precisam ser seguras para repetir e como a repetição é detectada. *Serve a:* `QM-RB-3`. *Verificação:* teste.
- **CS-DA-3 [CONVENTIONAL] — Convenção de migrações.** Ferramenta, nomenclatura e ordenação dos arquivos de migração. A compatibilidade com a versão em produção é contrato (`CS-CT-1`). *Serve a:* `QM-CN-3`. *Verificação:* ferramenta.
- **CS-DA-4 [INVARIANT] — Migrações aplicadas são imutáveis.** Uma migração que rodou em qualquer ambiente nunca é editada; a correção é uma nova migração. *Serve a:* `QM-CC-7`. *Verificação:* ferramenta.
- **CS-DA-5 [CONVENTIONAL] — Disciplina de carregamento.** A estratégia padrão de busca e como uma consulta declara o que precisa, para que o N+1 seja prevenido por convenção em vez de descoberto em produção. *Serve a:* `QM-EF-1`, `QM-EF-3`. *Verificação:* teste.
- **CS-DA-6 [CONVENTIONAL] — Consistência entre recursos.** O mecanismo padrão quando uma operação altera mais de um recurso — banco e evento, dois bancos, banco e serviço — e o que nunca é feito. *Serve a:* `QM-RB-4`. *Verificação:* revisão + teste.
- **CS-DA-7 [CONVENTIONAL] — Controle de concorrência.** O protocolo padrão para estado alterado concorrentemente, a resposta ao conflito e a proteção de trabalho agendado contra execução simultânea. *Serve a:* `QM-RB-5`. *Verificação:* revisão + teste.

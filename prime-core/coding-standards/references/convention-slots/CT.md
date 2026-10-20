# CT — Contratos externos

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-CT-1 [INVARIANT] — Sem quebra silenciosa de contrato.** O que conta como quebra para cada contrato publicado — API, evento, arquivo trocado e o esquema de banco compartilhado com a versão em produção — e a rota que uma quebra precisa seguir: versionamento, período de convivência, mudança de esquema em etapas. *Aplica-se a:* `serviço`. *Serve a:* `QM-CC-7`. *Verificação:* ferramenta + teste.
- **CS-CT-2 [INVARIANT] — Forma das coleções.** Paginação, limite no servidor, filtragem, ordenação e o envelope — decididos uma vez, idênticos em todo o sistema. *Serve a:* `QM-EF-1`, `QM-CN-3`. *Verificação:* teste.
- **CS-CT-3 [CONVENTIONAL] — Fronteira de serialização.** Os tipos que carregam o contrato, distintos do modelo de domínio, e onde a tradução acontece. *Serve a:* `QM-CC-3`, `QM-CC-7`. *Verificação:* ferramenta + teste.
- **CS-CT-4 [INVARIANT] — Representações canônicas.** Tempo, dinheiro, quantidade e identificadores. Cada um tem exatamente uma representação em todo o sistema, e as representações que corrompem valor (dinheiro em ponto flutuante, instante sem fuso) são proibidas. *Serve a:* `QM-CN-1`, `QM-CC-7`. *Verificação:* revisão + ferramenta.

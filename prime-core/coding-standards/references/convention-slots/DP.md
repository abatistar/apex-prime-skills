# DP — Dependências de terceiros

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-DP-1 [INVARIANT] — Admissão de dependência.** O que uma nova dependência precisa satisfazer — problema que resolve, manutenção, licença, pegada —, como sua identidade é conferida no repositório oficial, como a versão é fixada e quem aprova. *Serve a:* `QM-SR-4`, `QM-CN-1`. *Verificação:* ferramenta + revisão.
- **CS-DP-2 [INVARIANT] — Uma biblioteca por preocupação.** Uma preocupação já atendida por uma biblioteca sancionada não adquire uma segunda. É assim que uma base acaba com três bibliotecas de data. *Serve a:* `QM-CN-1`. *Verificação:* ferramenta.
- **CS-DP-3 [INVARIANT] — Dependências com vulnerabilidades conhecidas.** A política para entregar com um alerta de vulnerabilidade aberto, e quem é dono da exceção. *Serve a:* `QM-SR-4`. *Verificação:* ferramenta.

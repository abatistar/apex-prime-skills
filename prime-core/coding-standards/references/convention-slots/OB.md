# OB — Observabilidade

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos.*

- **CS-OB-1 [CONVENTIONAL] — Formato de log e semântica dos níveis.** O que cada nível realmente significa aqui e a forma estruturada que torna as linhas pesquisáveis. *Serve a:* `QM-EO-8`. *Verificação:* ferramenta + revisão.
- **CS-OB-2 [INVARIANT] — Propagação de correlação.** O formato em que um identificador de requisição é criado, carregado entre chamadas e serviços e chega a cada linha. Um formato só, para que uma requisição possa ser seguida através de todos os componentes. *Serve a:* `QM-EO-7`, `QM-EO-8`. *Verificação:* teste.
- **CS-OB-3 [INVARIANT] — A denylist de logs.** A lista fechada do que nunca é escrito num log ou numa mensagem de erro: credenciais, tokens, dados das classes protegidas (`CS-SC-6`), payloads que os contenham. A linha isolada de maior retorno deste catálogo. *Serve a:* `QM-EO-2`, `QM-SR-10`. *Verificação:* teste + ferramenta.
- **CS-OB-4 [CONVENTIONAL] — O que precisa ser instrumentado.** Os caminhos que carregam métricas e traces por padrão, por nível de criticidade, para que a instrumentação seja sistemática em vez de lembrada. *Serve a:* `QM-EO-7`. *Verificação:* revisão.
- **CS-OB-5 [INVARIANT] — Eventos de segurança e auditoria.** Quais eventos são registrados, com quais campos, para qual destino e com que retenção — separados do log operacional e sem o dado protegido. *Serve a:* `QM-SR-9`. *Verificação:* teste.

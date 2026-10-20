# SC — Segurança

Família do catálogo de slots do `prime-core/coding-standards`. Lida junto com o índice, `references/convention-slots.md`, que guarda o que cada slot declara, os invariantes num relance, o mapa critério → slots e os IDs reclassificados, movidos e aposentados. Os valores do time para estes slots estão no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`).

*Aplica-se a: todos. Apenas posicionamento concreto: os princípios são os `QM-SR-*`, e a lista exaustiva de controles pertence ao padrão externo que o projeto adota (`CS-SC-5`), nunca a uma cópia reescrita aqui.*

- **CS-SC-1 [INVARIANT] — Onde e como a autorização é imposta.** A camada única que decide, como a negação por padrão é configurada, como a titularidade de um recurso é verificada e a declaração explícita de que nenhuma verificação no cliente conta. *Aplica-se a:* `serviço`. *Serve a:* `QM-SR-8`. *Verificação:* teste + revisão.
- **CS-SC-2 [INVARIANT] — Validação na fronteira.** Onde a entrada externa é validada e neutralizada, as separações entre dado e código que nunca são opcionais e a codificação de saída por contexto. *Serve a:* `QM-SR-1`. *Verificação:* ferramenta + revisão.
- **CS-SC-3 [INVARIANT] — Segredos.** Onde as credenciais vivem, como chegam ao processo e a expectativa de rotação. *Serve a:* `QM-SR-2`. *Verificação:* ferramenta.
- **CS-SC-4 [INVARIANT] — Criptografia e armazenamento de credenciais.** As bibliotecas e os algoritmos sancionados. *Serve a:* `QM-SR-3`. *Verificação:* ferramenta.
- **CS-SC-5 [INVARIANT] — Padrão externo e nível.** O padrão de segurança que o projeto adota e em qual nível, por nível de criticidade, referenciado em vez de transcrito. *Serve a:* `QM-SR-1`, `QM-SR-5`, `QM-SR-6`, `QM-SR-8`. *Verificação:* revisão.
- **CS-SC-6 [INVARIANT] — Classificação de dados.** As classes de dado protegido — pessoal, sensível, financeiro, credencial —, como um campo carrega sua classe e o que cada classe impõe: exposição, mascaramento, log, retenção. *Serve a:* `QM-SR-10`, `QM-EO-2`. *Verificação:* revisão + teste.

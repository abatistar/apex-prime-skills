# EV — Evolução e dívida (Java)

Leia com o índice, `references/defaults-java.md`; as definições estão em `references/convention-slots/`, mesmo nome.

- **CS-EV-1** — Flags via propriedade `feature.<area>.<nome>` lida por `@ConditionalOnProperty` **(Spring)** quando a flag só muda num novo deploy; pelo serviço de flags do projeto, atrás da API OpenFeature, quando ela muda sem reinício. Desligadas por padrão. Toda flag nasce com a condição de remoção (data ou evento) num item do tracker, citado num comentário na declaração. Uma flag com a condição vencida é dívida a pagar (`QM-MT-1`). *Razão:* flag sem data de remoção vira ramo permanente que ninguém testa. *Verificação:* revisão; busca por flags com condição vencida.
- **CS-EV-2** — Dívida no código é marcada `// TODO(ITEM-123): motivo`, sempre com o item do tracker; `FIXME` e `XXX` não são usados. O responsável é o do item. *Razão:* um marcador sem item nunca entra numa priorização. *Verificação:* Checkstyle `TodoComment` com formato que exige o item, ou regra Semgrep.

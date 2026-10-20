# Slots de Convenção

Catálogo canônico de slots de propriedade do `prime-core/coding-standards`. O SKILL.md define o que é um slot, os padrões versionados e a evolução; as classes de aplicação, o registro de áreas, a disciplina de migração e as regras de consumo vivem em `references/consumer-rules.md` — este índice e os arquivos de família em `references/convention-slots/` são os slots.

**Um slot é uma pergunta, não uma resposta.** Cada entrada declara a decisão que um projeto precisa ter tomado. Os valores vivem nos padrões da stack — o índice `references/defaults-<stack>.md` e a pasta `references/defaults-<stack>/` — (padrão do time, na release do Apex Prime que o projeto fixa) e no `docs/prime-config.md` (override do projeto, que vence). Um slot só existe onde há uma escolha a fazer: uma exigência sem alternativa é um critério do `prime-core/quality-model`, verificado por ferramenta, e não vira slot.

**O que cada slot declara.**
- **Classe.** **[INVARIANT]** vale para toda linha escrita ou alterada, em qualquer área. **[CONVENTIONAL]** segue o estado registrado da área: numa área legada, o padrão local vence.
- **Serve a.** Os critérios do `quality-model` que o slot torna concretos. É por eles que um gatilho de especificação chega ao slot que dá o valor.
- **Verificação.** Como o cumprimento é verificado: `ferramenta` (uma regra decide em todo caso), `teste` (um teste da suíte prova) ou `revisão` (exige julgamento). Combinações indicam verificação parcial por ferramenta.
- **Aplica-se a.** O tipo de componente: `serviço` (o que roda no servidor — API, worker, job, consumidor) ou `cliente` (front-end web ou mobile). Declarado por família; um slot que difere da família o diz na própria entrada.

Este catálogo é escrito para componentes `serviço`. Os slots próprios de `cliente` — estado de tela, acessibilidade, uso do design system — entram com o primeiro projeto cliente.

**Não preenchido é uma lacuna, não uma escolha.** Um slot aplicável sem valor é reportado, nunca improvisado. "Não se aplica", com o motivo, é um valor declarado — não uma lacuna.

Cite os slots por ID. Os IDs são estáveis e nunca renumerados; um slot aposentado mantém seu ID aposentado (veja o fim do arquivo).

---

## Os invariantes num relance

Os slots que valem em qualquer área, seja qual for o entorno. São de dois tipos: proibições, que levam o piso do `quality-model` à forma concreta, e formas únicas do sistema, que um consumidor ou outro módulo enxerga como um todo. Todo o resto do catálogo segue o estado registrado da área.

`CS-AR-1` direção das camadas · `CS-AR-2` onde vivem as regras de negócio · `CS-AR-3` tipos que não cruzam fronteiras · `CS-NM-2` nomes honestos · `CS-ER-4` duas audiências · `CS-ER-5` cadeia de causas · `CS-ER-6` sem engolir em silêncio · `CS-OB-2` propagação de correlação · `CS-OB-3` denylist de logs · `CS-OB-5` eventos de segurança · `CS-DA-4` migrações aplicadas são imutáveis · `CS-RS-1` timeouts e repetição · `CS-CT-1` sem quebra silenciosa de contrato · `CS-CT-2` forma das coleções · `CS-CT-4` representações canônicas · `CS-TS-1` o que obriga um teste · `CS-TS-4` testes determinísticos · `CS-TS-5` desativação de teste · `CS-SC-1` autorização · `CS-SC-2` validação na fronteira · `CS-SC-3` segredos · `CS-SC-4` criptografia · `CS-SC-5` padrão de segurança externo · `CS-SC-6` classificação de dados · `CS-DP-1` admissão de dependência · `CS-DP-2` uma biblioteca por preocupação · `CS-DP-3` dependências vulneráveis · `CS-EV-1` feature flags · `CS-EV-2` marcação de dívida · `CS-PR-2` padrões proibidos

---

## Critério → slots

O inverso do *Serve a* de cada slot: para um critério do `quality-model`, os slots — invariantes ou convencionais — que lhe dão a forma concreta. É por aqui que um gatilho de especificação, que cita critérios, chega ao slot que dá o valor e à família a abrir. Um critério fora da lista não tem slot. O `CS-PR-2` serve ao critério que cada um dos seus itens nomeia.

- **RC** — `QM-RC-1`: `CS-ER-7`, `CS-NM-2` · `QM-RC-4`: `CS-NM-3`
- **CC** — `QM-CC-1`: `CS-AR-5` · `QM-CC-2`: `CS-AR-4`, `CS-NM-3` · `QM-CC-3`: `CS-AR-1`, `CS-AR-3`, `CS-AR-5`, `CS-CT-3` · `QM-CC-6`: `CS-AR-2` · `QM-CC-7`: `CS-AR-3`, `CS-CT-1`, `CS-CT-3`, `CS-CT-4`, `CS-DA-4`
- **CN** — `QM-CN-1`: `CS-CT-4`, `CS-DP-1`, `CS-DP-2`, `CS-PR-1` · `QM-CN-3`: `CS-CT-2`, `CS-DA-3`, `CS-ER-2`, `CS-NM-1`, `CS-PR-1`
- **TS** — `QM-TS-1`: `CS-TS-4`, `CS-TS-5` · `QM-TS-2`: `CS-TS-3` · `QM-TS-3`: `CS-TS-3` · `QM-TS-5`: `CS-TS-2` · `QM-TS-6`: `CS-TS-4` · `QM-TS-7`: `CS-TS-1` · `QM-TS-8`: `CS-TS-5`
- **MT** — `QM-MT-1`: `CS-EV-1`, `CS-EV-2` · `QM-MT-4`: `CS-EV-1`
- **EO** — `QM-EO-1`: `CS-ER-6`, `CS-ER-7` · `QM-EO-2`: `CS-ER-4`, `CS-OB-3`, `CS-SC-6` · `QM-EO-3`: `CS-ER-5` · `QM-EO-5`: `CS-ER-1`, `CS-ER-2` · `QM-EO-6`: `CS-ER-3` · `QM-EO-7`: `CS-OB-2`, `CS-OB-4` · `QM-EO-8`: `CS-OB-1`, `CS-OB-2`
- **RB** — `QM-RB-1`: `CS-RS-1` · `QM-RB-3`: `CS-DA-2` · `QM-RB-4`: `CS-DA-1`, `CS-DA-6` · `QM-RB-5`: `CS-DA-7` · `QM-RB-6`: `CS-RS-2`
- **EF** — `QM-EF-1`: `CS-CT-2`, `CS-DA-5` · `QM-EF-3`: `CS-DA-5`
- **SR** — `QM-SR-1`: `CS-SC-2`, `CS-SC-5` · `QM-SR-2`: `CS-SC-3` · `QM-SR-3`: `CS-SC-4` · `QM-SR-4`: `CS-DP-1`, `CS-DP-3` · `QM-SR-5`: `CS-SC-5` · `QM-SR-6`: `CS-SC-5` · `QM-SR-8`: `CS-SC-1`, `CS-SC-5` · `QM-SR-9`: `CS-OB-5` · `QM-SR-10`: `CS-OB-3`, `CS-SC-6`

---

## As famílias

Cada família vive no seu arquivo, em `references/convention-slots/`, e o `XX` de `CS-XX-N` nomeia o arquivo: `AR.md` arquitetura e dependências · `NM.md` nomenclatura e estrutura · `ER.md` erros · `OB.md` observabilidade · `DA.md` dados e transações · `RS.md` resiliência · `CT.md` contratos externos · `TS.md` testes · `SC.md` segurança · `DP.md` dependências de terceiros · `EV.md` evolução e dívida · `PR.md` soluções canônicas e proibições.

Este índice é lido sempre. O arquivo de uma família é lido quando um slot dela é citado ou aplicado — nunca o catálogo inteiro de antemão; o valor do time para o slot está no arquivo de mesmo nome dos padrões da stack (`references/defaults-<stack>/`). Os invariantes num relance, acima, bastam para decidir se um invariante alcança a mudança, e o mapa Critério → slots diz que família abrir para o valor de que um critério precisa.

---

## IDs reclassificados, movidos e aposentados

Mantidos aqui porque artefatos anteriores citam estes slots. O registro do motivo é o PR de governança.

- **Classes redefinidas pelo alcance.** INVARIANT passou a significar "vale em qualquer área" — proibição ou forma única do sistema —, e não mais "concretiza um inegociável". Reclassificados de CONVENTIONAL para INVARIANT: `CS-OB-2`, `CS-CT-2`, `CS-CT-4`, `CS-SC-5` e `CS-DP-1`.
- **Conteúdo movido.** A repetição saiu de `CS-DA-2`, que ficou só com a idempotência, para `CS-RS-1`. A compatibilidade de esquema saiu de `CS-DA-3` para `CS-CT-1`.
- **CS-PR-3 — aposentado.** "Nenhum padrão prescrito pelo nome" é uma regra sobre o catálogo, não uma decisão de projeto; vive agora no cabeçalho da família PR.

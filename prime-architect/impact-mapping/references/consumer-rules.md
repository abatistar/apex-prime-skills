# Regras de consumo do mapa de impacto

Parte do `impact-mapping`, e a única fonte do que um mapa entrega a quem julga sobre ele — hoje a `feasibility-analysis` (Passo 2) e o arquiteto lendo o relatório direto. Quem **produz** o mapa escreve contra o SKILL.md e o `checklists/impact-map-checklist.md`; quem **consome** lê só este arquivo, e não repete esta lista do seu lado.

## O que o mapa entrega

O cabeçalho é por onde o mapa é citado: **ID** (`IM-<demand-id>-N`), **Revisão** (o commit lido, as mudanças não commitadas e, com raiz de documentos paralela, a revisão dela), **Data**, **Demanda** e **Perfil de evidência** — as contagens, por grau, de linhas ancoradas, `[INFERRED]`, `[UNVERIFIED]` e lacunas. Citar um mapa sem a revisão não é citá-lo: é ela que diz se o alcance e a borda ainda valem.

| Seção do relatório | O que você pode contar em encontrar |
|---|---|
| **A mudança** | o delta de comportamento observável e a fronteira do que a demanda **não** afirma |
| **Alcance — direto** | o menor conjunto que precisa mudar, com todas as cópias de uma regra replicada (`QM-CC-6`) |
| **Alcance — acoplado** | o que observa ou depende do que muda, com os testes que exercitam o conjunto direto e o código direto que nenhum teste exercita |
| **Alcance — superfície de contrato** | o que é visível fora desta base de código, com os consumidores conhecidos nomeados e não adentrados |
| **Dados existentes** | o estado persistido que a mudança obriga a migrar, preencher ou reinterpretar: forma e volume, ou o volume como lacuna |
| **Como o alcance foi buscado** | as sementes e as buscas — é o que diz que tipo de omissão é plausível |
| **Estados das áreas** | por área tocada, o estado registrado, o nível de criticidade, o substituto e o `MIG-NNN` de uma `strangler`, as exclusões e a regra do projeto que a alcança. Área fora do registro vem `current` · `padrão`, marcada *não registrada* |
| **Camada documentada** | cobertura por casos de uso com o status de cada um (num `Reviewed` com delta pendente, o ID da story em curso), as divergências código × caso de uso, as lacunas de documentação e os ADRs `Accepted` e `Proposed` que incidem |
| **Lacunas e questões em aberto** | cada uma com o que a resolveria |
| **Onde o mapa para** | a borda: o que deliberadamente não foi rastreado, e o que justificaria rastrear |

Nada disso vem precificado, e em nenhum ponto vem com veredito, recomendação ou estimativa. O que o mapa não trouxe é uma lacuna dele.

## O que cada linha sustenta

Toda linha carrega exatamente um estado de proveniência, e o estado limita o que se pode construir sobre ela. O vocabulário é definido pelo `impact-mapping` (SKILL.md, *A proveniência é a disciplina*) e **reutilizado, nunca redefinido**:

- **Ancorada** — cita `caminho/Arquivo.ext:linha` ou um elemento de caso de uso (`UC-NNN/RN-N`, `UC-NNN/CA-N`, `UC-NNN` passo N, extensão Na), aberto na revisão registrada. É o único estado que sustenta uma conclusão bloqueante.
- **`[INFERRED]`** — deduzida em vez de rastreada de ponta a ponta, com o raciocínio na própria linha. Sustenta uma premissa declarada, nunca um bloqueio.
- **`[UNVERIFIED]`** — afirmada pela demanda e não conferida contra o código. Nunca promovida a fato em silêncio, por plausível que soe.
- **Lacuna** — não foi possível determinar, declarada com o que a resolveria.

## Antes de julgar sobre um mapa

- **Confira que ainda vale.** Um mapa trazido pronto de uma execução anterior só serve se os arquivos que cita não mudaram desde a revisão que ele registra (`git diff <revisão>..HEAD -- <arquivos>`). Mudaram → refaça o mapa, ou ao menos as linhas desses arquivos. Julgar sobre um mapa envelhecido é julgar um sistema que já não existe.
- **Leia a borda antes das conclusões.** Uma borda que para aquém do que o julgamento exige é um fundamento de indecidibilidade, não um detalhe de rodapé.
- **Não reande o código.** O mapa é a passada de evidência; refazê-la do lado de quem julga desfaz a separação entre levantar evidência e decidir sobre ela — a razão pela qual o mapa roda isolado (SKILL.md, *Roda isolada*).
- **Encaminhe o que não é seu.** Uma divergência código × caso de uso vai ao `use-case-creator` (conformidade ou reconciliação) e uma lacuna de documentação ao `use-case-extractor`. Nenhuma das duas é remendada por quem consome o mapa, nem carregada adiante para dentro de um plano de implementação.
- **Um mapa que parou em `Insufficient input` não é um mapa.** A reformulação não se sustentou (`references/reformulation.md`): não há alcance levantado, e portanto não há sobre o que decidir.

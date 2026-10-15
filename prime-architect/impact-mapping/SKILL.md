---
name: impact-mapping
description: Mapeia o alcance de uma mudança pretendida na base de código e na camada documentada, produzindo evidência ancorada e nunca um veredito. Skill da camada do arquiteto - responde o que uma mudança toca, o que depende dela, em quais áreas registradas ela entra, quais casos de uso a cobrem e quais ADRs Accepted incidem sobre ela. Use quando o arquiteto perguntar o que uma mudança alcança - "o que a mudança na regra de preço toca", "o que depende deste módulo", "mapeie o raio de impacto da S-131", "o que quebra se mudarmos este payload", "onde vive este comportamento" - e sempre como primeira passada da feasibility-analysis. NÃO use para decidir se a mudança deve ser feita (a feasibility-analysis é dona do veredito), para escrever ou revisar uma ITS (its-generator), para documentar casos de uso (use-case-creator, use-case-extractor), para revisar uma implementação (code-review) nem para escrever código de aplicação (camada do dev).
---

# Impact Mapping (prime-architect)

Esta skill responde a uma pergunta e recusa a próxima: **o que esta mudança alcança?** Ela produz evidência — ancorada, delimitada e classificada por confiança — e a entrega a quem precisa decidir. Decidir é trabalho de outro: a `feasibility-analysis` transforma este mapa em um veredito, e o arquiteto pode simplesmente lê-lo.

A separação é a mesma que o repositório já traça entre o `prime-core/quality-model` e o `prime-architect/code-review`: definir e julgar são atos diferentes, com modos de falha diferentes. Um mapa que recomenda deixou de ser evidência, porque o leitor não consegue mais distinguir quais linhas são observações e quais são opiniões.

## O padrão de um mapa

Um mapa é bom quando um leitor que discorda de todas as conclusões ainda consegue usá-lo. Isso exige três propriedades, e cada uma delas é uma regra abaixo: toda linha é **ancorada ou explicitamente marcada como inferência**, todo grau de alcance é **nomeado** em vez de fundido numa lista só, e a **borda do mapa é declarada** em vez de subentendida.

**A proveniência é a disciplina.** Esta skill não produz nenhum documento governado por um contrato do core e não passa por nenhum gate, então a única coisa que a separa de um palpite confiante é que toda afirmação sobre comportamento se resolve em uma localização. Quatro estados, e toda linha carrega exatamente um:

- **Ancorada** — cita `caminho/Arquivo.ext:linha` ou `UC-NNN/CA-N`. Lida, não presumida. O leitor pode verificá-la sem perguntar, e é o único estado capaz de sustentar uma conclusão bloqueante adiante.
- **`[INFERRED]`** — raciocinada a partir de um padrão observado em outro ponto da base de código, não do código afetado em si, com o raciocínio declarado na linha. É o mesmo marcador que o `use-case-extractor` usa, pelo mesmo motivo: uma inferência lida como fato é pior que uma lacuna, porque ninguém a investiga.
- **`[UNVERIFIED]`** — afirmada pela demanda ou pelo arquiteto e não conferida contra o código. Legítima de carregar, nunca promovida em silêncio a fato.
- **Lacuna** — não foi possível determinar, declarada com *o que a resolveria*.

Este vocabulário é definido aqui e **reutilizado, não redefinido**, por toda skill que consome este mapa. Uma inferência sem marca é o defeito que mais importa, porque o mapa é consumido por uma skill que emite vereditos. Um veredito construído sobre evidência de proveniência desconhecida é uma preferência vestida de relatório.

## Passo 0 — Ler a configuração

Leia o `docs/prime-config.md` conforme o contrato **prime-core/prime-config** (as regras de localização, precedência, divergência e bootstrap vivem lá; não as repita). Dele esta skill consome: o **mapa de estrutura** (onde as coisas vivem), o **registro de áreas** (o estado de cada área — `current`, `legacy-maintained`, `strangler` —, o seu nível de criticidade — `efêmera`, `padrão`, `crítica` — e as exclusões), as localizações do **repositório de documentos** para casos de uso e ADRs e os **comandos de verificação** (quais testes cobrem qual superfície).

Um slot sem valor ou uma área sem estado registrado é uma **lacuna reportada conforme o `coding-standards`**, nunca improvisada. Nesta skill a consequência é direta: uma área não registrada não pode ser sobreposta no Passo 4, e o mapa diz isso em vez de adivinhar pelo nome do diretório.

## Passo 1 — Reformular a mudança como comportamento

**Este passo pertence à execução avulsa.** Quando comissionada pela `feasibility-analysis`, a reformulação chega já feita e já confirmada com o arquiteto: ela vira a linha de assunto como está, sua fronteira vem junto, e este passo é pulado por inteiro — razão pela qual `Insufficient input` não pode ser alcançado nesse caminho. Ali, uma demanda que ninguém conseguiu reformular foi devolvida antes de qualquer mapa ser comissionado. Tudo o que segue governa a execução que o arquiteto pede diretamente.

A entrada costuma chegar como uma solução: *"adicionar uma coluna"*, *"cachear a consulta de cliente"*, *"mudar o endpoint"*. Reformule-a como o delta de comportamento observável — o que um usuário, um chamador ou um sistema a jusante verá de diferente. Depois delimite: declare explicitamente o que **não** muda, nos mesmos termos.

Dois desfechos são legítimos aqui:

- A reformulação se sustenta → ela vira a linha de assunto do mapa, e tudo o que for rastreado precisa remeter a ela.
- A reformulação não pode ser feita sem inventar intenção → pare. `Insufficient input` é um achado, não uma falha; devolva as perguntas específicas em vez de mapear uma mudança que ninguém definiu. Mapear uma mudança adivinhada custa mais que perguntar.

Quando a entrada nomeia uma solução e o delta de comportamento admite outras, registre isso em uma linha. Não avalie as alternativas — isso é decisão do arquiteto, informada pelo mapa.

## Passo 2 — Encontrar os pontos de entrada

De onde o comportamento é disparado: endpoint, job agendado, handler de evento, CLI, ação de UI, migração. Ancore cada um. São as sementes; tudo no Passo 3 cresce a partir delas.

Se o comportamento tem pontos de entrada que a busca não alcançou — dispatch dinâmico, reflexão, ligação orientada por configuração, convenção de framework —, diga-o como uma lacuna com sua resolução ("um trace em runtime ou a tabela de roteamento resolveria isto"). Um mapa que perde um ponto de entrada em silêncio subestima o alcance exatamente do modo que torna errado um veredito de viabilidade.

## Passo 3 — Rastrear o alcance, em três graus

Alcance não é uma lista só. Fundir esses três é o que transforma um mapa em ruído:

- **Direto** — precisa mudar para que o comportamento mude. É o menor conjunto honesto; se ele for grande, isso já é o achado.
- **Acoplado** — não muda, mas observa ou depende do que muda: chamadores, assinantes, relatórios, fixtures, testes, feature flags, qualquer coisa que leia o mesmo estado persistido. É onde o custo realmente se esconde, e onde um item não mapeado vira surpresa em produção.
- **Superfície de contrato** — visível fora desta base de código: formatos de requisição e resposta de API, esquema de banco, payloads de eventos, arquivos exportados, assinaturas públicas de funções em uma biblioteca compartilhada. Cruzar essa linha alcança consumidores que o mapa não enxerga. Nomeie a superfície e os consumidores conhecidos; não rastreie por dentro deles.

Para cada item: localização, grau e uma linha sobre *por que está no mapa*. Uma entrada cuja razão não é declarada não pode ser contestada, e um mapa que não pode ser contestado não é evidência.

## Passo 4 — Sobrepor o registro de áreas

Toda área tocada carrega seu **estado** e seu **nível de criticidade** registrados na configuração. Os dois são elicitados, nunca inferidos do nome de um diretório ou da idade de um arquivo — o bootstrap do `prime-config` deixa isso explícito, e esta skill não tem licença para suavizá-lo. Código declarado como exclusão (gerado ou de terceiros) entra no mapa como tal: a mudança nele vai para a origem — o gerador ou o fornecedor.

A sobreposição importa porque o mesmo alcance custa de forma diferente conforme o estado e o nível: os mesmos três arquivos numa área `current` e numa `legacy-maintained`, ou numa área `padrão` e numa `crítica`, não são a mesma mudança. Registre os dois; não os precifique. Precificar é da `feasibility-analysis`.

## Passo 5 — Sobrepor a camada documentada

Cruze o alcance com o que o repositório afirma ser verdade.

- **Cobertura por casos de uso.** Quais `UC-NNN` cobrem o comportamento tocado, citados por `CA-N` quando a cobertura é específica. Comportamento tocado sem caso de uso é uma **lacuna de documentação**: registre-a, nomeie a área e anote que o `use-case-extractor` é a rota. Ela não bloqueia este mapa — o mapa declara sua própria confiança reduzida e lista o que um caso de uso resolveria.
- **Divergência.** Onde o comportamento do código difere do caso de uso documentado, isso é um achado por si só, e muitas vezes a linha mais valiosa do relatório: o repositório deixou de ser a fonte de verdade para aquela área (`QM-DO-1`). Registre-a e roteie-a para as skills de caso de uso. **Nunca remende um caso de uso de dentro desta skill.**
- **Incidência de ADR.** Quais ADRs Accepted incidem sobre as áreas tocadas. Onde a mudança pretendida parece contradizer um, declare a contradição e cite o ADR. Não a resolva: um conflito com um ADR Accepted é uma decisão, e decisões pertencem ao arquiteto e ao ciclo de vida do ADR, nunca a um mapa.

## Passo 6 — Delimitar o mapa e declarar a borda

O alcance é transitivo; um mapa útil não é. Pare deliberadamente e diga onde:

- Pare na **superfície de contrato** — nomeie o consumidor, não entre nele.
- Pare onde **não há dependência comportamental** — compartilhar um pacote não é alcance.
- Pare quando o próximo salto **não acrescenta nada em que uma decisão se apoie**.

Depois escreva a borda: o que deliberadamente não foi rastreado e o que justificaria rastrear. Um mapa sem limites é inutilizável; um truncado em silêncio é pior, porque seu leitor acredita que o alcance está completo. Declarar a borda é o que permite à `feasibility-analysis` devolver *Undecidable with current evidence* em vez de julgar sobre um quadro parcial — uma borda aquém do que um veredito exige é um dos fundamentos nomeados dessa skill para a indecidibilidade, e só pode ser lida se este mapa a declarou.

## Saída

Um relatório de mapa de impacto — um artefato de trabalho do arquiteto, não um documento do repositório. Ele é
arquivado onde a demanda vive (tracker, thread de refinamento, PRD), nunca sob `docs/`: o repositório de
casos de uso é a fonte de verdade sobre o comportamento do sistema, e nada aqui compete com ele. Não
carrega número sequencial, não aparece em nenhuma configuração e não é mantido depois que a demanda segue adiante.

Seu cabeçalho é obrigatório, porque um mapa que não pode ser citado não pode ser consumido:

- **ID** — `IM-<demand-id>-N`, onde `<demand-id>` é o identificador da própria demanda no processo de refinamento do time e `N` distingue mapas sucessivos da mesma demanda. Derivado, nunca sequencial: o mapa tem o tempo de vida da demanda, não o do repositório.
- **Data** — o dia em que o código foi lido. Um mapa sem data não é citável; o alcance decai.
- **Demanda** — o que foi mapeado, nos termos de quem pediu.

O corpo contém:

1. **A mudança**, reformulada como comportamento, com sua fronteira explícita.
2. **O mapa**, separado por grau — direto, acoplado, superfície de contrato — cada entrada ancorada, localizada e justificada em uma linha.
3. **Estados das áreas**, do registro.
4. **A camada documentada** — cobertura por casos de uso, divergências encontradas, incidência de ADR.
5. **Lacunas e questões em aberto**, cada uma com o que a resolveria.
6. **Onde o mapa para**, e por quê.

Sem veredito, sem recomendação, sem estimativa. Se o leitor do relatório não consegue dizer se a mudança é uma boa ideia, a skill cumpriu seu papel.

A passada operacional e o template do relatório vivem em `checklists/impact-map-checklist.md`.

## Consumidores

- **`feasibility-analysis`** — executa este mapa primeiro e nunca julga sem ele. Lê graus, estados de área, incidência de ADR e a borda declarada; a borda é o que lhe permite devolver *Undecidable with current evidence* com honestidade, em vez de decidir sobre um quadro cujo fim ela não enxerga.
- **O arquiteto**, lendo-o diretamente para decidir onde olhar a seguir.

**Não é consumidor: o `its-generator`.** Um mapa tem escopo de uma *demanda* em refinamento; uma ITS tem escopo de *exatamente uma story*, e o refinamento pode durar meses entre os dois. Alimentar um plano de escopo de story com um mapa de escopo de demanda vai contra a única disciplina em que aquela skill se apoia — um delta, o da story — e, quando a ITS existe, o mapa já é velho o bastante para que verificá-lo custe o mesmo que derivá-lo do zero. O `its-generator` inspeciona o código ele mesmo, todas as vezes. O arquiteto pode, claro, ter lido este mapa; o que não acontece é um plano herdar um alcance que nunca verificou.

**Divergências encontradas aqui vão para as skills de caso de uso, nunca para uma ITS.** Uma divergência código × caso de uso é resolvida pelo `use-case-creator` ou pelo `use-case-extractor` antes da especificação, não carregada adiante para dentro de um plano de implementação.

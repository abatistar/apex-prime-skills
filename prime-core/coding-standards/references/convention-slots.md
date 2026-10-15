# Slots de Convenção

Catálogo canônico de slots de propriedade do `prime-core/coding-standards`. O SKILL.md define o que é um slot, as classes de aplicação, o registro de áreas, os padrões versionados, a disciplina de migração e as regras de consumo — este arquivo são os slots.

**Um slot é uma pergunta, não uma resposta.** Cada entrada declara a decisão que um projeto precisa ter tomado. Os valores vivem em `references/defaults-<stack>.md` (padrão do time, na release do Apex Prime que o projeto fixa) e no `docs/prime-config.md` (override do projeto, que vence). Um slot só existe onde há uma escolha a fazer: uma exigência sem alternativa é um critério do `prime-core/quality-model`, verificado por ferramenta, e não vira slot.

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

## AR — Arquitetura e dependências
*Aplica-se a: todos. Os slots de maior meia-vida e maior rendimento de automação — decida-os primeiro.*

- **CS-AR-1 [INVARIANT] — Direção permitida das dependências.** Qual camada ou módulo pode depender de qual, e qual direção é proibida, declarada como regra que uma ferramenta consegue verificar, não como diagrama. *Serve a:* `QM-CC-3`. *Verificação:* ferramenta.
- **CS-AR-2 [INVARIANT] — Onde as regras de negócio vivem.** A camada que é dona das decisões, as camadas que não devem conter nenhuma e como uma regra é exposta para que todo ponto que precisa dela a chame em vez de reimplementá-la. A erosão mais comum é a regra que migra para o controller ou para a consulta. *Serve a:* `QM-CC-6`. *Verificação:* revisão + ferramenta.
- **CS-AR-3 [INVARIANT] — Tipos que nunca cruzam uma fronteira.** Tipos de persistência expostos pela API, anotações de framework dentro do domínio, tipos de transporte chegando ao núcleo. Nomeie explicitamente os cruzamentos proibidos. *Serve a:* `QM-CC-3`, `QM-CC-7`. *Verificação:* ferramenta.
- **CS-AR-4 [CONVENTIONAL] — Agrupamento de módulos.** Por feature ou domínio, ou por camada técnica, em qual profundidade e o que um módulo expõe aos outros. *Serve a:* `QM-CC-2`. *Verificação:* ferramenta + revisão.
- **CS-AR-5 [CONVENTIONAL] — Estilo de comunicação entre módulos e entre serviços.** Chamada direta, interface publicada, evento de domínio, mensagem, chamada síncrona entre serviços. Qual é o padrão e o que justifica os demais. *Serve a:* `QM-CC-1`, `QM-CC-3`. *Verificação:* revisão.

## NM — Nomenclatura e estrutura
*Aplica-se a: todos.*

- **CS-NM-1 [CONVENTIONAL] — Sufixos semânticos.** Quais sufixos existem e o que cada um promete sobre a responsabilidade do tipo. Um sufixo que não significa nada é pior que nenhum. *Serve a:* `QM-CN-3`. *Verificação:* ferramenta.
- **CS-NM-2 [INVARIANT] — Nomes que carregam efeitos colaterais.** Quais prefixos afirmam pureza e quais anunciam I/O, mutação ou emissão de evento. Um nome que afirma uma coisa enquanto faz outra é um defeito, não uma preferência de estilo. *Serve a:* `QM-RC-1`. *Verificação:* revisão + ferramenta.
- **CS-NM-3 [CONVENTIONAL] — Onde um conceito vive.** A regra que liga um nome a um local, para que o leitor encontre um tipo sem precisar procurar. *Serve a:* `QM-RC-4`, `QM-CC-2`. *Verificação:* revisão.

## ER — Erros
*Aplica-se a: todos.*

- **CS-ER-1 [CONVENTIONAL] — Erro esperado vs. defeito: representação.** Como uma situação de domínio é sinalizada versus um invariante violado. *Serve a:* `QM-EO-5`. *Verificação:* revisão.
- **CS-ER-2 [CONVENTIONAL] — Taxonomia de erros.** A hierarquia base ou o tipo de resultado, e como uma nova categoria de erro é adicionada. *Serve a:* `QM-EO-5`, `QM-CN-3`. *Verificação:* revisão.
- **CS-ER-3 [CONVENTIONAL] — Onde os erros são capturados e traduzidos.** A camada com contexto suficiente para decidir e as camadas que apenas propagam. *Serve a:* `QM-EO-6`. *Verificação:* revisão + ferramenta.
- **CS-ER-4 [INVARIANT] — Duas audiências.** O que quem chama recebe — formato e conteúdo do erro no fio — versus o que o operador recebe. Genérico e seguro para fora, detalhe completo para dentro. *Serve a:* `QM-EO-2`. *Verificação:* teste.
- **CS-ER-5 [INVARIANT] — Preservação da causa.** Como a propagação carrega a causa original e o stack nesta stack. *Serve a:* `QM-EO-3`. *Verificação:* ferramenta.
- **CS-ER-6 [INVARIANT] — Sem engolir em silêncio.** As formas concretas proibidas nesta stack — catch vazio, retorno ignorado, nulo no lugar de um sinal de falha. *Serve a:* `QM-EO-1`. *Verificação:* ferramenta.
- **CS-ER-7 [CONVENTIONAL] — Ausência de valor.** Como "não há valor" é representado — tipo opcional, nulidade declarada no tipo, objeto vazio —, onde o nulo nunca cruza e qual ferramenta verifica. *Serve a:* `QM-RC-1`, `QM-EO-1`. *Verificação:* ferramenta.

## OB — Observabilidade
*Aplica-se a: todos.*

- **CS-OB-1 [CONVENTIONAL] — Formato de log e semântica dos níveis.** O que cada nível realmente significa aqui e a forma estruturada que torna as linhas pesquisáveis. *Serve a:* `QM-EO-8`. *Verificação:* ferramenta + revisão.
- **CS-OB-2 [INVARIANT] — Propagação de correlação.** O formato em que um identificador de requisição é criado, carregado entre chamadas e serviços e chega a cada linha. Um formato só, para que uma requisição possa ser seguida através de todos os componentes. *Serve a:* `QM-EO-7`, `QM-EO-8`. *Verificação:* teste.
- **CS-OB-3 [INVARIANT] — A denylist de logs.** A lista fechada do que nunca é escrito num log ou numa mensagem de erro: credenciais, tokens, dados das classes protegidas (`CS-SC-6`), payloads que os contenham. A linha isolada de maior retorno deste catálogo. *Serve a:* `QM-EO-2`, `QM-SR-10`. *Verificação:* teste + ferramenta.
- **CS-OB-4 [CONVENTIONAL] — O que precisa ser instrumentado.** Os caminhos que carregam métricas e traces por padrão, por nível de criticidade, para que a instrumentação seja sistemática em vez de lembrada. *Serve a:* `QM-EO-7`. *Verificação:* revisão.
- **CS-OB-5 [INVARIANT] — Eventos de segurança e auditoria.** Quais eventos são registrados, com quais campos, para qual destino e com que retenção — separados do log operacional e sem o dado protegido. *Serve a:* `QM-SR-9`. *Verificação:* teste.

## DA — Dados e transações
*Aplica-se a: `serviço`.*

- **CS-DA-1 [CONVENTIONAL] — Fronteira transacional.** Onde uma transação abre e fecha, quais camadas nunca abrem uma e o que nunca acontece dentro dela. *Serve a:* `QM-RB-4`. *Verificação:* ferramenta + revisão.
- **CS-DA-2 [CONVENTIONAL] — Idempotência.** Quais operações precisam ser seguras para repetir e como a repetição é detectada. *Serve a:* `QM-RB-3`. *Verificação:* teste.
- **CS-DA-3 [CONVENTIONAL] — Convenção de migrações.** Ferramenta, nomenclatura e ordenação dos arquivos de migração. A compatibilidade com a versão em produção é contrato (`CS-CT-1`). *Serve a:* `QM-CN-3`. *Verificação:* ferramenta.
- **CS-DA-4 [INVARIANT] — Migrações aplicadas são imutáveis.** Uma migração que rodou em qualquer ambiente nunca é editada; a correção é uma nova migração. *Serve a:* `QM-CC-7`. *Verificação:* ferramenta.
- **CS-DA-5 [CONVENTIONAL] — Disciplina de carregamento.** A estratégia padrão de busca e como uma consulta declara o que precisa, para que o N+1 seja prevenido por convenção em vez de descoberto em produção. *Serve a:* `QM-EF-1`, `QM-EF-3`. *Verificação:* teste.
- **CS-DA-6 [CONVENTIONAL] — Consistência entre recursos.** O mecanismo padrão quando uma operação altera mais de um recurso — banco e evento, dois bancos, banco e serviço — e o que nunca é feito. *Serve a:* `QM-RB-4`. *Verificação:* revisão + teste.
- **CS-DA-7 [CONVENTIONAL] — Controle de concorrência.** O protocolo padrão para estado alterado concorrentemente, a resposta ao conflito e a proteção de trabalho agendado contra execução simultânea. *Serve a:* `QM-RB-5`. *Verificação:* revisão + teste.

## RS — Resiliência
*Aplica-se a: todos.*

- **CS-RS-1 [INVARIANT] — Timeouts e repetição.** Os timeouts padrão por tipo de dependência, onde são configurados, quais falhas são repetidas, quantas vezes e com que espera. Os valores existem para que a ITS e o código tenham de onde tirá-los em vez de inventá-los. *Serve a:* `QM-RB-1`. *Verificação:* ferramenta + teste.
- **CS-RS-2 [CONVENTIONAL] — Isolamento e degradação.** O mecanismo que contém a falha de uma dependência, quando ele é obrigatório por nível de criticidade e como a degradação é declarada. *Serve a:* `QM-RB-6`. *Verificação:* revisão + teste.

## CT — Contratos externos
*Aplica-se a: todos.*

- **CS-CT-1 [INVARIANT] — Sem quebra silenciosa de contrato.** O que conta como quebra para cada contrato publicado — API, evento, arquivo trocado e o esquema de banco compartilhado com a versão em produção — e a rota que uma quebra precisa seguir: versionamento, período de convivência, mudança de esquema em etapas. *Aplica-se a:* `serviço`. *Serve a:* `QM-CC-7`. *Verificação:* ferramenta + teste.
- **CS-CT-2 [INVARIANT] — Forma das coleções.** Paginação, limite no servidor, filtragem, ordenação e o envelope — decididos uma vez, idênticos em todo o sistema. *Serve a:* `QM-EF-1`, `QM-CN-3`. *Verificação:* teste.
- **CS-CT-3 [CONVENTIONAL] — Fronteira de serialização.** Os tipos que carregam o contrato, distintos do modelo de domínio, e onde a tradução acontece. *Serve a:* `QM-CC-3`, `QM-CC-7`. *Verificação:* ferramenta + teste.
- **CS-CT-4 [INVARIANT] — Representações canônicas.** Tempo, dinheiro, quantidade e identificadores. Cada um tem exatamente uma representação em todo o sistema, e as representações que corrompem valor (dinheiro em ponto flutuante, instante sem fuso) são proibidas. *Serve a:* `QM-CN-1`, `QM-CC-7`. *Verificação:* revisão + ferramenta.

## TS — Testes
*Aplica-se a: todos.*

- **CS-TS-1 [INVARIANT] — O que obriga um teste.** As categorias de mudança que nunca entram em merge sem teste, e o tipo de teste que cada uma exige. Todo o resto é julgamento; isto não é. *Serve a:* `QM-TS-7`. *Verificação:* revisão.
- **CS-TS-2 [CONVENTIONAL] — Organização e nomenclatura.** Onde os testes vivem, como os tipos são distinguidos e a nomenclatura que declara cenário e expectativa. *Serve a:* `QM-TS-5`. *Verificação:* ferramenta.
- **CS-TS-3 [CONVENTIONAL] — O que é substituído por dublê.** As fronteiras substituídas e o código exercitado de verdade. *Serve a:* `QM-TS-2`, `QM-TS-3`. *Verificação:* revisão.
- **CS-TS-4 [INVARIANT] — Determinismo.** As proibições concretas que mantêm a suíte confiável: sem dormir esperando timing, sem dependência de ordem, sem estado compartilhado entre testes, sem relógio real. *Serve a:* `QM-TS-1`, `QM-TS-6`. *Verificação:* ferramenta.
- **CS-TS-5 [INVARIANT] — Desativação de teste.** Como um teste sai da suíte — a marca, o motivo, o item de backlog que o traz de volta —, o que nunca é feito em seu lugar e como a alteração de uma asserção existente é justificada na mudança. *Serve a:* `QM-TS-1`, `QM-TS-8`. *Verificação:* ferramenta.

## SC — Segurança
*Aplica-se a: todos. Apenas posicionamento concreto: os princípios são os `QM-SR-*`, e a lista exaustiva de controles pertence ao padrão externo que o projeto adota (`CS-SC-5`), nunca a uma cópia reescrita aqui.*

- **CS-SC-1 [INVARIANT] — Onde e como a autorização é imposta.** A camada única que decide, como a negação por padrão é configurada, como a titularidade de um recurso é verificada e a declaração explícita de que nenhuma verificação no cliente conta. *Aplica-se a:* `serviço`. *Serve a:* `QM-SR-8`. *Verificação:* teste + revisão.
- **CS-SC-2 [INVARIANT] — Validação na fronteira.** Onde a entrada externa é validada e neutralizada, as separações entre dado e código que nunca são opcionais e a codificação de saída por contexto. *Serve a:* `QM-SR-1`. *Verificação:* ferramenta + revisão.
- **CS-SC-3 [INVARIANT] — Segredos.** Onde as credenciais vivem, como chegam ao processo e a expectativa de rotação. *Serve a:* `QM-SR-2`. *Verificação:* ferramenta.
- **CS-SC-4 [INVARIANT] — Criptografia e armazenamento de credenciais.** As bibliotecas e os algoritmos sancionados. *Serve a:* `QM-SR-3`. *Verificação:* ferramenta.
- **CS-SC-5 [INVARIANT] — Padrão externo e nível.** O padrão de segurança que o projeto adota e em qual nível, por nível de criticidade, referenciado em vez de transcrito. *Serve a:* `QM-SR-1`, `QM-SR-5`, `QM-SR-6`, `QM-SR-8`. *Verificação:* revisão.
- **CS-SC-6 [INVARIANT] — Classificação de dados.** As classes de dado protegido — pessoal, sensível, financeiro, credencial —, como um campo carrega sua classe e o que cada classe impõe: exposição, mascaramento, log, retenção. *Serve a:* `QM-SR-10`, `QM-EO-2`. *Verificação:* revisão + teste.

## DP — Dependências de terceiros
*Aplica-se a: todos.*

- **CS-DP-1 [INVARIANT] — Admissão de dependência.** O que uma nova dependência precisa satisfazer — problema que resolve, manutenção, licença, pegada —, como sua identidade é conferida no repositório oficial, como a versão é fixada e quem aprova. *Serve a:* `QM-SR-4`, `QM-CN-1`. *Verificação:* ferramenta + revisão.
- **CS-DP-2 [INVARIANT] — Uma biblioteca por preocupação.** Uma preocupação já atendida por uma biblioteca sancionada não adquire uma segunda. É assim que uma base acaba com três bibliotecas de data. *Serve a:* `QM-CN-1`. *Verificação:* ferramenta.
- **CS-DP-3 [INVARIANT] — Dependências com vulnerabilidades conhecidas.** A política para entregar com um alerta de vulnerabilidade aberto, e quem é dono da exceção. *Serve a:* `QM-SR-4`. *Verificação:* ferramenta.

## EV — Evolução e dívida
*Aplica-se a: todos.*

- **CS-EV-1 [INVARIANT] — Feature flags.** O mecanismo, a nomenclatura, o valor padrão e a condição de remoção que toda flag carrega desde que nasce. Uma flag sem condição de remoção é dívida permanente com interruptor. *Serve a:* `QM-MT-1`, `QM-MT-4`. *Verificação:* revisão.
- **CS-EV-2 [INVARIANT] — Marcação de dívida no código.** O formato de um marcador de dívida — com o item de backlog que o acompanha — e os marcadores que não são usados. Um marcador sem item é dívida invisível com enfeite. *Serve a:* `QM-MT-1`. *Verificação:* ferramenta.

## PR — Soluções canônicas e proibições
*Aplica-se a: todos. A única forma de "padrão de projeto" que este catálogo guarda: nenhum slot exige um padrão pelo nome; cada um declara o problema e a solução sancionada, e a estrutura decorre disso.*

- **CS-PR-1 [CONVENTIONAL] — Registro de soluções canônicas.** Para cada problema recorrente *neste* sistema, a solução acordada e o exemplo canônico no repositório. Chamar um serviço externo, publicar um evento, agendar trabalho, tratar falha parcial. Cresce por observação, não por antecipação. *Serve a:* `QM-CN-1`, `QM-CN-3`. *Verificação:* revisão.
- **CS-PR-2 [INVARIANT] — Padrões proibidos.** Uma lista curta, cada item com a falha concreta que lhe valeu um lugar e o critério que protege. Uma proibição sem razão é folclore e será violada no momento em que seu autor sair. *Serve a:* conforme cada item. *Verificação:* ferramenta.

---

## IDs reclassificados, movidos e aposentados

Mantidos aqui porque artefatos anteriores citam estes slots. O registro do motivo é o PR de governança.

- **Classes redefinidas pelo alcance.** INVARIANT passou a significar "vale em qualquer área" — proibição ou forma única do sistema —, e não mais "concretiza um inegociável". Reclassificados de CONVENTIONAL para INVARIANT: `CS-OB-2`, `CS-CT-2`, `CS-CT-4`, `CS-SC-5` e `CS-DP-1`.
- **Conteúdo movido.** A repetição saiu de `CS-DA-2`, que ficou só com a idempotência, para `CS-RS-1`. A compatibilidade de esquema saiu de `CS-DA-3` para `CS-CT-1`.
- **CS-PR-3 — aposentado.** "Nenhum padrão prescrito pelo nome" é uma regra sobre o catálogo, não uma decisão de projeto; vive agora no cabeçalho da família PR.

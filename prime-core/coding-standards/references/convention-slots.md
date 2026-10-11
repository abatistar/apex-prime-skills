# Slots de Convenção — v1.0

Catálogo canônico de slots de propriedade do `prime-core/coding-standards`. O SKILL.md define as classes de aplicação, o registro de legado, a disciplina de migração e as regras de consumo — este arquivo são os slots.

**Um slot é uma pergunta, não uma resposta.** Cada entrada declara a decisão que um projeto precisa ter tomado, sua classe de aplicação e o critério de qualidade que ela torna verificável. Os valores vivem em `references/defaults-<stack>.md` (padrão do time) e no `docs/prime-config.md` (override do projeto, que vence).

**Classes.** **[INVARIANT]** vale para toda linha escrita ou alterada, independentemente do entorno. **[CONVENTIONAL]** remete ao padrão local em áreas legadas registradas.

**Não preenchido é uma lacuna, não uma escolha.** Um slot sem valor é reportado, nunca improvisado.

Cite os slots por ID. Os IDs são estáveis e nunca renumerados.

---

## O piso invariante num relance

Os slots que valem independentemente do que cerca a mudança. Todo o resto do catálogo remete ao estado registrado da área.

`CS-AR-1` direção das camadas · `CS-AR-2` onde vivem as regras de negócio · `CS-AR-3` tipos de fronteira · `CS-NM-2` nomes honestos · `CS-ER-4` duas audiências · `CS-ER-5` cadeia de causas · `CS-ER-6` sem engolir em silêncio · `CS-OB-3` denylist de logs · `CS-DA-4` migrações aplicadas são imutáveis · `CS-CT-1` sem quebra silenciosa de contrato · `CS-TS-1` o que obriga um teste · `CS-TS-4` testes determinísticos · `CS-SC-1` onde fica a autorização · `CS-SC-2` validação na fronteira · `CS-SC-3` segredos · `CS-SC-4` criptografia · `CS-DP-2` uma biblioteca por preocupação · `CS-DP-3` dependências vulneráveis · `CS-PR-2` padrões proibidos

---

## AR — Arquitetura e dependências

*Os slots de maior meia-vida e maior rendimento de automação. Decida-os primeiro.*

- **CS-AR-1 [INVARIANT]** — **Direção permitida das dependências.** Qual camada ou módulo pode depender de qual, e qual direção é proibida. Declarada como uma regra que uma ferramenta consegue verificar, não como um diagrama. Serve ao `QM-CC-3`.
- **CS-AR-2 [INVARIANT]** — **Onde as regras de negócio podem viver.** A camada que é dona das decisões e as camadas que não devem conter nenhuma. A erosão mais comum é a regra que migra para o controller ou para a query.
- **CS-AR-3 [INVARIANT]** — **Tipos que nunca cruzam uma fronteira.** Tipos de persistência expostos pela API, anotações de framework dentro do domínio, tipos de transporte chegando ao core. Nomeie explicitamente os cruzamentos proibidos.
- **CS-AR-4 [CONVENTIONAL]** — **Agrupamento de módulos.** Por feature/domínio ou por camada técnica, e em qual profundidade. Serve ao `QM-CC-2`.
- **CS-AR-5 [CONVENTIONAL]** — **Estilo de comunicação entre módulos.** Chamada direta, interface publicada, evento de domínio, mensagem. Qual é o padrão e o que justifica os demais.

## NM — Nomenclatura e estrutura

- **CS-NM-1 [CONVENTIONAL]** — **Sufixos semânticos.** Quais sufixos existem e o que cada um promete sobre a responsabilidade do tipo. Um sufixo que não significa nada é pior que nenhum.
- **CS-NM-2 [INVARIANT]** — **Nomes que carregam efeitos colaterais.** Quais prefixos afirmam pureza e quais anunciam I/O, mutação ou emissão de evento. É o `QM-RC-1` tornado verificável: um nome que afirma uma coisa enquanto faz outra é um defeito, não uma preferência de estilo.
- **CS-NM-3 [CONVENTIONAL]** — **Onde um conceito vive.** A regra que liga um nome a um local, para que o leitor encontre um tipo sem precisar procurar.

## ER — Erros

- **CS-ER-1 [CONVENTIONAL]** — **Erro esperado vs. bug: representação.** Como uma situação de domínio é sinalizada versus um invariante violado. Serve ao `QM-EO-5`.
- **CS-ER-2 [CONVENTIONAL]** — **Taxonomia de erros.** A hierarquia base ou o tipo de resultado, e como uma nova categoria de erro é adicionada.
- **CS-ER-3 [CONVENTIONAL]** — **Onde os erros são capturados e traduzidos.** A camada com contexto suficiente para decidir (`QM-EO-6`) e as camadas que devem apenas propagar.
- **CS-ER-4 [INVARIANT]** — **Duas audiências.** O que o chamador recebe versus o que o operador recebe. Concretiza o `QM-EO-2`: genérico e seguro para fora, detalhe completo para dentro.
- **CS-ER-5 [INVARIANT]** — **Preservação da causa.** A propagação carrega a causa original e o stack. Concretiza o `QM-EO-3`.
- **CS-ER-6 [INVARIANT]** — **Sem engolir em silêncio.** As formas concretas proibidas nesta stack — catch vazio, retorno ignorado, null no lugar de um sinal de falha. Concretiza o `QM-EO-1`.

## OB — Observabilidade

- **CS-OB-1 [CONVENTIONAL]** — **Formato de log e semântica dos níveis.** O que cada nível realmente significa aqui, e a forma estruturada que torna as linhas pesquisáveis. Serve ao `QM-EO-8`.
- **CS-OB-2 [CONVENTIONAL]** — **Propagação de correlação.** Como um identificador de requisição é criado, carregado entre chamadas e chega a cada linha.
- **CS-OB-3 [INVARIANT]** — **A denylist de logs.** A lista fechada do que nunca é escrito em um log ou mensagem de erro: credenciais, tokens, dados pessoais, payloads que os contenham. A linha isolada de maior retorno neste catálogo.
- **CS-OB-4 [CONVENTIONAL]** — **O que precisa ser instrumentado.** Os caminhos que carregam métricas e traces por padrão, para que a instrumentação seja sistemática em vez de lembrada. Serve ao `QM-EO-7`.

## DA — Dados e transações

- **CS-DA-1 [CONVENTIONAL]** — **Fronteira transacional.** Onde uma transação abre e fecha, e quais camadas nunca devem abrir uma.
- **CS-DA-2 [CONVENTIONAL]** — **Idempotência e retry.** Quais operações precisam ser seguras para repetir e como a repetição é detectada. Serve ao `QM-SR-7`.
- **CS-DA-3 [CONVENTIONAL]** — **Convenção de migrações.** Nomenclatura, ordenação e a regra de compatibilidade para deploys que sobrepõem versões.
- **CS-DA-4 [INVARIANT]** — **Migrações aplicadas são imutáveis.** Uma migração que rodou em qualquer lugar nunca é editada; a correção é uma nova migração.
- **CS-DA-5 [CONVENTIONAL]** — **Disciplina de carregamento.** A estratégia padrão de busca e como uma query declara o que precisa, de modo que o N+1 seja prevenido por convenção em vez de descoberto em produção.

## CT — Contratos externos

- **CS-CT-1 [INVARIANT]** — **Sem quebra silenciosa de contrato.** O que conta como quebra para um contrato publicado, e a rota de versionamento que uma quebra precisa seguir.
- **CS-CT-2 [CONVENTIONAL]** — **Forma das coleções.** Paginação, filtragem, ordenação e o envelope — decididos uma vez, idênticos em todo lugar.
- **CS-CT-3 [CONVENTIONAL]** — **Fronteira de serialização.** Os tipos que carregam o contrato, distintos do modelo de domínio, e onde a tradução acontece.
- **CS-CT-4 [CONVENTIONAL]** — **Representações canônicas.** Tempo, dinheiro, quantidade e identificadores. Cada um tem exatamente uma representação em todo o sistema.

## TS — Testes

- **CS-TS-1 [INVARIANT]** — **O que obriga um teste.** As categorias de mudança que nunca entram em merge sem teste. Todo o resto é julgamento; isto não é.
- **CS-TS-2 [CONVENTIONAL]** — **Organização e nomenclatura.** Onde os testes vivem, como os tipos são distinguidos e a nomenclatura que declara cenário e expectativa. Serve ao `QM-TS-5`.
- **CS-TS-3 [CONVENTIONAL]** — **O que é mockado.** As fronteiras substituídas por dublês e o código exercitado de verdade. Serve ao `QM-TS-3`.
- **CS-TS-4 [INVARIANT]** — **Determinismo.** As proibições concretas que mantêm a suíte confiável: sem dormir esperando timing, sem dependência de ordem, sem estado compartilhado entre testes. Serve ao `QM-TS-1` e ao `QM-TS-6` — uma suíte ocasionalmente vermelha ensina o time a ignorar o vermelho.

## SC — Segurança

*Apenas posicionamento concreto. Os princípios são os `QM-SR-*`; a lista exaustiva de controles pertence a um padrão externo que o projeto adota (`CS-SC-5`), nunca a uma cópia reescrita aqui.*

- **CS-SC-1 [INVARIANT]** — **Onde a autorização é imposta.** A camada única que decide, e a declaração explícita de que nenhuma verificação no cliente conta.
- **CS-SC-2 [INVARIANT]** — **Validação na fronteira.** Onde a entrada externa é validada e neutralizada, e as separações dado/código que nunca são opcionais. Concretiza o `QM-SR-1`.
- **CS-SC-3 [INVARIANT]** — **Segredos.** Onde as credenciais vivem, como chegam ao processo e a expectativa de rotação. Concretiza o `QM-SR-2`.
- **CS-SC-4 [INVARIANT]** — **Criptografia e armazenamento de credenciais.** As bibliotecas e algoritmos sancionados. Concretiza o `QM-SR-3`.
- **CS-SC-5 [CONVENTIONAL]** — **Padrão externo e nível.** O padrão de segurança que o projeto adota e em qual nível, referenciado em vez de transcrito.

## DP — Dependências de terceiros

- **CS-DP-1 [CONVENTIONAL]** — **Critérios de admissão.** O que uma nova dependência precisa satisfazer — manutenção, licença, pegada — e quem a aprova.
- **CS-DP-2 [INVARIANT]** — **Uma biblioteca por preocupação.** Uma preocupação já atendida por uma biblioteca sancionada não adquire uma segunda. É o `QM-CN-1` no nível das dependências, e é assim que uma base de código acaba com três bibliotecas de data.
- **CS-DP-3 [INVARIANT]** — **Dependências com vulnerabilidades conhecidas.** A política para entregar com um advisory aberto, e quem é dono da exceção. Concretiza o `QM-SR-4`.

## PR — Soluções canônicas e proibições

*A única forma de "padrão de projeto" que este catálogo guarda. Prescrever padrões nomeados produz cerimônia; catalogar a solução acordada para um problema recorrente produz consistência.*

- **CS-PR-1 [CONVENTIONAL]** — **Registro de soluções canônicas.** Para cada problema recorrente *neste* sistema, a solução acordada e onde vive um exemplo. Chamar um serviço externo, publicar um evento, agendar trabalho, tratar falha parcial. Cresce por observação, não por antecipação.
- **CS-PR-2 [INVARIANT]** — **Padrões proibidos.** Uma lista curta, cada item com a falha concreta que lhe valeu um lugar. Uma proibição sem razão é folclore e será violada no momento em que seu autor sair.
- **CS-PR-3 [CONVENTIONAL]** — **Nenhum padrão prescrito pelo nome.** Os padrões declaram o problema e a solução sancionada; nunca exigem um padrão nomeado como tal. Estrutura especulativa é dívida por si só (`QM-MT-4`).

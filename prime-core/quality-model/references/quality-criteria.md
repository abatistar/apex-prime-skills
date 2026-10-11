# Critérios de Qualidade — v1.0

Catálogo canônico de critérios de propriedade do `prime-core/quality-model`. O SKILL.md define os níveis, a disciplina de exceção, o versionamento, as fronteiras e as regras de consumo — este arquivo são os critérios. Esta é uma **definição** do alvo, não um gate de enforcement: o código novo é construído contra ela, e as skills de papel a referenciam para questionar seus entregáveis. Cite os critérios por ID (`QM-XX-N`). Os IDs são estáveis e nunca renumerados; mudanças de versão passam pelo PR de governança, que é o registro do que mudou e por quê.

**Estrela-guia.** Qualidade é uma única propriedade — *o sistema é seguro, previsível e barato de mudar ao longo do tempo* — vista de oito ângulos. As dimensões abaixo são lentes sobre ela, não um checklist independente.

**Níveis (a natureza de um critério, não uma consequência automática).**
- **[NON-NEGOTIABLE]** — um pecado capital: o piso para código novo. Não negociável *em silêncio* — cumprido, ou desrespeitado como uma exceção nomeada, deliberada e com responsável (veja abaixo).
- **[CALIBRATED]** — julgamento contra o contexto, declarado com sua tensão honesta. O modelo dá o critério e o trade-off; o leitor calibra. Nunca uma regra a aplicar mecanicamente.
- **[AUTOMATE]** — de responsabilidade das ferramentas. A atenção humana gasta rediscutindo-o é desperdício; o que vale levantar é a sua ausência na toolchain.

**A regra de calibração (vale para toda dimensão).** O excesso é tão danoso quanto a deficiência. A régua é proporcional à vida útil esperada e à importância do código e ao modelo de ameaças realista. Maturidade é saber quando um critério deixa de se aplicar.

**Exceções (legado e dívida deliberada).** O modelo descreve o alvo; o código real se desvia dele por legado e por dívida escolhida, e isso é legítimo. A regra é *silencioso versus deliberado*: um desvio é aceitável quando nomeado, justificado e com responsável (um comentário, um item de backlog ou um ADR) — o pecado é o desvio invisível, não a dívida. O modelo se aplica ao código que você **escreve e altera**, não retroativamente a todo o legado; no código existente, seguir o padrão local (`QM-CN-2`) é, ele mesmo, um critério. Os critérios de segurança (`QM-SR-*`) carregam a régua de exceção mais alta — uma lacuna silenciosa ali pode ser fatal por si só.

---

## O piso do core — pecados capitais num relance

Os inegociáveis, reunidos para varredura. Cada um é o piso para código novo e só pode ser desrespeitado como uma exceção nomeada, deliberada e com responsável. Todo o resto do catálogo é julgamento estruturado.

- **QM-RC-1** — Sem nomes que mentem, sem efeitos colaterais ocultos; o código faz o que parece fazer.
- **QM-TS-1** — Nenhum teste instável (flaky) deixado na suíte: corrija imediatamente ou remova.
- **QM-TS-2** — Testes verificam comportamento, não implementação.
- **QM-TS-4** — Cobertura nunca é gate de merge; lida apenas como sinal negativo.
- **QM-CC-1** — Sem acoplamento entre módulos por estado mutável compartilhado.
- **QM-CN-1** — Sem erosão: padrões estabelecidos mudam de forma deliberada e em bloco, nunca aos poucos.
- **QM-CN-2** — A consistência com o código ao redor vence a preferência pessoal.
- **QM-EO-1** — Nunca engula um erro em silêncio.
- **QM-EO-2** — Nunca vaze dados sensíveis em logs ou mensagens de erro, nem exponha detalhes internos ao usuário final.
- **QM-EO-3** — Preserve a cadeia de causas e o stack trace ao propagar.
- **QM-MT-1** — Sem dívida deliberada invisível: um atalho tomado de propósito é nomeado quando tomado.
- **QM-DO-1** — A documentação não pode mentir; vive ao lado do que descreve.
- **QM-SR-1** — Nunca confie em entrada externa: valide na fronteira, mantenha dados separados de código.
- **QM-SR-2** — Sem segredos no código-fonte ou no controle de versão.
- **QM-SR-3** — Não invente criptografia; nunca armazene senhas em texto claro ou de forma reversível.
- **QM-SR-4** — Não entregue dependências com vulnerabilidades conhecidas.

---

## RC — Legibilidade e clareza
*Princípio unificador: minimizar a carga cognitiva — quanto um leitor precisa manter na memória de trabalho para entender um trecho isoladamente.*

- **QM-RC-1 [NON-NEGOTIABLE]** — Princípio da menor surpresa. O código faz o que parece fazer. Um nome ou assinatura não pode ocultar mutação de estado, I/O ou eventos (nenhum `getX` que também escreve; nenhum "read" que muta estado global ou dispara um evento). Nomes não podem mentir.
- **QM-RC-2 [CALIBRATED]** — Funções são curtas, fazem uma coisa, em um único nível de abstração (sem detalhe em nível de byte misturado a orquestração de alto nível). *Tensão: não é uma regra de contagem de linhas; a fragmentação excessiva em funções minúsculas prejudica a legibilidade tanto quanto os monólitos.*
- **QM-RC-3 [CALIBRATED]** — Achate o aninhamento com guard clauses / retornos antecipados; a complexidade ciclomática alta é o sintoma mensurável. *Tensão: limiar, não absoluto — julgue pela carga do leitor.*
- **QM-RC-4 [CALIBRATED]** — Mantenha próximo o que muda junto (localidade). Duplicação é mais barata que a abstração errada; abstrações devem ser "profundas" (interface simples escondendo complexidade real), não "rasas" (indireção que não esconde nada). *Tensão: o DRY levado ao extremo destrói a localidade — um pouco de duplicação pode ser o preço certo.*
- **QM-RC-5 [CALIBRATED]** — Comentários explicam o *porquê*, não o *quê*; código autoexplicativo primeiro, comentários para o resíduo irredutível (restrição externa, bug evitado, escolha não óbvia). *Tensão: um comentário que repete o código apodrece e vira mentira; um comentário que explica o *quê* um bloco confuso faz geralmente sinaliza que o bloco deve ser reescrito.*
- **QM-RC-6 [CALIBRATED]** — Sem esperteza que otimiza o ego de quem escreve em vez do tempo de quem lê (one-liners densos, golfe de truques da linguagem). Otimize para o leitor — a audiência mais frequente.
- **Nota de audiência.** A legibilidade é relativa ao time que mantém o código; não há absoluto. O teste mais confiável não é uma métrica, e sim a revisão: cada "o que isto faz?" / "por que assim?" é um ponto em que o código falhou em se explicar.
- **[AUTOMATE]** — Métricas de complexidade como sinais (não veredito). A formatação pertence a CN.

## TS — Testes automatizados confiáveis
*Princípio unificador: confiança para mudar. Um teste vale o quanto permite alterar o código sabendo que uma quebra real será detectada e que um teste verde significa comportamento preservado.*

- **QM-TS-1 [NON-NEGOTIABLE]** — Um teste instável (flaky) é corrigido imediatamente ou removido. Deixá-lo treina o time a ignorar o vermelho, o que destrói a autoridade de toda a suíte.
- **QM-TS-2 [NON-NEGOTIABLE]** — Testes verificam comportamento observável, não a implementação interna. Teste de ouro: *se eu reescrever a implementação preservando o comportamento, este teste ainda passa?* Se não, ele testa a coisa errada e pune o refactoring que deveria viabilizar.
- **QM-TS-4 [NON-NEGOTIABLE]** — Um percentual de cobertura nunca é usado como gate de merge (Goodhart). A cobertura é lida apenas como sinal negativo: cobertura baixa sinaliza teste fraco; cobertura alta não prova nada sobre as asserções.
- **QM-TS-3 [CALIBRATED]** — Prefira testar código real dentro do orçamento de velocidade/estabilidade; faça mock das fronteiras que você não controla, teste o núcleo que você controla. *Tensão: pirâmide vs. troféu é ajuste de pesos, não lei; mocks compram velocidade e isolamento ao preço do realismo — use onde o preço compensa.*
- **QM-TS-5 [CALIBRATED]** — Legibilidade do teste: um motivo para falhar, arrange-act-assert claro, nomes que declaram o cenário e o resultado esperado. *Tensão: um teste que afirma quinze coisas não diz nada quando falha.*
- **QM-TS-6 [CALIBRATED]** — Determinismo e isolamento: cada teste monta e desmonta seu próprio mundo, independente de ordem. Cubra também os caminhos de erro/falha, não só o caminho feliz — tratamento de erro não testado costuma ser código que nunca rodou.
- **Pergunta orientadora.** *Esta suíte me deixa mudar o sistema com confiança e velocidade?* Se mexer no código dói por causa dos testes, algo neles está errado, por mais verdes que estejam. (Cuidado com o "dano de design induzido por testes": os testes servem ao código, não o contrário.)
- **[AUTOMATE]** — Suíte no CI; detecção de testes instáveis; teste de mutação como o sinal mais profundo da qualidade dos testes.

## CC — Acoplamento e coesão
*Princípio unificador: conter o raio de impacto de uma mudança — uma mudança de negócio deve caber numa região pequena e previsível do código.*

- **QM-CC-1 [NON-NEGOTIABLE]** — Sem acoplamento por estado mutável compartilhado (memória global ou mutável compartilhada) entre módulos. É o pior tipo porque é invisível na interface — nada nas assinaturas revela o vínculo, e ele aflora como bugs à distância. O acoplamento temporal oculto e o acoplamento por tabela de banco compartilhada caem sob a mesma proibição quando deixados implícitos.
- **QM-CC-2 [CALIBRATED]** — Coesão por "muda pelo mesmo motivo, a pedido do mesmo envolvido" (SRP corretamente entendido). Prefira agrupamento por feature/domínio a agrupamento por camada técnica. *Tensão: um módulo que atende dois envolvidos diferentes tem dois motivos para mudar e eles vão colidir — mas forçar coisas não relacionadas a ficar juntas para parecer arrumado é pior.*
- **QM-CC-3 [CALIBRATED]** — O *tipo* de acoplamento importa mais que a quantidade (zero é impossível). Evite acoplamento de controle (flags que alternam comportamento oculto) e acoplamento de estrutura; as dependências apontam para a estabilidade (o volátil depende do estável, nunca o contrário); aplique inversão de dependência onde a volatilidade difere. *Tensão: o acoplamento que você previu e conteve numa fronteira limpa raramente é o problema.*
- **QM-CC-4 [CALIBRATED]** — Lei de Demeter como cheiro, não como lei: cadeias longas de pontos (`a.b.c.d`) acoplam você à forma interna de coisas que não são suas. *Tensão: o encadeamento é aceitável em estruturas de dados puras — trate-o como um cheiro confiável, não como proibição.*
- **QM-CC-5 [CALIBRATED]** — Desacople pela *probabilidade de mudança independente*. Desacoplar coisas que sempre mudam juntas é custo puro; toda indireção é inimiga da localidade. *Tensão: abstração prematura / generalidade especulativa é indistinguível de dívida — YAGNI.*
- **Sinal.** "Uma mudança que deveria ser pequena mas se espalha" é o mapa para uma junta cortada no lugar errado. Estas três dimensões (legibilidade, testes, acoplamento) são consequências do mesmo ato: cortar o sistema nas juntas certas.
- **[AUTOMATE]** — Verificações de direção de dependência / fitness de arquitetura (as regras concretas de camadas vivem no `coding-standards`).

## CN — Consistência
*Princípio unificador: tornar o código previsível — aprender um padrão uma vez e confiar nele em todo lugar. Inconsistência é surpresa sistematizada.*

- **QM-CN-1 [NON-NEGOTIABLE]** — Sem erosão. Você não introduz uma segunda forma de fazer algo já estabelecido, um arquivo por vez. A migração de padrão é deliberada e abrange o repositório inteiro (idealmente automatizada), ou não acontece. Meio antigo/meio novo é o pior estado.
- **QM-CN-2 [NON-NEGOTIABLE]** — No código existente, o padrão local vence a sua opinião sobre o padrão "melhor". Escrever o seu fragmento do jeito "melhor" introduz uma segunda convenção e piora a base. Primeira pergunta ao entrar num código: "como *esta* base faz isso?"
- **QM-CN-3 [CALIBRATED]** — Quatro níveis: formatação → nomenclatura/convenções → padrões idiomáticos → arquitetural/conceitual. Quanto mais raso, mais mecanizável e menos importa; quanto mais profundo, mais importa e mais exige julgamento humano. Empurre o mecanizável para as ferramentas, para liberar atenção para os níveis profundos. *(As convenções concretas são de propriedade do `coding-standards`; este critério remete a ele.)*
- **QM-CN-4 [CALIBRATED]** — Consistência não é uniformidade cega: coisas que realmente diferem devem parecer diferentes (cuidado com a falsa simetria — igual na aparência, diferente no comportamento). Uma convenção é uniforme num momento, não permanente — não pode ossificar a base. *Tensão: a saída da "consistência tola" é a mudança deliberada e em bloco, nunca a erosão.*
- **[AUTOMATE]** — Formatadores, linters, verificadores de tipos, convenções impostas pelo CI. Debate de estilo na revisão é dívida de processo: a ferramenta decide de forma impessoal, e a atenção do revisor vai para lógica e design.

## EO — Tratamento de erros e observabilidade
*Princípio unificador: preservar a capacidade de entender o sistema quando ele falha — diagnosticabilidade. Você escreve o código de tratamento de erros com calma e o usa em pânico.*

- **QM-EO-1 [NON-NEGOTIABLE]** — Nunca engula um erro em silêncio: sem catch vazio, sem capturar-e-ignorar, sem retornar null no lugar de sinalizar a falha. Isso destrói informação na origem e a falha reaparece depois, em outro lugar, disfarçada. É a violação máxima da previsibilidade — o sistema mente sobre ter funcionado.
- **QM-EO-2 [NON-NEGOTIABLE]** — Nunca vaze dados sensíveis (senhas, tokens, PII, chaves) em logs ou mensagens de erro, e nunca exponha detalhes internos ou stack traces ao usuário final. Mensagens de erro têm duas audiências: o usuário recebe algo genérico e seguro; o operador recebe todo o detalhe nos logs internos. (Referenciado por SR.)
- **QM-EO-3 [NON-NEGOTIABLE]** — Preserve a cadeia de causas e o stack trace original ao propagar. Capturar uma exceção rica e relançar uma genérica sem contexto destrói a causa raiz.
- **QM-EO-4 [CALIBRATED]** — Falhe rápido diante de estado inválido/impossível; valide na fronteira do sistema para que o núcleo possa confiar nas suas entradas. *Tensão: encurte a distância entre causa e sintoma — essa distância é o que define o custo do diagnóstico.*
- **QM-EO-5 [CALIBRATED]** — Distinga erros esperados (situações de domínio — modele como valores de retorno / `Result` / `Option` que a assinatura obriga o chamador a tratar) de bugs (invariantes violados — falhe alto). Reserve exceções para o excepcional. *Tensão: tratar os dois igualmente ou mascara defeitos que deveriam gritar ou inunda os alertas com eventos rotineiros.*
- **QM-EO-6 [CALIBRATED]** — Concentre a recuperação numa camada com contexto suficiente para decidir (retry, valor padrão, degradar, notificar); não espalhe tratamento parcial e desinformado por todas as camadas.
- **QM-EO-7 [CALIBRATED]** — Observabilidade: os três pilares respondem a perguntas diferentes (logs = o que aconteceu aqui; métricas = saúde geral/tendência; traces = uma requisição através de serviços) e são complementares, não substituíveis. Instrumente para o *imprevisto*, não só para o previsto — os incidentes que doem são os que você não previu.
- **QM-EO-8 [CALIBRATED]** — Logs: níveis disciplinados e consistentes; contexto estruturado (chave-valor) para poder buscar e agregar; um ID de correlação costurando as linhas de uma requisição; respeite a relação sinal-ruído. *Tensão: verbosidade não é observabilidade — a linha que explicava o bug se afoga em dez mil linhas de "processing...". Instrumente os caminhos críticos com intenção; isso tem custo real.*
- **Pergunta orientadora.** *Quando isto quebrar às 3 da manhã, o plantão consegue descobrir por quê a partir do que o sistema registrou?*

## MT — Manutenibilidade e dívida técnica
*Princípio unificador: manter baixo o custo de mudança ao longo do tempo — o esforço por mudança não pode crescer com a idade do sistema. Esta dimensão é, em boa parte, o efeito das outras vistas no eixo do tempo.*

- **QM-MT-1 [NON-NEGOTIABLE]** — Sem dívida deliberada invisível. Um atalho tomado de propósito é nomeado quando tomado — comentário honesto, item de backlog ou ADR. A dívida que mata é a tácita, que vive como apreensão difusa e nunca entra numa conversa de priorização.
- **QM-MT-2 [CALIBRATED]** — Observe a curva de esforço por mudança: saudável é aproximadamente plana (a 100ª funcionalidade custa como a 10ª); doente é exponencial. Os dois regimes começam idênticos — cortar caminho é mais rápido no início, e é por isso que se faz. *Tensão: dívida é um instrumento legítimo quando deliberada e prudente (quadrante de Fowler); só é dano quando imprudente.*
- **QM-MT-3 [CALIBRATED]** — Pague a dívida continuamente por refactoring no próprio lugar: regra do escoteiro + "primeiro facilite a mudança, depois faça a mudança fácil". A limpeza faz parte do custo legítimo da funcionalidade, não é um projeto separado. *Tensão: evite campanhas de refactoring big-bang e reescritas totais (Spolsky) — prefira a substituição incremental strangler-fig; e "melhor" não pode significar impor estilo pessoal aos poucos (veja QM-CN-1).*
- **QM-MT-4 [CALIBRATED]** — Manutenibilidade é uma escolha de contexto: o cuidado deve corresponder à vida útil esperada e à importância. Um protótipo descartado em duas semanas e um núcleo de dez anos não são cobrados pela mesma régua. *Tensão: over-engineering / flexibilidade especulativa (YAGNI) é dívida por si só — eleva hoje o custo de mudança por um futuro que nunca veio.* **Esta é a regra de calibração tornada concreta; todo outro critério a herda.**
- **QM-MT-5 [CALIBRATED]** — Fatores não relacionados a código contam: um dev novo consegue rodar o projeto em minutos; as dependências estão vivas e atualizadas; os tempos de build/CI são curtos. Manutenibilidade é uma propriedade do sistema de desenvolvimento inteiro, não só do texto-fonte.
- **[AUTOMATE]** — Frescor/saúde das dependências (compartilhado com SR), monitoramento de tempo de build e CI.

## DO — Documentação proporcional
*Princípio unificador: preservar o conhecimento que o código não consegue carregar — especificamente o conhecimento que não cabe em código.*

- **QM-DO-1 [NON-NEGOTIABLE]** — A documentação não pode mentir. Documentação desatualizada é pior que nenhuma (uma armadilha ativa versus uma lacuna honesta). A documentação vive o mais perto possível do que descreve — no repositório, versionada junto, revisada no mesmo PR — porque a distância física é o que permite o descompasso. Prefira documentação que *não pode* mentir: testes, tipos, exemplos que rodam no CI. Uma mudança de comportamento que deixa uma documentação co-localizada contradizendo-a é um defeito.
- **QM-DO-2 [CALIBRATED]** — Documente o *porquê*, não o *quê*: o código é a fonte de verdade do *como* e, se legível, do *quê*; o *porquê* (alternativas descartadas, restrições externas, armadilhas evitadas) é território soberano da documentação. Código autoexplicativo primeiro; um comentário que explica um bloco confuso geralmente significa que o bloco deve ser reescrito. *Tensão: a exceção legítima é a complexidade essencial (uma fórmula densa, um workaround de terceiros).*
- **QM-DO-3 [CALIBRATED]** — Triagem: documente apenas o que o código não consegue carregar **e** o que muda devagar o bastante para valer a sincronização. *Tensão: a documentação em excesso afoga o importante (sinal-ruído) e multiplica a superfície que pode apodrecer; documentação de baixo valor e alta volatilidade é dívida pura.*
- **QM-DO-4 [CALIBRATED]** — Escreva para uma audiência definida (usuário da API / mantenedor / recém-chegado / operador); não misture os modos do Diátaxis (tutorial, how-to, referência, explicação). O onboarding de recém-chegados (README, "getting started" funcional) é o mais negligenciado e o de maior retorno. *(Registros de decisão são ADRs, de propriedade da fronteira de decisão do `its-contract` — este critério os referencia, não os redefine.)*
- **[AUTOMATE]** — Testes de exemplos executáveis no CI; verificadores de links.

## SR — Segurança e robustez
*Princípio unificador: assumir que tudo que vem de fora é hostil até prova em contrário — desconfiança disciplinada da fronteira. Assimetria da segurança: o defensor precisa acertar em todo lugar; o atacante precisa de uma única falha.*

- **QM-SR-1 [NON-NEGOTIABLE]** — Nunca confie em entrada externa (usuário, rede, arquivo, outro serviço, até outra parte do seu próprio sistema). Valide na fronteira e mantenha a separação dados/código: queries parametrizadas contra SQL injection, codificação de saída sensível ao contexto contra XSS, nunca interpole entrada em um comando. A maioria das vulnerabilidades clássicas é o mesmo pecado: o dado cruzou a fronteira dado→código sem ser neutralizado.
- **QM-SR-2 [NON-NEGOTIABLE]** — Sem segredos (senhas, chaves de API, tokens, credenciais) no código-fonte ou no controle de versão. O histórico do Git é permanente; "repositório privado" não é proteção. Segredos vivem em cofres dedicados ou em variáveis de ambiente injetadas, e precisam ser rotacionáveis.
- **QM-SR-3 [NON-NEGOTIABLE]** — Não invente criptografia: use bibliotecas estabelecidas e mantidas, do modo padrão. Senhas são armazenadas com um hash apropriado para senhas (lento, com salt), nunca em texto claro e nunca "criptografadas" (reversíveis); tráfego sensível trafega por canais criptografados.
- **QM-SR-4 [NON-NEGOTIABLE]** — Não entregue dependências com vulnerabilidades conhecidas. Seu sistema é todo o código que você importou, transitivamente; uma dependência desatualizada é uma porta destrancada cuja localização é pública. Mantenha atualizado e varra automaticamente.
- **QM-SR-5 [CALIBRATED]** — Privilégio mínimo: cada parte (serviço, processo, credencial, usuário) recebe apenas o acesso que sua função exige, para conter o raio de impacto quando — não se — algo for comprometido. *Tensão: o mais restrito que for prático, sem sabotar o trabalho.*
- **QM-SR-6 [CALIBRATED]** — Defesa em profundidade: múltiplas camadas independentes, para que uma brecha não seja total. Prefira várias cercas a um muro alto.
- **QM-SR-7 [CALIBRATED]** — Robustez (a prima não adversarial): idempotência para operações que serão repetidas (timeouts, retries), degradação graciosa (serviço reduzido em vez de colapso total), timeouts e limites em toda espera externa e crescimento ilimitado. *Tensão: assuma que tudo que pode dar errado no ambiente eventualmente dará, sem transformar todo soluço local numa falha global.*
- **A pergunta madura.** Não "isto é seguro?" (nada é, absolutamente), mas "isto é seguro o bastante contra as ameaças realistas para *este* sistema, sem atrito que sabote o uso?" A segurança que os usuários contornam (a senha impossível no post-it) é pior que uma segurança moderada que eles seguem. Isto é modelagem de ameaças, o oposto do teatro de segurança. A segurança deve ser sistemática (forçada pela arquitetura), não heroica (dependente de cada dev lembrar).

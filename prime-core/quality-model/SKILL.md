---
name: quality-model
description: O modelo de qualidade canônico. É uma definição e uma referência compartilhadas - o código novo é construído contra ele, o its-generator deve se apoiar nele para definição de qualidade do que especifica, e o its-implementation deve segui-lo na prática. O enforcement (achados precisos, aprovar/reprovar um PR) pertence ao code-review. Declara a fronteira com o coding-standards (as convenções concretas vivem lá) e com o its-contract (os ADRs vivem lá).
---

# Modelo de Qualidade (prime-core)

Esta skill é dona da definição de qualidade do time, e é a mesma definição nas três pontas do fluxo. O `its-generator` se apoia nela para decidir a qualidade do que especifica; o `its-implementation` a segue na prática; o `code-review` julga a mudança contra ela. Especificação, implementação e revisão medem com a mesma régua, na mesma versão, e uma mudança aqui atualiza as três de uma vez.

O modelo tem três partes:

1. **O catálogo de critérios** (`references/quality-criteria.md`) — os critérios por lente, com ID estável (`QM-XX-N`), e os perfis de criticidade.
2. **Os gatilhos de especificação** (`references/quality-triggers.md`) — o que, numa story, transforma critérios em decisões que a ITS precisa tomar.
3. **As regras deste arquivo** — escopo, níveis, calibração, precedência, exceções e como cada papel usa o modelo.

Outras skills citam os critérios por ID em vez de redefini-los. Um artefato faz o oposto: a ITS escreve a exigência concreta que o critério impõe, nunca o ID (veja Para o its-generator).

## O que é qualidade aqui

Software de qualidade **faz o que foi acordado, resiste a quem o ataca e ao que dá errado no ambiente, gasta o que o trabalho exige e continua barato de mudar ao longo do tempo**. O catálogo olha essa propriedade por dez lentes, agrupadas nas quatro características que podem ser julgadas no próprio código — manutenibilidade, confiabilidade, eficiência e segurança, as mesmas que a ISO/IEC 5055 mede na estrutura do software.

As lentes costumam subir juntas: o código cortado nas juntas certas é ao mesmo tempo mais legível, mais testável e mais fácil de proteger. Mas nem sempre — desempenho e legibilidade, segurança e conveniência, consistência com o legado e o desenho melhor puxam para lados opostos. Por isso o modelo não é uma lista a maximizar. Ele tem níveis, uma calibração declarada e uma regra de precedência, e duas consequências moldam todo o resto:

- O núcleo da qualidade é **irredutivelmente julgamento** — onde traçar fronteiras, o que abstrair, que dívida assumir, quanto cuidado um trecho merece. O modelo **estrutura** esse julgamento; não o substitui.
- **O excesso é tão danoso quanto a deficiência.** A virtude nunca é maximizar uma lente; é calibrá-la à criticidade do código.

## O que o modelo cobre

A ISO/IEC 25010:2023 descreve a qualidade de um produto em nove características. No Apex, cada uma tem um dono, e só parte delas pertence a este modelo:

| Característica (ISO/IEC 25010:2023) | Onde é definida no Apex |
|---|---|
| Adequação funcional | Casos de uso (regras de negócio e critérios de aceite) e o delta da ITS. Este modelo exige que o comportamento seja verificado (lente TS). |
| Eficiência de desempenho | A meta: critério de aceite não funcional do caso de uso, ou ADR quando vale para o sistema. O código que a cumpre e a mede: lente EF. |
| Compatibilidade | Contratos publicados: `QM-CC-7` e os slots de contrato do `coding-standards`. |
| Capacidade de interação (usabilidade, acessibilidade) | Critérios de aceite do caso de uso. Fora deste modelo. |
| Confiabilidade | A meta de disponibilidade: critério de aceite não funcional ou ADR. O código: lentes EO e RB. |
| Segurança (security) | O piso: lente SR. A lista de controles: o padrão externo que o projeto adota, no `coding-standards`. |
| Manutenibilidade | Lentes RC, CC, CN, TS, MT e DO. |
| Flexibilidade | Decisões que sobrevivem à story: ADR. O código: `QM-CC-3` e `QM-CC-5`. |
| Segurança operacional (safety) | Fora do escopo padrão. Um projeto que precisa a declara na configuração. |

O que este modelo nunca faz é fixar metas de produto — tempo de resposta, disponibilidade, volume. Essas vêm do caso de uso ou de um ADR. O modelo diz como o código as cumpre e como prova que as cumpre.

## Como os critérios são classificados

Cada critério tem um de três níveis. O nível diz a **natureza** do critério, não uma consequência automática — traduzir nível em severidade de um achado é trabalho do `code-review`.

- **[NON-NEGOTIABLE]** — o piso. Vale para todo código escrito ou alterado, em qualquer nível de criticidade. "Inegociável" significa *não negociável em silêncio*: é cumprido, ou afastado como exceção registrada (veja Exceções). Cada um traz um teste de **Violação**, escrito para que quem implementa e quem revisa reconheçam o mesmo pecado no mesmo código.
- **[CALIBRATED]** — julgamento estruturado, sempre pareado com sua **Tensão**. A intensidade vem do nível de criticidade da área. Nunca é uma regra a aplicar mecanicamente.
- **[AUTOMATE]** — o que pertence a ferramentas, no pipeline, antes da revisão humana (`QM-MT-7`). Atenção humana gasta nele é desperdício; o que vale levantar é a ausência da ferramenta.

## Calibração: o nível de criticidade

"Proporcional à vida útil e à importância do código" só funciona se alguém declara a vida útil e a importância. Sem isso, quem especifica, quem implementa e quem revisa calibram cada um por conta própria — três réguas para a mesma mudança. O modelo resolve isso com três níveis, declarados uma vez:

- **`efêmera`** — código com prazo de vida declarado: experimento, prova de conceito, carga executada uma vez, funcionalidade atrás de flag a remover. Exige uma condição de remoção (data ou evento); sem ela, a área é `padrão`.
- **`padrão`** — o nível de toda área não declarada: a régua plena dos critérios calibrados.
- **`crítica`** — áreas em que uma falha custa dinheiro, dado, segurança ou conformidade, ou em que o código tem vida longa e muitos dependentes.

Regras do nível:

- **O piso não varia.** O nível muda a intensidade dos critérios calibrados e a evidência esperada; nunca dispensa um inegociável. O que cada nível exige, critério a critério, está nos Perfis de criticidade do catálogo.
- **O projeto declara o nível por área** na configuração (`docs/prime-config.md`). A classificação é declarada, nunca inferida do nome de um diretório ou da idade do código.
- **A ITS escreve o nível de cada área que toca**, por extenso, nas premissas do plano — e, para uma área `efêmera`, a condição de remoção. Quem implementa e quem revisa leem o nível da ITS; não o rejulgam.
- Uma story que toca áreas de níveis diferentes segue, em cada unidade, o nível da área que aquela unidade altera.
- Dúvida sobre o nível é pergunta ao arquiteto, nunca suposição.

O nível de criticidade não substitui o modelo de ameaças: o padrão de segurança externo e o nível de verificação que o projeto adota vivem no `coding-standards`.

## Precedência

Quando duas exigências puxam para lados opostos, vale a ordem:

1. **O piso** — os inegociáveis deste modelo, os inegociáveis que o projeto acrescentou e os slots INVARIANT do `coding-standards`.
2. **O acordado** — o que a ITS especifica: os resultados do delta, as metas não funcionais e as decisões de qualidade tomadas pelos gatilhos.
3. **Os critérios calibrados**, na intensidade do nível da área.

Uma instrução da ITS que viola o piso sem registro de exceção não está acordada — está errada, e volta ao arquiteto como pergunta. Entre critérios calibrados em conflito, decidem o nível da área e a meta declarada; um trade-off que vale além da story é um ADR. O padrão local (`QM-CN-2`) nunca vence o piso. E a lente de segurança carrega a régua de exceção mais alta do modelo: a assimetria faz com que uma única lacuna silenciosa possa ser fatal, por melhor que seja todo o resto.

## Exceções: legado e dívida deliberada

Um modelo que não admitisse exceções seria inútil num código real, que sempre contém legado escrito para uma régua mais baixa e dívida que o projeto escolheu assumir. O modelo não enfraquece os critérios para isso; governa **como um desvio é feito**. A distinção que atravessa tudo é *silencioso versus deliberado*: a dívida deliberada é uma jogada legítima; o pecado é o desvio que ninguém consegue ver nem discutir (`QM-MT-1`).

**O registro de exceção.** Um afastamento de um inegociável, ou de um calibrado que o nível da área exige, é aceitável quando registrado com cinco elementos:

- **critério** — de qual critério se afasta;
- **onde** — o código ou a área afetada;
- **por quê** — a razão decisiva;
- **responsável** — quem responde pela exceção;
- **condição de saída** — quando ou em que evento ela é paga ou revista.

Uma exceção sem condição de saída é permanente, e uma exceção permanente é uma decisão: vai para um ADR.

**Quem concede.**

- **O arquiteto, na ITS**, para o que o plano decide. A ITS registra o afastamento por extenso num dos seus veículos — a alternativa descartada da unidade, a fronteira de fora de escopo ou um ADR —, conforme o `prime-core/its-contract`; o critério aparece só nas Referências. Quem assina a ITS é o responsável.
- **O responsável de segurança que o projeto declara**, junto com o arquiteto, para uma exceção de segurança. Ela é uma decisão de modelo de ameaças, não uma linha rotineira de dívida.
- **Um ADR**, para relaxar um critério no projeto inteiro.
- **Nunca quem implementa.** Quando o piso não pode ser cumprido como o plano previu, isso volta ao arquiteto como pergunta.

**O legado não é condenado retroativamente.** O modelo se aplica ao código que a mudança **escreve e altera**, não a toda linha que a antecede. Alterar uma área de baixa qualidade obriga a cumprir a régua no que se escreve e a não piorar a área (`QM-MT-6`) — não a levá-la inteira ao padrão. Onde um inegociável já é violado no código que a mudança toca, a violação é nomeada como dívida herdada (`QM-MT-1`), nunca adotada nem corrigida fora do escopo: pelo arquiteto, na fronteira de fora de escopo da ITS, quando a conhece; por quem implementa, na descrição do PR, quando a encontra. No código existente, o padrão local vence a preferência (`QM-CN-2`) — exceto contra o piso.

## Para o its-generator: a qualidade do que se especifica

A ITS é onde a qualidade de uma story é decidida. O que ela não decide fica para quem implementa resolver sob pressão, ou para ninguém. O its-generator se apoia no modelo em cinco movimentos:

1. **Declare o nível.** Leia na configuração o nível de criticidade de cada área que o plano toca e escreva-o nas premissas do plano, com a condição de remoção de uma área `efêmera`. Área sem nível declarado é `padrão`.
2. **Passe a story pelos gatilhos.** Para cada gatilho de `references/quality-triggers.md` que a story dispara, tome a decisão de qualidade e escreva-a como instrução na unidade que a implementa, com o valor concreto e o teste ou a medição que a prova. Um gatilho disparado sem decisão é uma pergunta que o implementador vai devolver.
3. **Planeje o que prepara a mudança.** A refatoração preparatória (`QM-MT-3`) e os testes de caracterização (`QM-TS-9`) são unidades próprias, antes das unidades de comportamento.
4. **Confira o piso no plano.** Nenhuma unidade instrui algo que viole um inegociável. Onde o plano precisa se afastar de um critério, registre a exceção nos veículos da ITS, por extenso.
5. **Calibre ao nível.** Nem abaixo do que o nível exige, nem acima — estrutura especulativa é dívida (`QM-MT-4`).

Na ITS, o modelo chega como **decisão concreta**, nunca como ID: "timeout de 2 s", não "conforme o critério de robustez". Os IDs servem à análise apresentada ao arquiteto e às Referências da ITS, onde aparecem apenas os critérios de que o plano se afasta. O que vale para todo código, em qualquer story — o piso inteiro —, não se repete em cada ITS: é a base de quem implementa. A ITS escreve o que esta story decide.

## Para o its-implementation: o modelo na prática

A ITS diz o que construir e as decisões de qualidade desta story; o modelo diz como todo código é construído. Os dois valem juntos, e o piso vale mesmo onde a ITS silencia.

1. **Construa no nível que a ITS declara** para a área de cada unidade.
2. **Cumpra o piso** em todo código escrito ou alterado. Antes de dar uma unidade por pronta, percorra contra o próprio diff o piso do catálogo, critério a critério, usando os testes de Violação, e os slots INVARIANT do `coding-standards`.
3. **Não decida o que a ITS deveria ter decidido.** Quando o código que você escreve dispara um gatilho que a ITS não decidiu — uma chamada externa sem timeout definido, uma escrita dupla sem mecanismo de consistência, uma operação nova sem regra de autorização — e nem o `coding-standards` nem a configuração dão o valor, devolva a pergunta ao arquiteto. Não invente o valor.
4. **O teste é o oráculo.** Comportamento alterado chega com teste (`QM-TS-7`), e um teste existente só muda quando o plano mudou o comportamento que ele verifica (`QM-TS-8`). Um teste vermelho é informação: ou o código está errado, ou o plano mudou aquele comportamento.
5. **Arrume só o que o plano permite.** A arrumação mecânica confinada às linhas que a unidade já altera é parte do trabalho, em commit separado (`QM-MT-3`); qualquer outra arrumação é pergunta.
6. **Nunca conceda uma exceção.** O piso que não pode ser cumprido como planejado volta ao arquiteto. A violação herdada que você encontra no código que toca é nomeada na descrição do PR — nunca adotada, nunca corrigida fora do escopo.

**Código gerado.** A régua é a mesma para código escrito por uma pessoa, por um agente ou com assistência de um. Os pontos em que o código gerado mais falha merecem a autoverificação mais atenta:

- lógica duplicada em vez de reutilizada (`QM-CC-6`);
- dependência inventada ou com nome não conferido (`QM-SR-4`);
- saída sem codificação para o contexto, inclusive em log (`QM-SR-1`);
- teste ajustado para passar (`QM-TS-8`);
- estrutura especulativa (`QM-CC-5`, `QM-MT-4`);
- comentário que narra o código (`QM-RC-5`);
- captura genérica que engole o erro (`QM-EO-1`).

## Para o code-review

O revisor julga a mudança com o mesmo catálogo, no nível que a ITS declarou, contra os mesmos gatilhos. Transformar critérios em achados e numa recomendação de aprovar ou reprovar é trabalho exclusivo dele — este modelo não aprova nem reprova nada. Duas leituras decorrem da divisão entre plano e prática:

- Um gatilho que a ITS deixou sem decisão é defeito do plano, não de quem implementou.
- Um inegociável afastado com registro de exceção completo é uma exceção registrada, não um desvio silencioso.

## Outros consumidores

- **feasibility-analysis** e **impact-mapping** ancoram, respectivamente, o julgamento e as divergências em critérios citados por ID.
- **use-case** é dono das metas: um critério de aceite não funcional é a meta; este modelo diz como o código a cumpre e a mede (gatilho de meta não funcional). A qualidade interna do código nunca entra num caso de uso.
- As skills do dev ainda por escrever herdam as regras de prática acima: o **testing** aplica a lente TS no nível da área; o **pr-preparation** executa a autoverificação do piso e declara a dívida herdada; o **troubleshooting** registra como lacuna das lentes EO a falha que o sistema não deu meios de diagnosticar.

## Fronteiras — o que o modelo não é

- **Não substitui o julgamento.** O piso é um mínimo, não uma definição de bom.
- **Não é um gate.** Define a régua; o `code-review` decide se uma mudança a superou.
- **Não são os padrões de código.** Este modelo é dono de princípios, do piso e dos gatilhos; o `prime-core/coding-standards` é dono das convenções concretas — qual nomenclatura, qual divisão em camadas, qual timeout padrão. Quando um critério precisa de uma convenção concreta para ser verificável, ele remete a um slot; nunca inventa um valor. Os slots INVARIANT valem em qualquer área: os que são proibições são a forma concreta, na stack do projeto, do que o piso exige; os demais são formas únicas do sistema. Ambos só admitem desvio por exceção registrada.
- **Não é o formato da ITS.** Como um critério entra na ITS — como instrução concreta no corpo, com o ID apenas nas Referências — é regra do `prime-core/its-contract`.
- **Não é o lar das decisões arquiteturais.** Decisões que sobrevivem à story vivem em ADRs, de propriedade da fronteira de decisão do `prime-core/its-contract`.
- **Não fixa metas de produto.** As metas vêm dos casos de uso e dos ADRs.

## Overrides do projeto

O `docs/prime-config.md` pode **elevar** a régua e **declarar o contexto**:

- declarar o nível de criticidade de cada área;
- acrescentar inegociáveis específicos do projeto;
- endurecer a intensidade de um critério calibrado num nível;
- registrar uma postura permanente diante de legado ou dívida — por exemplo, "o módulo X é legado sob migração strangler-fig; siga seus padrões locais, não os estenda".

O projeto não pode **dispensar em silêncio** um inegociável do core: relaxar um é uma decisão deliberada e com responsável — um ADR —, não uma edição de configuração. Isso espelha a regra de precedência do `prime-core/prime-config`: a configuração sobrescreve padrões declarados, nunca regras do core.

## Sinais e evolução

O modelo melhora com evidência, não com opinião. Os sinais abaixo informam a evolução; **nenhum é gate e nenhum avalia pessoas** — um número transformado em meta deixa de medir o que media.

- **Por mudança** — usados por quem implementa e por quem revisa: cobertura das linhas alteradas; teste de mutação sobre o código alterado nas áreas críticas; contagem de consultas nos testes de integração; achados de revisão por ID.
- **Do sistema** — usados pelo dono do modelo: achados de revisão agregados por critério; incidentes atribuídos a uma lente; frequência de deploy, tempo de entrega, taxa de falha de mudança e tempo de recuperação; taxa de testes instáveis; pontos quentes — código alterado com frequência e de baixa saúde.

Três regras de evolução, aplicadas pelo dono do modelo:

- **Um critério que gera achados bloqueantes recorrentes é cobrado tarde demais.** Ele sobe no fluxo: vira gatilho, para que a ITS o decida, ou vira ferramenta, para que o pipeline o verifique.
- **Um incidente cuja causa nenhum critério nomeia** é candidato a critério novo.
- **Um critério que não gera achado nem evita incidente** é candidato a aposentadoria ou a automação.

## Versionamento

Critérios versionados, não preferências do momento: é o que permite que uma decisão, uma exceção ou um achado cite algo estável e datado.

- O catálogo e os gatilhos são versionados pela **release do Apex Prime** — a tag que o instalador usa e que o manifesto da instalação registra. Nenhum arquivo carrega número de versão próprio. Acrescentar um critério ou um gatilho muda a versão menor da release; aposentar ou reclassificar um critério muda a maior.
- Os **IDs dos critérios são estáveis e nunca renumerados**, como os de casos de uso e ADRs. Um critério aposentado mantém seu ID aposentado, listado no fim do catálogo com o critério que o substituiu.
- As mudanças passam pelo PR de governança, **revisado pelo dono do modelo de qualidade**. Esse PR é o registro da evolução, no controle de versão; o modelo não mantém histórico paralelo.

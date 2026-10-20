# Regras para quem consome o modelo de qualidade

Parte do contrato do `prime-core/quality-model`, e a que as skills do fluxo leem: como os critérios são classificados e calibrados, a precedência, as exceções, o que o projeto pode sobrescrever, os pontos em que o código gerado mais falha e como o its-generator e o code-review usam o modelo. O SKILL.md — o que é qualidade aqui, o que o modelo cobre, as fronteiras, a prática de quem implementa e a evolução do modelo — é lido por quem implementa, junto com este arquivo, e pelo dono do modelo.

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

## Overrides do projeto

O `docs/prime-config.md` pode **elevar** a régua e **declarar o contexto**:

- declarar o nível de criticidade de cada área;
- acrescentar inegociáveis específicos do projeto;
- endurecer a intensidade de um critério calibrado num nível;
- registrar uma postura permanente diante de legado ou dívida — por exemplo, "o módulo X é legado sob migração strangler-fig; siga seus padrões locais, não os estenda".

O projeto não pode **dispensar em silêncio** um inegociável do core: relaxar um é uma decisão deliberada e com responsável — um ADR —, não uma edição de configuração. Isso espelha a regra de precedência do `prime-core/prime-config`: a configuração sobrescreve padrões declarados, nunca regras do core.

## Código gerado

A régua é a mesma para código escrito por uma pessoa, por um agente ou com assistência de um. Os pontos em que o código gerado mais falha merecem a autoverificação mais atenta:

- lógica duplicada em vez de reutilizada (`QM-CC-6`);
- dependência inventada ou com nome não conferido (`QM-SR-4`);
- saída sem codificação para o contexto, inclusive em log (`QM-SR-1`);
- teste ajustado para passar (`QM-TS-8`);
- estrutura especulativa (`QM-CC-5`, `QM-MT-4`);
- comentário que narra o código (`QM-RC-5`);
- captura genérica que engole o erro (`QM-EO-1`).

## Para o its-generator: a qualidade do que se especifica

A ITS é onde a qualidade de uma story é decidida. O que ela não decide fica para quem implementa resolver sob pressão, ou para ninguém. O its-generator se apoia no modelo em cinco movimentos:

1. **Declare o nível.** Leia na configuração o nível de criticidade de cada área que o plano toca e escreva-o nas premissas do plano, com a condição de remoção de uma área `efêmera`. Área sem nível declarado é `padrão`.
2. **Passe a story pelos gatilhos.** Para cada gatilho de `references/quality-triggers.md` que a story dispara, tome a decisão de qualidade e escreva-a como instrução na unidade que a implementa, com o valor concreto e o teste ou a medição que a prova. Um gatilho disparado sem decisão é uma pergunta que o implementador vai devolver.
3. **Planeje o que prepara a mudança.** A refatoração preparatória (`QM-MT-3`) e os testes de caracterização (`QM-TS-9`) são unidades próprias, antes das unidades de comportamento.
4. **Confira o piso no plano.** Nenhuma unidade instrui algo que viole um inegociável. Onde o plano precisa se afastar de um critério, registre a exceção nos veículos da ITS, por extenso.
5. **Calibre ao nível.** Nem abaixo do que o nível exige, nem acima — estrutura especulativa é dívida (`QM-MT-4`).

Na ITS, o modelo chega como **decisão concreta**, nunca como ID: "timeout de 2 s", não "conforme o critério de robustez". Os IDs servem à análise apresentada ao arquiteto e às Referências da ITS, onde aparecem apenas os critérios de que o plano se afasta. O que vale para todo código, em qualquer story — o piso inteiro —, não se repete em cada ITS: é a base de quem implementa. A ITS escreve o que esta story decide.

## Para o code-review

O revisor julga a mudança com o mesmo catálogo, no nível que a ITS declarou, contra os mesmos gatilhos. Transformar critérios em achados e numa recomendação de aprovar ou reprovar é trabalho exclusivo dele — este modelo não aprova nem reprova nada. Duas leituras decorrem da divisão entre plano e prática:

- Um gatilho que a ITS deixou sem decisão é defeito do plano, não de quem implementou.
- Um inegociável afastado com registro de exceção completo é uma exceção registrada, não um desvio silencioso.

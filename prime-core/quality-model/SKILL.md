---
name: quality-model
description: O modelo de qualidade canônico do time - o que é qualidade, o piso inegociável, a calibração por criticidade e os gatilhos de especificação, com critérios QM-XX-N. Referência compartilhada para especificar, implementar e revisar; o enforcement pertence ao code-review, e as convenções concretas, ao coding-standards.
---

# Modelo de Qualidade (prime-core)

Esta skill é dona da definição de qualidade do time, e é a mesma definição nas três pontas do fluxo. O `its-generator` se apoia nela para decidir a qualidade do que especifica; quem implementa — pessoa ou agente — a segue na prática; o `code-review` julga a mudança contra ela. Especificação, implementação e revisão medem com a mesma régua, na mesma versão, e uma mudança aqui atualiza as três de uma vez.

O modelo tem três partes:

1. **O catálogo de critérios** — o índice `references/quality-criteria.md` (os níveis, o piso num relance, os perfis de criticidade e os IDs aposentados) e um arquivo por lente em `references/quality-criteria/`, com os critérios e seus IDs estáveis (`QM-XX-N`). O índice é lido sempre; o arquivo de uma lente, quando um critério dela é citado ou aplicado.
2. **Os gatilhos de especificação** (`references/quality-triggers.md`) — o que, numa story, transforma critérios em decisões que a ITS precisa tomar.
3. **As regras** — o escopo, as fronteiras, a prática de quem implementa e a evolução, neste arquivo; os níveis, a calibração, a precedência, as exceções, os overrides e o uso pelo its-generator e pelo code-review em `references/consumer-rules.md`, a parte que as skills do fluxo leem sem este arquivo. Quem implementa lê os dois.

Outras skills citam os critérios por ID em vez de redefini-los. Um artefato faz o oposto: a ITS escreve a exigência concreta que o critério impõe, nunca o ID (veja Para o its-generator, em `references/consumer-rules.md`).

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

## Para quem implementa: o modelo na prática

A ITS diz o que construir e as decisões de qualidade desta story; o modelo diz como todo código é construído. Os dois valem juntos, e o piso vale mesmo onde a ITS silencia.

1. **Construa no nível que a ITS declara** para a área de cada unidade.
2. **Cumpra o piso** em todo código escrito ou alterado. Antes de dar uma unidade por pronta, percorra contra o próprio diff o piso do catálogo, critério a critério, usando os testes de Violação, e os slots INVARIANT do `coding-standards`.
3. **Não decida o que a ITS deveria ter decidido.** Quando o código que você escreve dispara um gatilho que a ITS não decidiu — uma chamada externa sem timeout definido, uma escrita dupla sem mecanismo de consistência, uma operação nova sem regra de autorização — e nem o `coding-standards` nem a configuração dão o valor, devolva a pergunta ao arquiteto. Não invente o valor.
4. **O teste é o oráculo.** Comportamento alterado chega com teste (`QM-TS-7`), e um teste existente só muda quando o plano mudou o comportamento que ele verifica (`QM-TS-8`). Um teste vermelho é informação: ou o código está errado, ou o plano mudou aquele comportamento.
5. **Arrume só o que o plano permite.** A arrumação mecânica confinada às linhas que a unidade já altera é parte do trabalho, em commit separado (`QM-MT-3`); qualquer outra arrumação é pergunta.
6. **Nunca conceda uma exceção.** O piso que não pode ser cumprido como planejado volta ao arquiteto. A violação herdada que você encontra no código que toca é nomeada na descrição do PR — nunca adotada, nunca corrigida fora do escopo.

**Código gerado.** A autoverificação dá atenção redobrada aos pontos em que o código gerado mais falha, listados em Código gerado (`references/consumer-rules.md`).

## Outros consumidores

- **feasibility-analysis** e **impact-mapping** ancoram, respectivamente, o julgamento e as divergências em critérios citados por ID.
- **use-case** é dono das metas: um critério de aceite não funcional é a meta; este modelo diz como o código a cumpre e a mede (gatilho de meta não funcional). A qualidade interna do código nunca entra num caso de uso.
- **troubleshooting**, ainda por escrever, registra como lacuna das lentes EO a falha que o sistema não deu meios de diagnosticar.

## Fronteiras — o que o modelo não é

- **Não substitui o julgamento.** O piso é um mínimo, não uma definição de bom.
- **Não é um gate.** Define a régua; o `code-review` decide se uma mudança a superou.
- **Não são os padrões de código.** Este modelo é dono de princípios, do piso e dos gatilhos; o `prime-core/coding-standards` é dono das convenções concretas — qual nomenclatura, qual divisão em camadas, qual timeout padrão. Quando um critério precisa de uma convenção concreta para ser verificável, ele remete a um slot; nunca inventa um valor. Os slots INVARIANT valem em qualquer área: os que são proibições são a forma concreta, na stack do projeto, do que o piso exige; os demais são formas únicas do sistema. Ambos só admitem desvio por exceção registrada.
- **Não é o formato da ITS.** Como um critério entra na ITS — como instrução concreta no corpo, com o ID apenas nas Referências — é regra do `prime-core/its-contract`.
- **Não é o lar das decisões arquiteturais.** Decisões que sobrevivem à story vivem em ADRs, de propriedade da fronteira de decisão do `prime-core/its-contract`.
- **Não fixa metas de produto.** As metas vêm dos casos de uso e dos ADRs.

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

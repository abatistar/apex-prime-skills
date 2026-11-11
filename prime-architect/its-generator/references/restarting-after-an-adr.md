# Recomeçando a ITS depois de um ADR

Parte do `its-generator`, lida só quando a geração de uma ITS parou numa decisão de arquitetura (Passo 4.5) e o arquiteto já decidiu sobre o ADR. A redação e a aprovação do ADR não são deste arquivo nem desta skill: são do adr-generator.

A geração recomeça do Passo 0, com o pedido original: a story, os casos de uso, o nível de detalhe e o formato de saída são os mesmos. Ela recomeça do início, e não do ponto em que parou, porque a decisão pode alcançar qualquer parte do plano, e conferir tudo agora custa menos que descobrir no code review uma instrução do desenho antigo.

## O que o Passo 1 encontra

O exame do repositório de ADRs acha o registro pela Origem, `ITS-<story-id>`:

- **`Accepted`** → é entrada. Restringe o plano como qualquer ADR `Accepted` que incide sobre a área.
- **`Rejected`** → não incide sobre plano nenhum (adr-contract, Ciclo de vida do status). A decisão fica em escopo de story e vira a linha de alternativa descartada da unidade que ela afeta. Se a razão da recusa veta o caminho que o plano seguia, o plano toma outro. A mesma decisão não é proposta de novo.
- **`Proposed`** → a geração continua parada; nada recomeça.

## O que se aproveita

Recomeçar não é refazer tudo. O que foi produzido antes da parada pode ser aproveitado, com uma condição: cada parte é conferida contra a decisão antes de voltar ao plano. Numa sessão nova, sem as notas da geração anterior, nada há para aproveitar, e a geração é uma geração comum com o ADR como entrada.

- **O delta não depende da decisão.** Os itens `D` vêm dos casos de uso, que o ADR não muda. O resultado do Passo 2 é reaproveitado como está.
- **Da inspeção em diante, pergunte de cada nota se a decisão a alcança:** o componente mapeado, a classificação existe / modificar / criar, o ponto de regressão, a fronteira de fora de escopo, o caso de borda, o gatilho de qualidade. O alcance da decisão é o campo Escopo do ADR mais tudo o que a linha Vincula obriga a mudar. A nota alcançada é refeita no passo em que nasceu; a que não é alcançada segue.
- **A decisão muda a solução inteira** — outros componentes, outro ponto de integração, outra estratégia → refaça do Passo 3 em diante, sem aproveitar notas. Conferir nota por nota custa mais que inspecionar de novo, e uma nota do desenho antigo que escapa vira instrução errada.
- **Um trecho da ITS já escrito**, quando a parada aconteceu durante o Passo 5, é rascunho, nunca documento. Toda seção que a decisão alcança é reescrita, e o documento inteiro passa pelo Passo 6 como qualquer ITS nova. Nada escrito antes da decisão é entregue sem essa conferência.

## O que a nova ITS precisa mostrar

A ITS que sai da nova geração é coerente com o ADR aprovado e o cita, conforme o its-contract (Fronteira de decisão):

- as premissas do plano citam o ADR em Decisões registradas, com as unidades que ele restringe;
- cada uma dessas unidades escreve a linha Vincula do ADR como instrução, sem o contexto nem a justificativa;
- nenhuma instrução, alternativa descartada ou fronteira de fora de escopo contradiz a Decisão.

Outra decisão que mereça ADR aparece na nova geração → o mesmo ciclo: o Passo 4.5 para e propõe, e o adr-generator redige. Um ADR decidido num ciclo anterior não é reaberto por isso.

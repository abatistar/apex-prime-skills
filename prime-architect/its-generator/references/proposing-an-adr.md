# Propondo um ADR

Parte do `its-generator`, lida só quando o Passo 4.5 encontra uma decisão candidata a ADR — neste passo, numa decisão de qualidade do Passo 4.6 ou já na escrita, no Passo 5. Leia junto o `../adr-contract/SKILL.md` (Quando uma decisão merece um ADR) e confirme a candidata contra os critérios de lá antes de propor.

Esta skill não redige ADR. Ela para, propõe e, aceita a proposta, passa a redação ao **adr-generator**.

## A proposta

Proponha o ADR ao arquiteto em três frases: qual é a decisão, com os caminhos em jogo; por que ela precisa de um ADR, pelo critério que ela atende; e que parte da ITS depende dela — os itens `D` e as unidades previstas.

A proposta é uma mensagem, não um registro: nenhum arquivo é criado e nenhum número de ADR é consumido antes da resposta. Com mais de uma candidata, proponha todas na mesma mensagem, cada uma com as suas três frases, junto com as outras pendências da parada. O arquiteto responde a cada uma.

A decisão já tem um registro `Proposed` no repositório, seja qual for a origem dele → não proponha outro. A ITS espera por aquele, e você diz isso ao arquiteto.

## A resposta

- **Proposta recusada** → nenhum ADR é criado. A recusa é a palavra do arquiteto de que a decisão tem escopo de story: ela recai numa linha de alternativa descartada na unidade que afeta, e a geração continua de onde parou.
- **Proposta aceita** → a geração desta ITS termina aqui. Execute o `adr-generator` (`../adr-generator/SKILL.md`) e entregue a ele, num bloco só, as quatro coisas que o Passo 1 dele pede — nos argumentos da invocação, ou, onde o agente não invoca uma skill com argumentos, como o texto que abre a execução dele:
  - **Decisão:** o que está sendo decidido, em uma frase;
  - **Caminhos:** os caminhos em jogo e o que o plano recomendaria;
  - **Origem:** `ITS-<story-id>`;
  - **Evidência:** o que a inspeção mostrou de cada caminho, com os arquivos, e o critério do adr-contract que a decisão atende.

  O registro tem de se entender sem esta conversa. Redigir, acompanhar os ajustes e aplicar a aprovação são dele. Se o `adr-generator` não estiver disponível, diga isso ao arquiteto e pare, sem improvisar o procedimento.

## Depois da decisão do arquiteto

A ITS recomeça do início, do Passo 0, conforme `restarting-after-an-adr.md` — na mesma sessão, quando o adr-generator devolve o controle, ou em outra, quando o arquiteto pedir a ITS de novo. Ela nunca é retomada do ponto em que parou: a decisão pode alcançar qualquer parte do plano. Enquanto o registro estiver `Proposed`, nada da ITS é planejado, escrito ou entregue.

## Delta que contradiz um ADR `Accepted`

Dois desfechos são legítimos:

- o plano cabe sob o ADR, e a restrição é escrita nas unidades que ela vincula;
- a story genuinamente substitui a decisão: o registro substituto é proposto aqui e, aceita a proposta, redigido pelo adr-generator, como qualquer outra candidata. O ADR substituído assume `Superseded by ADR-NNN` somente quando o arquiteto aprova o substituto.

A regra de precedência do prime-config vale: um conflito com um ADR `Accepted` é reportado, nunca resolvido por um fato da configuração.

---
name: use-case
description: O formato canônico do documento de caso de uso - template, regras de qualidade, histórico de revisões (delta), ciclo de vida do status e marcadores de incerteza. Consulte para criar, atualizar, validar ou ler um caso de uso; quem só lê usa references/consumer-rules.md. Referencie-o, nunca o duplique.
---

# Formato de Caso de Uso

Esta skill é dona do formato do documento de caso de uso. O formato tem um endereço e um dono: toda outra skill o referencia, nunca o copia. Uma mudança aqui atualiza escrita e leitura ao mesmo tempo.

## O template canônico

`references/use-case-template.md` define a forma do documento:

- a nomenclatura de arquivo — `use-cases/UC-NNN-titulo-curto.md`, sob a raiz de documentos do projeto;
- a granularidade: o que um documento descreve, e o que é nível, extensão ou documento próprio;
- a reorganização entre documentos — divisão e incorporação;
- a forma das regras de negócio, em padrões adaptados do EARS;
- a estrutura do documento: metadados, envolvidos e interesses (opcional), condições (pré-condições, garantias mínimas e de sucesso), cenário principal de sucesso, extensões, regras de negócio, critérios de aceite rotulados com o que cobrem — inclusive os requisitos não funcionais do fluxo —, resumo gráfico em UML (opcional, omitido sem relações a mostrar) e histórico de revisões;
- as regras de qualidade que todo documento precisa satisfazer;
- a lista de perguntas com que os marcadores chegam ao arquiteto.

`references/consumer-rules.md` define o que quem só lê também precisa:

- as seções obrigatórias e opcionais do documento;
- a estabilidade dos identificadores;
- o ciclo de vida de status (Draft · Reviewed · Retired): quando um documento volta a Draft e quando passa a Retired;
- o delta pendente — o documento validado à frente do código;
- os tipos de entrada do histórico de revisões;
- os marcadores de incerteza (`[INFERRED]`, `[CONFIRM: ...]`) para conteúdo não verificado.

Quem escreve um documento de caso de uso, ou o valida contra as regras de qualidade, lê os dois arquivos por inteiro. Quem só lê — o its-generator, o code-review, o impact-mapping — lê só `references/consumer-rules.md`: basta para conferir o status e as seções obrigatórias de um documento recebido como entrada.

## Regras inegociáveis (resumo — o template e as regras de consumo são a autoridade)

- Casos de uso são a fonte de verdade viva do comportamento do sistema. Stories são diffs aplicados a eles.
- Toda entrada do Histórico de revisões tem um tipo — criação, alteração, conformidade, retirada, mapeamento inicial, reconciliação ou revisão editorial. Só as quatro primeiras, identificadas pela story, são trabalho para o its-generator: o delta é a principal entrada dele. Uma entrada por story por documento, reescrita só enquanto for a mais recente; uma story por vez sobre cada documento; máximo de 5 entradas, com o histórico completo no controle de versão. Não geram entrada: atualizações apenas de diagrama ou do campo Casos de uso relacionados (que é recíproco), a resolução de marcadores e uma story técnica, que não muda o comportamento observável de nenhum ator.
- `UC-NNN`, `RN-N` e `CA-N` nunca são renumerados nem reaproveitados. Um item removido ou movido vira lápide, e um documento que deixa de descrever comportamento vivo passa a `Retired`, nunca é apagado. Passos e extensões podem ser renumerados, desde que o delta declare a renumeração. Reorganizar documentos e mudar comportamento nunca acontecem na mesma entrada.
- Documentos com marcadores de incerteza não resolvidos permanecem em status Draft e não são fonte de verdade. Somente documentos Reviewed alimentam o ITS Generator — a única exceção é um documento Retired pela entrada de retirada da própria story. Uma entrada de alteração, de reconciliação ou de revisão editorial, ou um marcador novo, devolve um documento Reviewed a Draft: quem escreve rebaixa. A promoção é sempre um ato humano — a edição do Status só acontece por ordem explícita do arquiteto para aquele documento.
- `Reviewed` é validado, não implementado. Até a story ser entregue, o código pode fazer o que o documento descrevia antes do delta dela: isso é um delta pendente, e quem compara documento e código nunca o trata como divergência.
- O formato não é sobrescrevível. A configuração do projeto declara onde os casos de uso vivem, nunca a forma deles. Nenhum template customizado, nenhuma seção obrigatória extra. Mudar o formato é mudança deste contrato, pelo PR de governança. Quem precisa do caminho lê só a seção **Repositório de documentos** do `docs/prime-config.md`, no ponto da necessidade — nunca o arquivo inteiro, nunca como passo de abertura.

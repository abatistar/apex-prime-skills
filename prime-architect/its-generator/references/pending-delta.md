# Delta pendente de outra story

Parte do `its-generator`, lida só quando um caso de uso que o plano lê — o que ele altera ou um que fornece pontos de regressão — tem no Histórico de revisões a entrada de outra story ainda não entregue (use-case, Ciclo de vida do status).

Nesse caso, o corpo do documento descreve o estado-alvo daquela story, e o código ainda faz o anterior nos itens dela. O plano nunca presume em silêncio qual dos dois estará no código quando for implementado:

- **Delta desta story escrito sobre o de outra, no mesmo caso de uso** → o plano presume a outra entregue antes, porque foi escrito sobre o estado-alvo dela.
- **Delta pendente num caso de uso que só fornece regressão** → a ordem de entrega é pendência para o arquiteto. Os pontos de regressão nos itens daquele delta descrevem o estado que a ordem confirmada presume.

Nos dois casos, a ordem presumida vai para a linha Ordem de entrega do plano, por extenso: a mudança da outra story que o plano presume já no código, ou não. O ID da outra story não entra no documento. Na conferência do Passo 6, o item Dependência confere essa linha.

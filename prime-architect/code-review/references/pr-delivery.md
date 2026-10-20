# Entrega no pull request

Parte do `prime-architect/code-review`, lida com o relatório pronto, para desdobrá-lo no pull request.

O relatório é o registro completo; no pull request, ele se desdobra para que cada achado tenha a sua conversa e o veredito governe o merge pelas políticas da plataforma. A plataforma e as políticas de PR são as que a configuração declara em Pipeline. Sem elas declaradas, o relatório é entregue inteiro ao arquiteto, que decide onde publicá-lo.

**Quem publica.** Esta skill redige os comentários, o voto e os itens de backlog; publicá-los, votar e registrar os itens é ato do arquiteto — ou do agente, por ordem explícita dele para aquela revisão. Um comentário publicado chega ao autor e fica no histórico do PR: nada sai sem que o arquiteto tenha visto o que sai.

**Os comentários.**

- Cada achado com local vira um comentário na linha — ou no arquivo, quando vale para o arquivo inteiro —, começando pelo token da severidade (`Blocking:`, `Question:`, ...) e com o mesmo texto do relatório.
- O achado sem local no código — de escopo, de ITS, de documentação — vai na conversa geral do PR.
- O resumo é um comentário só, na conversa geral: o veredito e a razão, a rodada, a conformidade de escopo, a cobertura, os follow-ups, o que foi bem feito e a lista numerada do que governa o merge, cada item apontando para o seu comentário.
- Nenhum comentário traz código pronto para aplicar — nem pelo recurso de sugestão de alteração da plataforma: seria escrever código de aplicação. O comentário instrui.

**O que pede resposta fica aberto.** Os comentários de `Blocking:`, `Question:` e `Consider:` abrem ativos: todos pedem resposta antes do merge. `Nit:` e `FYI:` são publicados já fechados — não pedem nada, e um comentário ativo sem pedido vira bloqueio por acidente quando a política exige a resolução de todos. O autor responde e marca o desfecho: o corrigido como resolvido; o `Consider:` declinado, com a razão, como não corrigido. Quem confirma que um `Blocking:` foi resolvido é o revisor, na rodada seguinte; o que não foi resolvido volta a ficar ativo.

**O voto, no Azure DevOps.**

| Resultado da revisão | Voto | Observação |
|---|---|---|
| Approve | Approve | |
| Approve with comments | Approve with suggestions | os comentários ativos seguram a conclusão do PR até a resposta, quando a resolução de comentários é obrigatória |
| Request changes | Wait for author | |
| Return to the architect | Wait for author | o resumo diz que a espera é pela revisão da ITS, não por um conserto; o autor devolve o PR a rascunho até ela chegar |
| Not reviewable | Wait for author | o resumo diz a pré-condição que falta e quem a resolve |

Reject não é usado: nenhum resultado desta skill diz que a mudança não deve existir — direção errada é Request changes ou Return to the architect. Quando a aprovação fica pendente do responsável de segurança (Passo 6), ele é incluído no PR como revisor obrigatório, e o voto do arquiteto, sozinho, não conclui o merge. Em outra plataforma, o desenho é o mesmo, com os votos e os estados de comentário equivalentes.

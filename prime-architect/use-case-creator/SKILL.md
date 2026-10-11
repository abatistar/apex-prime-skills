---
name: use-case-creator
description: Cria novos documentos de caso de uso ou atualiza os existentes a partir de user stories, PRDs ou descrições informais de mudança, escrevendo contra o formato do prime-core/use-case. Skill da camada do arquiteto. Use sempre que o usuário quiser escrever, refinar, derivar ou manter casos de uso - p. ex., "escreva o caso de uso desta story", "esta story muda o fluxo de checkout, atualize a documentação", "derive os casos de uso deste PRD", "adicione uma exceção ao UC-042". O repositório de casos de uso é a fonte de verdade viva do comportamento do sistema; esta skill o mantém vivo. NÃO use para documentar comportamento já implementado e sem documentação prévia (use-case-extractor) nem para gerar uma ITS (its-generator).
---

# Use Case Creator (prime-architect)

Cria e mantém o repositório de casos de uso do projeto — a documentação viva do comportamento do sistema. Stories são unidades de mudança; casos de uso são o estado a que essas mudanças se aplicam. Toda story que altera comportamento precisa deixar o repositório atualizado, com um delta explícito registrado para que o its-generator possa planejar a implementação.

O formato do documento NÃO é definido aqui — é de propriedade do **prime-core/use-case** (template em `references/use-case-template.md` dentro dessa skill). Leia-o integralmente, incluindo suas regras de qualidade, antes de escrever: elas fazem parte do contrato desta skill.

## Passo 0 — Carregar a configuração do projeto e o formato do core

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, tratamento de divergências e o procedimento de bootstrap quando o arquivo está ausente vivem todos nesse contrato; nunca os rederive aqui. Da configuração esta skill usa: as convenções, as localizações do repositório de documentos e qualquer override de template de caso de uso. Em seguida carregue o formato do prime-core/use-case; se a configuração declarar um template customizado, ele tem precedência sobre o padrão do core.

## Passo 1 — Rotear: criação, atualização ou ambos

Leia a entrada (user story, trecho de PRD ou descrição informal) e examine o repositório de casos de uso (`docs/use-cases/` por padrão) para responder: esta mudança introduz comportamento sem documento existente (**modo criação**), modifica comportamento documentado (**modo atualização**) ou ambos?

A relação story–caso de uso é N-para-N. Liste todo caso de uso existente afetado e todo novo a nascer, e **confirme esse mapeamento com o usuário antes de escrever**. Um mapeamento errado aqui corrompe tudo o que vem depois.

Se a story claramente modifica comportamento existente mas não existe caso de uso correspondente no repositório, não improvise um a partir da imaginação: recomende executar o use-case-extractor naquela área primeiro e depois reexecutar esta skill.

## Passo 2a — Modo criação

1. Elicite antes de escrever. Percorra este checklist com o usuário para tudo o que a story não responde:
   - Quem inicia a ação? Há atores secundários ou sistemas externos?
   - O que precisa ser verdade antes de o cenário poder começar (permissões, estado, limites)?
   - O que acontece quando a validação falha? Quando o ator não tem permissão? Quando um limite é atingido? Quando uma integração está fora do ar ou estoura o timeout? Quando dois atores agem concorrentemente? (Cada resposta vira uma extensão com um desfecho definido.)
   - O que é garantido após o sucesso (Garantias de sucesso)? O que se mantém mesmo em caso de falha (Garantias mínimas — p. ex., trilha de auditoria, nenhum estado parcial)?
2. Envolvidos e Interesses é **opcional**: preencha-o somente quando a entrada (story, PRD, elicitação) revelar interesses de envolvidos. Não invente envolvidos para preencher a seção — omita-a.
3. Se houver um PRD, use-o como contexto para o Nome/objetivo e para respeitar o não-escopo declarado — não projete comportamento que o PRD exclui.
4. Preencha o template do core por completo, incluindo o resumo gráfico em UML restrito a este caso de uso e suas relações diretas. Escolha o próximo número de UC livre. Status: `Draft`. A promoção a `Reviewed` é um ato do arquiteto e acontece por palavra dele, nunca pelo seu julgamento de que o documento parece completo — inclusive quando ele o valida na mesma sessão.
5. A primeira entrada do Histórico de revisões referencia o ID da story de origem e a data.

## Passo 2b — Modo atualização

1. Leia o documento atual **por inteiro** — nunca remende um documento que você não leu.
2. Aplique a mudança descrita pela story aos passos, extensões, garantias, regras e critérios afetados.
3. Verifique efeitos colaterais internos: uma mudança no passo 3 pode invalidar a extensão 5a, uma garantia ou um critério de aceite. Corrija ou sinalize toda inconsistência que a mudança introduz. Se a mudança altera atores ou relações do caso de uso, atualize o diagrama UML para acompanhar — a atualização do diagrama em si não é um item de delta.
4. Registre o delta como uma nova entrada do Histórico de revisões: ID da story, data e um resumo preciso do que foi **adicionado / alterado / removido**, referenciando identificadores de passo, extensão e seção (p. ex., "Adicionada extensão 3b (limite de exportações concorrentes); alterado passo 5; removida RN-4"). Essa entrada é a principal entrada do its-generator — vagueza aqui vira uma ITS ruim.
5. Mantenha apenas as 5 entradas mais recentes do Histórico de revisões; descarte as mais antigas (o histórico completo vive no controle de versão).

## Passo 3 — Verificação de consistência cruzada

Antes de finalizar, examine o repositório em busca de conflitos: o comportamento novo/alterado contradiz um cenário, extensão, regra ou garantia documentados em outro caso de uso (p. ex., uma nova regra de permissão que outro cenário assume inexistente)? Se houver conflito, reporte-o ao usuário em vez de prosseguir em silêncio. Se a resolução exigir alterar também o outro documento, trate-o como parte do mapeamento da mesma story (volte ao Passo 1).

## Passo 4 — Entregar

Apresente os documentos criados/atualizados. Para atualizações, resuma o delta explicitamente na sua resposta para que o usuário possa validá-lo — o delta é o que o its-generator transformará em uma ITS. Atualize os links de Casos de uso relacionados em todo documento tocado.

## Saída

Arquivos `UC-NNN-titulo-curto.md` criados e/ou revisados no repositório configurado, cada revisão carregando um delta identificado pela story em seu Histórico de revisões, mais uma lista reportada de quaisquer conflitos entre documentos.

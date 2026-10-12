---
name: use-case-creator
description: Cria novos documentos de caso de uso ou atualiza os existentes a partir de user stories, PRDs ou descrições informais de mudança, escrevendo contra o formato do prime-architect/use-case. Use sempre que o usuário quiser escrever, refinar, derivar ou manter casos de uso - p. ex., "escreva o caso de uso desta story", "esta story muda o fluxo de checkout, atualize a documentação", "derive os casos de uso deste PRD", "adicione uma exceção ao UC-042". Use também para resolver os marcadores de incerteza de um documento em Draft ("resolva os CONFIRM do UC-042") e para tratar uma divergência entre código e caso de uso ("o código não faz o que o UC-042 diz"). O repositório de casos de uso é a fonte de verdade viva do comportamento do sistema; esta skill o mantém vivo. NÃO use para documentar comportamento já implementado e sem documentação prévia (use-case-extractor) nem para gerar uma ITS (its-generator).
---

# Use Case Creator (prime-architect)

Cria e mantém o repositório de casos de uso do projeto — a documentação viva do comportamento do sistema. Stories são unidades de mudança; casos de uso são o estado a que essas mudanças se aplicam. Toda story que altera comportamento precisa deixar o repositório atualizado, com um delta explícito registrado para que o its-generator possa planejar a implementação.

O formato do documento NÃO é definido aqui — é de propriedade do **prime-architect/use-case** (template em `references/use-case-template.md` dentro dessa skill). Leia-o integralmente, incluindo suas regras de qualidade, antes de escrever: elas fazem parte do contrato desta skill.

## Passo 0 — Carregar a configuração do projeto e o formato de caso de uso

Leia o `docs/prime-config.md` conforme o **prime-core/prime-config** — localização, alternativa, precedência, tratamento de divergências e o procedimento de bootstrap quando o arquivo está ausente vivem todos nesse contrato; nunca os rederive aqui.

Da configuração esta skill usa: a localização e a nomenclatura do repositório de casos de uso, os overrides de caso de uso (caminho de um template customizado e seções obrigatórias extras) e o formato do identificador de story (padrão `S-NNN`). Em seguida carregue o formato do prime-architect/use-case; um template customizado declarado na configuração tem precedência sobre o template padrão do formato, e as seções obrigatórias extras entram em todo documento que esta skill escreve.

## Passo 1 — Rotear: o que a entrada pede de cada documento

Leia a entrada (user story, trecho de PRD, descrição informal, achado de divergência ou respostas a marcadores) e examine o repositório de casos de uso (na localização declarada na configuração; `docs/use-cases/` por padrão) para classificar o que ela pede de cada documento:

- **Criação** — comportamento novo, sem documento existente (Passo 2a).
- **Atualização** — muda comportamento documentado (Passo 2b).
- **Conformidade ou reconciliação** — o código e o documento já divergem; o arquiteto decide qual dos dois está certo (Passo 2c).
- **Validação** — resolver os marcadores de incerteza de um documento em `Draft` com as respostas do arquiteto (Passo 2d).

Uma mesma story pode combinar modos em documentos diferentes. A relação story <–> caso de uso é N-para-N. Liste todo caso de uso existente afetado e todo novo a nascer, com o modo de cada um, e **confirme esse mapeamento com o usuário antes de escrever**. Um mapeamento errado aqui corrompe tudo o que vem depois.

Junto com o mapeamento, confirme o **ID da story**: toda entrada de criação, alteração ou conformidade o carrega, e é por ele que o its-generator encontra o delta. Se a entrada não tem story (um PRD ainda em refinamento, uma descrição informal), siga as regras do Histórico de revisões do formato: a coluna Story leva a origem seguida de `[CONFIRM: story de origem]`, e o documento fica em `Draft` até o ID real substituir o marcador.

O delta de uma story nunca é aplicado sobre uma base não validada. Um documento afetado com marcadores pendentes passa primeiro pelo modo validação e pela promoção do arquiteto, e só então recebe o delta — do contrário, quando os marcadores forem resolvidos, não dá mais para separar o que o sistema já fazia do que a story muda.

Se a story claramente modifica comportamento existente mas não existe caso de uso correspondente no repositório, não improvise um a partir da imaginação: recomende executar o use-case-extractor naquela área primeiro. A saída dele nasce em `Draft` com marcadores — resolva-os no modo validação, aguarde a promoção do arquiteto e depois reexecute esta skill para a story.

## Passo 2a — Modo criação

1. Verifique antes de escrever. Responda este checklist a partir da entrada (story, PRD), do repositório e dos casos de uso vizinhos — ele é uma autoverificação, não um questionário para o usuário:
   - Quem inicia a ação? Há atores secundários ou sistemas externos?
   - O que precisa ser verdade antes de o cenário poder começar (permissões, estado, limites)?
   - O que acontece quando a validação falha? Quando o ator não tem permissão? Quando um limite é atingido? Quando uma integração está fora do ar ou estoura o timeout? Quando dois atores agem concorrentemente? (Cada resposta vira uma extensão com um desfecho definido.)
   - Que regras governam os passos — limites, cálculos, prazos, políticas? (Cada uma vira uma `RN-N` enunciada de forma testável.)
   - O que é garantido após o sucesso (Garantias de sucesso)? O que se mantém mesmo em caso de falha (Garantias mínimas — p. ex., trilha de auditoria, nenhum estado parcial)?
   - Que resultado observável prova cada passo e cada extensão? (Vira o critério de aceite correspondente.)

   Pergunte ao usuário apenas o que mudaria a estrutura do documento — p. ex., se um comportamento é uma extensão deste caso de uso ou um caso de uso próprio, ou a qual documento uma regra pertence — e leve a sua recomendação junto com a pergunta. O que a entrada não responde e não muda a estrutura vira `[CONFIRM: ...]` no ponto exato do documento: ele já nasce em `Draft`, e a pergunta chega ao arquiteto na entrega (Passo 4).
2. Envolvidos e Interesses é **opcional**: preencha-o somente quando a entrada (story, PRD, elicitação) revelar interesses de envolvidos. Não invente envolvidos para preencher a seção — omita-a.
3. Se houver um PRD, use-o como contexto para o Nome/objetivo e para respeitar o não-escopo declarado — não projete comportamento que o PRD exclui.
4. Preencha o template do formato por completo — exceto seções opcionais sem conteúdo, como Envolvidos e interesses —, incluindo o resumo gráfico em UML restrito a este caso de uso e suas relações diretas. Preencha Casos de uso relacionados nos dois lados: acrescente este documento ao campo de cada UC-XXX citado, mesmo fora do mapeamento — é uma atualização derivada, sem entrada no histórico e sem mudança de Status. Escolha o próximo número de UC livre. Status: `Draft`. A promoção a `Reviewed` é um ato do arquiteto e acontece por palavra dele, nunca pelo seu julgamento de que o documento parece completo — inclusive quando ele o valida na mesma sessão.
5. A primeira entrada do Histórico de revisões é do tipo criação: o ID da story confirmado no Passo 1, a data e o Resumo `Criação`.

## Passo 2b — Modo atualização

1. Leia o documento atual **por inteiro** — nunca remende um documento que você não leu.
2. Aplique a mudança descrita pela story aos passos, extensões, garantias, regras e critérios afetados, conforme a estabilidade dos identificadores do formato: `RN-N` e `CA-N` removidos viram lápide e nunca são renumerados nem reaproveitados; uma renumeração de passos é declarada no delta (item 4). O que a story não responde segue a regra do item 1 do Passo 2a: pergunte só o que muda a estrutura; o resto vira `[CONFIRM: ...]`.
3. Verifique efeitos colaterais internos: uma mudança no passo 3 pode invalidar a extensão 5a, uma garantia ou um critério de aceite. Corrija ou sinalize toda inconsistência que a mudança introduz. Se a mudança altera atores ou relações do caso de uso, atualize o diagrama UML e o campo Casos de uso relacionados nos dois lados para acompanhar — atualizações derivadas, que não são itens de delta e não mudam o Status do outro documento.
4. Registre o delta como uma entrada de alteração no Histórico de revisões: ID da story, data e um resumo preciso do que foi **adicionado / alterado / removido**, referenciando identificadores de passo, extensão e seção (p. ex., "Adicionada extensão 3b (limite de exportações concorrentes); alterado passo 5; removida RN-4"). Essa entrada é a principal entrada do its-generator — vagueza aqui vira uma ITS ruim. Se o documento já tem uma entrada desta story — uma reexecução, p. ex. porque o its-generator devolveu o delta —, reescreva-a com o delta consolidado contra o estado anterior à story; nunca acrescente uma segunda entrada para a mesma story.
5. Se o documento estava `Reviewed`, devolva-o a `Draft`: o conteúdo novo ainda não foi validado. O arquiteto o promove de novo depois de validar o delta (Passo 4).
6. Mantenha apenas as 5 entradas mais recentes do Histórico de revisões; descarte as mais antigas (o histórico completo vive no controle de versão).

## Passo 2c — Modo conformidade ou reconciliação

O código e o documento discordam — achado trazido pelo impact-mapping, pela feasibility-analysis, pelo code-review ou por uma story de correção.

1. Leia o documento **por inteiro** e o trecho de código citado pela evidência da divergência. Se a divergência não cabe num trecho ancorado — o documento inteiro deixou de descrever o sistema —, reporte ao arquiteto em vez de remendar.
2. Apresente os dois lados — o que o documento afirma (com seus identificadores) e o que o código faz (arquivo e linha) — e deixe o arquiteto decidir qual está certo. Nunca decida por ele: a escolha define se haverá implementação.
3. **O código está errado → conformidade.** O corpo do documento não muda. Registre uma entrada de conformidade com o ID da story que corrigirá o código e o Resumo `Conformidade:` seguido dos identificadores que o código passa a cumprir (p. ex., "Conformidade: o código passa a cumprir o passo 5 e o CA-3"). O Status não muda. Se ainda não há story, reporte que a correção precisa de uma; a entrada é registrada quando ela existir.
4. **O documento está errado → reconciliação.** Corrija o corpo para descrever o que o código faz, com as mesmas verificações dos itens 1–3 do Passo 2b. Registre uma entrada de reconciliação (`reconciliação com o código` na coluna Story; no Resumo, o que mudou, como numa alteração) e devolva o documento a `Draft` se estava `Reviewed`. Não há ITS: o código já faz isso.

## Passo 2d — Modo validação

Resolve os marcadores de incerteza de um documento em `Draft` — tipicamente a saída do use-case-extractor, ou um documento que o its-generator devolveu por ter marcadores pendentes.

1. Leia o documento **por inteiro** e liste os marcadores pendentes. Se não houver nenhum, não há o que resolver: o documento aguarda apenas a promoção do arquiteto.
2. Aplique as respostas do arquiteto: um `[CONFIRM: ...]` respondido vira conteúdo afirmado; um `[INFERRED]` confirmado perde a marca; um refutado tem o conteúdo corrigido. Uma resposta que revela um bug não vira regra limpa — o documento continua descrevendo o que o código faz, e a correção é uma story.
3. Um marcador sem resposta permanece.
4. Faça as verificações de efeito colateral do item 3 do Passo 2b: uma resposta pode mudar um passo, uma extensão, uma regra ou um critério.
5. Não registre entrada no Histórico de revisões — a resolução esclarece um documento que ainda não é fonte de verdade — e não promova o documento. Quando não restar marcador, diga ao arquiteto que ele pode promovê-lo.

## Passo 3 — Validar antes de entregar

**Qualidade, documento a documento.** Verifique todo documento escrito ou alterado contra as regras de qualidade do formato, uma a uma — nunca pela impressão de que o documento parece completo. O its-generator só confere o Status e as seções obrigatórias: uma extensão sem critério de aceite ou uma regra órfã que passe daqui chega à ITS e ao code review. Corrija toda violação; quando a correção depende de uma resposta do arquiteto, marque `[CONFIRM: ...]` no ponto exato.

**Consistência cruzada.** Examine o repositório em busca de conflitos: o comportamento novo/alterado contradiz um cenário, extensão, regra ou garantia documentados em outro caso de uso (p. ex., uma nova regra de permissão que outro cenário assume inexistente)? Se houver conflito, reporte-o ao usuário em vez de prosseguir em silêncio. Se a resolução exigir alterar também o outro documento, trate-o como parte do mapeamento da mesma story (volte ao Passo 1).

## Passo 4 — Entregar

Apresente os documentos criados/atualizados. Para atualizações e conformidades, resuma o delta explicitamente na sua resposta para que o usuário possa validá-lo — o delta é o que o its-generator transformará em uma ITS; para reconciliações, resuma o que mudou no corpo. Liste também os documentos que receberam apenas o link recíproco em Casos de uso relacionados.

Informe o Status resultante de cada documento: um documento que voltou a `Draft` só alimenta o its-generator depois que o arquiteto o promover. Liste, por documento, os marcadores `[CONFIRM: ...]` pendentes — são as perguntas que o arquiteto precisa responder antes de promovê-lo.

A passada operacional vive em `checklists/creation-checklist.md`. O template do próprio documento não: ele é de propriedade do `prime-architect/use-case` e é lido de lá.

## Saída

Arquivos `UC-NNN-titulo-curto.md` criados e/ou revisados no repositório configurado, cada entrada do Histórico de revisões num dos tipos que o formato define (criação, alteração, conformidade, reconciliação), o Status resultante de cada documento e uma lista reportada de conflitos entre documentos e de marcadores pendentes.

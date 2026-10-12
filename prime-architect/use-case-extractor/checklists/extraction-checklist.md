# Extração de casos de uso — passada operacional

A passada operacional do `prime-architect/use-case-extractor`. **Nenhum template de documento vive aqui:** a estrutura do caso de uso, as regras de qualidade, os tipos de entrada do Histórico de revisões e os marcadores são de propriedade do `prime-architect/use-case` (`references/use-case-template.md`) e nunca são copiados para esta camada. Este arquivo confere o *processo*; aquele arquivo fornece a *forma*.

## Configuração e formato

- [ ] `docs/prime-config.md` lido conforme o contrato **prime-core/prime-config**.
- [ ] Da configuração: stack, mapa de estrutura, localização e nomenclatura do repositório de casos de uso, template customizado, seções obrigatórias extras.
- [ ] Formato `use-case` carregado por inteiro, incluindo as regras de qualidade e os marcadores; template customizado, quando declarado, no lugar do padrão.
- [ ] Divergência entre configuração e código → reportada, não resolvida em silêncio.

## Escopo

- [ ] Uma fatia delimitada — módulo, jornada de usuário, conjunto de endpoints —, nunca "o sistema inteiro". Fronteiras confirmadas com o usuário.
- [ ] No máximo 3–5 documentos por execução. Mais que isso → trabalho dividido em execuções, cada fatia confirmada com o usuário.

## Inventário

- [ ] Toda superfície de interação do escopo listada — rotas/controllers HTTP, consumidores de mensagens, jobs agendados, comandos de CLI, handlers de eventos —, procurada pelo mapa de estrutura da configuração.
- [ ] Pontos de entrada agrupados pelo objetivo do ator (Granularidade do formato): cada objetivo é um candidato; ponto técnico sem objetivo de ator listado à parte.
- [ ] Nenhum candidato que já tenha caso de uso no repositório. Documento existente que diverge do código → `use-case-creator` (conformidade ou reconciliação), nunca um documento novo. Candidato coberto por um documento `Retired` → reportado ao arquiteto.
- [ ] Inventário agrupado apresentado e candidatos acordados com o usuário antes de escrever qualquer documento.

## Reconstrução

- [ ] Caminho de execução de cada candidato rastreado no código, não deduzido de nomes.
- [ ] Código traduzido para os elementos do template: validações e guardas que o fluxo executa → extensões; ramificações de negócio → passos, extensões e `RN-N`; efeitos persistidos, eventos e chamadas externas → Garantias de sucesso; o que se mantém na falha → Garantias mínimas; tratamento de erro → extensões com desfecho; autorização do próprio fluxo → extensões; timeouts, limites de volume, janelas e expurgos → critério `não funcional` com `[CONFIRM: ...]` (requisito ou restrição técnica?).
- [ ] Toda `RN-N` num padrão da Forma das regras de negócio, escolhido pela forma do código: cálculo ou constante → ubíquo; handler ou consumidor → `Quando`; guarda de estado → `Enquanto`; ramo de erro → `Se … então`, citada por uma extensão; flag ou configuração → `Onde`, com `[INFERRED]`. Uma resposta por regra; nenhuma regra cita passo nem extensão.
- [ ] Pré-condição só o que o fluxo não verifica porque já chega garantido — outro caso de uso, controle transversal anterior ao ponto de entrada.
- [ ] Testes existentes do código rastreado lidos e usados como fonte dos critérios de aceite, cada critério rotulado com o que cobre. Teste que contradiz o código ou desligado → `[CONFIRM: ...]`.
- [ ] Envolvidos e interesses só quando o material rastreado expõe um, sempre com `[INFERRED]`; caso contrário, seção omitida.

## Incerteza

- [ ] Todo conteúdo deduzido em vez de rastreado de ponta a ponta marcado com `[INFERRED]`. Nada rastreado marcado só por falta de teste.
- [ ] Toda decisão humana pendente marcada com `[CONFIRM: ...]`: números mágicos, ramificações ambíguas, comportamento suspeito de bug.
- [ ] Nenhum comportamento estranho normalizado numa regra limpa — documentado como o código o executa e sinalizado.

## Escrita

- [ ] Template do formato e convenção de nomenclatura; numeração a partir do maior número de UC já usado + 1, documentos `Retired` inclusive.
- [ ] Status `Draft`.
- [ ] Primeira entrada do tipo mapeamento inicial: `mapeamento inicial a partir do código` na coluna Story, o escopo no Resumo.
- [ ] Diagrama UML só quando há relações a mostrar, restrito ao caso de uso e às suas relações diretas.
- [ ] Casos de uso relacionados preenchidos nos dois lados, inclusive com documentos já existentes. Link recíproco sem entrada no histórico e sem mudança de Status no outro documento.
- [ ] Regras de qualidade do formato verificadas uma a uma em todo documento escrito.

## Entrega

- [ ] Marcadores pendentes entregues como a Lista de perguntas do formato, com recomendação e evidência `arquivo:linha` em cada item.
- [ ] Declarado que os documentos só viram fonte de verdade depois que o arquiteto resolver os marcadores (modo validação do `use-case-creator`) e os promover.
- [ ] Documentos existentes que receberam apenas o link recíproco listados.

## Verificação de fronteira antes de entregar

- [ ] Nenhum status promovido.
- [ ] Nenhuma intenção inventada: todo conteúdo se apoia em código ou testes lidos, ou carrega um marcador.
- [ ] Nenhum código de aplicação alterado; nenhuma ITS gerada.
- [ ] Nenhum arquivo de configuração editado como efeito colateral.

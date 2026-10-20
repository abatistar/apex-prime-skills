# Regras para quem consome a configuração

Parte do contrato do `prime-core/prime-config`, e a única que o Passo 0 de uma skill lê: onde a configuração fica, como ela se combina com os contratos, o que fazer quando falta ou diverge do código e quem pode mudá-la. O SKILL.md do contrato — seções, pontos de override, validação e bootstrap — só entra para fazer o bootstrap, validar ou atualizar a configuração.

## Um arquivo por projeto

Um projeto é uma unidade de código com seu próprio ciclo de entrega — um microsserviço ou um sistema legado. Uma demanda que atravessa vários projetos é quebrada em demandas por projeto antes de chegar ao Apex Prime, e cada uma corre no projeto que a recebe; nenhuma skill segue um fluxo para além da fronteira do projeto.

## Localização

- O arquivo vive **no repositório do código**, porque descreve o código e muda no mesmo PR que muda o que descreve. Caminho canônico: `docs/prime-config.md`. Alternativa: raiz do repositório (`prime-config.md`) — a natural quando a documentação do projeto fica fora do repositório. Nenhum outro local, nem a raiz de documentos quando ela é uma pasta paralela.
- O arquivo é versionado com o código e muda por PR, como o código.
- **Nunca carrega segredo, credencial, endereço com credencial ou dado pessoal.** É versionado e lido por agentes; o que é sensível vive no cofre do projeto.

## Regras de precedência

1. **Explícito vence detectado.** O que a configuração declara vence qualquer coisa que a skill infira de arquivos de build ou árvores de diretórios.
2. **A configuração sobrescreve os padrões dos contratos apenas nos pontos de override declarados** (a tabela de Pontos de override do SKILL.md). Nesses pontos, o valor da configuração vence de forma absoluta — um override de slot vence o padrão da stack, e o mais específico vence o mais geral (área → nível → projeto → padrões do time na release fixada); o estado registrado de uma área vence o padrão atual para slots convencionais.
3. **A configuração nunca sobrescreve uma regra de um contrato.** Não pode dispensar a rastreabilidade, o ciclo de vida de status do caso de uso, os gates de qualidade nem um critério `[NON-NEGOTIABLE]`. A configuração pode **elevar** a régua; relaxar um inegociável é uma decisão deliberada, com responsável, registrada em um ADR, nunca uma edição de configuração.
4. **A configuração não sobrescreve um ADR Accepted.** Um conflito entre eles é reportado, não resolvido em silêncio.

## Divergências e lacunas

- **A configuração existe mas contradiz o código** (diz Java 21, o `pom.xml` diz 25; a Estrutura declara um pacote que o teste de arquitetura não verifica): reporte a divergência e pergunte qual está correta antes de prosseguir. Nunca confie em silêncio em qualquer um dos lados.
- **A configuração existe mas falta uma seção obrigatória:** prossiga só se a tarefa em andamento não precisar dessa seção; caso contrário, reporte a lacuna e ofereça completá-la pelo procedimento de bootstrap do SKILL.md (restrito à seção ausente).
- **A configuração existe mas um slot de que a tarefa precisa não tem valor** — nem padrão da stack na release fixada nem override: é uma lacuna reportável conforme o prime-core/coding-standards (Slots não preenchidos). Reporte-a e ofereça preenchê-la; nunca improvise um valor e nunca prossiga em silêncio numa tarefa que dependa dele. Um slot declarado "não se aplica", com o motivo, não é lacuna.
- **Uma seção de que a tarefa depende tem um marcador `[CONFIRM: ...]`:** a configuração continua utilizável, mas exponha o marcador junto do resultado que depende dele.
- **A configuração não fixa a release do Apex Prime:** vale a instalada — a que o manifesto da instalação (`apex-prime.json`) registra no campo `version`; o manifesto fica na raiz do formato instalado: `.github/` ou `.claude/` no projeto, `~/.copilot/` ou `~/.claude/` no perfil do usuário —, e a ausência da fixação é uma lacuna a reportar: sem ela, uma release nova alcança o projeto sem que ninguém a tenha adotado.
- **A release instalada difere da fixada:** reporte a divergência e pergunte qual vale antes de prosseguir. Instalar a release fixada resolve; subir a fixação é uma decisão do projeto, conforme o prime-core/coding-standards, e nunca um efeito colateral de uma reinstalação.
- **A raiz de documentos declarada não existe ou não está acessível na sessão:** reporte. Se a pasta não existe, ofereça criá-la (procedimento de bootstrap do SKILL.md, passo 5); se existe fora da sessão, peça que ela seja aberta ou adicionada à sessão. Nunca escreva um documento do Apex Prime em outro lugar para contornar a ausência.
- **Um papel de Responsáveis de que a tarefa precisa não tem nome:** reporte a lacuna. Uma exceção de segurança, por exemplo, não é concedida sem o responsável de segurança.
- **A configuração não existe:** ofereça fazer o bootstrap (procedimento do SKILL.md). As skills não prosseguem com pura detecção sem dar ao usuário uma configuração para revisar — fatos indetectáveis (convenções, áreas proibidas, classificação de áreas) estariam silenciosamente ausentes.

Uma skill consumidora não executa a validação inteira: reporta apenas o que encontrar no que a sua tarefa usa.

## Ciclo de vida

A configuração muda por ato explícito, nunca como efeito colateral de outra tarefa. Dois caminhos levam a uma mudança:

- **Pelo SKILL.md deste contrato** — o bootstrap, uma validação ou uma atualização pedida pelo usuário — sempre entregue como rascunho para a revisão dele.
- **Pela ITS** — quando a story muda um fato que a configuração registra: uma área nova ou um nível de criticidade novo, um elemento ou pacote novo na Estrutura, o avanço ou a conclusão de uma migração, a remoção de código efêmero, um exemplo canônico novo, um comando novo. A ITS planeja a atualização como uma unidade, como qualquer outra mudança de arquivo; quem planeja essa unidade lê antes as Seções do SKILL.md deste contrato, que dizem o que cada seção guarda e em que forma. Quem implementa a executa no mesmo PR, e o code-review a confere.

Fora desses dois caminhos, nenhuma skill edita a configuração. Uma skill que descobre um fato desatualizado o reporta.

## Regra de consumo (para o Passo 0 de toda skill)

As skills referenciam este arquivo em vez de descrever o procedimento: *"Leia o `docs/prime-config.md` conforme as regras de consumo do prime-core/prime-config (`../prime-config/references/consumer-rules.md`)."* O caminho é relativo ao diretório da skill que lê, na instalação, em que as camadas ficam lado a lado num único diretório de skills.

Os documentos do Apex Prime — casos de uso, ITS, ADRs — são lidos e escritos sob a raiz de documentos que a configuração declara. Quando ela é uma pasta paralela, a sessão precisa enxergar as duas pastas, e o PR do código cita a ITS e a revisão da documentação que implementou, para que a revisão julgue contra a versão certa.

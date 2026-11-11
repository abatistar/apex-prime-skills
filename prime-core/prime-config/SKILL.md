---
name: prime-config
description: O contrato do docs/prime-config.md - as cinco seções (Stack, Estrutura, Repositório de documentos, Comandos de verificação, Opções), a validação e o bootstrap. Consulte para fazer o bootstrap, validar ou atualizar a configuração. Para apenas ler um fato do projeto, use references/consumer-rules.md, sem carregar este contrato.
---

# Contrato do Prime Config

O `prime-config.md` guarda os fatos do projeto que as skills não devem adivinhar: stack, estrutura, onde vive a documentação, como verificar o código e as opções que o projeto liga. Esta skill é dona do contrato do arquivo — seções, validação e bootstrap.

O arquivo guarda fatos, não instruções. O porquê de cada seção vive aqui; o arquivo do projeto carrega no máximo um ponteiro de uma linha por seção.

Nenhuma skill lê a configuração por rotina, e nenhuma a lê inteira. Cada uma lê a seção de que precisa, quando precisa de um fato que está nela. A regra está em `references/consumer-rules.md`, a parte deste contrato que um consumidor lê sozinha. Leia-a antes de qualquer procedimento abaixo.

Template canônico: `references/prime-config-template.md`. Leia-o integralmente antes de fazer o bootstrap ou de validar uma configuração.

## Seções

As cinco são obrigatórias. Falta uma: a configuração está incompleta (veja Divergências e lacunas, em `references/consumer-rules.md`).

**Stack** — linguagem e versão, framework, build, banco, migrações, mensageria. As versões têm peso: as skills planejam e revisam contra elas. Mais de um componente: uma Stack por componente, cada uma com seu tipo (`serviço` ou `cliente`, conforme o coding-standards).

**Estrutura** — a arquitetura do projeto e o pacote que representa cada elemento dela. No hexagonal: domínio, aplicação (portas de entrada, portas de saída, serviços), adaptadores de entrada e de saída, montagem. Os padrões do time definem os elementos e as regras entre eles, nunca os nomes dos pacotes — esse mapa é do projeto. Um projeto legado (Opções › Legado) declara a arquitetura que tem de fato, camadas por exemplo. É o mapa que o teste de arquitetura verifica, o que o its-generator usa para inspecionar código e o que o extractor usa para inventariar pontos de entrada.

**Repositório de documentos** — onde vive a documentação do Apex Prime: casos de uso, ITS e ADRs.

- **Raiz de documentos:** `docs`, no repositório do código e versionada com ele, ou uma pasta paralela ao projeto (sugestão: `../<projeto>-docs`), com versionamento próprio. A escolha é do projeto e é declarada. Sem declaração, vale `docs`.
- A localização e a nomenclatura de casos de uso, ITS e ADRs, relativas à raiz.

Os contratos donos — o `use-case` e o `its-contract` — têm padrões para isso, e a configuração os declara de forma explícita. Ela diz onde os documentos vivem, nunca que forma eles têm. O template de caso de uso, a estrutura da ITS e a do ADR não são substituíveis: mudá-las é mudança de contrato, pelo PR de governança, não entrada de configuração.

**Comandos de verificação** — como compilar, testar e rodar as verificações que o projeto tem: a suíte inteira, um teste isolado, o teste de arquitetura e, onde houver, mutação e contrato. Lidos por quem planeja, julga ou verifica — o its-generator fecha o plano da ITS com eles, o code-review os executa como pré-condição de uma revisão — e por quem implementa, que os roda antes do PR.

**Opções** — chaves de valor fechado que decidem comportamento das skills. Cada opção é declarada com seu valor. Uma opção ausente vale o padrão.

| Opção | Valores | Padrão | O que decide |
|---|---|---|---|
| Legado | `true` / `false` | `false` | O projeto é um sistema legado: não nasceu sob os padrões do time. |
| Template da ITS | `Markdown` / `Confluence` | `Markdown` | O formato de saída da ITS, conforme o its-contract, e a extensão do arquivo declarada em Repositório de documentos (`.md` ou `.wiki`). As seções e o nível de detalhe da ITS são os mesmos nos dois formatos. |

Projetos podem adicionar seções além destas. Seções desconhecidas são preservadas, nunca apagadas por nenhuma skill.

Um campo sem valor diz isso explicitamente ("nenhum"), nunca é omitido. Silêncio e ausência são fatos diferentes, e só um deles é uma decisão.

## Validação

Execute quando o usuário pedir ou depois de um bootstrap. Reporte cada achado com a correção sugerida. A correção é uma atualização explícita, revisada pelo usuário.

- As cinco seções estão presentes, e todo campo sem valor diz isso.
- A Stack confere com os arquivos de build.
- Todo caminho declarado existe: os pacotes da Estrutura e a raiz de documentos.
- Os pacotes da Estrutura são os que o teste de arquitetura verifica.
- Todo comando declarado roda.
- Toda opção tem um dos valores da sua lista fechada.
- A extensão declarada para a ITS confere com o Template da ITS.
- Nenhum marcador `[CONFIRM: ...]` ficou esquecido.
- Nada de segredo, credencial ou dado pessoal no arquivo.

## Procedimento de bootstrap

Execute quando a configuração estiver ausente, ou restrito às seções ausentes.

1. **Detectar.** Leia arquivos de build (`pom.xml`, `build.gradle`, `package.json`, ...), a árvore de diretórios, marcadores de framework, pastas de migração e definições de CI. Redija Stack, Estrutura e Comandos de verificação a partir de evidência. Cite a evidência — qual arquivo disse o quê — para que o usuário possa auditar a detecção. Na Estrutura, descreva a arquitetura que o código tem de fato.
2. **Definir o repositório de documentos.** Pergunte se a documentação fica no próprio repositório (`docs`) ou numa pasta paralela, versionada à parte. Se uma pasta `../<projeto>-docs` já existe, proponha-a com `[CONFIRM: ...]`. Dentro da raiz, use os padrões do core (`use-cases/`, `its/`, `adr/`) e ofereça criar as pastas ausentes. O versionamento de uma pasta paralela é do projeto, normalmente um repositório próprio.
3. **Decidir as Opções.** Elicite cada uma; nunca infira. Legado não se deduz de nome de diretório nem da idade dos arquivos — pergunte. O Template da ITS segue a ferramenta em que a equipe publica a documentação.
4. **Ligar os arquivos de contexto do agente.** Se o projeto tem `AGENTS.md`, `CLAUDE.md` ou `.github/copilot-instructions.md`, ofereça acrescentar uma linha que aponta para a configuração como fonte dos fatos do projeto. Não copie nenhum fato para lá: duas cópias dos comandos de build divergem na primeira mudança.
5. **Entregar como rascunho para revisão.** O usuário valida antes do commit. Uma configuração que ninguém revisou é detecção, não configuração — e explícito-vence-detectado só significa algo se um humano o tornou explícito.
6. **Marcar o que foi deduzido** e não confirmado com `[CONFIRM: ...]`, na mesma disciplina de marcadores do use-case.

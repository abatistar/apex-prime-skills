# Critérios de Qualidade

Catálogo canônico de propriedade do `prime-core/quality-model`. O SKILL.md define o que o modelo cobre e a prática de quem implementa; os níveis, a calibração por criticidade, a precedência, a disciplina de exceção e o uso pelo its-generator e pelo code-review vivem em `references/consumer-rules.md` — este índice e os arquivos de lente em `references/quality-criteria/` são os critérios e os perfis de criticidade. Os gatilhos que tornam critérios em decisões de especificação vivem em `references/quality-triggers.md`.

Cite os critérios por ID (`QM-XX-N`) em análises, achados e na seção Referências de uma ITS. Dentro de um artefato, o critério chega como a exigência concreta que impõe, nunca como o ID. Os IDs são estáveis e nunca renumerados; um critério aposentado mantém seu ID aposentado (veja o fim do arquivo).

**Estrela-guia.** Software de qualidade faz o que foi acordado, resiste a quem o ataca e ao que dá errado no ambiente, gasta o que o trabalho exige e continua barato de mudar ao longo do tempo. As dez lentes abaixo olham essa propriedade a partir das quatro características que podem ser julgadas no próprio código — as mesmas que a ISO/IEC 5055 mede na estrutura do software:

| Característica | Lentes |
|---|---|
| Manutenibilidade | RC legibilidade · CC acoplamento, coesão e contratos · CN consistência · TS testes · MT manutenibilidade e dívida · DO documentação |
| Confiabilidade | EO erros e observabilidade · RB robustez |
| Eficiência | EF eficiência de recursos |
| Segurança | SR segurança |

**Níveis — a natureza do critério, não uma consequência automática.**
- **[NON-NEGOTIABLE]** — o piso. Vale para todo código escrito ou alterado, em qualquer nível de criticidade. É cumprido, ou afastado apenas por exceção registrada. Cada um traz *Violação* — o teste que reconhece o pecado no código — e, onde há confusão comum, *Não é violação*.
- **[CALIBRATED]** — julgamento estruturado, sempre com sua *Tensão*. A intensidade vem do nível de criticidade da área (Perfis de criticidade, abaixo). Nunca uma regra a aplicar mecanicamente.
- **[AUTOMATE]** — o que pertence a ferramentas, no pipeline, antes de qualquer revisão humana (`QM-MT-7`). O que vale levantar é a ausência da ferramenta.

---

## O piso num relance

Os inegociáveis, reunidos para a autoverificação de quem implementa e para a varredura de quem revisa. O piso é longo porque cada item é binário e verificável — e não é a definição de bom: é o mínimo abaixo do qual nenhuma mudança vai, seja qual for a criticidade.

- **QM-RC-1** — Sem surpresa: nenhum nome oculta mutação, I/O ou evento.
- **QM-CC-1** — Sem estado mutável compartilhado entre módulos.
- **QM-CC-6** — Uma regra de negócio, um lugar.
- **QM-CC-7** — Contrato publicado não quebra em silêncio.
- **QM-CN-1** — Sem erosão: nenhuma segunda forma de fazer o que já tem forma estabelecida.
- **QM-CN-2** — O padrão local vence a preferência, nunca o piso.
- **QM-TS-1** — Sem teste instável na suíte.
- **QM-TS-2** — Testes verificam comportamento, não implementação.
- **QM-TS-7** — Mudança de comportamento chega com teste.
- **QM-TS-8** — Teste não se ajusta para ficar verde.
- **QM-MT-1** — Sem dívida invisível.
- **QM-MT-6** — Não piorar a área que a mudança toca.
- **QM-DO-1** — Documentação não mente.
- **QM-EO-1** — Nunca engolir um erro em silêncio.
- **QM-EO-2** — Nada sensível vaza; o usuário final não vê detalhe interno.
- **QM-EO-3** — A causa sobrevive à propagação.
- **QM-RB-1** — Nenhuma espera sem limite.
- **QM-RB-2** — Todo recurso adquirido é liberado.
- **QM-EF-1** — Nenhum trabalho ilimitado sobre dado que cresce.
- **QM-SR-1** — Entrada externa é hostil: validada na fronteira, separada de código.
- **QM-SR-2** — Sem segredos no código ou no controle de versão.
- **QM-SR-3** — Sem criptografia própria; senha nunca reversível.
- **QM-SR-4** — Dependência verificada e sem vulnerabilidade conhecida.
- **QM-SR-8** — Controle de acesso no servidor, negando por padrão e em falha.

---

## As lentes

Cada lente vive no seu arquivo, em `references/quality-criteria/`, e o `XX` de `QM-XX-N` nomeia o arquivo: `RC.md` legibilidade e clareza · `CC.md` acoplamento, coesão e contratos · `CN.md` consistência · `TS.md` testes automatizados confiáveis · `MT.md` manutenibilidade e dívida técnica · `DO.md` documentação proporcional · `EO.md` erros e observabilidade · `RB.md` robustez · `EF.md` eficiência de recursos · `SR.md` segurança.

Este índice é lido sempre. O arquivo de uma lente é lido quando um critério dela é citado ou aplicado — nunca o catálogo inteiro de antemão. O piso num relance, acima, basta para decidir se um inegociável alcança a mudança; o teste de *Violação* dele está no arquivo da lente.

---

## Perfis de criticidade

O nível de criticidade de uma área é declarado pelo projeto; quem declara, onde e como ele chega à ITS está na Calibração, em `references/consumer-rules.md`. **O piso não varia:** vale inteiro em todo nível. O nível muda a intensidade dos critérios calibrados e a evidência esperada de uma mudança. O que cada nível exige se soma ao do nível abaixo.

### efêmera
Código com prazo de vida declarado — experimento, prova de conceito, carga de dados executada uma vez, funcionalidade atrás de flag a remover. Sem condição de remoção declarada (data ou evento), a área é `padrão`: código temporário sem data costuma ser permanente.
- **Testes:** o caminho principal e todo caminho que destrói ou corrompe dado (`QM-TS-6`); a cobertura não é lida (`QM-TS-4`).
- **Estrutura:** a mais simples que funciona; nenhuma abstração para reuso (`QM-CC-5`, `QM-MT-4`).
- **Observabilidade:** erros registrados com causa (`QM-EO-8`); métrica só se a pergunta do experimento a pede (`QM-EO-7`).
- **Robustez e eficiência:** o piso basta (`QM-RB-1`, `QM-RB-2`, `QM-EF-1`).
- **Documentação:** a condição de remoção, no código e no backlog (`QM-DO-3`).

### padrão
O nível de toda área não declarada: a régua plena dos critérios calibrados, julgada contra o contexto.
- **Testes:** todo resultado do que a mudança entrega e os caminhos de erro (`QM-TS-6`); caracterização do código sem testes que a mudança altera (`QM-TS-9`); cobertura das linhas alteradas lida como sinal (`QM-TS-4`).
- **Estrutura:** coesão, tipo de acoplamento e localidade pesados normalmente (`QM-CC-2`, `QM-CC-3`, `QM-RC-4`).
- **Observabilidade:** o comportamento novo tem um sinal em produção — métrica ou evento de log estruturado — que mostra que ele funciona (`QM-EO-7`).
- **Robustez:** idempotência onde há repetição (`QM-RB-3`); falha parcial e concorrência tratadas onde a mudança as cria (`QM-RB-4`, `QM-RB-5`); degradação para dependências não essenciais (`QM-RB-6`).
- **Eficiência:** o volume de produção considerado no acesso a dados (`QM-EF-3`).
- **Segurança:** eventos de autenticação e de autorização negada registrados (`QM-SR-9`).

### crítica
Áreas em que uma falha custa dinheiro, dado, segurança ou conformidade — pagamentos, identidade e acesso, dado pessoal sensível, núcleo regulatório — ou em que o código tem vida longa e muitos dependentes.
- **Testes:** caracterização antes de qualquer alteração em código sem testes (`QM-TS-9`); teste de mutação sobre o código alterado lido como sinal da força das asserções (`QM-TS-4`); testes de autorização negativa e de falha de cada dependência (`QM-TS-6`).
- **Observabilidade:** métrica e alerta para cada meta não funcional e para os caminhos de erro (`QM-EO-7`); correlação de ponta a ponta (`QM-EO-8`).
- **Robustez:** toda escrita declara seu comportamento sob falha parcial e sob concorrência (`QM-RB-4`, `QM-RB-5`); dependências isoladas (`QM-RB-6`).
- **Eficiência:** meta de desempenho declarada e medida antes do merge (`QM-EF-2`).
- **Segurança:** trilha de auditoria de toda alteração de dado sensível e de privilégio (`QM-SR-9`); privilégio mínimo e defesa em profundidade escritos no plano (`QM-SR-5`, `QM-SR-6`); a revisão inclui o responsável de segurança que o projeto declara.

---

## IDs aposentados e reclassificados

Mantidos aqui porque artefatos anteriores os citam. O registro do motivo é o PR de governança.

- **QM-SR-7** — aposentado. A robustez saiu da lente de segurança, que passou a guardar só o adversarial, e virou a lente RB: timeouts e limites de repetição em `QM-RB-1`, idempotência em `QM-RB-3`, degradação em `QM-RB-6`. O crescimento ilimitado passou a `QM-EF-1`.
- **QM-TS-4** — reclassificado de [NON-NEGOTIABLE] para [CALIBRATED]. Proibir um gate de cobertura é regra de processo, não propriedade do código; o critério passou a dizer como a cobertura é lida.

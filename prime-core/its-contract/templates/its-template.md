# ITS Template

Canonical template owned by prime-core/its-contract. The architect writes it; the developer implements from it; code review validates against it. See the its-contract SKILL.md for level-of-detail, writing rules, traceability, and ITS-vs-ADR boundary rules.

**Language.** The block below is the artifact and is written in the project's document language (`docs/prime-config.md` › Document repository; default `pt-BR`); the guidance around it is skill-facing and stays in English. Section titles are translated; the stable tokens declared by prime-core/prime-config — `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`, `ITS-<story-id>`, `S-NNN`, `QM-XX-N`, `CS-XX-N`, ADR status values (`Proposed`, `Accepted`, `Superseded by ADR-NNN`), use case status values (`Draft`, `Reviewed`), file paths and identifiers — are never translated.

Formatting constraints (from the contract's writing rules): maximum 3 heading levels, 2 list-nesting levels, simple tables (no multi-line cells, no embedded HTML), simple non-nested code fences, no diagrams. The document must survive copy-paste into the company's documentation platform as-is.

```markdown
# ITS-<story-id> — [Título da story]

## Metadados
- **Story:** <id — resumo em uma linha — link resolvível para o item no tracker>
- **Casos de uso afetados:** UC-NNN (criação|alteração), ...
- **Snapshot de configuração:** stack + versões relevantes para este plano
- **ADRs referenciados:** ADR-NNN (status), ou "nenhum"
  [Decisões que sobrevivem à story vivem em ADRs e são apenas referenciadas aqui — ver a
  fronteira de decisão no contrato. ADRs com status Accepted são vinculantes para o implementador.]

## Sumário executivo
[3–5 linhas, linguagem de negócio, sem identificadores de código. O que a story muda, em
quais casos de uso, e o efeito observável para o usuário/sistema. Escreva esta seção POR
ÚLTIMO, depois de fechado o plano consolidado. É a porta de entrada para lideranças
técnicas e compliance — o teste do leitor frio se aplica aqui: compreensível sem abrir
nenhum outro documento.]

## Análise por caso de uso
### UC-NNN — [título] (criação | alteração)
[Abra com UMA frase de síntese em linguagem de comportamento — o que muda neste caso de uso,
legível por quem não implementa. Ex.: "Este caso de uso passa a validar o limite de crédito
antes de confirmar o pedido." A tabela abaixo carrega a precisão técnica.]
- **Delta:** [copiado da entrada de revisão do caso de uso referente a esta story; para criação, "documento inteiro"]
- **Mapeamento:** tabela de item de delta (ou passo do fluxo) → componente/arquivo → ação (criar | modificar | remover)
- **Pontos de regressão:** [apenas em cenário de alteração — comportamento inalterado que compartilha código com as mudanças]

## Plano consolidado
### Arquivos afetados
[Lista unificada entre todos os casos de uso: caminho, natureza da mudança, quais UC/itens de delta ela atende. Resolva sobreposições — uma entrada por arquivo.]
### Novos arquivos
### Alterações de esquema / migrações
### Ordem de implementação
[Sequência numerada com justificativa (dependências primeiro, etc.)]
### Estratégia de testes
[Testes derivados de cada critério de aceite tocado pelos deltas + testes de não regressão para cada ponto de regressão + áreas quentes. Referencie os comandos de verificação da configuração do projeto.]
### Fora de escopo — não alterar
[Uma linha por área intocável: componente/caminho, por que permanece inalterada, e a
cobertura de não regressão que a protege. Ex.: "Não modificar `PaymentService` — o fluxo de
estorno não é alterado por esta story, coberto pela suíte de não regressão de estorno."
Fronteiras nomeadas tornam "tudo isso e nada além disso" exigível para o implementador e
verificável para o revisor. Se nada estiver sob risco de alteração acidental, escreva
"nenhuma identificada".]
### Riscos e pontos de atenção
[Outros casos de uso servidos pelos componentes modificados; questões em aberto]

## Verificação de rastreabilidade
[Confirmação explícita, por seção de caso de uso: todo item de delta tem uma mudança
correspondente (ou uma justificativa de que o código existente já o cobre), e toda mudança
planejada referencia um item de delta ou é justificada como consequência técnica. Onde uma
mudança teve mais de um caminho viável, declare a alternativa descartada e o motivo decisivo
em uma linha. Além de liberar a entrega, esta seção é a evidência de auditoria do documento.]

## Glossário de referência
[Para leitores sem acesso ao repositório de documentos. Apenas metadados — resolva O QUE é
cada identificador, nunca copie O QUE o documento diz. Preencha a partir dos documentos já
carregados durante o planejamento; snapshot no momento da entrega. Qualifique RN/CA com seu
UC quando mais de um caso de uso for afetado.]

### Citados neste ITS
| ID | Tipo | Nome / glosa em uma linha |
|---|---|---|
| UC-NNN | Caso de uso | [campo Nome do documento] |
| UC-NNN/RN-N | Regra de negócio | [paráfrase em uma linha da intenção da regra] |
| UC-NNN/CA-N | Critério de aceite | [paráfrase em uma linha do que ele verifica] |
| ADR-NNN | Registro de decisão | [título] (Status) |

### Termos do processo
| Termo | Significado |
|---|---|
| ITS | Instrução de Trabalho de Software — este documento: o plano de implementação de uma story |
| UC | Caso de uso — a documentação viva de um comportamento do sistema |
| RN | Regra de negócio dentro de um caso de uso |
| CA | Critério de aceite dentro de um caso de uso |
| ADR | Architecture Decision Record — uma decisão que sobrevive à story |
| Delta | O conjunto de mudanças que uma story aplica a um caso de uso |
```
# ITS Template

Canonical template owned by prime-core/its-contract. The architect writes it; the developer implements from it; code review validates against it. See the its-contract SKILL.md for level-of-detail, writing rules, traceability, and ITS-vs-ADR boundary rules.

**Language.** The block below is the artifact and is written in the document language of this format: `pt-BR`; the guidance around it is skill-facing and stays in English. Section titles are translated; the stable tokens cited here — `UC-NNN`, `RN-N`, `CA-N`, `ADR-NNN`, `ITS-<story-id>`, `S-NNN`, `QM-XX-N`, `CS-XX-N`, ADR status values (`Proposed`, `Accepted`, `Superseded by ADR-NNN`), use case status values (`Draft`, `Reviewed`), file paths and identifiers — are never translated. Each token stays owned by the contract that declares it; this note only states that none of them is translated.

Formatting constraints (from the contract's writing rules): maximum 3 heading levels, 2 list-nesting levels, simple tables (no multi-line cells, no embedded HTML), simple non-nested code fences, no diagrams. The document must survive copy-paste into the company's documentation platform as-is.

````markdown
# ITS-<story-id> — [Título da story]

## Metadados
- **Story:** <id — resumo em uma linha — link resolvível para o item no tracker>
- **Casos de uso afetados:** UC-NNN (criação|alteração), ...
- **Snapshot de configuração:** stack + versões relevantes para este plano
- **ADRs referenciados:** ADR-NNN (status), ou "nenhum"
  [Decisões que sobrevivem à story vivem em ADRs e são apenas referenciadas aqui — ver a fronteira de decisão no contrato. ADRs com status Accepted são vinculantes para o implementador.]

### Verificação de rastreabilidade
[Escrita por último, junto com o sumário executivo. Evidência, não prosa: duas listas de identificadores e as linhas de alternativa descartada. Dirigida ao revisor e à auditoria — quem implementa não depende dela para trabalhar, e por isso ela não fica no corpo do documento. O exemplo abaixo é de uma story que afeta um único caso de uso; com mais de um, qualifique todo identificador aqui também: UC-NNN/D1, UC-NNN/RG-1.]

| Item de delta | Atendido por |
|---|---|
| D1 | unidade 3 |
| D2 | já coberto — [justificativa em uma linha] |

| Unidade | Justificativa |
|---|---|
| 1 | D1 |
| 4 | consequência técnica — [uma linha] |

- **Pontos de regressão:** RG-1 → unidade 3; RG-2 → unidade 5.
- **Alternativa descartada (unidade 3):** [caminho viável descartado e o motivo decisivo, em uma linha]
- **Fronteira de decisão:** nenhuma decisão arquitetural embutida neste documento.

## Sumário executivo
[3–5 linhas, linguagem de negócio, sem identificadores de código. O que a story muda, em quais casos de uso, e o efeito observável para o usuário/sistema. Escreva esta seção POR ÚLTIMO, depois de fechado o plano. É a porta de entrada para lideranças técnicas e compliance — o teste do leitor frio se aplica aqui.]

## O que muda no comportamento
[Uma subseção por caso de uso afetado. Só o que existe neste eixo: a síntese, o delta e o que
precisa continuar funcionando. O mapeamento para código vive uma vez, no plano. Com mais de um
caso de uso afetado, qualifique os identificadores: UC-NNN/D1, UC-NNN/RG-1.]

### UC-NNN — [Nome do caso de uso]
**Síntese:** [uma frase em linguagem de comportamento — o que o sistema passa a fazer de diferente neste caso de uso. Sem identificador de código.]

**Delta** [copiado da entrada de revisão do caso de uso referente a esta story; para criação, "documento inteiro" desdobrado em itens. Numere: os identificadores são citados pelas unidades do plano e pela verificação de rastreabilidade.]
- **D1:** [item adicionado/alterado/removido, referenciando passo, extensão ou seção]
- **D2:** ...

**Pontos de regressão** [apenas em cenário de alteração — comportamento inalterado que compartilha código com as mudanças. Cada ponto é reivindicado por exatamente uma unidade do plano.]
- **RG-1:** [comportamento que precisa continuar funcionando]

## Plano de implementação
[A espinha do documento, em ordem de execução. Quem implementa lê daqui até o fim e não
precisa sair do documento. Toda exigência citada é escrita na linha, com o identificador
como procedência.]

### 1. [Título da unidade]
**Arquivos:**
  1 - `caminho/Arquivo.java` (modificar)
  2 - `caminho/Novo.java` (criar)
  3 - ...
**O que fazer:** [instrução com a exigência em linha]
  1 - "rejeitar quando o total exceder o limite de crédito vigente (RN-3)"
  2 - ...
**Atende:** D1 · [ou: "consequência técnica — <uma linha>"]
**Testes:** [um por critério de aceite que os itens de delta desta unidade tocam, mais o teste de não regressão quando a unidade toca código compartilhado com um ponto de regressão]
  1 - "pedido acima do limite retorna erro de negócio sem persistir (CA-2)"
  2 - "pedido dentro do limite continua sendo confirmado (RG-1)"

### 2. [Título da unidade]
[...]

### Alterações de esquema / migrações
[Ordem relativa às unidades acima quando importar.]

### Fora de escopo — não alterar
[Uma linha por área intocável: componente/caminho, a razão escrita em linha, e a cobertura de
não regressão que a protege. Ex.: "Não modificar `PaymentService` — o fluxo de estorno depende
do estado atual (UC-051) e não é tocado por esta story; coberto pela suíte de não regressão de
estorno." Se nada estiver sob risco de alteração acidental, escreva "nenhuma identificada".]

### Riscos e pontos de atenção
[Outros casos de uso servidos pelos componentes modificados; questões em aberto.]

### Verificação
[Comandos de build e teste, da configuração do projeto.]

## Glossário de referência
[Para leitores sem acesso ao repositório de documentos. Apenas metadados — resolva O QUE é
cada identificador, nunca copie O QUE o documento diz. Preencha a partir dos documentos já
carregados durante o planejamento; snapshot no momento da entrega. Qualifique RN/CA com seu
UC quando mais de um caso de uso for afetado. Para ADR, a glosa vai até a Decisão — o que ficou
decidido. Contexto, Consequências e alternativas consideradas permanecem no ADR; copiá-los aqui
é a duplicação que o princípio de dono único proíbe.]

### Citados neste ITS
| ID | Tipo | Nome / glosa em uma linha |
|---|---|---|
| UC-NNN | Caso de uso | [campo Nome do documento] |
| RN-N | Regra de negócio | [paráfrase em uma linha da intenção da regra] |
| CA-N | Critério de aceite | [paráfrase em uma linha do que ele verifica] |
| ADR-NNN | Registro de decisão | [título] (Status) — decidiu-se: [paráfrase da Decisão em uma linha] |
| QM-XX-N · CS-XX-N | Critério de qualidade · slot de convenção | [nome no catálogo] ([NON-NEGOTIABLE] · [CALIBRATED] · INVARIANT · CONVENTIONAL) |

### Termos do processo
| Termo | Significado |
|---|---|
| ITS | Instrução de Trabalho de Software — este documento: o plano de implementação de uma story |
| UC | Caso de uso — a documentação viva de um comportamento do sistema |
| RN | Regra de negócio dentro de um caso de uso |
| CA | Critério de aceite dentro de um caso de uso |
| ADR | Architecture Decision Record — uma decisão que sobrevive à story |
| Delta | O conjunto de mudanças que uma story aplica a um caso de uso |
````
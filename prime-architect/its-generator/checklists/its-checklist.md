# ITS — conferência antes de entregar

A conferência do Passo 6 do `its-generator`, feita sobre o documento pronto. As regras são do `its-contract`; esta é a única lista que se executa. Ela confere o documento e não repete o processo: quando um item falha, volte ao passo que o produz e conserte o plano. Nenhum template vive aqui.

## 1. O que o script confere

Execute o script de conferência, `scripts/check-its.ps1`, no terminal do projeto (PowerShell; em outro shell, `pwsh -File`):

```powershell
& "<diretório desta skill>/scripts/check-its.ps1" -Its "<caminho da ITS>" -Root "<raiz do repositório do código>"
```

Ele só lê arquivos. Confere a estrutura do documento, as direções de rastreabilidade, os identificadores de outros documentos no corpo, a existência dos caminhos, tipos e membros citados e os arquivos que referenciam um tipo alterado.

- [ ] Todo `ERRO` corrigido, e o script executado de novo até não restar nenhum.
- [ ] Todo `AVISO` decidido:
  - `alcance` — um arquivo referencia um tipo que o plano altera e o documento não o cita. Abra o trecho que usa o tipo. Se o arquivo é afetado, ele ganha o destino da regra "Quem depende do que muda" (Passo 3). Se não é, siga.
  - `ancora` — um membro citado não existe no tipo. Se o plano o cria, falta a marca `(criar)`. Se não, o nome está errado: abra o tipo e corrija.
  - `delta->teste` — um item "já atendido hoje" não tem prova: nem um teste existente nomeado na linha, nem um teste de caracterização numa unidade. Nomeie o teste, ou planeje a unidade.
  - `teste` — um teste não diz o item ou o ponto de regressão que prova. Acrescente-o entre parênteses.
  - `hedge` — uma instrução hesita. Feche a decisão ou leve-a ao arquiteto.

**Sem o script** — formato Confluence, PowerShell indisponível ou execução negada —, confira à mão o que ele confere e diga isso na mensagem de entrega:

- [ ] Título, bloco Como implementar este documento e as três seções de nível 2 (Descrição, O que muda, Plano de implementação), nesta ordem; as subseções de fecho do plano (Entrega, Fora de escopo, Riscos e pontos de atenção, Verificação) são de nível 3.
- [ ] Premissas técnicas em lista, com a stack e as versões.
- [ ] Delta → plano: todo item `D` atendido por uma unidade, ou declarado "já atendido hoje" com o teste que o prova.
- [ ] Plano → delta: toda unidade com Atende — itens ou consequência técnica.
- [ ] Delta → teste: todo item `D` atendido citado por um teste da unidade; todo teste termina com o item ou o ponto de regressão que prova.
- [ ] Regressão → plano: todo `RG-N` reivindicado nos Testes de exatamente uma unidade.
- [ ] Nenhum `UC-`, `RN-`, `CA-`, `QM-`, `CS-` ou `ADR-` no documento.
- [ ] Âncoras: todo caminho marcado modificar ou remover existe; todo caminho marcado criar ainda não existe; todo tipo e todo membro sem a marca `(criar)` foi aberto nesta execução.

## 2. O que só o julgamento confere

- [ ] **Alcance.** Todo componente que o plano modifica ou remove teve as três buscas do Passo 3, e todo resultado afetado está no documento: ponto de regressão, teste existente a alterar, fronteira de fora de escopo ou risco com o efeito descrito.
- [ ] **Fonte.** Todo item `D` e todo ponto de regressão corresponde a um elemento que existe na fonte e diz o que o item diz. Nenhum nasceu de uma resposta dada em conversa, salvo dispensa explícita do arquiteto para um caso de borda: aí Riscos e pontos de atenção registra a decisão por extenso, a data e os itens que dependem dela, e diz que o caso de uso recebe a exigência antes do merge. Uma decisão técnica do plano não é item `D`.
- [ ] **Casos de borda.** Todo caso escrito remonta a um item, a um ponto de regressão ou a uma decisão de qualidade. Nenhum caso sem decisão ficou no plano.
- [ ] **Alternativa descartada.** Toda escolha real da inspeção está fechada: uma linha na unidade, com a razão decisiva, ou a restrição de um ADR `Accepted` escrita na unidade. Unidade sem escolha real não declara nada.
- [ ] **Decisão de arquitetura.** Nenhuma decisão que merece ADR tomada no corpo. Toda restrição de ADR escrita nas unidades vem de um ADR `Accepted` que muda ao menos uma instrução, sem o identificador. Nenhuma instrução contradiz um ADR `Accepted` nem repete o que o código já faz.
- [ ] **Fora de escopo.** Toda entrada diz por que é uma borda — compartilhado mas intocado, superfície de contrato não migrada, legado deixado em paz. Nenhuma duplica um ponto de regressão. Sem bordas, a seção diz "nenhuma identificada".
- [ ] **Qualidade.** Todo gatilho disparado tem decisão numa unidade, com valor concreto e o teste ou a medição que a prova. Todo afastamento de critério ou de slot está registrado por extenso, com a condição de saída, e sem o identificador. Nenhuma violação silenciosa de inegociável ou de slot INVARIANT.
- [ ] **Dependência.** Todo delta pendente de outra story tem a ordem de entrega presumida na linha Ordem de entrega, por extenso.
- [ ] **Nível.** Toda unidade tem os campos do nível pedido, e só eles. Nada do que é igual nos três níveis falta por o documento ser `simplificado` ou `médio`.
- [ ] **Proporção.** Cada unidade termina com a suíte verde e é revisável sozinha. Nenhum campo opcional vazio, nenhuma frase que repete outra, nenhuma explicação de conceito.
- [ ] **Entrega.** A subseção diz como a mudança é ativada e como é desfeita, mesmo que em uma linha.
- [ ] **Os seis testes pré-entrega** das Regras de escrita, sobre o documento pronto: implementador, leitor frio, colagem, autor, coerência, nível.

## 3. Fronteira

- [ ] A única escrita desta execução foi o arquivo da ITS: nenhum código, teste, caso de uso, status, ADR ou configuração foi alterado.
- [ ] Nada foi decidido em nome do arquiteto: as propostas foram apresentadas, não aplicadas.
- [ ] A mensagem de entrega segue a seção Saída do `SKILL.md`.

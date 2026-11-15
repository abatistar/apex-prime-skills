# Passo 2c — Modo conformidade ou reconciliação

Parte do `use-case-creator`, lida só quando o Passo 1 classifica um documento no modo conformidade ou reconciliação. Os passos citados abaixo — Passo 1, Passo 2a, Passo 2b, Passo 4 — são os do SKILL.md.

O código e o documento discordam — achado trazido pelo impact-mapping, pela feasibility-analysis, pelo code-review ou por uma story de correção.

1. Leia o documento **por inteiro** e só o trecho de código citado pela evidência da divergência. Se a divergência não cabe num trecho ancorado — o documento inteiro deixou de descrever o sistema —, reporte ao arquiteto em vez de remendar.
2. Confira se não é um delta pendente (formato, Ciclo de vida do status): o código diverge só nos itens do delta de uma story ainda não entregue e faz ali o que o documento descrevia antes dele. Nesse caso não há divergência a tratar — diga isso ao arquiteto, com o ID da story, e não registre nada. Reconciliar agora apagaria a mudança que a story planejou.
3. Apresente os dois lados — o que o documento afirma (com seus identificadores) e o que o código faz (arquivo e linha) — e deixe o arquiteto decidir qual está certo. Nunca decida por ele: a escolha define se haverá implementação.
4. **O código está errado → conformidade.** O corpo do documento não muda. Registre uma entrada de conformidade com o ID da story que corrigirá o código e o Resumo `Conformidade:` seguido dos identificadores que o código passa a cumprir (por exemplo, "Conformidade: o código passa a cumprir o passo 5 e o CA-3"). O Status não muda. Se ainda não há story, reporte que a correção precisa de uma; a entrada é registrada quando ela existir.
5. **O documento está errado → reconciliação.** Corrija o corpo para descrever o que o código faz, com as mesmas verificações dos itens 1–3 do Passo 2b. Registre uma entrada de reconciliação (`reconciliação com o código` na coluna Story; no Resumo, o que mudou, como numa alteração) e devolva o documento a `Draft` se estava `Reviewed`. Não há ITS: o código já faz isso.

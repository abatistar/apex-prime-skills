# Passo 2e — Modo retirada

Parte do `use-case-creator`, lida só quando o Passo 1 classifica um documento no modo retirada. Os passos citados abaixo — Passo 1, Passo 2a, Passo 2b, Passo 4 — são os do SKILL.md.

Uma story remove do sistema todo o comportamento que um documento descreve. Remover só parte dele é atualização (Passo 2b).

1. Leia o documento **por inteiro**. Ele parte de `Reviewed` (Passo 1): o corpo validado é exatamente o que o its-generator vai planejar remover.
2. Não altere o corpo — ele descreve o que sai do sistema. Registre uma entrada de retirada: ID da story, data e o Resumo `Retirada`. O Status passa a `Retired`, e o arquivo fica no mesmo caminho; nunca o apague.
3. Retire este documento do campo Casos de uso relacionados dos outros — atualização derivada, sem entrada e sem mudança de Status; o campo deste fica como está. Se o fluxo de outro documento depende deste (um «include», um passo que o aciona), aquele documento muda de comportamento: trate-o como atualização no mapeamento da mesma story (volte ao Passo 1).

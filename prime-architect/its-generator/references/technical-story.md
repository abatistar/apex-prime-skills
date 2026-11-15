# Story técnica

Parte do `its-generator`, lida só quando a story muda o código sem mudar o comportamento observável de nenhum ator: o avanço de uma migração, a atualização de uma dependência ou da stack, uma refatoração, a remoção de uma flag cujo comportamento já é o definitivo. Este arquivo diz o que muda nos Passos 1, 2 e 3; o resto do processo é o mesmo.

## No Passo 1 — a entrada

A story técnica não deixa entrada em caso de uso nenhum (use-case, Regras do Histórico de revisões) e entra só com a story.

Confirme com o arquiteto que nada observável muda antes de planejar: essa confirmação é o que dispensa o delta. Se ele discordar, algo observável muda, e o caso de uso muda primeiro, pelo use-case-creator.

Confirmada, as duas condições de parada do Passo 1 — status e seções — não se aplicam a ela. Os casos de uso só entram pela regressão, no Passo 4.

## No Passo 2 — o cenário técnico

Não há entrada a localizar nem caso de uso afetado: o delta é o resultado técnico que a story declara. Cada item `D` é esse resultado, verificável por uma checagem nomeada — o teste de arquitetura, a contagem da detecção de uma migração no escopo da story, a versão no arquivo de build, a ausência da flag no código e na configuração.

Todo o comportamento observável que passa pelo código alterado é regressão (Passo 4), porque a story promete deixá-lo intacto.

## No Passo 3 — a inspeção

1. Localize todo o código que a story altera, guiado pelo mapa de estrutura. Numa migração, são as ocorrências que a detecção dela encontra no escopo da story; numa atualização de dependência ou de stack, os usos da API que muda.
2. Para cada componente, identifique o comportamento que ele serve hoje e leve-o à varredura do Passo 4: todo ponto de regressão deste cenário vem de lá.
3. O comportamento que o código alterado serve e que nenhum caso de uso descreve não vira ponto de regressão sem fonte. A cobertura dele é a unidade de testes de caracterização do Passo 4.6, quando o código não tem testes. A lacuna de documentação entra em Riscos e pontos de atenção, com o use-case-extractor como rota.

As buscas de "Quem depende do que muda" e o fim da inspeção valem como em qualquer cenário.

## No documento

A seção O que muda tem uma subseção só, nomeada pelo resultado técnico: a frase de síntese declara que o comportamento observável não muda, e cada item `D` é o resultado técnico com a checagem que o prova (its-contract, O que muda).

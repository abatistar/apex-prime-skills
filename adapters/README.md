# Adapters

Configuração dos agentes por plataforma. Cada arquivo é o prompt de entrada que uma plataforma carrega; o processo em si vive nas skills, e um adapter roteia para elas em vez de repetir os procedimentos delas.

| Plataforma | Jarvis (Arquiteto) |
|---|---|
| Claude Code | `claude-code/jarvis.md` |
| Copilot | `copilot/jarvis.agent.md` |

## Os dois arquivos do Jarvis são cópias deliberadas

Nenhuma das plataformas consegue incluir um arquivo compartilhado, então o corpo do prompt do arquiteto existe duas vezes, literalmente. Essa duplicação é aceita, e é o único lugar deste repositório em que "referenciar, nunca duplicar" não se aplica — não há nada de onde referenciar.

O que decorre disso:

- **Uma mudança em um é uma mudança nos dois, no mesmo commit.** Toda linha de prosa precisa permanecer idêntica. Uma correção que cai em apenas um adapter é um fork silencioso, e a plataforma que a perdeu vai rotear de forma diferente da que a recebeu.
- **Somente o frontmatter, a linha de invocação e as linhas em branco ao redor delas podem diferir.** O Claude Code carrega `description` e fecha com a linha `$ARGUMENTS`; o Copilot carrega `name` e `description`, abre com um título `#` e não tem linha de argumentos. Tudo o que fica entre eles é o mesmo texto.
- **Verifique antes de commitar**, ignorando linhas em branco e a linha de invocação:

```bash
diff <(grep -v '^\s*$' adapters/claude-code/jarvis.md | grep -v '^Tarefa do arquiteto') <(grep -v '^\s*$' adapters/copilot/jarvis.agent.md | grep -v '^# Jarvis')
```

A saída esperada é a diferença de frontmatter e nada mais.

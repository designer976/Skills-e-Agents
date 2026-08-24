---
name: setup-project
description: Configura um projeto para usar os skills do plugin wa, injetando o bloco do Analista no CLAUDE.md local. Rodar uma vez por projeto. Invoque APENAS quando o usuario chamar /wa:setup-project explicitamente.
---

# Setup Project — Configuração de Agentes Globais

> **Identidade visual:** Enquanto este skill estiver rodando, inicie cada resposta com `⚙️ **Setup Project**`
> na primeira linha. Ao encerrar, pare de usar essa marca.

Você é o **Setup Project** — responsável por configurar o projeto atual para usar os agentes e skills globais automaticamente.

## Workflow

### Passo 1 — Localizar o CLAUDE.md do projeto

Procure o `CLAUDE.md` na raiz do projeto atual (working directory).

- Se existir → leia o conteúdo e vá para o Passo 2
- Se não existir → crie um novo com apenas o bloco do Analista e vá para o Passo 4

### Passo 2 — Verificar se o bloco já existe

Procure no conteúdo do `CLAUDE.md` por `## Skills do plugin wa`.

Se encontrar a versão antiga do bloco (`## Agente Analista (OBRIGATÓRIO)`, que mandava ativar
em cada prompt), **substitua-a** pelo bloco do Passo 3 — ela contradiz a regra de invocação
explícita.

- Se já existir → informe o usuário: "Projeto já configurado. Nenhuma alteração necessária."
- Se não existir → vá para o Passo 3

### Passo 3 — Injetar o bloco do Analista

Adicione o bloco abaixo **logo após a primeira linha** (`# CLAUDE.md` ou título equivalente) do arquivo existente:

```
## Skills do plugin wa

Os skills deste projeto rodam **somente quando chamados explicitamente**. Nunca ative um skill
por conta própria — nem ao detectar um pedido que "combina" com ele, nem ao terminar a
implementação de outro. Responda normalmente e, quando um skill for útil, **sugira o comando**.

| Sinal na solicitação | Comando a sugerir |
|----------------------|-------------------|
| Nova tela do zero sem spec | `/wa:all-agents` |
| Implementar + revisar com spec validada | `/wa:all-front-end` |
| Componente ou ajuste visual sem spec clara | `/wa:designer` |
| Implementação de UI com spec definida | `/wa:front-end-ui` |
| Endpoint, API, controller, service, DTO | `/wa:backend` |
| Schema, migração, model, query, índice | `/wa:database` |
| Testes unitários, integração ou E2E | `/wa:tester` |
| Revisão geral ou auditoria de qualidade | `/wa:reviewer` |
| Não sabe qual usar | `/wa:analista` |

Quando um skill terminar a tarefa, ele encerra e o Claude volta ao comportamento padrão.
```

### Passo 4 — Confirmar

Informe ao usuário:

```
⚙️ **Setup Project**
✅ CLAUDE.md atualizado com sucesso.
Skills disponíveis neste projeto: /wa:analista, /wa:all-agents, /wa:all-front-end, /wa:designer,
/wa:front-end-ui, /wa:backend, /wa:database, /wa:tester, /wa:reviewer
Nenhum skill roda sozinho — chame pelo comando quando precisar.
```

## Regras

- Nunca remover ou sobrescrever conteúdo existente no CLAUDE.md — apenas adicionar
- Sempre inserir o bloco no topo do arquivo, antes de qualquer outra seção
- Se o arquivo não tiver um título (`#`), criar o bloco como primeira seção

## Ciclo de Vida (OBRIGATORIO)

Este skill so roda quando o usuario o invoca explicitamente.

**Ao iniciar:** confirme que foi chamado de proposito. Se voce chegou aqui por conta propria,
sem o usuario ter digitado o comando, pare e devolva o controle sem executar nada.

**Enquanto roda:** faca apenas o que este skill cobre. Nao invoque outro skill por conta propria.
Quando outro skill for necessario, **sugira o comando ao usuario** e espere ele decidir.

**Ao terminar:** encerre. Entregue o resultado, informe qual comando o usuario pode chamar em
seguida, se houver, e **volte ao comportamento padrao do Claude**. Nao permaneca ativo, nao
assuma o proximo pedido do usuario e nao mantenha a identidade visual deste skill nas
respostas seguintes.

---
name: setup-project
description: Configura um projeto novo para usar os agentes e skills globais. Injeta o bloco do Analista no CLAUDE.md local, criando-o se não existir. Rodar uma vez por projeto.
---

# Setup Project — Configuração de Agentes Globais

> **Identidade visual:** Sempre inicie com `⚙️ **Setup Project**` na primeira linha da resposta.

Você é o **Setup Project** — responsável por configurar o projeto atual para usar os agentes e skills globais automaticamente.

## Workflow

### Passo 1 — Localizar o CLAUDE.md do projeto

Procure o `CLAUDE.md` na raiz do projeto atual (working directory).

- Se existir → leia o conteúdo e vá para o Passo 2
- Se não existir → crie um novo com apenas o bloco do Analista e vá para o Passo 4

### Passo 2 — Verificar se o bloco do Analista já existe

Procure no conteúdo do `CLAUDE.md` por `## Agente Analista`.

- Se já existir → informe o usuário: "Projeto já configurado. Nenhuma alteração necessária."
- Se não existir → vá para o Passo 3

### Passo 3 — Injetar o bloco do Analista

Adicione o bloco abaixo **logo após a primeira linha** (`# CLAUDE.md` ou título equivalente) do arquivo existente:

```
## Agente Analista (OBRIGATÓRIO)

Em CADA prompt que contenha uma solicitação de ajuste, criação ou implementação:

1. Exiba `🔍 **Analista**` na primeira linha da resposta
2. Classifique a tarefa e informe: "Detectei: [descrição] → Acionando: [skill]"
3. Use a ferramenta **Skill** para invocar o skill correspondente imediatamente

| Sinal na solicitação | Skill |
|----------------------|-------|
| Nova tela do zero sem spec | `all-agents` |
| Implementar + revisar com spec validada | `all-front-end` |
| Componente ou ajuste visual sem spec clara | `designer` |
| Implementação de UI com spec definida | `front-end-ui` |
| Endpoint, API, controller, service, DTO | `backend` |
| Schema, migração, model, query, índice | `database` |
| Testes unitários, integração ou E2E | `tester` |
| Revisão geral ou auditoria de qualidade | `reviewer` |

> Exceção: perguntas conceituais e explicações de código podem ser respondidas diretamente.
```

### Passo 4 — Confirmar

Informe ao usuário:

```
⚙️ **Setup Project**
✅ CLAUDE.md atualizado com sucesso.
Agentes configurados: Analista, Designer, Front-end-UI, Front-end-Code, Backend, Database, Tester, Reviewer
A partir do próximo prompt, o Analista estará ativo neste projeto.
```

## Regras

- Nunca remover ou sobrescrever conteúdo existente no CLAUDE.md — apenas adicionar
- Sempre inserir o bloco do Analista no topo do arquivo, antes de qualquer outra seção
- Se o arquivo não tiver um título (`#`), criar o bloco como primeira seção

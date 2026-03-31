# Skills & Agents — Claude Code

Skills globais para Claude Code com pipeline de agentes para desenvolvimento frontend, backend e banco de dados.

## Instalação

1. Copie as pastas de skills para `~/.claude/skills/`:

```bash
# Clone o repositório direto na pasta de skills
git clone https://github.com/designer976/Skills-e-Agents.git ~/.claude/skills
```

2. Adicione as regras de auto-ativação no seu `~/.claude/CLAUDE.md` (veja a seção abaixo).

## Skills disponíveis

| Skill | Descrição |
|-------|-----------|
| `designer` | Valida specs, garante consistência com Design System e planeja implementações |
| `front-end-ui` | Implementa componentes visuais e UI com tokens do Design System |
| `front-end-code` | Revisa código frontend: performance, TypeScript, acessibilidade |
| `all-agents` | Pipeline completo: Designer → Front-end-UI → Front-end-Code → Designer |
| `all-front-end` | Pipeline front-end: Front-end-UI → Front-end-Code |
| `backend` | Implementa APIs, endpoints, services, controllers, DTOs e autenticação |
| `database` | Schema, migrações, models, queries e índices de banco de dados |
| `tester` | Testes unitários, de integração e E2E |
| `reviewer` | Revisão geral de código e auditoria de qualidade |
| `project-rules` | Regras e convenções do projeto (adaptar para cada projeto) |

## Regras de auto-ativação (CLAUDE.md)

Adicione ao seu `~/.claude/CLAUDE.md` para ativar os skills automaticamente:

```markdown
## Skills Front-end (Auto-ativação obrigatória)

| Situação detectada | Skill a invocar |
|--------------------|----------------|
| Usuário pede novo componente, tela ou ajuste visual sem spec clara | `designer` |
| Usuário pede implementação de UI com spec já definida | `front-end-ui` |
| Usuário pede nova tela do zero sem nenhuma spec | `all-agents` |
| Usuário pede implementar + revisar com spec já validada | `all-front-end` |

## Skills Backend/Infra (Auto-ativação com gate de permissão)

| Situação detectada | Skill a invocar |
|--------------------|----------------|
| Usuário pede endpoint, API, controller, service, DTO ou autenticação | `backend` |
| Usuário pede schema, migração, model, query ou índice de banco | `database` |
| Usuário pede testes unitários, integração ou E2E | `tester` |
| Usuário pede revisão geral de código ou auditoria de qualidade | `reviewer` |
```

## Uso manual

```
/designer     - Agente de design
/front-end-ui - Implementação visual
/backend      - Implementação de API
/database     - Banco de dados
/tester       - Testes
/reviewer     - Revisão de código
/all-agents   - Pipeline completo
```

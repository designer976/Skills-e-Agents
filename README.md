# Skills & Agents — Claude Code

Skills globais para Claude Code com pipeline de agentes para desenvolvimento frontend, backend e banco de dados.

## Instalação

```bash
# Clone o repositório direto na pasta .claude
git clone https://github.com/designer976/Skills-e-Agents.git ~/.claude
```

Em seguida, abra qualquer projeto e rode `/setup-project` para configurar o Analista automaticamente.

## Como funciona

Todo prompt passa pelo **Analista** (`🔍`), que classifica a tarefa e delega ao skill correto. Você não precisa invocar os skills manualmente — o Analista faz isso.

```
Usuário faz solicitação
       ↓
   🔍 Analista (classifica)
       ↓
   skill correto (executa)
       ↓
   🔄 Ralph-Loop (itera até aprovação, se necessário)
```

## Skills disponíveis

| Skill | Emoji | Descrição |
|-------|-------|-----------|
| `analista` | 🔍 | Orquestrador central — classifica e delega ao skill correto |
| `setup-project` | ⚙️ | Configura um projeto novo para usar os agentes globais |
| `atualizar-skill-agent` | 🔄 | Sincroniza os skills com a versão mais recente do GitHub |
| `designer` | 🟣 | Valida specs, garante consistência com Design System e planeja implementações |
| `front-end-ui` | 🔵 | Implementa componentes visuais e UI com tokens do Design System |
| `front-end-code` | 🟢 | Revisa código frontend: performance, TypeScript, acessibilidade |
| `all-agents` | — | Pipeline completo: Designer → Front-end-UI → Front-end-Code → Designer |
| `all-front-end` | — | Pipeline front-end: Front-end-UI → Front-end-Code |
| `backend` | 🟠 | Implementa APIs, endpoints, services, controllers, DTOs e autenticação |
| `database` | 🗄️ | Schema, migrações, models, queries e índices de banco de dados |
| `tester` | 🧪 | Testes unitários, de integração e E2E |
| `reviewer` | 🔍 | Revisão geral de código e auditoria de qualidade |
| `project-rules` | — | Regras e convenções do projeto (adaptar para cada projeto) |

## Ralph-Loop — iteração automática

Os skills integram o plugin `ralph-loop`, que itera automaticamente quando encontra falhas:

| Skill | Trigger | Promise |
|-------|---------|---------|
| `designer` | Inconsistências visuais após implementação | `DESIGNER APROVADO` |
| `front-end-ui` | Tokens proibidos / estados ausentes | `FRONT-END-UI APROVADO` |
| `front-end-code` | Itens 🔴 Críticos na revisão | `FRONT-END-CODE APROVADO` |
| `backend` | Falhas em build / lint / test | `BACKEND APROVADO` |
| `tester` | Testes falhando no ciclo TDD | `TESTES APROVADOS` |
| `reviewer` | Vulnerabilidades 🔴 Críticas | `REVISAO APROVADA` |
| `database` | ❌ Sem loop — para e aguarda instrução manual (risco de perda de dados) | — |

Requer o plugin `ralph-loop@claude-plugins-official` habilitado em `settings.json`.

## Configuração por projeto

Ao criar um projeto novo, rode uma vez:

```
/setup-project
```

Isso injeta automaticamente o bloco do Analista no `CLAUDE.md` local do projeto.

## Manter skills atualizados

Para sincronizar os skills com a versão mais recente do GitHub:

```
/atualizar-skill-agent
```

Após atualizar, abra uma nova conversa para carregar os skills atualizados.

## CLAUDE.md global

O `CLAUDE.md` na raiz deste repositório já contém as regras de auto-ativação do Analista. Ele é carregado automaticamente pelo Claude Code em toda conversa.

## Uso manual

Caso queira invocar um skill diretamente:

```
/analista              - Orquestrador central
/setup-project         - Configurar projeto novo
/atualizar-skill-agent - Sincronizar skills com GitHub
/designer              - Agente de design
/front-end-ui          - Implementação visual
/front-end-code        - Revisão de código frontend
/backend               - Implementação de API
/database              - Banco de dados
/tester                - Testes
/reviewer              - Revisão de código
/all-agents            - Pipeline completo
/all-front-end         - Pipeline front-end
```

## Plugins necessários

Habilitar em `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "ralph-loop@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true
  }
}
```

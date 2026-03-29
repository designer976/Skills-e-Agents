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

### Frontend / Visual

| Skill | Descrição |
|-------|-----------|
| `designer` | Valida specs, garante consistência com Design System e planeja implementações |
| `front-end-ui` | Implementa componentes visuais e UI com tokens do Design System |
| `front-end-code` | Revisa código frontend: performance, TypeScript, acessibilidade |
| `all-agents` | Pipeline completo: Designer → Front-end-UI → Front-end-Code → Designer |
| `all-front-end` | Pipeline front-end: Front-end-UI → Front-end-Code |

### Backend / Infra

| Skill | Descrição |
|-------|-----------|
| `backend` | Implementa APIs, endpoints, services, controllers, DTOs e autenticação |
| `database` | Schema, migrações, models, queries e índices de banco de dados |
| `tester` | Testes unitários, de integração e E2E |
| `reviewer` | Revisão geral de código e auditoria de qualidade |

### Segurança / Performance

| Skill | Descrição |
|-------|-----------|
| `security-reviewer` | Auditoria OWASP Top 10 + extras (timing attack, mass assignment, JWT, supply chain). Nunca corrige — só reporta e aciona `security-fixer` |
| `security-fixer` | Corrige vulnerabilidades identificadas com fix patterns completos. Debate Gate obrigatório quando escopo > 3 arquivos ou múltiplas camadas |
| `pagespeed` | Auditoria Pareto-first de Core Web Vitals / Lighthouse. Debate Gate quando > 5 componentes ou impacto visual |

### Utilitários

| Skill | Descrição |
|-------|-----------|
| `project-rules` | Regras e convenções do projeto (adaptar para cada projeto) |
| `analista` | Ponto de entrada central — interpreta e delega ao skill correto |

## Regras de auto-ativação (CLAUDE.md)

O Analista classifica cada solicitação e aciona o skill correto automaticamente. Tabela completa:

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
| Revisão de segurança, vulnerabilidades, OWASP | `security-reviewer` |
| Corrigir vulnerabilidades já identificadas | `security-fixer` |
| PageSpeed, Lighthouse score, Core Web Vitals | `pagespeed` |

## Uso manual

```
/designer          - Agente de design
/front-end-ui      - Implementação visual
/backend           - Implementação de API
/database          - Banco de dados
/tester            - Testes
/reviewer          - Revisão de código
/all-agents        - Pipeline completo
/security-reviewer - Auditoria de segurança (OWASP)
/security-fixer    - Correção de vulnerabilidades
/pagespeed         - Otimização de performance / Lighthouse
```

## Debate Gate

Os skills `security-reviewer`, `security-fixer` e `pagespeed` possuem um **Debate Gate** integrado:
quando o escopo de mudanças excede um threshold (arquivos > N, múltiplas camadas, impacto visual),
o agente pausa e apresenta 3 opções ao usuário antes de prosseguir. A aprovação antecipada
("pode fazer tudo") **não** bypassa o gate.

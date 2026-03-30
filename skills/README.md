# Skills & Agents — Claude Code

Skills globais para Claude Code com pipeline de agentes para desenvolvimento frontend, backend, banco de dados, segurança, performance, SEO e conteúdo.

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
| `designer-ux` | Auditoria de UX (Nielsen), acessibilidade WCAG 2.2, design de interação (estados, animações, timing) e fundamentos visuais |
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
| `seo-manager` | Auditoria de SEO técnico (meta tags, structured data, sitemap, robots.txt) e de conteúdo (keywords, topic clusters). Coordena com `pagespeed`, `front-end-ui` e `redator` |
| `redator` | Copywriting para landing pages, pricing, e-mails e UX writing (labels, tooltips, erros). Nunca escreve sem briefing de brand voice, persona e diferenciais |

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
| UX audit, acessibilidade, animações, estados, hierarquia visual | `designer-ux` |
| Implementação de UI com spec definida | `front-end-ui` |
| Endpoint, API, controller, service, DTO | `backend` |
| Schema, migração, model, query, índice | `database` |
| Testes unitários, integração ou E2E | `tester` |
| Revisão geral ou auditoria de qualidade | `reviewer` |
| Revisão de segurança, vulnerabilidades, OWASP | `security-reviewer` |
| Corrigir vulnerabilidades já identificadas | `security-fixer` |
| PageSpeed, Lighthouse score, Core Web Vitals | `pagespeed` |
| SEO, ranqueamento, meta tags, structured data, sitemap, GSC | `seo-manager` |
| Copy de landing page, pricing, e-mails, textos de UI, UX writing | `redator` |

## Uso manual

```
/designer          - Agente de design
/designer-ux       - Auditoria de UX, acessibilidade WCAG e interação
/front-end-ui      - Implementação visual
/backend           - Implementação de API
/database          - Banco de dados
/tester            - Testes
/reviewer          - Revisão de código
/all-agents        - Pipeline completo
/security-reviewer - Auditoria de segurança (OWASP)
/security-fixer    - Correção de vulnerabilidades
/pagespeed         - Otimização de performance / Lighthouse
/seo-manager       - SEO técnico e de conteúdo
/redator           - Copywriting e UX writing
```

## Debate Gate

Os skills abaixo possuem um **Debate Gate** integrado: quando o escopo excede um threshold,
o agente pausa, apresenta 3 opções e aguarda escolha explícita antes de prosseguir.
A aprovação antecipada ("pode fazer tudo") **não** bypassa o gate.

| Skill | Threshold de ativação |
|-------|----------------------|
| `security-reviewer` | > 5 arquivos afetados ou mudanças arquiteturais |
| `security-fixer` | > 3 arquivos ou > 1 camada (backend + frontend) |
| `pagespeed` | > 5 componentes ou qualquer impacto visual |
| `seo-manager` | Reestruturação de URL ou > 5 páginas com mudanças técnicas |
| `redator` | > 3 tipos de entrega simultâneos → propõe sequência faseada |
| `designer-ux` | > 4 páginas/componentes afetados ou mudanças em componentes base |

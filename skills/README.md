# Skills & Agents — Claude Code

Skills globais para Claude Code com pipeline de agentes para desenvolvimento frontend, backend, banco de dados, segurança, performance, SEO e conteúdo.

## ⚙️ Skills Corrigidos - Zero Alucinação (100% Complete)

**Problema identificado:** Skills anteriormente faziam **assumptions falsas** sobre ferramentas disponíveis e usavam workflows over-engineered.

**Solução aplicada:** Systematic debugging com 5 princípios implementados em TODOS os skills:

### 🔍 **1. Validation-First Approach**
- Skills checam disponibilidade de ferramentas antes de usar
- Auto-detect platform/stack ao invés de assumir  
- Graceful degradation quando ferramentas específicas não existem

### ⚡ **2. Simple-by-Default Workflows**  
- Operações simples = processos simples
- Workflows complexos apenas quando realmente necessário
- Complexity-aware: detecta automaticamente nível necessário

### 🎯 **3. Actionable Instructions**
- Comandos específicos que realmente funcionam
- Specs concretas para implementação
- Evita consultoria genérica, foca em ação

### 🛡️ **4. Resilient Operations**
- Funciona mesmo sem ferramentas ideais
- Fallback strategies para cenários reais
- Never fail completely due to missing dependencies

### 🔄 **5. Consistent Patterns**
- Gate de Permissão padronizado em todos os skills
- Mesmo sistema de níveis (🟢 🟡 🔴)
- Predictable behavior across skills

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
| `designer` | Valida specs, garante consistência com Design System, planeja implementações. **FIXED:** Complexity-aware workflows, no tool dependencies, graceful validation |
| `designer-ux` | Auditoria de UX (Nielsen), acessibilidade WCAG 2.2, design de interação (estados, animações, timing) e fundamentos visuais |
| `front-end-ui` | Implementa componentes visuais e UI com tokens do Design System |
| `front-end-code` | Revisa código frontend: performance, TypeScript, acessibilidade |
| `all-agents` | Pipeline completo: Designer → Front-end-UI → Front-end-Code → Designer |
| `all-front-end` | Pipeline front-end: Front-end-UI → Front-end-Code |

### Projeto & DevOps

| Skill | Descrição |
|-------|-----------|
| `project-manager` | Tech stack selection, project inception. **FIXED:** Simple-by-default approach, optional Business Canvas, context-aware complexity |
| `github-integrator` | Git/GitHub workflows seguros. **FIXED:** Tool validation, graceful CLI fallbacks, flexible commit standards, proportional safety |
| `devops` | CI/CD, production deployment, monitoring setup. **FIXED:** Platform auto-detection, environment-aware checklists, no static tables |

### Backend / Infra

| Skill | Descrição |
|-------|-----------|
| `backend` | Implementa APIs, endpoints, services, controllers, DTOs e autenticação |
| `database` | Schema, migrações, models, queries e índices de banco de dados. **FIXED:** Tool validation, proportional safety, graceful degradation when tools unavailable |
| `tester` | Testes unitários, de integração e E2E |
| `reviewer` | Revisão geral de código e auditoria de qualidade. **Enhanced:** GitHub integration, PR workflows, EnterWorktree para mudanças arriscadas |

### Segurança / Performance

| Skill | Descrição |
|-------|-----------|
| `security-reviewer` | Auditoria OWASP Top 10 + extras (timing attack, mass assignment, JWT, supply chain). Nunca corrige — só reporta e aciona `security-fixer` **FIXED:** Tool validation, graceful degradation when npm audit unavailable |
| `security-fixer` | Corrige vulnerabilidades identificadas com fix patterns completos. Debate Gate obrigatório quando escopo > 3 arquivos ou múltiplas camadas **FIXED:** Tool validation, manual verification when tsc/lint unavailable |
| `pagespeed` | Auditoria Pareto-first de Core Web Vitals / Lighthouse. Debate Gate quando > 5 componentes ou impacto visual **FIXED:** Tool validation, graceful degradation when build tools unavailable |
| `seo-manager` | Auditoria de SEO técnico (meta tags, structured data, sitemap, robots.txt) e de conteúdo (keywords, topic clusters). Coordena com `pagespeed`, `front-end-ui` e `redator` **FIXED:** File validation strategy, graceful handling of missing files |
| `redator` | Copywriting para landing pages, pricing, e-mails e UX writing (labels, tooltips, erros). Nunca escreve sem briefing de brand voice, persona e diferenciais **✅ NO ISSUES** - No external tool dependencies, briefing-focused approach |

### Utilitários

| Skill | Descrição |
|-------|-----------|
| `project-rules` | Regras e convenções do projeto (adaptar para cada projeto) |
| `analista` | Ponto de entrada central — interpreta e delega ao skill correto |

## Regras de auto-ativação (CLAUDE.md)

O Analista classifica cada solicitação e aciona o skill correto automaticamente. Tabela completa:

| Sinal na solicitação | Skill |
|----------------------|-------|
| **Projeto & Setup** |  |
| Setup novo projeto, escolha de stack, "criar/construir do zero" | `project-manager` |
| Deploy produção, CI/CD, configurar hosting | `devops` |
| PR, Git workflows, branch operations | `github-integrator` |
| **Frontend/Visual** |  |
| Nova tela do zero sem spec | `all-agents` |
| Implementar + revisar com spec validada | `all-front-end` |
| Componente ou ajuste visual sem spec clara | `designer` |
| UX audit, acessibilidade, animações, estados, hierarquia visual | `designer-ux` |
| Implementação de UI com spec definida | `front-end-ui` |
| **Backend/Infra** |  |
| Endpoint, API, controller, service, DTO | `backend` |
| Schema, migração, model, query, índice | `database` |
| Testes unitários, integração ou E2E | `tester` |
| Revisão geral ou auditoria de qualidade | `reviewer` |
| **Segurança/Performance** |  |
| Revisão de segurança, vulnerabilidades, OWASP | `security-reviewer` |
| Corrigir vulnerabilidades já identificadas | `security-fixer` |
| PageSpeed, Lighthouse score, Core Web Vitals | `pagespeed` |
| SEO, ranqueamento, meta tags, structured data, sitemap, GSC | `seo-manager` |
| Copy de landing page, pricing, e-mails, textos de UI, UX writing | `redator` |

## Uso manual

```
# Projeto & Setup
/project-manager   - Setup de projeto, Business Canvas, escolha de stack
/github-integrator - Git workflows seguros, PR management
/devops            - CI/CD, production deployment, monitoring

# Frontend / Visual
/designer          - Agente de design (Enhanced: visual references, Pencil)
/designer-ux       - Auditoria de UX, acessibilidade WCAG e interação
/front-end-ui      - Implementação visual
/all-agents        - Pipeline completo
/all-front-end     - Pipeline frontend

# Backend / Infra
/backend           - Implementação de API
/database          - Banco de dados (Enhanced: safety layer, worktrees)
/tester            - Testes
/reviewer          - Revisão de código (Enhanced: GitHub integration)

# Segurança / Performance
/security-reviewer - Auditoria de segurança (OWASP)
/security-fixer    - Correção de vulnerabilidades
/pagespeed         - Otimização de performance / Lighthouse
/seo-manager       - SEO técnico e de conteúdo
/redator           - Copywriting e UX writing
```

## Safety Gates & Protection Mechanisms

Os skills possuem diferentes níveis de proteção para prevenir ações arriscadas:

### Debate Gate (Escopo Elevado)
Quando o escopo excede um threshold, o agente pausa e apresenta opções antes de prosseguir:

| Skill | Threshold de ativação |
|-------|----------------------|
| `security-reviewer` | > 5 arquivos afetados ou mudanças arquiteturais |
| `security-fixer` | > 3 arquivos ou > 1 camada (backend + frontend) |
| `pagespeed` | > 5 componentes ou qualquer impacto visual |
| `seo-manager` | Reestruturação de URL ou > 5 páginas com mudanças técnicas |
| `redator` | > 3 tipos de entrega simultâneos → propõe sequência faseada |
| `designer-ux` | > 4 páginas/componentes afetados ou mudanças em componentes base |

### Permission Gate (Operações Críticas)
Confirmação obrigatória antes de executar:

| Skill | Protection Level |
|-------|------------------|
| `database` | 🔴 **EnterWorktree obrigatório** para DROP, ALTER destrutivos. Confirmação "CONFIRMO DESTRUIÇÃO" |
| `github-integrator` | 🔴 **Bloqueia push direto para main**. Força PR workflow sempre |
| `devops` | 🔴 **Production Readiness Checklist** obrigatório antes de deploy produção |
| `project-manager` | 🟡 **Business Canvas obrigatório** antes de sugestões de tech stack |
| `reviewer` | 🟡 **EnterWorktree recomendado** para mudanças arriscadas ou refactoring grande |

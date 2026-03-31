# Skills & Agents — Claude Code

Skills globais para Claude Code com pipeline de agentes para desenvolvimento completo: inception de projeto, design, frontend, backend, banco de dados, segurança, performance, SEO, DevOps e conteúdo.

## Por que este modelo é diferente?

### 🛡️ **Safety-First vs Speed-First**
**Agentes tradicionais:** Focam em automação rápida - "como posso te ajudar a ir mais rápido?"
**Nosso modelo:** Força disciplina engenharia mesmo quando "atrapalha" - bloqueia push direto para main, exige Business Canvas, resiste a shortcuts sob pressão.

### 🎭 **Especialização Profissional Real**
**Multi-agent systems atuais:** Agentes genéricos (research, writing, analysis)
**Nosso modelo:** Espelha equipe de desenvolvimento real com expertise específica:
- `project-manager` → Business Canvas obrigatório antes de tech
- `database` → EnterWorktree para operações destrutivas
- `devops` → Production Readiness Checklist
- `github-integrator` → Bloqueia workflows perigosos

### 🔄 **TDD Aplicado à Documentação**
**Únicos que conhecemos:** RED-GREEN-REFACTOR para criar skills:
- **RED**: Testar pressure scenarios, capturar racionalizações típicas
- **GREEN**: Skills que resistem especificamente a esses shortcuts
- **REFACTOR**: Plugar novos buracos encontrados em testing

### 🚨 **Pressure Resistance Sistemática**
**Agentes comuns:** "Ok, como você quiser" quando usuário tem pressa
**Nosso modelo:** Tabelas de rationalization resistance:

```
"É emergência" → "Emergências causam bugs. PR leva 2 min."
"É só uma linha" → "Bugs pequenos quebram sistemas grandes."
"Já testei local" → "Local ≠ produção. CI/CD exists for a reason."
```

### 🧠 **Context-Aware Auto-Delegation**
**Diferencial:** Analista que detecta tipo de tarefa e aciona especialista correto automaticamente:

```
"fazer login" → `all-agents` (nova tela sem spec)
"query lenta" → `database` (performance)
"deploy produção" → `devops` (deployment)
```

### 🔗 **Safety-Aware Handoffs**
**Inovação:** Handoffs baseados em risco e completude real:
```
Database change completo → `reviewer` audita qualidade
Review aprovado → `devops` faz Production Readiness
Schema breaking → `backend` alinha mudanças
```

### 🏢 **Business-First Architecture**
**Outros:** Assumem tech stack ou perguntam preferência técnica
**Nosso:** `project-manager` FORÇA investigação de negócio antes de sugerir qualquer tecnologia.

---

**Resultado:** Como ter uma **equipe sênior virtual** que se auto-organiza, cada um expert na sua área, com safety protocols que não permitem ser quebrados mesmo sob pressão.

**Most agents:** "How can I help you go faster?"
**Our agents:** "How can I help you go safely and avoid shortcuts you'll regret?"

## ⚙️ Status: Zero Alucinação (100% Complete)

**Systematic debugging aplicado em TODOS os 13 skills principais:**

✅ **Validation-First Approach** — Check tool availability before use  
✅ **Simple-by-Default Workflows** — Complexity-aware (🟢🟡🔴)  
✅ **Actionable Instructions** — Specific, not generic consultancy  
✅ **Resilient Operations** — Graceful degradation when tools missing  
✅ **Consistent Patterns** — Uniform gate and workflow patterns  
✅ **Scope Creep Protection** — "STICK TO SCOPE" rule prevents improvements beyond what was asked

**Antes (hallucination + scope creep):** Assumiam ferramentas sempre disponíveis + faziam "melhorias" não solicitadas  
**Depois (zero hallucination + disciplined scope):** `npm run build 2>/dev/null || echo "Manual verification needed"` + Don't add features/refactor/comments beyond what was asked

Todos os skills agora funcionam em qualquer ambiente, fazendo apenas o que foi explicitamente solicitado.

## Instalação

```bash
# Clone o repositório direto na pasta .claude
git clone https://github.com/designer976/Skills-e-Agents.git ~/.claude
```

Em seguida, abra qualquer projeto e rode `/setup-project` para configurar o Analista automaticamente.

## Como funciona

### Ativação Manual de Agentes

Os agentes são ativados **apenas** quando explicitamente chamados:

```
Você chama explicitamente:  /analista  ou  /designer  ou  /backend
                                    ↓
       🔍 Analista — classifica e delega (se /analista) 
                         ou
       Skill específico ativado — lê arquivos e analisa
                                    ↓
       Gate de permissão — "detectei X, vou fazer Y. Posso prosseguir?"
                                    ↓
                            Você aprova
                                    ↓
       Para cada arquivo editado → mostra o diff → você aprova
                                    ↓
       🔄 Ralph-Loop — itera automaticamente se encontrar falhas
```

**Controle total:** Agentes só rodam quando você decide. Use `/inactive-agents` para desabilitar completamente.

## Permissões e segurança

O `settings.json` global define três camadas de proteção:

| Camada | Configuração | Efeito |
|--------|-------------|--------|
| Aprovação por arquivo | `defaultMode: acceptEdits` | Mostra diff e pede aprovação antes de salvar cada arquivo |
| Aviso de bypass | `skipDangerousModePermissionPrompt` removido | Restaura o aviso se alguém tentar desativar permissões |
| Comandos bloqueados | `deny` | Bloqueia permanentemente comandos destrutivos de banco |

**Comandos bloqueados permanentemente:**
- `prisma migrate reset` / `prisma db push --force-reset`
- `DROP TABLE`, `DELETE FROM`, `TRUNCATE`

## Skills disponíveis

| Skill | Emoji | Descrição |
|-------|-------|-----------|
| **Core & Controle** | | |
| `analista` | 🔍 | Classifica tarefa e aciona skill apropriado (ativação manual apenas) |
| `inactive-agents` | 🚫 | **NEW:** Desativa sistema de agentes temporariamente, permite respostas diretas do Claude |
| `setup-project` | ⚙️ | Configura um projeto novo para usar os agentes globais |
| `atualizar-skill-agent` | 🔄 | Sincroniza os skills com a versão mais recente do GitHub |
| **Projeto & Setup** | | |
| `project-manager` | 📋 | **NEW:** Business Canvas obrigatório, tech stack selection, inception de projeto. Força investigação de negócio ANTES de sugerir tecnologia |
| `github-integrator` | 🔗 | **NEW:** Git workflows seguros, bloqueia push direto para main, commits semânticos obrigatórios |
| `devops` | 🚀 | **NEW:** CI/CD, production deployment, monitoring setup. Production Readiness Checklist obrigatório |
| **Design & Frontend** | | |
| `designer` | 🟣 | Valida specs, DS consistency, planeja implementações. **Enhanced:** Visual references (Awwwards), Pencil integration |
| `designer-ux` | 🎨 | Auditoria UX (Nielsen), acessibilidade WCAG 2.2, design de interação e fundamentos visuais |
| `front-end-ui` | 🔵 | Implementa componentes visuais e UI com tokens do Design System |
| `front-end-code` | 🟢 | Revisa código frontend: performance, TypeScript, acessibilidade |
| `all-agents` | — | Pipeline completo: Designer → Front-end-UI → Front-end-Code → Designer |
| `all-front-end` | — | Pipeline front-end: Front-end-UI → Front-end-Code |
| **Backend & Database** | | |
| `backend` | 🟠 | Implementa APIs, endpoints, services, controllers, DTOs e autenticação |
| `database` | 🗄️ | Schema, migrações, models, queries e índices. **Enhanced:** EnterWorktree obrigatório para operações destrutivas |
| `tester` | 🧪 | Testes unitários, de integração e E2E |
| `reviewer` | 🔍 | Revisão geral de código e auditoria de qualidade. **Enhanced:** GitHub PR integration, EnterWorktree safety |
| **Segurança & Performance** | | |
| `security-reviewer` | 🛡️ | Auditoria OWASP Top 10 + extras. Nunca corrige — só reporta e aciona `security-fixer` |
| `security-fixer` | 🔧 | Corrige vulnerabilidades com fix patterns completos. Debate Gate obrigatório |
| `pagespeed` | ⚡ | Auditoria Pareto-first de Core Web Vitals / Lighthouse. Debate Gate quando > 5 componentes |
| `seo-manager` | 📈 | SEO técnico (meta tags, JSON-LD, sitemap) e de conteúdo (keywords, topic clusters) |
| `redator` | ✍️ | Copywriting para landing pages, pricing, e-mails e UX writing. Nunca escreve sem briefing |
| `project-rules` | — | Regras e convenções do projeto (adaptar para cada projeto) |

## Safety Gates & Protection Mechanisms

Os skills possuem diferentes níveis de proteção para prevenir ações arriscadas:

### 🔴 Permission Gates (Operações Críticas)
Confirmação obrigatória antes de executar:

| Skill | Protection Level | Trigger |
|-------|------------------|---------|
| `database` | 🔴 **EnterWorktree obrigatório** | DROP, ALTER destrutivos → "CONFIRMO DESTRUIÇÃO" |
| `github-integrator` | 🔴 **Bloqueia push direto** | git push origin main → força PR workflow |
| `devops` | 🔴 **Production Readiness** | Deploy produção → checklist obrigatório |
| `project-manager` | 🟡 **Business Canvas** | Sugestão tech → investigação negócio primeiro |

### 🔄 Debate Gates (Escopo Elevado)
Pausa e apresenta opções quando escopo excede threshold:

| Skill | Threshold | Ação |
|-------|-----------|------|
| `security-reviewer` | > 5 arquivos ou mudanças arquiteturais | 3 opções antes de prosseguir |
| `security-fixer` | > 3 arquivos ou múltiplas camadas | Sequência faseada |
| `pagespeed` | > 5 componentes ou impacto visual | Priorização manual |
| `designer-ux` | > 4 páginas ou componentes base | Escopo reduzido ou fases |

### 🛡️ Pressure Resistance
Todos os skills têm tabelas de rationalization resistance para prevenir shortcuts sob pressão.

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

Isso configura o projeto para usar os agentes via `CLAUDE.md` local.

**Modo de uso:**
- **Manual:** Chame `/analista` ou skills específicos quando precisar
- **Desativar:** Use `/inactive-agents` para respostas diretas do Claude

## Manter skills e plugins atualizados

### Skills
Para sincronizar os skills com a versão mais recente do GitHub:

```
/atualizar-skill-agent
```

### Plugins
Para atualizar plugins que fornecem funcionalidades aos skills:

```bash
# Verificar plugins instalados e versões
/plugin list

# Atualizar plugin específico
/plugin update github@claude-plugins-official

# Atualizar todos os plugins
/plugin update

# Verificar se há updates disponíveis
/plugin check-updates
```

### Automação
Configure atualizações automáticas:

```bash
# Skills: a cada 7 dias
/loop 7d /atualizar-skill-agent

# Plugins: a cada 30 dias
/loop 30d /plugin update
```

**Após atualizar skills ou plugins, abra uma nova conversa para carregar as versões atualizadas.**

## CLAUDE.md global

O `CLAUDE.md` na raiz deste repositório já contém as regras de auto-ativação do Analista. Ele é carregado automaticamente pelo Claude Code em toda conversa.

## Uso manual

Caso queira invocar um skill diretamente:

```
# Core & Controle
/analista              - Classifica tarefa e aciona skill apropriado
/inactive-agents       - Desativa sistema de agentes temporariamente
/setup-project         - Configurar projeto novo
/atualizar-skill-agent - Sincronizar skills com GitHub

# Projeto & Setup
/project-manager       - Setup projeto, Business Canvas, tech selection
/github-integrator     - Git workflows seguros, PR management
/devops                - CI/CD, production deployment, monitoring

# Design & Frontend
/designer              - Agente de design (Enhanced: visual refs, Pencil)
/designer-ux           - Auditoria de UX, acessibilidade WCAG e interação
/front-end-ui          - Implementação visual
/front-end-code        - Revisão de código frontend
/all-agents            - Pipeline completo
/all-front-end         - Pipeline front-end

# Backend & Database
/backend               - Implementação de API
/database              - Banco de dados (Enhanced: safety layer)
/tester                - Testes
/reviewer              - Revisão de código (Enhanced: GitHub integration)

# Segurança & Performance
/security-reviewer     - Auditoria de segurança (OWASP)
/security-fixer        - Correção de vulnerabilidades
/pagespeed             - Otimização de performance / Lighthouse
/seo-manager           - SEO técnico e de conteúdo
/redator               - Copywriting e UX writing
```

## Plugins necessários

Habilitar em `~/.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "ralph-loop@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true,
    "github@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true
  },
  "autoUpdatesChannel": "latest"
}
```

### Plugin Functions

- **ralph-loop**: Iteração automática quando skills encontram falhas
- **superpowers**: TDD methodology, git worktrees, systematic debugging
- **github**: GitHub workflows, PR automation, integração com `github-integrator` skill
- **frontend-design**: Visual design tools, integração com `designer` skill

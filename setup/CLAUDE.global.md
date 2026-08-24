# Regras Globais — Claude Code

## Agentes e Skills — Ativação Manual APENAS

Os agentes são ativados **apenas** quando explicitamente chamados:

- **`/wa:analista`** → Classifica tarefa e aciona skill apropriado  
- **Skills individuais** → `/wa:designer`, `/wa:backend`, `/wa:database`, etc.
- **Pipelines** → `/wa:all-agents`, `/wa:all-front-end`

### Desativar Agentes
- **`/wa:inactive-agents`** → Desativa sistema de agentes temporariamente

---

## ⚠️ IMPORTANTE: SEM ATIVAÇÃO AUTOMÁTICA

**NÃO ative skills automaticamente.** 

**Responda diretamente** para:
- Perguntas conceituais ("Como funciona X?")
- Explicações de código ("O que faz esta função?") 
- Discussões técnicas ("Devo usar X ou Y?")
- Troubleshooting ("Por que este erro?")

**Use `/wa:analista` APENAS** quando explicitamente chamado pelo usuário.

### Ciclo de vida dos skills

Um skill roda **do momento em que é chamado até concluir a tarefa** — nada além disso.

- **Não ative por conta própria.** Nem ao detectar um pedido que "combina" com algum skill,
  nem ao terminar a implementação de outro. Quando um skill for útil, **sugira o comando**
  e espere o usuário decidir.
- **Ao concluir, o skill se desliga.** Entrega o resultado, indica o próximo comando se
  houver, e o Claude volta ao comportamento padrão.
- **A marca visual do skill (`🔍 **Analista**`, `🟠 **Backend**`, etc.) vale apenas enquanto
  ele estiver rodando.** Se ela aparecer numa resposta que não faz parte de um skill em
  execução, o skill não desligou como deveria.

---

## Tabela de Classificação (APENAS para quando `/wa:analista` for chamado)

### Projeto & Setup
| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Setup novo projeto, escolha de stack, "criar/construir do zero" | `/wa:project-manager` |
| Deploy produção, CI/CD, configurar hosting | `/wa:devops` |
| PR, Git workflows, branch operations | `/wa:github-integrator` |

### Frontend / Visual
| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Nova tela do zero sem nenhuma spec | `/wa:all-agents` |
| Implementar + revisar com spec já validada | `/wa:all-front-end` |
| Novo componente, tela ou ajuste visual sem spec clara | `/wa:designer` |
| UX audit, acessibilidade WCAG, animações, estados, hierarquia visual | `/wa:designer-ux` |
| Implementação de UI com spec já definida | `/wa:front-end-ui` |

### Backend / Infra
| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Endpoint, API, controller, service, DTO ou autenticação | `/wa:backend` |
| Schema, migração, model, query ou índice de banco | `/wa:database` |
| Testes unitários, integração ou E2E | `/wa:tester` |
| Revisão geral de código ou auditoria de qualidade | `/wa:reviewer` |

### Segurança / Performance
| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Revisão de segurança, auditoria de vulnerabilidades, OWASP | `/wa:security-reviewer` |
| Corrigir vulnerabilidades já identificadas | `/wa:security-fixer` |
| PageSpeed, Lighthouse score, Core Web Vitals, performance | `/wa:pagespeed` |
| SEO, ranqueamento, meta tags, structured data, sitemap, GSC | `/wa:seo-manager` |
| Copy de landing page, pricing, e-mails, textos de UI, UX writing | `/wa:redator` |

### Regras de desempate
- Sem spec → prefira `/wa:all-agents` sobre `/wa:designer`
- Implementar + revisar → prefira `/wa:all-front-end` sobre `/wa:front-end-ui`
- Solicitação mista (ex: endpoint + tela) → invoque `/wa:backend` primeiro, depois o skill visual
- Ajuste visual pequeno com spec clara → `/wa:front-end-ui` direto

---

## Origem dos Skills

Os skills vêm do plugin `wa`, instalado do marketplace privado `wa-skills`
(repositório `designer976/wa-skills`). **Não** edite `~/.claude/plugins/cache/` —
é sobrescrito a cada update.

- Atualizar: `/wa:atualizar-skill-agent` ou `claude plugin update wa@wa-skills`
- Instalar em outra máquina: `claude plugin marketplace add designer976/wa-skills` e `claude plugin install wa@wa-skills`

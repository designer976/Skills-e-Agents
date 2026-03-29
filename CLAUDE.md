# Regras Globais — Claude Code

## Analista — Ponto de Entrada Obrigatório

Em CADA prompt que contenha uma solicitação de ajuste, criação ou implementação:

1. Exiba `🔍 **Analista**` na primeira linha da resposta
2. Classifique a tarefa usando a tabela abaixo
3. Informe: "Detectei: [descrição] → Acionando: [skill]"
4. Use a ferramenta **Skill** para invocar o skill correspondente imediatamente

> **Exceção:** perguntas conceituais puras, explicações de código e dúvidas arquiteturais
> podem ser respondidas diretamente, sem exibir o Analista.

---

## Tabela de Classificação (Analista)

### Frontend / Visual

| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Nova tela do zero sem nenhuma spec | `all-agents` |
| Implementar + revisar com spec já validada | `all-front-end` |
| Novo componente, tela ou ajuste visual sem spec clara | `designer` |
| Implementação de UI com spec já definida | `front-end-ui` |

### Backend / Infra

| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Endpoint, API, controller, service, DTO ou autenticação | `backend` |
| Schema, migração, model, query ou índice de banco | `database` |
| Testes unitários, integração ou E2E | `tester` |
| Revisão geral de código ou auditoria de qualidade | `reviewer` |

### Segurança / Performance

| Sinal na solicitação | Skill a invocar |
|----------------------|----------------|
| Revisão de segurança, auditoria de vulnerabilidades, OWASP | `security-reviewer` |
| Corrigir vulnerabilidades já identificadas | `security-fixer` |
| PageSpeed, Lighthouse score, Core Web Vitals, performance | `pagespeed` |
| SEO, ranqueamento, meta tags, structured data, sitemap, GSC | `seo-manager` |
| Copy de landing page, pricing, e-mails, textos de UI, UX writing | `redator` |

### Regras de desempate

- Sem spec → prefira `all-agents` sobre `designer`
- Implementar + revisar → prefira `all-front-end` sobre `front-end-ui`
- Solicitação mista (ex: endpoint + tela) → invoque `backend` primeiro, depois o skill visual
- Ajuste visual pequeno com spec clara → `front-end-ui` direto

> Nota: NÃO invocar `front-end-code` diretamente — o skill `front-end-ui`
> já encadeia para ele automaticamente ao finalizar qualquer implementação.

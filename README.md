# WA Skills & Agents — Plugin para Claude Code

Pipeline de agentes da WA Project distribuído como plugin do Claude Code.

| | |
|---|---|
| **Versão** | 1.2.0 |
| **Skills** | 24 |
| **Última atualização** | 24/08/2026 |
| **Última verificação** | 24/08/2026 |

*Atualização* é a data do último commit que mudou uma skill. *Verificação* é a data em que o
update automático rodou pela última vez e confirmou que a versão instalada bate com a publicada
— ela avança toda segunda mesmo quando nada muda. Ambas são carimbadas automaticamente na
descrição do repositório por `setup/atualizar-plugin-wa.ps1`.

## Instalar

```bash
claude plugin marketplace add designer976/wa-skills
```

```bash
claude plugin install wa@wa-skills
```

Reinicie o Claude Code depois de instalar.

## Atualizar

```bash
claude plugin update wa@wa-skills
```

Ou use a própria skill: `/wa:atualizar-skill-agent`.

### Atualização automática (Windows)

`setup/atualizar-plugin-wa.ps1` roda o update e carimba as datas na descrição deste repositório.
Para agendá-lo toda segunda às 09:00, copie o script para `~/.claude/scripts/` e registre a tarefa:

```powershell
$acao = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$env:USERPROFILE\.claude\scripts\atualizar-plugin-wa.ps1`""
$gatilho = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 09:00
$config = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 15)
Register-ScheduledTask -TaskName "Claude - Atualizar plugin wa" -Action $acao -Trigger $gatilho -Settings $config
```

`-StartWhenAvailable` faz a tarefa rodar assim que possível se a máquina estiver desligada às segundas 09:00.
O log fica em `~/.claude/backups/plugin-update.log`.

A descrição deste repositório no GitHub é atualizada pelo script a cada execução, no formato:
`... | vX.Y.Z | atualizado em DD/MM/AAAA | verificado em DD/MM/AAAA` — *atualizado* é a data do último
commit aqui, *verificado* é a data em que o script rodou pela última vez.

## Uso

As skills são invocadas com o prefixo do plugin — e **somente assim**.

Nenhum skill se ativa sozinho: não ao detectar um pedido que combina com ele, não ao terminar
a execução de outro. Quando um skill for útil, o Claude **sugere o comando** e espera você decidir.
Ao concluir a tarefa, o skill encerra e o Claude volta ao comportamento padrão.

| Skill | O que faz | Última atualização | Item atualizado |
|---|---|---|---|
| `/wa:analista` | Classifica a tarefa e aciona o skill apropriado | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` dizia "ativo em todo prompt"; tabelas de classificação com prefixo `wa:` |
| `/wa:all-agents` | Pipeline completo: designer, front-end-ui, front-end-code, designer | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar ao detectar feature visual sem spec |
| `/wa:all-front-end` | Implementação + revisão de código front-end | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:designer` | Valida specs e planeja implementação visual | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar ao detectar mudança visual sem spec |
| `/wa:designer-ux` | Auditoria de UX, acessibilidade WCAG e interação | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:audit-ui` | Audita a UI implementada contra o Design System - tokens, componente canônico, consistência, estados, responsividade | 24/08/2026 | skill nova |
| `/wa:front-end-ui` | Implementa UI com tokens do Design System | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:front-end-code` | Revisa código front-end sem alterar o visual | 24/08/2026 | invocação explicita e encerramento ao concluir; `references/` via `${CLAUDE_PLUGIN_ROOT}`; `description` mandava ativar automaticamente após implementação |
| `/wa:backend` | Endpoints, services, controllers, DTOs, autenticação | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:database` | Schema, migrações, models, queries, índices | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:tester` | Testes unitários, de integração e E2E | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar ao detectar código sem cobertura |
| `/wa:reviewer` | Revisão geral de código e auditoria de qualidade | 24/08/2026 | invocação explicita e encerramento ao concluir; `references/` via `${CLAUDE_PLUGIN_ROOT}` |
| `/wa:security-reviewer` | Auditoria de segurança e vulnerabilidades (OWASP) | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar ao fim da implementação de outros skills |
| `/wa:security-fixer` | Corrige vulnerabilidades já identificadas | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:devops` | Deploy, CI/CD, hosting | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:github-integrator` | PRs, branches, workflows de Git | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:pagespeed` | Lighthouse, Core Web Vitals, performance | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:seo-manager` | SEO, meta tags, structured data, sitemap, GSC | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:redator` | Copy de landing pages, e-mails, UX writing | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:project-manager` | Setup de projeto novo e escolha de stack | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:project-rules` | Convenções obrigatórias do projeto | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar sempre que um agente precisasse de contexto |
| `/wa:setup-project` | Configura um projeto para usar os agentes | 24/08/2026 | invocação explicita e encerramento ao concluir; bloco injetado no CLAUDE.md dos projetos reescrito — mandava ativar em cada prompt |
| `/wa:inactive-agents` | Desativa o sistema de agentes temporariamente | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:atualizar-skill-agent` | Sincroniza as skills com este repositório | 24/08/2026 | invocação explicita e encerramento ao concluir; workflow migrado de `git pull` para `claude plugin update`; aponta para o repo `wa-skills` |

> Todas as 23 skills mudaram em **24/08/2026**, na migração para plugin. A partir daqui o histórico por skill fica no git deste repositório: `git log -- wa/skills/<nome>` dá a resposta exata.

## Estrutura

```
.claude-plugin/marketplace.json   # manifesto do marketplace
wa/
  .claude-plugin/plugin.json      # manifesto do plugin
  skills/                         # 24 skills
  references/                     # material compartilhado entre skills
docs/                             # auditorias
setup/CLAUDE.global.md            # ~/CLAUDE.md de referencia, com os comandos /wa:
setup/atualizar-plugin-wa.ps1     # script do update semanal agendado
```

Para replicar as regras globais numa máquina nova, copie `setup/CLAUDE.global.md` para `~/CLAUDE.md` depois de instalar o plugin.

## Historico

- [`docs/AUDITORIA-2026-08-24.md`](docs/AUDITORIA-2026-08-24.md) — auditoria das 23 skills e o incidente que motivou a migração do repositório público `Skills-e-Agents` para esta árvore limpa.

## Contribuir

Edite os arquivos neste repositório — nunca em `~/.claude/plugins/cache/`, que é sobrescrito a cada update.

Suba o campo `version` em `wa/.claude-plugin/plugin.json` a cada mudança, senão o `claude plugin update` não detecta a atualização.

Valide antes de commitar:

```bash
claude plugin validate . && claude plugin validate ./wa
```

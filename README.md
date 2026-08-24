# WA Skills & Agents — Plugin para Claude Code

Pipeline de agentes da WA Project distribuído como plugin do Claude Code.

| | |
|---|---|
| **Versão** | 1.4.0 |
| **Skills** | 26 |
| **Última atualização** | 24/08/2026 |
| **Última verificação** | 24/08/2026 |

*Atualização* é a data do último commit que mudou uma skill. *Verificação* é a data em que o
update automático rodou pela última vez e confirmou que a versão instalada bate com a publicada
— ela avança toda segunda mesmo quando nada muda. Ambas são carimbadas automaticamente na
descrição do repositório por `setup/atualizar-plugin-wa.ps1`.

## Instalar

Uma linha deixa a máquina pronta — marketplace, plugin e atualização automática semanal:

```powershell
powershell -ExecutionPolicy Bypass -File "setup/instalar.ps1"
```

| Opção | Para quê |
|---|---|
| `-Dia Friday` | Muda o dia da atualização automática (padrão: `Monday`) |
| `-Hora 14:30` | Muda o horário (padrão: `09:00`) |
| `-SemAgendamento` | Instala o plugin sem criar a tarefa agendada |
| `-Remover` | Desinstala o plugin e remove a tarefa |

O instalador é idempotente: rodar de novo atualiza em vez de duplicar. Reinicie o Claude Code
depois — a instalação baixa os arquivos, mas os comandos só aparecem no restart.

**Na mão**, se preferir:

```bash
claude plugin marketplace add designer976/wa-skills && claude plugin install wa@wa-skills
```

## Atualizar

Sob demanda, a qualquer momento:

```bash
claude plugin update wa@wa-skills
```

Ou pela skill: `/wa:atualizar-skill-agent`, que compara as versões e mostra o que mudou antes
de aplicar.

### Atualização automática (Windows)

São dois processos com públicos diferentes. **Quem só usa as skills precisa apenas do primeiro.**

#### Segunda, 09:00 — para quem usa

`setup/atualizar-plugin-wa.ps1` puxa a versão publicada e deixa a máquina em dia. É tudo que
alguém que clonou este repositório precisa: o trabalho de decidir o que muda já foi feito na
sexta pelo mantenedor, e aqui só se herda o resultado.

```powershell
$dir = "$env:USERPROFILE\.claude\scripts"
$acao = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$dir\atualizar-plugin-wa.ps1`""
$gatilho = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At 09:00
$config = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 20)
Register-ScheduledTask -TaskName "Claude - Atualizar plugin wa" -Action $acao -Trigger $gatilho -Settings $config
```

O script termina depois do update em qualquer máquina que não seja a do mantenedor — a parte
que carimba a descrição do repositório é pulada, porque escreve no GitHub.

#### Sexta, 09:00 — só para o mantenedor

`setup/verificar-skills-wa.ps1` faz a análise externa: verifica se as skills continuam válidas
e se os plugins dos quais elas dependem mudaram. **Não altera nenhuma skill** — quando encontra
divergência, abre uma issue neste repositório. É a partir dela que o mantenedor decide o que
ajustar e publica, para que a distribuição de segunda entregue o resultado.

| Check | O que detecta |
|---|---|
| Manifestos e frontmatter | YAML quebrado que faria a skill carregar com metadata vazia e sumir da lista |
| Versão de `superpowers` | `references/debugging.md` e `verification.md` são destilados dele — se subir de versão, o material derivado pode estar defasado |
| Flags do `/ralph-loop` | `front-end-code` e `reviewer` mandam rodar com `--max-iterations` e `--completion-promise`; se a interface mudar, apontam para algo que não existe |
| Skills-fonte do `superpowers` | `systematic-debugging` e `verification-before-completion` ainda existem com esses nomes |
| Plugins novos no marketplace oficial | Algum plugin novo pode cobrir lacuna nossa |

```powershell
$dir = "$env:USERPROFILE\.claude\scripts"
$acao = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$dir\verificar-skills-wa.ps1`""
$gatilho = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 09:00
$config = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 20)
Register-ScheduledTask -TaskName "Claude - Verificar skills wa" -Action $acao -Trigger $gatilho -Settings $config
```

O script tem uma guarda: se o `gh` não estiver autenticado como o mantenedor, ele encerra sem
fazer nada. Sem isso, uma cópia rodando em outra máquina abriria issues em repositório alheio.

O estado da semana anterior fica em `~/.claude/backups/wa-baseline.json`, com as versões **e os
commits** das dependências — é o commit que permite mostrar na issue exatamente quais arquivos
mudaram na fonte, em vez de apenas dizer que a versão subiu. Sem divergência, o script não abre
nada: o log registra e encerra em silêncio. Ambos escrevem em `~/.claude/backups/plugin-update.log`.

O que a verificação **não** faz é julgar se o nosso material derivado ficou desatualizado —
isso exige leitura e comparação. Esse trabalho é conduzido por `/wa:manter-skills`, que investiga
os itens da issue, propõe as edições para aprovação, sobe a versão, valida, publica e fecha a
issue. O ciclo completo fica assim:

```
sexta    verificacao roda e abre issue se algo mudou
   |
   v
         mantenedor chama /wa:manter-skills, aprova as edicoes, publica
   |
   v
segunda  quem instalou o plugin recebe a versao nova
```

`-StartWhenAvailable` faz a tarefa rodar assim que possível se a máquina estiver desligada no horário.

## Uso

As skills são invocadas com o prefixo do plugin — e **somente assim**.

Nenhum skill se ativa sozinho: não ao detectar um pedido que combina com ele, não ao terminar
a execução de outro. Quando um skill for útil, o Claude **sugere o comando** e espera você decidir.
Ao concluir a tarefa, o skill encerra e o Claude volta ao comportamento padrão.

| Skill | O que faz | Última atualização | Item atualizado |
|---|---|---|---|
| `/wa:analista` | Classifica a tarefa e aciona o skill apropriado | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` dizia "ativo em todo prompt"; tabelas de classificação com prefixo `wa:` |
| `/wa:all-agents` | Pipeline completo: designer, front-end-ui, front-end-code, designer | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar ao detectar feature visual sem spec; passo de diagrama antes/depois |
| `/wa:all-front-end` | Implementação + revisão de código front-end | 24/08/2026 | invocação explicita e encerramento ao concluir; passo de diagrama antes/depois |
| `/wa:designer` | Valida specs e planeja implementação visual | 24/08/2026 | invocação explicita e encerramento ao concluir; `description` mandava ativar ao detectar mudança visual sem spec; passo de diagrama antes/depois |
| `/wa:designer-ux` | Auditoria de UX, acessibilidade WCAG e interação | 24/08/2026 | invocação explicita e encerramento ao concluir |
| `/wa:audit-ui` | Audita a UI implementada contra o Design System - tokens, componente canônico, consistência, estados, responsividade | 24/08/2026 | skill nova; passo de diagrama antes/depois |
| `/wa:diagrama` | Gera diagramas Mermaid do codigo real - fluxo, ER, arvore de componentes, navegacao, sequencia - e comparacao antes/depois | 24/08/2026 | skill nova |
| `/wa:manter-skills` | Fluxo do mantenedor - investiga a issue de verificacao semanal, propoe as edicoes, sobe versao, publica e fecha a issue | 24/08/2026 | skill nova |
| `/wa:front-end-ui` | Implementa UI com tokens do Design System | 24/08/2026 | invocação explicita e encerramento ao concluir; passo de diagrama antes/depois |
| `/wa:front-end-code` | Revisa código front-end sem alterar o visual | 24/08/2026 | invocação explicita e encerramento ao concluir; `references/` via `${CLAUDE_PLUGIN_ROOT}`; `description` mandava ativar automaticamente após implementação |
| `/wa:backend` | Endpoints, services, controllers, DTOs, autenticação | 24/08/2026 | invocação explicita e encerramento ao concluir; passo de diagrama antes/depois |
| `/wa:database` | Schema, migrações, models, queries, índices | 24/08/2026 | invocação explicita e encerramento ao concluir; passo de diagrama antes/depois |
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
| `/wa:atualizar-skill-agent` | Sincroniza as skills com este repositório | 24/08/2026 | invocação explicita e encerramento ao concluir; workflow migrado de `git pull` para `claude plugin update`; aponta para o repo `wa-skills`; passo de instalacao via setup/instalar.ps1 e checagem do agendamento |

> Todas as 23 skills mudaram em **24/08/2026**, na migração para plugin. A partir daqui o histórico por skill fica no git deste repositório: `git log -- wa/skills/<nome>` dá a resposta exata.

## Estrutura

```
.claude-plugin/marketplace.json   # manifesto do marketplace
wa/
  .claude-plugin/plugin.json      # manifesto do plugin
  skills/                         # 26 skills
  references/                     # material compartilhado entre skills
docs/                             # auditorias
setup/instalar.ps1                # instalador: plugin + agendamento, em uma linha
setup/CLAUDE.global.md            # ~/CLAUDE.md de referencia, com os comandos /wa:
setup/atualizar-plugin-wa.ps1     # update semanal (segunda) - para quem usa
setup/verificar-skills-wa.ps1     # verificacao externa (sexta) - do mantenedor
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

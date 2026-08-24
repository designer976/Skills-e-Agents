# CLAUDE.md — Skills e Agentes globais da WA

Esta pasta é a **cópia de trabalho** do plugin `wa`: as skills e agentes que o Charles usa em
todos os projetos da WA. Uma sessão aberta aqui é uma sessão de **manutenção do plugin**, não
de desenvolvimento de produto.

## O que é este repositório

| | |
|---|---|
| Repositório | `designer976/wa-skills` (privado) |
| Espelho público | `designer976/Skills-e-Agents` |
| Plugin | `wa`, instalado do marketplace `wa-skills` |
| Comandos | `/wa:analista`, `/wa:designer`, `/wa:backend`, … |

```
wa/skills/                  as skills
wa/references/              material compartilhado entre skills
wa/.claude-plugin/          plugin.json — e aqui que sobe a versao
.claude-plugin/             marketplace.json
setup/                      instalador e scripts agendados
docs/                       auditorias
```

## Regras que não podem ser quebradas

**1. Editar aqui, nunca em `~/.claude/plugins/cache/`.** O cache é sobrescrito a cada
`claude plugin update` — qualquer edição lá se perde sem aviso.

**2. Toda mudança de skill exige subir a `version`** em `wa/.claude-plugin/plugin.json`. O
`claude plugin update` compara o campo `version`, não o conteúdo dos arquivos. Sem bump, a
mudança fica no GitHub e nunca chega em nenhuma máquina — inclusive na do próprio Charles.

**3. Validar antes de commitar:**

```bash
claude plugin validate . && claude plugin validate ./wa
```

Não é formalidade. Um `:` cru dentro de `description:` quebra o YAML, e a skill passa a carregar
com metadata vazia — ela **some da lista sem gerar erro nenhum**. Já aconteceu com 4 skills de
uma vez, e só foi pego porque a validação rodou antes do push.

**4. Skills não se auto-ativam.** Cada SKILL.md tem uma seção `## Ciclo de Vida` que exige
invocação explícita e encerramento ao concluir a tarefa. Ao criar ou editar qualquer skill,
mantenha essa seção e a exigência de invocação explícita na `description`. Handoffs **sugerem**
o comando seguinte; não invocam a skill. A única exceção é o `analista`, orquestrador declarado
no `~/CLAUDE.md`.

## O que atualiza sozinho e o que não

| | Atualiza sozinho? |
|---|---|
| Plugin `wa` | Sim — segunda, para quem instalou |
| Plugins externos (`superpowers`, `frontend-design`, `ralph-loop`) | Sim — segunda, junto com o `wa`. São arquivos de terceiros, não editamos nada neles |
| `wa/references/*.md` | **Não.** São síntese adaptada da fonte, não cópia. Reescrever automaticamente apagaria a adaptação. Só mudam por `/wa:manter-skills`, com aprovação |
| `wa/skills/*.md` | **Não.** São autorais |

## O ciclo semanal

```
Sexta 09:00   verificar-skills-wa.ps1 roda, compara com o baseline
              e abre issue se algo mudou nas dependencias
                          |
                          v
              voce chama /wa:manter-skills nesta pasta:
              investiga, propoe, voce aprova, publica e fecha a issue
                          |
                          v
Segunda 09:00 atualizar-plugin-wa.ps1 distribui a versao nova
              para quem instalou o plugin
```

A verificação de sexta é **do mantenedor** — o script tem uma guarda e só roda se o `gh`
estiver autenticado como `designer976`. A de segunda é para quem apenas consome, e é a única
mencionada no README.

### O que a verificação de sexta checa

| Check | O que detecta |
|---|---|
| Manifestos e frontmatter | YAML quebrado que faria a skill carregar com metadata vazia e sumir da lista |
| Versão das dependências | `superpowers`, `frontend-design`, `ralph-loop`, `supabase`, `vercel` contra a semana anterior |
| **Commit** das dependências | Sinal mais fino que a versão: pega upstream que publicou mudança sem subir o número. A issue já vem com o `gh api .../compare/<antes>...<agora>` pronto |
| Flags do `/ralph-loop` | `front-end-code` e `reviewer` mandam rodar com `--max-iterations` e `--completion-promise`; se a interface mudar, apontam para algo que não existe |
| Skills-fonte dos destilados | `systematic-debugging` e `verification-before-completion` ainda existem com esses nomes |
| Plugins novos no marketplace oficial | Os 286 plugins, comparados com a semana anterior |
| `obra/superpowers` | Upstream do plugin, consultado direto no GitHub: commits novos e skills que entraram ou saíram |
| `anthropics/skills` | Repositório oficial da Anthropic (19 skills). Skill nova costuma indicar padrão que vale adotar; skill removida significa que uma fonte deixou de existir |

Baseline em `~/.claude/backups/wa-baseline.json`. Sem divergência, não abre issue nenhuma.

O script **atualiza o índice do marketplace antes de comparar**. Sem isso a comparação rodaria contra o `marketplace.json` que a tarefa de segunda baixou, e tudo publicado de terça a quinta passaria despercebido até a semana seguinte.

As três listas de dependência (`$DEPS`, `$COMANDOS`, `$FONTES`) são **declaradas à mão** no script. Skill nova que passe a depender de algo externo precisa entrar ali — senão a dependência nasce fora do radar.

### Registrar a tarefa de sexta numa máquina nova

O `setup/instalar.ps1` **não** cria esta tarefa — ela é só do mantenedor. Copie
`setup/verificar-skills-wa.ps1` para `~/.claude/scripts/` e registre:

```powershell
$dir = "$env:USERPROFILE\.claude\scripts"
$nome = "Claude - Verificar skills wa"
$acao = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$dir\verificar-skills-wa.ps1`""
$gatilho = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Friday -At 09:00
$config = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 20)
try { Unregister-ScheduledTask -TaskName $nome -Confirm:$false -ErrorAction Stop } catch {}
Register-ScheduledTask -TaskName $nome -Action $acao -Trigger $gatilho -Settings $config
```

O `Unregister` antes não é opcional: `Register-ScheduledTask` falha com *"Não é possível criar
um arquivo já existente"* quando o nome já existe.

## Para trabalhar aqui

**Manutenção a partir da issue de sexta:** `/wa:manter-skills` — investiga o que mudou nas
dependências, propõe as edições para aprovação, sobe versão, valida, publica e fecha a issue.

**Só atualizar a instalação local:** `/wa:atualizar-skill-agent`.

**Editar uma skill pontualmente**, sem passar por skill nenhuma: edite o arquivo, suba a versão,
valide, commit e push. Depois `claude plugin update wa@wa-skills` e reinicie o Claude Code.

## Armadilhas conhecidas

- **`ConvertFrom-Json` do PowerShell 5.1 não lê o `marketplace.json`** do marketplace oficial:
  o arquivo tem chaves duplicadas e o parser lança exceção em vez de manter a última ocorrência.
  Os scripts usam python para isso.
- **Acento em caminho não sobrevive** à leitura de `.ps1` pelo PowerShell 5.1. Os scripts
  localizam esta pasta por varredura em vez de escrever "Área de Trabalho" literal.
- **Baixar a versão nova não basta:** o Claude Code só carrega as skills atualizadas depois de
  reiniciar o app.
- **Escrita no GitHub é só do mantenedor.** Abrir issue e carimbar a descrição do repositório
  ficam atrás de uma checagem de `gh api user`. Sem isso, uma cópia rodando em outra máquina
  abriria issues em repositório alheio.

## Documentação

- `README.md` — visão geral, instalação, tabela das skills com data e o que mudou em cada uma
- `COMO-TRABALHAR-AQUI.md` — fluxo de edição em detalhe
- `docs/AUDITORIA-2026-08-24.md` — auditoria das skills e o incidente que motivou a migração
  do repositório antigo

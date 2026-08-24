# Como trabalhar nesta pasta

Esta é a **cópia de trabalho** das skills e agentes globais da WA. É um clone do repositório
privado [designer976/wa-skills](https://github.com/designer976/wa-skills).

Edite as skills **aqui**. Nunca em `~/.claude/plugins/cache/` — aquilo é o cache do plugin
instalado e é sobrescrito a cada `claude plugin update`.

## Fluxo para alterar uma skill

1. Edite o arquivo em `wa/skills/<nome>/SKILL.md`

2. **Suba a versão** em `wa/.claude-plugin/plugin.json`. Sem isso o update não detecta
   a mudança e a alteração nunca chega na sua máquina.

3. Valide antes de commitar:

   ```bash
   claude plugin validate . && claude plugin validate ./wa
   ```

   Este passo não é opcional. Um `:` cru dentro de `description:` quebra o YAML e faz a skill
   carregar com metadata vazia — ela some da lista sem erro nenhum. Já aconteceu com 4 skills.

4. Commit e push para `master`

5. Para usar imediatamente, sem esperar a segunda-feira:

   ```bash
   claude plugin update wa@wa-skills
   ```

   Depois reinicie o Claude Code / Cowork.

## Atualização automática

Uma tarefa do Agendador do Windows chamada **"Claude - Atualizar plugin wa"** roda toda
segunda às 09:00, puxa a versão publicada e carimba versão e datas na descrição do
repositório no GitHub.

- Script agendado: `~/.claude/scripts/atualizar-plugin-wa.ps1`
- Cópia versionada: `setup/atualizar-plugin-wa.ps1`
- Log: `~/.claude/backups/plugin-update.log`

As duas cópias do script são independentes. Se editar a versionada, copie para
`~/.claude/scripts/` — o agendador não puxa do git sozinho.

## O que é cada coisa

| Caminho | O que é |
|---|---|
| `wa/skills/` | As 24 skills |
| `wa/references/` | Material compartilhado entre skills |
| `wa/.claude-plugin/plugin.json` | Manifesto do plugin — **é aqui que sobe a versão** |
| `.claude-plugin/marketplace.json` | Manifesto do marketplace |
| `setup/CLAUDE.global.md` | Referência do `~/CLAUDE.md`, para replicar em outra máquina |
| `setup/atualizar-plugin-wa.ps1` | Script do update semanal |
| `docs/` | Auditorias |

## Regra de ouro das skills

Nenhuma skill se ativa sozinha. Ela roda quando o usuário digita o comando e **encerra ao
concluir a tarefa**. Handoffs sugerem o próximo comando — não invocam a skill seguinte.
A única exceção é o `analista`, que é o orquestrador declarado no `~/CLAUDE.md`.

Ao criar ou editar qualquer skill, mantenha a seção **Ciclo de Vida** no fim do arquivo.

## Não confundir com `_claude-skills`

A pasta `WA/_claude-skills` é material antigo, de antes da migração para plugin: um instalador
PowerShell que copiava skills soltas para `~/.claude/skills` (pasta que não existe mais), além
de `MANIFEST.json` e `SKILLS.md`, que descrevem um conjunto diferente — 19 skills importadas do
catálogo `ComposioHQ/awesome-claude-skills`, não as 24 da WA.

Nada lá é usado pelo plugin. A única peça que foi aproveitada é a auditoria, já versionada em
`docs/AUDITORIA-2026-08-24.md`.

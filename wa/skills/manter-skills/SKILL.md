---
name: manter-skills
description: Fluxo do mantenedor para agir sobre a issue de verificacao semanal - investiga o que mudou nas dependencias, propoe as edicoes, sobe versao, valida, publica e fecha a issue. Invoque APENAS quando o usuario chamar /wa:manter-skills explicitamente.
---

# Agente Manter-Skills

> **Identidade visual:** Enquanto este skill estiver rodando, inicie cada resposta com `🔧 **Manter-Skills**`
> na primeira linha. Ao encerrar, pare de usar essa marca.

Você é o **Manter-Skills** — conduz o trabalho que a verificação de sexta **não** faz.

O script `verificar-skills-wa.ps1` é deliberadamente burro: ele detecta que uma dependência
mudou de versão, mas não sabe se o nosso material derivado ficou desatualizado por causa disso.
Essa comparação exige leitura e julgamento. É o que se faz aqui.

## Contexto

| | |
|---|---|
| Cópia de trabalho | `WA/Skills e Agentes globais/` |
| Repositório | `designer976/wa-skills` (privado) |
| Espelho público | `designer976/Skills-e-Agents` |
| Baseline da verificação | `~/.claude/backups/wa-baseline.json` |
| Log | `~/.claude/backups/plugin-update.log` |

**Nunca edite `~/.claude/plugins/cache/`** — é sobrescrito a cada update. Toda edição acontece
na cópia de trabalho.

## Gate de Permissão (OBRIGATÓRIO — executar PRIMEIRO)

1. Liste as issues abertas de verificação:

   ```bash
   gh issue list --repo designer976/wa-skills --state open --search "Verificacao semanal"
   ```

2. Se não houver nenhuma, pergunte ao usuário o que ele quer manter — pode ser uma mudança
   que ele já tem em mente, não necessariamente vinda do script.

3. Apresente os itens encontrados e pergunte: "Quais destes você quer tratar agora?"

**Aguarde confirmação. Se recusar → encerre.**

---

## Fase 1 — Investigar cada item

Para cada item aprovado, faça a análise que o script não fez.

### Dependência mudou de versão ou commit

A issue traz o comando de comparação pronto. Rode-o:

```bash
gh api repos/obra/superpowers/compare/<sha_antes>...<sha_agora> --jq '.files[].filename'
```

Depois filtre para o que **realmente** nos afeta. Nosso material derivado hoje:

| Nosso arquivo | Fonte |
|---|---|
| `wa/references/debugging.md` | `superpowers:systematic-debugging` |
| `wa/references/verification.md` | `superpowers:verification-before-completion` |

Se nenhum arquivo da fonte correspondente aparecer no compare, **o item morre aqui** —
a dependência subiu de versão mas não mexeu no que copiamos. Registre isso e siga.

Se mexeu, leia as duas versões e compare com o nosso destilado:

```bash
gh api repos/obra/superpowers/contents/skills/systematic-debugging/SKILL.md?ref=<sha> --jq '.content' | base64 -d
```

### Flag ou comando sumiu

`front-end-code` e `reviewer` mandam rodar `/ralph-loop` com flags específicas. Se a interface
mudou, leia os `commands/` do plugin e descubra o equivalente novo. Se não houver equivalente,
a instrução tem que sair da skill — melhor perder o passo do que mandar rodar algo inexistente.

### Plugin novo no marketplace

Leia a descrição e responda uma pergunta só: **ele cobre lacuna que temos hoje?** Se cobrir,
o resultado não é editar skill — é sugerir ao usuário instalar o plugin, ou abrir issue
descrevendo a lacuna. Não duplique num SKILL.md algo que um plugin já faz melhor.

---

## Fase 2 — Propor antes de editar

Para cada mudança, apresente:

```
ARQUIVO: wa/references/debugging.md
ORIGEM: superpowers 6.3.0 -> 6.4.0, systematic-debugging alterado
DIVERGENCIA: a fonte adicionou a etapa "reproduzir antes de instrumentar";
             nosso destilado ainda descreve o fluxo antigo de 4 etapas
PROPOSTA: [trecho exato que entra e trecho que sai]
IMPACTO: front-end-code e reviewer apontam para este arquivo
```

**Nenhuma edição sem aprovação.** Se o usuário recusar, registre na issue que o item foi
avaliado e dispensado, com o motivo — isso evita reavaliar a mesma coisa toda semana.

---

## Fase 3 — Aplicar e validar

1. Edite os arquivos aprovados na cópia de trabalho

2. **Suba a versão** em `wa/.claude-plugin/plugin.json`. Sem isso o `claude plugin update` não
   detecta mudança e a correção nunca chega em ninguém. É a falha mais provável deste fluxo.

3. Atualize a tabela do README: data e o que mudou, na linha das skills tocadas

4. Valide — **não pule este passo**:

   ```bash
   claude plugin validate . && claude plugin validate ./wa
   ```

   Um `:` cru dentro de `description:` quebra o YAML e faz a skill carregar com metadata vazia:
   ela some da lista sem erro nenhum. Já aconteceu com 4 skills de uma vez.

---

## Fase 4 — Publicar

```bash
git add -A && git commit && git push origin master
```

A mensagem de commit deve dizer **o que motivou** a mudança, não só o que mudou — daqui a seis
meses o motivo é o que estará faltando.

Se o usuário mantiver o espelho público sincronizado, lembre-o de replicar lá.

---

## Fase 5 — Fechar a issue

```bash
gh issue close <n> --repo designer976/wa-skills --comment "Resolvido em <sha>. <resumo>"
```

**Só feche o que foi resolvido de fato.** Item avaliado e dispensado também fecha, mas com o
motivo escrito. Item que ficou pendente permanece aberto.

---

## Regras

- **Nunca editar o cache do plugin** — só a cópia de trabalho
- **Nenhuma edição sem aprovação** do usuário, item por item
- **Bump de versão é obrigatório** em qualquer mudança de skill
- **Validar antes de commitar** — sempre, sem exceção
- **Dependência que subiu de versão não é motivo suficiente** para editar; só edite se o compare mostrar que a fonte do nosso material mudou
- **Não fechar issue sem publicar** — issue fechada com mudança só no disco é pior que issue aberta
- **Não duplicar o que um plugin faz** — se o marketplace já resolve, instale o plugin

## Handoff

- Mudança grande em skill visual → sugerir `/wa:designer` para planejar antes
- Precisa de diagrama do antes/depois da estrutura de skills → sugerir `/wa:diagrama`
- Apenas atualizar a instalação local, sem manutenção → sugerir `/wa:atualizar-skill-agent`

## Ciclo de Vida (OBRIGATORIO)

Este skill so roda quando o usuario o invoca explicitamente.

**Ao iniciar:** confirme que foi chamado de proposito. Se voce chegou aqui por conta propria,
sem o usuario ter digitado o comando, pare e devolva o controle sem executar nada.

**Enquanto roda:** faca apenas o que este skill cobre. Nao invoque outro skill por conta propria.
Quando outro skill for necessario, **sugira o comando ao usuario** e espere ele decidir.

**Ao terminar:** encerre. Entregue o resultado, informe qual comando o usuario pode chamar em
seguida, se houver, e **volte ao comportamento padrao do Claude**. Nao permaneca ativo, nao
assuma o proximo pedido do usuario e nao mantenha a identidade visual deste skill nas
respostas seguintes.

---
name: all-agents
description: Pipeline completo para tela ou componente do zero - Designer (validacao e plano), Front-end-UI (implementacao), Front-end-Code (revisao), Designer (aprovacao final). Invoque APENAS quando o usuario chamar /wa:all-agents explicitamente.
---

# Pipeline Completo — Todos os Agentes

## Quando usar cada skill

| Situação | Skill |
|----------|-------|
| Validar spec ou planejar antes de implementar | `/wa:designer` |
| Implementar UI com spec já pronta | `/wa:front-end-ui` |
| Revisar código após implementação | `/wa:front-end-code` |
| Implementar + revisar (spec já validada) | `/wa:all-front-end` |
| Do zero: validar + implementar + revisar | `/wa:all-agents` ← este |

---

## Fase 1 — Designer (Validação, Auditoria e Planejamento)

Adote o papel do **Agente Designer**. Inicie esta fase com `🟣 **Designer**` na primeira linha da resposta.

> ⚠️ **ATENÇÃO OBRIGATÓRIA — ANTES DE QUALQUER PASSO**
>
> Identifique o cenário do projeto:
> - **Cenário A (projeto legado):** O projeto existia antes do DS ser criado. Telas e componentes existentes podem estar **fora de conformidade com o DS**. Não trate o código existente como referência — trate-o como legado que pode precisar de migração.
> - **Cenário B (DS criado com o projeto):** Mesmo assim, verifique se o código existente segue fielmente o DS antes de implementar.
>
> **Em ambos os cenários: o DS é a fonte de verdade. O código existente pode estar errado.**

**Passos**:
1. Verifique se a solicitação contém:
   - **Local** onde será aplicado (rota, arquivo, componente pai)
   - **Especificação visual** (layout, componentes, cores, comportamento: hover, focus, mobile, empty state)
   - Se deve reutilizar componente do DS ou criar novo
2. Se faltar qualquer informação → **pergunte ao usuário e aguarde resposta**
   > **Skip de validação:** se o usuário incluir a spec completa na mesma mensagem, ou disser "spec completa, pode avançar" / "pule a validação", vá direto para a análise do DS sem perguntar.
3. **LEIA o DS com as ferramentas** (obrigatório — use Read/Glob):
   - **Glob** → liste `src/components/ui/**` para ver todos os componentes disponíveis
   - **Read** → abra `tailwind.config.ts` e `src/index.css` para identificar os tokens reais do projeto
   - **Glob + Read** → localize e leia a página de documentação do DS (`*DesignSystem*`, `*design-system*`) para ver exemplos de uso, casing, variantes e ícones de cada componente
4. **Audite os arquivos relevantes existentes** — compare o código atual com o DS e documente divergências encontradas (tokens hardcoded, componentes inline, libs de ícones erradas)
5. Verifique se existe padrão similar antes de propor criação de novo componente
6. Monte o **plano de implementação**: componentes, tokens, arquivos, comportamentos esperados — **incluindo correção das divergências encontradas no passo 4**
7. Apresente o plano — prossiga somente quando estiver claro

**Avance para a Fase 2 somente após confirmação do usuário ou quando a spec estiver inequivocamente completa.**

---

## Fase 2 — Front-end-UI (Implementação)

Adote o papel do **Agente Front-end-UI**. Inicie esta fase com `🔵 **Front-end-UI**` na primeira linha da resposta.

**Entrada:** use o plano aprovado na Fase 1 — componentes, tokens, arquivos e comportamentos definidos são a spec de implementação.

**Tokens obrigatórios:**

| Categoria | Token correto | Proibido |
|-----------|--------------|---------|
| Fundo | `bg-background`, `bg-card`, `bg-muted`, `bg-secondary` | `bg-gray-*`, `bg-white`, `bg-zinc-*` |
| Texto | `text-foreground`, `text-muted-foreground` | `text-gray-*`, `text-zinc-*` |
| Borda | `border-border` | `border-gray-*`, `border-zinc-*` |
| Radius | `rounded-lg` | `rounded-xl`, `rounded-2xl`, `rounded-3xl` |
| Hover | `hover:bg-secondary`, `hover:brightness-95` | `hover:bg-blue-*`, `hover:bg-gray-*` |
| Ícones | `import { ... } from "lucide-react"` | `@tabler/icons-react` |

**Exceção aceita:** cores semânticas intencionais (`bg-green-500` = sucesso, `bg-red-500` = erro, `bg-yellow-500` = alerta).
**Conflito spec vs DS:** se a spec pede algo que viola o DS → alerte o usuário e aplique o token canônico.

**Regras**:
- Se novo componente DS → **antes de criar**, abrir 2-3 componentes similares em `src/components/ui/` e replicar exatamente o mesmo padrão estrutural (exportação, tipagem, uso de `cn()`, variantes com `cva`). Criar em `src/components/ui/` e registrar na documentação do DS
- TypeScript: todas as props tipadas, sem `any`, union types para variantes
- Nunca alterar lógica de negócio ou hooks
- Listar arquivos alterados ao final desta fase

---

## Fase 3 — Front-end-Code (Revisão)

Adote o papel do **Agente Front-end-Code**. Inicie esta fase com `🟢 **Front-end-Code**` na primeira linha da resposta.

**O que revisar**:
1. **Performance**: `useMemo`/`useCallback` ausentes, listas sem `key`, subscriptions sem cleanup
2. **TypeScript**: sem `any`, props tipadas, retornos explícitos, generics corretos
3. **DS Tokens**: classes proibidas, imports de `@tabler/icons-react`
4. **Navegabilidade**: z-index, overflow, acessibilidade básica (`aria-label`, `role`)
5. **Código limpo**: imports não usados, `console.log`, variáveis mortas

**Regra CRÍTICA**: Não alterar nada visual. Problemas visuais → reportar ao Designer.

**Formato por problema**:
```
ARQUIVO: caminho/arquivo.tsx:linha
SEVERIDADE: 🔴 Crítico | 🟡 Alerta | 🟢 Info
PROBLEMA: descrição
ACAO: correção aplicada (ou "→ Designer" se visual)
```

**Níveis:**
- 🔴 Crítico — quebra de tipagem, `@tabler/icons-react`, token DS proibido, performance real (loop em render, subscription sem cleanup)
- 🟡 Alerta — `useMemo`/`useCallback` ausente, `any` em prop, cor/radius não-canônico
- 🟢 Info — `console.log`, import não usado, variável morta

---

## Fase 4 — Designer (Revisão Final)

Adote o papel do **Agente Designer**. Inicie esta fase com `🟣 **Designer**` na primeira linha da resposta.

**Verificar nos arquivos alterados**:
1. Nenhuma cor hardcoded introduzida (`gray-*`, `blue-*`, `white` direto)
2. Radius usa exclusivamente `rounded-lg`
3. Ícones importados de `lucide-react`
4. Componentes seguem o padrão visual do projeto
5. Estrutura semântica e acessível

**Se houver inconsistência** → avise o usuário com detalhes antes de finalizar.
**Se tudo ok** → declare aprovação.

---

## Resumo Executivo Final

```
PIPELINE CONCLUIDO

Fase 1 - Designer:
  - Spec validada: sim/não (itens pendentes se houver)
  - Plano: [descrição resumida]

Fase 2 - Front-end-UI:
  - Arquivos criados/editados: [lista]
  - O que foi implementado: [descrição]

Fase 3 - Front-end-Code:
  - 🔴 Críticos corrigidos: X
  - 🟡 Alertas corrigidos: Y
  - 🟢 Infos corrigidos: Z
  - Itens para o Designer: W

Fase 4 - Designer:
  - Status: APROVADO / PENDÊNCIAS (listar)
```

## Stack Assumida

React + Vite + TypeScript + Tailwind CSS + shadcn/ui
`rounded-lg` = `var(--radius)` = token canônico de border-radius

## Diagrama da Mudanca

Quando o pipeline mexeu em estrutura de tela ou navegacao, entregue tambem um diagrama Mermaid junto com o resultado.

**Tipo:** consolide na entrega final um `flowchart TD` da arvore de componentes, ou `flowchart LR` da navegacao se a mudanca foi de fluxo.

**Convencoes** (definidas em `/wa:diagrama`, siga-as para os diagramas sairem consistentes
entre skills):

- Maximo de 20 nos. Passou disso, quebre em dois diagramas
- Nomes reais de arquivo, rota, tabela ou componente - nunca generícos como "Servico A"
- Marcacao de mudanca, sempre as mesmas tres classes:

```
classDef novo fill:#dcfce7,stroke:#16a34a,stroke-width:2px
classDef saiu fill:#fee2e2,stroke:#dc2626,stroke-dasharray: 5 5
classDef mudou fill:#fef9c3,stroke:#ca8a04,stroke-width:2px
```

- Dois blocos separados, **Antes** e **Depois**, seguidos de uma lista em texto do que mudou.
  A lista nao e redundante: e o que sobra para quem abrir o arquivo num editor sem Mermaid

**Nao desenhe de memoria.** Baseie-se nos arquivos que voce leu ou alterou nesta execucao, e
declare o que ficou de fora. Se a mudanca foi pequena e o diagrama nao acrescenta nada, diga
isso e siga - diagrama obrigatorio vira ruido.

Para um diagrama mais elaborado, ou de uma parte que voce nao tocou, sugira `/wa:diagrama`.

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

# Skills de terceiros — referência rápida

As 32 skills instaladas em `~/.claude/skills` via `npx skills add`. **Cada uma é um comando
próprio**, sem prefixo — chamar direto sempre funciona e é mais rápido que passar pelo roteador.

O `/wa:super-ui-skills` existe para o caso oposto: quando você sabe o problema mas não lembra
o nome da skill.

> Levantado em 19/10/2026. Elas ficam **fora do versionamento** — se uma sumir ou mudar de nome,
> este documento fica desatualizado sem aviso. A verificação de sexta vigia a pasta e avisa
> quando aparecem novas ou quando uma colide de nome com as do plugin `wa`.

---

## Os mais usados

| Comando | Para quê |
|---|---|
| `/impeccable` | Redesign e crítica de interface. É o mais abrangente: hierarquia visual, carga cognitiva, acessibilidade, responsividade, tipografia, cor, motion, UX copy, estados de erro |
| `/emil-design-eng` | Polimento e os detalhes invisíveis que fazem software parecer bom. Filosofia do Emil Kowalski sobre qualidade de componente |
| `/design-taste-frontend` | Direção de arte para site público, destilada de 247 sites de galeria. **Não serve para dashboard ou tela de app** — ela própria diz isso |
| `/break-ui` | Stress-test: alimenta a UI com nome gigante, e-mail sem quebra, lista vazia, emoji, número extremo, e reporta o que quebrou |
| `/apple-design` | Gesto, spring, drag, swipe, sheet, materiais translúcidos — a abordagem da Apple traduzida para web |

## Animação

| Comando | Para quê |
|---|---|
| `/animate` | Animar do zero: se deve animar, qual propriedade, qual curva, duração, como interrompe e como sai |
| `/animation-performance` | Animação travando ou perdendo frame. Pipeline layout/paint/composite, propriedades baratas, quando `will-change` ajuda de verdade |
| `/improve-animations` | Auditoria do movimento do codebase inteiro, com plano priorizado. Não aplica, planeja |
| `/find-animation-opportunities` | "O que aqui poderia animar?" — propõe com valores exatos, não implementa |
| `/review-animations` | Revisar uma animação específica já feita |
| `/animation-vocabulary` | "Como chama aquele efeito que...?" — glossário reverso |
| `/animate-expo` | Animação em React Native / Expo. Fora do stack da WA |

## Direção de arte e estética

| Comando | Para quê |
|---|---|
| `/high-end-visual-design` | "Quero que pareça caro". Define fontes, espaçamento, sombras e bloqueia os defaults que denunciam design gerado |
| `/redesign-existing-projects` | Site existente que precisa subir de nível sem quebrar o que funciona |
| `/gpt-taste` | GSAP, ScrollTrigger, pinning, tipografia editorial larga, espaçamento generoso |
| `/stitch-design-taste` | Gera `DESIGN.md` com padrões anti-genéricos, para o Google Stitch |
| `/minimalist-ui` | Estética editorial limpa, monocromático quente, sem gradiente nem sombra pesada |
| `/industrial-brutalist-ui` | Grid rígido, terminal militar, contraste extremo de escala tipográfica |

## Geração de imagem

| Comando | Para quê |
|---|---|
| `/brandkit` | Board de identidade visual, sistema de logo, deck de marca |
| `/imagegen-frontend-web` | Referência visual de site antes de codar — uma imagem por seção |
| `/imagegen-frontend-mobile` | Telas de app mobile em mockup de telefone |
| `/image-to-code` | Gera a imagem e implementa o site a partir dela |

## Stack e utilidades

| Comando | Para quê |
|---|---|
| `/ask-sonner` | Toast com Sonner — **a única lib de toast permitida no Severino** |
| `/mobile-native` | Web app parecer nativo no celular: 100vh, tap highlight, pull-to-refresh, notch, PWA |
| `/web-design-guidelines` | Revisar código de UI contra as Web Interface Guidelines |
| `/pick-ui-library` | Escolher biblioteca de componentes |
| `/prototype` | Protótipo rápido para validar ideia |
| `/find-skills` | Procurar se existe skill para alguma coisa |
| `/full-output-enforcement` | Saída sendo truncada, precisa de código completo sem placeholder |
| `/write-swift` | Swift moderno, concorrência Swift 6. Fora do stack da WA |

## Não usar

`/design-taste-frontend-v1` e `/design-taste-frontend-v2-experimental` são versões antigas
preservadas para compatibilidade. A atual é `/design-taste-frontend`.

---

## Quando usar as de terceiros e quando usar as da WA

**Regra prática:** se a resposta certa depende de ler o `tailwind.config` do projeto, é skill da
WA. Se vale para qualquer projeto do mundo, é de terceiro.

| Pedido | Vá para |
|---|---|
| Auditar aderência ao **nosso** Design System, tokens vs. hardcoded | `/wa:audit-ui` |
| Validar spec visual contra o DS antes de implementar | `/wa:designer` |
| Implementar UI com os tokens do projeto | `/wa:front-end-ui` |
| Auditoria de UX com nosso formato de finding e severidade | `/wa:designer-ux` |
| Revisar código front-end — performance, TypeScript | `/wa:front-end-code` |

Dois casos ficam no meio:

- **Dashboard ou tela de app** — a `/design-taste-frontend` declara que não serve para isso.
  Prefira `/impeccable` ou as skills da WA
- **Site público novo, sem Design System** — aí as de terceiros ganham: não há DS a respeitar e
  o trabalho é justamente criar a identidade

## Atualização

Estas 32 **não se atualizam sozinhas**. O `npx skills list` reporta `Source: local` para todas e
não existe `skills-lock.json`, então o `npx skills update` não tem origem para consultar.

Na prática, atualizar significa rodar de novo os comandos de instalação:

```bash
npx skills add emilkowalski/skill
npx impeccable install
npx skills add Leonxlnx/taste-skill
npx skills add vercel-labs/skills@find-skills
npx skills add https://github.com/vercel-labs/agent-skills --skill web-design-guidelines
```

É o oposto do plugin `wa`, onde a origem está no `plugin.json`, o update compara versão e a
tarefa de segunda executa sozinha.

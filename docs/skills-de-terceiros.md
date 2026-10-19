# Skills de terceiros — referência rápida

As 32 skills instaladas em `~/.claude/skills` via `npx skills add`. **Cada uma é um comando
próprio**, sem prefixo — chamar direto sempre funciona e é mais rápido que passar pelo roteador.

O `/wa:super-ui-skills` existe para o caso oposto: quando você sabe o problema mas não lembra
o nome da skill.

> Levantado em 19/10/2026, após reinstalar tudo pela fonte. Duas mudaram de escopo nessa
> atualização — `design-taste-frontend` passou a cobrir telas de app, e `impeccable` ganhou
> iOS/Android e documentação de Design System. Elas ficam **fora do versionamento** — se uma sumir ou mudar de nome,
> este documento fica desatualizado sem aviso. A verificação de sexta vigia a pasta e avisa
> quando aparecem novas ou quando uma colide de nome com as do plugin `wa`.

---

## Os mais usados

| Comando | Para quê |
|---|---|
| `/impeccable` | Redesign e crítica de interface. É o mais abrangente: hierarquia, layout, tipografia, cor, motion, UX copy, acessibilidade, edge cases. Cobre também tela nativa iOS/Android e documentar Design System em `DESIGN.md` |
| `/emil-design-eng` | Polimento e os detalhes invisíveis que fazem software parecer bom. Filosofia do Emil Kowalski sobre qualidade de componente |
| `/design-taste-frontend` | Direção de arte, destilada de 247 sites de galeria. Cobre site público **e também telas de app** — dashboard, admin, settings, inbox — cada um com regras próprias |
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

- **Dashboard ou tela de app** — a `/design-taste-frontend` passou a cobrir isso (mudou em
  19/10/2026; antes declarava não servir). `/impeccable` também cobre. Entre as duas e as skills
  da WA, decide quem conhece o seu Design System: para aderência a tokens e componentes do
  projeto, as da WA; para direção visual, as de terceiros
- **Site público novo, sem Design System** — aí as de terceiros ganham: não há DS a respeitar e
  o trabalho é justamente criar a identidade

## Créditos e licenças

Nenhuma destas skills é da WA. Elas são instaladas da fonte original por `npx skills add` e
**não são redistribuídas neste repositório** — o que também evita o problema de licença, já que
quase nenhuma declara uma.

| Autor | Pacote | Skills |
|---|---|---|
| **Emil Kowalski** | `emilkowalski/skill` | `animate`, `animate-expo`, `animation-performance`, `animation-vocabulary`, `apple-design`, `ask-sonner`, `break-ui`, `emil-design-eng`, `find-animation-opportunities`, `improve-animations`, `mobile-native`, `pick-ui-library`, `prototype`, `review-animations`, `write-swift` |
| **Leonxlnx** | `Leonxlnx/taste-skill` | `design-taste-frontend` (+ `-v1`, `-v2-experimental`), `brandkit`, `gpt-taste`, `high-end-visual-design`, `image-to-code`, `imagegen-frontend-web`, `imagegen-frontend-mobile`, `industrial-brutalist-ui`, `minimalist-ui`, `redesign-existing-projects`, `stitch-design-taste` |
| **Vercel Labs** | `vercel-labs/skills`, `vercel-labs/agent-skills` | `find-skills`, `web-design-guidelines` |
| **impeccable** | `npx impeccable install` | `impeccable` — **Apache 2.0**, a única que declara licença |
| *origem não identificada* | — | `full-output-enforcement` — instalada antes das demais e não veio de nenhum dos cinco comandos acima |

**Sobre licença:** apenas a `impeccable` declara uma (Apache 2.0). As outras 31 não têm arquivo
`LICENSE` nem declaração no frontmatter. Sem licença explícita, o padrão legal é *todos os
direitos reservados* — por isso elas não entram neste repositório, e por isso `/wa:impeccable`
e companhia não existem: criar esses comandos exigiria copiar o trabalho delas para cá.

Se algum dia precisar do prefixo `/wa:`, o caminho é pedir autorização a cada autor — ou
escrever skills próprias cobrindo os mesmos temas.

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

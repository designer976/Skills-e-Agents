# Plano: Redesign Easy Salon Landing Page

## Context
Redesign completo do site institucional da Easy Salon como projeto standalone separado do monorepo. O objetivo é uma identidade visual mais premium e moderna, mantendo a identidade de marca (vermelho #CE4836, fontes Inter), inspirado no estilo clean e espaçoso do baselsupercluster.com. Stack: React + Vite + Tailwind.

**Destino:** `C:\Users\charl\OneDrive\Área de Trabalho\WA\Easy\Easy site\`

---

## Design System

### Cores
```
Background:    #F8F5F0  (creme quente)
Surface:       #FFFFFF  (cards)
Text:          #1A1A1A  (títulos)
Muted:         #6B6B6B  (subtexto)
Primary:       #CE4836  (vermelho marca)
Primary hover: #B53D2D
Accent:        #EDE4D4  (bege claro - bordas, fundos)
Dark section:  #1A0F0D  (footer)
```

### Tipografia
- **Display (headlines):** Playfair Display — serif elegante, peso 700 (inspiração baselsupercluster)
- **Body:** Inter — mesmo que o monorepo, peso 400/500/600
- **Tamanhos hero:** 5xl–7xl em desktop, 3xl–5xl em mobile

### Componentes visuais
- Espaçamento generoso (py-24 to py-32 entre seções)
- Cards com bordas 1px #EDE4D4, sombra suave, border-radius 16px
- Números decorativos grandes (text-[120px], opacity-10) como elemento visual
- Animações via Framer Motion: fade-in + slide-up ao entrar no viewport
- Navbar sticky: transparente → fundo branco com blur ao scroll

---

## Estrutura do Projeto

```
Easy site/
├── index.html
├── package.json
├── vite.config.ts
├── tailwind.config.ts
├── postcss.config.js
├── tsconfig.json
└── src/
    ├── main.tsx
    ├── App.tsx
    ├── index.css          (tokens CSS, @import fontes)
    └── components/
        ├── Navbar.tsx     (sticky, blur, CTA)
        ├── Hero.tsx       (título animado, CTAs, mockup app)
        ├── HowItWorks.tsx (4 steps numerados)
        ├── BusinessTypes.tsx (3 cards com foto)
        ├── About.tsx      (texto + foto equipe)
        ├── CTA.tsx        (banner full-width)
        └── Footer.tsx     (dark, logo, links, social)
```

---

## Seções e Conteúdo

### 1. Navbar
- Logo "EASY ✦ SALON" à esquerda
- Links: Soluções (dropdown) | Planos | Quem somos
- CTAs à direita: "Login" (ghost) + "Crie sua conta" (vermelho)
- Comportamento: bg transparente → `bg-white/90 backdrop-blur` ao scroll

### 2. Hero
- Badge pill: "Inteligência Artificial para beleza"
- Título H1 grande (Playfair Display): "IA de agendamento para **barbearias**" (palavra animada com TypewriterEffect ou framer-motion)
- Subtítulo Inter: "A Easy Salon ajuda donos de salões, barbearias e estúdios de beleza a organizarem sua agenda e evoluírem para uma gestão simples e inteligente."
- 2 CTAs: [Começar grátis] (vermelho filled) + [Agende uma Demonstração] (ghost com seta)
- Imagem: mockup de telas do app à direita (placeholder ou imagem existente)
- Fundo: creme com textura sutil ou wave SVG

### 3. Como organizamos negócios da beleza
- Título seção + 4 cards em grid 2x2
- Cada card: número decorativo grande (01–04) + ícone + título bold + descrição
- Fundo: branco com borda accent

### 4. Veja a Easy funcionando
- Título + 3 cards em grid (salão de beleza, barbearia, estúdio de beleza)
- Cada card: foto full (aspect-ratio 4/5), categoria pill, título, descrição, CTA
- Hover: leve scale + sombra mais forte

### 5. Por trás da Easy
- Layout 2 colunas: texto à esquerda, foto equipe à direita
- Título (Playfair) + 2 parágrafos + 2 CTAs
- Fundo creme #F8F5F0

### 6. CTA Banner
- Fundo vermelho #CE4836
- Título branco grande, subtítulo, botão branco
- Design full-width com padding generoso

### 7. Footer
- Fundo dark #1A0F0D
- Logo branca + 4 colunas de links
- Linha de copyright + links legais
- Ícones sociais (Instagram, WhatsApp, LinkedIn)

---

## Dependências

```json
{
  "react": "^18",
  "react-dom": "^18",
  "framer-motion": "^11",
  "lucide-react": "latest",
  "@types/react": "^18",
  "tailwindcss": "^3",
  "vite": "^5",
  "typescript": "^5"
}
```

Fontes via Google Fonts CDN no index.html:
- `Playfair+Display:wght@400;700;900`
- `Inter:wght@400;500;600;700`

---

## Implementação — Passos

1. Criar estrutura do projeto (`package.json`, `vite.config.ts`, `tailwind.config.ts`, `tsconfig.json`, `index.html`)
2. Configurar Tailwind com tokens do design system (cores, fontes, radius)
3. Criar `src/index.css` com variáveis CSS e imports de fonte
4. Criar `src/App.tsx` montando todas as seções em ordem
5. Implementar componentes na ordem: Navbar → Hero → HowItWorks → BusinessTypes → About → CTA → Footer
6. Adicionar animações Framer Motion (useInView + variants de fade/slide)
7. Garantir responsividade mobile (breakpoints sm/md/lg)

---

## Verificação

- Rodar `npm install && npm run dev` dentro de `Easy site/`
- Abrir `http://localhost:5173` e validar todas as seções
- Checar responsividade em 375px (mobile), 768px (tablet), 1440px (desktop)
- Verificar animações de scroll e comportamento do navbar

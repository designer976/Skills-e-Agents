# Memory — Rios ID Project

## Projeto ativo
- **Path:** `C:/Users/charl/OneDrive/Área de Trabalho/WA/Rios ID`
- **Repo:** https://github.com/designer976/rios-id.git
- **Stack:** Next.js 16, Tailwind v3, pnpm, shadcn/ui (radix-nova), TypeScript
- **Dev:** `pnpm dev` → http://localhost:3001

## Regras do projeto — OBRIGATÓRIO LER ANTES DE CONSTRUIR

### Design System First
- Antes de criar ou alterar qualquer componente, consultar `/admin/design-system` (arquivo: `app/admin/design-system/page.tsx`)
- Esta página é a **fonte de verdade** dos componentes pai do sistema
- Se um componente necessário não existir no design system, **perguntar ao usuário qual usar** antes de implementar

### Componentes fonte (não reinventar)
| Componente | Arquivo |
|---|---|
| AdminButton | `components/admin/admin-button.tsx` |
| AdminInput | `components/admin/admin-input.tsx` |
| AdminRadioGroup | `components/admin/admin-radio.tsx` |
| AdminTooltip | `components/admin/admin-tooltip.tsx` |
| AdminTable | `components/admin/admin-table.tsx` |
| AdminCard | `components/admin/admin-card.tsx` |
| AdminModal | `components/admin/admin-modal.tsx` |
| AdminTabs | `components/admin/admin-tabs.tsx` |
| DashboardFilters | `components/admin/dashboard-filters.tsx` |
| Select/shadcn | `components/ui/select.tsx` |

## Padrões consolidados

### Select — sempre abrir abaixo do trigger (dropdown)
```tsx
<SelectContent position="popper" side="bottom" sideOffset={4}>
```
- Usar `position="popper"` + `side="bottom"` + `sideOffset={4}` em **todo uso de SelectContent** no projeto
- Com `position="popper"` o conteúdo herda a largura do trigger via `min-w-(--radix-select-trigger-width)`

### Cores da marca (globals.css — HSL)
- `--primary: 198 73% 29%` (teal/azul)
- `--background: 210 40% 98%`
- `--radius: 0.75rem`
- NÃO usar oklch para as variáveis de tema — projeto usa HSL

### Fonte
- Apenas `Plus_Jakarta_Sans` — variável `--font-plus-jakarta`
- NÃO adicionar Geist ou outras fontes

## Detalhes técnicos
- Tailwind v3 (não v4) — usar `tailwind.config.ts` + `@tailwind` directives
- NÃO instalar `@tailwindcss/postcss` (causa conflito com Turbopack)
- PostCSS config usa `tailwindcss: {}` (plugin v3)

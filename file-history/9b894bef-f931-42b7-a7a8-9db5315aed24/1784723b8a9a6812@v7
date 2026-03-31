# Easy Salon Monorepo - Memory

## Project
- Monorepo: `C:\Users\charl\OneDrive\Área de Trabalho\WA\easy-salon-monorepo`
- Frontend: React 18 + Vite + TypeScript + Tailwind CSS (port 8080)
- Prototype for reference: `C:\Users\charl\OneDrive\Área de Trabalho\WA\Easy prototipo` (Next.js, port 3000)

## Icon Library
- **`@tabler/icons-react`** (replaced `lucide-react` completely)
- All icons use `Icon` prefix: `IconCheck`, `IconPlus`, `IconArrowLeft`, etc.
- Key non-obvious mappings: `Trash2`→`IconTrash`, `RefreshCw`→`IconRefresh`, `LogOut`→`IconLogout`, `Building2`→`IconBuilding`, `Bot`→`IconRobot`, `DollarSign`→`IconCurrencyDollar`, `CheckCircle`→`IconCircleCheck`, `XCircle`→`IconCircleX`, `Info`→`IconInfoCircle`, `Menu`→`IconMenu2`, `MoreHorizontal`→`IconDots`, `Save`→`IconDeviceFloppy`, `PanelLeft`→`IconLayoutSidebar`, `ReceiptText`→`IconReceipt2`, `ChevronsUpDown`→`IconSelector`, `MessageSquare`→`IconMessage`, `Wrench`→`IconTool`, `Edit2`→`IconPencil`, `BarChart3`→`IconChartBar`
- `LucideIcon` type replaced with: `React.ComponentType<{ size?: number; stroke?: number; className?: string; }>`
- All imports use alias pattern to preserve local names: `import { IconTrash as Trash2 } from "@tabler/icons-react"`

## Visual Migration Status (as of 2026-03-18)
Migration of visual components + responsive adjustments from prototype to monorepo is **COMPLETE**.

### Color Tokens (index.css) — Fixed
- Light mode: `--background: 0 0% 98%`, `--muted: 0 0% 95%`, `--muted-foreground: 0 0% 46%` (neutral, not blue-tinted)
- Dark mode: full neutral gray palette aligned with prototype OKLCH neutrals
- `.salon-badge-inactive`: updated to `rgb(221 66 39 / 0.1)` bg + `#dd4227` text (was gray `#F1EFE8/#5F5E5A`)

### Status Badge Alignment — Fixed (active=green, inactive=red-tint)
- `SalonUsersPage.tsx`, `UsersPage.tsx` (admin), `AdminDashboardPage.tsx`, `SalonsPage.tsx` — all now use `.salon-badge-active` / `.salon-badge-inactive` CSS classes
- `ServicesPage.tsx` was already correct using these classes

### EasyCalendar — Restructured
- Fixed header row outside scroll area; JS-synced `headerScrollRef.scrollLeft` for horizontal sync
- Scrollbar width compensation via `useEffect` measuring `offsetWidth - clientWidth`
- Responsive columns: `min-w-[160px] md:min-w-[300px]`
- Professional initials + full name in header (no truncate, break-words)

### Completed
- `index.css`: `.salon-card` → `rounded-3xl`, `.salon-table-header` → `bg-[#f5ebe6]`, `.salon-button-primary` → `bg-[#dd4227]`
- `components/layout/Header.tsx` — hamburger, salon selector Drawer (mobile), "Minha página web", "Agendamento IA"
- `components/layout/EasySalonSidebar.tsx` — slide-in drawer with X close button
- `components/layout/EasySalonLayout.tsx` — backdrop overlay + drawer sidebar variant
- `components/layout/PageHeader.tsx` — action button `rounded-[14px] bg-[#dd4227]`
- `components/AuthLayout.tsx` — white logo on left panel, mobile red banner with logo, bg-white right side
- `components/ui/loading-spinner.tsx` — NEW: LoadingSpinner component
- `components/ui/empty.tsx` — NEW: Empty, EmptyHeader, EmptyTitle, EmptyDescription, EmptyContent, EmptyMedia
- `components/ui/EasyCalendar/EventBlock.tsx` — rounded-sm, bg-card, border-l-gray-900
- `components/ui/EasyCalendar/EasyCalendar.tsx` — removed max-w magic number
- `components/ui/EasyCalendar/TimeGrid.tsx` — width: "100vw" for current time line
- `components/agenda/AgendaFilters.tsx` — plain `<button>` triggers
- `components/agenda/mobile/MobileAgendaView.tsx` — filter button + props
- `pages/auth/Login.tsx` → `pages/Login.tsx` — `bg-[#dd4227]` button, `#dd4227` links
- `pages/salon/DashboardPage.tsx` — plain divs rounded-3xl, native date inputs, text-3xl KPIs
- `pages/salon/SalonUsersPage.tsx` — pagination bg-[#dd4227] active
- `pages/salon/ClientsPage.tsx` — pagination bg-[#dd4227] active
- `pages/salon/SettingsPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/SolicitacoesPage.tsx` — Card → plain divs rounded-3xl; mobile Tabs view (block md:hidden) + desktop Kanban (hidden md:block); gray tokens → design tokens
- `pages/salon/SalonUserFormPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/AgendaV2Page.tsx` — mobile filter Drawer
- `pages/admin/AdminDashboardPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/settings/WorkingHoursPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/settings/SalonDataPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/settings/OnlineBookingHoursPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/settings/OnlineBookingSettingsPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/AbsencesPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/UserSchedulePage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/UserServicesPage.tsx` — Card → plain divs rounded-3xl
- `pages/salon/UserPasswordPage.tsx` — Card → plain divs rounded-3xl
- `pages/admin/EditUserPage.tsx` — Card → plain divs rounded-3xl; btn color #dd4227
- `pages/admin/CreateSalonPage.tsx` — Card → plain divs rounded-3xl; btn color #dd4227
- `pages/admin/CreateUserPage.tsx` — Card → plain divs rounded-3xl; btn color #dd4227
- `pages/Register.tsx` — Card → plain divs rounded-3xl
- `pages/ProfilePage.tsx` — Card → plain divs rounded-3xl (2 cards)
- `components/admin/financial/FinancialOverviewCards.tsx` — Card → plain divs rounded-3xl
- `components/solicitacoes/SolicitacaoKanban.tsx` — Card → plain divs rounded-3xl; Online badge `bg-primary`
- `components/agenda/mobile/TimeSlotGrid.tsx` — gray-*/blue-* → design tokens (muted, primary, border)
- `components/agenda/mobile/EventCard.tsx` — blue-500/gray-* → design tokens; highlight `ring-primary`
- `components/agenda/mobile/ProfessionalCarousel.tsx` — badge `bg-muted-foreground text-background`
- `pages/salon/settings/SalonDataPage.tsx` — button #ce4836 → #dd4227
- `index.css` — fixed wrong comment on --primary (actual value is #dd4227)
- `pages/salon/SpecialtiesPage.tsx` — "Padrão" badge bg-blue-100 → bg-muted; mobileView="cards" ✅
- `pages/admin/SalonsPage.tsx` — mobileView="cards" ✅ (already done)
- `pages/admin/UsersPage.tsx` — mobileView="cards" ✅ (already done)
- `pages/salon/ServicesPage.tsx` — mobileView="cards" in accordion ✅ (already done)
- `components/ui/services-accordion.tsx` — Card → div rounded-3xl
- `components/ui/user-services-accordion.tsx` — Card → div rounded-3xl
- `components/modals/TransformarSolicitacaoModal.tsx` — Card → div rounded-2xl; blue/gray tokens → design tokens

## CSS Token Notes
- `--primary: 9 73% 51%` in index.css actually computes to `#dd4227` (the comment was wrong saying #ce4836)
- `--ring: 9 73% 51%` same token, used for focus rings

## Key Design Tokens
- Brand red: `#dd4227`, hover: `#c73a22`
- Table header bg: `#f5ebe6`
- Card border radius: `rounded-3xl`
- Button radius (action): `rounded-[14px]`
- Active badge: `bg-green-100 text-green-800`
- Inactive badge: `bg-[#dd4227]/10 text-[#dd4227]`
- Primary role badge: `bg-[#dd4227]/10 text-[#dd4227] rounded-full`

## Architecture Notes
- DataTable component (`components/ui/data-table.tsx`) uses `.salon-card` and `.salon-table-header` CSS classes → automatically styled by index.css changes
- salon-card = `rounded-3xl border border-border bg-card`
- salon-table-header = `bg-[#f5ebe6] text-foreground font-medium`
- Login: `pages/Login.tsx` uses `AuthLayout` which has the full split-panel layout
- Logo: `@/assets/easy-logo.svg` and `@/assets/easy-logo.png` - use `brightness-0 invert` CSS for white version

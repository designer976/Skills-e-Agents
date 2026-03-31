# Claude Memory - Easy Salon Project

## Project Overview
**Easy Salon** - Complete beauty salon management system with multi-tenant architecture

### Project Location
- Main Path: `C:\Users\charl\OneDrive\Área de Trabalho\WA\easy-salon-monorepo`
- Frontend URL: `http://localhost:9001` (temporário devido conflito porta 9000)
- Backend URL: `http://localhost:3000/api` (GitHub original intocado)
- Client Management: `http://localhost:9001/salon/clients`

### Architecture Stack
- **Frontend**: Next.js 16.0.10 + TypeScript + Turbopack + shadcn/ui + Tailwind CSS
- **Backend**: NestJS + TypeScript + TypeORM (GitHub original preservado)
- **Database**: PostgreSQL (multi-tenant with schema per tenant)
- **Cache/Session**: Redis
- **Authentication**: JWT
- **Routing**: Next.js App Router

### Design System
- Primary Color: `#dd4227` (Easy Salon Red)
- Secondary: `#f5f2ed`
- Component Classes: salon-button, salon-input, salon-card, salon-table-header
- Status Badges: salon-badge-active, salon-badge-inactive
- Border Radius: 14px (--radius: 0.875rem)
- Dark mode support with HSL color system

### Multi-Tenant Strategy
- Schema per tenant approach
- Platform schema: shared data (tenants, users, plans)
- Tenant schemas: isolated tenant data (tenant_xyz format)

### Development Ports
- Frontend: 9001 (temporarily due to port 9000 conflict)
- Backend: 3000 (GitHub original)
- PostgreSQL: 5432
- Redis: 6379

### Reference Component Base
**Location**: `C:\Users\charl\OneDrive\Área de Trabalho\WA\Easy prototipo`
- **Tech Stack**: Next.js prototype
- **Design System**: OKLCH colors (vs HSL in main project)
- **Radius**: 0.625rem (vs 0.875rem in main)
- **Fonts**: Geist family (vs Inter in main)
- **Features**: Advanced focus states, shadow system, enhanced dark mode

### Current Status
- **Frontend Migration**: ✅ COMPLETED (19/03/2026) - React+Vite → Next.js 16.0.10
- **Backend**: ✅ PRESERVED GITHUB ORIGINAL - No changes applied
- **Running Status**: Frontend ✅ Running on port 9001, Backend untouched
- **Goal**: Only visual frontend improvements, backend remains as per GitHub repo

### Key Features Context
- Client management system at `/salon/clients`
- Complete salon business management
- Multi-tenant SaaS architecture
- Modern Next.js/NestJS stack
- GitHub backend functionality preserved
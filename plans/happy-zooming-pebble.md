# Plano: Remover installCommand pills do Design System

## Contexto
O Design System exibe pills de "pnpm dlx shadcn@latest add ..." em cada seção de componente. O usuário quer remover esses elementos, mantendo apenas os pills de import path (borda tracejada).

## Arquivo
`frontend/src/pages/DesignSystemPage.tsx`

## Mudanças

### 1. Componente `Section` (linhas ~157-213)
- Remover prop `installCommand?: string` da interface
- Remover state `copiedInstall` e função `copyInstall`
- Remover o bloco de render do pill de installCommand (o `{installCommand && (...)}` block)
- Simplificar a condição `{(installCommand || importPath) &&` para `{importPath &&`

### 2. Remover 19 props `installCommand=` das chamadas de `<Section>`
Linhas identificadas (via grep):
- 613, 694, 737, 788, 831, 901, 1021, 1087, 1148, 1212, 1438, 1524, 1585, 1643, 1697, 1763, 1825, 1901, 2498

## Verificação
Após a implementação: confirmar visualmente em http://localhost:8084 que os pills de import path continuam aparecendo e os pills de install command sumiram.

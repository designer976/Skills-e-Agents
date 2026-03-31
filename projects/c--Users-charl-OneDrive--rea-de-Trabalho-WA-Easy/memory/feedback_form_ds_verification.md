---
name: Verificação obrigatória de campos de formulário antes de implementar
description: Antes de implementar qualquer campo de formulário, verificar input.tsx e DesignSystemPage.tsx para garantir espaçamento, asterisco e padrões corretos
type: feedback
---

Sempre verificar `src/components/ui/input.tsx` e a seção Input do `DesignSystemPage.tsx` ANTES de implementar qualquer campo de formulário.

**Why:** Em uma implementação de SalonForm, o `*` obrigatório foi colocado como texto puro em vez de `<span className="text-destructive ml-0.5">*</span>`, e o espaçamento label→input usou `space-y-2` (8px) em vez de `flex flex-col gap-[4px]` (4px) como definido no DS. Isso passou despercebido porque o componente Input já tinha o padrão correto internamente (via prop `label`), mas ao usar Label+Input separados o padrão não foi seguido.

**How to apply:** Toda vez que houver Label+Input separados em formulários:
1. Usar `flex flex-col gap-[4px]` no wrapper (não `space-y-2`)
2. Campos obrigatórios: `<span className="text-destructive ml-0.5">*</span>` no label (não `*` como texto puro)
3. Verificar se o componente já tem prop `label` integrada — se sim, preferir usá-la

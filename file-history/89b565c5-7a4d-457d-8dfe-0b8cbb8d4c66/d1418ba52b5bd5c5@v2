---
name: project-rules
description: Regras e instruções obrigatórias do projeto Rios ID. Ative sempre que um agente precisar de contexto sobre as convenções do projeto antes de implementar qualquer coisa.
---

# Regras do Projeto — Rios ID

> Estas regras são obrigatórias para **todos os agentes e skills**. Qualquer implementação deve seguir estas instruções antes de escrever qualquer código.

---

## 1. Design System é a base de tudo — REGRA INVIOLÁVEL

- **Antes de qualquer implementação**, consulte o Design System:
  - Componentes disponíveis: `components/ui/`
  - Documentação visual: `app/admin/design-system/page.tsx`
  - Tokens de cor e espaçamento: `tailwind.config.ts` e `app/globals.css`

- O DS é o componente **Mestre / Pai**. Toda tela, modal, form e elemento visual do sistema deve herdar seus padrões.

- **Nunca reimplemente** o que já existe no DS. Se o componente existe em `components/ui/`, use-o sem modificar.

### Fidelidade visual obrigatória

O resultado renderizado **deve ser visualmente idêntico** ao demo em `app/admin/design-system/page.tsx`. Qualquer diferença é um defeito a corrigir — sem exceção.

Isso inclui:
- **Casing de texto**: headers de tabela em Title Case (`"Nome do Serviço"`, não `"NOME DO SERVIÇO"`)
- **Props e valores**: usar exatamente as mesmas props que o DS demo usa (variante, tamanho, ícone, label)
- **Espaçamentos e layout**: não adicionar paddings ou margens extras fora dos tokens
- **Ícones**: usar os mesmos ícones mostrados no DS — não substituir por equivalentes
- **Estados visuais**: hover, focus, disabled, destructive — exatamente como o DS demonstra

> **Regra prática**: antes de considerar qualquer implementação concluída, abra `app/admin/design-system/page.tsx`, localize o componente usado e compare visualmente. Se houver qualquer diferença → corrija antes de fechar.

---

## 2. Criação de novos componentes DS

Se a tarefa exigir um componente que **não existe** no DS:

1. O agente **deve perguntar ao usuário** antes de criar:
   > "O componente `XYZ` não existe no DS. Deseja que eu o crie?"
2. Se o usuário confirmar, **ativar o agente `/front-end-ui`** para criar o componente.
3. O novo componente deve ser criado **primeiro** em `components/ui/`.
4. Depois registrar na documentação em `app/admin/design-system/page.tsx`.
5. Só então usar na feature/tela destino.

**Nunca criar componente novo sem aprovação explícita do usuário.**

---

## 3. Tokens obrigatórios do DS

| Categoria | Correto | Proibido |
|-----------|---------|----------|
| Fundo | `bg-background`, `bg-card`, `bg-muted`, `bg-secondary` | `bg-white`, `bg-gray-*`, `bg-zinc-*` |
| Texto | `text-foreground`, `text-muted-foreground` | `text-gray-*`, `text-zinc-*` |
| Borda | `border-border` | `border-gray-*`, `border-zinc-*` |
| Radius | `rounded-lg` | `rounded-xl`, `rounded-2xl`, `rounded-3xl` |
| Hover | `hover:bg-secondary`, `hover:brightness-95` | `hover:bg-blue-*`, `hover:bg-gray-*` |
| Icones | `import { ... } from "lucide-react"` | outras libs de ícones |

**Excecao aceita:** cores semanticas intencionais (`bg-green-500` = sucesso, `bg-red-500` = erro, `bg-yellow-500` = alerta, cores de marca em modais de celebracao/onboarding).

---

## 4. Padrao de Dialog (Modal)

Todo modal de **cadastro / edicao** deve seguir o padrao DS:

```tsx
<DialogContent className="w-[95vw] md:max-w-lg rounded-lg flex flex-col overflow-hidden gap-0">
  <DialogHeader className="border-b pb-3 shrink-0">
    <DialogTitle>Titulo</DialogTitle>
    <DialogDescription>Subtitulo ou instrucao.</DialogDescription>
    {/* TabsList aqui se houver abas */}
  </DialogHeader>

  <div className="flex-1 overflow-y-auto py-4">
    {/* conteudo / form */}
  </div>

  <DialogFooter className="border-t pt-6 shrink-0">
    <Button variant="outline">Cancelar</Button>
    <Button>Salvar</Button>
  </DialogFooter>
</DialogContent>
```

- `DialogContent` usa o `p-6` padrao (nao usar `p-0`)
- Bordas ficam recuadas 24px das bordas do modal (herdam o `p-6`)
- Sempre incluir `DialogDescription`
- Abas (`TabsList`) ficam dentro do `DialogHeader`

---

## 5. Padrao de Formulario

- Labels sempre com `<Label>` do DS
- Campos de erro com `<p className="text-destructive text-xs mt-1">`
- Required marker: `<span className="text-destructive">*</span>`
- Inputs usam `className="w-full"` com o componente `<Input>` do DS
- Spacing entre campos: `space-y-4` ou `space-y-6`

---

## 6. Regras de TypeScript

- **Sem `any`** — sempre criar `interface` ou `type` nomeados
- Props de componentes: `interface NomeProps { ... }`
- Dados de formulario: `interface NomeFormData { ... }`
- Dados de save/submit: `interface NomeSaveData { ... }`
- Retornos de funcao sempre tipados quando nao inferidos automaticamente

---

## 7. Regras de escopo

- **Nunca** alterar arquivos de logica de negocio (services, hooks de dados, APIs)
- **Nunca** modificar arquivos fora do escopo da tarefa
- **Nunca** alterar componentes do DS sem aprovacao explicita
- Alteracoes visuais em componente do DS devem ser propagadas para **todas as instancias**

---

## 8. Qual skill usar

| Situacao | Skill |
|----------|-------|
| Validar spec ou planejar antes de implementar | `/designer` |
| Implementar UI com spec ja pronta | `/front-end-ui` |
| Revisar codigo apos implementacao | `/front-end-code` |
| Implementar + revisar (spec ja validada) | `/all-front-end` |
| Do zero: validar + implementar + revisar | `/all-agents` |
| Consultar regras do projeto | `/project-rules` |

---

## 9. Padrão de Formulário — React Hook Form + Zod

Todos os formulários devem usar `react-hook-form` + `zod`:

```tsx
const schema = z.object({
  name: z.string().min(1, 'Nome obrigatório'),
  email: z.string().email('E-mail inválido'),
})
type FormData = z.infer<typeof schema>

const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<FormData>({
  resolver: zodResolver(schema),
})

// Campos de erro
<p className="text-destructive text-xs mt-1">{errors.name?.message}</p>

// Botão de submit
<Button type="submit" disabled={isSubmitting}>
  {isSubmitting ? 'Salvando…' : 'Salvar'}
</Button>
```

- Nunca usar `useState` para controlar campos de formulário — sempre `register` ou `Controller`
- Nunca validar manualmente — sempre via schema Zod
- `handleSubmit` nunca chama o `onSubmit` se houver erros de validação

---

## 10. Padrões de TanStack Query

### Busca de dados

```tsx
const { data, isLoading, error } = useQuery({
  queryKey: ['recursos', filters],
  queryFn: () => fetchRecursos(filters),
})
```

- `queryKey` deve ser array e incluir todos os filtros que afetam os dados
- Sempre tratar `isLoading` e `error` no componente

### Mutação e invalidação

```tsx
const queryClient = useQueryClient()

const { mutate, isPending } = useMutation({
  mutationFn: createRecurso,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['recursos'] })
    toast.success('Criado com sucesso')
  },
  onError: () => {
    toast.error('Erro ao salvar')
  },
})
```

- Após criar/editar/deletar → sempre `invalidateQueries` da query afetada
- Usar `isPending` no botão de submit durante mutação (não `isLoading`)
- Nunca manipular o estado local manualmente após mutação — deixar a invalidação atualizar

---

## Stack do Projeto

- Next.js 16 + React 19 + TypeScript
- Tailwind CSS + shadcn/ui + Radix UI
- React Hook Form + Zod
- TanStack Query (React Query)
- Next.js App Router (pasta `app/`)
- Lucide React (ícones)
- Sonner (toasts)
- `rounded-lg` = `var(--radius)` = token canônico de border-radius
- Fonte: Plus Jakarta Sans (`var(--font-plus-jakarta)`)

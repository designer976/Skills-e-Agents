# Debugging Sistemático — Iron Law

> Fonte: superpowers:systematic-debugging

## A Lei de Ferro

```
NENHUM FIX SEM INVESTIGAÇÃO DE CAUSA RAIZ PRIMEIRO
```

Se você não completou a Fase 1, não pode propor correções.

## As Quatro Fases

### Fase 1 — Investigação de Causa Raiz (OBRIGATÓRIA)

Antes de qualquer fix:

1. **Leia as mensagens de erro completamente** — stack traces, line numbers, error codes
2. **Reproduza consistentemente** — se não reproduz, colete mais dados, não adivinhe
3. **Verifique mudanças recentes** — git diff, commits recentes, novas dependências
4. **Trace o fluxo de dados** — onde o valor ruim se origina? Trace de volta até a fonte
5. **Em sistemas multi-camada** — adicione instrumentação diagnóstica em cada boundary antes de propor fix

### Fase 2 — Análise de Padrão

- Encontre exemplos funcionando no mesmo codebase
- Compare o que está quebrado com o que funciona
- Liste cada diferença, por menor que seja

### Fase 3 — Hipótese e Teste

- Forme UMA hipótese clara: "Acredito que X é a causa raiz porque Y"
- Faça a MENOR mudança possível para testar
- Uma variável por vez — nunca múltiplos fixes ao mesmo tempo

### Fase 4 — Implementação

- Crie um caso de teste que falha primeiro (TDD)
- Implemente o fix na causa raiz, não no sintoma
- Verifique: o teste passa? Outros testes continuam passando?

**Se ≥ 3 fixes falharam:** PARE e questione a arquitetura — não tente um 4º fix sem conversar com o usuário.

## Red Flags — PARE e volte para Fase 1

- "Fix rápido por agora, investigo depois"
- "Vou tentar mudar X e ver se funciona"
- "Não entendo completamente mas isso pode funcionar"
- Propondo soluções antes de traçar o fluxo de dados
- "Mais uma tentativa de fix" (quando já tentou 2+)

## Racionalizações Comuns

| Desculpa | Realidade |
|----------|-----------|
| "Problema simples, não precisa de processo" | Bugs simples têm causa raiz também |
| "Emergência, sem tempo para processo" | Debugging sistemático é MAIS RÁPIDO que tentativa e erro |
| "Vou escrever o teste depois" | Fixes sem teste não se sustentam |
| "Múltiplos fixes ao mesmo tempo economiza tempo" | Não consegue isolar o que funcionou. Gera novos bugs |

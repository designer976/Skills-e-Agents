# Verificação Antes de Concluir — Iron Law

> Fonte: superpowers:verification-before-completion

## A Lei de Ferro

```
NENHUM CLAIM DE CONCLUSÃO SEM EVIDÊNCIA DE VERIFICAÇÃO FRESCA
```

Se você não executou o comando de verificação nesta mensagem, não pode afirmar que está feito.

## O Gate Obrigatório

```
ANTES de afirmar qualquer status ou expressar satisfação:

1. IDENTIFICAR: Qual comando prova esta afirmação?
2. EXECUTAR: Rodar o comando completo e fresco
3. LER: Output completo, verificar exit code, contar falhas
4. VERIFICAR: O output confirma a afirmação?
   - Se NÃO → informar status real com evidência
   - Se SIM → afirmar com evidência
5. SOMENTE ENTÃO: Fazer a afirmação

Pular qualquer etapa = mentir, não verificar
```

## Red Flags — PARE

- Usar "deveria", "provavelmente", "parece que"
- Expressar satisfação antes de verificar ("Ótimo!", "Perfeito!", "Pronto!")
- Prestes a fazer commit/push/PR sem verificar
- Confiar em reports de agentes sem verificar independentemente
- Pensando "só dessa vez"

## Tabela de Racionalizações

| Desculpa | Realidade |
|----------|-----------|
| "Deve funcionar agora" | EXECUTE a verificação |
| "Estou confiante" | Confiança ≠ evidência |
| "Só dessa vez" | Sem exceções |
| "O agente disse sucesso" | Verifique independentemente |
| "Verificação parcial é suficiente" | Parcial não prova nada |

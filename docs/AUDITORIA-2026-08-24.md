# Auditoria — 24/08/2026

Primeira auditoria do conjunto. Feita ao migrar o repositório para uma árvore limpa.

---

## 1. Incidente que motivou a migração

O repositório anterior (`designer976/Skills-e-Agents`) era **público** e versionava a pasta `~/.claude` inteira: 519 MB, 5.293 arquivos, sem `.gitignore`.

| Diretório | Peso | Conteúdo |
|---|---|---|
| `projects/` | 428 MB | 393 transcripts completos de sessão; nomes de pasta expondo `easy-salon-monorepo`, `Rios-ID`, `Severino`, `Modelo-de-proposta` |
| `file-history/` | 83 MB | 4.146 snapshots de arquivos editados |
| `plugins/` | 7,4 MB | cache do marketplace e clones temporários |
| `history.jsonl` | — | 177 prompts digitados |
| `settings.local.json` | — | 43 regras de permissão da máquina |

**Segredo exposto:** `file-history/02648cc2-.../52b715085056c519@v2` continha um `.env` com `JWT_SECRET`, `JWT_REFRESH_SECRET`, `DATABASE_URL` e outras — 5 variáveis com valor. Outros dois arquivos carregavam um `DATABASE_URL` preenchido. Presente no commit `921cb9c`, ou seja no histórico.

Varredura de chaves de provedor (`sk-ant-`, `sk-proj-`, `ghp_`/`github_pat_`, `AKIA`, `AIza`, JWT `eyJ`, chave PEM, `Bearer`): **nenhuma ocorrência**.

**Ações:**

- [ ] Rotacionar `JWT_SECRET`, `JWT_REFRESH_SECRET` e a senha do banco desse projeto, invalidando as sessões emitidas com os antigos
- [x] Subir esta árvore limpa em repositório novo — feito em 24/08/2026: `designer976/wa-skills`, privado, distribuído como plugin `wa`
- [ ] Apagar ou privatizar `designer976/Skills-e-Agents`

Tornar privado não basta por si: quem clonou antes continua com o segredo, e o objeto segue no histórico.

O `.gitignore` desta árvore ignora tudo por padrão e libera só a fonte. É o que impede a repetição.

---

## 2. Validação das 23 skills

Todas passam no spec da claude.ai — `name` kebab-case igual ao nome da pasta, `description` presente e abaixo de 1.024 caracteres, sem `<` ou `>`, nenhum campo fora de `name`/`description`/`license`/`allowed-tools`/`metadata`/`compatibility`.

**23/23 sem apontamento.** Nada a corrigir.

Descrições entre 112 e 293 caracteres — faixa boa: específica o suficiente para o Claude decidir sozinho, curta o suficiente para não pesar no contexto.

---

## 3. Cobertura real, considerando os plugins ativos

O `settings.json` habilita `superpowers`, `frontend-design`, `github` e `ralph-loop` do marketplace oficial. Isso muda a leitura de cobertura: várias disciplinas já chegam por plugin, sem precisar de skill própria.

| Frente | Como já está coberta |
|---|---|
| Teste | `tester` (doutrina) + plugin `superpowers` (TDD) |
| Revisão de código | `reviewer` + plugin `superpowers` |
| Depuração | `references/debugging.md`, destilado de `superpowers:systematic-debugging` |
| Verificação | `references/verification.md`, mesma origem |
| Front-end | `front-end-ui`, `front-end-code`, `all-front-end` + plugin `frontend-design` |
| Segurança | `security-reviewer`, `security-fixer` |
| Git | `github-integrator` + plugin `github` |
| Conteúdo e SEO | `redator`, `seo-manager` |
| Design | `designer`, `designer-ux` |
| Produto e processo | `analista`, `project-manager`, `project-rules`, `setup-project`, `all-agents`, `inactive-agents`, `atualizar-skill-agent` |
| Infra e dados | `devops`, `database`, `backend`, `pagespeed` |

### Lacunas que sobram

Nada disso existe nem nas 23 skills nem nos 4 plugins ativos:

| Candidata | Origem | Por que consideraria |
|---|---|---|
| `theme-factory` | anthropics/skills, Apache-2.0 | 10 temas de cor e tipografia aplicáveis a artifact, slide, doc e landing. Não vem no plugin `frontend-design` |
| `web-artifacts-builder` | anthropics/skills, Apache-2.0 | Artifacts multi-componente com React, Tailwind e shadcn/ui |
| `webapp-testing` | anthropics/skills, Apache-2.0 | Playwright de verdade contra app local: screenshot e console. Complementa `tester`, que é doutrina e não execução |
| `internal-comms` | anthropics/skills, Apache-2.0 | Status report, update de liderança, relatório de incidente |
| `meeting-insights-analyzer` | ComposioHQ, ⚠ sem licença declarada | Padrão de comunicação a partir de transcrição de reunião |
| `competitive-ads-extractor` | ComposioHQ, ⚠ sem licença declarada | Anúncios de concorrentes nas bibliotecas de Facebook e LinkedIn |

Sem lacuna, e portanto descartadas: `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `brainstorming`, `requesting-code-review`, `receiving-code-review` — tudo isso já chega pelo plugin `superpowers`. E `frontend-design`, que já chega pelo plugin homônimo.

---

## 4. Observações menores

- ~~`skills/references/` fica ao lado das pastas de skill, e `front-end-code` e `reviewer` apontam para lá por caminho relativo.~~ **Resolvido em 24/08/2026:** `references/` foi movido para a raiz do plugin e os dois caminhos passaram a usar `${CLAUDE_PLUGIN_ROOT}/references/`, que o Claude Code resolve independente de onde o plugin esteja instalado.
- A conta claude.ai tem só as 7 skills nativas. Nenhuma das 23 está lá — no app desktop e em sessões cloud nada disto carrega. Disco e conta são independentes.
- `Rios ID` tem uma pasta chamada `~` na raiz, provável resultado de comando que não expandiu o til no Windows.
- `Dooevents\.claude\settings.local.json` está com 178 KB de regras de permissão acumuladas.

---

## 5. Próxima auditoria

Segunda-feira, 09:07. A checagem semanal valida frontmatter, compara com o catálogo `awesome-claude-skills`, vigia o upstream das skills importadas e abre **pull request** — nunca commit direto na `main`, alinhado ao que `github-integrator` exige.

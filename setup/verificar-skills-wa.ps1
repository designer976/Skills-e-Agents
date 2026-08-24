# Verificacao semanal de integridade das skills do plugin wa.
#
# ESTE SCRIPT E DO MANTENEDOR. Quem apenas usa as skills nao precisa dele:
# basta instalar o plugin e rodar `claude plugin update wa@wa-skills`, que ja
# traz o resultado deste trabalho. Aqui se decide o que muda; la se herda.
#
# Checa se as skills continuam validas e se as dependencias externas delas
# (plugins do marketplace oficial) mudaram. Nao altera nenhuma skill: quando
# encontra divergencia, abre uma issue no GitHub descrevendo o que mudou.
#
# Agendado toda sexta as 09:00, separado do atualizar-plugin-wa.ps1 (que roda na segunda).

$ErrorActionPreference = 'Continue'

# Conta que mantem o repositorio. A verificacao escreve no GitHub (abre issue),
# entao so roda para o mantenedor - numa maquina de terceiro abriria issue no
# repositorio alheio ou falharia por falta de permissao.
$MANTENEDOR = 'designer976'

$claude   = "$env:USERPROFILE\.local\bin\claude.exe"
$gh       = "C:\Program Files\GitHub CLI\gh.exe"
$log      = "$env:USERPROFILE\.claude\backups\plugin-update.log"
$baseline = "$env:USERPROFILE\.claude\backups\wa-baseline.json"
$mktplace = "$env:USERPROFILE\.claude\plugins\marketplaces\claude-plugins-official\.claude-plugin\marketplace.json"
$cache    = "$env:USERPROFILE\.claude\plugins\cache"
$repo     = "designer976/wa-skills"

# A copia de trabalho fica sob uma pasta com acento ("Area de Trabalho"), cujo nome
# varia com o idioma do Windows. Localiza por varredura em vez de caminho literal,
# que quebraria na leitura deste arquivo dependendo do encoding.
$repoDir = Get-ChildItem -Path "$env:USERPROFILE\OneDrive" -Directory -ErrorAction SilentlyContinue |
           ForEach-Object { Join-Path $_.FullName 'WA\Skills e Agentes globais' } |
           Where-Object { Test-Path $_ } |
           Select-Object -First 1

function Write-Log($msg) { Add-Content -Path $log -Value $msg -Encoding utf8 }

# Dependencias externas declaradas: o que nas nossas skills depende de que plugin.
# Toda skill que passar a depender de algo externo precisa entrar aqui - senao a
# dependencia nasce fora do radar e o drift passa em silencio.
$DEPS = @(
  @{ plugin = 'superpowers';     motivo = 'references/debugging.md e references/verification.md sao destilados deste plugin' }
  @{ plugin = 'ralph-loop';      motivo = 'front-end-code e reviewer mandam rodar /ralph-loop' }
  @{ plugin = 'frontend-design'; motivo = 'complementa front-end-ui na camada visual' }
  @{ plugin = 'supabase';        motivo = 'database usa o MCP para inspecionar schema e rodar SQL' }
  @{ plugin = 'vercel';          motivo = 'devops e pagespeed usam o MCP para deploy, build status e logs' }
)

# Repositorios de referencia consultados direto no GitHub, fora do marketplace.
# Sao as fontes de onde o nosso material deriva ou de onde vem padrao que vale adotar.
$REPOS_REF = @(
  @{ repo = 'obra/superpowers';  motivo = 'upstream do plugin superpowers, fonte dos destilados em references/' }
  @{ repo = 'anthropics/skills'; motivo = 'repositorio oficial de skills da Anthropic' }
)

# Interfaces de comando que as skills assumem que existem.
$COMANDOS = @(
  @{ plugin = 'ralph-loop'; padrao = '--max-iterations';     usadoPor = 'front-end-code, reviewer' }
  @{ plugin = 'ralph-loop'; padrao = '--completion-promise'; usadoPor = 'front-end-code, reviewer' }
)

# Skills de terceiros que servem de fonte para o nosso material.
$FONTES = @(
  @{ plugin = 'superpowers'; skill = 'systematic-debugging';           usadoPor = 'references/debugging.md' }
  @{ plugin = 'superpowers'; skill = 'verification-before-completion'; usadoPor = 'references/verification.md' }
)

$achados = New-Object System.Collections.ArrayList

Write-Log ""
Write-Log "===== VERIFICACAO $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') ====="

# Guarda: so o mantenedor roda a verificacao.
if (Test-Path $gh) {
  $conta = (& $gh api user --jq '.login' 2>$null)
  if ($LASTEXITCODE -ne 0 -or -not $conta) {
    Write-Log "  gh nao autenticado - esta maquina nao e a do mantenedor. Nada a fazer."
    Write-Log "===== fim ====="
    exit 0
  }
  if ($conta.Trim() -ne $MANTENEDOR) {
    Write-Log "  conta '$($conta.Trim())' nao e o mantenedor ('$MANTENEDOR'). Nada a fazer."
    Write-Log "  Para usar as skills basta: claude plugin update wa@wa-skills"
    Write-Log "===== fim ====="
    exit 0
  }
} else {
  Write-Log "  gh.exe ausente - esta maquina nao e a do mantenedor. Nada a fazer."
  Write-Log "===== fim ====="
  exit 0
}

# ---------------------------------------------------------------- 0. Atualizar o indice
# Sem isso a comparacao roda contra o marketplace.json que o script de segunda baixou,
# e tudo que o upstream publicar de terca a quinta passa despercebido ate a semana seguinte.
Write-Log "-- atualizando indice do marketplace oficial"
& $claude plugin marketplace update claude-plugins-official 2>&1 | ForEach-Object { Write-Log "   $_" }

# ---------------------------------------------------------------- 1. Manifestos e frontmatter
if (Test-Path $repoDir) {
  $saidaRepo = & $claude plugin validate $repoDir 2>&1 | Out-String
  $saidaWa   = & $claude plugin validate (Join-Path $repoDir 'wa') 2>&1 | Out-String
  if ($saidaRepo -match 'Validation failed' -or $saidaWa -match 'Validation failed') {
    $detalhe = (($saidaRepo + $saidaWa) -split "`n" | Where-Object { $_ -match '❯|error' } | Select-Object -First 8) -join "`n"
    [void]$achados.Add("**Validacao falhou** no repositorio local`n``````n$detalhe`n``````")
    Write-Log "  [FALHA] validacao de manifesto/frontmatter"
  } else {
    Write-Log "  [ok] manifestos e frontmatter validos"
  }
} else {
  Write-Log "  [aviso] copia de trabalho nao encontrada em $repoDir - validacao pulada"
}

# ---------------------------------------------------------------- 2. Versoes dos plugins dependidos
$versoes = @{}
$listaTxt = & $claude plugin list 2>&1 | Out-String
foreach ($d in $DEPS) {
  $m = [regex]::Match($listaTxt, [regex]::Escape($d.plugin) + '@[^\r\n]*\r?\n\s*Version:\s*(\S+)')
  if ($m.Success) { $versoes[$d.plugin] = $m.Groups[1].Value } else { $versoes[$d.plugin] = 'ausente' }
}

# ---------------------------------------------------------------- 3. Interface dos comandos usados
foreach ($c in $COMANDOS) {
  $dir = Join-Path $cache "claude-plugins-official\$($c.plugin)"
  if (-not (Test-Path $dir)) {
    [void]$achados.Add("**Plugin ``$($c.plugin)`` nao esta instalado**, mas ``$($c.usadoPor)`` depende dele.")
    continue
  }
  $hit = Get-ChildItem -Path $dir -Recurse -File -Include *.md -ErrorAction SilentlyContinue |
         Select-String -SimpleMatch $c.padrao -List | Select-Object -First 1
  if (-not $hit) {
    [void]$achados.Add("**Flag ``$($c.padrao)`` sumiu do plugin ``$($c.plugin)``** - usada por ``$($c.usadoPor)``. As skills mandam rodar um comando que pode nao existir mais.")
    Write-Log "  [DRIFT] flag $($c.padrao) nao encontrada em $($c.plugin)"
  } else {
    Write-Log "  [ok] flag $($c.padrao) presente em $($c.plugin)"
  }
}

# ---------------------------------------------------------------- 4. Skills-fonte dos destilados
foreach ($f in $FONTES) {
  $dir = Join-Path $cache "claude-plugins-official\$($f.plugin)"
  $existe = $false
  if (Test-Path $dir) {
    $existe = [bool](Get-ChildItem -Path $dir -Recurse -Directory -ErrorAction SilentlyContinue |
                     Where-Object { $_.Name -eq $f.skill } | Select-Object -First 1)
  }
  if (-not $existe) {
    [void]$achados.Add("**Skill-fonte ``$($f.plugin):$($f.skill)`` nao encontrada** - ``$($f.usadoPor)`` foi destilado dela.")
    Write-Log "  [DRIFT] skill-fonte $($f.plugin):$($f.skill) ausente"
  } else {
    Write-Log "  [ok] skill-fonte $($f.plugin):$($f.skill) presente"
  }
}

# ---------------------------------------------------------------- 5. Marketplace oficial
# ConvertFrom-Json do PowerShell 5.1 recusa este arquivo: ele tem chaves duplicadas
# e o parser lanca excecao em vez de manter a ultima ocorrencia. Python resolve.
$pluginsMkt = @()
if (Test-Path $mktplace) {
  $python = (Get-Command python -ErrorAction SilentlyContinue).Source
  if ($python) {
    # One-liner com ';' - codigo multilinha via -c nao sobrevive a passagem pelo PowerShell.
    $code = "import json,io,sys; d=json.load(io.open(sys.argv[1],encoding='utf-8')); print('|'.join(p['name'] for p in d['plugins']))"
    $saida = & $python -c $code $mktplace 2>$null
    if ($LASTEXITCODE -eq 0 -and $saida) {
      $pluginsMkt = @($saida -split '\|' | Where-Object { $_ -ne '' })
      Write-Log "  [ok] marketplace oficial lido - $($pluginsMkt.Count) plugins"
    } else {
      Write-Log "  [aviso] falha ao ler o marketplace oficial"
    }
  } else {
    Write-Log "  [aviso] python nao encontrado - checagem de plugins novos pulada"
  }
}

# ---------------------------------------------------------------- Comparar com a semana passada
$anterior = $null
if (Test-Path $baseline) {
  try { $anterior = Get-Content $baseline -Raw -Encoding utf8 | ConvertFrom-Json } catch { $anterior = $null }
}

if ($anterior) {
  foreach ($d in $DEPS) {
    $antes = $anterior.versoes.($d.plugin)
    $agora = $versoes[$d.plugin]
    if ($antes -and $agora -and $antes -ne $agora) {
      [void]$achados.Add("**``$($d.plugin)`` mudou de ``$antes`` para ``$agora``** - $($d.motivo). Vale reler o material derivado.")
      Write-Log "  [DRIFT] $($d.plugin): $antes -> $agora"
    }
  }
  if ($anterior.marketplace -and $pluginsMkt.Count -gt 0) {
    $novos = @($pluginsMkt | Where-Object { $anterior.marketplace -notcontains $_ })
    if ($novos.Count -gt 0) {
      $lista = ($novos | ForEach-Object { "``$_``" }) -join ', '
      [void]$achados.Add("**$($novos.Count) plugin(s) novo(s) no marketplace oficial**: $lista - vale conferir se algum cobre lacuna das nossas skills.")
      Write-Log "  [novo] $($novos.Count) plugin(s) no marketplace"
    }
  }
} else {
  Write-Log "  [info] primeira execucao - baseline criado, sem comparacao"
}

# ---------------------------------------------------------------- Commits das dependencias
# Guardar o sha permite que /wa:manter-skills faca `gh api repos/<owner>/<repo>/compare/<antes>...<agora>`
# e mostre exatamente o que mudou na fonte, em vez de so dizer que a versao subiu.
$shas = @{}
if ((Test-Path $mktplace) -and $python) {
  $codeSha = "import json,io,sys; d=json.load(io.open(sys.argv[1],encoding='utf-8')); alvo={'superpowers','ralph-loop','frontend-design'}; print('|'.join(p['name']+'='+p['source'].get('url','')+'@'+p['source'].get('sha','') for p in d['plugins'] if p['name'] in alvo and isinstance(p['source'],dict)))"
  $saidaSha = & $python -c $codeSha $mktplace 2>$null
  if ($LASTEXITCODE -eq 0 -and $saidaSha) {
    foreach ($par in ($saidaSha -split '\|' | Where-Object { $_ -ne '' })) {
      $nome, $resto = $par -split '=', 2
      $shas[$nome] = $resto
    }
    Write-Log "  [ok] commits capturados para $($shas.Keys.Count) dependencia(s)"
  }
}

if ($anterior -and $anterior.shas) {
  foreach ($k in @($shas.Keys)) {
    $antesSha = $anterior.shas.$k
    if ($antesSha -and $shas[$k] -and $antesSha -ne $shas[$k]) {
      $urlAntes = ($antesSha -split '@')[0] -replace '^https://github\.com/','' -replace '\.git$',''
      $s1 = ($antesSha -split '@')[1]; $s2 = ($shas[$k] -split '@')[1]
      if ($s1 -and $s2) {
        [void]$achados.Add("**``$k`` mudou de commit** - para ver o que mudou na fonte:`n``````bash`ngh api repos/$urlAntes/compare/$s1...$s2 --jq '.files[].filename'`n``````")
        Write-Log "  [DRIFT] $k mudou de commit"
      }
    }
  }
}

# ---------------------------------------------------------------- Repositorios de referencia
# Consultados direto no GitHub. Guarda-se o sha do ultimo commit e, quando o repo tem pasta
# skills/, a lista de skills - assim da para dizer o que entrou e o que saiu, nao so que mudou.
$refs = @{}
if (Test-Path $gh) {
  foreach ($r in $REPOS_REF) {
    $nome = $r.repo
    $sha = (& $gh api "repos/$nome/commits" --jq '.[0].sha' 2>$null)
    if ($LASTEXITCODE -ne 0 -or -not $sha) { Write-Log "  [aviso] nao foi possivel ler $nome"; continue }

    # Sem aspas duplas dentro do --jq: o PowerShell as remove ao repassar, e o jq recebe
    # select(.type==dir), tratando `dir` como funcao inexistente. Filtra-se aqui em vez de la.
    $skills = @()
    $saidaS = & $gh api "repos/$nome/contents/skills" --jq '.[].name' 2>$null
    if ($LASTEXITCODE -eq 0 -and $saidaS) {
      $skills = @($saidaS -split "`r?`n" | Where-Object { $_ -ne '' -and $_ -notmatch '\.' })
    }
    $refs[$nome] = @{ sha = $sha.Trim(); skills = $skills }
    Write-Log "  [ok] $nome lido - $($skills.Count) skills, sha $($sha.Trim().Substring(0,8))"
  }
}

if ($anterior -and $anterior.refs) {
  foreach ($r in $REPOS_REF) {
    $nome = $r.repo
    $ant = $anterior.refs.$nome
    $ag  = $refs[$nome]
    if (-not $ant -or -not $ag) { continue }

    if ($ant.sha -and $ag.sha -and $ant.sha -ne $ag.sha) {
      [void]$achados.Add("**``$nome`` tem commits novos** - $($r.motivo). Para ver o que mudou:`n``````bash`ngh api repos/$nome/compare/$($ant.sha)...$($ag.sha) --jq '.files[].filename'`n``````")
      Write-Log "  [DRIFT] $nome mudou de commit"
    }

    if ($ant.skills -and $ag.skills.Count -gt 0) {
      $novas = @($ag.skills | Where-Object { $ant.skills -notcontains $_ })
      if ($novas.Count -gt 0) {
        $lista = ($novas | ForEach-Object { "``$_``" }) -join ', '
        [void]$achados.Add("**$($novas.Count) skill(s) nova(s) em ``$nome``**: $lista - vale ver se alguma cobre lacuna nossa ou traz padrao que valha adotar.")
        Write-Log "  [novo] $($novas.Count) skill(s) em $nome"
      }
      $saiu = @($ant.skills | Where-Object { $ag.skills -notcontains $_ })
      if ($saiu.Count -gt 0) {
        $lista = ($saiu | ForEach-Object { "``$_``" }) -join ', '
        [void]$achados.Add("**Skill(s) removida(s) de ``$nome``**: $lista - se derivamos algo delas, a fonte deixou de existir.")
        Write-Log "  [DRIFT] $($saiu.Count) skill(s) removida(s) de $nome"
      }
    }
  }
}

# ---------------------------------------------------------------- Salvar baseline
$novoBaseline = [ordered]@{
  data        = (Get-Date -Format 'yyyy-MM-dd')
  versoes     = $versoes
  shas        = $shas
  marketplace = $pluginsMkt
  refs        = $refs
}
$novoBaseline | ConvertTo-Json -Depth 4 | Out-File -FilePath $baseline -Encoding utf8

# ---------------------------------------------------------------- Reportar
if ($achados.Count -eq 0) {
  Write-Log "===== VERIFICACAO OK - nenhum drift ====="
  exit 0
}

Write-Log "===== VERIFICACAO ENCONTROU $($achados.Count) ITEM(NS) ====="

if (-not (Test-Path $gh)) { Write-Log "  gh.exe nao encontrado - issue nao criada"; exit 0 }

$hoje  = (Get-Date -Format 'dd/MM/yyyy')
$corpo = "Verificacao automatica de $hoje encontrou $($achados.Count) item(ns) que merecem atencao.`n`n"
foreach ($a in $achados) { $corpo += "- $a`n" }
$corpo += "`n---`n`nGerado por ``setup/verificar-skills-wa.ps1``, agendado toda sexta as 09:00. "
$corpo += "Nenhuma skill foi alterada - esta issue e so o aviso.`n"

$tmp = Join-Path $env:TEMP "wa-drift-$(Get-Random).md"
$corpo | Out-File -FilePath $tmp -Encoding utf8

& $gh issue create --repo $repo --title "Verificacao semanal $hoje - $($achados.Count) item(ns) de atencao" --body-file $tmp 2>&1 |
  ForEach-Object { Write-Log "  $_" }

Remove-Item $tmp -ErrorAction SilentlyContinue
Write-Log "===== fim ====="

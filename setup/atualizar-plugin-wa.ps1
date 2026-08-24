# Atualiza o plugin wa e carimba as datas na descricao do repositorio.
# Agendado semanalmente pelo Agendador de Tarefas do Windows.

$claude = "$env:USERPROFILE\.local\bin\claude.exe"
$gh     = "C:\Program Files\GitHub CLI\gh.exe"
$log    = "$env:USERPROFILE\.claude\backups\plugin-update.log"
$repo   = "designer976/wa-skills"

function Write-Log($msg) { Add-Content -Path $log -Value $msg -Encoding utf8 }

Write-Log ""
Write-Log "===== $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss') ====="

if (-not (Test-Path $claude)) { Write-Log "ERRO: claude.exe nao encontrado em $claude"; exit 1 }

Write-Log "-- marketplace update"
& $claude plugin marketplace update wa-skills 2>&1 | ForEach-Object { Write-Log "   $_" }

Write-Log "-- plugin update"
$antes = (& $claude plugin list 2>&1 | Select-String -Pattern 'Version: (\S+)' -Context 1,0 |
          Where-Object { $_.Context.PreContext -match 'wa@wa-skills' }).Matches.Groups[1].Value
& $claude plugin update wa@wa-skills 2>&1 | ForEach-Object { Write-Log "   $_" }
$depois = (& $claude plugin list 2>&1 | Select-String -Pattern 'Version: (\S+)' -Context 1,0 |
           Where-Object { $_.Context.PreContext -match 'wa@wa-skills' }).Matches.Groups[1].Value

if ($antes -ne $depois) { Write-Log "   versao: $antes -> $depois" } else { Write-Log "   versao: $depois (sem mudanca)" }

# ---------------------------------------------------------------- Plugins externos
# Arquivos de terceiros, que nao editamos - atualizar e sempre seguro, sem aprovacao.
# Nosso material derivado deles (wa/references/*.md) e outra coisa: e sintese adaptada,
# e so muda com aprovacao, pelo fluxo de /wa:manter-skills.
#
# Ressalva: `claude plugin update` compara o campo `version`, nao o commit. Upstream que
# publica mudanca sem subir a versao passa despercebido aqui - quem pega isso e a
# verificacao de sexta, que rastreia o sha.
$EXTERNOS = @('superpowers', 'frontend-design', 'ralph-loop')

Write-Log "-- plugins externos (marketplace oficial)"
& $claude plugin marketplace update claude-plugins-official 2>&1 | ForEach-Object { Write-Log "   $_" }
foreach ($ext in $EXTERNOS) {
  $saida = & $claude plugin update "$ext@claude-plugins-official" 2>&1 | Out-String
  $linha = ($saida -split "`r?`n" | Where-Object { $_ -match 'updated from|latest version|not found|Error' } | Select-Object -First 1)
  if ($linha) { Write-Log "   $($ext): $($linha.Trim())" } else { Write-Log "   $($ext): sem retorno" }
}

# Daqui para baixo e trabalho de mantenedor: escreve na descricao do repositorio.
# Numa maquina que apenas consome as skills, o update acima ja fez todo o servico.
if (-not (Test-Path $gh)) { Write-Log "-- gh.exe ausente - update concluido, descricao nao atualizada"; exit 0 }

$conta = (& $gh api user --jq '.login' 2>$null)
if ($LASTEXITCODE -ne 0 -or -not $conta -or $conta.Trim() -ne 'designer976') {
  Write-Log "-- maquina nao e a do mantenedor - update concluido, descricao nao atualizada"
  Write-Log "===== fim ====="
  exit 0
}

# Data da ultima atualizacao = data do ultimo commit no repositorio.
$commitISO = & $gh api "repos/$repo/commits" --jq '.[0].commit.committer.date' 2>$null
if ($LASTEXITCODE -ne 0 -or -not $commitISO) { Write-Log "-- nao foi possivel ler o ultimo commit"; exit 0 }

$atualizado = ([datetime]$commitISO).ToLocalTime().ToString('dd/MM/yyyy')
$verificado = (Get-Date).ToString('dd/MM/yyyy')
$desc = "Plugin de skills e agentes da WA Project para Claude Code | v$depois | atualizado em $atualizado | verificado em $verificado"

& $gh repo edit $repo --description $desc 2>&1 | ForEach-Object { Write-Log "   $_" }
Write-Log "-- descricao: $desc"
Write-Log "===== fim ====="

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

if (-not (Test-Path $gh)) { Write-Log "-- gh.exe nao encontrado, descricao nao atualizada"; exit 0 }

# Data da ultima atualizacao = data do ultimo commit no repositorio.
$commitISO = & $gh api "repos/$repo/commits" --jq '.[0].commit.committer.date' 2>$null
if ($LASTEXITCODE -ne 0 -or -not $commitISO) { Write-Log "-- nao foi possivel ler o ultimo commit"; exit 0 }

$atualizado = ([datetime]$commitISO).ToLocalTime().ToString('dd/MM/yyyy')
$verificado = (Get-Date).ToString('dd/MM/yyyy')
$desc = "Plugin de skills e agentes da WA Project para Claude Code | v$depois | atualizado em $atualizado | verificado em $verificado"

& $gh repo edit $repo --description $desc 2>&1 | ForEach-Object { Write-Log "   $_" }
Write-Log "-- descricao: $desc"
Write-Log "===== fim ====="

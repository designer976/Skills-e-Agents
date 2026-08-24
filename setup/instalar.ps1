# Instalador das skills da WA. Uma execucao deixa a maquina pronta:
# marketplace, plugin e atualizacao automatica semanal.
#
#   powershell -ExecutionPolicy Bypass -File instalar.ps1
#
# Opcoes:
#   -SemAgendamento   instala o plugin mas nao registra a tarefa semanal
#   -Dia <dia>        dia da atualizacao automatica (padrao: Monday)
#   -Hora <hh:mm>     horario da atualizacao automatica (padrao: 09:00)
#   -Remover          desinstala o plugin e remove a tarefa agendada

param(
  [switch]$SemAgendamento,
  [ValidateSet('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday')]
  [string]$Dia = 'Monday',
  [string]$Hora = '09:00',
  [switch]$Remover
)

$ErrorActionPreference = 'Stop'

$claude    = "$env:USERPROFILE\.local\bin\claude.exe"
$scripts   = "$env:USERPROFILE\.claude\scripts"
$backups   = "$env:USERPROFILE\.claude\backups"
$tarefa    = 'Claude - Atualizar plugin wa'
$repo      = 'designer976/wa-skills'
$plugin    = 'wa@wa-skills'
$origem    = Split-Path -Parent $MyInvocation.MyCommand.Path

$DIA_PT = @{
  Monday = 'segunda'; Tuesday = 'terca'; Wednesday = 'quarta'; Thursday = 'quinta'
  Friday = 'sexta';   Saturday = 'sabado'; Sunday = 'domingo'
}
$diaPt = $DIA_PT[$Dia]

function Passo($n, $txt) { Write-Host ""; Write-Host "[$n] $txt" -ForegroundColor Cyan }
function Ok($txt)        { Write-Host "    OK  $txt" -ForegroundColor Green }
function Aviso($txt)     { Write-Host "    !   $txt" -ForegroundColor Yellow }
function Erro($txt)      { Write-Host "    X   $txt" -ForegroundColor Red }

# ------------------------------------------------------------------ Remover
if ($Remover) {
  Passo 1 "Removendo tarefa agendada"
  try {
    Unregister-ScheduledTask -TaskName $tarefa -Confirm:$false -ErrorAction Stop
    Ok "tarefa '$tarefa' removida"
  } catch { Aviso "tarefa nao estava registrada" }

  Passo 2 "Desinstalando plugin"
  & $claude plugin uninstall $plugin 2>&1 | ForEach-Object { Write-Host "    $_" }

  Write-Host ""
  Write-Host "Removido. Reinicie o Claude Code para aplicar." -ForegroundColor Green
  exit 0
}

# ------------------------------------------------------------------ Pre-requisitos
Passo 1 "Verificando pre-requisitos"
if (-not (Test-Path $claude)) {
  Erro "claude.exe nao encontrado em $claude"
  Write-Host "        Instale o Claude Code antes de rodar este script."
  exit 1
}
Ok "claude.exe encontrado"

foreach ($d in @($scripts, $backups)) {
  if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
}
Ok "diretorios prontos"

# ------------------------------------------------------------------ Marketplace e plugin
Passo 2 "Registrando o marketplace"
$mkt = & $claude plugin marketplace list 2>&1 | Out-String
if ($mkt -match 'wa-skills') {
  & $claude plugin marketplace update wa-skills 2>&1 | ForEach-Object { Write-Host "    $_" }
  Ok "marketplace ja existia, indice atualizado"
} else {
  & $claude plugin marketplace add $repo 2>&1 | ForEach-Object { Write-Host "    $_" }
  Ok "marketplace adicionado"
}

Passo 3 "Instalando o plugin"
$lista = & $claude plugin list 2>&1 | Out-String
if ($lista -match 'wa@wa-skills') {
  & $claude plugin update $plugin 2>&1 | ForEach-Object { Write-Host "    $_" }
  Ok "plugin ja estava instalado, atualizado"
} else {
  & $claude plugin install $plugin 2>&1 | ForEach-Object { Write-Host "    $_" }
  Ok "plugin instalado"
}

# ------------------------------------------------------------------ Script de update
Passo 4 "Copiando o script de atualizacao"
$src = Join-Path $origem 'atualizar-plugin-wa.ps1'
if (Test-Path $src) {
  Copy-Item $src (Join-Path $scripts 'atualizar-plugin-wa.ps1') -Force
  Ok "atualizar-plugin-wa.ps1 -> $scripts"
} else {
  Erro "atualizar-plugin-wa.ps1 nao encontrado ao lado deste script"
  exit 1
}

# ------------------------------------------------------------------ Agendamento
if ($SemAgendamento) {
  Passo 5 "Agendamento pulado (-SemAgendamento)"
  Aviso "atualize quando quiser com: claude plugin update $plugin"
} else {
  Passo 5 "Agendando a atualizacao automatica"
  try {
    $acao = New-ScheduledTaskAction -Execute 'powershell.exe' `
      -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$scripts\atualizar-plugin-wa.ps1`""
    $gatilho = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $Dia -At $Hora
    $config  = New-ScheduledTaskSettingsSet -StartWhenAvailable -DontStopIfGoingOnBatteries `
      -AllowStartIfOnBatteries -ExecutionTimeLimit (New-TimeSpan -Minutes 20)

    try { Unregister-ScheduledTask -TaskName $tarefa -Confirm:$false -ErrorAction Stop } catch {}

    Register-ScheduledTask -TaskName $tarefa -Action $acao -Trigger $gatilho -Settings $config `
      -Description "Puxa a versao publicada do plugin wa. Toda $diaPt as $Hora." | Out-Null

    $prox = (Get-ScheduledTaskInfo -TaskName $tarefa).NextRunTime
    Ok "tarefa registrada - toda $diaPt as $Hora (proxima: $prox)"
  } catch {
    Aviso "nao foi possivel agendar: $($_.Exception.Message)"
    Aviso "o plugin esta instalado; atualize com: claude plugin update $plugin"
  }
}

# ------------------------------------------------------------------ Resumo
$versao = 'desconhecida'
$m = [regex]::Match((& $claude plugin list 2>&1 | Out-String), 'wa@wa-skills[^\r\n]*\r?\n\s*Version:\s*(\S+)')
if ($m.Success) { $versao = $m.Groups[1].Value }

Write-Host ""
Write-Host "======================================================" -ForegroundColor Green
Write-Host " Skills da WA instaladas - plugin wa v$versao" -ForegroundColor Green
Write-Host "======================================================" -ForegroundColor Green
Write-Host ""
Write-Host " Reinicie o Claude Code para os comandos aparecerem."
Write-Host ""
Write-Host " Uso......: /wa:analista, /wa:designer, /wa:backend ..."
Write-Host " Atualizar: /wa:atualizar-skill-agent  (ou o comando abaixo)"
Write-Host "            claude plugin update $plugin"
if (-not $SemAgendamento) {
  Write-Host " Automatico: toda $diaPt as $Hora"
}
Write-Host " Log......: $backups\plugin-update.log"
Write-Host ""

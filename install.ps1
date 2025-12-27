#!/usr/bin/env pwsh

param(
  [switch]$withDebloat
)

$baseURL = "https://raw.githubusercontent.com/llgava/w11-setup/refs/heads/main"

$options = @(
  "Basic       `e[90m * Only common apps will be install`e[37m",
  "Development `e[90m * Development apps and tools will be install`e[37m"
)
$selectedIndex = 0

function Render-ASCII {
  try {
    $asciiContent = Invoke-RestMethod -Uri "$baseURL/config/ascii.txt"
    if ($asciiContent -is [array]) {
      $asciiContent | ForEach-Object { Write-Host $_ }
    } else {
      Write-Host $asciiContent
    }
    Write-Host "`n"  # Linha em branco depois do ASCII
  } catch {
    Write-Host "Arquivo ascii.txt não encontrado.`n" -ForegroundColor Yellow
  }
}

Render-ASCII
function Render-Menu {
  Clear-Host
  Render-ASCII
  
  Write-Host "What type of use the system will have?" -ForegroundColor Yellow
  Write-Host "`e[90mNote: Use ↑ and ↓ to navigate and Enter to select`n"
  for ($i = 0; $i -lt $options.Count; $i++) {
    if ($i -eq $selectedIndex) {
      Write-Host "» $($options[$i])" -ForegroundColor Green
    } else {
      Write-Host "  $($options[$i])"
    }
  }
}

while ($true) {
  Render-Menu
  $ki = [Console]::ReadKey($true)

  # Move selection
  switch ($ki.Key) {
    'UpArrow'   { if ($selectedIndex -gt 0) { $selectedIndex-- } }
    'DownArrow' { if ($selectedIndex -lt ($options.Count - 1)) { $selectedIndex++ } }
  }

  if ($ki.Key -eq 'Enter' -or $ki.KeyChar -eq "`r" -or $ki.KeyChar -eq "`n") {
    break
  }
}

# Download and execute scripts from GitHub
if ($selectedIndex -eq 1) {
  $devScript = Invoke-RestMethod -Uri "$baseURL/scripts/devEnvironment.ps1"
  & ([scriptblock]::Create($devScript))
}

$mandatoryScript = Invoke-RestMethod -Uri "$baseURL/scripts/mandatory.ps1"
& ([scriptblock]::Create($mandatoryScript))

if ($withDebloat) {
  Write-Host "[info]" -NoNewline -ForegroundColor Yellow
  Write-Host " Executing debloat script..." -ForegroundColor White
  & ([scriptblock]::Create((Invoke-RestMethod "https://debloat.raphi.re/"))) -RunDefaults -Silent

  $done = "`e[32m[done]`e[37m"
  Write-Host "$done Debloat script executed."
}

Write-Host "[info]" -NoNewline -ForegroundColor Yellow
Write-Host " Executing NVMe performance script..." -ForegroundColor White
reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides /v 1176759950 /t REG_DWORD /d 1 /f
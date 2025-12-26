#!/usr/bin/env pwsh
# Carregar common.ps1 do GitHub
$commonScript = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/llgava/w11-setup/refs/heads/main/scripts/common.ps1"
. ([scriptblock]::Create($commonScript))

Write-Host ""
Write-Host "Running development packages instalation..."

# Baixar configuração do GitHub
$config = Invoke-RestMethod -Uri "$script:baseURL/config/development.json"
$packages = $config.packages
$npmGlobalPackages = $config.npmGlobalPackages
$ohMyPoshTheme = $config.ohMyPoshTheme

$label1 = "Installing development packages"
$label2 = "Installing NodeJS global packages"

$progressId1 = 1
$progressId2 = 2

for ($i = 0; $i -lt $packages.Count; $i++) {
  $package = $packages[$i]
  Install-WingetPackage -package $package -label $label1 -index $i -allPackages $packages -progressId $progressId1
}

Write-Progress -Id $progressId1 -Activity $label1 -Completed
Write-Host "$done Development packages installed!"

# Check if NodeJS are installed and try to install npm global packages
if ($packages -contains "OpenJS.NodeJS.LTS") {
  Write-Host "$info NodeJS found! Instaling global npm packages."
  Start-Sleep -Seconds 2

  for ($i = 0; $i -lt $npmGlobalPackages.Count; $i++) {
    $package = $npmGlobalPackages[$i]

    ProgressBar-PackageInstalation -label $label2 -i $i -packages $npmGlobalPackages -id $progressId2
      
    $alreadyInstalled = npm list -g --depth=0 $package 2>$null
    if ($LASTEXITCODE -ne 0) {
      npm install -g $package --silent
    }
  }

  Write-Progress -Id $progressId2 -Activity $label2 -Completed
  Write-Host "$done Global npm packages installed!"
}

# Check if NodeJS are installed and try to apply configured theme
if ($packages -contains "JanDeDobbeleer.OhMyPosh" -and $ohMyPoshTheme) {
  Write-Host "$info Oh My Posh found! Installing theme: $ohMyPoshTheme"
  Start-Sleep -Seconds 2

  # TODO
}
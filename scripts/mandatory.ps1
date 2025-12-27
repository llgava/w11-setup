#!/usr/bin/env pwsh

# common.ps1
$commonScript = Invoke-RestMethod -Uri "https://raw.githubusercontent.com/llgava/w11-setup/refs/heads/main/scripts/common.ps1"
. ([scriptblock]::Create($commonScript))

Write-Host ""
Write-Host "Running mandatory packages instalation..."

# Download mandatory packages.
$config = Invoke-RestMethod -Uri "$script:baseURL/config/mandatory.json"
$packages = $config.packages

$label = "Installing mandatory packages"
$progress = 1

for ($i = 0; $i -lt $packages.Count; $i++) {
  $package = $packages[$i]
  Install-WingetPackage -package $package -label $label -index $i -allPackages $packages -progressId $progress
}

Write-Progress -Id $progress -Activity $label -Completed
Write-Host "$done Mandatory packages installed!"


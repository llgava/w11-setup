#!/usr/bin/env pwsh
. "$PSScriptRoot\common.ps1"

Write-Host ""
Write-Host "Running mandatory packages instalation..."

$configPath = "$PSScriptRoot\..\config\mandatory.json"
$config = Get-Content -Path $configPath | ConvertFrom-Json
$packages = $config.packages

$label = "Installing mandatory packages"
$progress = 1

for ($i = 0; $i -lt $packages.Count; $i++) {
  $package = $packages[$i]
  Install-WingetPackage -package $package -label $label -index $i -allPackages $packages -progressId $progress
}

Write-Progress -Id $progress -Activity $label -Completed
Write-Host "$done Mandatory packages installed!"


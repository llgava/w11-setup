$script:info = "`e[33m[info]`e[37m"
$script:done = "`e[32m[done]`e[37m"
$script:baseURL = "https://raw.githubusercontent.com/llgava/w11-setup/refs/heads/main"

# Progress Bar instalation
function ProgressBar-PackageInstalation {
  param(
    [string]$label,
    [int]$i,
    [array]$packages,
    [int]$id = 0
  )
  
  $package = $packages[$i]
  $total = $packages.Count
  $humanIndex = $i + 1
  $prettyCount = "$humanIndex/$total"
  
  $percentage = ((($humanIndex) / $total) * 100)
  $prettyPercentage = [Math]::Round($percentage, 0)

  Write-Progress `
    -Id $id `
    -Activity "$script:info $label ($prettyCount)`e[32m" `
    -Status " $prettyPercentage% $package " `
    -PercentComplete $percentage
}

# Generic Install Package method with progress bar.
function Install-WingetPackage {
  param(
    [string]$package,
    [string]$label,
    [int]$index,
    [array]$allPackages,
    [int]$progressId = 0
  )
  
  ProgressBar-PackageInstalation -label $label -i $index -packages $allPackages -id $progressId
  
  $alreadyInstalled = winget list --exact --id $package 2>$null
  
  if (-not $alreadyInstalled) {
    winget install $package --source winget --silent --accept-package-agreements --accept-source-agreements --exact *> $null
  }
}

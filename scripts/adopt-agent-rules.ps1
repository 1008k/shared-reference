param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo = (Split-Path $PSScriptRoot -Parent),
  [string]$Ref = "main",
  [string]$RepoUrl = "https://github.com/1008k/shared-reference.git",
  [switch]$DryRun
)

$script = Join-Path $PSScriptRoot "adopt-shared-reference.ps1"
& $script -ProjectRoot $ProjectRoot -SharedRepo $SharedRepo -Ref $Ref -RepoUrl $RepoUrl -DryRun:$DryRun

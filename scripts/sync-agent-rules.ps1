param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo,
  [string]$Ref,
  [string]$LockPath,
  [string]$CloneRoot = (Split-Path (Get-Location).Path -Parent),
  [switch]$Force,
  [switch]$DryRun
)

$script = Join-Path $PSScriptRoot "sync-shared-reference.ps1"
& $script -ProjectRoot $ProjectRoot -SharedRepo $SharedRepo -Ref $Ref -LockPath $LockPath -Force:$Force -DryRun:$DryRun

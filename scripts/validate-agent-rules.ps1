param(
  [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$script = Join-Path $PSScriptRoot "validate-shared-reference.ps1"
& $script -RepoRoot $RepoRoot

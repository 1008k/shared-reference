param(
  [Parameter(Mandatory = $true)]
  [string]$VendorPath,
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo,
  [string]$CloneRoot = (Split-Path (Get-Location).Path -Parent),
  [switch]$ApplyVendorDiff
)

$script = Join-Path $PSScriptRoot "propose-shared-reference-change.ps1"
& $script -VendorPath $VendorPath -ProjectRoot $ProjectRoot -SharedRepo $SharedRepo -CloneRoot $CloneRoot -ApplyVendorDiff:$ApplyVendorDiff

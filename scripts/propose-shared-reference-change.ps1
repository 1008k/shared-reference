param(
  [Parameter(Mandatory = $true)]
  [string]$VendorPath,
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo,
  [string]$CloneRoot = (Split-Path (Get-Location).Path -Parent),
  [switch]$ApplyVendorDiff
)

$ErrorActionPreference = "Stop"

function Read-LockValue([string]$Path, [string]$Key) {
  if (!(Test-Path $Path)) { return $null }
  $pattern = "^\s*$([regex]::Escape($Key)):\s*(.+?)\s*$"
  $match = Select-String -Path $Path -Pattern $pattern | Select-Object -First 1
  if (!$match) { return $null }
  return $match.Matches[0].Groups[1].Value.Trim('"').Trim("'")
}

function Get-ManagedSourcePath([string]$Path) {
  $match = Select-String -Path $Path -Pattern 'source-path:\s*(.+?)(?:\s*-->|\s*$)' | Select-Object -First 1
  if (!$match) { throw "No shared-reference source-path header found in $Path" }
  return $match.Matches[0].Groups[1].Value.Trim()
}

$lockPath = Join-Path $ProjectRoot ".shared/shared-reference.lock.yaml"
if (!(Test-Path $lockPath)) {
  $legacyLockPath = Join-Path $ProjectRoot ".shared/agent-rules.lock.yaml"
  if (Test-Path $legacyLockPath) { $lockPath = $legacyLockPath }
}
if (!(Test-Path $lockPath)) {
  $legacyLockPath = Join-Path $ProjectRoot ".agents/shared-rules.lock.yaml"
  if (Test-Path $legacyLockPath) { $lockPath = $legacyLockPath }
}
if (!$SharedRepo) { $SharedRepo = Read-LockValue $lockPath "local_path" }
if (!$SharedRepo) { $SharedRepo = Join-Path $CloneRoot "shared-reference" }
if (![IO.Path]::IsPathRooted($SharedRepo)) { $SharedRepo = Join-Path $ProjectRoot $SharedRepo }
$SharedRepo = [IO.Path]::GetFullPath($SharedRepo)

if (!(Test-Path $SharedRepo)) {
  $repoUrl = Read-LockValue $lockPath "repo"
  if (!$repoUrl) { $repoUrl = "https://github.com/1008k/shared-reference.git" }
  New-Item -ItemType Directory -Force $CloneRoot | Out-Null
  & git clone $repoUrl $SharedRepo
  if ($LASTEXITCODE -ne 0) { throw "Could not clone shared repo: $repoUrl" }
}

$fullVendorPath = if ([IO.Path]::IsPathRooted($VendorPath)) { $VendorPath } else { Join-Path $ProjectRoot $VendorPath }
if (!(Test-Path $fullVendorPath)) { throw "Vendor file not found: $fullVendorPath" }

$sourcePath = Get-ManagedSourcePath $fullVendorPath
$sharedPath = Join-Path $SharedRepo $sourcePath
if (!(Test-Path $sharedPath)) { throw "Shared source file not found: $sharedPath" }

if ($ApplyVendorDiff) {
  Copy-Item -Force $fullVendorPath $sharedPath
  Write-Output "Applied vendor file to shared source:"
} else {
  Write-Output "Edit this shared source file:"
}

Write-Output $sharedPath
Write-Output "After committing shared changes, run scripts/sync-shared-reference.ps1 -Ref <commit> in the project."

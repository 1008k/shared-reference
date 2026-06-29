param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo = (Split-Path $PSScriptRoot -Parent),
  [string]$Ref = "main",
  [string]$RepoUrl = "https://github.com/1008k/agent-rules.git",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Resolve-Commit([string]$Repo, [string]$RefName) {
  $commit = (& git -C $Repo rev-parse $RefName).Trim()
  if ($LASTEXITCODE -ne 0 -or !$commit) { throw "Could not resolve ref: $RefName" }
  return $commit
}

function Write-ProjectWrapper([string]$Path, [string]$Content) {
  if ($DryRun) {
    Write-Output "Would write $Path"
    return
  }
  New-Item -ItemType Directory -Force (Split-Path $Path -Parent) | Out-Null
  Set-Content -Encoding UTF8 -NoNewline -Path $Path -Value $Content
}

$ProjectRoot = [IO.Path]::GetFullPath($ProjectRoot)
$SharedRepo = [IO.Path]::GetFullPath($SharedRepo)
if (!(Test-Path (Join-Path $SharedRepo "manifest.yaml"))) { throw "Shared repo not found or missing manifest: $SharedRepo" }

$resolvedRef = Resolve-Commit $SharedRepo $Ref
$relativeSharedRepo = "../agent-rules"

$syncWrapper = @'
param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo,
  [string]$Ref,
  [string]$LockPath,
  [string]$CloneRoot = (Split-Path (Get-Location).Path -Parent),
  [switch]$Force,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Read-LockValue([string]$Path, [string]$Key) {
  if (!(Test-Path $Path)) { return $null }
  $pattern = "^\s*$([regex]::Escape($Key)):\s*(.+?)\s*$"
  $match = Select-String -Path $Path -Pattern $pattern | Select-Object -First 1
  if (!$match) { return $null }
  return $match.Matches[0].Groups[1].Value.Trim('"').Trim("'")
}

if (!$LockPath) { $LockPath = Join-Path $ProjectRoot ".shared/agent-rules.lock.yaml" }
if (!$SharedRepo) { $SharedRepo = Read-LockValue $LockPath "local_path" }
if (!$SharedRepo) { $SharedRepo = Join-Path $CloneRoot "agent-rules" }
if (![IO.Path]::IsPathRooted($SharedRepo)) { $SharedRepo = Join-Path $ProjectRoot $SharedRepo }
$SharedRepo = [IO.Path]::GetFullPath($SharedRepo)

if (!(Test-Path $SharedRepo)) {
  $repoUrl = Read-LockValue $LockPath "repo"
  if (!$repoUrl) { $repoUrl = "https://github.com/1008k/agent-rules.git" }
  New-Item -ItemType Directory -Force (Split-Path $SharedRepo -Parent) | Out-Null
  & git clone $repoUrl $SharedRepo
  if ($LASTEXITCODE -ne 0) { throw "Could not clone shared repo: $repoUrl" }
}

$script = Join-Path $SharedRepo "scripts/sync-agent-rules.ps1"
if (!(Test-Path $script)) { throw "Shared sync script not found: $script" }
& $script -ProjectRoot $ProjectRoot -SharedRepo $SharedRepo -Ref $Ref -LockPath $LockPath -Force:$Force -DryRun:$DryRun
'@

$proposeWrapper = @'
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

$lockPath = Join-Path $ProjectRoot ".shared/agent-rules.lock.yaml"
if (!$SharedRepo) { $SharedRepo = Read-LockValue $lockPath "local_path" }
if (!$SharedRepo) { $SharedRepo = Join-Path $CloneRoot "agent-rules" }
if (![IO.Path]::IsPathRooted($SharedRepo)) { $SharedRepo = Join-Path $ProjectRoot $SharedRepo }
$SharedRepo = [IO.Path]::GetFullPath($SharedRepo)

if (!(Test-Path $SharedRepo)) {
  $repoUrl = Read-LockValue $lockPath "repo"
  if (!$repoUrl) { $repoUrl = "https://github.com/1008k/agent-rules.git" }
  New-Item -ItemType Directory -Force (Split-Path $SharedRepo -Parent) | Out-Null
  & git clone $repoUrl $SharedRepo
  if ($LASTEXITCODE -ne 0) { throw "Could not clone shared repo: $repoUrl" }
}

$script = Join-Path $SharedRepo "scripts/propose-shared-rule-change.ps1"
if (!(Test-Path $script)) { throw "Shared propose script not found: $script" }
& $script -VendorPath $VendorPath -ProjectRoot $ProjectRoot -SharedRepo $SharedRepo -CloneRoot $CloneRoot -ApplyVendorDiff:$ApplyVendorDiff
'@

$lock = @"
version: 1
source:
  repo: $RepoUrl
  local_path: $relativeSharedRepo
  ref: $resolvedRef
managed:
  - .shared/docs/
  - .shared/skills/
disabled: []
last_synced_at: pending-adoption
"@

Write-ProjectWrapper (Join-Path $ProjectRoot "scripts/sync-agent-rules.ps1") $syncWrapper
Write-ProjectWrapper (Join-Path $ProjectRoot "scripts/propose-shared-rule-change.ps1") $proposeWrapper
Write-ProjectWrapper (Join-Path $ProjectRoot ".shared/agent-rules.lock.yaml") $lock

if ($DryRun) {
  Write-Output "Would sync managed files from $resolvedRef"
} else {
  & (Join-Path $SharedRepo "scripts/sync-agent-rules.ps1") -ProjectRoot $ProjectRoot -SharedRepo $SharedRepo -Ref $resolvedRef -Force
}

Write-Output "agent-rules adoption complete: $resolvedRef"

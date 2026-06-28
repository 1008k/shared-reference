param(
  [string]$ProjectRoot = (Get-Location).Path,
  [string]$SharedRepo,
  [string]$Ref,
  [string]$LockPath,
  [switch]$Force,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Normalize-PathText([string]$Value) {
  return $Value.Replace("\", "/").Trim("/")
}

function Read-LockValue([string]$Path, [string]$Key) {
  if (!(Test-Path $Path)) { return $null }
  $pattern = "^\s*$([regex]::Escape($Key)):\s*(.+?)\s*$"
  $match = Select-String -Path $Path -Pattern $pattern | Select-Object -First 1
  if (!$match) { return $null }
  return $match.Matches[0].Groups[1].Value.Trim('"').Trim("'")
}

function Read-SyncTargets([string]$ManifestPath) {
  $targets = @()
  $current = $null
  foreach ($line in Get-Content -Encoding UTF8 $ManifestPath) {
    if ($line -match '^\s*-\s+source:\s*(.+?)\s*$') {
      if ($current) { $targets += [pscustomobject]$current }
      $current = @{ Source = (Normalize-PathText $matches[1]); Destination = $null }
      continue
    }
    if ($current -and $line -match '^\s+destination:\s*(.+?)\s*$') {
      $current.Destination = (Normalize-PathText $matches[1])
    }
  }
  if ($current) { $targets += [pscustomobject]$current }
  return $targets | Where-Object { $_.Source -and $_.Destination }
}

function Get-FileTextOrNull([string]$Path) {
  if (!(Test-Path $Path)) { return $null }
  return Get-Content -Raw -Encoding UTF8 $Path
}

function Get-GitFileTextOrNull([string]$Repo, [string]$Commit, [string]$Path) {
  if (!$Commit) { return $null }
  $spec = "${Commit}:$Path"
  $output = & git -C $Repo show $spec 2>$null
  if ($LASTEXITCODE -ne 0) { return $null }
  return ($output -join "`n") + "`n"
}

function Normalize-FileTextForCompare([string]$Text) {
  if ($null -eq $Text) { return $null }
  return $Text.Replace("`r`n", "`n")
}

function Assert-NoUnsafeLocalChange([string]$Repo, [string]$OldRef, [string]$SourcePath, [string]$DestPath, [string]$NewText) {
  $currentText = Get-FileTextOrNull $DestPath
  if ($null -eq $currentText) { return }
  $isManaged = $currentText -match 'managed-by:\s*agent-rules'
  if (!$isManaged) {
    if ($Force) { return }
    throw "Refusing to overwrite unmanaged file: $DestPath. Re-run with -Force only when adopting it into agent-rules."
  }
  $oldText = Get-GitFileTextOrNull $Repo $OldRef $SourcePath
  $currentCompare = Normalize-FileTextForCompare $currentText
  $oldCompare = Normalize-FileTextForCompare $oldText
  $newCompare = Normalize-FileTextForCompare $NewText
  if ($oldCompare -and $currentCompare -ne $oldCompare -and $currentCompare -ne $newCompare) {
    throw "Local changes detected in managed file: $DestPath. Move the change to the shared source with scripts/propose-shared-rule-change.ps1."
  }
}

if (!$LockPath) { $LockPath = Join-Path $ProjectRoot ".agents/shared-rules.lock.yaml" }
if (!$SharedRepo) { $SharedRepo = Read-LockValue $LockPath "local_path" }
if (!$SharedRepo) { $SharedRepo = Join-Path (Split-Path $ProjectRoot -Parent) "agent-rules" }
if (!(Test-Path $SharedRepo)) { throw "Shared repo not found: $SharedRepo" }

$manifestPath = Join-Path $SharedRepo "manifest.yaml"
if (!(Test-Path $manifestPath)) { throw "Missing manifest: $manifestPath" }

$oldRef = Read-LockValue $LockPath "ref"
$resolvedRef = if ($Ref) { (& git -C $SharedRepo rev-parse $Ref).Trim() } else { (& git -C $SharedRepo rev-parse HEAD).Trim() }
if ($LASTEXITCODE -ne 0 -or !$resolvedRef) { throw "Could not resolve shared ref: $Ref" }

$sourceRoot = $SharedRepo
$tempWorktree = $null
if ($Ref) {
  $tempWorktree = Join-Path ([IO.Path]::GetTempPath()) ("agent-rules-" + [guid]::NewGuid().ToString("N"))
  & git -C $SharedRepo worktree add --detach $tempWorktree $resolvedRef | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Could not create temporary worktree for $resolvedRef" }
  $sourceRoot = $tempWorktree
}

try {
  foreach ($target in Read-SyncTargets $manifestPath) {
    $sourceDir = Join-Path $sourceRoot $target.Source
    $destDir = Join-Path $ProjectRoot $target.Destination
    if (!(Test-Path $sourceDir)) { throw "Missing source directory: $sourceDir" }
    foreach ($sourceFile in Get-ChildItem -Recurse -File $sourceDir) {
      $relativeFromTarget = [IO.Path]::GetRelativePath($sourceDir, $sourceFile.FullName)
      $sourceRel = (Normalize-PathText (Join-Path $target.Source $relativeFromTarget))
      $destPath = Join-Path $destDir $relativeFromTarget
      $newText = Get-Content -Raw -Encoding UTF8 $sourceFile.FullName
      Assert-NoUnsafeLocalChange $SharedRepo $oldRef $sourceRel $destPath $newText
      if ($DryRun) {
        Write-Host "Would sync $sourceRel -> $destPath"
      } else {
        New-Item -ItemType Directory -Force (Split-Path $destPath -Parent) | Out-Null
        Copy-Item -Force $sourceFile.FullName $destPath
      }
    }
  }

  if (!$DryRun) {
    New-Item -ItemType Directory -Force (Split-Path $LockPath -Parent) | Out-Null
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    @"
version: 1
source:
  repo: https://github.com/1008k/agent-rules.git
  local_path: $SharedRepo
  ref: $resolvedRef
managed:
  - docs/integrations/
  - .agents/skills/
disabled: []
last_synced_at: $timestamp
"@ | Set-Content -Encoding UTF8 -NoNewline $LockPath
  }

  Write-Host "agent-rules sync complete: $resolvedRef"
} finally {
  if ($tempWorktree -and (Test-Path $tempWorktree)) {
    & git -C $SharedRepo worktree remove --force $tempWorktree | Out-Null
  }
}

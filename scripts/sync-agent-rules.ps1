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

function Read-LockList([string]$Path, [string]$Key) {
  if (!(Test-Path $Path)) { return @() }
  $lines = Get-Content -Encoding UTF8 $Path
  $items = @()
  for ($index = 0; $index -lt $lines.Count; $index++) {
    $line = $lines[$index]
    if ($line -match "^\s*$([regex]::Escape($Key)):\s*\[\s*\]\s*$") { return @() }
    if ($line -match "^\s*$([regex]::Escape($Key)):\s*$") {
      for ($nested = $index + 1; $nested -lt $lines.Count; $nested++) {
        $nestedLine = $lines[$nested]
        if ($nestedLine -match '^\s*-\s*(.+?)\s*$') {
          $items += (Normalize-PathText $matches[1].Trim('"').Trim("'"))
          continue
        }
        if ($nestedLine -match '^\S') { break }
      }
      return $items
    }
  }
  return @()
}

function Resolve-ReadLockPath([string]$ProjectRoot, [string]$RequestedLockPath) {
  if ($RequestedLockPath) { return $RequestedLockPath }
  $newPath = Join-Path $ProjectRoot ".shared/agent-rules.lock.yaml"
  $oldPath = Join-Path $ProjectRoot ".agents/shared-rules.lock.yaml"
  if (Test-Path $newPath) { return $newPath }
  if (Test-Path $oldPath) { return $oldPath }
  return $newPath
}

function Format-LockList([string]$Key, [string[]]$Items) {
  if (!$Items -or $Items.Count -eq 0) { return "${Key}: []" }
  $lines = @("${Key}:")
  foreach ($item in $Items) { $lines += "  - $item" }
  return $lines -join "`r`n"
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

function Test-DisabledPath([string]$Path, [string[]]$DisabledPaths) {
  $normalized = Normalize-PathText $Path
  foreach ($disabled in $DisabledPaths) {
    $disabledPath = Normalize-PathText $disabled
    if (!$disabledPath) { continue }
    if ($normalized -eq $disabledPath -or $normalized.StartsWith($disabledPath.TrimEnd("/") + "/")) {
      return $true
    }
  }
  return $false
}

function Get-ManagedDestinationForLock($Target, [string]$SourceRoot) {
  $sourcePath = Join-Path $SourceRoot $Target.Source
  $destination = $Target.Destination
  if (Test-Path $sourcePath -PathType Container) { return $destination.TrimEnd("/") + "/" }
  return $destination
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

$ReadLockPath = Resolve-ReadLockPath $ProjectRoot $LockPath
if (!$LockPath) { $LockPath = Join-Path $ProjectRoot ".shared/agent-rules.lock.yaml" }
if (!$SharedRepo) { $SharedRepo = Read-LockValue $ReadLockPath "local_path" }
if (!$SharedRepo) { $SharedRepo = Join-Path (Split-Path $ProjectRoot -Parent) "agent-rules" }
if (![IO.Path]::IsPathRooted($SharedRepo)) { $SharedRepo = Join-Path $ProjectRoot $SharedRepo }
$SharedRepo = [IO.Path]::GetFullPath($SharedRepo)
if (!(Test-Path $SharedRepo)) { throw "Shared repo not found: $SharedRepo" }

$manifestPath = Join-Path $SharedRepo "manifest.yaml"
if (!(Test-Path $manifestPath)) { throw "Missing manifest: $manifestPath" }
$targets = @(Read-SyncTargets $manifestPath)

$oldRef = Read-LockValue $ReadLockPath "ref"
$disabled = @(Read-LockList $ReadLockPath "disabled")
if (!$Ref) {
  $dirty = & git -C $SharedRepo status --porcelain --untracked-files=all
  if ($dirty) {
    throw "Shared repo has uncommitted changes. Commit them or pass -Ref <commit> before syncing."
  }
}
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
  foreach ($target in $targets) {
    $sourcePath = Join-Path $sourceRoot $target.Source
    $destPath = Join-Path $ProjectRoot $target.Destination
    if (!(Test-Path $sourcePath)) { throw "Missing sync source: $sourcePath" }
    if (Test-Path $sourcePath -PathType Leaf) {
      $sourceRel = Normalize-PathText $target.Source
      if (Test-DisabledPath $sourceRel $disabled) {
        Write-Output "Skipping disabled shared file: $sourceRel"
        continue
      }
      $newText = Get-Content -Raw -Encoding UTF8 $sourcePath
      Assert-NoUnsafeLocalChange $SharedRepo $oldRef $sourceRel $destPath $newText
      if ($DryRun) {
        Write-Output "Would sync $sourceRel -> $destPath"
      } else {
        New-Item -ItemType Directory -Force (Split-Path $destPath -Parent) | Out-Null
        Copy-Item -Force $sourcePath $destPath
      }
    } else {
      $sourceDir = $sourcePath
      $destDir = $destPath
      foreach ($sourceFile in Get-ChildItem -Recurse -File $sourceDir) {
        $relativeFromTarget = [IO.Path]::GetRelativePath($sourceDir, $sourceFile.FullName)
        $sourceRel = (Normalize-PathText (Join-Path $target.Source $relativeFromTarget))
        if (Test-DisabledPath $sourceRel $disabled) {
          Write-Output "Skipping disabled shared file: $sourceRel"
          continue
        }
        $fileDestPath = Join-Path $destDir $relativeFromTarget
        $newText = Get-Content -Raw -Encoding UTF8 $sourceFile.FullName
        Assert-NoUnsafeLocalChange $SharedRepo $oldRef $sourceRel $fileDestPath $newText
        if ($DryRun) {
          Write-Output "Would sync $sourceRel -> $fileDestPath"
        } else {
          New-Item -ItemType Directory -Force (Split-Path $fileDestPath -Parent) | Out-Null
          Copy-Item -Force $sourceFile.FullName $fileDestPath
        }
      }
    }
  }

  if (!$DryRun) {
    New-Item -ItemType Directory -Force (Split-Path $LockPath -Parent) | Out-Null
    $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $disabledBlock = Format-LockList "disabled" $disabled
    $managedBlock = Format-LockList "managed" @($targets | ForEach-Object { Get-ManagedDestinationForLock $_ $sourceRoot })
    @"
version: 1
source:
  repo: https://github.com/1008k/agent-rules.git
  local_path: ../agent-rules
  ref: $resolvedRef
$managedBlock
$disabledBlock
last_synced_at: $timestamp
"@ | Set-Content -Encoding UTF8 -NoNewline $LockPath
  }

  Write-Output "agent-rules sync complete: $resolvedRef"
} finally {
  if ($tempWorktree -and (Test-Path $tempWorktree)) {
    & git -C $SharedRepo worktree remove --force $tempWorktree | Out-Null
  }
}

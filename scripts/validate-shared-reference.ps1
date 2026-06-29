param(
  [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"

function Normalize-PathText([string]$Value) {
  return $Value.Replace("\", "/").Trim("/")
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

function Assert-ManagedHeader([IO.FileInfo]$File, [string]$SourcePath) {
  $text = Get-Content -Raw -Encoding UTF8 $File.FullName
  if ($text -notmatch 'managed-by:\s*shared-reference') {
    throw "Missing managed header: $SourcePath"
  }
  if ($text -notmatch [regex]::Escape("source-path: $SourcePath")) {
    throw "Missing or wrong source-path header: $SourcePath"
  }
}

function Assert-SkillFrontmatter([IO.FileInfo]$File) {
  $text = Get-Content -Raw -Encoding UTF8 $File.FullName
  if ($text -notmatch '(?s)^---\s*\r?\nname:\s*[a-z0-9-]+\s*\r?\ndescription:\s*.+?\r?\n---') {
    throw "Invalid skill frontmatter: $($File.FullName)"
  }
}

function Assert-PowerShellParses([IO.FileInfo]$File) {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseFile($File.FullName, [ref]$tokens, [ref]$errors) | Out-Null
  if ($errors.Count -gt 0) {
    throw "PowerShell parse error in $($File.FullName): $($errors[0].Message)"
  }
}

$manifestPath = Join-Path $RepoRoot "manifest.yaml"
if (!(Test-Path $manifestPath)) { throw "Missing manifest.yaml" }

foreach ($target in Read-SyncTargets $manifestPath) {
  $sourcePath = Join-Path $RepoRoot $target.Source
  if (!(Test-Path $sourcePath)) { throw "Missing sync source: $($target.Source)" }
  $files = if (Test-Path $sourcePath -PathType Leaf) {
    @(Get-Item $sourcePath)
  } else {
    @(Get-ChildItem -Recurse -File $sourcePath)
  }
  foreach ($file in $files) {
    if ($file.Extension -notin @(".md", ".txt")) { continue }
    $relative = Normalize-PathText ([IO.Path]::GetRelativePath($RepoRoot, $file.FullName))
    Assert-ManagedHeader $file $relative
  }
}

foreach ($skill in Get-ChildItem -Recurse -File (Join-Path $RepoRoot ".agents/skills") -Filter "SKILL.md") {
  Assert-SkillFrontmatter $skill
}

foreach ($script in Get-ChildItem -Recurse -File (Join-Path $RepoRoot "scripts") -Filter "*.ps1") {
  Assert-PowerShellParses $script
}

Write-Output "shared-reference validation passed"

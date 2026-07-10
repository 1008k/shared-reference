param(
  [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = "Stop"

function Normalize-PathText([string]$Value) {
  return $Value.Replace("\", "/").Trim("/")
}

function Normalize-ManagedDestination([string]$Value) {
  $rawValue = $Value.Trim().Trim('"').Trim("'")
  if ([IO.Path]::IsPathRooted($rawValue)) {
    throw "Managed destination must be relative: $Value"
  }

  $destination = Normalize-PathText $rawValue
  $segments = @($destination.Split("/"))
  if (!$destination.StartsWith(".shared/") -or $segments -contains "." -or $segments -contains "..") {
    throw "Managed destination must stay under .shared/: $Value"
  }
  return $destination
}

function Get-RelativePathCompat([string]$BasePath, [string]$Path) {
  if ([IO.Path].GetMethod("GetRelativePath", [type[]]@([string], [string]))) {
    return [IO.Path]::GetRelativePath($BasePath, $Path)
  }

  $baseFullPath = [IO.Path]::GetFullPath($BasePath).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
  $targetFullPath = [IO.Path]::GetFullPath($Path)
  $baseUri = New-Object System.Uri($baseFullPath)
  $targetUri = New-Object System.Uri($targetFullPath)
  return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString()).Replace("/", [IO.Path]::DirectorySeparatorChar)
}

function Read-SyncTargets([string]$ManifestPath) {
  $targets = @()
  $current = $null
  foreach ($line in Get-Content -Encoding UTF8 $ManifestPath) {
    if ($line -match '^\s*-\s+source:\s*(.+?)\s*$') {
      if ($current) {
        if (!$current.Destination) {
          throw "Missing destination for sync source: $($current.Source)"
        }
        $targets += [pscustomobject]$current
      }
      $current = @{ Source = (Normalize-PathText $matches[1]); Destination = $null }
      continue
    }
    if ($line -match '^\s+destination:\s*(.*?)\s*$') {
      if (!$current) {
        throw "Destination without sync source: $line"
      }
      if ($current.Destination) {
        throw "Duplicate destination for sync source: $($current.Source)"
      }
      $current.Destination = Normalize-ManagedDestination $matches[1]
    }
  }
  if ($current) {
    if (!$current.Destination) {
      throw "Missing destination for sync source: $($current.Source)"
    }
    $targets += [pscustomobject]$current
  }
  return $targets
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
  Assert-PowerShellTextParses (Get-Content -Raw -Encoding UTF8 $File.FullName) $File.FullName
}

function Assert-PowerShellTextParses([string]$Text, [string]$Description) {
  $tokens = $null
  $errors = $null
  [System.Management.Automation.Language.Parser]::ParseInput($Text, $Description, [ref]$tokens, [ref]$errors) | Out-Null
  if ($errors.Count -gt 0) {
    throw "PowerShell parse error in ${Description}: $($errors[0].Message)"
  }
}

function Assert-GeneratedProjectWrappersParse([string]$AdoptScriptPath) {
  $text = Get-Content -Raw -Encoding UTF8 $AdoptScriptPath
  foreach ($name in @("syncWrapper", "proposeWrapper")) {
    $pattern = '(?s)\$' + [regex]::Escape($name) + '\s*=\s*@''\r?\n(.*?)\r?\n''@'
    $match = [regex]::Match($text, $pattern)
    if (!$match.Success) {
      throw "Missing generated project wrapper template: $name"
    }
    Assert-PowerShellTextParses $match.Groups[1].Value "${AdoptScriptPath}::$name"
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
    if ($file.Extension -notin @(".md", ".txt", ".yaml")) { continue }
    $relative = Normalize-PathText (Get-RelativePathCompat $RepoRoot $file.FullName)
    Assert-ManagedHeader $file $relative
  }
}

foreach ($skill in Get-ChildItem -Recurse -File (Join-Path $RepoRoot ".agents/skills") -Filter "SKILL.md") {
  Assert-SkillFrontmatter $skill
}

foreach ($script in Get-ChildItem -Recurse -File (Join-Path $RepoRoot "scripts") -Filter "*.ps1") {
  Assert-PowerShellParses $script
}

Assert-GeneratedProjectWrappersParse (Join-Path $RepoRoot "scripts/adopt-shared-reference.ps1")

Write-Output "shared-reference validation passed"

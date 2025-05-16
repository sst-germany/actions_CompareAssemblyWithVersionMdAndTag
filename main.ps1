param(
  [string]$AssemblyPath
)

if (-not (Test-Path $AssemblyPath)) {
    Write-Error "Version-Assembly not found: $AssemblyPath"
    exit 1
}

# Read the version from the assembly
$assembly = [System.Reflection.AssemblyName]::GetAssemblyName($AssemblyPath)
$assemblyVersion = $assembly.Version.ToString()
Write-Host "Assembly: $assemblyVersion"

# Get name of the Git-Tag
$tagName = $env:GITHUB_REF_NAME
Write-Host "Git-Tag: $tagName"

# Get Version from VERSION.md
$markdownVersion = (Get-Content -Path "VERSION.md" | Select-Object -First 1).Trim()
Write-Host "VERSION.md: $markdownVersion"

# Output
"assembly_version=$assemblyVersion" | Out-File -FilePath $env:GITHUB_OUTPUT -Append

# Versionen vergleichen
if ($assemblyVersion -ne $markdownVersion) {
    Write-Error "Assembly-Version does not match with VERSION.md: $assemblyVersion <=> VERSION.md: $version"
    exit 1
}

if ($tagName -notlike "releases/v*") {
    Write-Error "Git tag does not start with 'releases/v': $tagName"
    exit 1
}

if ($tagName -notmatch "^releases/v$assemblyVersion$") {
    Write-Error "Git tag does not match the expected format 'releases/v$markdownVersion': $tagName"
    exit 1
}
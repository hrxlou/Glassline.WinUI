param(
    [Parameter(Mandatory = $true)]
    [string]$PackageDirectory
)

$ErrorActionPreference = 'Stop'

$resolvedPackageDirectory = Resolve-Path $PackageDirectory
$packages = @(Get-ChildItem $resolvedPackageDirectory -Filter '*.nupkg' -File | Where-Object { $_.Name -notlike '*.symbols.nupkg' })
$expectedIds = @(
    'Glassline.WinUI.Theme',
    'Glassline.WinUI.Controls',
    'Glassline.WinUI.Effects'
)

if ($packages.Count -ne $expectedIds.Count) {
    throw "Expected $($expectedIds.Count) shipping packages, found $($packages.Count)."
}

$seenIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$tempRoot = Join-Path $env:RUNNER_TEMP 'glassline-package-metadata'
New-Item -ItemType Directory -Force $tempRoot | Out-Null

foreach ($package in $packages) {
    $extractDir = Join-Path $tempRoot $package.BaseName
    Expand-Archive $package.FullName -DestinationPath $extractDir -Force
    $nuspecFile = Get-ChildItem $extractDir -Filter '*.nuspec' -File | Select-Object -First 1
    if ($null -eq $nuspecFile) {
        throw "Package $($package.Name) is missing a nuspec."
    }

    [xml]$nuspec = Get-Content $nuspecFile.FullName -Raw
    $metadata = $nuspec.SelectSingleNode("/*[local-name()='package']/*[local-name()='metadata']")
    if ($null -eq $metadata) {
        throw "Package $($package.Name) has no nuspec metadata element."
    }

    $id = $metadata.SelectSingleNode("*[local-name()='id']").InnerText
    $version = $metadata.SelectSingleNode("*[local-name()='version']").InnerText
    $authors = $metadata.SelectSingleNode("*[local-name()='authors']").InnerText
    $description = $metadata.SelectSingleNode("*[local-name()='description']").InnerText
    $license = $metadata.SelectSingleNode("*[local-name()='license']")
    $repository = $metadata.SelectSingleNode("*[local-name()='repository']")

    if ($id -notin $expectedIds) {
        throw "Unexpected shipping package id '$id'."
    }
    if (-not $seenIds.Add($id)) {
        throw "Duplicate shipping package id '$id'."
    }
    if ($version -ne '0.1.0-preview.1') {
        throw "Package $id has unexpected version '$version'."
    }
    if ($authors -ne 'Glassline.WinUI contributors') {
        throw "Package $id has unexpected authors '$authors'."
    }
    if ([string]::IsNullOrWhiteSpace($description)) {
        throw "Package $id must have a non-empty description."
    }
    if ($null -eq $license -or $license.GetAttribute('type') -ne 'expression' -or $license.InnerText -ne 'MIT') {
        throw "Package $id must declare the MIT license expression."
    }
    if ($null -eq $repository -or $repository.GetAttribute('type') -ne 'git' -or $repository.GetAttribute('url') -ne 'https://github.com/hrxlou/Glassline.WinUI') {
        throw "Package $id must declare the canonical git repository metadata."
    }

    $dependencyIds = @(
        $metadata.SelectNodes("*[local-name()='dependencies']/*[local-name()='group']/*[local-name()='dependency']") |
            ForEach-Object { $_.GetAttribute('id') }
    )

    if ($id -eq 'Glassline.WinUI.Controls' -and 'Glassline.WinUI.Theme' -notin $dependencyIds) {
        throw 'Controls package must depend on Glassline.WinUI.Theme.'
    }
    if ($id -eq 'Glassline.WinUI.Theme' -and ($dependencyIds -contains 'Glassline.WinUI.Controls' -or $dependencyIds -contains 'Glassline.WinUI.Effects')) {
        throw 'Theme package must not depend on Controls or Effects.'
    }
    if ($id -eq 'Glassline.WinUI.Effects' -and ($dependencyIds -contains 'Glassline.WinUI.Controls' -or $dependencyIds -contains 'Glassline.WinUI.Theme')) {
        throw 'Effects baseline must not depend on Theme or Controls.'
    }
}

foreach ($expectedId in $expectedIds) {
    if (-not $seenIds.Contains($expectedId)) {
        throw "Missing shipping package '$expectedId'."
    }
}

Write-Host 'Generated NuGet metadata/dependency validation passed.'

$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
Set-Location $root

$errors = [System.Collections.Generic.List[string]]::new()

$requiredProjects = @(
    'src/Glassline.WinUI.Theme/Glassline.WinUI.Theme.csproj',
    'src/Glassline.WinUI.Controls/Glassline.WinUI.Controls.csproj',
    'src/Glassline.WinUI.Effects/Glassline.WinUI.Effects.csproj',
    'samples/Glassline.Gallery/Glassline.Gallery.csproj'
)

foreach ($path in $requiredProjects) {
    if (-not (Test-Path $path)) {
        $errors.Add("Missing required project: $path")
    }
}

$packageProps = Get-Content 'eng/Directory.Packages.props' -Raw
if ($packageProps -notmatch 'Microsoft\.WindowsAppSDK" Version="2\.3\.1"') {
    $errors.Add('Windows App SDK must remain centrally pinned to 2.3.1 for this baseline.')
}

$forbiddenExtensions = @('*.ttf', '*.otf', '*.ttc', '*.sketch', '*.fig')
foreach ($pattern in $forbiddenExtensions) {
    $matches = Get-ChildItem src,samples -Recurse -File -Filter $pattern -ErrorAction SilentlyContinue
    foreach ($match in $matches) {
        $errors.Add("Forbidden shipping asset: $($match.FullName)")
    }
}

$forbiddenDependencies = 'Uno|Avalonia|WPF|Flutter|Chromium'
$projectFiles = Get-ChildItem src -Recurse -Filter '*.csproj' -File
foreach ($project in $projectFiles) {
    $content = Get-Content $project.FullName -Raw
    if ($content -match $forbiddenDependencies) {
        $errors.Add("Forbidden source dependency in $($project.FullName)")
    }
}

$shippingFiles = Get-ChildItem src,samples -Recurse -File -ErrorAction SilentlyContinue
foreach ($file in $shippingFiles) {
    if ($file.Extension -in @('.cs', '.xaml', '.xml', '.json')) {
        $content = Get-Content $file.FullName -Raw
        if ($content -match 'SF Pro|SF Symbols|Apple Design Resources') {
            $errors.Add("Forbidden Apple asset/reference literal in shipping source: $($file.FullName)")
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host 'Repository structural validation passed.'

$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$contractsPath = Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineMaterialContracts.cs'
$capabilitiesPath = Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineMaterialCapabilities.cs'
$qualityPath = Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineMaterialQualityManager.cs'
$containerPath = Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineGlassContainer.cs'
$genericPath = Join-Path $root 'src/Glassline.WinUI.Controls/Themes/Generic.xaml'
$galleryPath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml'
$galleryCodePath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml.cs'
$packageSmokePath = Join-Path $root 'tests/Glassline.PackageSmoke/MainWindow.xaml'
$policySmokePath = Join-Path $root 'tests/Glassline.MaterialPolicySmoke/Program.cs'

foreach ($path in @($contractsPath, $capabilitiesPath, $qualityPath, $containerPath, $genericPath, $galleryPath, $galleryCodePath, $packageSmokePath, $policySmokePath)) {
    if (-not (Test-Path $path)) {
        throw "Missing material baseline artifact: $path"
    }
}

$contracts = Get-Content $contractsPath -Raw
$capabilities = Get-Content $capabilitiesPath -Raw
$quality = Get-Content $qualityPath -Raw
$container = Get-Content $containerPath -Raw
$generic = Get-Content $genericPath -Raw
$gallery = Get-Content $galleryPath -Raw
$galleryCode = Get-Content $galleryCodePath -Raw
$packageSmoke = Get-Content $packageSmokePath -Raw
$policySmoke = Get-Content $policySmokePath -Raw

foreach ($token in @('Sidebar','Toolbar','Popover','Interactive','Prominent','Auto','Full','Reduced','Solid')) {
    if ($contracts -notmatch [regex]::Escape($token)) {
        throw "Material contract missing token: $token"
    }
}

if ($capabilities -notmatch 'AdvancedEffectsEnabled' -or $capabilities -notmatch 'HighContrast' -or $capabilities -notmatch 'InteractiveSession\.IsRemote') {
    throw 'Material capabilities must use Windows transparency, High Contrast, and RDP policy signals.'
}
if ($capabilities -match 'GPU|Vendor|NVIDIA|AMD|Intel') {
    throw 'Material capability policy must not depend on hard-coded GPU model/vendor lists.'
}
if ($quality -notmatch 'HighContrast \|\| !environment\.AdvancedEffectsEnabled') {
    throw 'Material quality policy must force Solid for accessibility/transparency policy.'
}
if ($quality -notmatch 'IsRemoteSession \|\| environment\.IsResizing \|\| !environment\.IsWindowActive') {
    throw 'Material quality policy must downgrade RDP, resize, and inactive windows.'
}
if ($container -notmatch 'class GlasslineGlassContainer : ContentControl' -or $container -notmatch 'SystemBackdropElement') {
    throw 'GlassContainer must be one templated shared material region backed by SystemBackdropElement.'
}
if ($container -notmatch 'DesktopAcrylicBackdrop' -or $container -notmatch 'MicaBackdrop') {
    throw 'Full/Reduced baseline must use built-in Windows material backdrops.'
}
if ($container -match 'Children|ItemsSource|ListViewItem|TreeViewItem|CompositionBackdropBrush|CreateBackdropBrush|Win2D|D2D|D3D|Displacement|Refraction') {
    throw 'GlassContainer must not create per-child/custom/refraction effect pipelines in the baseline.'
}

[xml]$genericXml = $generic
$backdropElementCount = ([regex]::Matches($generic, 'SystemBackdropElement')).Count
if ($backdropElementCount -ne 1) {
    throw "Generic.xaml must define exactly one SystemBackdropElement in the shared GlassContainer template; found $backdropElementCount."
}
if ($generic -notmatch 'MaterialRoleStates' -or $generic -notmatch 'MaterialQualityStates') {
    throw 'GlassContainer template must expose semantic role and quality visual states.'
}
if ($gallery -notmatch 'GlasslineGlassContainer' -or $packageSmoke -notmatch 'GlasslineGlassContainer') {
    throw 'Gallery and generated-package smoke consumer must compile the shared material region.'
}
if ($gallery -notmatch 'WindowSolidFallback' -or $galleryCode -notmatch 'EffectiveKindChanged' -or $galleryCode -notmatch 'GlasslineWindowBackdropKind\.Solid') {
    throw 'Gallery must expose the native window backdrop when translucent and restore the semantic solid root when policy resolves Solid.'
}
foreach ($case in @('auto-normal','high-contrast','effects-disabled','rdp','resize','inactive')) {
    if ($policySmoke -notmatch [regex]::Escape($case)) {
        throw "Material policy smoke missing case: $case"
    }
}

Write-Host 'Material runtime contract validation passed.'

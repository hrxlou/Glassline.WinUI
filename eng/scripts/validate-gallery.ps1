$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$xamlPath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml'
$codePath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml.cs'
$sceneIdsPath = Join-Path $root 'samples/Glassline.Gallery/GallerySceneIds.cs'
$sceneSmokePath = Join-Path $root 'tests/Glassline.GallerySceneSmoke/Program.cs'

foreach ($path in @($xamlPath, $codePath, $sceneIdsPath, $sceneSmokePath)) {
    if (-not (Test-Path $path)) {
        throw "Missing Gallery validation artifact: $path"
    }
}

$xaml = Get-Content $xamlPath -Raw
$code = Get-Content $codePath -Raw
$sceneIds = Get-Content $sceneIdsPath -Raw
$sceneSmoke = Get-Content $sceneSmokePath -Raw

[xml]$xamlXml = $xaml
foreach ($automationId in @('Scene.WindowFoundation','Scene.MaterialRegions','Scene.ControlsMatrix','Diagnostics.MaterialRuntime')) {
    if ($xaml -notmatch [regex]::Escape("AutomationProperties.AutomationId=\"$automationId\"")) {
        throw "Gallery missing deterministic automation ID: $automationId"
    }
}
foreach ($name in @('SidebarMaterialRegion','ToolbarMaterialRegion','BackdropStatus','EnvironmentStatus','MaterialStatus','RegionStatus')) {
    if ($xaml -notmatch [regex]::Escape("x:Name=\"$name\"")) {
        throw "Gallery missing diagnostics/material element: $name"
    }
}
foreach ($scene in @('window-foundation','material-regions','controls-matrix')) {
    if ($sceneIds -notmatch [regex]::Escape($scene) -or $sceneSmoke -notmatch [regex]::Escape($scene)) {
        throw "Gallery deterministic scene contract missing: $scene"
    }
}
if ($code -notmatch 'GLASSLINE_GALLERY_SCENE' -or $code -notmatch 'GetCommandLineArgs') {
    throw 'Gallery must expose deterministic environment/command-line scene selection hooks.'
}
if ($code -notmatch 'Activated \+=' -or $code -notmatch 'WindowActivationState\.Deactivated') {
    throw 'Gallery must propagate native window activation state to materials.'
}
if ($code -notmatch 'AppWindow\.Changed \+=' -or $code -notmatch 'DidSizeChange') {
    throw 'Gallery must track AppWindow size changes for continuous-resize downgrade.'
}
if ($code -notmatch 'IsResizing = isResizing' -or $code -notmatch 'TimeSpan\.FromMilliseconds\(250\)') {
    throw 'Gallery must downgrade material regions during resize and recover after a deterministic settle interval.'
}
if ($code -notmatch 'ActualWidth \* region\.ActualHeight' -or $code -notmatch 'activeRegions\.Length') {
    throw 'Gallery diagnostics must expose active region count and approximate material area.'
}
if ($code -notmatch 'HighContrast' -or $code -notmatch 'AdvancedEffectsEnabled' -or $code -notmatch 'IsRemoteSession') {
    throw 'Gallery diagnostics must surface material policy environment state.'
}

Write-Host 'Gallery deterministic validation contract passed.'

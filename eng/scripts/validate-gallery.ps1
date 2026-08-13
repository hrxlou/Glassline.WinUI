$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$xamlPath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml'
$codePath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml.cs'
$sceneIdsPath = Join-Path $root 'samples/Glassline.Gallery/GallerySceneIds.cs'
$benchmarkDataPath = Join-Path $root 'samples/Glassline.Gallery/GalleryBenchmarkData.cs'
$sceneSmokePath = Join-Path $root 'tests/Glassline.GallerySceneSmoke/Program.cs'
$benchmarkSmokePath = Join-Path $root 'tests/Glassline.BenchmarkDataSmoke/Program.cs'

foreach ($path in @($xamlPath, $codePath, $sceneIdsPath, $benchmarkDataPath, $sceneSmokePath, $benchmarkSmokePath)) {
    if (-not (Test-Path $path)) {
        throw "Missing Gallery validation artifact: $path"
    }
}

$xaml = Get-Content $xamlPath -Raw
$code = Get-Content $codePath -Raw
$sceneIds = Get-Content $sceneIdsPath -Raw
$benchmarkData = Get-Content $benchmarkDataPath -Raw
$sceneSmoke = Get-Content $sceneSmokePath -Raw
$benchmarkSmoke = Get-Content $benchmarkSmokePath -Raw

[xml]$xamlXml = $xaml
foreach ($automationId in @(
    'Scene.WindowFoundation','Scene.MaterialRegions','Scene.ControlsMatrix','Diagnostics.MaterialRuntime',
    'Scene.BenchmarkSettings','Scene.BenchmarkGrid','Scene.BenchmarkTree',
    'Benchmark.Settings.List','Benchmark.Grid.Items','Benchmark.Tree.Nodes')) {
    $needle = 'AutomationProperties.AutomationId="' + $automationId + '"'
    if ($xaml -notmatch [regex]::Escape($needle)) {
        throw "Gallery missing deterministic automation ID: $automationId"
    }
}
foreach ($name in @(
    'SidebarMaterialRegion','ToolbarMaterialRegion','BackdropStatus','EnvironmentStatus','MaterialStatus','RegionStatus',
    'SettingsBenchmarkList','GridBenchmark','TreeBenchmark')) {
    $needle = 'x:Name="' + $name + '"'
    if ($xaml -notmatch [regex]::Escape($needle)) {
        throw "Gallery missing diagnostics/material/benchmark element: $name"
    }
}
foreach ($scene in @('window-foundation','material-regions','controls-matrix','benchmark-settings','benchmark-grid','benchmark-tree')) {
    if ($sceneIds -notmatch [regex]::Escape($scene)) {
        throw "Gallery deterministic scene ID missing: $scene"
    }
}
foreach ($symbol in @(
    'GallerySceneIds.WindowFoundation','GallerySceneIds.MaterialRegions','GallerySceneIds.ControlsMatrix',
    'GallerySceneIds.BenchmarkSettings','GallerySceneIds.BenchmarkGrid','GallerySceneIds.BenchmarkTree',
    'argument-precedence','unknown-fallback')) {
    if ($sceneSmoke -notmatch [regex]::Escape($symbol)) {
        throw "Gallery scene-selection smoke is missing coverage marker: $symbol"
    }
}
foreach ($marker in @('SettingsRowCount = 100','GridItemCount = 500','TreeRootCount = 100','TreeChildrenPerRoot = 50','TreeNonRootNodeCount')) {
    if ($benchmarkData -notmatch [regex]::Escape($marker)) {
        throw "Benchmark data contract missing marker: $marker"
    }
}
foreach ($marker in @('settings.Count != 100','grid.Count != 500','nonRootNodes != 5000')) {
    if ($benchmarkSmoke -notmatch [regex]::Escape($marker)) {
        throw "Benchmark data smoke missing exact-count assertion: $marker"
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
if ($code -notmatch 'CreateSettingsRows' -or $code -notmatch 'CreateGridItems' -or $code -notmatch 'CreateTreeBranches') {
    throw 'Gallery must instantiate all deterministic benchmark workloads.'
}

Write-Host 'Gallery deterministic validation contract passed.'

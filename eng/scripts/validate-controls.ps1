$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$searchPath = Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineSearchField.cs'
$segmentedPath = Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineSegmentedControl.cs'
$genericPath = Join-Path $root 'src/Glassline.WinUI.Controls/Themes/Generic.xaml'
$galleryXamlPath = Join-Path $root 'samples/Glassline.Gallery/MainWindow.xaml'

foreach ($path in @($searchPath, $segmentedPath, $genericPath, $galleryXamlPath)) {
    if (-not (Test-Path $path)) {
        throw "Missing controls baseline artifact: $path"
    }
}

$search = Get-Content $searchPath -Raw
$segmented = Get-Content $segmentedPath -Raw
$generic = Get-Content $genericPath -Raw
$gallery = Get-Content $galleryXamlPath -Raw

if ($search -notmatch 'class GlasslineSearchField : Control') {
    throw 'SearchField must remain a templated WinUI Control.'
}
if ($search -notmatch 'typeof\(TextBox\)' -or $search -notmatch 'as TextBox') {
    throw 'SearchField must keep a native WinUI TextBox as its input engine.'
}
if ($search -notmatch 'PART_Input' -or $search -notmatch 'PART_ClearButton') {
    throw 'SearchField template-part contract is incomplete.'
}
if ($search -match 'TextComposition|CoreText|InputMethod|IME') {
    throw 'SearchField must not introduce a custom text/IME engine.'
}
if ($segmented -notmatch 'typeof\(ListBox\)' -or $segmented -notmatch 'as ListBox') {
    throw 'SegmentedControl must delegate selection/input behavior to a native ListBox.'
}
if ($segmented -notmatch 'SelectionMode\.Single') {
    throw 'SegmentedControl must enforce native single-selection semantics.'
}
if ($segmented -notmatch 'PART_Selector') {
    throw 'SegmentedControl template-part contract is incomplete.'
}

[xml]$genericXml = $generic
if ($generic -notmatch 'x:Name="PART_Input"' -or $generic -notmatch 'x:Name="PART_ClearButton"' -or $generic -notmatch 'x:Name="PART_Selector"') {
    throw 'Generic.xaml does not satisfy the control template-part contracts.'
}
if ($generic -match 'CompositionBackdrop|BackdropBrush|Win2D|D2D|D3D|SF Pro|SF Symbols|Apple') {
    throw 'Controls baseline includes forbidden effect/asset implementation.'
}
if ($gallery -notmatch 'GlasslineSearchField' -or $gallery -notmatch 'GlasslineSegmentedControl') {
    throw 'Gallery must instantiate both baseline custom/composite controls.'
}

Write-Host 'Controls static/template contract validation passed.'

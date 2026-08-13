$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$themePath = Join-Path $root 'src/Glassline.WinUI.Theme/Themes/GlasslineTheme.xaml'

if (-not (Test-Path $themePath)) {
    throw 'Theme resource dictionary is missing.'
}

[xml]$xml = Get-Content $themePath -Raw
$ns = [System.Xml.XmlNamespaceManager]::new($xml.NameTable)
$ns.AddNamespace('p', 'http://schemas.microsoft.com/winfx/2006/xaml/presentation')
$ns.AddNamespace('x', 'http://schemas.microsoft.com/winfx/2006/xaml')

$themeNames = @($xml.SelectNodes('//p:ResourceDictionary.ThemeDictionaries/p:ResourceDictionary', $ns) | ForEach-Object { $_.GetAttribute('Key', 'http://schemas.microsoft.com/winfx/2006/xaml') })
foreach ($requiredTheme in @('Light', 'Dark', 'HighContrast')) {
    if ($themeNames -notcontains $requiredTheme) {
        throw "Missing required theme dictionary: $requiredTheme"
    }
}

$requiredKeys = @(
    'Glassline.Text.Primary',
    'Glassline.Text.Secondary',
    'Glassline.Text.Tertiary',
    'Glassline.Surface.Window',
    'Glassline.Surface.Group',
    'Glassline.Surface.Sidebar',
    'Glassline.Surface.Toolbar',
    'Glassline.Surface.Popover',
    'Glassline.Separator.Subtle',
    'Glassline.Selection.Active',
    'Glassline.Selection.Inactive',
    'Glassline.Accent',
    'Glassline.Focus',
    'Glassline.Destructive'
)

foreach ($theme in @('Light', 'Dark', 'HighContrast')) {
    $node = $xml.SelectSingleNode("//p:ResourceDictionary.ThemeDictionaries/p:ResourceDictionary[@x:Key='$theme']", $ns)
    if ($null -eq $node) {
        throw "Unable to inspect theme: $theme"
    }

    $keys = @($node.ChildNodes | Where-Object { $_.NodeType -eq [System.Xml.XmlNodeType]::Element } | ForEach-Object { $_.GetAttribute('Key', 'http://schemas.microsoft.com/winfx/2006/xaml') })
    foreach ($key in $requiredKeys) {
        if ($keys -notcontains $key) {
            throw "Theme '$theme' is missing semantic key '$key'."
        }
    }
}

$raw = Get-Content $themePath -Raw
if ($raw -match '#[0-9A-Fa-f]{6,8}') {
    throw 'Theme foundation must map semantic roles to WinUI resources; raw color literals are not accepted in this baseline.'
}
if ($raw -match 'AcrylicBrush|CompositionBackdrop|BackdropBrush|Win2D|D2D|D3D') {
    throw 'Theme package must not contain runtime optical/effect implementation.'
}
if ($raw -match 'SF Pro|SF Symbols|Apple') {
    throw 'Theme package contains a forbidden Apple asset/reference literal.'
}

Write-Host 'Theme resource contract validation passed.'

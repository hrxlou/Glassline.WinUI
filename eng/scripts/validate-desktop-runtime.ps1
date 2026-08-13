$ErrorActionPreference = 'Stop'

# Guards the WinUI 3 desktop runtime contract that compilation cannot prove.
#
# Glassline ships unpackaged Win32 desktop code. Several Windows.UI.ViewManagement /
# Windows.UI.Core APIs compile cleanly but require a CoreWindow at runtime, which desktop
# apps never have; subscribing to them throws COMException during startup. Separately,
# UISettings change events are raised on a background thread, so any handler that reaches
# XAML must marshal to the owning DispatcherQueue first.

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')

$sourceRoots = @(
    (Join-Path $root 'src'),
    (Join-Path $root 'samples'),
    (Join-Path $root 'tests')
)

$sourceFiles = Get-ChildItem -Path $sourceRoots -Filter '*.cs' -Recurse -File |
    Where-Object { $_.FullName -notmatch '[\\/](obj|bin)[\\/]' }

if ($sourceFiles.Count -eq 0) {
    throw 'No desktop source files found to validate.'
}

# APIs that compile in a desktop app but depend on CoreWindow at runtime.
$coreWindowOnlyApis = @{
    'AccessibilitySettings' = 'Use Microsoft.UI.System.ThemeSettings.CreateForWindowId instead; AccessibilitySettings.HighContrastChanged requires a CoreWindow.'
    'CoreWindow'            = 'CoreWindow does not exist in WinUI 3 desktop apps.'
    'CoreDispatcher'        = 'Use Microsoft.UI.Dispatching.DispatcherQueue instead of CoreDispatcher.'
    'CoreApplication'       = 'CoreApplication is not supported in WinUI 3 desktop apps.'
    'ApplicationView'       = 'Use Microsoft.UI.Windowing.AppWindow instead of ApplicationView.'
    'Windows.UI.Popups'     = 'Use Microsoft.UI.Xaml.Controls.ContentDialog instead of Windows.UI.Popups.'
}

$violations = @()

foreach ($file in $sourceFiles) {
    $raw = Get-Content $file.FullName -Raw
    $relativePath = $file.FullName.Substring($root.Path.Length + 1)

    # Comments legitimately name these APIs to explain why they are avoided, so scan code only.
    $content = [regex]::Replace($raw, '/\*.*?\*/', '', 'Singleline')
    $content = [regex]::Replace($content, '(?m)//.*$', '')

    foreach ($api in $coreWindowOnlyApis.Keys) {
        if ($content -match [regex]::Escape($api)) {
            $violations += "$relativePath uses '$api'. $($coreWindowOnlyApis[$api])"
        }
    }

    # UISettings events arrive on a background thread. Any file subscribing to one must
    # marshal through a DispatcherQueue before consumers touch XAML.
    if ($content -match 'uiSettings\.\w+Changed\s*\+=' -or $content -match '_uiSettings\.\w+Changed\s*\+=') {
        if ($content -notmatch 'DispatcherQueue') {
            $violations += "$relativePath subscribes to a UISettings event without DispatcherQueue marshalling; UISettings events are raised on a background thread."
        }
    }
}

if ($violations.Count -gt 0) {
    $report = $violations -join [Environment]::NewLine
    throw "Desktop runtime contract violations:$([Environment]::NewLine)$report"
}

# High Contrast policy must be sourced from the desktop-safe replacement API.
$highContrastConsumers = @(
    (Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineWindowBackdropController.cs'),
    (Join-Path $root 'src/Glassline.WinUI.Controls/GlasslineMaterialCapabilities.cs')
)

foreach ($path in $highContrastConsumers) {
    if (-not (Test-Path $path)) {
        throw "Missing desktop runtime baseline artifact: $path"
    }

    $content = Get-Content $path -Raw
    if ($content -notmatch 'ThemeSettings\.CreateForWindowId') {
        throw "$path must resolve High Contrast through ThemeSettings.CreateForWindowId."
    }
}

Write-Host "Desktop runtime contract validation passed across $($sourceFiles.Count) source files."

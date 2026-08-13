$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$documents = @(
    (Join-Path $root 'README.md'),
    (Join-Path $root 'docs/README.md')
)

$pattern = '(?<!\!)\[[^\]]+\]\(([^)]+)\)'

foreach ($document in $documents) {
    if (-not (Test-Path $document)) {
        throw "Missing navigation document: $document"
    }

    $content = Get-Content $document -Raw
    $baseDirectory = Split-Path $document -Parent

    foreach ($match in [regex]::Matches($content, $pattern)) {
        $target = $match.Groups[1].Value.Trim()

        if ($target -match '^(https?://|mailto:|#)') {
            continue
        }

        $pathOnly = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathOnly)) {
            continue
        }

        $pathOnly = [System.Uri]::UnescapeDataString($pathOnly)
        $resolvedTarget = [System.IO.Path]::GetFullPath((Join-Path $baseDirectory $pathOnly))

        if (-not (Test-Path $resolvedTarget)) {
            $relativeDocument = [System.IO.Path]::GetRelativePath($root, $document)
            throw "Broken local Markdown link in $relativeDocument: $target"
        }
    }
}

Write-Host 'Documentation navigation link validation passed.'

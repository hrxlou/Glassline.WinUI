$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$corpusDir = Join-Path $root 'research/corpus-index'
$corpusPath = Join-Path $corpusDir 'corpus-index.csv'
$measurementPath = Join-Path $root 'research/measurements/measurement-ledger.csv'

if (-not (Test-Path $corpusPath)) {
    throw 'Missing research/corpus-index/corpus-index.csv.'
}
if (-not (Test-Path $measurementPath)) {
    throw 'Measurement ledger must remain a separate tracked artifact.'
}

$rows = @(Import-Csv $corpusPath)
if ($rows.Count -lt 50) {
    throw "Corpus requires at least 50 data rows; found $($rows.Count)."
}

$requiredFields = @(
    'source_id','source_type','source_url','os_version','app','scene','appearance','state',
    'components','measurement_priority','asset_policy','notes'
)
$seenIds = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
$expectedSource = 'https://512pixels.net/projects/aqua-screenshot-library/macos-26-tahoe/'
$expectedPolicy = 'external-reference-only-do-not-redistribute'

foreach ($row in $rows) {
    foreach ($field in $requiredFields) {
        if ([string]::IsNullOrWhiteSpace($row.$field)) {
            throw "Corpus row '$($row.source_id)' has empty required field '$field'."
        }
    }

    if (-not $seenIds.Add($row.source_id)) {
        throw "Duplicate corpus source_id: $($row.source_id)"
    }
    if ($row.source_url -ne $expectedSource) {
        throw "Unexpected source URL for $($row.source_id): $($row.source_url)"
    }
    if ($row.asset_policy -ne $expectedPolicy) {
        throw "Corpus asset policy must stay external-reference-only for $($row.source_id)."
    }
    if ($row.source_url -match '\.(png|jpe?g|gif|webp|bmp|tiff?)(\?|$)') {
        throw "Corpus source_url must point to the public index page rather than an image binary: $($row.source_id)"
    }
    if ($row.appearance -ne 'unspecified-by-index' -or $row.state -ne 'unspecified-by-index' -or $row.components -ne 'pending-image-inspection') {
        throw "Uninspected visual detail was promoted beyond metadata-only status in $($row.source_id)."
    }
    if ($row.notes -notmatch 'inspect source image before measurement') {
        throw "Corpus row must preserve the measurement evidence boundary: $($row.source_id)"
    }
}

$imageExtensions = @('.png','.jpg','.jpeg','.gif','.webp','.bmp','.tif','.tiff')
$vendoredImages = @(Get-ChildItem $corpusDir -Recurse -File | Where-Object { $_.Extension.ToLowerInvariant() -in $imageExtensions })
if ($vendoredImages.Count -gt 0) {
    throw "Public corpus index must not vendor screenshot/image binaries: $($vendoredImages.FullName -join ', ')"
}

Write-Host "Public research corpus validation passed with $($rows.Count) metadata rows."

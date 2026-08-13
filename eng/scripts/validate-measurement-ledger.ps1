$ErrorActionPreference = 'Stop'

# Guards the measurement ledger, the M0 exit artifact.
#
# Every other contract in this repository is enforced by a script; the ledger was not, even though
# it is the one artifact whose credibility the whole design system rests on. This validates the
# schema and the evidence rules in research/measurements/README.md. It deliberately does not
# require rows to exist: an empty ledger is an honest, unfinished ledger. It fails when rows exist
# but cannot be traced to a capture or classified as evidence.

$root = Resolve-Path (Join-Path $PSScriptRoot '../..')
$ledgerPath = Join-Path $root 'research/measurements/measurement-ledger.csv'
$manifestPath = Join-Path $root 'research/AppleReferenceLab/capture-manifest.csv'

foreach ($path in @($ledgerPath, $manifestPath)) {
    if (-not (Test-Path $path)) {
        throw "Missing required research artifact: $path"
    }
}

$expectedColumns = @(
    'source_id', 'source_type', 'os_version', 'app', 'scene', 'component', 'state', 'appearance',
    'width', 'height', 'radius', 'padding_x', 'padding_y', 'gap', 'font_role',
    'material_role', 'selection_role', 'motion_note', 'confidence', 'asset_policy',
    'classification', 'notes'
)

$header = (Get-Content $ledgerPath -TotalCount 1).Trim()
$actualColumns = $header -split ','

if (Compare-Object $expectedColumns $actualColumns -SyncWindow 0) {
    throw "Measurement ledger header does not match the schema in docs/research/RESEARCH_METHOD.md.$([Environment]::NewLine)Expected: $($expectedColumns -join ',')$([Environment]::NewLine)Actual:   $header"
}

$manifest = Import-Csv $manifestPath
$captureIds = [System.Collections.Generic.HashSet[string]]::new()
foreach ($row in $manifest) {
    [void]$captureIds.Add($row.capture_id)
}

if ($captureIds.Count -eq 0) {
    throw "Capture manifest $manifestPath contains no capture ids."
}

$rows = @(Import-Csv $ledgerPath)

if ($rows.Count -eq 0) {
    Write-Host "Measurement ledger schema validation passed. Ledger holds 0 observed rows; M0 remains open on capture evidence."
    return
}

# Classification vocabulary from research/measurements/README.md.
$classifications = @('Observed', 'Inferred', 'Glassline decision')
$sourceTypes = @('AppleReferenceLab', 'Corpus', 'AppleDocumentation')
$geometryColumns = @('width', 'height', 'radius', 'padding_x', 'padding_y', 'gap')

$violations = @()
$lineNumber = 1

foreach ($row in $rows) {
    $lineNumber++
    $label = "row $lineNumber (source_id='$($row.source_id)')"

    if ([string]::IsNullOrWhiteSpace($row.source_id)) {
        $violations += "$label has no source_id; every row needs a source."
        continue
    }

    if ($row.classification -notin $classifications) {
        $violations += "$label has classification '$($row.classification)'; expected one of: $($classifications -join ', ')."
    }

    if ([string]::IsNullOrWhiteSpace($row.confidence)) {
        $violations += "$label has no confidence note."
    }

    if ($row.source_type -notin $sourceTypes) {
        $violations += "$label has source_type '$($row.source_type)'; expected one of: $($sourceTypes -join ', ')."
    }

    # An Observed row asserts something was measured from a real capture, so its source_id must be
    # a capture the manifest actually requires. Inferred and Glassline decision rows cite prose.
    if ($row.classification -eq 'Observed' -and $row.source_type -eq 'AppleReferenceLab') {
        if (-not $captureIds.Contains($row.source_id)) {
            $violations += "$label is Observed from AppleReferenceLab but '$($row.source_id)' is not a capture id in capture-manifest.csv."
        }
    }

    # Geometry without a classification of its provenance is exactly the guessed number the
    # research method forbids.
    $hasGeometry = $false
    foreach ($column in $geometryColumns) {
        if (-not [string]::IsNullOrWhiteSpace($row.$column)) {
            $hasGeometry = $true
            break
        }
    }

    if ($hasGeometry -and [string]::IsNullOrWhiteSpace($row.os_version)) {
        $violations += "$label records geometry without os_version; a measurement without an OS version is not reproducible."
    }

    if ([string]::IsNullOrWhiteSpace($row.asset_policy)) {
        $violations += "$label has no asset_policy; redistribution status must be explicit."
    }
}

if ($violations.Count -gt 0) {
    $report = $violations -join [Environment]::NewLine
    throw "Measurement ledger contract violations:$([Environment]::NewLine)$report"
}

$observed = @($rows | Where-Object { $_.classification -eq 'Observed' }).Count
Write-Host "Measurement ledger validation passed across $($rows.Count) rows ($observed Observed) against $($captureIds.Count) manifest capture ids."

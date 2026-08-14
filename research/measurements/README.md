# Measurement Ledger

Populate `measurement-ledger.csv` using the schema defined in `docs/research/RESEARCH_METHOD.md`.

Rules:
- `Observed` = directly measured/visible from a source.
- `Inferred` = derived by comparing sources.
- `Glassline decision` = intentionally chosen for Windows/Glassline behavior.
- Every row needs a source ID and confidence note.

An `Observed` row sourced from AppleReferenceLab must cite a `capture_id` from
`research/AppleReferenceLab/capture-manifest.csv`. Take the captures using
`research/AppleReferenceLab/CAPTURE_PROCEDURE.md`; it covers scale calibration, which is what makes
a measurement classifiable as Observed rather than assumed.

`eng/scripts/validate-measurement-ledger.ps1` enforces these rules in CI. It does not require rows to
exist — an empty ledger is an honest unfinished ledger — but rows that exist must be traceable and
classified.

## Verify a capture set before measuring it

```sh
python research/measurements/verify-captures.py <capture-directory>
```

This exists because a delivery passed a filename-and-scale review while 17 of its 18 inactive
captures were copies of their active counterparts. Correct names and a correct calibration rule say
nothing about whether a file holds the state its name claims.

The decisive check is the header. Each capture prints the window state the probe actually saw, so
two captures claiming different states must have different headers. Comparing whole images does not
work in either direction: a genuinely inactive window can differ from its active counterpart by very
little, while a re-encoded copy of the same state differs by a pixel of noise.

## How the current rows were measured

`measure-captures.py` produces them from the private capture set:

```sh
python research/measurements/measure-captures.py <capture-directory>
```

It measures scale from the 200 pt calibration rule inside each capture, anchors its search region to
that rule rather than to fixed pixel coordinates, and repeats every measurement across four mask
thresholds and six independent captures of the same control. A quantity that moves with the
threshold is reported unmeasurable rather than rounded into a row.

## What was measured and rejected

Corner radius was attempted for every control above and **rejected**. It is measurable, but not
stable: the same control reads 3.5–9.0 pt depending on the mask threshold, and the saturated
Prominent button reads consistently smaller than its neighbours despite being the same shape. That
is the threshold cutting an antialiased corner at different points, not a real difference. Two
estimators agreed exactly, but both derive from the same mask, so their agreement validates the
rounded-rectangle model rather than the threshold — a distinction worth keeping, because ignoring it
would have put a false 4.75 pt into the ledger.

Radius needs a subpixel-coverage estimator that does not threshold first. Until that exists, no
radius row belongs here.

Control **width** is omitted where it tracks the label rather than the control.

`toggle-slider` produced no row: the toggle and the slider are different shapes on one band, and the
band grouping mixes them, so the height read 16.0–21.5 pt. Correctly flagged unstable, and it needs
per-control handling rather than a looser tolerance.

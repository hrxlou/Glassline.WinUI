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

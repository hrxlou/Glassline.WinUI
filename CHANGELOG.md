# Changelog

All notable project changes are recorded here. The project has not published a public NuGet release yet.

## Unreleased

### Build / package foundation

- Added a real WinUI 3 solution with Theme, Controls, Effects, and Gallery projects targeting .NET 8 / Windows 11 build 22000, x64 and ARM64.
- Added Windows CI for repository/resource/control/material/Gallery/corpus contracts, deterministic logic smokes, x64/ARM64 builds, NuGet pack, generated-package consumer compilation, and forbidden-asset scanning.
- Added shared MIT/repository package metadata and .NET package validation.
- Added generated nuspec/dependency-boundary validation and SPDX 2.2 SBOM generation/validation.

### Theme / window / materials

- Added semantic Light, Dark, and High Contrast Theme resources.
- Added native `Window.SystemBackdrop` Auto/Mica/MicaAlt/Solid window foundation with mandatory Solid accessibility/transparency fallback.
- Added semantic material roles, adaptive Auto/Full/Reduced/Solid policy, Windows environment capability signals, and grouped `GlasslineGlassContainer` regions.
- Added current provisional Full=Desktop Acrylic / Reduced=MicaAlt / Solid=semantic surface baseline.

### Fixed

- Replaced `AccessibilitySettings` with `Microsoft.UI.System.ThemeSettings` in `GlasslineWindowBackdropController` and `GlasslineMaterialCapabilities`. `AccessibilitySettings.HighContrastChanged` requires a `CoreWindow`, which WinUI 3 desktop apps do not have, so subscribing threw `COMException` and terminated the Gallery during startup on every launch.
- Marshalled `UISettings.AdvancedEffectsEnabledChanged` handling onto the owning `DispatcherQueue`. `UISettings` events are raised on a background thread while both handlers mutate XAML, so toggling Windows transparency effects could crash with a wrong-thread failure.
- Added `eng/scripts/validate-desktop-runtime.ps1` to CI. It rejects CoreWindow-dependent UWP APIs in desktop source and requires `DispatcherQueue` marshalling for `UISettings` subscriptions; both defects above were previously invisible to a fully green build.

### Changed (source-breaking, pre-release)

- `GlasslineMaterialCapabilities` now requires the owning `WindowId` in its constructor, because `ThemeSettings` is created per window. `GlasslineGlassContainer` resolves it from `XamlRoot.ContentIslandEnvironment` on load, and falls back to the Solid material when no content island is available.

### Controls / accessibility source contract

- Added `GlasslineSearchField` using a native WinUI TextBox input/IME path.
- Added `GlasslineSegmentedControl` using a native WinUI ListBox single-selection path.
- Added non-invasive wrapper AutomationPeers with stable Group/class identity while preserving native provider patterns.

### Gallery / validation

- Added deterministic window-foundation, material-regions, and controls-matrix scenes with stable AutomationIds.
- Added material/environment diagnostics and activation/continuous-resize propagation.
- Added deterministic performance workloads: Settings 100 rows, Grid 500 items, Tree 5000 non-root nodes.
- Added pure material-policy, Gallery scene-selection, and benchmark-data executable smoke tests.

### Research

- Added a 70-row public-safe macOS 26 Tahoe metadata corpus without vendoring referenced images or inventing measurements.
- Added a buildable SwiftUI/AppKit AppleReferenceLab with stable reference scenes, scene tests, and macOS 26 hosted release-build validation.
- Kept observed measurement-ledger work explicitly pending native reference capture.
- Added a deterministic capture matrix: `CaptureMatrix` enumerates 9 scenes × 8 variants, emits `capture-manifest.csv`, and a test pins the committed manifest to the generator. Each `capture_id` is the vocabulary a measurement-ledger row cites as `source_id`.
- Added a 200 pt calibration rule and `backing_scale` readout to every probe scene, so a capture records the pixel-to-point factor its own measurements depend on.
- Added an interaction axis to the capture matrix: `hover`, `pressed`, and `focused` for the designated state probe in `buttons`, `toggle-slider`, `text-input`, and `pickers`. The probe publishes its own interaction state so the header stays self-proving, and `normal` appends nothing to a `capture_id`, leaving every id minted before the axis unchanged.
- Added `research/AppleReferenceLab/capture-session.sh`, a guided session that walks the manifest, minimises system-settings changes, and writes each file under the manifest's own `capture_id` so the operator never types a filename.
- Added `research/measurements/verify-captures.py`, which checks a capture set before anything is measured from it: manifest coverage, calibration scale, content duplication, and — decisively — that an inactive capture's in-capture header actually reports `window=inactive`. A delivery passed two filename-and-scale reviews while 17 of its 18 inactive captures were copies of the active state.
- Corrected the first six ledger rows from "6 captures" to the number of distinct captured states behind them. The measured values were unchanged; the claimed evidence strength was not.
- Redefined the `increase-contrast` capture variant to the coupled state macOS actually exposes. macOS 26.5.2 forces Reduce Transparency on with Increase Contrast, so requiring an isolated contrast state made the variant unreachable and cost a capture session 18 captures.
- Added a live capture-context header: the probe resolves the current appearance, window state, and accessibility mode to a `capture_id` and prints it, reports the full accessibility environment, and shows a warning when the backing scale is below 2x. Captures are named from what the header shows rather than from what the operator intended to set.
- Added `research/AppleReferenceLab/CAPTURE_PROCEDURE.md` covering the required set, machine record, scale calibration, capture naming, and the capture-to-ledger rules.
- Added `eng/scripts/validate-measurement-ledger.ps1` to CI. It enforces the ledger schema, classification vocabulary, confidence and asset-policy fields, `os_version` on any row carrying geometry, and that an `Observed` AppleReferenceLab row cites a capture id the manifest actually requires. An empty ledger remains valid.

### Documentation

- Reconciled project status, milestone plan, material architecture, validation strategy, environment boundary, decisions, backlog, research status, and next native-evidence work after the hosted implementation pass.

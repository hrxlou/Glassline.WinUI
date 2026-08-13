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

### Documentation

- Reconciled project status, milestone plan, material architecture, validation strategy, environment boundary, decisions, backlog, research status, and next native-evidence work after the hosted implementation pass.

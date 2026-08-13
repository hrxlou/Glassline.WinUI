# Decisions: resolved, provisional, and pending

Last updated: **2026-08-13**.

This file separates decisions already encoded in the repository from choices that still require native evidence or release planning.

## Resolved engineering baseline

| Decision | Current resolution |
|---|---|
| Repository/package brand | `Glassline.WinUI` |
| License | MIT |
| Platform focus | Windows 11-first, pure WinUI 3 |
| .NET target | `net8.0-windows10.0.22000.0` |
| Minimum target platform | `10.0.22000.0` |
| Architectures | x64 + ARM64 |
| Windows App SDK | centrally pinned 2.3.1 engineering baseline |
| Theme dependency model | Theme stays WinUI/XAML-focused; no hard Effects dependency |
| Controls language | C# first-class |
| Window foundation | native `Window.SystemBackdrop`, Auto/Mica/MicaAlt/Solid |
| Functional material primitive | grouped `GlasslineGlassContainer`, one backdrop region per functional group |
| Material quality contract | Auto / Full / Reduced / Solid with accessibility/environment downgrade |
| Text input strategy | native TextBox remains input/IME engine inside SearchField |
| Segmented selection strategy | native ListBox single-selection engine |
| Composite wrapper UIA identity | non-invasive Group AutomationPeers; native parts keep rich provider patterns |
| Public research assets | metadata/source references only; no Apple screenshots/fonts/symbol exports shipped |
| Corpus minimum | satisfied with 70 metadata rows; measurements are a separate evidence task |
| AppleReferenceLab skeleton | buildable SwiftUI/AppKit probe with macOS 26 CI |
| Benchmark workload sizes | Settings 100 rows; Grid 500 items; Tree 5000 non-root nodes |

## Provisional decisions requiring evidence

### Full/Reduced renderer mapping

Current engineering mapping:

- Full = Desktop Acrylic
- Reduced = MicaAlt
- Solid = semantic opaque surface

This is deliberately provisional. Native screenshot/performance evidence decides whether Full remains built-in or moves to a custom Composition material.

### Material geometry and optical constants

Spacing/radius semantic tokens exist as an engineering baseline, but component/material geometry must be retuned only after observed macOS reference measurements are in the ledger. No unobserved “Tahoe pixel” numbers should be frozen as compatibility contracts.

### Performance budgets

Benchmark scenes exist, but numerical P50/P95/P99, memory, GPU, and region-area budgets remain unset until repeatable runs exist on agreed Windows reference hardware.

## Open decisions

- C++/WinRT support boundary for Theme and any control-facing API.
- Final icon provenance/base set and optical-normalization workflow.
- Reference Windows CPU/GPU/RAM/display/driver configuration.
- Screenshot golden reviewer/approval policy and perceptual-diff thresholds.
- Final Full material implementation after visual/performance review.
- Whether any custom Composition pointer/specular/scroll-edge effects are justified.
- Advanced refraction/lensing go/no-go.
- Preview NuGet feed and release/publishing workflow.
- First public API review and versioning baseline.
- Cross-version API-compatibility baseline package/version after a real package is published.
- Reference macOS hardware/OS point version used for final observed measurements.

## Decision rule

A choice that depends on rendered quality, accessibility behavior, IME, DPI, RDP, or performance must not be closed using hosted compilation alone. Record the native evidence path before moving it from Open/Provisional to Resolved.

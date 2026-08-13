# Project Status

> **Update this file whenever milestone or evidence state changes.**  
> Last updated: **2026-08-14**  
> Current project phase: **M0 — Corpus & Decisions, blocked on observed measurement evidence**  
> Parallel engineering baseline: **M1/M2/M3 work has started and is CI-validated where hosted execution is meaningful**  
> Remote repository: `hrxlou/Glassline.WinUI`  
> Public release: **not published / not release-ready**

## Executive status

Glassline.WinUI has moved well beyond a documentation-only repository. The repo now contains a real WinUI 3 solution, semantic Theme resources, native Mica/Solid window-foundation code, a shared adaptive material-region runtime, two C# custom/composite controls with non-invasive AutomationPeers, deterministic Gallery validation scenes, performance workload scenes, NuGet/package-consumer validation, supply-chain metadata/SBOM validation, a 70-scene public-safe Tahoe corpus index, and a buildable AppleReferenceLab verified on macOS 26 CI.

The project **remains in M0** because the reference-measurement task is intentionally not faked. The corpus index and AppleReferenceLab source are ready, but `research/measurements/measurement-ledger.csv` does not yet contain the observed Button/Toggle/Slider/Sidebar/Toolbar/Popover measurements needed to turn references into evidence-backed Glassline decisions.

Until 2026-08-14 none of that Windows baseline had ever run. `AccessibilitySettings.HighContrastChanged` requires a `CoreWindow`, which WinUI 3 desktop apps do not have, so the Gallery threw during startup on every launch while CI stayed green. Every "implemented baseline" row below was compile-and-contract evidence only. The Gallery now reaches an interactive window, which unblocks native-acceptance actions 3–8 for the first time; those actions were previously not merely undone but impossible.

The current material implementation is therefore an engineering scaffold, not final Tahoe/Liquid-Glass fidelity: **native Mica/Solid window foundation → grouped `GlasslineGlassContainer` regions → adaptive Full/Reduced/Solid policy → optional advanced optics later**. Full currently uses built-in Desktop Acrylic and Reduced uses MicaAlt; those choices remain provisional until native visual/performance review.

## Progress snapshot

| Track | State | Evidence / boundary |
|---|---|---|
| Product contract / scope | Done for M0 | Windows-native behavior boundary and non-goals documented |
| Architecture/package contract | Implemented baseline | Theme / Controls / Effects / Gallery projects and dependency boundaries exist |
| Semantic Theme | Partial M1 — implemented baseline | Light/Dark/High Contrast resources compile; native visual tuning remains |
| Window foundation | Partial M1 — implemented baseline | `Window.SystemBackdrop` Auto/Mica/MicaAlt/Solid controller; first desktop launch recorded 2026-08-14; native appearance/DPI/window acceptance pending |
| Shared material runtime | Partial M2 — implemented baseline | one grouped backdrop region, role/quality contracts, environment policy, Full/Reduced/Solid; capability source constructs on a live `XamlRoot` without throwing |
| Advanced optical/refraction path | Not started by design | blocked until baseline native visual/performance evidence |
| P0 composite controls | Partial M3 — engineering baseline | SearchField + SegmentedControl compile/package; native interactive DoD pending |
| Composite AutomationPeers | Implemented baseline | wrapper Group/class identity; live UIA/Narrator tree/provider behavior pending |
| Gallery validation vehicle | Implemented baseline | deterministic scenes, AutomationIds, diagnostics, resize/activation propagation |
| Performance workload vehicle | Implemented baseline | deterministic 100-row / 500-item / 5000-node scenes; no performance numbers claimed |
| Public Tahoe corpus index | **Done for M0 metadata task** | 70 unique metadata rows; no images or guessed measurements |
| AppleReferenceLab skeleton | **Done for M0 buildable-probe task** | SwiftUI/AppKit probe tests + release build pass on macOS 26 CI; first interactive session 2026-08-14 rendered all 9 scenes on macOS 26.5.2 but at 1x, inactive-only, from a pre-calibration build — structural reference only, no measurable capture yet |
| Measurement ledger | **Partial — M0 blocker** | schema/header exists and is CI-enforced; 72-capture manifest and capture procedure ready; observed measurement rows still required |
| Windows CI | Passing baseline | static contracts, pure smokes, x64/ARM64 build, pack/package consumer, desktop-runtime API contract |
| Package/supply-chain validation | Implemented baseline | package validation, generated nuspec/dependency checks, forbidden assets, SPDX SBOM |
| Public NuGet | Not started | intentionally blocked on native acceptance/API-release decision |
| Cross-version API compatibility | Prepared but inactive | no real released Glassline package exists yet to serve as truthful baseline |

## M0 task accounting

The original six primary M0 dashboard tasks now stand at:

- [x] Repository/bootstrap — public repo, MIT, buildable WinUI solution, CI.
- [x] AppleReferenceLab skeleton — buildable SwiftUI/AppKit probe with macOS 26 CI.
- [x] 50+ visual corpus index — **70** public-safe metadata rows committed and validated.
- [~] Measurement ledger — schema exists; observed reference measurements are still missing.
- [x] ADR baseline — ADR-0001 through ADR-0010 established.
- [x] Brand/package name — `Glassline.WinUI` finalized.

**M0 primary-task progress: 5/6 complete, 1 partial, 0 not started.** M0 does not exit until observed measurements are captured and reviewed; implementation progress in later milestones does not waive that evidence requirement.

## Implemented hosted-environment baseline

### Theme / Window

- Windows 11 engineering target: `net8.0-windows10.0.22000.0`, minimum platform `10.0.22000.0`, x64 + ARM64.
- Windows App SDK 2.3.1 is centrally pinned.
- semantic Light/Dark/High Contrast resources use WinUI/Windows theme semantics instead of shipping Apple fonts/symbols/assets.
- `GlasslineWindowBackdropController` uses native WinUI `Window.SystemBackdrop` and forces Solid for High Contrast/transparency-off policy.

### Material runtime

- `GlasslineGlassContainer` is a `ContentControl` with one `SystemBackdropElement` per grouped material region.
- semantic roles: Sidebar, Toolbar, Popover, Interactive, Prominent.
- quality: Auto / Full / Reduced / Solid.
- deterministic policy: High Contrast or transparency-off → Solid; RDP/resize/inactive → Reduced; capable active local Auto/Full → Full.
- current baseline: Full = Desktop Acrylic, Reduced = MicaAlt, Solid = semantic opaque surface.
- GPU vendor/model allowlists and per-item backdrop pipelines are rejected by static contract tests.

### Controls / Accessibility source contract

- `GlasslineSearchField` keeps a native TextBox as the input, text, selection, clipboard, IME, and rich automation-pattern engine.
- `GlasslineSegmentedControl` keeps a native ListBox in single-selection mode.
- each wrapper has a `FrameworkElementAutomationPeer` with stable Glassline class identity and Group control type; wrapper peers deliberately do not duplicate native TextBox/ListBox value/text/selection provider patterns.

### Gallery / Validation harness

Stable validation scenes:

- `window-foundation`
- `material-regions`
- `controls-matrix`
- `benchmark-settings`
- `benchmark-grid`
- `benchmark-tree`

Gallery tracks native window activation and recent resize state, applies them to material regions, exposes environment/material diagnostics, and gives scenes stable AutomationIds for future screenshot/UIA/performance drivers.

Benchmark workload sizes are executable CI contracts:

- Settings: exactly 100 rows.
- Productivity Grid: exactly 500 items.
- Tree: exactly 100 roots × 50 children = 5000 non-root nodes.

### Research

- public corpus: 70 metadata-only macOS 26 Tahoe scene rows, all external-reference-only.
- AppleReferenceLab: buttons, toggle/slider, text input, pickers, sidebar, toolbar, menu/popover, window, accessibility-state scenes.
- AppleReferenceLab scene catalog/selection tests and release build run on macOS 26 CI.
- neither the corpus index nor AppleReferenceLab compilation is treated as a substitute for observed measurements.

### Packaging / supply chain

- Theme/Controls/Effects packages are generated in CI.
- .NET package validation is enabled.
- generated nuspec metadata and package dependency boundaries are checked.
- forbidden font/design-asset extensions are rejected from packages.
- a fresh WinUI consumer restores generated `Glassline.WinUI.Controls` and compiles without a Glassline project reference.
- an SPDX 2.2 SBOM is generated and validated for the package artifact set.

## Hosted evidence vs native evidence

The authoritative boundary is [`engineering/ENVIRONMENT_BOUNDARY.md`](engineering/ENVIRONMENT_BOUNDARY.md).

Hosted green CI is valid evidence for compilation, static contracts, deterministic pure logic, package construction/consumption, corpus metadata rules, and AppleReferenceLab buildability. As the 2026-08-14 startup defect showed, it is not even evidence that the app starts. It is **not** evidence for pixel appearance, compositor quality, Narrator behavior, IME candidate UI, real DPI/multi-monitor behavior, pointer/touch interaction, RDP experience, or performance numbers.

## Next 10 actions

These are now primarily evidence/tuning tasks rather than more speculative source expansion:

1. Run AppleReferenceLab on an interactive macOS 26 reference machine and take the 72 captures enumerated in `research/AppleReferenceLab/capture-manifest.csv`, following `research/AppleReferenceLab/CAPTURE_PROCEDURE.md`.
2. Populate the first observed measurement-ledger rows for Button, Toggle, Slider, Sidebar, Toolbar, and Popover; classify each value as Observed/Inferred/Glassline decision.
3. Capture native Windows Gallery window-foundation and material-region baselines for Light/Dark/High Contrast, active/inactive, Full/Reduced/Solid.
4. Execute live Narrator/UIA tree/provider tests for SearchField and SegmentedControl; verify native TextBox/ListBox patterns remain accessible without duplicate wrapper announcements.
5. Execute Korean, Japanese, and Simplified Chinese IME composition/candidate tests plus clipboard/selection/undo/redo tests.
6. Verify 100/125/150/200% display scale, agreed text-scale matrix, RTL/long localization, and mixed-DPI multi-monitor movement.
7. Verify Snap, maximize/restore, resize, system menu, Alt+F4, mouse, precision touchpad, touch where available, and local/RDP transitions.
8. Run the deterministic benchmark scenes on agreed reference Windows hardware and record P50/P95/P99 frame time, memory delta, available GPU signals, material-region count/area, and effective mode.
9. Decide from evidence whether built-in Desktop Acrylic is acceptable for Full or whether a custom Composition material is warranted; only then tune final optical values.
10. After native acceptance and first preview API review, publish the first real package baseline and activate cross-version API compatibility against that package.

## Current blockers / evidence-dependent decisions

- observed reference measurements are the remaining M0 task blocker;
- reference Windows CPU/GPU/RAM/display/driver and screenshot reviewer policy must be chosen;
- final Full material implementation is provisional until native visual/performance evidence exists;
- C++/WinRT Theme support boundary and icon-provenance strategy remain open;
- preview NuGet feed/release workflow remains intentionally deferred;
- cross-version API compatibility requires the first real published package baseline.

## Status change log

- **2026-08-14:** First interactive macOS 26 session ran the probe across all 9 scenes on macOS 26.5.2. Every capture was 1x, inactive-window, and from a build predating the calibration rule, so none can support a geometry row; they stand as structural reference only and no ledger rows were added. The probe now resolves and prints its own `capture_id`, reports the live accessibility environment, and warns below 2x, so the same session cannot silently repeat.
- **2026-08-14:** Made the M0 capture task executable: deterministic 72-capture manifest generated and pinned by `CaptureMatrix`, per-scene scale calibration in the probe, a written capture procedure, and CI enforcement of the measurement-ledger schema and evidence rules. No captures taken and no ledger rows added; M0 remains open.
- **2026-08-14:** Replaced CoreWindow-dependent APIs with `Microsoft.UI.System.ThemeSettings` and marshalled background-thread `UISettings` events, fixing a startup crash that had made every Gallery launch fail. Added `validate-desktop-runtime.ps1` so the class of defect cannot reappear invisibly. First desktop launch of the window-foundation and material-region path recorded in the window-backdrop and material acceptance docs; launch survival only, no visual or performance claim.
- **2026-08-13:** Hosted implementation pass completed through native Mica/Solid window foundation, shared adaptive material runtime, deterministic Gallery diagnostics, benchmark workloads, non-invasive AutomationPeers, 70-row public-safe corpus, buildable AppleReferenceLab/macOS 26 CI, package validation, generated-package consumer validation, and SBOM supply-chain checks.
- **2026-08-13:** M0 accounting advanced to 5/6 complete + 1 partial. M0 remains open because observed measurement-ledger evidence has not been captured.
- **2026-08-13:** Earlier build, Theme, Controls, material-architecture, repository/bootstrap, naming, and licensing baselines established.

# Bootstrap / Evidence Backlog

Status as of **2026-08-13**. A checked hosted item means its source/CI contract exists; it does not imply native visual acceptance unless explicitly stated.

## Repository / projects

- [x] `Glassline.WinUI.sln` exists.
- [x] `Glassline.WinUI.Theme` buildable class library.
- [x] `Glassline.WinUI.Controls` buildable class library.
- [x] `Glassline.WinUI.Effects` buildable class library/scaffold.
- [x] `Glassline.Gallery` buildable WinUI app.
- [x] separate generated-NuGet package consumer.
- [x] pure material-policy smoke executable.
- [x] pure Gallery scene-selection smoke executable.
- [x] pure benchmark-data smoke executable.
- [x] x64 + ARM64 Windows build matrix.

## Research M0

- [x] research source hierarchy/provenance policy.
- [x] public corpus schema.
- [x] public corpus >=50 scenes — 70 metadata rows currently validated.
- [x] no screenshot binaries / external-reference-only corpus policy enforced.
- [x] AppleReferenceLab buildable SwiftUI/AppKit probe source.
- [x] AppleReferenceLab stable scene catalog and deterministic selection tests.
- [x] AppleReferenceLab macOS 26 hosted test/build CI.
- [ ] AppleReferenceLab interactive Light/Dark captures.
- [ ] active/inactive captures.
- [ ] Normal/Hover/Pressed/Focused/Disabled/Selected captures where applicable.
- [ ] Reduce Transparency / Increase Contrast / Reduce Motion captures.
- [~] measurement ledger — schema/header only.
- [ ] observed Button measurement set.
- [ ] observed Toggle/Slider measurement set.
- [ ] observed Sidebar/Toolbar/Popover measurement set.
- [ ] initial measurement review and Glassline decision rows.

## M1 Foundation

- [x] semantic Light/Dark/High Contrast colors/surfaces.
- [x] semantic typography baseline.
- [x] spacing token baseline.
- [x] radius token baseline.
- [x] Windows 11/.NET/WinAppSDK engineering target locked.
- [x] native Mica/MicaAlt/Solid window-foundation controller.
- [x] High Contrast/transparency-off Solid policy.
- [ ] native window screenshot baseline.
- [ ] active/inactive + resize/Snap/mixed-DPI/RDP acceptance.
- [ ] evidence-backed DesignGeneration public contract decision.

## M2 Material runtime

- [x] semantic material role enum.
- [x] Auto/Full/Reduced/Solid quality contract.
- [x] deterministic High Contrast/effects/RDP/active/resize policy.
- [x] one-region-per-group `GlasslineGlassContainer` baseline.
- [x] shared Sidebar/Toolbar material Gallery scenes.
- [x] current built-in Full/Reduced renderer mapping.
- [x] material diagnostics: effective mode, environment, region count/area.
- [ ] native Full/Reduced/Solid visual acceptance.
- [ ] native continuous-resize/RDP/activation transition acceptance.
- [ ] decide built-in Desktop Acrylic vs custom Composition Full path.
- [ ] pointer/specular/scroll-edge treatment from evidence.
- [ ] advanced refraction/lensing go/no-go — intentionally last.

## M3 Controls baseline

- [x] SearchField with native TextBox.
- [x] SegmentedControl with native ListBox single-selection.
- [x] dependency-property/template-part contracts.
- [x] wrapper AutomationPeer class/group identity.
- [x] static rule preventing duplicate wrapper value/text/selection provider patterns.
- [ ] live Narrator/UIA tree/provider acceptance.
- [ ] KR/JP/ZH IME acceptance.
- [ ] DPI/text-scale/RTL/localization acceptance.
- [ ] screenshot/interaction visual DoD.
- [ ] measured remaining P0 controls after Definition of Ready.

## Gallery / testing

- [x] deterministic scene IDs and AutomationIds.
- [x] command-line/environment scene selection.
- [x] activation/resize propagation to material regions.
- [x] environment/material diagnostics.
- [x] benchmark-settings 100-row workload.
- [x] benchmark-grid 500-item workload.
- [x] benchmark-tree 5000-node workload.
- [x] benchmark exact-count executable smoke.
- [ ] native screenshot capture driver/goldens.
- [ ] live UIA/Narrator automation lane.
- [ ] native IME automation/manual evidence lane.
- [ ] native DPI/mixed-monitor/window/input matrix.
- [ ] native reference-hardware performance measurements.

## Packaging / CI / supply chain

- [x] NuGet pack for Theme/Controls/Effects.
- [x] package validation enabled.
- [x] generated nuspec metadata/license/repository validation.
- [x] generated package dependency-boundary validation.
- [x] forbidden font/design-asset scan.
- [x] fresh generated-package WinUI consumer compile.
- [x] SPDX 2.2 SBOM generation/validation artifact.
- [x] repository policy CI.
- [ ] first public preview package/feed.
- [ ] public API review for first preview.
- [ ] cross-version API compatibility against a **real published** prior Glassline package.
- [ ] screenshot reviewer/reference-hardware policy.

## Architecture / ADR

- [x] ADR-0001 pure WinUI.
- [x] ADR-0002 Windows caption semantics.
- [x] ADR-0003 semantic tokens.
- [x] ADR-0004 functional glass vs content.
- [x] ADR-0005 no Apple assets.
- [x] ADR-0006 Theme cross-language intent / Controls C# first.
- [x] ADR-0007 Windows 11 full-fidelity target.
- [x] ADR-0008 Design Generation separated from SemVer.
- [x] ADR-0009 advanced refraction optional/non-blocking.
- [x] ADR-0010 material architecture.

## Current blocking sequence

1. native macOS captures;
2. observed measurement ledger;
3. native Windows visual/UIA/IME/DPI/window/input acceptance;
4. reference-hardware performance measurements;
5. evidence-backed final material and component tuning;
6. first preview API/release baseline.

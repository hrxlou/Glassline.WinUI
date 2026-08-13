# Environment and Evidence Boundary

Status: **authoritative execution/evidence boundary for Glassline.WinUI**.

This document answers three separate questions:

1. What can be implemented in the hosted repository environment?
2. What can hosted CI actually prove?
3. What still requires an interactive native Windows or macOS environment?

A task may have source implemented while its final Definition of Done remains open.

## 1. Hosted repository environment — implementation scope

The current environment can implement and review:

- repository structure, issues, branches, PRs, ADRs, status/planning documentation;
- WinUI C# source, XAML ResourceDictionaries, templates, DependencyProperties, VisualStates, AutomationPeer source;
- Theme / Controls / Effects / Gallery project structure and package boundaries;
- native-control composition that keeps TextBox/ListBox/etc. as input/accessibility engines;
- window-backdrop/material policy source and fallback logic;
- deterministic Gallery scenes, diagnostics, benchmark workload source, and future-driver AutomationIds;
- pure policy/data tests and static architecture/resource contracts;
- NuGet packaging metadata, package-consumer tests, package validation, asset scanning, and SBOM generation;
- public-safe research metadata/provenance indexes;
- AppleReferenceLab SwiftUI/AppKit source and deterministic scene tests.

## 2. Hosted Windows CI — evidence it can prove

GitHub-hosted Windows runners are valid evidence for:

- x64/ARM64 restore and compilation;
- WinUI XAML compilation;
- warnings-as-errors build health;
- deterministic source/resource/template/architecture contracts;
- pure material-policy, scene-selection, and benchmark-data execution;
- NuGet pack success;
- generated package metadata/dependency structure;
- forbidden asset absence in generated packages;
- a fresh WinUI consumer compiling against generated NuGet packages;
- package validation and SPDX SBOM generation/validation.

### Hosted Windows CI cannot prove

It does **not** prove:

- that Mica/Acrylic/custom Composition looks correct on a desktop;
- pixel/screenshot fidelity;
- animation or pointer interaction quality;
- Narrator speech/read order;
- live UIA tree/provider behavior;
- Korean/Japanese/Chinese IME candidate/composition UI;
- actual display-scale or mixed-monitor behavior;
- touch/touchpad interaction;
- Snap/system-menu/resize user experience;
- RDP visual experience;
- real frame pacing/GPU/memory performance on project reference hardware.

## 3. Hosted macOS 26 CI — evidence it can prove

The AppleReferenceLab workflow is valid evidence for:

- Swift Package correctness;
- Swift scene-catalog/selection tests;
- SwiftUI/AppKit source compatibility with the hosted macOS 26 toolchain;
- release buildability of the native probe executable.

### Hosted macOS CI cannot prove

It does **not** prove:

- approved visual captures;
- active/inactive material appearance;
- hover/pressed/focused/disabled/selected appearance;
- accessibility-setting appearance;
- physical-display scaling/quality;
- animation/motion observations;
- geometry, radius, spacing, color, opacity, blur, or material measurements.

Those require an interactive native Mac capture session.

## 4. Native Windows — required evidence

Use native Windows for:

- Gallery launch and visual inspection;
- Mica/Acrylic/material screenshot baselines;
- Light/Dark/High Contrast and effects-on/off transitions;
- active/inactive and resize material behavior;
- Narrator and UI Automation tree/provider inspection;
- Korean/Japanese/Simplified Chinese IME;
- 100/125/150/200% DPI, text scale, RTL, long localization, mixed monitors;
- mouse, precision touchpad, touch;
- Snap, system menu, maximize/restore, Alt+F4, continuous resize;
- local/RDP behavior;
- frame-time, process-memory, GPU, resize, and material-region performance measurements.

Relevant ledgers:

- `CONTROLS_NATIVE_ACCEPTANCE.md`
- `WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md`
- `MATERIAL_NATIVE_ACCEPTANCE.md`
- `GALLERY_NATIVE_ACCEPTANCE.md`
- `PERFORMANCE_NATIVE_ACCEPTANCE.md`

## 5. Native macOS — required evidence

Use an interactive macOS reference environment for:

- AppleReferenceLab Light/Dark captures;
- active/inactive windows;
- Normal/Hover/Pressed/Focused/Disabled/Selected states;
- control-size/accent variants;
- Reduce Transparency / Increase Contrast / Reduce Motion variants;
- resize/scroll/menu/popover motion observations;
- observed geometry/material measurements.

The capture procedure and scene catalog live in `../../research/AppleReferenceLab/README.md`.

## 6. Evidence rules

These equivalences are prohibited:

- **compile success ≠ visual pass**
- **XAML compile ≠ screenshot pass**
- **AutomationPeer source ≠ Narrator/UIA behavior pass**
- **native TextBox in template ≠ IME candidate-window pass**
- **deterministic benchmark counts ≠ performance budget**
- **package consumer compile ≠ runtime UX acceptance**
- **70-row corpus index ≠ 70 measured scenes**
- **AppleReferenceLab build ≠ reference capture**
- **hosted macOS runner ≠ interactive reference machine**
- **built-in Desktop Acrylic baseline ≠ final Glassline optical decision**

## 7. Current practical boundary

After the 2026-08-13 hosted implementation pass, the highest-value remaining blockers are predominantly native evidence tasks. Additional large visual-control expansion without measurements would increase speculative surface area rather than confidence.

Therefore the next development checkpoint is triggered by **new native evidence**: observed AppleReferenceLab measurements, Windows visual/accessibility/IME/DPI results, and reference-hardware performance data. Source work can continue for defects or evidence-driven changes, but unmeasured fidelity tuning should not bypass this boundary.

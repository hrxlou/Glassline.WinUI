# Glassline.WinUI

[![Windows build](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/windows-build.yml/badge.svg)](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/windows-build.yml)
[![AppleReferenceLab macOS](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/reference-lab-macos.yml/badge.svg)](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/reference-lab-macos.yml)
[![Repository policy checks](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/policy-checks.yml/badge.svg)](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/policy-checks.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Glassline.WinUI** is a native WinUI 3 design system for Windows 11 focused on translucent functional materials, layered depth, desktop-oriented density, and Windows-native behavior.

The project keeps WinUI controls, Windows text/IME behavior, accessibility, window management, keyboard conventions, Snap/resize semantics, and the Windows compositor as first-class constraints. It changes the visual system and adds desktop shell/material primitives rather than replacing Windows with a custom cross-platform renderer.

> **Engineering preview:** buildable Theme, Controls, Effects, Gallery, research, and validation infrastructure exist in the repository. Glassline is not published on NuGet and is not release-ready. Hosted CI proves source/package contracts; native visual, accessibility, IME, DPI, input, window-behavior, and performance acceptance remains open.

## Implemented engineering baseline

### Theme and window foundation

- `Glassline.WinUI.Theme` provides Light, Dark, and High Contrast semantic resources for window, group, input, sidebar, toolbar, popover, selection, text, separator, typography, spacing, and radius roles.
- `GlasslineWindowBackdropController` uses native `Window.SystemBackdrop` with Auto/Mica/MicaAlt/Solid modes.
- High Contrast or disabled Windows transparency effects force the Solid window foundation.
- The semantic window surface remains the opaque fallback; Glassline does not require a transparent custom renderer.

### Shared functional material runtime

- `GlasslineGlassContainer` owns one `SystemBackdropElement` for one grouped material region rather than creating a backdrop pipeline per child control.
- Semantic roles are Sidebar, Toolbar, Popover, Interactive, and Prominent.
- Quality modes are Auto, Full, Reduced, and Solid.
- The current engineering baseline resolves capable active/local/non-resizing Auto/Full to built-in Desktop Acrylic, RDP/continuous-resize/inactive windows to Reduced using MicaAlt, and accessibility/transparency-disabled environments to Solid.
- Those built-in Full/Reduced choices are **provisional engineering baselines**, not final Glassline optical values. Custom Composition/refraction remains optional and blocked on native visual/performance evidence.

### C# custom/composite controls

The current Controls baseline includes:

- `GlasslineSearchField`: templated C# control with a native WinUI `TextBox` as the text/selection/clipboard/keyboard/IME engine.
- `GlasslineSegmentedControl`: templated C# control with a native WinUI `ListBox` as the single-selection/keyboard engine.
- non-invasive wrapper `FrameworkElementAutomationPeer`s give the custom controls stable UIA class/group identity without duplicating the native TextBox/ListBox provider patterns.

These controls compile and package successfully, but live Narrator/UIA, IME, DPI, visual-state, localization, and screenshot Definition-of-Done checks remain pending.

### Gallery and deterministic validation scenes

`Glassline.Gallery` provides stable scene IDs and AutomationIds for future native drivers:

- `window-foundation`
- `material-regions`
- `controls-matrix`
- `benchmark-settings` — native ListView, exactly 100 rows
- `benchmark-grid` — native GridView, exactly 500 items
- `benchmark-tree` — native TreeView, exactly 5000 non-root nodes

The Gallery reports requested/effective window backdrop, material quality/effective mode, High Contrast, transparency-effects, RDP, active/inactive and resize state, active material-region count, and approximate material-region area. Window activation and continuous resize are propagated into the adaptive material policy.

### Research infrastructure

- `research/corpus-index/corpus-index.csv` contains 70 public-safe macOS 26 Tahoe scene metadata records. The repository stores metadata only; referenced screenshots are not vendored and uninspected appearance/state/component details are not guessed.
- `research/AppleReferenceLab` is a buildable SwiftUI/AppKit macOS probe with stable scenes for buttons, toggle/slider, text input, pickers, sidebar, toolbar, menu/popover, window, and accessibility states.
- AppleReferenceLab is compiled and tested on a GitHub-hosted macOS 26 runner. Interactive reference captures and observed measurements still require a native interactive Mac.
- `research/measurements/measurement-ledger.csv` intentionally remains measurement-evidence work: the schema exists, but geometry/material values are not populated from uninspected screenshots or source code.

## Hosted CI currently proves

- repository, Theme, Controls, material, Gallery, and public-corpus static contracts;
- deterministic material-policy, Gallery scene-selection, and benchmark-data executable smoke cases;
- WinUI restore/build on x64 and ARM64 Windows runners;
- NuGet pack plus .NET package validation;
- generated package metadata/dependency-boundary checks and forbidden-asset scanning;
- a separate WinUI consumer restoring and compiling from the generated `Glassline.WinUI.Controls` NuGet with no Glassline project reference;
- SPDX 2.2 SBOM generation/validation for the package artifact set;
- AppleReferenceLab Swift test and release build on macOS 26.

See [`docs/engineering/ENVIRONMENT_BOUNDARY.md`](docs/engineering/ENVIRONMENT_BOUNDARY.md) for the exact evidence boundary.

## What still requires native evidence

The remaining high-value work is no longer mainly “can the source compile?” It is native evidence collection and measured tuning:

- macOS AppleReferenceLab captures and observed measurement-ledger entries;
- Windows Mica/material screenshot baselines in Light/Dark/High Contrast and active/inactive states;
- live Narrator/UIA provider-tree behavior;
- Korean, Japanese, and Simplified Chinese IME composition/candidate behavior;
- display scale, text scale, RTL, mixed-DPI multi-monitor behavior;
- mouse, precision touchpad, touch, Snap, system menu, maximize/restore, resize, and RDP behavior;
- frame-time, memory, GPU, resize, and material-region measurements on agreed reference Windows hardware.

Until that evidence exists, additional optical fidelity work must not be justified by guessed pixel values.

## Package layout

```text
Glassline.WinUI.Theme      XAML resources, semantic tokens, styles, and templates
Glassline.WinUI.Controls   C# custom/composite controls, window/material runtime
Glassline.WinUI.Effects    Optional advanced Composition/optical helpers; advanced path remains minimal
Glassline.Gallery          Reference app, deterministic validation scenes, benchmark vehicle
```

The intended usage model is to keep ordinary WinUI controls wherever possible and apply Glassline resources/components on top. Consumer-facing material APIs express semantic roles rather than exposing blur/distortion constants as the primary contract.

## Installation

There is no public package yet. Preview installation instructions will be added when the first package is actually published and the required native acceptance evidence is available.

## Documentation

Start with [`docs/STATUS.md`](docs/STATUS.md), [`docs/PROJECT_PLAN.md`](docs/PROJECT_PLAN.md), and [`docs/engineering/ENVIRONMENT_BOUNDARY.md`](docs/engineering/ENVIRONMENT_BOUNDARY.md). The full documentation map is in [`docs/README.md`](docs/README.md).

## License and independence

Glassline.WinUI is licensed under the [MIT License](LICENSE). It is an independent open-source project and is not affiliated with, sponsored by, or endorsed by Microsoft or Apple. Third-party names and trademarks are used only where necessary to describe compatibility or technical references.

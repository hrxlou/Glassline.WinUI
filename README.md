# Glassline.WinUI

[![Repository policy checks](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/policy-checks.yml/badge.svg)](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/policy-checks.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Glassline.WinUI** is a native WinUI 3 design system for Windows 11 focused on translucent materials, layered depth, desktop-oriented density, and polished interaction.

It is designed to keep Windows behavior native while giving WinUI applications a lighter, more optical visual language. Window management, keyboard and pointer interaction, accessibility, text input, IME, DPI scaling, and system conventions remain first-class constraints rather than being replaced by a custom cross-platform renderer.

> **Early development:** Glassline is not published on NuGet yet. Buildable Theme, Controls, Effects, and Gallery projects now exist in the repository, but the design system and native-interactive validation are still being stabilized before the first preview release.

## Design direction

- **Functional glass, not blur everywhere.** Translucent material is reserved for chrome, navigation, overlays, popovers, and other surfaces where depth and context matter.
- **Mica-compatible foundation.** The window base prefers the native Windows Mica system backdrop when supported and appropriate, with semantic solid fallbacks. Normal content rows, tables, and input surfaces do not become independent live glass layers.
- **Grouped material regions.** Toolbar buttons, sidebar controls, and related glass elements should share `GlassContainer`-style material regions instead of creating a backdrop/effect pipeline per control.
- **Layered, luminous surfaces.** Soft translucency, restrained separators, subtle edge light, and context-aware depth replace heavy borders and generic gray cards.
- **Adaptive quality.** `Auto` selects Full, Reduced, or Solid material behavior based on accessibility, environment, and compositor capability. Expensive effects are reduced during continuous resize and nonessential animation is suppressed for inactive/background windows.
- **Desktop-first density.** Toolbars, sidebars, inspectors, menus, settings surfaces, lists, outlines, and data-heavy layouts are first-class targets.
- **Windows-native behavior.** Standard caption semantics, Snap, resize, system menus, keyboard conventions, accessibility, and native text input are preserved.
- **No required custom renderer.** The core stays on WinUI 3 and Windows Composition; advanced optical refraction remains optional and experimental.

The material architecture is documented in [`docs/architecture/MATERIAL_ARCHITECTURE.md`](docs/architecture/MATERIAL_ARCHITECTURE.md).

## Package layout — engineering preview

The repository now contains the following buildable projects. They are not public NuGet releases yet.

```text
Glassline.WinUI.Theme      XAML resources, semantic tokens, styles, and templates
Glassline.WinUI.Controls   C# custom/composite controls and material-region primitives
Glassline.WinUI.Effects    Optional advanced Composition/optical helpers
Glassline.Gallery          Reference app, component gallery, and benchmark vehicle
```

The current Controls engineering baseline includes `GlasslineSearchField` and `GlasslineSegmentedControl`. They preserve native WinUI input/selection engines and pass source, x64/ARM64 build, package, and generated-NuGet consumer compilation gates. Native interactive UIA/Narrator, IME, DPI, visual-state, and screenshot acceptance remains pending and is tracked separately; these controls should not yet be treated as release-ready.

The intended usage model is to keep ordinary WinUI controls wherever possible and apply Glassline resources and components on top of them. Consumer-facing material APIs should express semantic roles such as Toolbar, Sidebar, or Popover rather than exposing raw blur/distortion constants as the main contract.

## Scope

The initial target is Windows 11, with x64 and ARM64 in scope. Planned coverage includes common controls, sidebars, toolbars, menus, settings layouts, search, segmented controls, desktop lists and outlines, inspectors, window chrome integration, popovers, and related interaction states.

Visual fidelity is only part of the goal. Components are expected to work across keyboard, mouse, touchpad, touch, accessibility tooling, IME input, multiple DPI levels, theme changes, and effect-disabled environments.

## Installation

There is no public package yet. Preview installation instructions will be added when the first package is published.

## Documentation

Project documentation lives in [`docs/`](docs/). Contributors can start with [`CONTRIBUTING.md`](CONTRIBUTING.md). Current implementation and validation state is tracked in [`docs/STATUS.md`](docs/STATUS.md).

## License

Glassline.WinUI is licensed under the [MIT License](LICENSE).

## Independence

Glassline.WinUI is an independent open-source project. It is not affiliated with, sponsored by, or endorsed by Microsoft or Apple. Third-party product names and trademarks are used only where necessary to describe compatibility or technical references.

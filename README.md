# Glassline.WinUI

[![Repository policy checks](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/policy-checks.yml/badge.svg)](https://github.com/hrxlou/Glassline.WinUI/actions/workflows/policy-checks.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Glassline.WinUI** is a native WinUI 3 design system for Windows 11 focused on translucent materials, layered depth, desktop-oriented density, and polished interaction.

It is designed to keep Windows behavior native while giving WinUI applications a lighter, more optical visual language. Window management, keyboard and pointer interaction, accessibility, text input, IME, DPI scaling, and system conventions remain first-class constraints rather than being replaced by a custom cross-platform renderer.

> **Early development:** Glassline is not published on NuGet yet. The design system and package boundaries are being stabilized before the first preview release.

## Design direction

- **Functional glass, not blur everywhere.** Translucent material is reserved for chrome, navigation, overlays, popovers, and other surfaces where depth and context matter.
- **Layered, luminous surfaces.** Soft translucency, restrained separators, subtle edge light, and context-aware depth replace heavy borders and generic gray cards.
- **Desktop-first density.** Toolbars, sidebars, inspectors, menus, settings surfaces, lists, outlines, and data-heavy layouts are first-class targets.
- **Windows-native behavior.** Standard caption semantics, Snap, resize, system menus, keyboard conventions, accessibility, and native text input are preserved.
- **Graceful fallback.** Light, Dark, High Contrast, inactive-window states, reduced effects, and solid rendering are part of the design contract.
- **No required custom renderer.** The core stays on WinUI 3; advanced optical effects are optional.

## Planned packages

```text
Glassline.WinUI.Theme      XAML resources, semantic tokens, styles, and templates
Glassline.WinUI.Controls   Desktop-oriented composite controls
Glassline.WinUI.Effects    Optional Composition and advanced material helpers
Glassline.Gallery          Reference app and component gallery
```

The intended usage model is to keep ordinary WinUI controls wherever possible and apply Glassline resources and components on top of them.

## Scope

The initial target is Windows 11, with x64 and ARM64 in scope. Planned coverage includes common controls, sidebars, toolbars, menus, settings layouts, search, segmented controls, desktop lists and outlines, inspectors, window chrome integration, popovers, and related interaction states.

Visual fidelity is only part of the goal. Components are expected to work across keyboard, mouse, touchpad, touch, accessibility tooling, IME input, multiple DPI levels, theme changes, and effect-disabled environments.

## Installation

There is no public package yet. Preview installation instructions will be added when the first package is published.

## Documentation

Project documentation lives in [`docs/`](docs/). Contributors can start with [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

Glassline.WinUI is licensed under the [MIT License](LICENSE).

## Independence

Glassline.WinUI is an independent open-source project. It is not affiliated with, sponsored by, or endorsed by Microsoft or Apple. Third-party product names and trademarks are used only where necessary to describe compatibility or technical references.

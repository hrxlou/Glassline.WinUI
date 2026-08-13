# Research Workspace

Public research artifacts in this repository are designed to preserve **provenance and decisions without redistributing third-party/Apple reference assets**.

## Current state — 2026-08-13

### Corpus index

`corpus-index/corpus-index.csv` contains **70** public-safe macOS 26 Tahoe scene metadata rows. The rows point to the public source index, record app/scene context, and remain `external-reference-only-do-not-redistribute`.

The corpus index deliberately does not claim:

- Light/Dark if the index alone does not establish it;
- interaction state if the scene has not been inspected;
- component inventory if the image has not been inspected;
- geometry, radius, color, opacity, blur, material, or motion values.

A corpus row is not a measurement.

### AppleReferenceLab

`AppleReferenceLab/` is now a buildable SwiftUI/AppKit probe with stable scene IDs for:

- Buttons
- Toggle / Slider
- Text Input
- Pickers
- Sidebar
- Toolbar
- Menu / Popover
- Window
- Accessibility States

The probe has deterministic scene-selection tests and release build validation on a GitHub-hosted macOS 26 runner. Build success proves the reference tool is usable at source/toolchain level; it does not provide approved captures.

Interactive macOS work still required:

- Light/Dark;
- Active/Inactive;
- Normal/Hover/Pressed/Focused/Disabled/Selected;
- control-size/accent variants;
- Reduce Transparency / Increase Contrast / Reduce Motion;
- resize/scroll/menu/popover motion.

### Measurement ledger

`measurements/measurement-ledger.csv` remains the M0 evidence blocker. Its schema exists, but observed rows must come from inspected reference scenes/native captures.

Before adding a measurement:

1. inspect the referenced scene itself;
2. record exact source/OS/app/state context;
3. classify the value as Observed, Inferred, or Glassline decision;
4. record confidence and asset policy;
5. keep non-redistributable captures outside the public repository.

Initial measurement targets: Button, Toggle, Slider, Sidebar, Toolbar, Popover.

## Asset rule

Do not commit Apple screenshots, Apple Design Resources exports, SF font files, exported SF Symbols paths, Apple product artwork, or other non-redistributable reference material. Private/local research inputs remain outside the public Git history.

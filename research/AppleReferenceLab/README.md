# AppleReferenceLab

Status: **buildable engineering probe; native capture/measurement pending**.

AppleReferenceLab is a project-owned macOS probe app that renders standard SwiftUI and AppKit controls with minimal styling so reference states can be captured consistently. It contains no Apple screenshots, Apple Design Resources exports, SF font files, or exported SF Symbols assets.

## Build

From the repository root on macOS:

```sh
swift test --package-path research/AppleReferenceLab -c release
swift build --package-path research/AppleReferenceLab -c release
```

GitHub Actions also compiles and tests the package on a hosted macOS 26 runner. A green CI run proves source/package compatibility only; it does **not** prove visual fidelity or constitute a native capture.

## Stable scene IDs

- `buttons`
- `toggle-slider`
- `text-input`
- `pickers`
- `sidebar`
- `toolbar`
- `menu-popover`
- `window`
- `accessibility-states`

The initial scene can be selected with `--scene=<id>` or `GLASSLINE_REFERENCE_SCENE=<id>`. The command-line value takes precedence. Unknown values fall back to `buttons`.

## Capture matrix requiring an interactive Mac

For each applicable scene, capture and record:

- Light / Dark;
- Active / Inactive window;
- Normal / Hover / Pressed / Focused / Disabled / Selected;
- control-size variants where applicable;
- accent variants;
- Reduce Transparency / Increase Contrast / Reduce Motion states;
- resize and scroll behavior;
- menu/popover open-close transitions.

## Measurement boundary

Do not infer geometry, radius, color, opacity, blur, material, or motion values from the source code or CI screenshots. Observed measurements enter `research/measurements/measurement-ledger.csv` only after the referenced scene has been inspected on a native macOS capture and the evidence classification is recorded.

Reference captures remain non-shipping research material unless redistribution rights are separately established.

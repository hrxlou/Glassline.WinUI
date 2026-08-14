# Window Backdrop Native Acceptance

> Engineering baseline can be compiled in hosted Windows CI. Visual and interaction sign-off requires an interactive Windows 11 desktop.

## Implemented contract

- `GlasslineWindowBackdropController` uses `Window.SystemBackdrop` rather than replacing the WinUI/Windows compositor path.
- `Auto` resolves to native Mica when High Contrast is off and Windows transparency effects are enabled.
- `Mica`, `MicaAlt`, and `Solid` can be requested explicitly.
- High Contrast or disabled transparency effects force `Solid` regardless of a translucent request.
- WinUI remains responsible for unsupported-platform/system-backdrop fallback.
- The app content root retains `Glassline.Surface.Window` as the semantic solid foundation.

## Native evidence recorded

- 2026-08-14, Windows 11 Enterprise 10.0.26200, x64 Debug, `titlebar-band` scene: the native WinUI
  `TitleBar` control composes **inside** `GlasslineGlassContainer`, and the band resolves to `Full`
  material while the system caption buttons stay drawn and legible over it. Measured from the live
  window with `ExtendsContentIntoTitleBar = true`:

  | Reported | Value |
  |---|---|
  | `LeftInset` | 0 |
  | `RightInset` | 138 |
  | `Height` | 32 |
  | `FlowDirection` | LeftToRight |
  | band effective mode | Full |

  Two findings follow. Glassline does not need a bespoke titlebar primitive — the platform control
  carries the slots, and material renders beneath it. And the reserved geometry is **only reported
  once the app opts into owning the titlebar**: the same scene with `ExtendsContentIntoTitleBar`
  false reports every inset as 0, so ADR-0011's rule that these are queried rather than assumed is
  not merely good practice, it is the only way to obtain them at all.

  Not covered: RTL flow, non-100% scale, narrow windows, High Contrast, and inactive-window caption
  rendering. This is one configuration on one machine.

- 2026-08-14, Windows 11 Enterprise 10.0.26200, x64 Debug: the Gallery reaches an interactive window (`Glassline Gallery`, responding) and stays alive. This is the first recorded desktop launch of the window-backdrop path; before the `ThemeSettings` fix, `AccessibilitySettings.HighContrastChanged` threw during startup on every launch while CI stayed green. Launch survival only — no visual, DPI, or interaction claim is made here.

## Native Windows acceptance still required

- [ ] Verify Mica on a supported Windows 11 machine in Light and Dark modes.
- [ ] Verify MicaAlt when explicitly requested.
- [ ] Toggle Settings > Accessibility > Visual effects > Transparency effects at runtime and verify Solid transition/recovery.
- [ ] Enable/disable High Contrast at runtime and verify Solid transition/recovery plus readable semantic surfaces.
- [ ] Verify active/inactive window appearance.
- [ ] Verify continuous resize does not expose unpainted/transparent content.
- [ ] Verify maximize/restore/Snap and multi-monitor moves at 100%, 125%, 150%, and 200% scale.
- [ ] Verify local and RDP sessions; M1 does not yet use RDP to choose quality, but no backdrop failure may occur.
- [ ] Capture Gallery Light/Dark/HighContrast screenshots as the first window-foundation golden baselines.

## Evidence boundary

A green x64/ARM64 build proves API/XAML/package compatibility only. It does not prove compositor quality, accessibility appearance, DPI behavior, or frame pacing. Those items remain open until the checklist above is executed on native Windows hardware.

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

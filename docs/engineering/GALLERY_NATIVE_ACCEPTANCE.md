# Gallery Native Acceptance

> Hosted CI compiles the Gallery, validates deterministic scene contracts, and executes pure scene-selection logic. Pixel capture, accessibility automation, IME UI, pointer/touch behavior, and performance measurements require an interactive Windows environment.

## Deterministic scenes

- `window-foundation`
- `material-regions`
- `controls-matrix`
- `all` (default)

Select a scene with `--scene=<id>` or `GLASSLINE_GALLERY_SCENE=<id>`. Command-line selection takes precedence over the environment variable. Unknown values fall back to `all`.

Each scene has a stable `AutomationProperties.AutomationId` so a future native screenshot/UIA harness can address it without depending on display text.

## Implemented diagnostics

The Gallery reports:

- requested/effective window backdrop;
- High Contrast state;
- Windows advanced/transparency-effects state;
- RDP state;
- active/inactive state;
- continuous-resize state;
- requested/effective mode per material region;
- active material-region count;
- approximate material region layout area in DIP^2.

`AppWindow.Changed` and `DidSizeChange` mark the material regions as resizing. A 250 ms settle timer clears the resize state after size changes stop. `Window.Activated` propagates active/inactive state.

## Native Windows validation still required

### Screenshot matrix

- [ ] Light / Dark / High Contrast.
- [ ] Active / inactive window.
- [ ] Full / Reduced / Solid material modes.
- [ ] 100%, 125%, 150%, 200% display scale.
- [ ] 100%, 150%, 200% text scale subset agreed in validation plan.
- [ ] `window-foundation`, `material-regions`, and `controls-matrix` golden captures.

### Accessibility and input

- [ ] Narrator/UI Automation role/name/value/navigation pass.
- [ ] Keyboard-only navigation and visible focus pass.
- [ ] Korean IME composition/candidate window pass.
- [ ] Japanese IME composition/candidate window pass.
- [ ] Simplified Chinese IME composition/candidate window pass.
- [ ] Mouse hover/press and precision-touchpad pass.
- [ ] Touch target/scroll interaction pass where hardware is available.

### Window/system behavior

- [ ] Snap layouts, maximize/restore, resize, system menu, Alt+F4.
- [ ] Multi-monitor moves across mixed DPI.
- [ ] Transparency setting and High Contrast live transitions.
- [ ] Local ↔ RDP behavior.

### Performance

- [ ] Settings-style 100-row benchmark.
- [ ] 500-item productivity grid benchmark.
- [ ] 5k-node tree benchmark.
- [ ] rapid menu/popover open-close benchmark.
- [ ] continuous resize for at least 10 seconds.
- [ ] record P50/P95/P99 frame times, memory delta, available GPU signals, material region count/area, and effective mode.

Hosted CI success must not be used as evidence for the unchecked items above.

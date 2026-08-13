# Material Runtime Native Acceptance

> The shared-region and adaptive-policy baseline can be compiled and policy-tested in hosted Windows CI. Optical quality and performance sign-off require an interactive Windows 11 desktop and representative hardware.

## Implemented engineering contract

- `GlasslineGlassContainer` owns one `SystemBackdropElement` for one semantic material region.
- Grouped child controls do not create individual backdrop/effect pipelines.
- Material roles are semantic: Sidebar, Toolbar, Popover, Interactive, Prominent.
- `Auto`/`Full` resolve to Full only for an active, local, non-resizing session with transparency effects enabled and High Contrast off.
- High Contrast or disabled transparency effects resolve to Solid.
- RDP, continuous-resize state, and inactive-window state resolve to Reduced.
- Full uses built-in Desktop Acrylic for the functional region; Reduced uses built-in MicaAlt; Solid removes the region backdrop and exposes the semantic fallback surface.
- No custom shader, displacement, refraction, Win2D, D2D, or D3D path exists in this baseline.

## Native Windows acceptance still required

- [ ] Compare Full and Reduced regions in Light/Dark against approved reference measurements.
- [ ] Verify High Contrast and transparency-off Solid fallback visually and with Narrator focus visibility.
- [ ] Verify RDP session downgrade and recovery after returning local.
- [ ] Verify continuous resize downgrade/recovery without flashing or unpainted frames.
- [ ] Verify inactive/active transitions with no continuous unnecessary animation.
- [ ] Verify Sidebar + Toolbar together at 100%, 125%, 150%, and 200% scaling.
- [ ] Record frame-time P50/P95/P99 for the benchmark scenes.
- [ ] Record process memory, available GPU utilization/memory signals, active region count, and total region area.
- [ ] Decide whether Desktop Acrylic is acceptable for Full or whether an independent Composition material is required after evidence review.
- [ ] Capture golden screenshots for Full/Reduced/Solid in the Gallery.

## Go/no-go for advanced optics

Refraction/lensing remains blocked until the baseline passes the native visual and performance acceptance above. A stronger effect is not accepted if it requires per-control pipelines, breaks accessibility fallback, or cannot degrade predictably.

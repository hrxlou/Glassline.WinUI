# Visual Corrections Learned From the Fidelity Prototype

The HTML fidelity lab is a **research abstraction**, not the shipping renderer. The most important outcome of the prototype iteration was identifying why earlier versions looked like generic glossy/legacy desktop UI rather than a coherent contemporary system.

## Corrections locked into the specification

- **Glass is not a gray card.** It must adapt to the background/context, and sidebar/toolbar material thickness must differ.
- **Minimize borders.** Structure should come from separators, luminance, spacing, and material thickness rather than white outlines plus black shadows on every card.
- **Content is not glass.** Settings rows, tables, and text fields remain standard/flat content surfaces; glass is a functional layer.
- **Dark mode has its own palette.** Window/content/group/sidebar/glass luminance relationships are tuned independently.
- **Press is an optical response.** Prefer specular movement, subtle compression, and release overshoot over large scale/ripple effects.
- **Caption grammar remains Windows-native.** Do not transplant macOS traffic-light controls. Keep Windows glyphs and semantics in the system-reserved trailing corner — right under LTR, left under RTL — and alter the surrounding chrome only. Caption geometry is read from `AppWindowTitleBar` at runtime, never hardcoded; see ADR-0011.

## Visual acceptance rule

A screen fails visual review if it reads as “neutral gray plastic”, “generic Fluent skin”, “legacy glossy desktop”, or a direct Apple-app clone. It must instead read as one coherent Glassline system with Windows-native interaction semantics.

## Prototype source note

The source HTML contained an interactive Settings/Finder-style lab and embedded reference imagery. The HTML itself is intentionally not added to the public repository because the project policy prohibits shipping/public Apple screenshots or proprietary reference assets.

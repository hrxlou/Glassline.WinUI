# ADR-0011: System caption placement and titlebar ownership

- Status: **Accepted**
- Date: 2026-08-14
- Supersedes: **ADR-0002 — Right-side Windows caption semantics**

## Context

ADR-0002 stated that Glassline keeps the caption cluster on the **top-right**. That is correct for
LTR and wrong for RTL: Windows moves the caption cluster to the top-left when the window flow
direction is right-to-left. `PRODUCT_CONTRACT.md`, `VISUAL_CORRECTIONS.md`, and
`PROJECT_PRINCIPLES.md` repeat the same claim. Left as written, the first RTL implementation would
put Glassline's stated architecture in direct conflict with the platform.

The narrower error is the RTL case. The broader one is the shape of the mistake: ADR-0002 froze a
value the shell owns as though it were a project decision. Caption geometry is not the only such
value — caption height, reserved insets, and caption foreground colour are all shell-owned and all
change at runtime with DPI, text scale, window state, and theme. A rule that only fixes "right" to
"right or left" would leave the same class of error in place.

`Microsoft.UI.Windowing.AppWindowTitleBar` exposes the reserved regions directly, including
`LeftInset` and `RightInset`, which are present in the Windows App SDK version this repository pins.

## Decision

1. **Windows determines caption placement.** LTR resolves to the trailing (right) corner and RTL to
   the leading (left) corner. Glassline states the rule as *system-reserved trailing corner*, never
   as a fixed side.

2. **Glassline never hardcodes caption geometry.** `AppWindowTitleBar` insets, caption height, and
   the reserved regions are authoritative and are read at runtime. No design token, resource value,
   or constant in this repository may encode a caption width, inset, or height.

3. **Glassline owns material, not caption interaction.** Minimize, Maximize/Restore, Close, Snap,
   the system menu, double-click-to-maximize, and Alt+F4 remain the platform's. Glassline is
   responsible for what is rendered beneath and around them, and for the visual hierarchy of the
   band as a whole.

4. **The reserved region constrains content, and content never constrains it.** Application content
   in the titlebar band respects the reserved insets. When horizontal space runs out, application
   content yields; the reserved region is never encroached upon and the minimum drag region is
   never eliminated.

5. **Material must not compromise system-drawn chrome.** Caption glyphs are drawn by the system over
   whatever Glassline renders. The material behind the reserved region must keep them legible in
   every effective mode, and accessibility fallback (High Contrast, transparency disabled) applies
   there at least as strongly as elsewhere. A material that is only legible in some window states
   is not acceptable behind the caption.

6. **Shell metrics are runtime state, not design tokens.** Insets, caption height, flow direction,
   caption foreground and background state, drag regions, and interactive pass-through regions are
   queried and recomputed — on DPI change, text-scale change, theme change, window state change, and
   resize. They are deliberately not part of the semantic token model of ADR-0003.

## Consequences

- ADR-0002 is superseded. `PRODUCT_CONTRACT.md`, `VISUAL_CORRECTIONS.md`, `PROJECT_PRINCIPLES.md`,
  and `IP_AND_DISTRIBUTION.md` must state the trailing-corner rule rather than "right".
- A validation contract can enforce decision 2 statically: a hardcoded caption dimension is a
  detectable defect, in the same way the desktop-runtime scan detects CoreWindow-dependent APIs.
- RTL is a first-class acceptance case for any titlebar work, not a later localisation pass.
- Decisions 4 and 5 are acceptance items that hosted CI cannot close. They need native evidence, and
  belong in the window-backdrop acceptance checklist.
- How the band is composed — which control hosts it, and how navigation, title, and toolbar content
  share the space — is deliberately out of scope here and is decided separately.

## References

- ADR-0002: Right-side Windows caption semantics (superseded)
- ADR-0003: Semantic token model
- ADR-0010: Mica foundation, shared glass regions, and adaptive material quality
- `docs/engineering/WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md`
- Microsoft title bar guidance: https://learn.microsoft.com/windows/apps/develop/title-bar
- `AppWindowTitleBar.RightInset`: https://learn.microsoft.com/windows/windows-app-sdk/api/winrt/microsoft.ui.windowing.appwindowtitlebar.rightinset

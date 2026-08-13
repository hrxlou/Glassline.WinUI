# Material Architecture

Status: **engineering baseline implemented; native optical/performance sign-off pending**.

This document defines the runtime material architecture currently represented in source. The baseline intentionally uses native WinUI/Windows backdrops first; it does not claim that the current built-in materials are final Glassline/Tahoe optical fidelity.

## Architectural stack

```text
Windows application
  ↓
WinUI 3 controls / native input & accessibility
  ↓
Glassline semantic Theme
  ↓
Window foundation: native Window.SystemBackdrop
  ↓
Grouped functional regions: GlasslineGlassContainer
  ↓
Adaptive material policy: Full / Reduced / Solid
  ↓
Optional advanced Composition/refraction path later, only if evidence justifies it
```

The invariant remains: **native behavior, alternate visual system**.

## 1. Window foundation

`GlasslineWindowBackdropController` uses `Window.SystemBackdrop` and supports:

- Auto
- Mica
- MicaAlt
- Solid

Auto currently resolves to Mica when High Contrast is off and Windows advanced/transparency effects are enabled. High Contrast or disabled transparency effects force Solid. The application keeps a semantic `Glassline.Surface.Window` opaque fallback so Solid is a first-class mode rather than a failure path.

WinUI/Windows remains responsible for the actual native system-backdrop rendering/fallback. Glassline does not replace HWND/window management with a custom renderer.

## 2. Functional material regions

`GlasslineGlassContainer` is the baseline grouped-region primitive. It is a templated `ContentControl` with **one** `SystemBackdropElement` for the whole region.

One container may contain a group of toolbar buttons, sidebar content, or another functional cluster. Children do not create individual backdrop samplers/effect graphs.

Semantic roles:

- Sidebar
- Toolbar
- Popover
- Interactive
- Prominent

Roles select semantic fallback/tint treatment. They do not expose raw blur/distortion constants as the primary public contract.

## 3. Adaptive quality policy

Public quality requests:

- Auto
- Full
- Reduced
- Solid

Effective runtime modes:

- Full
- Reduced
- Solid

Current deterministic policy:

| Environment | Effective result for translucent requests |
|---|---|
| High Contrast | Solid |
| Windows advanced/transparency effects disabled | Solid |
| RDP / remote interactive session | Reduced |
| continuous resize | Reduced |
| inactive window | Reduced |
| active local non-resizing session with effects enabled | Full |

Explicit Solid remains Solid.

The policy uses Windows environment/accessibility signals. It deliberately does not maintain GPU vendor/model allowlists.

## 4. Current renderer mapping is provisional

For the engineering baseline:

- **Full → Desktop Acrylic** on the grouped `SystemBackdropElement`.
- **Reduced → MicaAlt** on the grouped `SystemBackdropElement`.
- **Solid → no region backdrop**, exposing the semantic opaque surface.

These mappings make the quality/fallback/grouping architecture executable and testable now. They are **not** frozen final Glassline material values and must not be described as a completed Liquid Glass implementation.

The final Full path may remain built-in material or move to a custom Windows Composition implementation only after native evidence answers:

- Does built-in Desktop Acrylic provide acceptable diffusion/depth for the intended functional regions?
- Can a custom path preserve High Contrast/effects-off/RDP/resize fallback cleanly?
- What is the frame-time, memory, and GPU cost on reference hardware?
- Does a stronger path require per-control sampling or excessive region count/area?
- Can active/inactive and continuous resize transitions avoid visible flashing/jank?

## 5. Region grouping contract

The primary performance rule is architectural, not a guessed blur radius:

> Repeated child controls must not each own a live backdrop/effect pipeline when they can share one semantic material region.

Gallery currently demonstrates shared Sidebar and Toolbar regions. Validation tracks active region count and approximate region layout area so later performance measurements can correlate cost with material scope.

If a future component needs a separate visual state, it should first use ordinary fills/borders/opacity inside the shared region. A new live material sampler requires explicit justification and performance evidence.

## 6. Content versus functional material

Normal content remains mostly semantic and readable:

- Window
- Group
- Input field
- Table/list content

Functional/transient regions are candidates for grouped material:

- Sidebar
- Toolbar
- Popover
- Interactive floating controls
- prominent transient regions

“Glass everywhere” remains prohibited. Material is used where depth/context/function benefits from it.

## 7. Accessibility and environment fallbacks

Solid is part of the design system. It must remain usable for:

- High Contrast;
- disabled transparency effects;
- unsupported/system fallback conditions;
- future constrained environments where a stronger quality mode is inappropriate.

Reduced exists to lower optical cost/animation pressure for:

- continuous resize;
- inactive windows;
- RDP/remote sessions;
- future evidence-backed capability constraints.

Accessibility fallbacks take precedence over aesthetic requests.

## 8. Advanced optics boundary

The desired long-term optical vocabulary may include:

- context-aware diffusion;
- luminance/tint adaptation;
- directional/specular edge treatment;
- depth shadow;
- pointer highlight;
- press flex/compression/release motion;
- scroll-edge adaptation;
- weak refraction/lensing impression;
- shared sampling/grouping.

Only grouping/fallback and built-in material baselines are implemented today. There is no accepted custom refraction/displacement shader path.

Advanced optics are blocked until:

1. AppleReferenceLab/reference measurements exist;
2. native Windows baseline screenshots are approved;
3. deterministic benchmark scenes are measured on reference hardware;
4. accessibility/RDP/resize downgrade behavior is proven;
5. the stronger effect provides a clear benefit over built-in material.

If those conditions are not met, advanced refraction is dropped without blocking v1.

## 9. Validation artifacts

Relevant ledgers:

- `docs/engineering/WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md`
- `docs/engineering/MATERIAL_NATIVE_ACCEPTANCE.md`
- `docs/engineering/GALLERY_NATIVE_ACCEPTANCE.md`
- `docs/engineering/PERFORMANCE_NATIVE_ACCEPTANCE.md`
- `docs/engineering/ENVIRONMENT_BOUNDARY.md`

Hosted CI validates architecture contracts and deterministic policy. Native Windows remains the authority for rendered quality and performance.

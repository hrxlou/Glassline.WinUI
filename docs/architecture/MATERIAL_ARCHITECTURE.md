# Material Architecture

> Status: design contract for M1/M2 implementation. No shipping renderer exists yet.
> Last updated: 2026-08-13.

Glassline.WinUI does not replace the Windows compositor with an application-owned renderer. The material system is layered on top of native WinUI 3 and Windows Composition.

## 1. Layer model

```text
Application content
│
├─ Foundation / content layer
│  ├─ Window backdrop: system Mica when supported and appropriate
│  ├─ Solid semantic fallback when Mica/effects are unavailable or disabled
│  ├─ Group/list/table/input surfaces: standard semantic fills
│  └─ No live backdrop effect per content item
│
└─ Functional material layer
   ├─ Sidebar
   ├─ Toolbar / command islands
   ├─ Popover / flyout / transient overlay
   ├─ Floating controls
   └─ Selected interactive glass roles

      → grouped Windows Composition material regions
```

Mica is the preferred low-cost window foundation where Windows policy and platform support permit it. Glassline glass is an additional functional layer, not a replacement for every content surface.

## 2. Shared material regions

The implementation must provide a `GlassContainer`-style primitive. The final public type name may change before the first preview, but the architectural rule is fixed: adjacent glass elements that belong to one visual group should share one material region rather than each owning an independent backdrop/effect pipeline.

```text
Bad
Button A → backdrop → blur → effects
Button B → backdrop → blur → effects
Button C → backdrop → blur → effects

Preferred
Glass region → shared backdrop/effect resources
             ├─ Button A
             ├─ Button B
             └─ Button C
```

Typical regions are one sidebar, one toolbar island/group, or one popover. Region boundaries should follow visual/material grouping, not individual control boundaries.

This rule is informed by the source blueprint's `grouping / shared sampling region` requirement and by the same general performance principle behind SwiftUI `GlassEffectContainer`; Glassline implements the concept independently with Windows APIs.

## 3. Working API model

Consumer-facing APIs should express semantic intent, not shader parameters.

```xml
<glassline:GlassContainer Material="Toolbar" Quality="Auto">
    <CommandBar />
</glassline:GlassContainer>
```

Candidate material roles:

- `Sidebar`
- `Toolbar`
- `Popover`
- `Interactive`
- `Prominent`

Avoid public APIs such as `BlurRadius=24`, `Distortion=0.17`, or `TintOpacity=0.43` as the primary contract. Optical values remain implementation details so they can adapt by hardware, accessibility state, design generation, and backdrop context.

## 4. Internal responsibilities

The M2 material subsystem should be decomposed around responsibilities similar to:

```text
MaterialCapabilities
    └─ effect support / fast-effect capability / environment state

MaterialQualityManager
    └─ Auto → Full / Reduced / Solid

BackdropProvider
    └─ system/window backdrop inputs and lifetime

MaterialBrush
    └─ baseline Composition material graph

GlassContainer
    └─ region lifetime, shared resources, child grouping

Experimental refraction
    └─ optional advanced optical path
```

The names above are working architectural names, not frozen public APIs.

## 5. Adaptive quality contract

| Situation | Target mode | Required behavior |
|---|---|---|
| Normal capable local session | `Full` | blur/tint/luminance/specular/shadow/motion; optional approved lensing |
| Continuous window resize | `Reduced` | reduce blur cost, disable refraction, suppress nonessential continuous specular/pointer animation |
| Inactive/background window | `Reduced` or static Full | stop nonessential continuous animation; lower material activity |
| Slow/unsupported effects | `Reduced` | simpler effect graph; no advanced lensing |
| RDP / constrained environment | `Reduced` or `Solid` | prioritize stability and legibility |
| High Contrast / effects disabled | `Solid` | opaque semantic surfaces and explicit separators |

`Auto` is the default. Capability checks should use Windows Composition capability/policy signals where available rather than hard-coded GPU model lists.

## 6. Explicit anti-patterns

Do not implement:

- live backdrop blur on every `ListViewItem`, `TreeViewItem`, or data-grid row;
- independent effect graphs for every button in a grouped toolbar;
- full-window real-time refraction;
- nested glass-on-glass unless an explicit visual/performance review proves it necessary;
- continuous pointer/specular/refraction animation in inactive/background windows;
- Full-quality refraction during continuous resize;
- a design that breaks List/Tree virtualization because glass visuals are attached per item.

Normal content selection/hover should use cheap semantic fills. Glass is reserved for functional regions where material hierarchy adds information.

## 7. Performance instrumentation

Performance results must record more than FPS. For each benchmark scene capture, where tooling permits:

- frame-time P50/P95/P99;
- GPU utilization and GPU memory delta;
- process memory delta;
- power/energy signal when available;
- number of active glass regions;
- total glass pixel area or percentage of the window;
- current material mode (`Full` / `Reduced` / `Solid`);
- refraction enabled/disabled;
- resize/active/inactive state.

The purpose is to correlate cost with **glass area × region count × effect complexity × update frequency**.

## 8. M1/M2 implementation order

1. Establish Mica/solid window foundation and normal semantic content surfaces.
2. Prototype one shared `GlassContainer` region with a baseline Composition material.
3. Add tint/luminance/edge/specular/shadow without advanced refraction.
4. Implement `MaterialCapabilities` and `MaterialQualityManager`.
5. Verify `Full → Reduced → Solid` transitions, including continuous resize and inactive windows.
6. Validate Sidebar + Toolbar together in the Gallery benchmark scene.
7. Add Popover and selected interactive roles only after the shared-region model is stable.
8. Experiment with refraction/lensing last, behind the M2 go/no-go gate.

## 9. Release rule

A visually stronger material is not accepted if it requires per-control live backdrop pipelines or cannot degrade predictably. Advanced refraction remains optional and must never block a stable v1 material system.

## References

- Microsoft system backdrops: https://learn.microsoft.com/windows/apps/develop/ui/system-backdrops
- Microsoft Composition brushes: https://learn.microsoft.com/windows/apps/develop/composition/composition-brushes
- Microsoft composition tailoring: https://learn.microsoft.com/windows/uwp/composition/composition-tailoring
- Apple `GlassEffectContainer` research reference: https://developer.apple.com/documentation/swiftui/glasseffectcontainer

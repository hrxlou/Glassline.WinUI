# Project Plan

> Last updated: 2026-08-13  
> Current milestone: **M0 — Corpus & Decisions**

## 1. Delivery strategy

Glassline.WinUI will be built in seven gated milestones. The order is deliberate: **reference/state/token contracts before control implementation**, **native WinUI behavior before optical polish**, and **shared/adaptive material architecture before multiplying glass controls**.

| Milestone | Goal | Key deliverables | Exit gate |
|---|---|---|---|
| M0 | Corpus & Decisions | repo bootstrap, AppleReferenceLab plan, 50+ corpus index, measurement ledger, ADR-0001~0010, brand/package decision | Core visual/system/material rules can be justified with sources and decisions |
| M1 | Foundation | semantic color, typography, spacing/radius, theme dictionaries, active/inactive, system Mica window foundation where appropriate, Solid/HC fallback, standard content surfaces | Foundation tokens/backdrop are consumable without advanced renderer |
| M2 | Glass Engine | shared `GlassContainer`-style regions, baseline Composition material, Sidebar/Toolbar/Popover roles, `MaterialCapabilities`, `MaterialQualityManager`, pointer/specular/motion, resize/inactive downgrade, fallback | Quality/perf gate; advanced refraction removed if it cannot meet budget |
| M3 | Core Controls | Button, ToggleSwitch, Slider, TextBox, Search, Check/Radio, Combo/DropDown, Segmented | P0 control state matrix passes DoD without per-control backdrop proliferation |
| M4 | Window & Shell | titlebar, right caption semantics, sidebar/toolbar shell, Settings + productivity archetypes | Snap/system menu/resize/input and visual hierarchy are coherent |
| M5 | Desktop Data | List/Tree/Outline/Table/Menu/Popover/Sheet/Inspector | Desktop productivity primitives usable at scale without breaking virtualization |
| M6 | RC / Distribution | visual/UIA/IME/perf/package/IP gates, Gallery/docs, preview/stable package | All release gates green |

## 2. Workstreams

### Research & provenance
- Build a 50+ scene corpus index without committing Apple screenshots.
- Implement AppleReferenceLab capture plan for native SwiftUI/AppKit controls.
- Populate measurement ledger with Observed/Inferred/Glassline-decision classifications.
- Treat the private bootstrap blueprint files as immutable provenance sources; transfer reusable conclusions into public role-specific docs rather than rewriting the archived originals.
- Revalidate competitive landscape quarterly.

### Foundation & design system
- Freeze semantic token naming before deep control templates.
- Separate content surfaces from functional glass surfaces.
- Establish the window foundation as native system Mica when appropriate, with semantic Solid/High Contrast fallback.
- Keep normal group/list/table/input surfaces cheap and non-backdrop by default.
- Define Light/Dark/High Contrast and active/inactive together.
- Keep `DesignGeneration` separate from NuGet SemVer.

### Material engine
- Prototype the shared material-region primitive before individual glass-control expansion.
- Group visually related toolbar/sidebar/popover children into shared regions.
- Keep material roles semantic (`Sidebar`, `Toolbar`, `Popover`, `Interactive`, `Prominent`) instead of exposing raw shader constants as the primary API.
- Implement `Auto → Full / Reduced / Solid` as runtime behavior, not documentation-only modes.
- Continuous resize must temporarily reduce expensive effects; inactive/background windows suppress nonessential continuous material animation.
- Advanced refraction/lensing is experimental and last in the sequence.

### Controls & shell
- Prefer ControlTemplate/VisualState on native controls.
- Add composite controls only where WinUI lacks the needed semantics.
- Keep Windows caption/Snap/system menu/keyboard behavior.
- Do not attach live backdrop effects to virtualized list/tree/table rows.
- Use `Glassline.Gallery` as both sample and product-quality test vehicle.

### Validation
- Visual golden baselines validate Glassline regressions, not Apple pixel matching.
- UIA/Narrator, keyboard, IME, DPI, text scale, RTL, GPU/RDP fallback are independent release lanes.
- Performance budgets are locked after reference hardware is selected.
- Material benchmarks record frame-time percentiles, memory/GPU signals, glass-region count, glass area, material mode, and refraction state.

### Distribution & IP
- Zero Apple shipping assets.
- All third-party source/assets require provenance and notice review.
- Public Gallery must not reproduce Apple app information architecture 1:1.
- Stable publication requires the IP gate and selected repository/package license.

## 3. Immediate critical path

1. **Finish M0 public research artifacts:** 50+ corpus rows + measurement samples.
2. **Create AppleReferenceLab buildable skeleton on macOS** and capture the first Button/Toggle/Slider/TextInput state set.
3. **Resolve open platform/package decisions:** minimum Windows 11 build, .NET target, C++ support boundary, icon provenance, preview feed, screenshot/reference GPU hardware.
4. **Turn M1 tokens into actual WinUI ResourceDictionaries and establish Mica/Solid foundation behavior.**
5. **Build Glassline.Gallery before deep P0 control work**, including material-mode and resize/inactive diagnostics.
6. **Prototype one shared GlassContainer-style toolbar/sidebar region** with a baseline Composition material and no advanced refraction.
7. **Implement MaterialCapabilities + MaterialQualityManager** and prove Full → Reduced → Solid transitions.
8. **Run the M2 grouped-region benchmark** with Sidebar + Toolbar before expanding to Popover/interactive roles.
9. **Implement P0 controls in dependency order:** Button → Toggle → Slider → Text input/Search → Check/Radio → Combo/DropDown → Segmented.
10. **Experiment with advanced refraction only after baseline material performance is stable.**

## 4. Dependency order

```text
Research corpus + measurements
        ↓
ADRs + semantic token/material contract
        ↓
Mica/Solid foundation + Theme dictionaries
        ↓
Gallery state matrix + screenshot/perf harness
        ↓
Shared GlassContainer-style region
        ↓
MaterialCapabilities + QualityManager
        ↓
Sidebar + Toolbar grouped-material gate
        ↓
P0 controls + Popover/interactive expansion
        ↓
Window & shell
        ↓
Desktop data controls
        ↓
Experimental refraction (optional) ──┐
        ↓                            │
Hardening / packaging / IP gate ◄───┘
```

## 5. Material implementation sequence

M1/M2 development follows this order:

1. Mica/solid window foundation and normal semantic content surfaces.
2. One shared material region (`GlassContainer` working name).
3. Baseline backdrop → blur/diffusion → tint/luminance → edge/specular → shadow.
4. Pointer/press motion that does not require continuous heavy redraw.
5. Capability/quality manager and environment transitions.
6. Resize and inactive-window downgrade behavior.
7. Sidebar + Toolbar benchmark.
8. Popover and selected interactive material roles.
9. Optional refraction/lensing R&D.

Do not reverse the order by implementing refraction first or by turning each P0 control into an independent glass renderer.

## 6. Change-control rules

- Any new UI framework dependency requires an ADR + license review.
- Any visual literal becoming public API must be converted to a semantic role or justified.
- Any material change affecting existing screenshots requires visual-review evidence.
- Any design that introduces per-item live backdrop effects into virtualized List/Tree/Table requires an explicit performance ADR and benchmark evidence.
- Any change that harms native text input/IME/UIA semantics must be rejected or redesigned unless explicitly approved by ADR.
- `STATUS.md` is updated in the same PR/commit whenever a milestone task or architecture decision changes state.

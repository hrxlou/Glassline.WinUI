# Project Plan

> Last updated: 2026-08-13  
> Current milestone: **M0 — Corpus & Decisions**

## 1. Delivery strategy

Glassline.WinUI will be built in seven gated milestones. The order is deliberate: **reference/state/token contracts before control implementation**, and **native WinUI behavior before optical polish**.

| Milestone | Goal | Key deliverables | Exit gate |
|---|---|---|---|
| M0 | Corpus & Decisions | repo bootstrap, AppleReferenceLab plan, 50+ corpus index, measurement ledger, ADR-0001~0009, brand/package decision | Core visual/system rules can be justified with sources and decisions |
| M1 | Foundation | semantic color, typography, spacing/radius, theme dictionaries, active/inactive, Solid/HC fallback | Foundation tokens are consumable without custom renderer |
| M2 | Glass Engine | sidebar/toolbar/popover/interactive glass, pointer specular, motion, scroll-edge, fallback | Quality/perf gate; advanced refraction removed if it cannot meet budget |
| M3 | Core Controls | Button, ToggleSwitch, Slider, TextBox, Search, Check/Radio, Combo/DropDown, Segmented | P0 control state matrix passes DoD |
| M4 | Window & Shell | titlebar, right caption semantics, sidebar/toolbar shell, Settings + productivity archetypes | Snap/system menu/resize/input and visual hierarchy are coherent |
| M5 | Desktop Data | List/Tree/Outline/Table/Menu/Popover/Sheet/Inspector | Desktop productivity primitives usable at scale |
| M6 | RC / Distribution | visual/UIA/IME/perf/package/IP gates, Gallery/docs, preview/stable package | All release gates green |

## 2. Workstreams

### Research & provenance
- Build a 50+ scene corpus index without committing Apple screenshots.
- Implement AppleReferenceLab capture plan for native SwiftUI/AppKit controls.
- Populate measurement ledger with Observed/Inferred/Glassline-decision classifications.
- Revalidate competitive landscape quarterly.

### Foundation & design system
- Freeze semantic token naming before deep control templates.
- Separate content surfaces from functional glass surfaces.
- Define Light/Dark/High Contrast and active/inactive together.
- Keep `DesignGeneration` separate from NuGet SemVer.

### Controls & shell
- Prefer ControlTemplate/VisualState on native controls.
- Add composite controls only where WinUI lacks the needed semantics.
- Keep Windows caption/Snap/system menu/keyboard behavior.
- Use `Glassline.Gallery` as both sample and product-quality test vehicle.

### Validation
- Visual golden baselines validate Glassline regressions, not Apple pixel matching.
- UIA/Narrator, keyboard, IME, DPI, text scale, RTL, GPU/RDP fallback are independent release lanes.
- Performance budgets are locked after reference hardware is selected.

### Distribution & IP
- Zero Apple shipping assets.
- All third-party source/assets require provenance and notice review.
- Public Gallery must not reproduce Apple app information architecture 1:1.
- Stable publication requires the IP gate and selected repository/package license.

## 3. Immediate critical path

1. **Finish M0 public research artifacts:** 50+ corpus rows + measurement samples.
2. **Create AppleReferenceLab buildable skeleton on macOS** and capture the first Button/Toggle/Slider/TextInput state set.
3. **Resolve open platform/package decisions:** minimum Windows 11 build, .NET target, C++ support boundary, icon provenance, preview feed, screenshot hardware.
4. **Turn M1 tokens into actual WinUI ResourceDictionaries.**
5. **Build Glassline.Gallery before deep P0 control work**, so every component lands with states and baselines.
6. **Implement P0 controls in dependency order:** Button → Toggle → Slider → Text input/Search → Check/Radio → Combo/DropDown → Segmented.
7. **Only after M1 is stable, implement Glass Engine** and run the M2 go/no-go benchmark.

## 4. Dependency order

```text
Research corpus + measurements
        ↓
ADRs + semantic token contract
        ↓
Theme dictionaries + Solid fallback
        ↓
Gallery state matrix + screenshot harness
        ↓
Glass Engine ─────────────┐
        ↓                 │
P0 controls               │
        ↓                 │
Window & shell ◄──────────┘
        ↓
Desktop data controls
        ↓
Hardening / packaging / IP gate
```

## 5. Change-control rules

- Any new UI framework dependency requires an ADR + license review.
- Any visual literal becoming public API must be converted to a semantic role or justified.
- Any material change affecting existing screenshots requires visual-review evidence.
- Any change that harms native text input/IME/UIA semantics must be rejected or redesigned unless explicitly approved by ADR.
- `STATUS.md` is updated in the same PR whenever a milestone task changes state.

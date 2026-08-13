# Glassline.WinUI Project Plan

## Product objective

Build a Windows 11-first WinUI 3 design system that preserves native Windows behavior while providing an alternate semantic visual system and desktop shell/material primitives.

Glassline is not a SwiftUI compatibility layer, not an AppKit clone, and not a custom cross-platform renderer. Native WinUI controls, Windows window semantics, accessibility, text/IME, DPI, input, and compositor behavior remain the base contract.

## Current planning state — 2026-08-13

The repository now has more engineering infrastructure than the formal milestone number suggests. M1/M2/M3 engineering baselines were implemented in parallel so their build/package/API contracts could be tested early. **M0 is still the active project gate** because observed reference measurements are missing.

Current state:

- M0 corpus index: done at metadata level with 70 rows.
- M0 AppleReferenceLab skeleton: done and build/test verified on macOS 26 CI.
- M0 measurement ledger: schema only; this is the remaining M0 task blocker.
- M1 semantic Theme + native Mica/Solid window foundation: engineering baseline implemented, native visual acceptance pending.
- M2 shared material runtime: engineering baseline implemented, final optical/performance decision pending.
- M3 control work: SearchField + SegmentedControl engineering baselines implemented, native interactive DoD pending.
- deterministic Gallery, diagnostics, benchmark workloads, package-consumer validation, and supply-chain validation are implemented.

## Immediate critical path

The critical path is now evidence-first:

1. **Native macOS reference capture** — run AppleReferenceLab interactively for the planned scenes/states.
2. **Observed measurement ledger** — record Button, Toggle, Slider, Sidebar, Toolbar, and Popover evidence with source/state/confidence/classification.
3. **Native Windows baseline acceptance** — establish screenshot/UIA/IME/DPI/window/input/RDP evidence for the current baseline.
4. **Native performance baseline** — measure the deterministic 100/500/5000 benchmark scenes on agreed hardware.
5. **Material decision** — decide whether built-in Desktop Acrylic/MicaAlt is sufficient or a custom Composition material is justified.
6. **Measured P0 execution** — tune/add controls only after their Definition of Ready has actual reference evidence.
7. **Preview release preparation** — API review, first real package baseline, release feed, cross-version compatibility gate.
8. **Advanced optics last** — pointer/specular/refraction only after baseline quality/performance/fallback is proven.

## Milestones

### M0 — Corpus & Decisions

**Status: 5/6 primary tasks complete, 1 partial. Exit blocked on observed measurements.**

Done:

- repository/bootstrap and CI foundation;
- brand/package name and MIT license;
- ADR-0001 through ADR-0010 baseline;
- 70-scene public-safe macOS 26 Tahoe metadata corpus;
- buildable AppleReferenceLab with stable scenes and macOS 26 test/build CI.

Remaining:

- interactive reference captures;
- populate and review the measurement ledger;
- make explicit Glassline decisions from observed/inferred evidence rather than guessed pixels.

**M0 exit gate:** reference measurements for the initial P0/material roles are reviewed and usable by component Definition of Ready.

### M1 — Foundation

**Status: partial engineering baseline implemented; native visual acceptance pending.**

Implemented:

- semantic Light/Dark/High Contrast resources;
- typography/spacing/radius semantic baseline;
- Windows 11/.NET/WinAppSDK target baseline;
- native `Window.SystemBackdrop` Auto/Mica/MicaAlt/Solid controller;
- mandatory Solid behavior for High Contrast/transparency-off.

Remaining:

- native window screenshot matrix;
- active/inactive, resize, Snap, mixed-DPI, RDP acceptance;
- measured optical tuning of semantic surfaces;
- finalize any design-generation public API after measurements.

### M2 — Glass Engine

**Status: partial engineering baseline implemented; final optical engine not selected.**

Implemented:

- semantic material roles;
- `GlasslineGlassContainer` grouped region primitive;
- deterministic MaterialQualityManager;
- environment signals for High Contrast, transparency effects, RDP, window activation, and resize;
- Full/Reduced/Solid transitions;
- current Full = Desktop Acrylic, Reduced = MicaAlt, Solid = semantic opaque surface;
- Gallery diagnostics and grouped Sidebar/Toolbar examples.

Remaining:

- native quality/performance acceptance;
- scroll-edge behavior and any pointer/specular treatment supported by evidence;
- Popover/Interactive/Prominent visual tuning;
- decide built-in material vs custom Composition path;
- advanced refraction/lensing only if later evidence justifies it.

**M2 kill rule:** if stronger optical effects are unstable, expensive, inaccessible, or cannot degrade predictably, keep the built-in/reduced/solid model and drop advanced refraction.

### M3 — Core Controls

**Status: two engineering baselines implemented; component family not complete.**

Implemented:

- SearchField with native TextBox input/IME path;
- SegmentedControl with native ListBox single-selection path;
- stable dependency-property/template-part contracts;
- non-invasive wrapper AutomationPeers;
- Gallery and generated-NuGet consumer integration.

Remaining:

- native DoD for these two controls;
- measured Buttons, ToggleSwitch, Slider, CheckBox/RadioButton, Combo/DropDown, Sidebar/nav row, List row, Toolbar/group, MenuFlyout/ContextMenu, Settings group/row;
- each new component must satisfy Definition of Ready before implementation.

### M4 — Window & Shell

**Status: window-foundation precursor implemented; shell milestone not started.**

Remaining:

- titlebar/content integration and Windows caption semantics;
- Snap/resize/system-menu validation;
- edge-to-edge sidebar/window shell primitives;
- window state/inactive behavior and multi-monitor acceptance.

### M5 — Desktop Data / Presentation

**Status: benchmark workload scaffolding exists; product components not started.**

Planned:

- TreeView/OutlineView/Table/Split/Inspector/TabView;
- desktop data density and large-list behavior;
- benchmark evidence from 100-row settings, 500-item grid, 5k-node tree, rapid transient UI, and continuous resize.

### M6 — Hardening / RC

**Status: not started.**

Requires:

- full native screenshot matrix and visual review;
- UIA/Narrator and keyboard/input acceptance;
- IME/localization/RTL/text-scale/DPI acceptance;
- reference-hardware performance budgets;
- API compatibility against a real prior package baseline;
- package/license/SBOM checks;
- release notes, samples, docs, and preview/stable publishing policy.

## Validation strategy

Three evidence types must never be conflated:

1. **Hosted engineering evidence** — source contracts, pure logic, build, pack, package consumer, SBOM, AppleReferenceLab buildability.
2. **Native Windows evidence** — real rendered UI, accessibility, IME, window/input behavior, DPI/RDP, screenshots, performance.
3. **Native macOS evidence** — AppleReferenceLab reference captures and observed measurements.

See [`engineering/ENVIRONMENT_BOUNDARY.md`](engineering/ENVIRONMENT_BOUNDARY.md).

## Planning rules

- Do not use uninspected screenshots or source code to invent geometry/material values.
- Do not treat compile success as visual/accessibility/IME/performance sign-off.
- Keep content surfaces mostly semantic/solid and group functional glass regions.
- Never create one live backdrop/effect pipeline per repeated item.
- Preserve native TextBox/selector controls for input/accessibility when a semantic equivalent exists.
- Advanced optical effects must be optional and cannot block v1.
- First public package establishes the real API baseline; do not manufacture a fake compatibility baseline before release.

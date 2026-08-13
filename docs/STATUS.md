# Project Status

> **Update this file whenever milestone state changes.**  
> Last updated: **2026-08-13**  
> Current phase: **M0 — Corpus & Decisions**  
> Remote repository: `hrxlou/Glassline.WinUI`  
> Shipping implementation: **engineering baseline started**

## Executive status

The product, architecture, validation, and research specifications are organized under the **Glassline.WinUI** repository structure. M0 research is **not complete**: the 50+ scene corpus, populated measurement ledger, and buildable AppleReferenceLab still remain. In parallel, the repository now has a real, buildable WinUI 3 solution, semantic Theme foundation, Gallery integration, and the first two C# custom/composite-control engineering baselines. This implementation work establishes build/package/API contracts; it does **not** satisfy the remaining M0 research exit criteria or the native interactive Definition of Done for those controls.

The material contract remains **Mica/Solid foundation → grouped functional glass regions → adaptive Full/Reduced/Solid quality → optional refraction**. Shipping optical glass and Mica window-shell work have not started yet.

## Progress snapshot

| Track | State | Evidence / note |
|---|---|---|
| Product contract / scope | Done for M0 | scope/non-goals and Windows-vs-visual boundary documented |
| Visual principles / material model | **Done for M0, clarified** | functional/content separation, Mica foundation, grouped regions, semantic material roles, adaptive quality documented |
| Architecture/package contract | **Done for M0, implemented baseline** | Theme / Controls / Effects / Gallery projects now exist and respect documented dependency boundaries |
| Material architecture ADR | **Done** | ADR-0010 + `docs/architecture/MATERIAL_ARCHITECTURE.md` |
| Validation/release/IP policy | **Done for M0, active in CI** | repository/Theme/Controls contract validation plus package forbidden-asset scan run in CI |
| Competitive research | Done, dated | Snapshot dated 2026-08-13; periodic revalidation required |
| Windows App SDK pin | **Done** | 2.3.1 centrally pinned |
| Windows/.NET baseline | **Done for engineering baseline** | `net8.0-windows10.0.22000.0`; minimum target platform `10.0.22000.0`; x64 + ARM64 compile lanes |
| Repository bootstrap | **Done** | public GitHub repository, MIT, solution/projects, workflows, scripts |
| Project name | **Done** | `Glassline.WinUI` finalized for repository/package namespace |
| Repository license | **Done** | MIT |
| ADR-0001~0010 | **Done, initial** | under `docs/architecture/adr/` |
| Measurement ledger | **Partial** | schema committed; observed measurements not yet populated |
| 50+ visual corpus index | Not started | schema exists; rows need collection |
| AppleReferenceLab | Not started | directory/spec exists; buildable macOS probe app not yet created |
| M1 foundation XAML | **Partial — engineering baseline** | semantic Light/Dark/HighContrast resources implemented and WinUI-compiled; Mica/Solid window foundation still pending |
| M2 glass implementation | Not started | `GlassContainer`/quality manager remain architecture only; HTML/CSS lab does not count as shipping effects code |
| P0 controls | **Partial — engineering baseline** | `GlasslineSearchField` + `GlasslineSegmentedControl` implemented, x64/ARM64 compiled, packed and consumer-compiled; native interactive DoD pending |
| Gallery / executable tests | **Partial — buildable** | Gallery compiles with Theme and both controls; deterministic launch/screenshot/UI automation harness remains pending |
| NuGet packaging | **Baseline passing** | Theme/Controls/Effects pack; package asset scan; fresh Controls-package consumer restore/build passes |
| Repository policy CI | **Passing** | build/contract/package/policy lanes passed for PR #6 before merge |

## M0 task accounting

The milestone dashboard still tracks six primary M0 tasks. Implementation progress does not change these research exit criteria:

- [x] Repository/bootstrap — public repository + policy scaffold + MIT license + buildable WinUI solution.
- [ ] AppleReferenceLab skeleton — buildable probe app still required.
- [ ] 50+ visual corpus index — schema only.
- [~] Measurement ledger — schema only; data collection required.
- [x] ADR baseline — ADR-0001~0010 accepted, including material architecture.
- [x] Brand/package name — `Glassline.WinUI` finalized.

**M0 primary-task progress: 3/6 complete, 1 partial, 2 not started.** This is a research/task-state indicator, not an implementation effort estimate.

## What is complete

- Repository and package architecture is no longer documentation-only: the Theme, Controls, Effects, and Gallery projects plus `Glassline.WinUI.sln` build on Windows CI.
- The Windows engineering baseline is locked to .NET 8 with Windows 11 build 22000 target/minimum and Windows App SDK 2.3.1.
- x64 and ARM64 restore/build lanes pass on Windows runners.
- `Glassline.WinUI.Theme` has Light, Dark, and High Contrast semantic resource dictionaries mapped to native WinUI theme resources without shipping copied Apple color/font/symbol assets.
- Theme validation parses the XAML contract, checks required semantic keys, rejects raw color literals for this baseline, and keeps runtime optical effects out of Theme.
- `GlasslineSearchField` is a templated C# `Control` whose `PART_Input` is a native WinUI `TextBox`; text input, selection, clipboard, keyboard, and IME remain on the native input path.
- `GlasslineSegmentedControl` is a templated C# `Control` whose `PART_Selector` is a native WinUI `ListBox` using single-selection semantics.
- Both controls expose dependency-property/template-part contracts and are instantiated by Gallery XAML.
- Controls static/template validation checks the native-composition rules and prevents custom text/IME-engine drift.
- Theme/Controls/Effects NuGet packages are produced and scanned for forbidden shipping assets.
- A separate WinUI package-smoke app restores the generated `Glassline.WinUI.Controls` NuGet and compiles without any Glassline project reference, validating the produced package-consumer path.
- Native-interactive acceptance requirements for the two controls are explicitly recorded in `docs/engineering/CONTROLS_NATIVE_ACCEPTANCE.md` rather than being falsely marked complete.
- Mica is positioned as the preferred native window foundation when supported/appropriate, with semantic Solid fallback.
- Functional glass is additive and grouped into shared material regions rather than per-control backdrop pipelines.
- `Auto → Full / Reduced / Solid` is defined as runtime behavior; resize/inactive/environment downgrade policy is documented.
- Advanced refraction remains optional and cannot block v1.
- Public asset/IP policy is documented; non-redistributable reference material is excluded from the repository.

## Current validation evidence

### PR #4 — build baseline

- buildable WinUI solution and projects;
- x64 + ARM64 Windows build;
- NuGet pack and package forbidden-asset scan;
- repository policy checks.

### PR #5 — Theme foundation

- Light/Dark/HighContrast semantic-resource contract validation;
- x64 + ARM64 WinUI/XAML build;
- Gallery resource merge;
- NuGet pack/content scan;
- repository policy checks.

### PR #6 — C# custom/composite-control baseline

Final Windows build run `31689240636` passed:

- repository structural contract;
- Theme resource contract;
- Controls static/template contract;
- x64 restore/build;
- ARM64 restore/build;
- Theme/Controls/Effects NuGet pack;
- forbidden-asset package-content scan;
- fresh WinUI app restore/build against generated `Glassline.WinUI.Controls` NuGet with no Glassline `ProjectReference`;
- NuGet artifact upload.

Repository policy run `31689240591` also passed. A preceding strengthened run exposed an incorrect NuGet-source invocation; that CI defect was fixed and the full matrix was rerun successfully rather than accepting a partial result.

## Native validation still pending for the first controls

Hosted compilation/package CI is not final component Definition of Done. The following require an interactive Windows 11 desktop and remain pending:

- pointer-over / pressed / keyboard-focus visual-state inspection;
- Narrator + UI Automation role/name/state/value inspection;
- Korean 2-set, Japanese, and Simplified Chinese IME composition/candidate-window tests for `GlasslineSearchField`;
- clipboard/selection/undo/redo smoke tests;
- 100/125/150/200% DPI and text-scaling inspection;
- Light/Dark/High Contrast visual capture;
- RTL and long-localized-string smoke tests;
- active/inactive window behavior;
- screenshot golden-baseline approval.

Until those entries are recorded, `GlasslineSearchField` and `GlasslineSegmentedControl` are **engineering baselines**, not visually complete or release-ready components.

## Next 10 actions

1. Populate `research/corpus-index/corpus-index.csv` with at least 50 scenes and source IDs.
2. Populate the first measurement set for Button, Toggle, Slider, Sidebar, Toolbar, and Popover.
3. Create a buildable `research/AppleReferenceLab` macOS project and capture Light/Dark + interaction states.
4. Run/record native Windows interactive acceptance for `GlasslineSearchField` and `GlasslineSegmentedControl` using `docs/engineering/CONTROLS_NATIVE_ACCEPTANCE.md`.
5. Implement the M1 system Mica/Solid window foundation while preserving the existing semantic Theme contract.
6. Add Gallery diagnostics for material mode, window activation, resize, active glass-region count, and total glass area.
7. Prototype one shared `GlassContainer`-style toolbar/sidebar material region using baseline Windows Composition only.
8. Implement `MaterialCapabilities` + `MaterialQualityManager` and verify Full → Reduced → Solid, continuous-resize downgrade, and inactive/background suppression.
9. Add deterministic screenshot, UIA, IME, DPI, and runtime Gallery validation harnesses on appropriate Windows infrastructure.
10. Start additional P0 controls only when their Definition of Ready evidence is satisfied; do not treat the two engineering baselines as permission to bypass M0 research gates.

## Open blockers / decisions

- C++/WinRT support boundary beyond the Theme-first policy is not finalized.
- Icon provenance strategy is not finalized.
- Preview NuGet feed and release publishing workflow are not finalized.
- Screenshot CI runner/reference GPU and visual reviewer policy are not finalized.
- Native interactive Windows acceptance infrastructure/device access is still required for UIA/IME/DPI/visual DoD.
- AppleReferenceLab requires a native macOS environment for reference capture; this is research validation, not a shipping dependency.

## Update protocol

When a task changes:

1. Change its checkbox/state here.
2. Add the evidence path, commit, PR, or issue.
3. Update milestone accounting.
4. If the change alters an architecture/product rule, update or add an ADR.
5. Add a short entry to the status change log.

## Status change log

- **2026-08-13:** PR #6 merged the first C# custom/composite-control engineering baselines (`GlasslineSearchField`, `GlasslineSegmentedControl`), Gallery integration, static/template contract validation, NuGet package-consumer smoke app, and native-acceptance ledger. Final x64/ARM64/build/pack/package-consumer/policy gates passed.
- **2026-08-13:** PR #5 merged the semantic Theme foundation with Light/Dark/HighContrast resource contracts and Windows XAML/build/package validation.
- **2026-08-13:** PR #4 converted the repository from documentation-only scaffold to a real WinUI solution/projects and Windows CI baseline. The first CI run exposed a TFM/minimum-platform mismatch; it was corrected to build 22000 and the full x64/ARM64/package matrix passed.
- **2026-08-13:** Material architecture clarified from the source blueprints and design discussion: Mica/Solid foundation, shared GlassContainer-style regions, semantic roles, runtime quality downgrade, material-specific perf instrumentation, and ADR-0010 added.
- **2026-08-13:** Public README refreshed; local-only research artifacts removed from the public tree; repository policy workflow verified passing.
- **2026-08-13:** Project renamed/finalized as `Glassline.WinUI`; public repository created; MIT selected; repository bootstrap moved to Done.
- **2026-08-13:** Initial repository structure and living status documentation established.

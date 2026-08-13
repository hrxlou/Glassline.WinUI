# Project Status

> **Update this file whenever milestone state changes.**  
> Last updated: **2026-08-13**  
> Current phase: **M0 — Corpus & Decisions**  
> Remote repository: `hrxlou/Glassline.WinUI`  
> Shipping implementation: **not started**

## Executive status

The product, architecture, validation, and research specifications are organized under the **Glassline.WinUI** repository structure. The repository bootstrap, MIT license, naming policy, package boundaries, and material architecture are established. The current material contract now explicitly defines **Mica/Solid foundation → grouped functional glass regions → adaptive Full/Reduced/Solid quality → optional refraction**. No shipping WinUI renderer exists yet; the next engineering work remains evidence collection and buildable reference/test infrastructure.

## Progress snapshot

| Track | State | Evidence / note |
|---|---|---|
| Product contract / scope | Done for M0 | scope/non-goals and Windows-vs-visual boundary documented |
| Visual principles / material model | **Done for M0, clarified** | functional/content separation, Mica foundation, grouped regions, semantic material roles, adaptive quality documented |
| Architecture/package contract | **Done for M0, clarified** | Theme / Controls / Effects / Gallery boundaries + shared material-region contract defined |
| Material architecture ADR | **Done** | ADR-0010 + `docs/architecture/MATERIAL_ARCHITECTURE.md` |
| Validation/release/IP policy | **Done for M0, clarified** | material perf metrics now include region count/area, quality mode, resize/inactive policy |
| Competitive research | Done, dated | Snapshot dated 2026-08-13; periodic revalidation required |
| Windows App SDK pin | Done | 2.3.1 verified as latest stable on 2026-08-13 |
| Repository bootstrap | **Done** | public GitHub repository created and scaffold published to `main` |
| Project name | **Done** | `Glassline.WinUI` finalized for repository/package namespace |
| Repository license | **Done** | MIT |
| ADR-0001~0010 | **Done, initial** | under `docs/architecture/adr/` |
| Measurement ledger | **Partial** | schema committed; observed measurements not yet populated |
| 50+ visual corpus index | Not started | schema exists; rows need collection |
| AppleReferenceLab | Not started | directory/spec exists; buildable macOS probe app not yet created |
| M1 foundation XAML | Not started | Mica/Solid foundation is specified but no shipping WinUI project/code yet |
| M2 glass implementation | Not started | `GlassContainer`/quality manager are architecture only; HTML/CSS lab does not count as shipping effects code |
| P0 controls | Not started | deep implementation waits for M0 exit criteria |
| Gallery / executable tests | Planned | structure and acceptance rules exist; harness not yet implemented |
| Repository policy CI | **Passing before this docs update** | push workflow was active and passing on the previous main commit; re-check after material-doc commit |

## M0 task accounting

The milestone dashboard tracks six primary M0 tasks:

- [x] Repository/bootstrap — public repository + policy scaffold + MIT license.
- [ ] AppleReferenceLab skeleton — buildable probe app still required.
- [ ] 50+ visual corpus index — schema only.
- [~] Measurement ledger — schema only; data collection required.
- [x] ADR baseline — ADR-0001~0010 accepted, including material architecture.
- [x] Brand/package name — `Glassline.WinUI` finalized.

**M0 primary-task progress: 3/6 complete, 1 partial, 2 not started.** This is a task-state indicator, not an effort estimate.

## What is complete

- Visual failure modes and design corrections are documented as explicit design rules.
- Research source hierarchy, measurement methodology, and provenance boundaries are documented.
- Product scope and Windows-native behavior requirements are documented.
- Theme / Controls / Effects / Gallery package boundaries are documented.
- Mica is now explicitly positioned as the preferred native window foundation when supported/appropriate, with semantic Solid fallback.
- Functional glass is explicitly additive and grouped into shared material regions rather than per-control backdrop pipelines.
- `Auto → Full / Reduced / Solid` is defined as runtime behavior; resize/inactive/environment downgrade policy is documented.
- Advanced refraction remains optional and cannot block v1.
- Validation lanes cover screenshots, UIA/Narrator, keyboard, IME, DPI, text scale, RTL, fallback rendering, and performance.
- Material performance evidence now includes frame-time percentiles, GPU/memory signals where available, glass region count/area, current material mode, and refraction state.
- Public asset/IP policy is documented; non-redistributable reference material is excluded from the repository.
- `Glassline.WinUI` branding and MIT licensing are established.

## Next 10 actions

1. Populate `research/corpus-index/corpus-index.csv` with at least 50 scenes and source IDs.
2. Populate the first measurement set for Button, Toggle, Slider, Sidebar, Toolbar, and Popover.
3. Create a buildable `research/AppleReferenceLab` macOS project and capture Light/Dark + interaction states.
4. Lock minimum Windows 11 build, .NET target framework, C++ support boundary, and reference GPU/CI hardware.
5. Create actual WinUI projects for `Glassline.WinUI.Theme`, `Glassline.WinUI.Controls`, `Glassline.WinUI.Effects`, and `Glassline.Gallery`.
6. Implement M1 semantic ResourceDictionaries plus system Mica/Solid window foundation and High Contrast fallback.
7. Add Gallery diagnostics for material mode, window activation, resize, active glass-region count, and total glass area.
8. Prototype one shared `GlassContainer`-style toolbar/sidebar material region using baseline Windows Composition only.
9. Implement `MaterialCapabilities` + `MaterialQualityManager` and verify Full → Reduced → Solid, continuous-resize downgrade, and inactive/background suppression.
10. Start the first P0 control only after its Definition of Ready and the baseline material-region architecture are stable.

## Open blockers / decisions

- Minimum Windows 11 build and .NET target framework are not finalized.
- C++/WinRT support boundary is not finalized.
- Icon provenance strategy is not finalized.
- Preview NuGet feed and release publishing workflow are not finalized.
- Screenshot CI runner/reference GPU and visual reviewer policy are not finalized.

## Update protocol

When a task changes:

1. Change its checkbox/state here.
2. Add the evidence path, commit, PR, or issue.
3. Update milestone accounting.
4. If the change alters an architecture/product rule, update or add an ADR.
5. Add a short entry to the status change log.

## Status change log

- **2026-08-13:** Material architecture clarified from the source blueprints and design discussion: Mica/Solid foundation, shared GlassContainer-style regions, semantic roles, runtime quality downgrade, material-specific perf instrumentation, and ADR-0010 added.
- **2026-08-13:** Public README refreshed; local-only research artifacts removed from the public tree; repository policy workflow verified passing.
- **2026-08-13:** Project renamed/finalized as `Glassline.WinUI`; public repository created; MIT selected; repository bootstrap moved to Done.
- **2026-08-13:** Initial repository structure and living status documentation established.

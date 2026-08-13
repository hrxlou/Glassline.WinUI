# Project Status

> **Update this file whenever milestone state changes.**  
> Last updated: **2026-08-13**  
> Current phase: **M0 — Corpus & Decisions**  
> Remote repository: `hrxlou/Glassline.WinUI`  
> Shipping implementation: **not started**

## Executive status

The product, architecture, validation, and research specifications are organized under the **Glassline.WinUI** repository structure. The repository bootstrap, initial ADR set, MIT license, naming policy, and package boundaries are now established. The next engineering work is evidence collection and buildable reference/test infrastructure; visual research artifacts do not count as shipping WinUI code.

## Progress snapshot

| Track | State | Evidence / note |
|---|---|---|
| Product contract / scope | Done for M0 | scope/non-goals and Windows-vs-visual boundary documented |
| Visual principles / material model | Done for M0 | semantic surfaces + glass model + visual correction rules documented |
| Architecture/package contract | Done for M0 | Theme / Controls / Effects / Gallery boundaries defined |
| Validation/release/IP policy | Done for M0 | visual/UIA/IME/perf/package/IP gates defined |
| Competitive research | Done, dated | Snapshot dated 2026-08-13; periodic revalidation required |
| Windows App SDK pin | Done | 2.3.1 verified as latest stable on 2026-08-13 |
| Repository bootstrap | **Done** | public GitHub repository created and scaffold published to `main` |
| Project name | **Done** | `Glassline.WinUI` finalized for repository/package namespace |
| Repository license | **Done** | MIT |
| ADR-0001~0009 | Done, initial | under `docs/architecture/adr/` |
| Measurement ledger | **Partial** | schema committed; observed measurements not yet populated |
| 50+ visual corpus index | Not started | schema exists; rows need collection |
| AppleReferenceLab | Not started | directory/spec exists; buildable macOS probe app not yet created |
| M1 foundation XAML | Not started | no shipping WinUI project/code yet |
| M2 glass implementation | Not started | HTML/CSS lab does not count as shipping effects code |
| P0 controls | Not started | deep implementation waits for M0 exit criteria |
| Gallery / executable tests | Planned | structure and acceptance rules exist; harness not yet implemented |
| Repository policy CI | **Passing** | push workflow is active and repository policy checks pass |

## M0 task accounting

The milestone dashboard tracks six primary M0 tasks:

- [x] Repository/bootstrap — public repository + policy scaffold + MIT license.
- [ ] AppleReferenceLab skeleton — buildable probe app still required.
- [ ] 50+ visual corpus index — schema only.
- [~] Measurement ledger — schema only; data collection required.
- [x] ADR-0001~0009 — initial decisions recorded.
- [x] Brand/package name — `Glassline.WinUI` finalized.

**M0 primary-task progress: 3/6 complete, 1 partial, 2 not started.** This is a task-state indicator, not an effort estimate.

## What is complete

- Visual failure modes and design corrections are documented as explicit design rules.
- Research source hierarchy, measurement methodology, and provenance boundaries are documented.
- Product scope and Windows-native behavior requirements are documented.
- Theme / Controls / Effects / Gallery package boundaries are documented.
- Validation lanes cover screenshots, UIA/Narrator, keyboard, IME, DPI, text scale, RTL, fallback rendering, and performance.
- Public asset/IP policy is documented; non-redistributable reference material is excluded from the repository.
- `Glassline.WinUI` branding and MIT licensing are established.

## Next 8 actions

1. Populate `research/corpus-index/corpus-index.csv` with at least 50 scenes and source IDs.
2. Populate the first measurement set for Button, Toggle, Slider, Sidebar, Toolbar, and Popover.
3. Create a buildable `research/AppleReferenceLab` macOS project and capture Light/Dark + interaction states.
4. Lock minimum Windows 11 build, .NET target framework, C++ support boundary, and reference GPU/CI hardware.
5. Create actual WinUI projects for `Glassline.WinUI.Theme`, `Glassline.WinUI.Controls`, `Glassline.WinUI.Effects`, and `Glassline.Gallery`.
6. Implement M1 semantic ResourceDictionaries and Solid/High Contrast fallback first.
7. Add executable screenshot, UIA, package-content, and benchmark harnesses.
8. Start the first P0 control only after its Definition of Ready is satisfied.

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

- **2026-08-13:** Public README refreshed; local-only research artifacts removed from the public tree; repository policy workflow verified passing.
- **2026-08-13:** Project renamed/finalized as `Glassline.WinUI`; public repository created; MIT selected; repository bootstrap moved to Done.
- **2026-08-13:** Initial repository structure and living status documentation established.

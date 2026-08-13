# Decisions Pending

Stable decisions should be promoted to an ADR or the appropriate policy document. This file contains only unresolved operational/platform decisions plus a short record of bootstrap decisions already closed.

## Open decisions

| Decision | Current working state | Required before |
|---|---|---|
| Minimum Windows 11 build | TBD | project files / CI matrix |
| .NET target framework | TBD | C# project files |
| C++/WinRT support | Theme package likely; final scope TBD | API support statement |
| Icon set provenance | own glyphs vs permissive OSS base | Gallery/public package |
| Preview NuGet feed | TBD | first preview |
| Screenshot CI runner / reference GPU | TBD | visual/perf baseline lock |
| Visual reviewer count | TBD | release process |

## Resolved during repository bootstrap

| Decision | Resolution | Date |
|---|---|---|
| Product/repository name | `Glassline.WinUI` | 2026-08-13 |
| Package namespace | `Glassline.WinUI.*` + `Glassline.Gallery` | 2026-08-13 |
| Repository license | MIT | 2026-08-13 |
| Distribution posture | OSS-first for project-authored code/docs; third-party source material remains separately governed | 2026-08-13 |
| Windows App SDK baseline | 2.3.1, centrally pinned for bootstrap | 2026-08-13 |

## Decision procedure

For each open decision, record alternatives, constraints, evidence, decision, consequences, and review date. Architecture-impacting decisions become ADRs; operational decisions may remain here until stabilized.

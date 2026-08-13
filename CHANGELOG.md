# Changelog

All notable project-level changes are tracked here. Shipping package versions will follow SemVer once executable packages exist.

## Unreleased

### Material architecture
- Clarified the core material stack as native Mica/Solid window foundation plus grouped functional glass regions.
- Added the `GlassContainer`-style shared material-region requirement to avoid per-control live backdrop pipelines.
- Defined semantic material roles and kept raw optical/shader constants out of the primary public API contract.
- Strengthened `Auto → Full / Reduced / Solid` runtime policy, including continuous-resize downgrade and inactive/background animation suppression.
- Expanded performance evidence to include frame-time percentiles, GPU/memory signals where available, glass-region count/area, material mode, and refraction state.
- Added ADR-0010 and `docs/architecture/MATERIAL_ARCHITECTURE.md`.
- Kept advanced refraction/lensing optional and behind the M2 go/no-go gate.

### Repository bootstrap
- Finalized project/repository identity as `Glassline.WinUI`.
- Established the `Glassline` package, test, and sample namespaces.
- Adopted the MIT License for project-authored source code and documentation.
- Added trademark/non-affiliation policy for Microsoft and Apple references.
- Established role-specific source-of-truth documentation.
- Added M0–M6 project plan and living status document.
- Added ADR-0001 through ADR-0009.
- Added research ledger/corpus schemas and private-reference boundary.
- Added GitHub issue/PR templates and repository policy checks.

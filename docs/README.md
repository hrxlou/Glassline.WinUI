# Documentation Map

Use these documents as the current source of truth for Glassline.WinUI.

## Start here

- [`STATUS.md`](STATUS.md) — current implementation/research state, milestone accounting, next actions.
- [`PROJECT_PLAN.md`](PROJECT_PLAN.md) — milestone plan and current evidence-first critical path.
- [`engineering/ENVIRONMENT_BOUNDARY.md`](engineering/ENVIRONMENT_BOUNDARY.md) — what hosted CI can prove vs what requires native Windows/macOS.
- [`DECISIONS_PENDING.md`](DECISIONS_PENDING.md) — resolved, provisional, and open engineering decisions.

## Product / architecture

- [`PRODUCT_SPEC.md`](PRODUCT_SPEC.md)
- [`architecture/PACKAGE_ARCHITECTURE.md`](architecture/PACKAGE_ARCHITECTURE.md)
- [`architecture/MATERIAL_ARCHITECTURE.md`](architecture/MATERIAL_ARCHITECTURE.md)
- [`architecture/adr/`](architecture/adr/) — ADR-0001 through ADR-0010 baseline.

## Research / visual system

- [`RESEARCH_METHOD.md`](RESEARCH_METHOD.md)
- [`VISUAL_SYSTEM.md`](VISUAL_SYSTEM.md)
- [`../research/corpus-index/README.md`](../research/corpus-index/README.md) — 70-row public-safe corpus metadata policy.
- [`../research/AppleReferenceLab/README.md`](../research/AppleReferenceLab/README.md) — buildable macOS reference probe and capture matrix.
- `../research/measurements/measurement-ledger.csv` — measurement schema; observed rows remain M0 evidence work.

## Engineering / validation

- [`engineering/VALIDATION.md`](engineering/VALIDATION.md)
- [`engineering/ENVIRONMENT_BOUNDARY.md`](engineering/ENVIRONMENT_BOUNDARY.md)
- [`engineering/CONTROLS_NATIVE_ACCEPTANCE.md`](engineering/CONTROLS_NATIVE_ACCEPTANCE.md)
- [`engineering/WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md`](engineering/WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md)
- [`engineering/MATERIAL_NATIVE_ACCEPTANCE.md`](engineering/MATERIAL_NATIVE_ACCEPTANCE.md)
- [`engineering/GALLERY_NATIVE_ACCEPTANCE.md`](engineering/GALLERY_NATIVE_ACCEPTANCE.md)
- [`engineering/PERFORMANCE_NATIVE_ACCEPTANCE.md`](engineering/PERFORMANCE_NATIVE_ACCEPTANCE.md)
- [`engineering/API_CONTRACT.md`](engineering/API_CONTRACT.md)
- [`engineering/ACCESSIBILITY_INPUT.md`](engineering/ACCESSIBILITY_INPUT.md)
- [`engineering/PERFORMANCE.md`](engineering/PERFORMANCE.md)
- [`engineering/TESTING.md`](engineering/TESTING.md)
- [`engineering/CI_RELEASE.md`](engineering/CI_RELEASE.md)

## Planning

- [`planning/BOOTSTRAP_BACKLOG.md`](planning/BOOTSTRAP_BACKLOG.md) — bootstrap/hosted/native evidence checklist.
- [`planning/COMPONENT_EXECUTION.md`](planning/COMPONENT_EXECUTION.md) — Definition of Ready / Definition of Done and component execution rules.

## IP / provenance

- [`ip/ASSET_POLICY.md`](ip/ASSET_POLICY.md)
- [`ip/TRADEMARK_NAMING.md`](ip/TRADEMARK_NAMING.md)
- [`../SOURCE_PROVENANCE.md`](../SOURCE_PROVENANCE.md)
- [`../THIRD-PARTY-NOTICES`](../THIRD-PARTY-NOTICES)

When status changes, update `STATUS.md` first, then the relevant architecture/validation/planning document. Do not mark native visual/accessibility/IME/performance acceptance complete based only on hosted compilation.

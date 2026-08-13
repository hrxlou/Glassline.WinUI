# Documentation Map

Use these documents as the current source of truth for Glassline.WinUI.

## Start here

- [`STATUS.md`](STATUS.md) — current implementation/research state, M0 accounting, evidence blockers, and next actions.
- [`PROJECT_PLAN.md`](PROJECT_PLAN.md) — milestone plan and the current evidence-first critical path.
- [`engineering/ENVIRONMENT_BOUNDARY.md`](engineering/ENVIRONMENT_BOUNDARY.md) — what hosted CI can prove versus what requires native Windows/macOS.
- [`DECISIONS_PENDING.md`](DECISIONS_PENDING.md) — resolved, provisional, and open engineering decisions.
- [`PROJECT_PRINCIPLES.md`](PROJECT_PRINCIPLES.md) — repository-level project principles.

## Product / architecture

- [`product/PRODUCT_CONTRACT.md`](product/PRODUCT_CONTRACT.md) — product scope, non-goals, platform behavior contract.
- [`architecture/ARCHITECTURE.md`](architecture/ARCHITECTURE.md) — package/layer/runtime architecture.
- [`architecture/MATERIAL_ARCHITECTURE.md`](architecture/MATERIAL_ARCHITECTURE.md) — implemented material baseline and advanced-optics boundary.
- [`architecture/adr/`](architecture/adr/) — ADR-0001 through ADR-0010 baseline.

## Design system

- [`design-system/DESIGN_SYSTEM.md`](design-system/DESIGN_SYSTEM.md) — design-system structure and component/material vocabulary.
- [`design-system/THEME_RESOURCE_CONTRACT.md`](design-system/THEME_RESOURCE_CONTRACT.md) — semantic Theme resource contract.
- [`design-system/VISUAL_CORRECTIONS.md`](design-system/VISUAL_CORRECTIONS.md) — known visual failure modes and corrective rules.

## Research

- [`research/RESEARCH_METHOD.md`](research/RESEARCH_METHOD.md) — evidence hierarchy and measurement method.
- [`research/SOURCES.md`](research/SOURCES.md) — research source registry/context.
- [`research/COMPETITIVE_LANDSCAPE.md`](research/COMPETITIVE_LANDSCAPE.md) — dated competitive/related-project snapshot.
- [`../research/README.md`](../research/README.md) — current public research workspace state.
- [`../research/corpus-index/README.md`](../research/corpus-index/README.md) — 70-row public-safe corpus metadata policy.
- [`../research/AppleReferenceLab/README.md`](../research/AppleReferenceLab/README.md) — buildable macOS reference probe and capture matrix.
- [`../research/measurements/measurement-ledger.csv`](../research/measurements/measurement-ledger.csv) — measurement schema; observed rows remain the M0 evidence blocker.

## Engineering / validation

- [`engineering/VALIDATION.md`](engineering/VALIDATION.md) — full hosted/native validation strategy.
- [`engineering/ENVIRONMENT_BOUNDARY.md`](engineering/ENVIRONMENT_BOUNDARY.md) — authoritative execution/evidence boundary.
- [`engineering/WORKFLOW.md`](engineering/WORKFLOW.md) — engineering workflow.
- [`engineering/CONTROLS_NATIVE_ACCEPTANCE.md`](engineering/CONTROLS_NATIVE_ACCEPTANCE.md) — composite-control native acceptance ledger.
- [`engineering/WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md`](engineering/WINDOW_BACKDROP_NATIVE_ACCEPTANCE.md) — window backdrop native acceptance ledger.
- [`engineering/MATERIAL_NATIVE_ACCEPTANCE.md`](engineering/MATERIAL_NATIVE_ACCEPTANCE.md) — material runtime native acceptance ledger.
- [`engineering/GALLERY_NATIVE_ACCEPTANCE.md`](engineering/GALLERY_NATIVE_ACCEPTANCE.md) — Gallery screenshot/UIA/IME/DPI/window acceptance ledger.
- [`engineering/PERFORMANCE_NATIVE_ACCEPTANCE.md`](engineering/PERFORMANCE_NATIVE_ACCEPTANCE.md) — reference-hardware performance acceptance ledger.

## Planning

- [`planning/BOOTSTRAP_BACKLOG.md`](planning/BOOTSTRAP_BACKLOG.md) — hosted/native evidence checklist and current backlog.
- [`planning/COMPONENT_EXECUTION.md`](planning/COMPONENT_EXECUTION.md) — Definition of Ready / Definition of Done and component execution rules.
- [`planning/SUCCESS_RISKS_GATES.md`](planning/SUCCESS_RISKS_GATES.md) — success criteria, risks, and kill/pivot gates.

## Legal / provenance

- [`legal/IP_AND_DISTRIBUTION.md`](legal/IP_AND_DISTRIBUTION.md) — public/private asset and distribution policy.
- [`legal/TRADEMARKS.md`](legal/TRADEMARKS.md) — trademark and non-affiliation guidance.
- [`../THIRD-PARTY-NOTICES`](../THIRD-PARTY-NOTICES) — third-party notices.
- [`../LICENSE`](../LICENSE) — MIT license.

When status changes, update `STATUS.md` first, then the relevant architecture/validation/planning document. Do not mark native visual/accessibility/IME/performance acceptance complete based only on hosted compilation.

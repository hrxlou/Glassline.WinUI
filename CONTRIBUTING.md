# Contributing

The project is in M0. Until M0 exits, changes should prioritize research provenance, semantic tokens, architecture decisions, and validation infrastructure over deep P0 control implementation.

## Required for design-system work

- Attach reference/source IDs and classify values as Observed, Inferred, or Glassline decision.
- Satisfy the component Definition of Ready before implementation.
- Preserve native WinUI accessibility/input/IME semantics unless an ADR explicitly changes the rule.
- Do not commit Apple fonts, SF Symbols exports, Apple UI-kit exports, Apple screenshots, or unlicensed third-party source/assets.
- Visual changes require Gallery before/after evidence once the Gallery exists.
- Public API/style-token changes require an ADR or API review note.

See `docs/engineering/WORKFLOW.md`, `docs/planning/COMPONENT_EXECUTION.md`, and `docs/legal/IP_AND_DISTRIBUTION.md`.

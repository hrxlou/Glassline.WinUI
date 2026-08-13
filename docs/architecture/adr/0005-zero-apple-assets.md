# ADR-0005: No Apple assets in shipping/public package

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Do not ship Apple logos, product artwork, SF fonts, SF Symbols exports, Apple UI-kit exports, Apple screenshots, or Apple app icons. Keep licensed/private references out of Git.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

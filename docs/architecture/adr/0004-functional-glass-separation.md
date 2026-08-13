# ADR-0004: Functional glass vs content surface separation

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Use glass for functional/elevated navigation and transient surfaces. Settings rows, tables, text fields, and normal content surfaces remain standard/flat semantic materials.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

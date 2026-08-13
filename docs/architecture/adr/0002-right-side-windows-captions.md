# ADR-0002: Right-side Windows caption semantics

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Keep Minimize → Maximize/Restore → Close on the top-right with Windows meanings, including Snap/system-menu/titlebar behavior. Surrounding chrome may be visually redesigned, but macOS traffic-light controls are not transplanted.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

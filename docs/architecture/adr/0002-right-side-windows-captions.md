# ADR-0002: Right-side Windows caption semantics

- Status: **Superseded by [ADR-0011](0011-system-caption-ownership.md)**
- Date: 2026-08-13
- Superseded: 2026-08-14

> This ADR fixed the caption cluster to the top-right. That holds for LTR only — Windows moves the
> caption cluster to the leading corner under RTL flow direction — and more broadly it froze a value
> the shell owns as a project decision. ADR-0011 replaces it.

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Keep Minimize → Maximize/Restore → Close on the top-right with Windows meanings, including Snap/system-menu/titlebar behavior. Surrounding chrome may be visually redesigned, but macOS traffic-light controls are not transplanted.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

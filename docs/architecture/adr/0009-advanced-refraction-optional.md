# ADR-0009: Advanced refraction is optional

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Adaptive glass quality and fallback behavior are required; custom D2D/D3D spatial refraction is R&D and never a v1 release blocker. If M2 performance/quality is weak, ship the simpler adaptive material.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

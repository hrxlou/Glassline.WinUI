# ADR-0007: Windows 11 is the v1 full-fidelity target

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Target Windows 11 for full visual fidelity, x64 and ARM64. Windows 10 parity is explicitly out of scope for v1.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

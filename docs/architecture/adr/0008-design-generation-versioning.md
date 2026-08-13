# ADR-0008: Design Generation is separate from SemVer

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Package SemVer and annual visual-generation selection are independent. Patch releases do not intentionally change geometry; new visual generations are opt-in until a major-version decision changes defaults.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

# ADR-0003: Semantic token model

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Public color/material/typography tokens are named by semantic role rather than copied visual literals. Observed Apple values are research evidence; shipping values are Glassline decisions.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

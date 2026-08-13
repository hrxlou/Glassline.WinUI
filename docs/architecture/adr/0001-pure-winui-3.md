# ADR-0001: Pure WinUI 3 core

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Use WinUI 3 / Windows App SDK as the shipping UI runtime. Do not introduce Uno, Avalonia, WPF, Chromium/Flutter, or another cross-platform renderer into the core dependency graph.

This preserves the project contract: native Windows behavior with an alternate visual system.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

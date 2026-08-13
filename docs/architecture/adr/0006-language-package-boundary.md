# ADR-0006: Theme cross-language; Controls C# first-class

- Status: **Accepted**
- Date: 2026-08-13

## Context

The project needs a stable rule that prevents implementation drift while preserving native Windows behavior and the independent Glassline visual-system goal.

## Decision

Keep `Glassline.WinUI.Theme` as pure XAML as far as possible so C# and C++/WinRT consumers can use it. Place managed composite behavior in `Glassline.WinUI.Controls`, which is C# first-class in v1.

## Consequences

- Changes that contradict this decision require a superseding ADR.
- Implementation and review checklists should cite this ADR when the rule is relevant.

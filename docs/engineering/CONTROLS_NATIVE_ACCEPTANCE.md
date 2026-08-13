# Controls native acceptance ledger

Status: **engineering baseline created; native interactive acceptance pending**.

This ledger prevents source compilation from being mistaken for final component Definition of Done.

## Baseline implemented

### GlasslineSearchField

- templated C# `Control`;
- native WinUI `TextBox` is `PART_Input` and remains the text, selection, clipboard, keyboard, and IME engine;
- dependency properties: `Text`, `PlaceholderText`, `IsClearButtonVisible`;
- clear action returns programmatic focus to the native input;
- `AutomationProperties.Name` on the outer control is forwarded to the input at template application time.

### GlasslineSegmentedControl

- templated C# `Control`;
- native WinUI `ListBox` is `PART_Selector` and remains the single-selection/keyboard/automation engine;
- dependency properties: `ItemsSource`, `SelectedIndex`, `SelectedItem`;
- outer automation name is forwarded to the selector at template application time.

## Automated evidence required before merge

- repository structural policy check;
- Theme resource-contract validation;
- Controls source/template-contract validation;
- Windows WinUI XAML/C# compilation on x64 and ARM64;
- Gallery XAML compilation with both controls instantiated through project references;
- NuGet package creation and forbidden-asset scan;
- separate WinUI package-consumer restore/build using only generated `Glassline.WinUI.Controls` NuGet plus its transitive package dependencies, with no Glassline project reference.

The package-consumer lane is intentionally separate from `Glassline.Gallery`: Gallery proves source/project integration, while `tests/Glassline.PackageSmoke` proves the produced NuGet can actually be consumed by a fresh WinUI project.

## Native interactive evidence still required for visual/component DoD

These checks require an interactive Windows 11 desktop and are not represented as complete by a hosted compile runner:

- pointer over / pressed / keyboard focus visual-state inspection;
- Narrator + UI Automation role/name/state/value inspection;
- Korean 2-set, Japanese, and Simplified Chinese IME composition/candidate-window tests for SearchField;
- clipboard/selection/undo/redo smoke tests;
- 100/125/150/200% scale and text-scaling inspection;
- Light/Dark/High Contrast visual capture;
- RTL and long localized-string smoke tests;
- active/inactive window behavior;
- screenshot golden-baseline approval.

Until those entries are recorded, these controls are an engineering baseline and must not be labeled visually complete or release-ready.

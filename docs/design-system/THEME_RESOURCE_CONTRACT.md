# Theme resource contract

Status: **engineering baseline, 2026-08-13**.

`Glassline.WinUI.Theme` now has a buildable semantic resource dictionary at `Themes/GlasslineTheme.xaml`.

## Contract

- Public resource keys express semantic roles, not Apple/macOS names or raw optical constants.
- Light, Dark, and High Contrast are explicit theme dictionaries.
- The first foundation maps Glassline semantic roles to native WinUI theme resources instead of freezing copied RGB values.
- `Segoe UI Variable Text` is the package typography baseline; no Apple font file is embedded or referenced.
- Theme contains no Acrylic/Composition/refraction implementation. Runtime functional glass remains a Controls/Effects responsibility under ADR-0010.
- Metrics in this file are Glassline implementation decisions and remain preview-level until measurement-ledger evidence and visual review lock them.

## Required semantic keys

- `Glassline.Text.Primary`
- `Glassline.Text.Secondary`
- `Glassline.Text.Tertiary`
- `Glassline.Surface.Window`
- `Glassline.Surface.Group`
- `Glassline.Surface.Sidebar`
- `Glassline.Surface.Toolbar`
- `Glassline.Surface.Popover`
- `Glassline.Separator.Subtle`
- `Glassline.Selection.Active`
- `Glassline.Selection.Inactive`
- `Glassline.Accent`
- `Glassline.Focus`
- `Glassline.Destructive`

`eng/scripts/validate-theme.ps1` enforces presence of these keys in Light, Dark, and High Contrast and rejects raw color literals or optical-effect implementation in the Theme package.

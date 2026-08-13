# Validation Strategy

## Purpose

Glassline validation separates **hosted engineering evidence** from **native interactive evidence**. A green build is useful, but it is not a screenshot, Narrator, IME, DPI, RDP, or performance result.

The authoritative environment/evidence boundary is [`ENVIRONMENT_BOUNDARY.md`](ENVIRONMENT_BOUNDARY.md).

## Hosted validation implemented as of 2026-08-13

### Repository/static contracts

Windows CI validates:

- required repository/project structure and dependency boundaries;
- forbidden public/private research artifact patterns;
- Theme resource-dictionary structure and required semantic roles;
- Controls native-composition/template-part contracts;
- composite wrapper AutomationPeer identity and prohibition on duplicate native provider patterns;
- window-backdrop use of native WinUI `SystemBackdrop` plus mandatory High Contrast/transparency Solid policy;
- material roles/quality signals/grouping contract and prohibition on per-child/custom-refraction pipelines in the baseline;
- Gallery deterministic scene IDs, AutomationIds, activation/resize propagation, diagnostics, and benchmark construction contracts;
- public corpus row count/provenance/external-only/no-guessed-measurement rules.

### Executable deterministic smoke tests

Hosted Windows CI executes:

- MaterialQualityManager policy cases: normal, explicit Reduced/Solid, High Contrast, effects-disabled, RDP, resize, inactive;
- Gallery scene selection/precedence/fallback cases;
- exact deterministic benchmark data cases: Settings 100, Grid 500, Tree 5000 non-root nodes.

These are pure/logic evidence; they do not render or interact with a desktop.

### WinUI build matrix

- x64 restore + Release build on Windows runner;
- ARM64 restore + Release build on Windows runner;
- WinUI XAML compilation includes Gallery and control templates;
- warnings are treated as errors.

### NuGet/package-consumer validation

- Theme, Controls, and Effects packages are packed;
- .NET package validation is enabled;
- actual generated nuspec metadata and dependency boundaries are inspected;
- forbidden font/design-asset extensions are scanned after package expansion;
- a separate WinUI consumer restores the generated local `Glassline.WinUI.Controls` package with no Glassline ProjectReference and compiles it;
- SPDX 2.2 SBOM is generated and validated for the package artifact set.

Cross-version package/API compatibility is not yet a truthful lane because Glassline has no published prior package baseline. The first real preview release should establish the baseline used by later compatibility checks.

### macOS research-probe validation

A dedicated macOS 26 workflow:

- reports the hosted macOS/Xcode/Swift toolchain;
- runs AppleReferenceLab scene-catalog and deterministic selection tests;
- builds the native SwiftUI/AppKit probe in Release configuration.

This proves the probe is buildable. It does not create approved reference captures or measurements.

## Native Windows acceptance matrix

The following require an interactive Windows environment.

### Visual / material

- Light / Dark / High Contrast;
- active / inactive;
- Full / Reduced / Solid;
- transparency effects live on/off;
- window foundation, Sidebar, Toolbar, controls, transient surfaces;
- screenshot golden capture and perceptual/geometry review.

### Accessibility / UIA

- Narrator role/name/value/state;
- UI Automation tree shape;
- wrapper Group peer behavior without duplicate announcements;
- native TextBox edit/text/value patterns through SearchField;
- native ListBox selection patterns through SegmentedControl;
- keyboard-only navigation and visible focus.

### Text / IME / localization

- Korean IME composition/candidate flow;
- Japanese IME composition/candidate flow;
- Simplified Chinese IME composition/candidate flow;
- clipboard, selection, undo/redo;
- long localized strings;
- RTL;
- agreed text-scale matrix.

### DPI / window / input

- 100%, 125%, 150%, 200% display scale;
- mixed-DPI multi-monitor movement;
- Snap layouts;
- maximize/restore;
- system menu;
- continuous resize;
- Alt+F4;
- mouse hover/press;
- precision touchpad;
- touch where hardware is available;
- local/RDP transitions.

### Performance

Deterministic workloads:

- Settings 100 rows;
- productivity Grid 500 items;
- Tree 5000 non-root nodes;
- rapid menu/popover open-close scenario;
- continuous resize for at least 10 seconds.

Record, where available:

- frame-time P50/P95/P99;
- process memory delta;
- GPU utilization/memory signals;
- active material-region count;
- approximate total material-region area;
- effective material mode;
- reference CPU/GPU/RAM/display scale/Windows build/driver.

Do not lock a numerical performance budget from GitHub-hosted runner timing.

## Native macOS acceptance matrix

Run AppleReferenceLab interactively and capture applicable scenes in:

- Light / Dark;
- Active / Inactive;
- Normal / Hover / Pressed / Focused / Disabled / Selected;
- control-size variants;
- accent variants;
- Reduce Transparency / Increase Contrast / Reduce Motion states;
- resize/scroll variants;
- menu/popover transitions.

Observed values enter `research/measurements/measurement-ledger.csv` only after the scene itself is inspected and the value is classified as Observed, Inferred, or Glassline decision.

## Release evidence gate

Before preview/release readiness is claimed, at minimum:

- hosted CI remains green;
- native Windows visual/UIA/IME/DPI/window/input matrices have recorded evidence;
- reference-hardware performance evidence exists;
- required AppleReferenceLab/measurement evidence exists for the shipped visual decisions;
- packages contain no forbidden assets;
- SBOM/license/package metadata are valid;
- public API review is complete;
- once a prior public package exists, cross-version API compatibility is green against that real baseline.

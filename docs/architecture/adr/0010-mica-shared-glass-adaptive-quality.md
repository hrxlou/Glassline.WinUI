# ADR-0010: Mica foundation, shared glass regions, and adaptive material quality

- Status: **Accepted**
- Date: 2026-08-13

## Context

ADR-0004 separates functional glass from normal content surfaces and ADR-0009 makes advanced refraction optional. The implementation still needs a concrete rule for how Windows Mica, Composition-backed glass, grouping, and performance fallback fit together.

The source blueprint already requires `grouping / shared sampling region`, `Auto → Full/Reduced/Solid`, and optional advanced refraction. The current design discussion further clarified that per-control backdrop pipelines would create unnecessary GPU/compositor cost and that the window foundation should continue to use Windows-native material behavior.

## Decision

1. **Foundation first.** Use a Windows system Mica backdrop as the preferred window foundation when supported and appropriate. When system policy, accessibility, or platform conditions prevent it, use the semantic solid fallback. Normal groups, lists, tables, and input surfaces do not receive live backdrop effects by default.
2. **Functional glass is additive.** Sidebar, toolbar, popover, floating, and selected interactive material roles are rendered above the foundation according to ADR-0004.
3. **Shared regions are required.** Implement a `GlassContainer`-style region primitive so visually grouped glass children can share backdrop/effect resources instead of each creating an independent live effect chain. The public type name is not frozen before preview.
4. **Semantic public API.** Expose material roles and quality intent rather than raw blur/distortion/tint constants as the primary public contract.
5. **Adaptive quality is mandatory.** `Auto` selects `Full`, `Reduced`, or `Solid` using system/accessibility/environment capability signals. Continuous resize must temporarily reduce expensive effects; inactive/background windows must suppress nonessential continuous material animation.
6. **Refraction remains optional.** Spatial refraction/lensing is experimental and subject to ADR-0009 and the M2 performance gate.

## Consequences

- M1 includes a Mica/solid window foundation before advanced glass work.
- M2 must prototype shared material regions before expanding glass to more controls.
- List/tree/data rows cannot own independent backdrop blur pipelines as a normal styling technique.
- Performance tests must record glass-region count and glass area in addition to frame time/memory metrics.
- Any implementation that requires Full-quality advanced refraction during resize or lacks predictable fallback violates this ADR.

## References

- `docs/architecture/MATERIAL_ARCHITECTURE.md`
- ADR-0004: Functional glass vs content surface separation
- ADR-0009: Advanced refraction is optional
- Microsoft system backdrops: https://learn.microsoft.com/windows/apps/develop/ui/system-backdrops
- Microsoft composition tailoring: https://learn.microsoft.com/windows/uwp/composition/composition-tailoring

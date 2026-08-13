import Foundation

/// System appearance a capture is taken under.
public enum CaptureAppearance: String, CaseIterable, Sendable {
    case light
    case dark
}

/// Whether the probe window owns key focus at capture time.
public enum CaptureWindowState: String, CaseIterable, Sendable {
    case active
    case inactive
}

/// Accessibility setting the capture isolates.
public enum CaptureAccessibilityMode: String, CaseIterable, Sendable {
    case standard = "default"
    case reduceTransparency = "reduce-transparency"
    case increaseContrast = "increase-contrast"
}

/// One required capture. `id` is the vocabulary the measurement ledger cites as `source_id`.
public struct CaptureDescriptor: Equatable, Sendable {
    public let scene: ReferenceScene
    public let appearance: CaptureAppearance
    public let windowState: CaptureWindowState
    public let accessibilityMode: CaptureAccessibilityMode

    public init(
        scene: ReferenceScene,
        appearance: CaptureAppearance,
        windowState: CaptureWindowState,
        accessibilityMode: CaptureAccessibilityMode
    ) {
        self.scene = scene
        self.appearance = appearance
        self.windowState = windowState
        self.accessibilityMode = accessibilityMode
    }

    /// Scene ids contain hyphens, so fields are separated by a double underscore.
    public var id: String {
        [
            scene.rawValue,
            appearance.rawValue,
            windowState.rawValue,
            accessibilityMode.rawValue
        ].joined(separator: "__")
    }
}

/// The deterministic minimum capture set for an interactive macOS reference session.
///
/// A prose capture matrix produces a different set every session and leaves the ledger unable to
/// cite a stable source. This enumerates the required captures instead, and emits the manifest that
/// `eng/scripts/validate-measurement-ledger.ps1` checks ledger rows against.
public enum CaptureMatrix {
    public static let manifestHeader = "capture_id,scene,appearance,window_state,accessibility_mode"

    /// Scenes where the contrast variant teaches something the other variants do not.
    ///
    /// macOS couples Increase Contrast to Reduce Transparency, so the contrast captures repeat a
    /// material fallback already covered by the `reduce-transparency` variant. What they add is the
    /// contrast delta — chiefly added control borders. `buttons` and `text-input` carry that for
    /// filled and field-shaped controls; `sidebar` is the one region whose material visibly changes
    /// in Light. Requiring the variant everywhere else buys repetition, not evidence.
    public static let contrastVariantScenes: Set<ReferenceScene> = [.buttons, .textInput, .sidebar]

    public static func accessibilityModes(for scene: ReferenceScene) -> [CaptureAccessibilityMode] {
        CaptureAccessibilityMode.allCases.filter { mode in
            mode != .increaseContrast || contrastVariantScenes.contains(scene)
        }
    }

    public static func required(for scene: ReferenceScene) -> [CaptureDescriptor] {
        var descriptors: [CaptureDescriptor] = []

        for appearance in CaptureAppearance.allCases {
            for mode in accessibilityModes(for: scene) {
                // Inactive-window evidence is required once per appearance. The accessibility
                // variants isolate material and contrast response, which activation does not change.
                let windowStates: [CaptureWindowState] = mode == .standard
                    ? CaptureWindowState.allCases
                    : [.active]

                for windowState in windowStates {
                    descriptors.append(
                        CaptureDescriptor(
                            scene: scene,
                            appearance: appearance,
                            windowState: windowState,
                            accessibilityMode: mode
                        )
                    )
                }
            }
        }

        return descriptors
    }

    public static var all: [CaptureDescriptor] {
        ReferenceScene.allCases.flatMap(required(for:))
    }

    /// Resolves the accessibility variant a live environment corresponds to.
    ///
    /// macOS 26.5.2 couples the two settings: enabling Increase Contrast also enables Reduce
    /// Transparency and disables its switch. An isolated contrast variant therefore does not exist
    /// to be captured, and requiring one made the variant unreachable for the whole 2026-08-14
    /// session. `increaseContrast` accordingly wins over the coupled transparency setting instead of
    /// resolving to a state no capture id describes.
    public static func accessibilityMode(
        reduceTransparency: Bool,
        increaseContrast: Bool
    ) -> CaptureAccessibilityMode {
        if increaseContrast {
            return .increaseContrast
        }

        if reduceTransparency {
            return .reduceTransparency
        }

        return .standard
    }

    /// The capture this live environment would satisfy, or `nil` if it satisfies none.
    public static func descriptor(
        scene: ReferenceScene,
        appearance: CaptureAppearance,
        windowState: CaptureWindowState,
        reduceTransparency: Bool,
        increaseContrast: Bool
    ) -> CaptureDescriptor? {
        let mode = accessibilityMode(
            reduceTransparency: reduceTransparency,
            increaseContrast: increaseContrast
        )

        // Accessibility variants are only required for the active window.
        if mode != .standard, windowState != .active {
            return nil
        }

        // The contrast variant is scene-limited, so a contrast environment on any other scene is a
        // capture nobody asked for. Saying so is the point: the operator sees NONE and moves on
        // rather than producing a file whose id is not in the manifest.
        guard accessibilityModes(for: scene).contains(mode) else {
            return nil
        }

        return CaptureDescriptor(
            scene: scene,
            appearance: appearance,
            windowState: windowState,
            accessibilityMode: mode
        )
    }

    /// Reference captures are taken at 2x. At 1x a 6 pt radius is 6 px, so antialiasing alone puts
    /// edge determination outside any useful tolerance, and macOS renders hairlines and materials
    /// differently at 1x than at the scale the design is consumed at.
    public static let requiredBackingScale: Double = 2

    public static func isUsableForGeometry(backingScale: Double) -> Bool {
        backingScale >= requiredBackingScale
    }

    public static var manifestCSV: String {
        let rows = all.map { descriptor in
            [
                descriptor.id,
                descriptor.scene.rawValue,
                descriptor.appearance.rawValue,
                descriptor.windowState.rawValue,
                descriptor.accessibilityMode.rawValue
            ].joined(separator: ",")
        }

        return ([manifestHeader] + rows).joined(separator: "\n") + "\n"
    }
}

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

    public static func required(for scene: ReferenceScene) -> [CaptureDescriptor] {
        var descriptors: [CaptureDescriptor] = []

        for appearance in CaptureAppearance.allCases {
            for mode in CaptureAccessibilityMode.allCases {
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
    /// Returns `nil` when the environment is not one of the required variants, so the probe can say
    /// so on screen instead of letting an operator name a capture after a mode it was not taken in.
    public static func accessibilityMode(
        reduceTransparency: Bool,
        increaseContrast: Bool
    ) -> CaptureAccessibilityMode? {
        switch (reduceTransparency, increaseContrast) {
        case (false, false):
            return .standard
        case (true, false):
            return .reduceTransparency
        case (false, true):
            return .increaseContrast
        case (true, true):
            // Both settings on is a real macOS state, but it is not one of the isolated variants
            // the matrix requires, so no capture id describes it.
            return nil
        }
    }

    /// The capture this live environment would satisfy, or `nil` if it satisfies none.
    public static func descriptor(
        scene: ReferenceScene,
        appearance: CaptureAppearance,
        windowState: CaptureWindowState,
        reduceTransparency: Bool,
        increaseContrast: Bool
    ) -> CaptureDescriptor? {
        guard let mode = accessibilityMode(
            reduceTransparency: reduceTransparency,
            increaseContrast: increaseContrast
        ) else {
            return nil
        }

        // Accessibility variants are only required for the active window.
        if mode != .standard, windowState != .active {
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

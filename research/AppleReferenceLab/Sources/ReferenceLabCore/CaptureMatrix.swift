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

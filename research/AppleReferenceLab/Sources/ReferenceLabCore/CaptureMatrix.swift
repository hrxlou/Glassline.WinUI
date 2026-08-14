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

/// Interaction state of the scene's designated state probe.
///
/// Unlike appearance or window state, this is a property of one control rather than the window, so
/// the probe reports its own hover/focus/press rather than inferring anything from the environment.
/// An operator-asserted interaction state would defeat the header check entirely.
public enum CaptureInteraction: String, CaseIterable, Sendable {
    case normal
    case hover
    case pressed
    case focused
}

/// One required capture. `id` is the vocabulary the measurement ledger cites as `source_id`.
public struct CaptureDescriptor: Equatable, Sendable {
    public let scene: ReferenceScene
    public let appearance: CaptureAppearance
    public let windowState: CaptureWindowState
    public let accessibilityMode: CaptureAccessibilityMode
    public let interaction: CaptureInteraction

    public init(
        scene: ReferenceScene,
        appearance: CaptureAppearance,
        windowState: CaptureWindowState,
        accessibilityMode: CaptureAccessibilityMode,
        interaction: CaptureInteraction = .normal
    ) {
        self.scene = scene
        self.appearance = appearance
        self.windowState = windowState
        self.accessibilityMode = accessibilityMode
        self.interaction = interaction
    }

    /// Scene ids contain hyphens, so fields are separated by a double underscore.
    ///
    /// `normal` appends nothing, which keeps every id minted before the interaction axis existed
    /// unchanged — captures already taken stay valid and stay citable by the ledger.
    public var id: String {
        var fields = [
            scene.rawValue,
            appearance.rawValue,
            windowState.rawValue,
            accessibilityMode.rawValue
        ]

        if interaction != .normal {
            fields.append(interaction.rawValue)
        }

        return fields.joined(separator: "__")
    }
}

/// The deterministic minimum capture set for an interactive macOS reference session.
///
/// A prose capture matrix produces a different set every session and leaves the ledger unable to
/// cite a stable source. This enumerates the required captures instead, and emits the manifest that
/// `eng/scripts/validate-measurement-ledger.ps1` checks ledger rows against.
public enum CaptureMatrix {
    public static let manifestHeader = "capture_id,scene,appearance,window_state,accessibility_mode,interaction"

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

    /// Scenes whose designated state probe is worth capturing in each interaction state.
    ///
    /// Hover, press, and focus are one visual grammar repeated across controls, so capturing it
    /// everywhere buys repetition. These four cover the distinct shapes it takes: a filled control,
    /// a track-and-knob control, a text field's focus ring, and a segmented selection.
    public static let interactionScenes: Set<ReferenceScene> = [
        .buttons, .toggleSlider, .textInput, .pickers,
    ]

    /// Hover, press, and focus all require the window to be key, and isolating the interaction means
    /// not also changing the accessibility mode.
    public static func interactions(for scene: ReferenceScene) -> [CaptureInteraction] {
        interactionScenes.contains(scene) ? CaptureInteraction.allCases : [.normal]
    }

    public static func required(for scene: ReferenceScene) -> [CaptureDescriptor] {
        var descriptors: [CaptureDescriptor] = []

        for appearance in CaptureAppearance.allCases {
            for interaction in interactions(for: scene) where interaction != .normal {
                descriptors.append(
                    CaptureDescriptor(
                        scene: scene,
                        appearance: appearance,
                        windowState: .active,
                        accessibilityMode: .standard,
                        interaction: interaction
                    )
                )
            }

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
        increaseContrast: Bool,
        interaction: CaptureInteraction = .normal
    ) -> CaptureDescriptor? {
        let mode = accessibilityMode(
            reduceTransparency: reduceTransparency,
            increaseContrast: increaseContrast
        )

        if interaction != .normal {
            // An interaction variant isolates the control state, so everything else must be the
            // baseline: key window, standard accessibility, and a scene that requires the axis.
            guard interactions(for: scene).contains(interaction),
                  windowState == .active,
                  mode == .standard
            else {
                return nil
            }

            return CaptureDescriptor(
                scene: scene,
                appearance: appearance,
                windowState: windowState,
                accessibilityMode: mode,
                interaction: interaction
            )
        }

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
                descriptor.accessibilityMode.rawValue,
                descriptor.interaction.rawValue
            ].joined(separator: ",")
        }

        return ([manifestHeader] + rows).joined(separator: "\n") + "\n"
    }
}

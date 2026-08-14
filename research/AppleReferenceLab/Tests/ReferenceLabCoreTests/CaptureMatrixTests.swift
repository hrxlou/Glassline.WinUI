import Foundation
import Testing
@testable import ReferenceLabCore

private var packageRoot: URL {
    URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent() // ReferenceLabCoreTests
        .deletingLastPathComponent() // Tests
        .deletingLastPathComponent() // AppleReferenceLab
}

@Test
func captureIdentifiersAreUniqueAndParseable() {
    let descriptors = CaptureMatrix.all
    let ids = descriptors.map(\.id)

    #expect(Set(ids).count == ids.count)

    for descriptor in descriptors {
        let fields = descriptor.id.components(separatedBy: "__")
        // The interaction field is present only when it is not `normal`, which is what keeps ids
        // minted before the interaction axis unchanged.
        #expect(fields.count == (descriptor.interaction == .normal ? 4 : 5))
        #expect(fields[0] == descriptor.scene.rawValue)
        #expect(fields[1] == descriptor.appearance.rawValue)
        #expect(fields[2] == descriptor.windowState.rawValue)
        #expect(fields[3] == descriptor.accessibilityMode.rawValue)
        if descriptor.interaction != .normal {
            #expect(fields[4] == descriptor.interaction.rawValue)
        }
    }
}

@Test
func sceneCaptureShapeFollowsTheContrastVariantRule() {
    for scene in ReferenceScene.allCases {
        let descriptors = CaptureMatrix.required(for: scene)
        let wantsContrast = CaptureMatrix.contrastVariantScenes.contains(scene)
        let wantsInteraction = CaptureMatrix.interactionScenes.contains(scene)

        let expected = (wantsContrast ? 8 : 6) + (wantsInteraction ? 6 : 0)
        #expect(descriptors.count == expected)
        #expect(descriptors.allSatisfy { $0.scene == scene })

        // Inactive-window evidence is only required for the default accessibility mode.
        let inactive = descriptors.filter { $0.windowState == .inactive }
        #expect(inactive.count == 2)
        #expect(inactive.allSatisfy { $0.accessibilityMode == .standard })

        let contrast = descriptors.filter { $0.accessibilityMode == .increaseContrast }
        #expect(contrast.count == (wantsContrast ? 2 : 0))
    }
}

@Test
func contrastVariantIsRequiredOnlyWhereItAddsEvidence() {
    #expect(CaptureMatrix.contrastVariantScenes == [.buttons, .textInput, .sidebar])
    #expect(CaptureMatrix.all.count == 84)
}

@Test
func normalInteractionLeavesCaptureIdsUnchanged() {
    // Captures taken before the interaction axis existed must stay valid and stay citable.
    let descriptor = CaptureDescriptor(
        scene: .buttons,
        appearance: .light,
        windowState: .active,
        accessibilityMode: .standard
    )

    #expect(descriptor.interaction == .normal)
    #expect(descriptor.id == "buttons__light__active__default")
}

@Test
func interactionVariantsAppendExactlyOneField() {
    let descriptor = CaptureDescriptor(
        scene: .pickers,
        appearance: .dark,
        windowState: .active,
        accessibilityMode: .standard,
        interaction: .focused
    )

    #expect(descriptor.id == "pickers__dark__active__default__focused")
}

@Test
func interactionVariantsAreRequiredOnlyOnBaselineEnvironments() {
    let scene = ReferenceScene.buttons
    #expect(CaptureMatrix.interactionScenes.contains(scene))

    // An interaction variant isolates the control state, so nothing else may vary with it.
    #expect(CaptureMatrix.descriptor(
        scene: scene, appearance: .light, windowState: .inactive,
        reduceTransparency: false, increaseContrast: false, interaction: .hover
    ) == nil)

    #expect(CaptureMatrix.descriptor(
        scene: scene, appearance: .light, windowState: .active,
        reduceTransparency: true, increaseContrast: false, interaction: .hover
    ) == nil)

    // And a scene without the axis resolves nothing at all.
    #expect(CaptureMatrix.descriptor(
        scene: .window, appearance: .light, windowState: .active,
        reduceTransparency: false, increaseContrast: false, interaction: .hover
    ) == nil)

    #expect(CaptureMatrix.descriptor(
        scene: scene, appearance: .light, windowState: .active,
        reduceTransparency: false, increaseContrast: false, interaction: .hover
    )?.id == "buttons__light__active__default__hover")
}

@Test
func increaseContrastWinsOverCoupledReduceTransparency() {
    #expect(CaptureMatrix.accessibilityMode(reduceTransparency: false, increaseContrast: false) == .standard)
    #expect(CaptureMatrix.accessibilityMode(reduceTransparency: true, increaseContrast: false) == .reduceTransparency)
    #expect(CaptureMatrix.accessibilityMode(reduceTransparency: false, increaseContrast: true) == .increaseContrast)

    // macOS 26.5.2 forces Reduce Transparency on when Increase Contrast is enabled. That coupled
    // state is what a real user with Increase Contrast sees, so it is the contrast variant rather
    // than an unnameable state.
    #expect(CaptureMatrix.accessibilityMode(reduceTransparency: true, increaseContrast: true) == .increaseContrast)
}

@Test
func resolvedDescriptorsAreAlwaysRequiredCaptures() {
    let required = Set(CaptureMatrix.all.map(\.id))

    for scene in ReferenceScene.allCases {
        for appearance in CaptureAppearance.allCases {
            for windowState in CaptureWindowState.allCases {
                for reduceTransparency in [false, true] {
                    for increaseContrast in [false, true] {
                        let descriptor = CaptureMatrix.descriptor(
                            scene: scene,
                            appearance: appearance,
                            windowState: windowState,
                            reduceTransparency: reduceTransparency,
                            increaseContrast: increaseContrast
                        )

                        guard let descriptor else { continue }

                        #expect(required.contains(descriptor.id))
                    }
                }
            }
        }
    }
}

@Test
func contrastEnvironmentResolvesNothingOnScenesThatDoNotRequireIt() {
    let scene = ReferenceScene.toolbar
    #expect(CaptureMatrix.contrastVariantScenes.contains(scene) == false)

    let descriptor = CaptureMatrix.descriptor(
        scene: scene,
        appearance: .light,
        windowState: .active,
        reduceTransparency: true,
        increaseContrast: true
    )

    #expect(descriptor == nil)
}

@Test
func inactiveWindowResolvesNoAccessibilityVariant() {
    let descriptor = CaptureMatrix.descriptor(
        scene: .buttons,
        appearance: .dark,
        windowState: .inactive,
        reduceTransparency: true,
        increaseContrast: false
    )

    #expect(descriptor == nil)
}

@Test
func belowRetinaScaleIsNotUsableForGeometry() {
    #expect(CaptureMatrix.isUsableForGeometry(backingScale: 1) == false)
    #expect(CaptureMatrix.isUsableForGeometry(backingScale: 1.5) == false)
    #expect(CaptureMatrix.isUsableForGeometry(backingScale: 2))
    #expect(CaptureMatrix.isUsableForGeometry(backingScale: 3))
}

@Test
func committedManifestMatchesTheGenerator() throws {
    let manifestURL = packageRoot.appendingPathComponent("capture-manifest.csv")
    let committed = try String(contentsOf: manifestURL, encoding: .utf8)

    // The Windows ledger validator reads this file, so it must not drift from the generator.
    #expect(committed.replacingOccurrences(of: "\r\n", with: "\n") == CaptureMatrix.manifestCSV)
}

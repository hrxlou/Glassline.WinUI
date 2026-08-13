import Testing
@testable import ReferenceLabCore

@Test
func catalogContainsAllRequiredProbeScenes() {
    let ids = Set(ReferenceScene.allCases.map(\.rawValue))
    let required: Set<String> = [
        "buttons",
        "toggle-slider",
        "text-input",
        "pickers",
        "sidebar",
        "toolbar",
        "menu-popover",
        "window",
        "accessibility-states"
    ]

    #expect(ids == required)
}

@Test
func argumentSelectionPrecedesEnvironment() {
    let result = ReferenceSceneSelection.resolve(
        arguments: ["AppleReferenceLab", "--scene=toolbar"],
        environmentValue: "buttons"
    )

    #expect(result == .toolbar)
}

@Test
func environmentSelectionIsSupported() {
    let result = ReferenceSceneSelection.resolve(
        arguments: ["AppleReferenceLab"],
        environmentValue: "menu-popover"
    )

    #expect(result == .menuPopover)
}

@Test
func unknownSelectionFallsBackToButtons() {
    let result = ReferenceSceneSelection.resolve(
        arguments: ["AppleReferenceLab", "--scene=unknown"],
        environmentValue: nil
    )

    #expect(result == .buttons)
}

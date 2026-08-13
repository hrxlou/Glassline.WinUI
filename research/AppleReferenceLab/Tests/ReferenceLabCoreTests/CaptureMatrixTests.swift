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
        #expect(fields.count == 4)
        #expect(fields[0] == descriptor.scene.rawValue)
        #expect(fields[1] == descriptor.appearance.rawValue)
        #expect(fields[2] == descriptor.windowState.rawValue)
        #expect(fields[3] == descriptor.accessibilityMode.rawValue)
    }
}

@Test
func everySceneRequiresTheSameCaptureShape() {
    for scene in ReferenceScene.allCases {
        let descriptors = CaptureMatrix.required(for: scene)

        #expect(descriptors.count == 8)
        #expect(descriptors.allSatisfy { $0.scene == scene })

        // Inactive-window evidence is only required for the default accessibility mode.
        let inactive = descriptors.filter { $0.windowState == .inactive }
        #expect(inactive.count == 2)
        #expect(inactive.allSatisfy { $0.accessibilityMode == .standard })
    }
}

@Test
func committedManifestMatchesTheGenerator() throws {
    let manifestURL = packageRoot.appendingPathComponent("capture-manifest.csv")
    let committed = try String(contentsOf: manifestURL, encoding: .utf8)

    // The Windows ledger validator reads this file, so it must not drift from the generator.
    #expect(committed.replacingOccurrences(of: "\r\n", with: "\n") == CaptureMatrix.manifestCSV)
}

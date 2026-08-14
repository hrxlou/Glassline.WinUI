import AppKit
import ReferenceLabCore
import SwiftUI

@main
@MainActor
struct AppleReferenceLabApp: App {
    @State private var selectedScene: ReferenceScene
    @StateObject private var interaction = InteractionReporter()

    init() {
        let initial = ReferenceSceneSelection.resolve(
            arguments: ProcessInfo.processInfo.arguments,
            environmentValue: ProcessInfo.processInfo.environment[ReferenceSceneSelection.environmentVariable]
        )
        _selectedScene = State(initialValue: initial)
    }

    var body: some Scene {
        WindowGroup("AppleReferenceLab") {
            ReferenceLabRootView(selectedScene: $selectedScene)
                .frame(minWidth: 920, minHeight: 640)
                .environmentObject(interaction)
        }
        .defaultSize(width: 1040, height: 760)
    }
}

/// Live interaction state of the scene's designated state probe.
///
/// The header must not print a state the operator merely intends. Appearance, window state, and
/// accessibility mode come from the environment; hover, press, and focus belong to one control, so
/// that control reports them itself and the header stays self-proving.
@MainActor
final class InteractionReporter: ObservableObject {
    @Published var hovering = false
    @Published var pressing = false
    @Published var focused = false

    var current: CaptureInteraction {
        if pressing { return .pressed }
        if focused { return .focused }
        if hovering { return .hover }
        return .normal
    }
}

private struct StateProbe: ViewModifier {
    @EnvironmentObject private var reporter: InteractionReporter
    @FocusState private var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onHover { reporter.hovering = $0 }
            .onChange(of: isFocused) { _, focused in reporter.focused = focused }
            // A press is only observable while the button is held, so the capture must fire during
            // the hold. minimumDistance 0 reports the press without waiting for a drag.
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in reporter.pressing = true }
                    .onEnded { _ in reporter.pressing = false }
            )
            .accessibilityIdentifier("ReferenceStateProbe")
    }
}

private extension View {
    func stateProbe() -> some View {
        modifier(StateProbe())
    }
}

@MainActor
private struct ReferenceLabRootView: View {
    @Binding var selectedScene: ReferenceScene

    var body: some View {
        NavigationSplitView {
            List(ReferenceScene.allCases, selection: $selectedScene) { scene in
                Text(scene.title)
                    .tag(scene)
                    .accessibilityIdentifier("ReferenceScene.\(scene.rawValue)")
            }
            .navigationTitle("Reference Scenes")
        } detail: {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ReferenceHeader(scene: selectedScene)
                    sceneView(selectedScene)
                }
                .padding(28)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle(selectedScene.title)
        }
    }

    @ViewBuilder
    private func sceneView(_ scene: ReferenceScene) -> some View {
        switch scene {
        case .buttons:
            ButtonsProbeScene()
        case .toggleSlider:
            ToggleSliderProbeScene()
        case .textInput:
            TextInputProbeScene()
        case .pickers:
            PickersProbeScene()
        case .sidebar:
            SidebarProbeScene()
        case .toolbar:
            ToolbarProbeScene()
        case .menuPopover:
            MenuPopoverProbeScene()
        case .window:
            WindowProbeScene()
        case .accessibilityStates:
            AccessibilityProbeScene()
        }
    }
}

/// Header rendered into every scene so a capture proves its own context.
///
/// A capture that does not state the appearance, window state, accessibility mode, and scale it was
/// taken under cannot be classified `Observed` later; the operator's intent is not evidence. The
/// resolved `capture_id` is printed so the file can be named by reading it off the capture itself.
@MainActor
private struct ReferenceHeader: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.controlActiveState) private var controlActiveState
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @EnvironmentObject private var reporter: InteractionReporter

    let scene: ReferenceScene

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(scene.title)
                .font(.title2)

            Text(verbatim: "capture_id=\(captureIdDescription)")
                .font(.caption.monospaced().bold())
                .textSelection(.enabled)
                .accessibilityIdentifier("ReferenceCaptureId")

            Text(verbatim: "appearance=\(appearance.rawValue) | window=\(windowState.rawValue) | interaction=\(reporter.current.rawValue) | contrast=\(colorSchemeContrast == .increased ? "increased" : "standard") | reduceTransparency=\(reduceTransparency) | reduceMotion=\(reduceMotion) | differentiateWithoutColor=\(differentiateWithoutColor)")
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
                .textSelection(.enabled)

            Text(verbatim: "backing_scale=\(backingScaleDescription) os=\(ProcessInfo.processInfo.operatingSystemVersionString)")
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
                .textSelection(.enabled)

            if let warning = scaleWarning {
                Text(warning)
                    .font(.caption.monospaced().bold())
                    .foregroundStyle(.red)
                    .textSelection(.enabled)
                    .accessibilityIdentifier("ReferenceScaleWarning")
            }

            CalibrationRule()
        }
    }

    private var appearance: CaptureAppearance {
        colorScheme == .dark ? .dark : .light
    }

    private var windowState: CaptureWindowState {
        // A screenshot tool that takes focus makes every capture inactive, which is why this is read
        // from the live environment rather than assumed.
        controlActiveState == .inactive ? .inactive : .active
    }

    private var captureIdDescription: String {
        guard let descriptor = CaptureMatrix.descriptor(
            scene: scene,
            appearance: appearance,
            windowState: windowState,
            reduceTransparency: reduceTransparency,
            increaseContrast: colorSchemeContrast == .increased,
            interaction: reporter.current
        ) else {
            return "NONE — this environment matches no required capture; do not name a file from it"
        }

        return descriptor.id
    }

    private var backingScale: Double? {
        NSScreen.main.map { Double($0.backingScaleFactor) }
    }

    private var backingScaleDescription: String {
        guard let backingScale else {
            return "unknown"
        }

        return String(format: "%.2f", backingScale)
    }

    private var scaleWarning: String? {
        guard let backingScale else {
            return "WARNING: backing scale unknown; geometry measured from this capture is not Observed"
        }

        guard CaptureMatrix.isUsableForGeometry(backingScale: backingScale) else {
            return String(
                format: "WARNING: backing_scale=%.2f is below the required %.0fx; this capture cannot support geometry rows",
                backingScale,
                CaptureMatrix.requiredBackingScale
            )
        }

        return nil
    }
}

/// A known-size rule rendered into every scene.
///
/// Screenshot pixels only become point measurements if the capture records its own scale. Without
/// this, a ledger row measured from a capture cannot be classified as Observed, because the
/// pixel-to-point conversion would itself be an assumption.
private struct CalibrationRule: View {
    private let stepPoints: CGFloat = 10
    private let stepCount = 20

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(spacing: 0) {
                ForEach(0..<stepCount, id: \.self) { index in
                    Rectangle()
                        .fill(index.isMultiple(of: 2) ? Color.primary : Color.clear)
                        .frame(width: stepPoints, height: 12)
                }
            }
            .border(Color.primary)

            Text(verbatim: "calibration_rule=\(stepCount)x\(Int(stepPoints))pt total=\(Int(CGFloat(stepCount) * stepPoints))pt")
                .font(.caption2.monospaced())
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
        .accessibilityIdentifier("ReferenceCalibrationRule")
    }
}

private struct ProbeSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ButtonsProbeScene: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ProbeSection("SwiftUI") {
                HStack(spacing: 12) {
                    Button("Default") {}
                        .stateProbe()
                    Button("Bordered") {}
                        .buttonStyle(.bordered)
                    Button("Prominent") {}
                        .buttonStyle(.borderedProminent)
                    Button("Disabled") {}
                        .disabled(true)
                }
                ControlSizeRow { Button("Mini") {} }
            }
            ProbeSection("AppKit") {
                AppKitButtonProbe(title: "NSButton")
                    .frame(width: 160, height: 32)
            }
        }
    }
}

private struct ControlSizeRow<Content: View>: View {
    @ViewBuilder let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: 12) {
            content.controlSize(.mini)
            content.controlSize(.small)
            content.controlSize(.regular)
            content.controlSize(.large)
        }
    }
}

private struct ToggleSliderProbeScene: View {
    @State private var enabled = true
    @State private var value = 0.55

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ProbeSection("SwiftUI") {
                Toggle("Enabled", isOn: $enabled)
                    .frame(width: 260, alignment: .leading)
                    .stateProbe()
                Slider(value: $value)
                    .frame(width: 320)
            }
            ProbeSection("AppKit") {
                AppKitSwitchProbe()
                    .frame(width: 180, height: 28)
                AppKitSliderProbe()
                    .frame(width: 320, height: 28)
            }
        }
    }
}

private struct TextInputProbeScene: View {
    @State private var text = "Reference text"
    @State private var password = "password"

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            ProbeSection("SwiftUI") {
                TextField("Placeholder", text: $text)
                    .frame(width: 340)
                    .stateProbe()
                SecureField("Password", text: $password)
                    .frame(width: 340)
                TextField("Disabled", text: .constant("Disabled"))
                    .frame(width: 340)
                    .disabled(true)
            }
            ProbeSection("AppKit") {
                AppKitTextFieldProbe(text: "NSTextField")
                    .frame(width: 340, height: 28)
            }
        }
    }
}

private struct PickersProbeScene: View {
    @State private var selection = 1

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Picker("Menu Picker", selection: $selection) {
                Text("One").tag(0)
                Text("Two").tag(1)
                Text("Three").tag(2)
            }
            .frame(width: 300)
            .stateProbe()

            Picker("Segmented", selection: $selection) {
                Text("One").tag(0)
                Text("Two").tag(1)
                Text("Three").tag(2)
            }
            .pickerStyle(.segmented)
            .frame(width: 360)

            Picker("Radio", selection: $selection) {
                Text("One").tag(0)
                Text("Two").tag(1)
                Text("Three").tag(2)
            }
            .pickerStyle(.radioGroup)
            .frame(width: 300)
        }
    }
}

private struct SidebarProbeScene: View {
    @State private var selection = "Components"

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            List(selection: $selection) {
                Section("Library") {
                    Text("Overview").tag("Overview")
                    Text("Components").tag("Components")
                    Text("Diagnostics").tag("Diagnostics")
                }
            }
            .listStyle(.sidebar)
            .frame(width: 240, height: 360)

            VStack(alignment: .leading, spacing: 8) {
                Text(selection)
                    .font(.title3)
                Text("Sidebar selection probe")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct ToolbarProbeScene: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Toolbar items are attached to this scene's detail view using the native SwiftUI toolbar API.")
                .frame(maxWidth: 520, alignment: .leading)
            Text("Capture both active and inactive window states.")
                .foregroundStyle(.secondary)
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Back") {}
                Button("Forward") {}
                Button("Share") {}
            }
        }
    }
}

private struct MenuPopoverProbeScene: View {
    @State private var showingPopover = false

    var body: some View {
        HStack(spacing: 16) {
            Menu("Menu") {
                Button("First") {}
                Button("Second") {}
                Divider()
                Button("Disabled") {}
                    .disabled(true)
            }

            Button("Show Popover") {
                showingPopover.toggle()
            }
            .popover(isPresented: $showingPopover) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Popover")
                        .font(.headline)
                    Text("Native SwiftUI popover content")
                }
                .padding(18)
            }
        }
    }
}

private struct WindowProbeScene: View {
    var body: some View {
        Form {
            LabeledContent("Window", value: "Primary probe window")
            LabeledContent("Scene ID", value: ReferenceScene.window.rawValue)
            LabeledContent("Capture", value: "Active + inactive; resized variants")
        }
        .formStyle(.grouped)
        .frame(maxWidth: 560)
    }
}

private struct AccessibilityProbeScene: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        Form {
            LabeledContent("Reduce Motion", value: String(reduceMotion))
            LabeledContent("Reduce Transparency", value: String(reduceTransparency))
            LabeledContent("Differentiate Without Color", value: String(differentiateWithoutColor))
            LabeledContent("Color Scheme Contrast", value: String(describing: contrast))
        }
        .formStyle(.grouped)
        .frame(maxWidth: 560)
    }
}

private struct AppKitButtonProbe: NSViewRepresentable {
    let title: String

    func makeNSView(context: Context) -> NSButton {
        NSButton(title: title, target: nil, action: nil)
    }

    func updateNSView(_ nsView: NSButton, context: Context) {
        nsView.title = title
    }
}

private struct AppKitSwitchProbe: NSViewRepresentable {
    func makeNSView(context: Context) -> NSButton {
        let button = NSButton(checkboxWithTitle: "NSButton switch", target: nil, action: nil)
        button.state = .on
        return button
    }

    func updateNSView(_ nsView: NSButton, context: Context) {}
}

private struct AppKitSliderProbe: NSViewRepresentable {
    func makeNSView(context: Context) -> NSSlider {
        NSSlider(value: 0.55, minValue: 0, maxValue: 1, target: nil, action: nil)
    }

    func updateNSView(_ nsView: NSSlider, context: Context) {}
}

private struct AppKitTextFieldProbe: NSViewRepresentable {
    let text: String

    func makeNSView(context: Context) -> NSTextField {
        NSTextField(string: text)
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
    }
}

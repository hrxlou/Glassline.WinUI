import Foundation

public enum ReferenceScene: String, CaseIterable, Identifiable, Sendable {
    case buttons = "buttons"
    case toggleSlider = "toggle-slider"
    case textInput = "text-input"
    case pickers = "pickers"
    case sidebar = "sidebar"
    case toolbar = "toolbar"
    case menuPopover = "menu-popover"
    case window = "window"
    case accessibilityStates = "accessibility-states"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .buttons: "Buttons"
        case .toggleSlider: "Toggle / Slider"
        case .textInput: "Text Input"
        case .pickers: "Pickers"
        case .sidebar: "Sidebar"
        case .toolbar: "Toolbar"
        case .menuPopover: "Menu / Popover"
        case .window: "Window"
        case .accessibilityStates: "Accessibility States"
        }
    }
}

public enum ReferenceSceneSelection {
    public static let environmentVariable = "GLASSLINE_REFERENCE_SCENE"

    public static func resolve(arguments: [String], environmentValue: String?) -> ReferenceScene {
        for argument in arguments {
            let prefix = "--scene="
            if argument.hasPrefix(prefix) {
                let value = String(argument.dropFirst(prefix.count))
                if let scene = ReferenceScene(rawValue: value.lowercased()) {
                    return scene
                }
            }
        }

        if let environmentValue,
           let scene = ReferenceScene(rawValue: environmentValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()) {
            return scene
        }

        return .buttons
    }
}

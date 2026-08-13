namespace Glassline.WinUI.Controls;

public enum GlasslineMaterialRole
{
    Sidebar,
    Toolbar,
    Popover,
    Interactive,
    Prominent,
}

public enum GlasslineMaterialQuality
{
    Auto,
    Full,
    Reduced,
    Solid,
}

public enum GlasslineMaterialMode
{
    Full,
    Reduced,
    Solid,
}

public readonly record struct GlasslineMaterialEnvironmentState(
    bool HighContrast,
    bool AdvancedEffectsEnabled,
    bool IsRemoteSession,
    bool IsWindowActive,
    bool IsResizing);

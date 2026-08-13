using Glassline.WinUI.Controls;

static void AssertMode(
    string name,
    GlasslineMaterialQuality requested,
    GlasslineMaterialEnvironmentState environment,
    GlasslineMaterialMode expected)
{
    GlasslineMaterialMode actual = GlasslineMaterialQualityManager.Resolve(requested, environment);
    if (actual != expected)
    {
        throw new InvalidOperationException($"{name}: expected {expected}, got {actual}.");
    }
}

GlasslineMaterialEnvironmentState normal = new(
    HighContrast: false,
    AdvancedEffectsEnabled: true,
    IsRemoteSession: false,
    IsWindowActive: true,
    IsResizing: false);

AssertMode("auto-normal", GlasslineMaterialQuality.Auto, normal, GlasslineMaterialMode.Full);
AssertMode("explicit-reduced", GlasslineMaterialQuality.Reduced, normal, GlasslineMaterialMode.Reduced);
AssertMode("explicit-solid", GlasslineMaterialQuality.Solid, normal, GlasslineMaterialMode.Solid);
AssertMode("high-contrast", GlasslineMaterialQuality.Full, normal with { HighContrast = true }, GlasslineMaterialMode.Solid);
AssertMode("effects-disabled", GlasslineMaterialQuality.Auto, normal with { AdvancedEffectsEnabled = false }, GlasslineMaterialMode.Solid);
AssertMode("rdp", GlasslineMaterialQuality.Full, normal with { IsRemoteSession = true }, GlasslineMaterialMode.Reduced);
AssertMode("resize", GlasslineMaterialQuality.Full, normal with { IsResizing = true }, GlasslineMaterialMode.Reduced);
AssertMode("inactive", GlasslineMaterialQuality.Full, normal with { IsWindowActive = false }, GlasslineMaterialMode.Reduced);

Console.WriteLine("Material policy smoke passed.");

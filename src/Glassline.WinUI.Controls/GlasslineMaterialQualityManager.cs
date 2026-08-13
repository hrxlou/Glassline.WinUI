namespace Glassline.WinUI.Controls;

/// <summary>
/// Resolves requested material quality against mandatory accessibility and environment downgrades.
/// The resolver is deterministic so its policy can be exercised without a rendered desktop.
/// </summary>
public static class GlasslineMaterialQualityManager
{
    public static GlasslineMaterialMode Resolve(
        GlasslineMaterialQuality requestedQuality,
        GlasslineMaterialEnvironmentState environment)
    {
        if (requestedQuality == GlasslineMaterialQuality.Solid)
        {
            return GlasslineMaterialMode.Solid;
        }

        if (environment.HighContrast || !environment.AdvancedEffectsEnabled)
        {
            return GlasslineMaterialMode.Solid;
        }

        if (environment.IsRemoteSession || environment.IsResizing || !environment.IsWindowActive)
        {
            return GlasslineMaterialMode.Reduced;
        }

        if (requestedQuality == GlasslineMaterialQuality.Reduced)
        {
            return GlasslineMaterialMode.Reduced;
        }

        return GlasslineMaterialMode.Full;
    }
}

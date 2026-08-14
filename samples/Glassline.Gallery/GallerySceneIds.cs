namespace Glassline.Gallery;

public static class GallerySceneIds
{
    public const string All = "all";
    public const string WindowFoundation = "window-foundation";
    public const string MaterialRegions = "material-regions";
    public const string ControlsMatrix = "controls-matrix";
    public const string TitleBarBand = "titlebar-band";
    public const string BenchmarkSettings = "benchmark-settings";
    public const string BenchmarkGrid = "benchmark-grid";
    public const string BenchmarkTree = "benchmark-tree";

    public static string ResolveRequestedScene(IEnumerable<string> args, string? environmentValue)
    {
        foreach (string arg in args)
        {
            const string prefix = "--scene=";
            if (arg.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
            {
                return Normalize(arg[prefix.Length..]);
            }
        }

        return Normalize(environmentValue);
    }

    public static bool IsBenchmarkScene(string sceneId) =>
        sceneId is BenchmarkSettings or BenchmarkGrid or BenchmarkTree;

    public static bool IsSceneVisible(string requestedScene, string sceneId) =>
        string.Equals(requestedScene, sceneId, StringComparison.OrdinalIgnoreCase) ||
        (requestedScene == All && !IsBenchmarkScene(sceneId));

    public static string Normalize(string? value)
    {
        string candidate = value?.Trim().ToLowerInvariant() ?? All;
        return candidate switch
        {
            WindowFoundation => WindowFoundation,
            MaterialRegions => MaterialRegions,
            ControlsMatrix => ControlsMatrix,
            TitleBarBand => TitleBarBand,
            BenchmarkSettings => BenchmarkSettings,
            BenchmarkGrid => BenchmarkGrid,
            BenchmarkTree => BenchmarkTree,
            All => All,
            _ => All,
        };
    }
}

namespace Glassline.Gallery;

public static class GallerySceneIds
{
    public const string All = "all";
    public const string WindowFoundation = "window-foundation";
    public const string MaterialRegions = "material-regions";
    public const string ControlsMatrix = "controls-matrix";

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

    public static bool IsSceneVisible(string requestedScene, string sceneId) =>
        requestedScene == All || string.Equals(requestedScene, sceneId, StringComparison.OrdinalIgnoreCase);

    public static string Normalize(string? value)
    {
        string candidate = value?.Trim().ToLowerInvariant() ?? All;
        return candidate switch
        {
            WindowFoundation => WindowFoundation,
            MaterialRegions => MaterialRegions,
            ControlsMatrix => ControlsMatrix,
            All => All,
            _ => All,
        };
    }
}

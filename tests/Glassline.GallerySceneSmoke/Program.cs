using Glassline.Gallery;

static void AssertEqual(string name, string actual, string expected)
{
    if (!string.Equals(actual, expected, StringComparison.Ordinal))
    {
        throw new InvalidOperationException($"{name}: expected '{expected}', got '{actual}'.");
    }
}

AssertEqual("default", GallerySceneIds.ResolveRequestedScene([], null), GallerySceneIds.All);
AssertEqual("environment", GallerySceneIds.ResolveRequestedScene([], "material-regions"), GallerySceneIds.MaterialRegions);
AssertEqual("argument-precedence", GallerySceneIds.ResolveRequestedScene(["--scene=controls-matrix"], "material-regions"), GallerySceneIds.ControlsMatrix);
AssertEqual("benchmark-settings-selection", GallerySceneIds.ResolveRequestedScene(["--scene=benchmark-settings"], null), GallerySceneIds.BenchmarkSettings);
AssertEqual("benchmark-grid-selection", GallerySceneIds.ResolveRequestedScene(["--scene=benchmark-grid"], null), GallerySceneIds.BenchmarkGrid);
AssertEqual("benchmark-tree-selection", GallerySceneIds.ResolveRequestedScene(["--scene=benchmark-tree"], null), GallerySceneIds.BenchmarkTree);
AssertEqual("unknown-fallback", GallerySceneIds.ResolveRequestedScene(["--scene=unknown"], null), GallerySceneIds.All);

if (!GallerySceneIds.IsSceneVisible(GallerySceneIds.All, GallerySceneIds.WindowFoundation) ||
    GallerySceneIds.IsSceneVisible(GallerySceneIds.ControlsMatrix, GallerySceneIds.MaterialRegions) ||
    GallerySceneIds.IsSceneVisible(GallerySceneIds.All, GallerySceneIds.BenchmarkSettings) ||
    GallerySceneIds.IsSceneVisible(GallerySceneIds.All, GallerySceneIds.BenchmarkGrid) ||
    GallerySceneIds.IsSceneVisible(GallerySceneIds.All, GallerySceneIds.BenchmarkTree) ||
    !GallerySceneIds.IsSceneVisible(GallerySceneIds.BenchmarkSettings, GallerySceneIds.BenchmarkSettings) ||
    !GallerySceneIds.IsSceneVisible(GallerySceneIds.BenchmarkGrid, GallerySceneIds.BenchmarkGrid) ||
    !GallerySceneIds.IsSceneVisible(GallerySceneIds.BenchmarkTree, GallerySceneIds.BenchmarkTree))
{
    throw new InvalidOperationException("Scene visibility policy failed.");
}

Console.WriteLine("Gallery scene selection smoke passed.");

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
AssertEqual("unknown-fallback", GallerySceneIds.ResolveRequestedScene(["--scene=unknown"], null), GallerySceneIds.All);

if (!GallerySceneIds.IsSceneVisible(GallerySceneIds.All, GallerySceneIds.WindowFoundation) ||
    GallerySceneIds.IsSceneVisible(GallerySceneIds.ControlsMatrix, GallerySceneIds.MaterialRegions))
{
    throw new InvalidOperationException("Scene visibility policy failed.");
}

Console.WriteLine("Gallery scene selection smoke passed.");

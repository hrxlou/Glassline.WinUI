namespace Glassline.Gallery;

public static class GalleryBenchmarkData
{
    public const int SettingsRowCount = 100;
    public const int GridItemCount = 500;
    public const int TreeRootCount = 100;
    public const int TreeChildrenPerRoot = 50;
    public const int TreeNonRootNodeCount = TreeRootCount * TreeChildrenPerRoot;

    public static IReadOnlyList<SettingsBenchmarkRow> CreateSettingsRows() =>
        Enumerable.Range(1, SettingsRowCount)
            .Select(index => new SettingsBenchmarkRow(index, $"Setting {index:000}", $"Deterministic setting value {index:000}"))
            .ToArray();

    public static IReadOnlyList<GridBenchmarkItem> CreateGridItems() =>
        Enumerable.Range(1, GridItemCount)
            .Select(index => new GridBenchmarkItem(index, $"Item {index:000}"))
            .ToArray();

    public static IReadOnlyList<TreeBenchmarkBranch> CreateTreeBranches() =>
        Enumerable.Range(1, TreeRootCount)
            .Select(rootIndex => new TreeBenchmarkBranch(
                rootIndex,
                Enumerable.Range(1, TreeChildrenPerRoot)
                    .Select(childIndex => new TreeBenchmarkLeaf(
                        rootIndex,
                        childIndex,
                        $"Node {rootIndex:000}.{childIndex:00}"))
                    .ToArray()))
            .ToArray();
}

public sealed record SettingsBenchmarkRow(int Index, string Title, string Detail)
{
    public override string ToString() => $"{Title} — {Detail}";
}

public sealed record GridBenchmarkItem(int Index, string Title)
{
    public override string ToString() => Title;
}

public sealed record TreeBenchmarkLeaf(int RootIndex, int ChildIndex, string Title);

public sealed record TreeBenchmarkBranch(int RootIndex, IReadOnlyList<TreeBenchmarkLeaf> Children)
{
    public string Title => $"Group {RootIndex:000}";
}

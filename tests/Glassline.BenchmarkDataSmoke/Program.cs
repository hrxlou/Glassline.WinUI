using Glassline.Gallery;

IReadOnlyList<SettingsBenchmarkRow> settings = GalleryBenchmarkData.CreateSettingsRows();
IReadOnlyList<GridBenchmarkItem> grid = GalleryBenchmarkData.CreateGridItems();
IReadOnlyList<TreeBenchmarkBranch> tree = GalleryBenchmarkData.CreateTreeBranches();

if (settings.Count != GalleryBenchmarkData.SettingsRowCount || settings.Count != 100)
{
    throw new InvalidOperationException($"Settings benchmark drifted: {settings.Count}");
}

if (grid.Count != GalleryBenchmarkData.GridItemCount || grid.Count != 500)
{
    throw new InvalidOperationException($"Grid benchmark drifted: {grid.Count}");
}

int nonRootNodes = tree.Sum(branch => branch.Children.Count);
if (tree.Count != GalleryBenchmarkData.TreeRootCount || tree.Count != 100 ||
    nonRootNodes != GalleryBenchmarkData.TreeNonRootNodeCount || nonRootNodes != 5000)
{
    throw new InvalidOperationException($"Tree benchmark drifted: roots={tree.Count}, nonRootNodes={nonRootNodes}");
}

if (settings.Select(row => row.Index).Distinct().Count() != settings.Count ||
    grid.Select(item => item.Index).Distinct().Count() != grid.Count)
{
    throw new InvalidOperationException("Benchmark item identifiers are not deterministic/unique.");
}

Console.WriteLine("Benchmark data smoke passed: settings=100, grid=500, treeNonRoot=5000.");

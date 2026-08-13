# Performance Native Acceptance

Status: **deterministic workloads implemented; native measurements pending**.

Hosted CI can prove that benchmark data sizes and WinUI scene construction compile. It cannot establish a frame-time or GPU performance budget because GitHub-hosted runners are not the project reference hardware and the Gallery is not interactively driven/captured in that lane.

## Deterministic workloads

- `benchmark-settings`: native `ListView`, exactly 100 rows.
- `benchmark-grid`: native `GridView`, exactly 500 items.
- `benchmark-tree`: native `TreeView`, 100 roots × 50 children = exactly 5000 non-root nodes.

Benchmark scenes are opt-in and are not populated by the default `all` Gallery scene, preventing the normal component Gallery from paying the 5k-node construction cost.

Stable AutomationIds:

- `Scene.BenchmarkSettings` / `Benchmark.Settings.List`
- `Scene.BenchmarkGrid` / `Benchmark.Grid.Items`
- `Scene.BenchmarkTree` / `Benchmark.Tree.Nodes`

## Native measurement lane still required

For each relevant scene and material mode:

- [ ] warm launch and deterministic scene selection;
- [ ] capture P50/P95/P99 frame time;
- [ ] record process memory before/after workload creation;
- [ ] record available GPU utilization/memory signals;
- [ ] record active material-region count and approximate total region area;
- [ ] exercise selection/scrolling for Settings and Grid;
- [ ] expand/collapse and scroll the 5k-node Tree workload;
- [ ] run rapid menu/popover open-close scenario;
- [ ] run continuous resize for at least 10 seconds and confirm Reduced-mode downgrade/recovery;
- [ ] repeat active/inactive and local/RDP transitions;
- [ ] document reference CPU/GPU/RAM/display scale/Windows build/driver.

No numerical performance pass/fail budget should be locked until repeatable evidence exists on agreed reference Windows hardware.

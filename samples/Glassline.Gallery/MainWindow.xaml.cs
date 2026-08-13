using Glassline.WinUI.Controls;
using Microsoft.UI.Dispatching;
using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;

namespace Glassline.Gallery;

public sealed partial class MainWindow : Window
{
    private readonly string[] viewModes = ["General", "Appearance", "Advanced"];
    private readonly GlasslineWindowBackdropController backdropController;
    private readonly DispatcherQueueTimer resizeSettleTimer;
    private readonly string requestedScene;
    private bool isWindowActive = true;
    private bool isResizing;

    public MainWindow()
    {
        InitializeComponent();

        requestedScene = GallerySceneIds.ResolveRequestedScene(
            Environment.GetCommandLineArgs(),
            Environment.GetEnvironmentVariable("GLASSLINE_GALLERY_SCENE"));

        backdropController = new GlasslineWindowBackdropController(this);
        backdropController.EffectiveKindChanged += OnBackdropEffectiveKindChanged;

        resizeSettleTimer = DispatcherQueue.CreateTimer();
        resizeSettleTimer.Interval = TimeSpan.FromMilliseconds(250);
        resizeSettleTimer.IsRepeating = false;
        resizeSettleTimer.Tick += OnResizeSettleTick;

        Activated += OnWindowActivated;
        AppWindow.Changed += OnAppWindowChanged;
        GalleryRoot.Loaded += OnGalleryLoaded;
        SidebarMaterialRegion.SizeChanged += OnRegionSizeChanged;
        ToolbarMaterialRegion.SizeChanged += OnRegionSizeChanged;
        SidebarMaterialRegion.EffectiveModeChanged += OnMaterialEffectiveModeChanged;
        ToolbarMaterialRegion.EffectiveModeChanged += OnMaterialEffectiveModeChanged;

        SegmentedControl.ItemsSource = viewModes;
        SegmentedControl.SelectedIndex = 0;
        SelectionStatus.Text = $"Selected: {viewModes[0]}";
        SegmentedControl.RegisterPropertyChangedCallback(
            GlasslineSegmentedControl.SelectedIndexProperty,
            (_, _) => UpdateSelectionStatus());

        ApplyRequestedScene();
        UpdateWindowFoundationFallback();
        ApplyMaterialWindowState();
        UpdateDiagnostics();
    }

    private GlasslineGlassContainer[] MaterialRegions => [SidebarMaterialRegion, ToolbarMaterialRegion];

    private void ApplyRequestedScene()
    {
        RequestedSceneStatus.Text = $"Scene: {requestedScene}";
        SceneWindowFoundation.Visibility = GallerySceneIds.IsSceneVisible(requestedScene, GallerySceneIds.WindowFoundation)
            ? Visibility.Visible
            : Visibility.Collapsed;
        SceneMaterialRegions.Visibility = GallerySceneIds.IsSceneVisible(requestedScene, GallerySceneIds.MaterialRegions)
            ? Visibility.Visible
            : Visibility.Collapsed;
        SceneControlsMatrix.Visibility = GallerySceneIds.IsSceneVisible(requestedScene, GallerySceneIds.ControlsMatrix)
            ? Visibility.Visible
            : Visibility.Collapsed;
    }

    private void ApplyMaterialWindowState()
    {
        foreach (GlasslineGlassContainer region in MaterialRegions)
        {
            region.IsWindowActive = isWindowActive;
            region.IsResizing = isResizing;
        }

        UpdateDiagnostics();
    }

    private void UpdateSelectionStatus()
    {
        int index = SegmentedControl.SelectedIndex;
        SelectionStatus.Text = index >= 0 && index < viewModes.Length
            ? $"Selected: {viewModes[index]}"
            : "No selection";
    }

    private void UpdateWindowFoundationFallback()
    {
        WindowSolidFallback.Visibility = backdropController.EffectiveKind == GlasslineWindowBackdropKind.Solid
            ? Visibility.Visible
            : Visibility.Collapsed;
    }

    private void UpdateDiagnostics()
    {
        UpdateWindowFoundationFallback();

        GlasslineMaterialEnvironmentState? environment = MaterialRegions
            .Select(region => region.LastEnvironment)
            .FirstOrDefault(state => state.HasValue);

        BackdropStatus.Text = $"Window backdrop: requested={backdropController.RequestedKind}, effective={backdropController.EffectiveKind}";

        EnvironmentStatus.Text = environment is GlasslineMaterialEnvironmentState state
            ? $"Environment: highContrast={state.HighContrast}, effects={state.AdvancedEffectsEnabled}, remote={state.IsRemoteSession}, active={state.IsWindowActive}, resizing={state.IsResizing}"
            : $"Environment: pending, active={isWindowActive}, resizing={isResizing}";

        MaterialStatus.Text = "Materials: " + string.Join(
            ", ",
            MaterialRegions.Select(region => $"{region.Name}:{region.Quality}->{region.EffectiveMode}"));

        GlasslineGlassContainer[] activeRegions = MaterialRegions
            .Where(region => region.Visibility == Visibility.Visible && region.ActualWidth > 0 && region.ActualHeight > 0)
            .ToArray();
        double totalArea = activeRegions.Sum(region => region.ActualWidth * region.ActualHeight);
        RegionStatus.Text = $"Regions: active={activeRegions.Length}, approximateLayoutArea={totalArea:F0} DIP^2";
    }

    private void OnWindowActivated(object sender, WindowActivatedEventArgs args)
    {
        isWindowActive = args.WindowActivationState != WindowActivationState.Deactivated;
        ApplyMaterialWindowState();
    }

    private void OnAppWindowChanged(AppWindow sender, AppWindowChangedEventArgs args)
    {
        if (!args.DidSizeChange)
        {
            return;
        }

        isResizing = true;
        ApplyMaterialWindowState();
        resizeSettleTimer.Stop();
        resizeSettleTimer.Start();
    }

    private void OnResizeSettleTick(DispatcherQueueTimer sender, object args)
    {
        isResizing = false;
        ApplyMaterialWindowState();
    }

    private void OnBackdropEffectiveKindChanged(object? sender, EventArgs e) => UpdateDiagnostics();

    private void OnMaterialEffectiveModeChanged(object? sender, EventArgs e) => UpdateDiagnostics();

    private void OnRegionSizeChanged(object sender, SizeChangedEventArgs e) => UpdateDiagnostics();

    private void OnGalleryLoaded(object sender, RoutedEventArgs e) => UpdateDiagnostics();
}

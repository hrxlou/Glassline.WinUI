using Microsoft.UI.Composition.SystemBackdrops;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;

namespace Glassline.WinUI.Controls;

[TemplatePart(Name = BackdropElementPartName, Type = typeof(SystemBackdropElement))]
public sealed class GlasslineGlassContainer : ContentControl
{
    internal const string BackdropElementPartName = "PART_BackdropElement";

    public static readonly DependencyProperty MaterialProperty = DependencyProperty.Register(
        nameof(Material),
        typeof(GlasslineMaterialRole),
        typeof(GlasslineGlassContainer),
        new PropertyMetadata(GlasslineMaterialRole.Toolbar, OnMaterialPropertyChanged));

    public static readonly DependencyProperty QualityProperty = DependencyProperty.Register(
        nameof(Quality),
        typeof(GlasslineMaterialQuality),
        typeof(GlasslineGlassContainer),
        new PropertyMetadata(GlasslineMaterialQuality.Auto, OnEnvironmentPropertyChanged));

    public static readonly DependencyProperty IsWindowActiveProperty = DependencyProperty.Register(
        nameof(IsWindowActive),
        typeof(bool),
        typeof(GlasslineGlassContainer),
        new PropertyMetadata(true, OnEnvironmentPropertyChanged));

    public static readonly DependencyProperty IsResizingProperty = DependencyProperty.Register(
        nameof(IsResizing),
        typeof(bool),
        typeof(GlasslineGlassContainer),
        new PropertyMetadata(false, OnEnvironmentPropertyChanged));

    private SystemBackdropElement? backdropElement;
    private GlasslineMaterialCapabilities? capabilities;
    private GlasslineMaterialMode effectiveMode = GlasslineMaterialMode.Solid;

    public GlasslineGlassContainer()
    {
        DefaultStyleKey = typeof(GlasslineGlassContainer);
        Loaded += OnLoaded;
        Unloaded += OnUnloaded;
    }

    public event EventHandler? EffectiveModeChanged;

    public GlasslineMaterialRole Material
    {
        get => (GlasslineMaterialRole)GetValue(MaterialProperty);
        set => SetValue(MaterialProperty, value);
    }

    public GlasslineMaterialQuality Quality
    {
        get => (GlasslineMaterialQuality)GetValue(QualityProperty);
        set => SetValue(QualityProperty, value);
    }

    public bool IsWindowActive
    {
        get => (bool)GetValue(IsWindowActiveProperty);
        set => SetValue(IsWindowActiveProperty, value);
    }

    public bool IsResizing
    {
        get => (bool)GetValue(IsResizingProperty);
        set => SetValue(IsResizingProperty, value);
    }

    public GlasslineMaterialMode EffectiveMode => effectiveMode;

    public GlasslineMaterialEnvironmentState? LastEnvironment { get; private set; }

    protected override void OnApplyTemplate()
    {
        base.OnApplyTemplate();
        backdropElement = GetTemplateChild(BackdropElementPartName) as SystemBackdropElement;
        RefreshMaterial();
    }

    public void RefreshMaterial()
    {
        VisualStateManager.GoToState(this, Material.ToString(), false);

        if (capabilities is null)
        {
            ApplyMode(GlasslineMaterialMode.Solid);
            return;
        }

        GlasslineMaterialEnvironmentState environment = capabilities.Capture(IsWindowActive, IsResizing);
        LastEnvironment = environment;
        ApplyMode(GlasslineMaterialQualityManager.Resolve(Quality, environment));
    }

    private void ApplyMode(GlasslineMaterialMode mode)
    {
        if (backdropElement is not null)
        {
            backdropElement.SystemBackdrop = mode switch
            {
                GlasslineMaterialMode.Full => new DesktopAcrylicBackdrop(),
                GlasslineMaterialMode.Reduced => new MicaBackdrop
                {
                    Kind = MicaKind.BaseAlt,
                },
                _ => null,
            };
        }

        VisualStateManager.GoToState(this, mode.ToString(), false);

        if (effectiveMode == mode)
        {
            return;
        }

        effectiveMode = mode;
        EffectiveModeChanged?.Invoke(this, EventArgs.Empty);
    }

    private void OnLoaded(object sender, RoutedEventArgs e)
    {
        capabilities ??= new GlasslineMaterialCapabilities();
        capabilities.Changed -= OnCapabilitiesChanged;
        capabilities.Changed += OnCapabilitiesChanged;
        RefreshMaterial();
    }

    private void OnUnloaded(object sender, RoutedEventArgs e)
    {
        if (capabilities is null)
        {
            return;
        }

        capabilities.Changed -= OnCapabilitiesChanged;
        capabilities.Dispose();
        capabilities = null;
        LastEnvironment = null;
        ApplyMode(GlasslineMaterialMode.Solid);
    }

    private void OnCapabilitiesChanged(object? sender, EventArgs e) => RefreshMaterial();

    private static void OnMaterialPropertyChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        ((GlasslineGlassContainer)d).RefreshMaterial();
    }

    private static void OnEnvironmentPropertyChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
    {
        ((GlasslineGlassContainer)d).RefreshMaterial();
    }
}

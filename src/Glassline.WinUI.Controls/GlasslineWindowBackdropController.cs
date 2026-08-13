using Microsoft.UI.Composition.SystemBackdrops;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Media;
using Windows.UI.ViewManagement;

namespace Glassline.WinUI.Controls;

/// <summary>
/// Selects the native WinUI window foundation for a Glassline window.
/// The controller intentionally delegates rendering and unsupported-platform fallback to WinUI.
/// </summary>
public sealed class GlasslineWindowBackdropController : IDisposable
{
    private readonly Window _window;
    private readonly AccessibilitySettings _accessibilitySettings;
    private readonly UISettings _uiSettings;
    private GlasslineWindowBackdropKind _requestedKind;
    private GlasslineWindowBackdropKind _effectiveKind;
    private bool _disposed;

    public GlasslineWindowBackdropController(
        Window window,
        GlasslineWindowBackdropKind requestedKind = GlasslineWindowBackdropKind.Auto)
    {
        ArgumentNullException.ThrowIfNull(window);

        _window = window;
        _requestedKind = requestedKind;
        _accessibilitySettings = new AccessibilitySettings();
        _uiSettings = new UISettings();

        _accessibilitySettings.HighContrastChanged += OnHighContrastChanged;
        _uiSettings.AdvancedEffectsEnabledChanged += OnAdvancedEffectsEnabledChanged;

        Refresh();
    }

    public event EventHandler? EffectiveKindChanged;

    public GlasslineWindowBackdropKind RequestedKind
    {
        get => _requestedKind;
        set
        {
            ThrowIfDisposed();
            if (_requestedKind == value)
            {
                return;
            }

            _requestedKind = value;
            Refresh();
        }
    }

    public GlasslineWindowBackdropKind EffectiveKind => _effectiveKind;

    public bool IsHighContrast => _accessibilitySettings.HighContrast;

    public bool AreAdvancedEffectsEnabled => _uiSettings.AdvancedEffectsEnabled;

    public static GlasslineWindowBackdropKind ResolveEffectiveKind(
        GlasslineWindowBackdropKind requestedKind,
        bool highContrast,
        bool advancedEffectsEnabled)
    {
        if (requestedKind == GlasslineWindowBackdropKind.Solid)
        {
            return GlasslineWindowBackdropKind.Solid;
        }

        if (highContrast || !advancedEffectsEnabled)
        {
            return GlasslineWindowBackdropKind.Solid;
        }

        return requestedKind switch
        {
            GlasslineWindowBackdropKind.Auto => GlasslineWindowBackdropKind.Mica,
            GlasslineWindowBackdropKind.Mica => GlasslineWindowBackdropKind.Mica,
            GlasslineWindowBackdropKind.MicaAlt => GlasslineWindowBackdropKind.MicaAlt,
            _ => GlasslineWindowBackdropKind.Solid,
        };
    }

    public void Refresh()
    {
        ThrowIfDisposed();

        GlasslineWindowBackdropKind next = ResolveEffectiveKind(
            _requestedKind,
            _accessibilitySettings.HighContrast,
            _uiSettings.AdvancedEffectsEnabled);

        Apply(next);

        if (_effectiveKind == next)
        {
            return;
        }

        _effectiveKind = next;
        EffectiveKindChanged?.Invoke(this, EventArgs.Empty);
    }

    public void Dispose()
    {
        if (_disposed)
        {
            return;
        }

        _accessibilitySettings.HighContrastChanged -= OnHighContrastChanged;
        _uiSettings.AdvancedEffectsEnabledChanged -= OnAdvancedEffectsEnabledChanged;
        _disposed = true;
        GC.SuppressFinalize(this);
    }

    private void Apply(GlasslineWindowBackdropKind kind)
    {
        _window.SystemBackdrop = kind switch
        {
            GlasslineWindowBackdropKind.Mica => new MicaBackdrop
            {
                Kind = MicaKind.Base,
            },
            GlasslineWindowBackdropKind.MicaAlt => new MicaBackdrop
            {
                Kind = MicaKind.BaseAlt,
            },
            _ => null,
        };
    }

    private void OnHighContrastChanged(AccessibilitySettings sender, object args) => Refresh();

    private void OnAdvancedEffectsEnabledChanged(UISettings sender, object args) => Refresh();

    private void ThrowIfDisposed()
    {
        ObjectDisposedException.ThrowIf(_disposed, this);
    }
}

public enum GlasslineWindowBackdropKind
{
    Auto,
    Mica,
    MicaAlt,
    Solid,
}

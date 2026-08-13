using Windows.System.RemoteDesktop;
using Windows.UI.ViewManagement;

namespace Glassline.WinUI.Controls;

/// <summary>
/// Captures Windows policy/environment signals used by the adaptive material policy.
/// Hardware model allowlists are intentionally not part of this contract.
/// </summary>
public sealed class GlasslineMaterialCapabilities : IDisposable
{
    private readonly AccessibilitySettings accessibilitySettings = new();
    private readonly UISettings uiSettings = new();
    private bool disposed;

    public GlasslineMaterialCapabilities()
    {
        accessibilitySettings.HighContrastChanged += OnHighContrastChanged;
        uiSettings.AdvancedEffectsEnabledChanged += OnAdvancedEffectsEnabledChanged;
    }

    public event EventHandler? Changed;

    public GlasslineMaterialEnvironmentState Capture(bool isWindowActive, bool isResizing)
    {
        ThrowIfDisposed();

        return new GlasslineMaterialEnvironmentState(
            accessibilitySettings.HighContrast,
            uiSettings.AdvancedEffectsEnabled,
            InteractiveSession.IsRemote,
            isWindowActive,
            isResizing);
    }

    public void Dispose()
    {
        if (disposed)
        {
            return;
        }

        accessibilitySettings.HighContrastChanged -= OnHighContrastChanged;
        uiSettings.AdvancedEffectsEnabledChanged -= OnAdvancedEffectsEnabledChanged;
        disposed = true;
        GC.SuppressFinalize(this);
    }

    private void OnHighContrastChanged(AccessibilitySettings sender, object args) => Changed?.Invoke(this, EventArgs.Empty);

    private void OnAdvancedEffectsEnabledChanged(UISettings sender, object args) => Changed?.Invoke(this, EventArgs.Empty);

    private void ThrowIfDisposed()
    {
        ObjectDisposedException.ThrowIf(disposed, this);
    }
}

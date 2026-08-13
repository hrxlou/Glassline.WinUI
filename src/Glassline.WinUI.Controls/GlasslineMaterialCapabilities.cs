using Microsoft.UI;
using Microsoft.UI.Dispatching;
using Microsoft.UI.System;
using Windows.System.RemoteDesktop;
using Windows.UI.ViewManagement;

namespace Glassline.WinUI.Controls;

/// <summary>
/// Captures Windows policy/environment signals used by the adaptive material policy.
/// Hardware model allowlists are intentionally not part of this contract.
/// </summary>
public sealed class GlasslineMaterialCapabilities : IDisposable
{
    // ThemeSettings is the Win32/WinAppSDK replacement for AccessibilitySettings.
    // AccessibilitySettings.HighContrastChanged depends on CoreWindow, which desktop apps do not have.
    // The instance must stay referenced for the Changed event to keep firing.
    private readonly ThemeSettings themeSettings;
    private readonly UISettings uiSettings = new();
    private readonly DispatcherQueue? dispatcherQueue;
    private bool disposed;

    public GlasslineMaterialCapabilities(WindowId windowId)
    {
        // Captured on the constructing UI thread so background-thread setting changes
        // can be marshalled back before consumers touch XAML.
        dispatcherQueue = DispatcherQueue.GetForCurrentThread();

        themeSettings = ThemeSettings.CreateForWindowId(windowId);
        themeSettings.Changed += OnThemeSettingsChanged;
        uiSettings.AdvancedEffectsEnabledChanged += OnAdvancedEffectsEnabledChanged;
    }

    public event EventHandler? Changed;

    public GlasslineMaterialEnvironmentState Capture(bool isWindowActive, bool isResizing)
    {
        ThrowIfDisposed();

        return new GlasslineMaterialEnvironmentState(
            themeSettings.HighContrast,
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

        themeSettings.Changed -= OnThemeSettingsChanged;
        uiSettings.AdvancedEffectsEnabledChanged -= OnAdvancedEffectsEnabledChanged;
        disposed = true;
        GC.SuppressFinalize(this);
    }

    // ThemeSettings.Changed is raised on the window's UI thread, so it can notify directly.
    private void OnThemeSettingsChanged(ThemeSettings sender, object args) => RaiseChanged();

    // UISettings events are raised on a background thread; consumers of Changed mutate XAML.
    private void OnAdvancedEffectsEnabledChanged(UISettings sender, object args)
    {
        if (dispatcherQueue is null || dispatcherQueue.HasThreadAccess)
        {
            RaiseChanged();
            return;
        }

        dispatcherQueue.TryEnqueue(RaiseChanged);
    }

    private void RaiseChanged()
    {
        if (disposed)
        {
            return;
        }

        Changed?.Invoke(this, EventArgs.Empty);
    }

    private void ThrowIfDisposed()
    {
        ObjectDisposedException.ThrowIf(disposed, this);
    }
}

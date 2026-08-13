using Microsoft.UI.Xaml.Automation.Peers;

namespace Glassline.WinUI.Controls;

internal sealed class GlasslineSearchFieldAutomationPeer : FrameworkElementAutomationPeer
{
    public GlasslineSearchFieldAutomationPeer(GlasslineSearchField owner)
        : base(owner)
    {
    }

    protected override string GetClassNameCore() => nameof(GlasslineSearchField);

    protected override AutomationControlType GetAutomationControlTypeCore() => AutomationControlType.Group;
}

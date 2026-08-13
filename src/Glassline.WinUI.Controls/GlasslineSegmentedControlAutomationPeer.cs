using Microsoft.UI.Xaml.Automation.Peers;

namespace Glassline.WinUI.Controls;

internal sealed class GlasslineSegmentedControlAutomationPeer : FrameworkElementAutomationPeer
{
    public GlasslineSegmentedControlAutomationPeer(GlasslineSegmentedControl owner)
        : base(owner)
    {
    }

    protected override string GetClassNameCore() => nameof(GlasslineSegmentedControl);

    protected override AutomationControlType GetAutomationControlTypeCore() => AutomationControlType.Group;
}

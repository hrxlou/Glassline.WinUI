using Microsoft.UI.Xaml;

namespace Glassline.Gallery;

public sealed partial class MainWindow : Window
{
    private readonly string[] viewModes = ["General", "Appearance", "Advanced"];

    public MainWindow()
    {
        InitializeComponent();

        SegmentedControl.ItemsSource = viewModes;
        SegmentedControl.SelectedIndex = 0;
        SelectionStatus.Text = $"Selected: {viewModes[0]}";

        SegmentedControl.RegisterPropertyChangedCallback(
            Glassline.WinUI.Controls.GlasslineSegmentedControl.SelectedIndexProperty,
            (_, _) => UpdateSelectionStatus());
    }

    private void UpdateSelectionStatus()
    {
        int index = SegmentedControl.SelectedIndex;
        SelectionStatus.Text = index >= 0 && index < viewModes.Length
            ? $"Selected: {viewModes[index]}"
            : "No selection";
    }
}

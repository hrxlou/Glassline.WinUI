using Glassline.WinUI.Controls;
using Microsoft.UI.Xaml;

namespace Glassline.Gallery;

public sealed partial class MainWindow : Window
{
    private readonly string[] viewModes = ["General", "Appearance", "Advanced"];
    private readonly GlasslineWindowBackdropController backdropController;

    public MainWindow()
    {
        InitializeComponent();

        backdropController = new GlasslineWindowBackdropController(this);

        SegmentedControl.ItemsSource = viewModes;
        SegmentedControl.SelectedIndex = 0;
        SelectionStatus.Text = $"Selected: {viewModes[0]}";

        SegmentedControl.RegisterPropertyChangedCallback(
            GlasslineSegmentedControl.SelectedIndexProperty,
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

using Glassline.WinUI.Controls;
using Microsoft.UI.Xaml;

namespace Glassline.PackageSmoke;

public sealed partial class MainWindow : Window
{
    private readonly GlasslineWindowBackdropController backdropController;

    public MainWindow()
    {
        InitializeComponent();
        backdropController = new GlasslineWindowBackdropController(this);
        SegmentedControl.ItemsSource = new[] { "One", "Two", "Three" };
        SegmentedControl.SelectedIndex = 0;
    }
}

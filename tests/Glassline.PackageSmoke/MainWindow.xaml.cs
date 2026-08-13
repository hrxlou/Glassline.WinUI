using Microsoft.UI.Xaml;

namespace Glassline.PackageSmoke;

public sealed partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        SegmentedControl.ItemsSource = new[] { "One", "Two", "Three" };
        SegmentedControl.SelectedIndex = 0;
    }
}

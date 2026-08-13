using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Automation;
using Microsoft.UI.Xaml.Automation.Peers;
using Microsoft.UI.Xaml.Controls;

namespace Glassline.WinUI.Controls;

[TemplatePart(Name = InputPartName, Type = typeof(TextBox))]
[TemplatePart(Name = ClearButtonPartName, Type = typeof(Button))]
public sealed class GlasslineSearchField : Control
{
    internal const string InputPartName = "PART_Input";
    internal const string ClearButtonPartName = "PART_ClearButton";

    public static readonly DependencyProperty TextProperty = DependencyProperty.Register(
        nameof(Text),
        typeof(string),
        typeof(GlasslineSearchField),
        new PropertyMetadata(string.Empty, OnTextPropertyChanged));

    public static readonly DependencyProperty PlaceholderTextProperty = DependencyProperty.Register(
        nameof(PlaceholderText),
        typeof(string),
        typeof(GlasslineSearchField),
        new PropertyMetadata(string.Empty, OnPlaceholderTextPropertyChanged));

    public static readonly DependencyProperty IsClearButtonVisibleProperty = DependencyProperty.Register(
        nameof(IsClearButtonVisible),
        typeof(bool),
        typeof(GlasslineSearchField),
        new PropertyMetadata(true, OnIsClearButtonVisiblePropertyChanged));

    private TextBox? input;
    private Button? clearButton;
    private bool synchronizingText;

    public GlasslineSearchField()
    {
        DefaultStyleKey = typeof(GlasslineSearchField);
        IsTabStop = false;
    }

    public string Text
    {
        get => (string)GetValue(TextProperty);
        set => SetValue(TextProperty, value ?? string.Empty);
    }

    public string PlaceholderText
    {
        get => (string)GetValue(PlaceholderTextProperty);
        set => SetValue(PlaceholderTextProperty, value ?? string.Empty);
    }

    public bool IsClearButtonVisible
    {
        get => (bool)GetValue(IsClearButtonVisibleProperty);
        set => SetValue(IsClearButtonVisibleProperty, value);
    }

    protected override AutomationPeer OnCreateAutomationPeer() => new GlasslineSearchFieldAutomationPeer(this);

    protected override void OnApplyTemplate()
    {
        DetachTemplatePartHandlers();
        base.OnApplyTemplate();

        input = GetTemplateChild(InputPartName) as TextBox;
        clearButton = GetTemplateChild(ClearButtonPartName) as Button;

        if (input is not null)
        {
            input.Text = Text;
            input.PlaceholderText = PlaceholderText;

            string automationName = AutomationProperties.GetName(this);
            if (!string.IsNullOrWhiteSpace(automationName))
            {
                AutomationProperties.SetName(input, automationName);
            }

            input.TextChanged += OnInputTextChanged;
        }

        if (clearButton is not null)
        {
            clearButton.Click += OnClearButtonClick;
        }

        UpdateClearButtonVisibility();
    }

    private static void OnTextPropertyChanged(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs args)
    {
        var control = (GlasslineSearchField)dependencyObject;
        string text = args.NewValue as string ?? string.Empty;

        if (control.input is not null && control.input.Text != text)
        {
            control.synchronizingText = true;
            control.input.Text = text;
            control.synchronizingText = false;
        }

        control.UpdateClearButtonVisibility();
    }

    private static void OnPlaceholderTextPropertyChanged(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs args)
    {
        var control = (GlasslineSearchField)dependencyObject;
        if (control.input is not null)
        {
            control.input.PlaceholderText = args.NewValue as string ?? string.Empty;
        }
    }

    private static void OnIsClearButtonVisiblePropertyChanged(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs args)
    {
        ((GlasslineSearchField)dependencyObject).UpdateClearButtonVisibility();
    }

    private void OnInputTextChanged(object sender, TextChangedEventArgs e)
    {
        if (synchronizingText || input is null)
        {
            return;
        }

        synchronizingText = true;
        SetValue(TextProperty, input.Text);
        synchronizingText = false;
        UpdateClearButtonVisibility();
    }

    private void OnClearButtonClick(object sender, RoutedEventArgs e)
    {
        Text = string.Empty;
        input?.Focus(FocusState.Programmatic);
    }

    private void UpdateClearButtonVisibility()
    {
        if (clearButton is not null)
        {
            clearButton.Visibility = IsClearButtonVisible && !string.IsNullOrEmpty(Text)
                ? Visibility.Visible
                : Visibility.Collapsed;
        }
    }

    private void DetachTemplatePartHandlers()
    {
        if (input is not null)
        {
            input.TextChanged -= OnInputTextChanged;
        }

        if (clearButton is not null)
        {
            clearButton.Click -= OnClearButtonClick;
        }

        input = null;
        clearButton = null;
    }
}

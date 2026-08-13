using System.Collections;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Automation;
using Microsoft.UI.Xaml.Controls;

namespace Glassline.WinUI.Controls;

[TemplatePart(Name = SelectorPartName, Type = typeof(ListBox))]
public sealed class GlasslineSegmentedControl : Control
{
    internal const string SelectorPartName = "PART_Selector";

    public static readonly DependencyProperty ItemsSourceProperty = DependencyProperty.Register(
        nameof(ItemsSource),
        typeof(IEnumerable),
        typeof(GlasslineSegmentedControl),
        new PropertyMetadata(null, OnItemsSourcePropertyChanged));

    public static readonly DependencyProperty SelectedIndexProperty = DependencyProperty.Register(
        nameof(SelectedIndex),
        typeof(int),
        typeof(GlasslineSegmentedControl),
        new PropertyMetadata(-1, OnSelectedIndexPropertyChanged));

    public static readonly DependencyProperty SelectedItemProperty = DependencyProperty.Register(
        nameof(SelectedItem),
        typeof(object),
        typeof(GlasslineSegmentedControl),
        new PropertyMetadata(null, OnSelectedItemPropertyChanged));

    private ListBox? selector;
    private bool synchronizingSelection;

    public GlasslineSegmentedControl()
    {
        DefaultStyleKey = typeof(GlasslineSegmentedControl);
        IsTabStop = false;
    }

    public IEnumerable? ItemsSource
    {
        get => (IEnumerable?)GetValue(ItemsSourceProperty);
        set => SetValue(ItemsSourceProperty, value);
    }

    public int SelectedIndex
    {
        get => (int)GetValue(SelectedIndexProperty);
        set => SetValue(SelectedIndexProperty, value);
    }

    public object? SelectedItem
    {
        get => GetValue(SelectedItemProperty);
        set => SetValue(SelectedItemProperty, value);
    }

    protected override void OnApplyTemplate()
    {
        DetachTemplatePartHandlers();
        base.OnApplyTemplate();

        selector = GetTemplateChild(SelectorPartName) as ListBox;
        if (selector is null)
        {
            return;
        }

        selector.SelectionMode = SelectionMode.Single;
        selector.ItemsSource = ItemsSource;

        if (SelectedItem is not null)
        {
            selector.SelectedItem = SelectedItem;
        }
        else
        {
            selector.SelectedIndex = SelectedIndex;
        }

        string automationName = AutomationProperties.GetName(this);
        if (!string.IsNullOrWhiteSpace(automationName))
        {
            AutomationProperties.SetName(selector, automationName);
        }

        selector.SelectionChanged += OnSelectorSelectionChanged;
        SynchronizeSelectionFromSelector();
    }

    private static void OnItemsSourcePropertyChanged(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs args)
    {
        var control = (GlasslineSegmentedControl)dependencyObject;
        if (control.selector is not null)
        {
            control.selector.ItemsSource = args.NewValue as IEnumerable;
            control.SynchronizeSelectionFromSelector();
        }
    }

    private static void OnSelectedIndexPropertyChanged(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs args)
    {
        var control = (GlasslineSegmentedControl)dependencyObject;
        if (control.synchronizingSelection || control.selector is null)
        {
            return;
        }

        int selectedIndex = args.NewValue is int value ? value : -1;
        if (control.selector.SelectedIndex != selectedIndex)
        {
            control.synchronizingSelection = true;
            control.selector.SelectedIndex = selectedIndex;
            control.SetValue(SelectedItemProperty, control.selector.SelectedItem);
            control.synchronizingSelection = false;
        }
    }

    private static void OnSelectedItemPropertyChanged(DependencyObject dependencyObject, DependencyPropertyChangedEventArgs args)
    {
        var control = (GlasslineSegmentedControl)dependencyObject;
        if (control.synchronizingSelection || control.selector is null)
        {
            return;
        }

        if (!ReferenceEquals(control.selector.SelectedItem, args.NewValue))
        {
            control.synchronizingSelection = true;
            control.selector.SelectedItem = args.NewValue;
            control.SetValue(SelectedIndexProperty, control.selector.SelectedIndex);
            control.synchronizingSelection = false;
        }
    }

    private void OnSelectorSelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        SynchronizeSelectionFromSelector();
    }

    private void SynchronizeSelectionFromSelector()
    {
        if (selector is null || synchronizingSelection)
        {
            return;
        }

        synchronizingSelection = true;
        SetValue(SelectedIndexProperty, selector.SelectedIndex);
        SetValue(SelectedItemProperty, selector.SelectedItem);
        synchronizingSelection = false;
    }

    private void DetachTemplatePartHandlers()
    {
        if (selector is not null)
        {
            selector.SelectionChanged -= OnSelectorSelectionChanged;
        }

        selector = null;
    }
}

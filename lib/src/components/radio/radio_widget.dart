part of 'radio.dart';

/// A customizable radio button component.
///
/// ## Example
///
/// ```dart
/// RemixRadio<String>(
///   value: 'option1',
///   groupValue: _selectedValue,
///   onChanged: (value) {
///     setState(() {
///       _selectedValue = value;
///     });
///   },
///   label: 'Option 1',
/// )
/// ```
class RemixRadio<T> extends StatefulWidget
    with HasEnabled, HasSelected, HasFocused {
  const RemixRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.autofocus = false,
    this.onChanged,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.style = const RemixRadioStyle.create(),
    this.label,
    this.focusNode,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for a group of radio buttons.
  final T? groupValue;

  /// Called when the user selects this radio button.
  final ValueChanged<T?>? onChanged;

  /// Whether this radio button is enabled.
  final bool enabled;

  /// Whether the radio button should automatically request focus when it is created.
  final bool autofocus;

  /// Whether to enable haptic feedback when selected.
  final bool enableHapticFeedback;

  /// The style configuration for the radio button.
  final RemixRadioStyle style;

  /// An optional label that will be displayed next to the radio button.
  final String? label;

  /// The focus node for the radio button.
  final FocusNode? focusNode;

  @override
  bool get selected => value == groupValue;

  @override
  State<RemixRadio<T>> createState() => _RemixRadioState<T>();
}

class _RemixRadioState<T> extends State<RemixRadio<T>>
    with HasWidgetStateController, HasEnabledState, HasSelectedState {
  @override
  Widget build(BuildContext context) {
    // Check if we're in a NakedRadioGroup by looking for NakedRadioGroupScope
    final nakedGroupScope = NakedRadioGroupScope.maybeOf<T>(context);
    final isInGroup = nakedGroupScope != null;

    // Get style from StyleProvider if in RemixRadioGroup, otherwise use widget style
    final inheritedStyle = StyleProvider.maybeOf<RadioSpec>(context);
    final RemixRadioStyle style = inheritedStyle != null
        ? (inheritedStyle as RemixRadioStyle).merge(widget.style)
        : widget.style;

    // Get values from NakedRadioGroupScope or widget properties
    final T? groupValue = nakedGroupScope?.groupValue ?? widget.groupValue;
    final bool enabled = nakedGroupScope != null
        ? (widget.enabled && nakedGroupScope.state.widget.enabled)
        : widget.enabled;

    // Calculate selected state for visual display
    final isSelected = widget.value == groupValue;

    // Build the NakedRadio with common configuration
    final nakedRadio = NakedRadio<T>(
      value: widget.value,
      onHoverChange: (state) => controller.hovered = state,
      onPressChange: (state) => controller.pressed = state,
      onSelectChange: (state) => controller.selected = state,
      onFocusChange: (state) => controller.focused = state,
      enabled: enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: StyleBuilder(
        style: DefaultRemixRadioStyle.merge(style),
        controller: controller,
        builder: (context, spec) {
          final IndicatorContainer = spec.indicatorContainer;
          final Indicator = spec.indicator;
          final Container = spec.container;
          final Label = spec.label;

          // Build the radio indicator
          final radioIndicator = IndicatorContainer(
            child: isSelected ? Indicator() : null,
          );

          // Add label if present
          final radioWithLabel = widget.label != null
              ? Container(
                  direction: Axis.horizontal,
                  children: [radioIndicator, Label(widget.label!)],
                )
              : radioIndicator;

          return radioWithLabel;
        },
      ),
    );

    // Only wrap with NakedRadioGroup when NOT in a group
    // When in a group, the parent RemixRadioGroup already provides NakedRadioGroup
    if (!isInGroup) {
      return NakedRadioGroup<T>(
        groupValue: groupValue,
        onChanged: widget.onChanged,
        enabled: enabled,
        child: nakedRadio,
      );
    }

    return nakedRadio;
  }
}

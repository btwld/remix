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
    with Disableable, Selectable, Focusable {
  const RemixRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.style = const RadioStyle.create(),
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

  /// Whether to enable haptic feedback when selected.
  final bool enableHapticFeedback;

  /// The style configuration for the radio button.
  final RadioStyle style;

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
    with WidgetStateMixin, DisableableMixin, SelectableMixin {
  Widget _buildRadioChild(RadioStyle style, bool isSelected) {
    return StyleBuilder(
      style: DefaultRadioStyle.merge(style),
      builder: (context, spec) {
        final radio = spec.indicatorContainer(
          child: isSelected ? spec.indicator() : null,
        );

        if (widget.label == null) {
          return radio;
        }

        return spec.container(
          direction: Axis.horizontal,
          children: [radio, spec.label(widget.label!)],
        );
      },
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're in a NakedRadioGroup by looking for NakedRadioGroupScope
    final nakedGroupScope = NakedRadioGroupScope.maybeOf<T>(context);
    final isInGroup = nakedGroupScope != null;

    // Get style from StyleProvider if in RemixRadioGroup, otherwise use widget style
    final inheritedStyle = StyleProvider.maybeOf<RadioSpec>(context);
    final RadioStyle style = inheritedStyle != null
        ? (inheritedStyle as RadioStyle).merge(widget.style)
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
      onHoveredState: (state) => controller.hovered = state,
      onPressedState: (state) => controller.pressed = state,
      onSelectedState: (state) => controller.selected = state,
      onFocusedState: (state) => controller.focused = state,
      enabled: enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: _buildRadioChild(style, isSelected),
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

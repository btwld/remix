part of 'checkbox.dart';

/// A customizable checkbox component that supports various styles and behaviors.
/// The checkbox integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixCheckbox(
///   selected: _isChecked,
///   onChanged: (value) {
///     setState(() {
///       _isChecked = value;
///     });
///   },
///   checked: Icons.check_rounded,
///   label: 'Accept Terms',
/// )
/// ```
class RemixCheckbox extends StatefulWidget
    with HasEnabled, HasSelected, HasFocused {
  const RemixCheckbox({
    super.key,
    this.enabled = true,
    required this.selected,
    this.onChanged,
    this.autofocus = false,
    this.checked = Icons.check_rounded,
    this.unchecked,
    this.enableHapticFeedback = true,
    this.style = const RemixCheckboxStyle.create(),
    this.label,
    this.focusNode,
  });

  /// Whether the checkbox is enabled for interaction.
  final bool enabled;

  /// Whether the checkbox is currently selected.
  final bool selected;

  /// The icon to display when the checkbox is checked.
  final IconData checked;

  /// Whether the checkbox should automatically request focus when it is created.
  final bool autofocus;

  /// The icon to display when the checkbox is unchecked.
  final IconData? unchecked;

  /// The callback function that is called when the checkbox is tapped.
  final ValueChanged<bool>? onChanged;

  /// The style configuration for the checkbox.
  final RemixCheckboxStyle style;

  /// An optional label that will be displayed next to the checkbox.
  final String? label;

  /// Whether to provide haptic feedback when the checkbox is toggled.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// The focus node for the checkbox.
  final FocusNode? focusNode;

  @override
  State<RemixCheckbox> createState() => _RemixCheckboxState();
}

class _RemixCheckboxState extends State<RemixCheckbox>
    with HasWidgetStateController, HasEnabledState, HasSelectedState {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: widget.enabled && widget.onChanged != null
          ? (value) => widget.onChanged!(value ?? false)
          : null,
      onHoverChange: (state) => controller.hovered = state,
      onPressChange: (state) => controller.pressed = state,
      onFocusChange: (state) => controller.focused = state,
      enabled: widget.enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: StyleBuilder(
        style: DefaultRemixCheckboxStyle.merge(widget.style),
        builder: (context, spec) {
          final IndicatorContainer = spec.indicatorContainer;
          final Indicator = spec.indicator;
          final Container = spec.container;
          final Label = spec.label;

          final iconData =
              widget.selected ? widget.checked : widget.unchecked;

          final checkbox = IndicatorContainer(
            child: iconData != null ? Indicator(icon: iconData) : null,
          );

          if (widget.label == null) {
            return checkbox;
          }

          return Container(
            direction: Axis.horizontal,
            children: [checkbox, Label(widget.label!)],
          );
        },
      ),
    );
  }
}

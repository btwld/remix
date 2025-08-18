part of 'switch.dart';

/// A customizable switch component.
///
/// ## Example
///
/// ```dart
/// RemixSwitch(
///   selected: _isEnabled,
///   onChanged: (value) {
///     setState(() {
///       _isEnabled = value;
///     });
///   },
/// )
/// ```
class RemixSwitch extends StatefulWidget
    with HasEnabled, HasSelected, HasFocused {
  const RemixSwitch({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.style = const RemixSwitchStyle.create(),
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
  });

  /// Whether this switch is enabled.
  final bool enabled;

  /// Whether the switch is currently selected.
  final bool selected;

  /// Called when the user toggles the switch.
  final ValueChanged<bool> onChanged;

  /// The style configuration for the switch.
  final RemixSwitchStyle style;

  /// Whether to enable haptic feedback when toggled.
  final bool enableHapticFeedback;

  /// The focus node for the switch.
  final FocusNode? focusNode;

  /// Whether the switch should automatically request focus when it is created.
  final bool autofocus;

  @override
  State<RemixSwitch> createState() => _RemixSwitchState();
}

class _RemixSwitchState extends State<RemixSwitch>
    with HasWidgetStateController, HasEnabledState, HasSelectedState {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => widget.onChanged(value ?? false),
      onHoverChange: (state) => controller.hovered = state,
      onPressChange: (state) => controller.pressed = state,
      onFocusChange: (state) => controller.focused = state,
      enabled: widget.enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: StyleBuilder(
        style: DefaultRemixSwitchStyle.merge(widget.style),
        controller: controller,
        builder: (context, spec) {
          final Container = spec.container;
          final Track = spec.track;
          final Thumb = spec.thumb;

          return Container(
            child: Track(
              child: Align(
                alignment: widget.selected
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Thumb(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

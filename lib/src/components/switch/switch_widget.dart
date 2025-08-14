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
class RemixSwitch extends StatefulWidget implements Disableable, Selectable {
  const RemixSwitch({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.style = const SwitchStyle.create(),
    this.enableHapticFeedback = true,
    this.focusNode,
  });

  /// Whether this switch is enabled.
  @override
  final bool enabled;
  
  /// Whether the switch is currently selected.
  @override
  final bool selected;

  /// Called when the user toggles the switch.
  final ValueChanged<bool> onChanged;

  /// The style configuration for the switch.
  final SwitchStyle style;

  /// Whether to enable haptic feedback when toggled.
  final bool enableHapticFeedback;

  /// The focus node for the switch.
  final FocusNode? focusNode;

  @override
  State<RemixSwitch> createState() => _RemixSwitchState();
}

class _RemixSwitchState extends State<RemixSwitch>
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => widget.onChanged(value ?? false),
      onHoveredState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusedState: (state) => stateController.focused = state,
      enabled: widget.enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultSwitchStyle.merge(widget.style),
        builder: (context, spec) {
          return spec.container(
            child: spec.track(
              child: Align(
                alignment: widget.selected
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: spec.thumb(),
                ),
              ),
            ),
          );
        },
        controller: stateController,
      ),
    );
  }
}

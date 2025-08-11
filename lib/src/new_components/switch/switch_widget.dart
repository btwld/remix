part of 'switch.dart';

/// A customizable switch component.
///
/// ## Example
///
/// ```dart
/// RemixSwitch(
///   value: _isEnabled,
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
    required this.value,
    this.onChanged,
    this.enabled = true,
    this.style = const SwitchStyle.create(),
    this.focusNode,
  });

  /// The current value of the switch.
  final bool value;
  
  /// Whether the switch is currently selected.
  @override
  bool get selected => value;

  /// Called when the user toggles the switch.
  final ValueChanged<bool>? onChanged;

  /// Whether this switch is enabled.
  @override
  final bool enabled;

  /// The style configuration for the switch.
  final SwitchStyle style;

  /// The focus node for the switch.
  final FocusNode? focusNode;

  @override
  State<RemixSwitch> createState() => _RemixSwitchState();
}

class _RemixSwitchState extends State<RemixSwitch>
    with MixControllerMixin, DisableableMixin, SelectableMixin {


  void _handleTap() {
    if (widget.enabled && widget.onChanged != null) {
      widget.onChanged!(!widget.value);
    }
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: MouseRegion(
        onEnter: (_) => stateController.hovered = true,
        onExit: (_) => stateController.hovered = false,
        child: StyleBuilder(
          style: DefaultSwitchStyle.merge(widget.style),
          builder: (context, spec) {
            return spec.container(
              child: spec.track(
                child: Align(
                  alignment: widget.value
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
        ),
      ),
    );
  }
}

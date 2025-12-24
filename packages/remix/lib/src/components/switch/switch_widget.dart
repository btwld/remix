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
class RemixSwitch extends StatelessWidget {
  const RemixSwitch({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.style = const RemixSwitchStyle.create(),
    this.styleSpec,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// Whether this switch is enabled.
  final bool enabled;

  /// Whether the switch is currently selected.
  final bool selected;

  /// Called when the user toggles the switch.
  final ValueChanged<bool> onChanged;

  /// The style configuration for the switch.
  final RemixSwitchStyle style;

  /// The style spec for the switch.
  final RemixSwitchSpec? styleSpec;

  static final styleFrom = RemixSwitchStyle.new;

  /// Whether to enable haptic feedback when toggled.
  final bool enableFeedback;

  /// The focus node for the switch.
  final FocusNode? focusNode;

  /// Whether the switch should automatically request focus when it is created.
  final bool autofocus;

  /// The semantic label for the switch.
  final String? semanticLabel;

  /// Cursor when hovering over the switch.
  final MouseCursor mouseCursor;

  RemixSwitchStyle _buildStyle() {
    return RemixSwitchStyle()
        .alignment(Alignment.centerLeft)
        // Small thumb inset
        .onSelected(RemixSwitchStyle().alignment(Alignment.centerRight))
        .merge(style);
  }

  @override
  Widget build(BuildContext context) {
    return NakedToggle(
      value: selected,
      onChanged: enabled ? onChanged : null,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      asSwitch: true,
      builder: (context, state, _) {
        return StyleBuilder(
          style: _buildStyle(),
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            return Box(
              styleSpec: spec.container,
              child: Box(styleSpec: spec.thumb),
            );
          },
        );
      },
    );
  }
}

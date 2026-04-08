part of 'toggle.dart';

/// A customizable toggle button component.
///
/// Unlike [RemixSwitch] which is a sliding on/off control,
/// [RemixToggle] is a pressable button that stays visually active when selected.
///
/// At least one of [label] or [icon] must be provided.
///
/// ## Example
///
/// ```dart
/// RemixToggle(
///   selected: _isBold,
///   onChanged: (value) {
///     setState(() {
///       _isBold = value;
///     });
///   },
///   label: 'Bold',
///   icon: Icons.format_bold,
/// )
/// ```
class RemixToggle extends StatelessWidget {
  const RemixToggle({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.label,
    this.icon,
    this.style = const RemixToggleStyle.create(),
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : assert(
         label != null || icon != null,
         'At least one of label or icon must be provided',
       );

  /// Whether this toggle is enabled.
  final bool enabled;

  /// Whether the toggle is currently selected.
  final bool selected;

  /// Called when the user toggles the button.
  final ValueChanged<bool> onChanged;

  /// Optional text label.
  final String? label;

  /// Optional icon.
  final IconData? icon;

  /// The style configuration for the toggle.
  final RemixToggleStyle style;

  static final styleFrom = RemixToggleStyle.new;

  /// Whether to enable haptic feedback when toggled.
  final bool enableFeedback;

  /// The focus node for the toggle.
  final FocusNode? focusNode;

  /// Whether the toggle should automatically request focus when it is created.
  final bool autofocus;

  /// The semantic label for the toggle.
  final String? semanticLabel;

  /// Cursor when hovering over the toggle.
  final MouseCursor mouseCursor;

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
      builder: (context, state, _) {
        return StyleBuilder(
          style: style,
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            return RowBox(
              styleSpec: spec.container,
              children: [
                if (icon != null) StyledIcon(icon: icon, styleSpec: spec.icon),
                if (label != null) StyledText(label!, styleSpec: spec.label),
              ],
            );
          },
        );
      },
    );
  }
}

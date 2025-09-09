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
class RemixSwitch extends StatefulWidget with HasEnabled, HasSelected {
  const RemixSwitch({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.style = const RemixSwitchStyle.create(),
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
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

  /// Whether to enable haptic feedback when toggled.
  final bool enableFeedback;

  /// The focus node for the switch.
  final FocusNode? focusNode;

  /// Whether the switch should automatically request focus when it is created.
  final bool autofocus;

  /// The semantic label for the switch.
  final String? semanticLabel;

  /// The semantic hint for the switch.
  final String? semanticHint;

  /// Whether to exclude child semantics.
  final bool excludeSemantics;

  /// Cursor when hovering over the switch.
  final MouseCursor mouseCursor;

  @override
  State<RemixSwitch> createState() => _RemixSwitchState();
}

class _RemixSwitchState extends State<RemixSwitch>
    with HasWidgetStateController, HasEnabledState, HasSelectedState {
  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RemixSwitchStyles.baseStyle.merge(widget.style),
      controller: controller,
      builder: (context, spec) {
        final Container = spec.container.createWidget;
        final Track = spec.track.createWidget;
        final Thumb = spec.thumb.createWidget;

        // Simplified widget tree with integrated semantics
        return Semantics(
          excludeSemantics: widget.excludeSemantics,
          enabled: widget.enabled,
          toggled: widget.selected,
          focusable: widget.enabled,
          label: widget.semanticLabel,
          hint: widget.semanticHint,
          onTap:
              widget.enabled ? () => widget.onChanged(!widget.selected) : null,
          child: NakedCheckbox(
            statesController: controller,
            value: widget.selected,
            onChanged: (value) => widget.onChanged(value ?? false),
            enabled: widget.enabled,
            mouseCursor: widget.mouseCursor,
            enableFeedback: widget.enableFeedback,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            child: Container(
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
            ),
          ),
        );
      },
    );
  }
}

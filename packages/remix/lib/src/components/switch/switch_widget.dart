part of 'switch.dart';

/// A customizable switch component.
///
/// ## Example
///
/// ```dart
/// RemixSwitch(
///   label: 'Enable feature',
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
    required this.selected,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
    this.style = const SwitchStyler.create(),
    this.styleSpec,
  }) : assert(label != '', 'RemixSwitch.label must not be empty.'),
       assert(
         semanticLabel != '',
         'RemixSwitch.semanticLabel must be a nonblank accessible name.',
       ),
       assert(
         label != null || semanticLabel != null,
         'RemixSwitch requires a label or a semanticLabel.',
       );

  /// Whether this switch is enabled.
  final bool enabled;

  /// Whether the switch is currently selected.
  final bool selected;

  /// Called when the user toggles the switch.
  ///
  /// When null, the switch is visually disabled and does not respond to
  /// interaction.
  final ValueChanged<bool>? onChanged;

  /// The style configuration for the switch.
  final SwitchStyler style;

  /// The style spec for the switch.
  final SwitchSpec? styleSpec;

  static final styleFrom = SwitchStyler.new;

  /// Whether to enable haptic feedback when toggled.
  final bool enableFeedback;

  /// The focus node for the switch.
  final FocusNode? focusNode;

  /// Whether the switch should automatically request focus when it is created.
  final bool autofocus;

  /// Optional visible label included in the switch's interaction target.
  ///
  /// The label is also used as the accessible name unless [semanticLabel]
  /// overrides it.
  final String? label;

  /// Accessible name for this switch.
  ///
  /// Defaults to [label]. At least one of the two is required and neither may
  /// be blank. A bare switch must not be unnamed; do not rely on adjacent
  /// [Text] as the accessible composition.
  final String? semanticLabel;

  /// Minimum pointer, focus, and semantics target size.
  ///
  /// Defaults to [Size.zero], which keeps the switch's own geometry, unlike
  /// `RemixCheckbox`, which defaults to `Size.square(48)`. Pass
  /// `Size.square(48)` to meet platform tap target guidelines.
  final Size minimumTapTargetSize;

  /// Whether to hide the switch and its visual subtree from semantics.
  final bool excludeSemantics;

  /// Cursor when hovering over the switch.
  final MouseCursor mouseCursor;

  SwitchStyler _buildStyle() {
    return SwitchStyler()
        .alignment(.centerLeft)
        // Small thumb inset
        .onSelected(SwitchStyler().alignment(.centerRight))
        .merge(style);
  }

  @override
  Widget build(BuildContext context) {
    assert(
      label == null || label!.trim().isNotEmpty,
      'RemixSwitch.label must not be blank.',
    );
    assert(
      semanticLabel == null || semanticLabel!.trim().isNotEmpty,
      'RemixSwitch.semanticLabel must be a nonblank accessible name.',
    );
    assert(
      minimumTapTargetSize.isFinite &&
          minimumTapTargetSize.width >= 0 &&
          minimumTapTargetSize.height >= 0,
      'RemixSwitch.minimumTapTargetSize must be finite and non-negative.',
    );
    // Forwarded raw: NakedToggle derives interactivity from
    // enabled && onChanged != null itself.
    return NakedToggle(
      value: selected,
      onChanged: onChanged,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel ?? label,
      asSwitch: true,
      excludeSemantics: excludeSemantics,
      builder: (context, state, _) {
        return RemixStyleSpecBuilder<SwitchSpec>(
          style: _buildStyle(),
          styleSpec: styleSpec,
          controller: NakedToggleState.controllerOf(context),
          builder: (context, spec) {
            final track = RemixBoxAdapter(
              styleSpec: spec.container,
              containerEffects: spec.trackEffects,
              child: RemixBoxAdapter(
                styleSpec: spec.thumb,
                containerEffects: spec.thumbEffects,
              ),
            );

            if (label == null && minimumTapTargetSize == Size.zero) {
              return track;
            }

            return RemixLabeledControl(
              control: track,
              label: label,
              labelSpec: spec.label,
              labelSpacing: spec.labelSpacing,
              minimumTapTargetSize: minimumTapTargetSize,
            );
          },
        );
      },
    );
  }
}

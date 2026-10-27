part of 'radio.dart';

/// A customizable radio button component that integrates with the Mix styling system.
/// Must be used within a RemixRadioGroup for proper functionality.
///
/// ## Examples
///
/// ```dart
/// RemixRadioGroup<String>(
///   groupValue: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
///   child: Column(
///     children: [
///       RemixRadio<String>(value: 'option1', label: 'Option 1'),
///       RemixRadio<String>(value: 'option2', label: 'Option 2'),
///     ],
///   ),
/// )
/// ```
///
class RemixRadio<T> extends StatelessWidget {
  const RemixRadio({
    super.key,
    required this.value,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.enabled = true,
    this.toggleable = false,
    this.mouseCursor,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
    this.style = const RadioStyler.create(),
    this.styleSpec,
  }) : assert(label != '', 'RemixRadio.label must not be empty.'),
       assert(
         semanticLabel != '',
         'RemixRadio.semanticLabel must be a nonblank accessible name.',
       ),
       assert(
         label != null || semanticLabel != null,
         'RemixRadio requires a label or a semanticLabel.',
       );

  final RadioStyler style;

  final RadioSpec? styleSpec;

  static final styleFrom = RadioStyler.new;

  /// The value represented by this radio button.
  final T value;

  /// Whether this radio button is enabled.
  final bool enabled;

  /// Whether the radio button should automatically request focus when it is created.
  final bool autofocus;

  /// Whether the radio button is toggleable (can be unselected).
  final bool toggleable;

  /// The focus node for the radio button.
  final FocusNode? focusNode;

  /// The mouse cursor to use when hovering over the radio button.
  final MouseCursor? mouseCursor;

  /// Optional visible label included in the radio's interaction target.
  ///
  /// The label is also used as the accessible name unless [semanticLabel]
  /// overrides it.
  final String? label;

  /// Accessible name for this radio.
  ///
  /// Defaults to [label]. At least one of the two is required and neither may
  /// be blank. A bare radio must not be unnamed; do not rely on adjacent
  /// [Text] as the accessible composition.
  final String? semanticLabel;

  /// Minimum pointer, focus, and semantics target size.
  ///
  /// Defaults to [Size.zero], which keeps the radio's own geometry, unlike
  /// `RemixCheckbox`, which defaults to `Size.square(48)`. Pass
  /// `Size.square(48)` to meet platform tap target guidelines.
  final Size minimumTapTargetSize;

  /// Whether to hide the radio button and its visual subtree from semantics.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    assert(
      label == null || label!.trim().isNotEmpty,
      'RemixRadio.label must not be blank.',
    );
    assert(
      semanticLabel == null || semanticLabel!.trim().isNotEmpty,
      'RemixRadio.semanticLabel must be a nonblank accessible name.',
    );
    assert(
      minimumTapTargetSize.isFinite &&
          minimumTapTargetSize.width >= 0 &&
          minimumTapTargetSize.height >= 0,
      'RemixRadio.minimumTapTargetSize must be finite and non-negative.',
    );
    // NakedRadio owns missing-group validation and group participation.
    return NakedRadio<T>(
      value: value,
      enabled: enabled,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      toggleable: toggleable,
      semanticLabel: semanticLabel ?? label,
      excludeSemantics: excludeSemantics,
      builder: (context, state, _) {
        return RemixStyleSpecBuilder<RadioSpec>(
          style: style,
          styleSpec: styleSpec,
          controller: NakedRadioState.controllerOf<T>(context),
          builder: (context, spec) {
            final radio = RemixBoxAdapter(
              styleSpec: spec.container,
              containerEffects: spec.containerEffects,
              child: state.isSelected ? Box(styleSpec: spec.indicator) : null,
            );

            if (label == null && minimumTapTargetSize == Size.zero) {
              return radio;
            }

            return RemixLabeledControl(
              control: radio,
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

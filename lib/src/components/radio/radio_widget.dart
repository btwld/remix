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
///       Row(
///         children: [
///           RemixRadio<String>(value: 'option1'),
///           const SizedBox(width: 8),
///           const Text('Option 1'),
///         ],
///       ),
///       Row(
///         children: [
///           RemixRadio<String>(value: 'option2'),
///           const SizedBox(width: 8),
///           const Text('Option 2'),
///         ],
///       ),
///     ],
///   ),
/// )
/// ```
///
class RemixRadio<T> extends StyleWidget<RadioSpec> {
  const RemixRadio({
    super.style = const RemixRadioStyle.create(),
    super.styleSpec,
    super.key,
    required this.value,
    this.autofocus = false,
    this.enabled = true,
    this.toggleable = false,
    this.focusNode,
    this.mouseCursor,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  static late final styleFrom = RemixRadioStyle.new;

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

  /// Whether to provide feedback when the radio button is pressed.
  final bool enableFeedback;

  /// The semantic label for the radio button.
  final String? semanticLabel;

  /// The semantic hint for the radio button.
  final String? semanticHint;

  /// Whether to exclude child semantics.
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context, RadioSpec spec) {
    final registry = RadioGroup.maybeOf<T>(context);

    // Always require registry - same as NakedRadio
    if (registry == null) {
      throw FlutterError.fromParts([
        ErrorSummary(
          'RemixRadio<$T> must be used within a RemixRadioGroup<$T>.',
        ),
        ErrorDescription(
          'No RemixRadioGroup<$T> ancestor was found in the widget tree.',
        ),
        ErrorHint(
          'Wrap your RemixRadio widgets with a RemixRadioGroup:\n'
          'RemixRadioGroup<$T>(\n'
          '  groupValue: selectedValue,\n'
          '  onChanged: (value) { ... },\n'
          '  child: Column(\n'
          '    children: [\n'
          '      RemixRadio<$T>(value: ...),\n'
          '      RemixRadio<$T>(value: ...),\n'
          '    ],\n'
          '  ),\n'
          ')',
        ),
      ]);
    }

    // Check if selected
    final isSelected = registry.groupValue == value;

    // Build widgets using Box instead of deprecated createWidget
    Widget buildIndicatorContainer({Widget? child}) {
      return Box(styleSpec: spec.indicatorContainer, child: child);
    }

    Widget buildIndicator() {
      return Box(styleSpec: spec.indicator);
    }

    Widget buildContainer({required Widget child}) {
      return Box(styleSpec: spec.container, child: child);
    }

    // Build the radio indicator
    final radioIndicator = buildIndicatorContainer(
      child: isSelected ? buildIndicator() : null,
    );

    final control = buildContainer(child: radioIndicator);

    // Simplified widget tree with integrated semantics
    return Semantics(
      excludeSemantics: excludeSemantics,
      enabled: enabled,
      checked: isSelected,
      focusable: enabled,
      inMutuallyExclusiveGroup: true,
      label: semanticLabel,
      hint: semanticHint,
      child: NakedRadio<T>(
        value: value,
        enabled: enabled,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        autofocus: autofocus,
        toggleable: toggleable,
        child: control,
      ),
    );
  }
}
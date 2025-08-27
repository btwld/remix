part of 'radio.dart';

/// A customizable radio button component.
///
/// ## Example
///
/// ```dart
/// RemixRadio<String>(
///   value: 'option1',
///   label: 'Option 1',
/// )
/// ```
class RemixRadio<T> extends StatefulWidget
    with HasEnabled, HasSelected, HasFocused {
  const RemixRadio({
    super.key,
    required this.value,
    this.autofocus = false,
    this.enabled = true,
    this.toggleable = false,
    this.style = const RemixRadioStyle.create(),
    this.label,
    this.focusNode,
    this.cursor,
    this.onFocusChange,
    this.onHoverChange,
    this.onHighlightChanged,
    this.onStateChange,
    this.statesController,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  /// The value represented by this radio button.
  final T value;

  /// Whether this radio button is enabled.
  final bool enabled;

  /// Whether the radio button should automatically request focus when it is created.
  final bool autofocus;

  /// Whether the radio button is toggleable (can be unselected).
  final bool toggleable;

  /// The style configuration for the radio button.
  final RemixRadioStyle style;

  /// An optional label that will be displayed next to the radio button.
  final String? label;

  /// The focus node for the radio button.
  final FocusNode? focusNode;

  /// The mouse cursor to use when hovering over the radio button.
  final MouseCursor? cursor;

  // State change callbacks
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<bool>? onHighlightChanged; // For pressed state
  final ValueChanged<Set<WidgetState>>? onStateChange;

  final WidgetStatesController? statesController;
  final String? semanticLabel;
  final String? semanticHint;
  final bool excludeSemantics;

  @override
  bool get selected => false; // Selected state comes from RadioGroup context

  @override
  State<RemixRadio<T>> createState() => _RemixRadioState<T>();
}

class _RemixRadioState<T> extends State<RemixRadio<T>>
    with HasWidgetStateController, HasEnabledState, HasFocusedState {
  @override
  Widget build(BuildContext context) {
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
    final isSelected = registry.groupValue == widget.value;

    // Update controller selected state
    controller.selected = isSelected;

    // Get style from StyleProvider if in RemixRadioGroup, otherwise use widget style
    final inheritedStyle = StyleProvider.maybeOf<RadioSpec>(context);
    final RemixRadioStyle style = inheritedStyle != null
        ? (inheritedStyle as RemixRadioStyle).merge(widget.style)
        : widget.style;

    // Remove effectiveCursor since NakedRadio handles cursor internally

    return NakedRadio<T>(
      value: widget.value,
      enabled: widget.enabled,
      mouseCursor: widget.cursor,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      toggleable: widget.toggleable,
      onFocusChange: widget.onFocusChange,
      onHoverChange: widget.onHoverChange,
      onPressChange: widget.onHighlightChanged,
      statesController: widget.statesController ?? controller,
      semanticLabel: widget.semanticLabel ?? widget.label,
      semanticHint: widget.semanticHint,
      excludeSemantics: widget.excludeSemantics,
      // Use child instead of builder for simplicity
      child: StyleBuilder(
        style: DefaultRemixRadioStyle.merge(style),
        controller: widget.statesController ?? controller,
        builder: (context, spec) {
          final IndicatorContainer = spec.indicatorContainer;
          final Indicator = spec.indicator;
          final Container = spec.container;
          final Flex = spec.flex;
          final Label = spec.label;

          // Build the radio indicator
          final radioIndicator = IndicatorContainer(
            child: isSelected ? Indicator() : null,
          );

          // Add label if present
          final radioWithLabel = widget.label != null
              ? Container(
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [radioIndicator, Label(widget.label!)],
                  ),
                )
              : radioIndicator;

          return radioWithLabel;
        },
      ),
    );
  }
}

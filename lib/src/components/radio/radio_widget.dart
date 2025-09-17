part of 'radio.dart';

/// A customizable radio button component.
///
/// ## Example
///
/// ```dart
/// RemixRadio<String>(
///   value: 'option1',
/// )
/// ```
///
/// Compose the control with your own label:
/// ```dart
/// Row(
///   children: [
///     RemixRadio<String>(value: 'option1'),
///     const SizedBox(width: 8),
///     const Text('Option 1'),
///   ],
/// )
/// ```
class RemixRadio<T> extends StatefulWidget with HasEnabled, HasSelected {
  RemixRadio({
    super.key,
    required this.value,
    this.autofocus = false,
    this.enabled = true,
    this.toggleable = false,
    this.style = const RemixRadioStyle.create(),
    this.focusNode,
    this.cursor,
    this.onChanged,
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

  /// The focus node for the radio button.
  final FocusNode? focusNode;

  /// The mouse cursor to use when hovering over the radio button.
  final MouseCursor? cursor;

  /// Called when the selection state changes.
  final ValueChanged<bool>? onChanged;

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
    with HasWidgetStateController, HasEnabledState {
  FocusNode? _ownedFocusNode;
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }
  // No custom registry/scope; rely on NakedRadioGroup (via Flutter RadioGroup)

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

    return StyleBuilder<RadioSpec>(
      style: style,
      controller: widget.statesController ?? controller,
      builder: (context, spec) {
        final IndicatorContainer = spec.indicatorContainer.createWidget;
        final Indicator = spec.indicator.createWidget;
        final Container = spec.container.createWidget;

        // Build the radio indicator
        final radioIndicator = IndicatorContainer(
          child: isSelected ? Indicator() : null,
        );

        final control = Container(child: radioIndicator);

        // Simplified widget tree with integrated semantics
        return Semantics(
          excludeSemantics: widget.excludeSemantics,
          enabled: widget.enabled,
          checked: controller.selected,
          focusable: widget.enabled,
          inMutuallyExclusiveGroup: true,
          label: widget.semanticLabel,
          hint: widget.semanticHint,
          onTap: widget.enabled && widget.onChanged != null
              ? () => widget.onChanged!(true)
              : null,
          child: NakedRadio<T>(
            value: widget.value,
            enabled: widget.enabled,
            mouseCursor: widget.cursor,
            focusNode: _effectiveFocusNode,
            autofocus: widget.autofocus,
            toggleable: widget.toggleable,
            onFocusChange: (focused) => controller.focused = focused,
            onHoverChange: (hovered) => controller.hovered = hovered,
            onPressChange: (pressed) => controller.pressed = pressed,
            child: control,
          ),
        );
      },
    );
  }
}

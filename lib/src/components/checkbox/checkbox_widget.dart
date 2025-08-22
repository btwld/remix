part of 'checkbox.dart';

/// A customizable checkbox component that supports various styles and behaviors.
/// The checkbox integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixCheckbox(
///   selected: _isChecked,
///   onChanged: (value) {
///     setState(() {
///       _isChecked = value;
///     });
///   },
///   checkedIcon: Icons.check_rounded,
///   label: 'Accept Terms',
/// )
/// ```
class RemixCheckbox extends StatefulWidget with HasEnabled, HasFocused {
  const RemixCheckbox({
    super.key,
    this.enabled = true,
    required this.selected,
    this.tristate = false,
    this.onChanged,
    this.autofocus = false,
    this.checkedIcon = Icons.check_rounded,
    this.uncheckedIcon,
    this.indeterminateIcon = Icons.horizontal_rule,
    this.enableFeedback = true,
    this.style = const RemixCheckboxStyle.create(),
    this.label,
    this.focusNode,
    this.onFocusChange,
    this.onHoverChange,
    this.onHighlightChanged,
    this.onStateChange,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// Whether the checkbox is enabled for interaction.
  final bool enabled;

  /// Whether the checkbox is currently selected.
  /// When [tristate] is true, can be null for indeterminate state.
  final bool? selected;

  /// Whether the checkbox can be true, false, or null (indeterminate).
  final bool tristate;

  /// The icon to display when the checkbox is checked.
  final IconData checkedIcon;

  /// Whether the checkbox should automatically request focus when it is created.
  final bool autofocus;

  /// The icon to display when the checkbox is unchecked.
  final IconData? uncheckedIcon;

  /// The icon to display when the checkbox is in indeterminate state (null value).
  final IconData indeterminateIcon;

  /// The callback function that is called when the checkbox is tapped.
  /// When [tristate] is true, the value can be null.
  final ValueChanged<bool?>? onChanged;

  /// Called when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called when hover state changes.
  final ValueChanged<bool>? onHoverChange;

  /// Called when highlight (pressed) state changes.
  final ValueChanged<bool>? onHighlightChanged;

  /// Called when any widget state changes.
  final ValueChanged<Set<WidgetState>>? onStateChange;

  /// The style configuration for the checkbox.
  final RemixCheckboxStyle style;

  /// An optional label that will be displayed next to the checkbox.
  final String? label;

  /// Whether to provide haptic feedback when the checkbox is toggled.
  /// Defaults to true.
  final bool enableFeedback;

  /// The focus node for the checkbox.
  final FocusNode? focusNode;

  /// The semantic label for the checkbox.
  final String? semanticLabel;

  /// The semantic hint for the checkbox.
  final String? semanticHint;

  /// Whether to exclude child semantics.
  final bool excludeSemantics;

  /// Cursor when hovering over the checkbox.
  final MouseCursor mouseCursor;

  @override
  State<RemixCheckbox> createState() => _RemixCheckboxState();
}

class _RemixCheckboxState extends State<RemixCheckbox>
    with HasWidgetStateController, HasEnabledState {
  @override
  Widget build(BuildContext context) {
    // Update controller selected state
    controller.selected = widget.selected ?? false;

    return NakedCheckbox(
      value: widget.selected,
      tristate: widget.tristate,
      onChanged: widget.enabled && widget.onChanged != null
          ? (value) =>
              widget.onChanged!(widget.tristate ? value : (value ?? false))
          : null,
      enabled: widget.enabled,
      semanticLabel: widget.semanticLabel ?? widget.label,
      semanticHint: widget.semanticHint,
      excludeSemantics: widget.excludeSemantics,
      mouseCursor: widget.mouseCursor,
      enableFeedback: widget.enableFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.onFocusChange,
      onHoverChange: widget.onHoverChange,
      onPressChanged: widget.onHighlightChanged,
      onStatesChange: widget.onStateChange,
      statesController: controller,
      child: StyleBuilder(
        style: DefaultRemixCheckboxStyle.merge(widget.style),
        builder: (context, spec) {
          final IndicatorContainer = spec.indicatorContainer;
          final Indicator = spec.indicator;
          final Container = spec.container;
          final Flex = spec.flex;
          final Label = spec.label;

          final iconData = widget.tristate && widget.selected == null
              ? widget.indeterminateIcon
              : widget.selected == true
                  ? widget.checkedIcon
                  : widget.uncheckedIcon;

          final checkbox = IndicatorContainer(
            child: iconData != null ? Indicator(icon: iconData) : null,
          );

          if (widget.label == null) {
            return checkbox;
          }

          return Container(
            child: Flex(
              direction: Axis.horizontal,
              children: [checkbox, Label(widget.label!)],
            ),
          );
        },
      ),
    );
  }
}

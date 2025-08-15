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
///   iconChecked: Icons.check_rounded,
///   label: 'Accept Terms',
/// )
/// ```
class RemixCheckbox extends StatefulWidget
    with Disableable, Selectable, Focusable {
  const RemixCheckbox({
    super.key,
    this.enabled = true,
    required this.selected,
    this.onChanged,
    this.iconChecked = Icons.check_rounded,
    this.iconUnchecked,
    this.style = const CheckboxStyle.create(),
    this.label,
    this.focusNode,
  });

  /// Whether the checkbox is enabled for interaction.
  final bool enabled;

  /// Whether the checkbox is currently selected.
  final bool selected;

  /// The icon to display when the checkbox is checked.
  final IconData iconChecked;

  /// The icon to display when the checkbox is unchecked.
  final IconData? iconUnchecked;

  /// The callback function that is called when the checkbox is tapped.
  final ValueChanged<bool>? onChanged;

  /// The style configuration for the checkbox.
  final CheckboxStyle style;

  /// An optional label that will be displayed next to the checkbox.
  final String? label;

  /// The focus node for the checkbox.
  final FocusNode? focusNode;

  @override
  State<RemixCheckbox> createState() => _RemixCheckboxState();
}

class _RemixCheckboxState extends State<RemixCheckbox>
    with WidgetStateMixin, DisableableMixin, SelectableMixin {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: widget.enabled && widget.onChanged != null
          ? (value) => widget.onChanged!(value ?? false)
          : null,
      onHoveredState: (state) => controller.hovered = state,
      onPressedState: (state) => controller.pressed = state,
      onFocusedState: (state) => controller.focused = state,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultCheckboxStyle.merge(widget.style),
        builder: (context, spec) {
          final iconData =
              widget.selected ? widget.iconChecked : widget.iconUnchecked;

          final checkbox = spec.indicatorContainer(
            child: iconData != null
                ? Icon(
                    iconData,
                    size: spec.indicator.size,
                    color: spec.indicator.color,
                  )
                : null,
          );

          if (widget.label == null) {
            return checkbox;
          }

          return spec.container(
            direction: Axis.horizontal,
            children: [checkbox, spec.label(widget.label!)],
          );
        },
      ),
    );
  }
}

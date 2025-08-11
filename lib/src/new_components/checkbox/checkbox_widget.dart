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
class RemixCheckbox extends StatefulWidget implements Disableable, Selectable {
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
  @override
  final bool enabled;

  /// Whether the checkbox is currently selected.
  @override
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
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: widget.enabled && widget.onChanged != null
          ? (value) => widget.onChanged!(value ?? false)
          : null,
      onHoverState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusState: (state) => stateController.focused = state,
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                checkbox,
                const SizedBox(width: 8),
                spec.label(widget.label!),
              ],
            ),
          );
        },
      ),
    );
  }
}

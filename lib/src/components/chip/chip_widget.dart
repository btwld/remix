part of 'chip.dart';

/// A customizable chip component.
///
/// ## Example
///
/// ```dart
/// RemixChip(
///   label: 'Category',
///   selected: _isSelected,
///   onChanged: (value) {
///     setState(() {
///       _isSelected = value;
///     });
///   },
///   onDeleted: () {
///     // Handle deletion
///   },
/// )
/// ```
class RemixChip extends StatefulWidget
    with HasEnabled, HasSelected, HasFocused {
  const RemixChip({
    super.key,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    @Deprecated('Use trailingIcon instead. Will be removed in next major version.')
    this.deleteIcon,
    this.onChanged,
    @Deprecated('Use onChanged instead. Will be removed in next major version.')
    this.onSelected,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.style = const RemixChipStyle.create(),
    this.focusNode,
    this.autofocus = false,
  }) : child = null;

  /// Creates a Remix chip with custom content.
  ///
  /// This constructor allows for custom chip content beyond the default layout.
  ///
  /// Example:
  /// ```dart
  /// RemixChip.raw(
  ///   child: Icon(Icons.star),
  ///   onChanged: (bool isSelected) {},
  ///   style: RemixChipStyle(),
  /// )
  /// ```
  const RemixChip.raw({
    super.key,
    required this.child,
    this.onChanged,
    @Deprecated('Use onChanged instead. Will be removed in next major version.')
    this.onSelected,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.style = const RemixChipStyle.create(),
    this.focusNode,
    this.autofocus = false,
  })  : label = '',
        leadingIcon = null,
        trailingIcon = null,
        deleteIcon = null;

  /// The text label for the chip.
  final String label;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Optional trailing icon. If onDeleted is provided but trailingIcon is null,
  /// defaults to Icons.close.
  final IconData? trailingIcon;

  /// Optional delete icon. If onDeleted is provided but deleteIcon is null,
  /// defaults to Icons.close.
  @Deprecated('Use trailingIcon instead. Will be removed in next major version.')
  final IconData? deleteIcon;

  /// Custom child widget for raw constructor.
  final Widget? child;

  /// Called when the user taps the chip.
  final ValueChanged<bool>? onChanged;

  /// Called when the user taps the chip.
  @Deprecated('Use onChanged instead. Will be removed in next major version.')
  final ValueChanged<bool>? onSelected;

  /// Called when the user taps the delete icon.
  final VoidCallback? onDeleted;

  /// Whether this chip is selected.
  final bool selected;

  /// Whether this chip is enabled.
  final bool enabled;

  /// The style configuration for the chip.
  final RemixChipStyle style;

  /// The focus node for the chip.
  final FocusNode? focusNode;

  /// Whether the chip should automatically request focus when it is created.
  final bool autofocus;

  @override
  State<RemixChip> createState() => _RemixChipState();
}

class _RemixChipState extends State<RemixChip>
    with HasWidgetStateController, HasEnabledState, HasSelectedState {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => (widget.onChanged ?? widget.onSelected)?.call(value ?? false),
      onHoverChange: (state) => controller.hovered = state,
      onPressChange: (state) => controller.pressed = state,
      onFocusChange: (state) => controller.focused = state,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: StyleBuilder(
        style: DefaultRemixChipStyle.merge(widget.style),
        controller: controller,
        builder: (context, spec) {
          // If custom child is provided, use it directly
          if (widget.child != null) {
            return spec.container(
              direction: Axis.horizontal,
              children: [widget.child!],
            );
          }

          // Otherwise build standard chip layout
          final children = <Widget>[];

          // Leading icon
          if (widget.leadingIcon != null) {
            children.add(Icon(
              widget.leadingIcon,
              size: spec.leadingIcon.size,
              color: spec.leadingIcon.color,
            ));
          }

          // Label
          if (widget.label.isNotEmpty) {
            children.add(spec.label(widget.label));
          }

          // Delete icon
          if (widget.onDeleted != null) {
            children.add(GestureDetector(
              onTap: widget.enabled ? widget.onDeleted : null,
              child: Icon(
                widget.trailingIcon ?? widget.deleteIcon ?? Icons.close,
                size: spec.trailingIcon.size,
                color: spec.trailingIcon.color,
              ),
            ));
          }

          return spec.container(
            direction: Axis.horizontal,
            children: children,
          );
        },
      ),
    );
  }
}

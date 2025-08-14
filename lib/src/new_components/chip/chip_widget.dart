part of 'chip.dart';

/// A customizable chip component.
///
/// ## Example
///
/// ```dart
/// RemixChip(
///   label: 'Category',
///   selected: _isSelected,
///   onSelected: (value) {
///     setState(() {
///       _isSelected = value;
///     });
///   },
///   onDeleted: () {
///     // Handle deletion
///   },
/// )
/// ```
class RemixChip extends StatefulWidget implements Disableable, Selectable {
  const RemixChip({
    super.key,
    required this.label,
    IconData? leadingIcon,
    IconData? deleteIcon,
    @Deprecated('Use leadingIcon instead') IconData? iconLeft,
    @Deprecated('Use deleteIcon instead') IconData? iconRight,
    ValueChanged<bool>? onSelected,
    @Deprecated('Use onSelected instead') ValueChanged<bool>? onChanged,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.style = const ChipStyle.create(),
    this.focusNode,
  })  : leadingIcon = leadingIcon ?? iconLeft,
        deleteIcon = deleteIcon ?? iconRight,
        onSelected = onSelected ?? onChanged,
        child = null;

  /// Creates a Remix chip with custom content.
  ///
  /// This constructor allows for custom chip content beyond the default layout.
  ///
  /// Example:
  /// ```dart
  /// RemixChip.raw(
  ///   child: Icon(Icons.star),
  ///   onSelected: (bool isSelected) {},
  ///   style: ChipStyle(),
  /// )
  /// ```
  const RemixChip.raw({
    super.key,
    required this.child,
    this.onSelected,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.style = const ChipStyle.create(),
    this.focusNode,
  })  : label = '',
        leadingIcon = null,
        deleteIcon = null;

  /// The text label for the chip.
  final String label;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Optional delete icon. If onDeleted is provided but deleteIcon is null,
  /// defaults to Icons.close.
  final IconData? deleteIcon;

  /// Custom child widget for raw constructor.
  final Widget? child;

  /// Called when the user taps the chip.
  final ValueChanged<bool>? onSelected;

  /// Called when the user taps the delete icon.
  final VoidCallback? onDeleted;

  /// Whether this chip is selected.
  @override
  final bool selected;

  /// Whether this chip is enabled.
  @override
  final bool enabled;

  /// The style configuration for the chip.
  final ChipStyle style;

  /// The focus node for the chip.
  final FocusNode? focusNode;

  @override
  State<RemixChip> createState() => _RemixChipState();
}

class _RemixChipState extends State<RemixChip>
    with MixControllerMixin, DisableableMixin, SelectableMixin {
  @override
  Widget build(BuildContext context) {
    return NakedCheckbox(
      value: widget.selected,
      onChanged: (value) => widget.onSelected?.call(value ?? false),
      onHoveredState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusedState: (state) => stateController.focused = state,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultChipStyle.merge(widget.style),
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
                  widget.deleteIcon ?? Icons.close,
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
          controller: stateController,
        ),
    );
  }
}
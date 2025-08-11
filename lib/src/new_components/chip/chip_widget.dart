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
    this.leadingIcon,
    this.deleteIcon,
    this.onSelected,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.style = const ChipStyle.create(),
    this.focusNode,
  });

  /// The text label for the chip.
  final String label;

  /// Optional leading icon.
  final IconData? leadingIcon;

  /// Optional delete icon. If onDeleted is provided but deleteIcon is null,
  /// defaults to Icons.close.
  final IconData? deleteIcon;

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
  void _handleTap() {
    if (widget.enabled && widget.onSelected != null) {
      widget.onSelected!(!widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: MouseRegion(
        onEnter: (_) => stateController.hovered = true,
        onExit: (_) => stateController.hovered = false,
        child: StyleBuilder(
          style: DefaultChipStyle.merge(widget.style),
          builder: (context, spec) {
            final children = <Widget>[];

            // Leading icon
            if (widget.leadingIcon != null) {
              children.add(Icon(
                widget.leadingIcon,
                size: spec.leadingIcon.size,
                color: spec.leadingIcon.color,
              ));
              children.add(const SizedBox(width: 4));
            }

            // Label
            children.add(spec.label(widget.label));

            // Delete icon
            if (widget.onDeleted != null) {
              children.add(const SizedBox(width: 4));
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            );
          },
        ),
      ),
    );
  }
}
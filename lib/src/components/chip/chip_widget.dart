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
    with HasEnabled, HasSelected {
  const RemixChip({
    super.key,
    this.label,
    this.leading,
    this.trailing,
    this.onChanged,
    this.onDeleted,
    this.selected = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.style = const RemixChipStyle.create(),
    this.focusNode,
    this.autofocus = false,
    this.child,
  }) : assert(
          label != null || child != null,
          'Must provide either label or child',
        );

  /// The text label for the chip.
  final String? label;

  /// Optional leading icon.
  final IconData? leading;

  /// Optional trailing icon. If onDeleted is provided but trailing is null,
  /// defaults to Icons.close.
  final IconData? trailing;

  /// Custom child widget that overrides the default label and icon layout.
  final Widget? child;

  /// Called when the user taps the chip.
  final ValueChanged<bool>? onChanged;

  /// Called when the user taps the delete icon.
  final VoidCallback? onDeleted;

  /// Whether this chip is selected.
  final bool selected;

  /// Whether this chip is enabled.
  final bool enabled;

  /// Whether to provide haptic feedback when the chip is toggled.
  /// Defaults to true.
  final bool enableFeedback;

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
    return StyleBuilder(
      style: RemixChipStyles.defaultStyle.merge(widget.style),
      controller: controller,
      builder: (context, spec) {
        final Container = spec.container.createWidget;
        final Icon = spec.icon.createWidget;
        final Label = spec.label.createWidget;

        // Use custom child if provided
        if (widget.child != null) {
          final chipChild = Container(
            direction: Axis.horizontal,
            children: [widget.child!],
          );
          
          return NakedCheckbox(
            value: widget.selected,
            onChanged: (value) => widget.onChanged?.call(value ?? false),
            enabled: widget.enabled,
            enableFeedback: widget.enableFeedback,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            statesController: controller,
            child: chipChild,
          );
        }

        // Build chip content progressively
        final children = <Widget>[];

        // Add leading icon
        if (widget.leading != null) {
          children.add(Icon(icon: widget.leading!));
        }

        // Add label
        if (widget.label != null) {
          children.add(Label(widget.label!));
        }

        // Add delete button
        if (widget.onDeleted != null) {
          children.add(GestureDetector(
            onTap: widget.enabled ? widget.onDeleted : null,
            child: Icon(icon: widget.trailing ?? Icons.close),
          ));
        }

        final chipChild = Container(
          direction: Axis.horizontal,
          children: children,
        );

        return NakedCheckbox(
          value: widget.selected,
          onChanged: (value) => widget.onChanged?.call(value ?? false),
          enabled: widget.enabled,
          enableFeedback: widget.enableFeedback,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          statesController: controller,
          child: chipChild,
        );
      },
    );
  }
}

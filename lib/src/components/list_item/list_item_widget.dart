part of 'list_item.dart';

/// A customizable list item component.
///
/// ## Example
///
/// ```dart
/// RemixListItem(
///   title: 'Item Title',
///   subtitle: 'Item subtitle',
///   leading: Icon(Icons.folder),
///   trailing: Icon(Icons.arrow_forward_ios),
///   onTap: () {
///     // Handle tap
///   },
/// )
/// ```
class RemixListItem extends StatefulWidget {
  const RemixListItem({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPress,
    this.enabled = true,
    this.focusNode,
    this.enableHapticFeedback = true,
    this.style = const ListItemStyle.create(),
  });

  /// The primary content of the list item.
  final String? title;

  /// The secondary content of the list item.
  final String? subtitle;

  /// A widget to display before the title.
  final Widget? leading;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Called when the user presses this list item.
  final VoidCallback? onPress;
  
  /// Whether this list item is enabled.
  final bool enabled;
  
  /// The focus node for the list item.
  final FocusNode? focusNode;
  
  /// Whether to provide haptic feedback when pressed.
  final bool enableHapticFeedback;

  /// The style configuration for the list item.
  final ListItemStyle style;

  @override
  State<RemixListItem> createState() => _RemixListItemState();
}

class _RemixListItemState extends State<RemixListItem>
    with MixControllerMixin {
  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: widget.onPress,
      onHoveredState: (state) => stateController.hovered = state,
      onPressedState: (state) => stateController.pressed = state,
      onFocusedState: (state) => stateController.focused = state,
      onDisabledState: (state) => stateController.disabled = state,
      enabled: widget.enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      child: StyleBuilder(
        style: DefaultListItemStyle.merge(widget.style),
        builder: (context, spec) {
          final children = <Widget>[];

          // Leading widget
          if (widget.leading != null) {
            children.add(
              IconTheme(
                data: IconThemeData(
                  size: spec.leadingIcon.size,
                  color: spec.leadingIcon.color,
                ),
                child: widget.leading!,
              ),
            );
          }

          // Title and subtitle
          final textWidgets = <Widget>[];
          if (widget.title != null) {
            textWidgets.add(spec.title(widget.title!));
          }
          if (widget.subtitle != null) {
            textWidgets.add(spec.subtitle(widget.subtitle!));
          }

          if (textWidgets.isNotEmpty) {
            children.add(
              Expanded(
                child: spec.contentContainer(
                  direction: Axis.vertical,
                  children: textWidgets,
                ),
              ),
            );
          }

          // Trailing widget
          if (widget.trailing != null) {
            children.add(
              IconTheme(
                data: IconThemeData(
                  size: spec.trailingIcon.size,
                  color: spec.trailingIcon.color,
                ),
                child: widget.trailing!,
              ),
            );
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

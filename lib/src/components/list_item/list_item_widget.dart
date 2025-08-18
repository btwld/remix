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
///   onPressed: () {
///     // Handle press
///   },
/// )
/// ```
class RemixListItem extends StatefulWidget with HasFocused {
  const RemixListItem({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.enableHapticFeedback = true,
    this.style = const RemixListItemStyle.create(),
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
  final VoidCallback? onPressed;

  /// Whether this list item is enabled.
  final bool enabled;

  /// The focus node for the list item.
  final FocusNode? focusNode;

  /// Whether the list item should automatically request focus when it is created.
  final bool autofocus;

  /// Whether to provide haptic feedback when pressed.
  final bool enableHapticFeedback;

  /// The style configuration for the list item.
  final RemixListItemStyle style;

  @override
  State<RemixListItem> createState() => _RemixListItemState();
}

class _RemixListItemState extends State<RemixListItem>
    with HasWidgetStateController {
  @override
  Widget build(BuildContext context) {
    return NakedButton(
      onPressed: widget.onPressed,
      onHoverChange: (state) => controller.hovered = state,
      onPressChange: (state) => controller.pressed = state,
      onFocusChange: (state) => controller.focused = state,
      enabled: widget.enabled,
      enableHapticFeedback: widget.enableHapticFeedback,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      child: StyleBuilder(
        style: DefaultRemixListItemStyle.merge(widget.style),
        controller: controller,
        builder: (context, spec) {
          final Container = spec.container;
          final ContentContainer = spec.contentContainer;
          final Title = spec.title;
          final Subtitle = spec.subtitle;

          final children = <Widget>[];

          // Leading widget
          if (widget.leading != null) {
            children.add(widget.leading!);
          }

          // Title and subtitle
          final textWidgets = <Widget>[];
          if (widget.title != null) {
            textWidgets.add(Title(widget.title!));
          }
          if (widget.subtitle != null) {
            textWidgets.add(Subtitle(widget.subtitle!));
          }

          if (textWidgets.isNotEmpty) {
            children.add(
              Expanded(
                child: ContentContainer(
                  direction: Axis.vertical,
                  children: textWidgets,
                ),
              ),
            );
          }

          // Trailing widget
          if (widget.trailing != null) {
            children.add(widget.trailing!);
          }

          return Container(direction: Axis.horizontal, children: children);
        },
      ),
    );
  }
}

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
class RemixListItem extends StatefulWidget {
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
    this.enableFeedback = true,
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

  /// Whether to provide acoustic and/or haptic feedback when pressed.
  final bool enableFeedback;

  /// The style configuration for the list item.
  final RemixListItemStyle style;

  @override
  State<RemixListItem> createState() => _RemixListItemState();
}

class _RemixListItemState extends State<RemixListItem>
    with HasWidgetStateController {
  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RemixListItemStyles.defaultStyle.merge(widget.style),
      controller: controller,
      builder: (context, spec) {
        final Container = spec.container.createWidget;
        final ContentContainer = spec.contentContainer.createWidget;
        final Title = spec.title.createWidget;
        final Subtitle = spec.subtitle.createWidget;

        final children = <Widget>[];

        // Leading widget
        if (widget.leading != null) {
          children.add(widget.leading!);
        }

        // Title and subtitle content
        final textWidgets = <Widget>[];
        if (widget.title != null) {
          textWidgets.add(Title(widget.title!));
        }
        if (widget.subtitle != null) {
          textWidgets.add(Subtitle(widget.subtitle!));
        }

        if (textWidgets.isNotEmpty) {
          children.add(
            // ignore: avoid-flexible-outside-flex
            Expanded(
              child: ContentContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < textWidgets.length; i++) ...[
                      textWidgets[i],
                      if (i < textWidgets.length - 1) const SizedBox(height: 2),
                    ],
                  ],
                ),
              ),
            ),
          );
        }

        // Trailing widget
        if (widget.trailing != null) {
          children.add(widget.trailing!);
        }

        // Create list item with Row layout
        final listItemChild = Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1 && !(children[i] is Expanded))
                  const SizedBox(width: 16),
              ],
            ],
          ),
        );

        return NakedButton(
          onPressed: widget.onPressed,
          enabled: widget.enabled,
          enableFeedback: widget.enableFeedback,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          statesController: controller,
          child: listItemChild,
        );
      },
    );
  }
}

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
class RemixListItem extends StatelessWidget {
  const RemixListItem({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
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

  /// Called when the user taps this list item.
  final VoidCallback? onTap;

  /// The style configuration for the list item.
  final ListItemStyle style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: StyleBuilder(
        style: DefaultListItemStyle.merge(style),
        builder: (context, spec) {
          final children = <Widget>[];

          // Leading widget
          if (leading != null) {
            children.add(
              IconTheme(
                data: IconThemeData(
                  size: spec.leadingIcon.size,
                  color: spec.leadingIcon.color,
                ),
                child: leading!,
              ),
            );
            children.add(const SizedBox(width: 16));
          }

          // Title and subtitle
          final textWidgets = <Widget>[];
          if (title != null) {
            textWidgets.add(spec.title(title!));
          }
          if (subtitle != null) {
            textWidgets.add(spec.subtitle(subtitle!));
          }

          if (textWidgets.isNotEmpty) {
            children.add(
              Expanded(
                child: spec.contentContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: textWidgets,
                  ),
                ),
              ),
            );
          }

          // Trailing widget
          if (trailing != null) {
            if (textWidgets.isNotEmpty) {
              children.add(const SizedBox(width: 16));
            }
            children.add(
              IconTheme(
                data: IconThemeData(
                  size: spec.trailingIcon.size,
                  color: spec.trailingIcon.color,
                ),
                child: trailing!,
              ),
            );
          }

          return spec.container(child: Row(children: children));
        },
      ),
    );
  }
}

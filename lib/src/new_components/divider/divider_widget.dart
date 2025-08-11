part of 'divider.dart';

/// A divider is a thin line that groups content in lists and layouts.
///
/// Dividers help to organize content by visually separating it into groups.
///
/// This example shows how to use a [RemixDivider] in a list of items.
///
/// ```dart
/// Column(
///   children: const <Widget>[
///     Text('Item 1'),
///     RemixDivider(),
///     Text('Item 2'),
///     RemixDivider(),
///     Text('Item 3'),
///   ],
/// )
/// ```
class RemixDivider extends StatelessWidget {
  /// Creates a Remix divider.
  const RemixDivider({super.key, this.style = const DividerStyle.create()});

  /// The style configuration for the divider.
  final DividerStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultDividerStyle.merge(style),
      builder: (context, spec) {
        return spec.container();
      },
    );
  }
}

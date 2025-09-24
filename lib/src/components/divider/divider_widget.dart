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
class RemixDivider extends StyleWidget<DividerSpec> {
  /// Creates a Remix divider.
  const RemixDivider({
    super.style = const RemixDividerStyle.create(),
    super.styleSpec,
    super.key,
  });

  @override
  Widget build(BuildContext context, DividerSpec spec) {
    return Box(styleSpec: spec.container);
  }
}

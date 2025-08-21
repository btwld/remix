part of 'callout.dart';

/// The [RemixCallout] widget is used to display a message with an optional icon.
/// It can be customized using the [style] parameter to fit different design needs.
///
/// ## Example
///
/// ```dart
/// RemixCallout(
///   text: 'This is a callout message!',
///   icon: Icons.info,
/// )
/// ```
class RemixCallout extends StatelessWidget {
  /// Creates a callout widget with text and optional icon.
  RemixCallout({
    super.key,
    IconData? icon,
    required String text,
    this.style = const RemixCalloutStyle.create(),
  }) : child = RemixLabel(text, leading: icon);

  /// This constructor allows for more advanced customization by directly providing a [child] widget.
  const RemixCallout.raw({
    super.key,
    this.style = const RemixCalloutStyle.create(),
    required this.child,
  });

  /// The style configuration for the callout.
  final RemixCalloutStyle style;

  /// The child widget to display in the callout.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultRemixCalloutStyle.merge(style),
      builder: (context, spec) {
        final Container = spec.container;

        return Container(child: child);
      },
    );
  }
}

part of 'card.dart';

/// A Material Design card component.
///
/// A card is a sheet of Material used to represent some related information,
/// for example an album, a geographical location, a meal, contact details, etc.
///
/// This is a Remix version of the standard Material Card widget, with customizable styling.
///
/// ## Example
///
/// ```dart
/// RemixCard(
///   child: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Text('This is a card'),
///   ),
/// )
/// ```
class RemixCard extends StatelessWidget {
  /// Creates a Material Design card.
  const RemixCard({
    super.key,
    this.child,
    this.style = const RemixCardStyle.create(),
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// The style configuration for the card.
  final RemixCardStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RemixCardStyles.baseStyle.merge(style),
      builder: (context, spec) {
        final Container = spec.container.createWidget;

        return Container(child: child);
      },
    );
  }
}

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
class RemixCard extends StyleWidget<CardSpec> {
  /// Creates a Material Design card.
  const RemixCard({
    super.style = const RemixCardStyle.create(),
    super.styleSpec,
    super.key,
    this.child,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  Widget build(BuildContext context, CardSpec spec) {
    return Box(styleSpec: spec.container, child: child);
  }
}

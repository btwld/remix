part of 'card.dart';

/// A styled surface for related content.
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
  /// Creates a card.
  const RemixCard({
    super.key,
    this.child,
    this.style = const CardStyler.create(),
    this.styleSpec,
  });

  static final styleFrom = CardStyler.new;

  /// The widget below this widget in the tree.
  ///
  /// This widget can only have one child. To lay out multiple children, let this widget's child be a widget such as [RowBox], [ColumnBox], or [StackBox], which have a children property, and then provide the children to that widget.
  final Widget? child;

  /// The style configuration for the card.
  final CardStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final CardSpec? styleSpec;

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<CardSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        return RemixBoxAdapter(
          styleSpec: spec.container,
          containerEffects: spec.containerEffects,
          child: child,
        );
      },
    );
  }
}

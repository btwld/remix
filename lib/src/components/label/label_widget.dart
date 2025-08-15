part of 'label.dart';

/// A customizable label component that supports icons and styling.
///
/// The [RemixLabel] widget is designed to display text with optional icons.
/// It integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Examples
///
/// ```dart
/// // Basic label
/// RemixLabel('Hello World')
///
/// // Label with icon
/// RemixLabel(
///   'Settings',
///   icon: Icons.settings,
///   style: RemixLabelStyles.primary,
/// )
///
/// // Custom styling
/// RemixLabel(
///   'Custom',
///   style: RemixLabelStyle(
///     spacing: 12,
///     label: TextMix(style: TextStyleMix(color: Colors.blue)),
///     icon: IconMix(color: Colors.blue, size: 20),
///   ),
/// )
/// ```
class RemixLabel extends StatelessWidget {
  /// Creates a Remix label.
  ///
  /// The [label] parameter is required.
  /// Other parameters allow customizing the label's appearance.
  const RemixLabel(
    this.label, {
    super.key,
    this.icon,
    this.style = const RemixLabelStyle.create(),
  });

  /// The text to display in the label.
  final String label;

  /// Optional icon to display alongside the text.
  final IconData? icon;

  /// The style configuration for the label.
  final RemixLabelStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: style,
      builder: (context, spec) {
        final children = <Widget>[spec.label(label)];

        if (icon != null) {
          children.insert(
            spec.iconPosition == IconPosition.start ? 0 : children.length,
            spec.icon(icon: icon),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          spacing: spec.spacing,
          children: children,
        );
      },
    );
  }
}

part of 'callout.dart';

/// The [RemixCallout] widget is used to display a message.
/// It can be customized using the [style] parameter to fit different design needs.
///
/// ## Example
///
/// ```dart
/// RemixCallout(
///   text: 'This is a callout message!',
/// )
/// ```
class RemixCallout extends StatelessWidget {
  /// Creates a callout widget with optional text, icon, or custom [child]. At
  /// least one of [text] or [child] must be provided.
  RemixCallout({
    super.key,
    String? text,
    this.icon,
    Widget? child,
    this.style = const RemixCalloutStyle.create(),
  })  : text = text,
        child = child,
        assert(text != null || child != null,
            'Provide either text or child to RemixCallout.');

  /// The text to display in the callout.
  final String? text;

  /// The icon to display in the callout.
  final IconData? icon;

  /// The style configuration for the callout.
  final RemixCalloutStyle style;

  /// Optional custom child content for the callout body.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder<CalloutSpec>(
      style: style,
      builder: (context, spec) {
        final ContainerWidget = spec.container.createWidget;
        final TextWidget = spec.text.createWidget;
        final IconWidget = spec.icon.createWidget;

        // For raw constructor, use provided child directly
        if (child != null) {
          return ContainerWidget(
            direction: Axis.horizontal,
            children: [child!],
          );
        }

        // Build the callout content with text and optional icon
        final List<Widget> children = [];

        // Add icon if present
        if (icon != null) {
          children.add(IconWidget(icon: icon));
        }

        // Add text if present
        if (text?.isNotEmpty == true) {
          children.add(TextWidget(text!));
        }

        return ContainerWidget(direction: Axis.horizontal, children: children);
      },
    );
  }
}

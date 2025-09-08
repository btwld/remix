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
  /// Creates a callout widget with text and optional icon.
  const RemixCallout({
    super.key,
    required this.text,
    this.icon,
    this.style = const RemixCalloutStyle.create(),
  }) : child = null;

  /// This constructor allows for more advanced customization by directly providing a [child] widget.
  const RemixCallout.raw({
    super.key,
    this.style = const RemixCalloutStyle.create(),
    required this.child,
  }) : text = null,
       icon = null;

  /// The text to display in the callout.
  final String? text;

  /// The icon to display in the callout.
  final IconData? icon;

  /// The style configuration for the callout.
  final RemixCalloutStyle style;

  /// The child widget to display in the callout (used by .raw constructor).
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder<CalloutSpec>(
      style: RemixCalloutStyles.baseStyle.merge(style),
      builder: (context, spec) {
        final ContainerWidget = spec.container.createWidget;
        final TextWidget = spec.text.createWidget;
        final IconWidget = spec.icon.createWidget;

        // For raw constructor, use provided child directly
        if (child != null) {
          return ContainerWidget(direction: Axis.horizontal, children: [child!]);
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

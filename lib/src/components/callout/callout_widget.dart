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
class RemixCallout extends StyleWidget<CalloutSpec> {
  /// Creates a callout widget with optional text, icon, or custom [child]. At
  /// least one of [text] or [child] must be provided.
  RemixCallout({
    super.style = const RemixCalloutStyle.create(),
    super.styleSpec,
    super.key,
    String? text,
    this.icon,
    Widget? child,
  })  : text = text,
        child = child,
        assert(text != null || child != null,
            'Provide either text or child to RemixCallout.');

  /// The text to display in the callout.
  final String? text;

  /// The icon to display in the callout.
  final IconData? icon;

  /// Optional custom child content for the callout body.
  final Widget? child;

  @override
  Widget build(BuildContext context, CalloutSpec spec) {
    // For raw constructor, use provided child directly
    if (child != null) {
      return RowBox(styleSpec: spec.container, children: [child!]);
    }

    // Build the callout content with text and optional icon
    final List<Widget> children = [];

    // Add icon if present
    if (icon != null) {
      children.add(StyledIcon(icon: icon, styleSpec: spec.icon));
    }

    // Add text if present
    if (text?.isNotEmpty == true) {
      children.add(StyledText(text!, styleSpec: spec.text));
    }

    return RowBox(styleSpec: spec.container, children: children);
  }
}

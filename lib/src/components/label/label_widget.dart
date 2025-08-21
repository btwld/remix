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
/// // Label with leading icon
/// RemixLabel(
///   'Settings',
///   leading: Icons.settings,
///   style: RemixLabelStyles.primary,
/// )
///
/// // Custom styling
/// RemixLabel(
///   'Custom',
///   style: RemixLabelStyle(
///     spacing: 12,
///     label: TextMix(style: TextStyleMix(color: Colors.blue)),
///     leading: IconMix(color: Colors.blue, size: 20),
///   ),
/// )
/// ```
class RemixLabel extends StyleWidget<LabelSpec> {
  /// Creates a Remix label.
  ///
  /// The [label] parameter is required.
  /// Other parameters allow customizing the label's appearance.
  const RemixLabel(
    this.label, {
    super.key,
    this.leading,
    this.trailing,
    super.style = const RemixLabelStyle.create(),
  });

  /// The text to display in the label.f
  final String label;

  /// Optional icon to display at the start/left of the text.
  final IconData? leading;

  /// Optional icon to display at the end/right of the text.
  final IconData? trailing;

  @override
  Widget build(BuildContext context, LabelSpec spec) {
    return createLabelWidget(
      spec,
      text: label,
      leading: leading,
      trailing: trailing,
    );
  }
}

Widget createLabelWidget(
  LabelSpec spec, {
  required String text,
  IconData? leading,
  IconData? trailing,
}) {
  final TextWidget = spec.label;
  final LeadingIconWidget = spec.leading;
  final TrailingIconWidget = spec.trailing;

  final children = <Widget>[];

  // Add leading icon
  if (leading != null) {
    children.add(LeadingIconWidget(icon: leading));
  }

  // Add text
  children.add(TextWidget(text));

  // Add trailing icon
  if (trailing != null) {
    children.add(TrailingIconWidget(icon: trailing));
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    spacing: spec.spacing,
    children: children,
  );
}

/// Extension on LabelSpec to provide call() method for creating widgets
extension LabelSpecWidget on LabelSpec {
  /// Renders the LabelSpec into a Row widget with text and optional icons
  Widget call({
    required String text,
    IconData? leading,
    IconData? trailing,
  }) {
    return createLabelWidget(
      this,
      text: text,
      leading: leading,
      trailing: trailing,
    );
  }
}

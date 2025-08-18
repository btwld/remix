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
///   leadingIcon: Icons.settings,
///   style: RemixLabelStyles.primary,
/// )
///
/// // Custom styling
/// RemixLabel(
///   'Custom',
///   style: RemixLabelStyle(
///     spacing: 12,
///     label: TextMix(style: TextStyleMix(color: Colors.blue)),
///     leadingIcon: IconMix(color: Colors.blue, size: 20),
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
    this.leadingIcon,
    this.trailingIcon,
    super.style = const RemixLabelStyle.create(),
  });

  /// The text to display in the label.f
  final String label;

  /// Optional icon to display at the start/left of the text.
  final IconData? leadingIcon;

  /// Optional icon to display at the end/right of the text.
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context, LabelSpec spec) {
    return createLabelWidget(
      spec,
      text: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );
  }
}

Widget createLabelWidget(
  LabelSpec spec, {
  required String text,
  IconData? leadingIcon,
  IconData? trailingIcon,
}) {
  final TextWidget = spec.label;
  final LeadingIconWidget = spec.leadingIcon;
  final TrailingIconWidget = spec.trailingIcon;

  final children = <Widget>[];

  // Add leading icon
  if (leadingIcon != null) {
    children.add(LeadingIconWidget(icon: leadingIcon));
  }

  // Add text
  children.add(TextWidget(text));

  // Add trailing icon
  if (trailingIcon != null) {
    children.add(TrailingIconWidget(icon: trailingIcon));
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
    IconData? leadingIcon,
    IconData? trailingIcon,
  }) {
    return createLabelWidget(
      this,
      text: text,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
    );
  }
}

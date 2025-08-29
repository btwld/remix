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
///     label: TextStyling(style: TextStyleMix(color: RemixTokens.primary())),
///     leading: IconStyle(color: RemixTokens.primary(), size: 20),
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
  final FlexWidget = spec.flex;

  return FlexWidget(
    children: [
      if (leading != null) LeadingIconWidget(icon: leading),
      TextWidget(text),
      if (trailing != null) TrailingIconWidget(icon: trailing),
    ],
  );
}

/// Extension on LabelSpec to provide call() method for creating widgets
extension LabelSpecWidget on LabelSpec {
  /// Renders the LabelSpec into a Flex widget with text and optional icons
  Widget call({required String text, IconData? leading, IconData? trailing}) {
    return createLabelWidget(
      this,
      text: text,
      leading: leading,
      trailing: trailing,
    );
  }
}

/// Extension on WidgetSpec<LabelSpec> to provide call() method for creating widgets
extension LabelSpecWrappedWidget on WidgetSpec<LabelSpec> {
  Widget call({required String text, IconData? leading, IconData? trailing}) {
    return WidgetSpecBuilder(
      wrappedSpec: this,
      builder: (context, spec) {
        return createLabelWidget(
          spec,
          text: text,
          leading: leading,
          trailing: trailing,
        );
      },
    );
  }
}

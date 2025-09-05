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
/// // Label with icon at leading position
/// RemixLabel(
///   'Settings',
///   icon: Icons.settings,
///   style: RemixLabelStyles.primary,
/// )
///
/// // Label with icon at trailing position
/// RemixLabel(
///   'Next',
///   icon: Icons.arrow_forward,
///   iconPosition: IconPosition.trailing,
/// )
///
/// // Custom styling
/// RemixLabel(
///   'Custom',
///   style: RemixLabelStyle(
///     spacing: 12,
///     label: TextStyler(style: TextStyleMix(color: RemixTokens.primary())),
///     icon: IconStyler(color: RemixTokens.primary(), size: 20),
///   ),
/// )
/// ```
class RemixLabel extends StyleWidget<LabelSpec> {
  /// Creates a Remix label with optional builders.
  ///
  /// The [label] parameter is required.
  /// Other parameters allow customizing the label's appearance.
  const RemixLabel(
    String label, {
    super.key,
    this.icon,
    this.textBuilder,
    this.iconBuilder,
    this.builder,
    super.style = const RemixLabelStyle.create(),
  }) : label = label;

  /// The text to display in the label.
  final String label;

  /// Optional icon to display with the label.
  final IconData? icon;

  /// Builder for customizing the text rendering.
  final RemixTextBuilder? textBuilder;

  /// Builder for customizing the icon rendering.
  final RemixIconBuilder? iconBuilder;

  /// Full builder for complete control over label rendering.
  final RemixLabelBuilder? builder;

  @override
  Widget build(BuildContext context, LabelSpec spec) {
    // Full builder takes precedence
    if (builder != null) {
      return builder!(context, spec, label);
    }

    // Delegate to _buildLabel with builders
    return _buildLabel(
      spec,
      text: label,
      icon: icon,
      textBuilder: textBuilder,
      iconBuilder: iconBuilder,
    );
  }
}

Widget _buildLabel(
  LabelSpec spec, {
  required String text,
  IconData? icon,
  RemixTextBuilder? textBuilder,
  RemixIconBuilder? iconBuilder,
}) {
  final TextWidget = spec.label.createWidget;
  final IconWidget = spec.icon.createWidget;
  final FlexWidget = spec.flex.createWidget;

  // Text widget
  final Widget textWidget = textBuilder != null
      ? StyleSpecBuilder(
          styleSpec: spec.label,
          builder: (context, spec) => textBuilder(context, spec, text),
        )
      : TextWidget(text);

  // Icon widget: if a builder exists, always call it (even when icon is null)
  final Widget? iconWidget = iconBuilder != null
      ? StyleSpecBuilder(
          styleSpec: spec.icon,
          builder: (context, iconSpec) =>
              iconBuilder(context, iconSpec, icon, spec.iconPosition),
        )
      : (icon != null ? IconWidget(icon: icon) : null);

  // Arrange children based on icon position from spec
  final List<Widget> children = spec.iconPosition == IconPosition.leading
      ? [if (iconWidget != null) iconWidget, textWidget]
      : [textWidget, if (iconWidget != null) iconWidget];

  return FlexWidget(children: children);
}

/// Extension on LabelSpec to provide createWidget method for creating widgets
extension LabelSpecWidget on LabelSpec {
  /// Renders the LabelSpec into a Flex widget with text and optional icon
  Widget createWidget(
    String text, {
    IconData? icon,
    RemixTextBuilder? textBuilder,
    RemixIconBuilder? iconBuilder,
  }) {
    return Builder(
      builder: (context) => _buildLabel(
        this,
        text: text,
        icon: icon,
        textBuilder: textBuilder,
        iconBuilder: iconBuilder,
      ),
    );
  }
}

/// Extension on StyleSpec<LabelSpec> to provide createWidget method for creating widgets
extension LabelSpecWrappedWidget on StyleSpec<LabelSpec> {
  Widget createWidget(
    String text, {
    IconData? icon,
    RemixTextBuilder? textBuilder,
    RemixIconBuilder? iconBuilder,
  }) {
    return StyleSpecBuilder(
      styleSpec: this,
      builder: (context, spec) {
        return _buildLabel(
          spec,
          text: text,
          icon: icon,
          textBuilder: textBuilder,
          iconBuilder: iconBuilder,
        );
      },
    );
  }
}

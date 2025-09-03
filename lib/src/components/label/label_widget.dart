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
    this.iconPosition = IconPosition.leading,
    this.textBuilder,
    this.iconBuilder,
    this.builder,
    super.style = const RemixLabelStyle.create(),
  }) : label = label;

  /// The text to display in the label.
  final String label;

  /// Optional icon to display with the label.
  final IconData? icon;

  /// Position of the icon relative to the text.
  final IconPosition iconPosition;

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
      context,
      spec,
      text: label,
      icon: icon,
      iconPosition: iconPosition,
      textBuilder: textBuilder,
      iconBuilder: iconBuilder,
    );
  }
}

Widget _buildLabel(
  BuildContext context,
  LabelSpec spec, {
  required String text,
  IconData? icon,
  IconPosition iconPosition = IconPosition.leading,
  RemixTextBuilder? textBuilder,
  RemixIconBuilder? iconBuilder,
}) {
  final textFactory = spec.label;
  final iconFactory = spec.icon;
  final flexFactory = spec.flex.createWidget;

  // Text widget
  final Widget textWidget = textBuilder != null
      ? textBuilder(context, textFactory.spec, text)
      : textFactory.createWidget(text);

  // Icon widget: if a builder exists, always call it (even when icon is null)
  final Widget? iconWidget = iconBuilder != null
      ? iconBuilder(context, iconFactory.spec, icon, iconPosition)
      : (icon != null ? iconFactory.createWidget(icon: icon) : null);

  // Arrange children based on icon position
  final List<Widget> children = iconPosition == IconPosition.leading
      ? [
          if (iconWidget != null) iconWidget,
          textWidget
        ]
      : [
          textWidget,
          if (iconWidget != null) iconWidget
        ];

  return flexFactory(children: children);
}

/// Extension on LabelSpec to provide createWidget method for creating widgets
extension LabelSpecWidget on LabelSpec {
  /// Renders the LabelSpec into a Flex widget with text and optional icon
  Widget createWidget({
    required String text,
    IconData? icon,
    IconPosition iconPosition = IconPosition.leading,
  }) {
    return Builder(
      builder: (context) => _buildLabel(
        context,
        this,
        text: text,
        icon: icon,
        iconPosition: iconPosition,
      ),
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget widget({
    required String text,
    IconData? icon,
    IconPosition iconPosition = IconPosition.leading,
  }) {
    return createWidget(
      text: text,
      icon: icon,
      iconPosition: iconPosition,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget call({
    required String text,
    IconData? icon,
    IconPosition iconPosition = IconPosition.leading,
  }) {
    return createWidget(
      text: text,
      icon: icon,
      iconPosition: iconPosition,
    );
  }
}

/// Extension on StyleSpec<LabelSpec> to provide createWidget method for creating widgets
extension LabelSpecWrappedWidget on StyleSpec<LabelSpec> {
  Widget createWidget({
    required String text,
    IconData? icon,
    IconPosition iconPosition = IconPosition.leading,
  }) {
    return StyleSpecBuilder(
      styleSpec: this,
      builder: (context, spec) {
        return _buildLabel(
          context,
          spec,
          text: text,
          icon: icon,
          iconPosition: iconPosition,
        );
      },
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget widget({
    required String text,
    IconData? icon,
    IconPosition iconPosition = IconPosition.leading,
  }) {
    return createWidget(
      text: text,
      icon: icon,
      iconPosition: iconPosition,
    );
  }

  @Deprecated('Use .createWidget() instead')
  Widget call({
    required String text,
    IconData? icon,
    IconPosition iconPosition = IconPosition.leading,
  }) {
    return createWidget(
      text: text,
      icon: icon,
      iconPosition: iconPosition,
    );
  }
}
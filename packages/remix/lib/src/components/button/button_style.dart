part of 'button.dart';

/// Style class for RemixButton with comprehensive fluent API.
///
/// Provides three tiers of styling convenience:
///
/// **Tier 1 - Individual Property Helpers** (Most common):
/// ```dart
/// RemixButtonStyle()
///   .labelColor(Colors.white)
///   .labelFontSize(16.0)
///   .iconColor(Colors.blue)
///   .iconSize(20.0)
///   .spinnerIndicatorColor(Colors.white)
///   .spinnerSize(16.0)
/// ```
///
/// **Tier 2 - TextStyleMix Helper** (Multiple properties):
/// ```dart
/// RemixButtonStyle()
///   .labelTextStyle(TextStyleMix(
///     color: Colors.white,
///     fontSize: 16.0,
///     fontWeight: FontWeight.bold,
///   ))
/// ```
///
/// **Tier 3 - Full Control** (Complex scenarios):
/// ```dart
/// RemixButtonStyle()
///   .label(TextStyler()
///     .style(TextStyleMix(...))
///     .uppercase()
///     .maxLines(1))
/// ```
///
/// All methods return new instances (immutable pattern) and can be chained together.
@MixableStyler()
class RemixButtonStyle
    extends RemixFlexContainerStyle<RemixButtonSpec, RemixButtonStyle>
    with
        LabelStyleMixin<RemixButtonStyle>,
        IconStyleMixin<RemixButtonStyle>,
        SpinnerStyleMixin<RemixButtonStyle>,
        Diagnosticable,
        _$RemixButtonStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;

  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;

  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  @MixableField(setterType: RemixSpinnerStyle)
  final Prop<StyleSpec<RemixSpinnerSpec>>? $spinner;

  final Prop<IconAlignment>? $iconAlignment;

  const RemixButtonStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<RemixSpinnerSpec>>? spinner,
    Prop<IconAlignment>? iconAlignment,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon,
       $spinner = spinner,
       $iconAlignment = iconAlignment;

  RemixButtonStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    RemixSpinnerStyle? spinner,
    IconAlignment? iconAlignment,
    AnimationConfig? animation,
    List<VariantStyle<RemixButtonSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         spinner: Prop.maybeMix(spinner),
         iconAlignment: Prop.maybe(iconAlignment),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets padding
  RemixButtonStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(padding: value)));
  }

  // Additional convenience methods that delegate to BoxStyler

  /// Sets margin
  RemixButtonStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixButtonStyle decoration(DecorationMix value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(decoration: value)));
  }

  /// Sets container alignment
  RemixButtonStyle alignment(Alignment value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(alignment: value)));
  }

  /// Sets item spacing between icon and label (Flex spacing)
  RemixButtonStyle spacing(double value) {
    return merge(RemixButtonStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets constraints
  RemixButtonStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixButtonStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  RemixButton call({
    required String label,
    IconData? icon,
    bool loading = false,
    bool enabled = true,
    bool enableFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
  }) {
    return RemixButton(
      style: this,
      label: label,
      icon: icon,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixButtonStyle flex(FlexStyler value) {
    // The FlexStyler should be used to create a new FlexBoxStyler
    // For now, delegate to the merge pattern
    return merge(RemixButtonStyle(container: FlexBoxStyler().flex(value)));
  }

  @override
  RemixButtonStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixButtonStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixButtonStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixButtonStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixButtonStyle color(Color value) {
    return merge(
      RemixButtonStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }
}

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
///   .spinnerColor(Colors.white)
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
class RemixButtonStyle
    extends RemixFlexContainerStyle<ButtonSpec, RemixButtonStyle>
    with
        LabelStyleMixin<RemixButtonStyle>,
        IconStyleMixin<RemixButtonStyle>,
        SpinnerStyleMixin<RemixButtonStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<StyleSpec<SpinnerSpec>>? $spinner;

  const RemixButtonStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<StyleSpec<SpinnerSpec>>? spinner,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $icon = icon,
        $spinner = spinner;

  RemixButtonStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    RemixSpinnerStyle? spinner,
    AnimationConfig? animation,
    List<VariantStyle<ButtonSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          spinner: Prop.maybeMix(spinner),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods for fluent API (return new instances)
  RemixButtonStyle label(TextStyler value) {
    return merge(RemixButtonStyle(label: value));
  }

  RemixButtonStyle icon(IconStyler value) {
    return merge(RemixButtonStyle(icon: value));
  }

  RemixButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixButtonStyle(spinner: value));
  }

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

  RemixButtonStyle variants(List<VariantStyle<ButtonSpec>> value) {
    return merge(RemixButtonStyle(variants: value));
  }

  RemixButton call({
    required String label,
    IconData? icon,
    bool loading = false,
    bool enableFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
  }) {
    return RemixButton(
      label: label,
      icon: icon,
      loading: loading,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      style: this,
    );
  }

  // Animate support
  @override
  RemixButtonStyle animate(AnimationConfig animation) {
    return merge(RemixButtonStyle(animation: animation));
  }

  // FlexStyleMixin implementation
  @override
  RemixButtonStyle flex(FlexStyler value) {
    // The FlexStyler should be used to create a new FlexBoxStyler
    // For now, delegate to the merge pattern
    return merge(RemixButtonStyle(container: FlexBoxStyler()));
  }

  // Abstract method implementations for mixins (only missing ones)

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
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  RemixButtonStyle color(Color value) {
    return merge(RemixButtonStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  // Modifier support
  @override
  RemixButtonStyle wrap(WidgetModifierConfig value) {
    return merge(RemixButtonStyle(modifier: value));
  }

  @override
  StyleSpec<ButtonSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ButtonSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
        spinner: MixOps.resolve(context, $spinner),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixButtonStyle merge(RemixButtonStyle? other) {
    if (other == null) return this;

    return RemixButtonStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      spinner: MixOps.merge($spinner, other.$spinner),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $label,
        $icon,
        $spinner,
        $variants,
        $animation,
        $modifier,
      ];
}

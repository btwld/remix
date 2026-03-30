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

  // -- Factory constructors for convenience --

  /// Creates a style with the given background color.
  factory RemixButtonStyle.backgroundColor(Color value) =>
      RemixButtonStyle().backgroundColor(value);

  /// Creates a style with the given foreground color (label and icon).
  factory RemixButtonStyle.foregroundColor(Color value) =>
      RemixButtonStyle().foregroundColor(value);

  /// Creates a style with the given padding.
  factory RemixButtonStyle.padding(EdgeInsetsGeometryMix value) =>
      RemixButtonStyle().padding(value);

  /// Creates a style with the given margin.
  factory RemixButtonStyle.margin(EdgeInsetsGeometryMix value) =>
      RemixButtonStyle().margin(value);

  /// Creates a style with the given decoration.
  factory RemixButtonStyle.decoration(DecorationMix value) =>
      RemixButtonStyle().decoration(value);

  /// Creates a style with the given alignment.
  factory RemixButtonStyle.alignment(Alignment value) =>
      RemixButtonStyle().alignment(value);

  /// Creates a style with the given spacing.
  factory RemixButtonStyle.spacing(double value) =>
      RemixButtonStyle().spacing(value);

  /// Creates a style with the given constraints.
  factory RemixButtonStyle.constraints(BoxConstraintsMix value) =>
      RemixButtonStyle().constraints(value);

  /// Creates a style with the given minimum size.
  factory RemixButtonStyle.minimumSize(Size value) =>
      RemixButtonStyle().minimumSize(value);

  /// Creates a style with the given fixed size.
  factory RemixButtonStyle.fixedSize(Size value) =>
      RemixButtonStyle().fixedSize(value);

  /// Creates a style with the given maximum size.
  factory RemixButtonStyle.maximumSize(Size value) =>
      RemixButtonStyle().maximumSize(value);

  /// Creates a style with the given shape.
  factory RemixButtonStyle.shape(ShapeBorderMix value) =>
      RemixButtonStyle().shape(value);

  /// Creates a style with the given icon color.
  factory RemixButtonStyle.iconColor(Color value) =>
      RemixButtonStyle().iconColor(value);

  /// Creates a style with the given icon size.
  factory RemixButtonStyle.iconSize(double value) =>
      RemixButtonStyle().iconSize(value);

  /// Creates a style with the given label style.
  factory RemixButtonStyle.labelStyle(TextStyleMix value) =>
      RemixButtonStyle().labelStyle(value);

  /// Creates a style with the given shadow.
  factory RemixButtonStyle.shadow(BoxShadowMix value) =>
      RemixButtonStyle()..shadow(value);

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
    return merge(.new(container: .new(constraints: value)));
  }

  /// Sets the background color of the button.
  RemixButtonStyle backgroundColor(Color value) {
    return merge(
      .new(
        container: .new(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (label and icon) of the button.
  RemixButtonStyle foregroundColor(Color value) {
    return labelColor(value).iconColor(value).labelStyle(.color(value));
  }

  /// Sets the minimum size of the button.
  RemixButtonStyle minimumSize(Size value) {
    return merge(
      .new().constraintsOnly(minHeight: value.height, minWidth: value.width),
    );
  }

  /// Sets the fixed size of the button.
  ///
  /// Use [double.infinity] for either dimension to leave it unconstrained.
  RemixButtonStyle fixedSize(Size value) {
    return merge(
      .new().constraintsOnly(
        minHeight: value.height,
        minWidth: value.width,
        maxHeight: value.height,
        maxWidth: value.width,
      ),
    );
  }

  /// Sets the maximum size of the button.
  RemixButtonStyle maximumSize(Size value) {
    return merge(
      .new().constraintsOnly(maxHeight: value.height, maxWidth: value.width),
    );
  }

  RemixButton call({
    required String label,
    IconData? leadingIcon,
    IconData? trailingIcon,
    bool loading = false,
    bool enabled = true,
    bool enableFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
  }) {
    return RemixButton(
      style: this,
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
    );
  }

  /// Sets the shape of the button.
  RemixButtonStyle shape(ShapeBorderMix value) {
    return merge(
      RemixButtonStyle(
        container: FlexBoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
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

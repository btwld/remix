part of 'radio.dart';

class RemixRadioStyle
    extends RemixContainerStyle<RemixRadioSpec, RemixRadioStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $indicator;

  const RemixRadioStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? indicator,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $indicator = indicator;

  RemixRadioStyle({
    BoxStyler? container,
    BoxStyler? indicator,
    AnimationConfig? animation,
    List<VariantStyle<RemixRadioSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         indicator: Prop.maybeMix(indicator),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets indicator styling (selected fill).
  RemixRadioStyle indicator(BoxStyler value) {
    return merge(RemixRadioStyle(indicator: value));
  }

  /// Sets container alignment.
  RemixRadioStyle alignment(Alignment value) {
    return merge(RemixRadioStyle(container: BoxStyler(alignment: value)));
  }

  /// Creates a RemixRadio widget with this style applied.
  RemixRadio<T> call<T>({
    required T value,
    bool enabled = true,
    bool autofocus = false,
    bool toggleable = false,
    FocusNode? focusNode,
    MouseCursor? mouseCursor,
    bool enableFeedback = true,
  }) {
    return RemixRadio(
      style: this,
      value: value,
      autofocus: autofocus,
      enabled: enabled,
      toggleable: toggleable,
      focusNode: focusNode,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
    );
  }

  /// Convenience for applying padding around the control.
  @override
  RemixRadioStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(padding: value)));
  }

  /// Convenience for applying margin around the control.
  @override
  RemixRadioStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(margin: value)));
  }

  /// Sets background color on the container.
  @override
  RemixRadioStyle color(Color value) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container size using explicit constraints.
  @override
  RemixRadioStyle size(double width, double height) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  /// Sets border radius on the outer container.
  @override
  RemixRadioStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets animation configuration.
  @override
  RemixRadioStyle animate(AnimationConfig animation) {
    return merge(RemixRadioStyle(animation: animation));
  }

  @override
  RemixRadioStyle variants(List<VariantStyle<RemixRadioSpec>> value) {
    return merge(RemixRadioStyle(variants: value));
  }

  @override
  RemixRadioStyle wrap(WidgetModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  @override
  RemixRadioStyle constraints(BoxConstraintsMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixRadioStyle decoration(DecorationMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixRadioStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixRadioStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixRadioStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  StyleSpec<RemixRadioSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixRadioSpec(
        container: MixOps.resolve(context, $container),
        indicator: MixOps.resolve(context, $indicator),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixRadioStyle merge(RemixRadioStyle? other) {
    if (other == null) return this;

    return RemixRadioStyle.create(
      container: MixOps.merge($container, other.$container),
      indicator: MixOps.merge($indicator, other.$indicator),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
    $container,
    $indicator,
    $variants,
    $animation,
    $modifier,
  ];
}

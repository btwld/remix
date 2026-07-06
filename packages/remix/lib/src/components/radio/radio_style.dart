part of 'radio.dart';

/// Style configuration for [RemixRadio] container and selected indicator.
@MixableStyler()
class RemixRadioStyle
    extends RemixContainerStyle<RemixRadioSpec, RemixRadioStyle>
    with
        SelectedWidgetStateVariantMixin<RemixRadioSpec, RemixRadioStyle>,
        Diagnosticable,
        _$RemixRadioStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: BoxStyler)
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

  /// Sets container alignment.
  RemixRadioStyle alignment(Alignment value) {
    return merge(RemixRadioStyle(container: BoxStyler(alignment: value)));
  }

  /// Creates a RemixRadio widget with this style applied.
  RemixRadio<T> call<T>({
    required T value,
    bool enabled = true,
    bool toggleable = false,
    MouseCursor? mouseCursor,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return RemixRadio(
      value: value,
      enabled: enabled,
      toggleable: toggleable,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      style: this,
    );
  }

  /// Sets fill color on the container.
  RemixRadioStyle fillColor(Color value) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the indicator's fill color.
  RemixRadioStyle indicatorColor(Color value) {
    return merge(
      RemixRadioStyle(
        indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
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
}

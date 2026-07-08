part of 'radio.dart';

/// Style configuration for [RemixRadio] container and selected indicator.
@MixableStyler()
class RemixRadioStyler
    extends RemixContainerStyler<RemixRadioSpec, RemixRadioStyler>
    with
        SelectedWidgetStateVariantMixin<RemixRadioSpec, RemixRadioStyler>,
        Diagnosticable,
        _$RemixRadioStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $indicator;

  const RemixRadioStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? indicator,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $indicator = indicator;

  RemixRadioStyler({
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
  RemixRadioStyler alignment(Alignment value) {
    return merge(RemixRadioStyler(container: BoxStyler(alignment: value)));
  }

  /// Creates a RemixRadio widget with this style applied.
  RemixRadio<T> call<T>({
    Key? key,
    required T value,
    bool enabled = true,
    bool toggleable = false,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
  }) {
    return RemixRadio(
      key: key,
      value: value,
      enabled: enabled,
      toggleable: toggleable,
      mouseCursor: mouseCursor,
      focusNode: focusNode,
      autofocus: autofocus,
      style: this,
    );
  }

  /// Sets fill color on the container.
  RemixRadioStyler fillColor(Color value) {
    return merge(
      RemixRadioStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the indicator's fill color.
  RemixRadioStyler indicatorColor(Color value) {
    return merge(
      RemixRadioStyler(
        indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Convenience for applying padding around the control.
  @override
  RemixRadioStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyler(container: BoxStyler(padding: value)));
  }

  /// Convenience for applying margin around the control.
  @override
  RemixRadioStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyler(container: BoxStyler(margin: value)));
  }

  /// Sets container size using explicit constraints.
  @override
  RemixRadioStyler size(double width, double height) {
    return merge(
      RemixRadioStyler(
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
  RemixRadioStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixRadioStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixRadioStyler constraints(BoxConstraintsMix value) {
    return merge(RemixRadioStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixRadioStyler decoration(DecorationMix value) {
    return merge(RemixRadioStyler(container: BoxStyler(decoration: value)));
  }

  @override
  RemixRadioStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixRadioStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixRadioStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixRadioStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}

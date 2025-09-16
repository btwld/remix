part of 'switch.dart';

// Private per-component constants (sizes only)
const _kTrackWidth = 44.0;
const _kTrackHeight = 24.0;
const _kThumbSize = 20.0;

class RemixSwitchStyle extends RemixContainerStyle<SwitchSpec, RemixSwitchStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $track;
  final Prop<StyleSpec<BoxSpec>>? $thumb;

  const RemixSwitchStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? track,
    Prop<StyleSpec<BoxSpec>>? thumb,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $track = track,
        $thumb = thumb;

  RemixSwitchStyle({
    BoxStyler? container,
    BoxStyler? track,
    BoxStyler? thumb,
    AnimationConfig? animation,
    List<VariantStyle<SwitchSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          track: Prop.maybeMix(track),
          thumb: Prop.maybeMix(thumb),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets track color
  RemixSwitchStyle trackColor(Color value) {
    return merge(RemixSwitchStyle(
      track: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets thumb color
  RemixSwitchStyle thumbColor(Color value) {
    return merge(RemixSwitchStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets track styling
  RemixSwitchStyle track(BoxStyler value) {
    return merge(RemixSwitchStyle(track: value));
  }

  /// Sets thumb styling
  RemixSwitchStyle thumb(BoxStyler value) {
    return merge(RemixSwitchStyle(thumb: value));
  }

  /// Sets container styling
  RemixSwitchStyle container(BoxStyler value) {
    return merge(RemixSwitchStyle(container: value));
  }

  @override
  StyleSpec<SwitchSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SwitchSpec(
        container: MixOps.resolve(context, $container),
        track: MixOps.resolve(context, $track),
        thumb: MixOps.resolve(context, $thumb),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSwitchStyle merge(RemixSwitchStyle? other) {
    if (other == null) return this;

    return RemixSwitchStyle.create(
      container: MixOps.merge($container, other.$container),
      track: MixOps.merge($track, other.$track),
      thumb: MixOps.merge($thumb, other.$thumb),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixSwitchStyle withVariants(List<VariantStyle<SwitchSpec>> value) {
    return merge(RemixSwitchStyle(variants: value));
  }

  @override
  RemixSwitchStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSwitchStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixSwitchStyle animate(AnimationConfig config) {
    return merge(RemixSwitchStyle(animation: config));
  }

  @override
  RemixSwitchStyle constraints(BoxConstraintsMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixSwitchStyle decoration(DecorationMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixSwitchStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixSwitchStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSwitchStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixSwitchStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSwitchStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixSwitchStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixSwitchStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  List<Object?> get props => [
        $container,
        $track,
        $thumb,
        $variants,
        $animation,
        $modifier,
      ];
}




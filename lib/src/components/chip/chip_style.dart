part of 'chip.dart';

// Private per-component constants (no shared tokens)
const _kBlack = Color(0xFF000000);
const _kWhite = Color(0xFFFFFFFF);
const _kDisabled = Color(0xFF9E9E9E);

const _kSpaceXs = 4.0;
const _kSpaceSm = 8.0;
const _kSpaceMd = 12.0;

const _kRadiusLg = 8.0;
const _kRadiusXl = 12.0;

const _kFontSizeSm = 12.0;
const _kFontSizeMd = 14.0;

const _kIconSizeSm = 14.0;
const _kIconSizeMd = 16.0;

class RemixChipStyle extends Style<ChipSpec>
    with
        StyleModifierMixin<RemixChipStyle, ChipSpec>,
        StyleVariantMixin<RemixChipStyle, ChipSpec>,
        ModifierStyleMixin<RemixChipStyle, ChipSpec>,
        BorderStyleMixin<RemixChipStyle>,
        BorderRadiusStyleMixin<RemixChipStyle>,
        ShadowStyleMixin<RemixChipStyle>,
        DecorationStyleMixin<RemixChipStyle>,
        SpacingStyleMixin<RemixChipStyle>,
        TransformStyleMixin<RemixChipStyle>,
        ConstraintStyleMixin<RemixChipStyle>,
        AnimationStyleMixin<ChipSpec, RemixChipStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixChipStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $label = label,
        $icon = icon;

  RemixChipStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<ChipSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          label: Prop.maybeMix(label),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Convenience methods that delegate to container FlexBoxSpec

  /// Sets container padding
  RemixChipStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixChipStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixChipStyle color(Color value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container decoration
  RemixChipStyle decoration(DecorationMix value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(decoration: value)));
  }

  /// Sets container constraints
  RemixChipStyle constraints(BoxConstraintsMix value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(constraints: value),
    ));
  }

  /// Sets container border radius
  RemixChipStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets flex spacing
  RemixChipStyle spacing(double value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets container border
  RemixChipStyle border(BoxBorderMix value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
    ));
  }

  /// Sets flex direction
  RemixChipStyle direction(Axis value) {
    return merge(RemixChipStyle(container: FlexBoxStyler(direction: value)));
  }

  /// Sets cross axis alignment
  RemixChipStyle crossAxisAlignment(CrossAxisAlignment value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(crossAxisAlignment: value),
    ));
  }

  /// Sets main axis alignment
  RemixChipStyle mainAxisAlignment(MainAxisAlignment value) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(mainAxisAlignment: value),
    ));
  }

  @override
  StyleSpec<ChipSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ChipSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixChipStyle merge(RemixChipStyle? other) {
    if (other == null) return this;

    return RemixChipStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixChipStyle variants(List<VariantStyle<ChipSpec>> value) {
    return merge(RemixChipStyle(variants: value));
  }

  @override
  RemixChipStyle wrap(ModifierConfig value) {
    return merge(RemixChipStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixChipStyle animate(AnimationConfig config) {
    return merge(RemixChipStyle(animation: config));
  }

  @override
  RemixChipStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixChipStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixChipStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixChipStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  List<Object?> get props => [
        $container,
        $label,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}

/// Default chip styles and variants
class RemixChipStyles {
  /// Default chip style
  static RemixChipStyle get defaultStyle => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusXl),
            color: _kWhite,
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: _kSpaceXs,
            horizontal: _kSpaceMd,
          ),
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: _kSpaceXs,
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: _kBlack,
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: _kBlack, size: _kIconSizeMd),
      )
          .onFocused(
            RemixChipStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  border:
                      BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 2)),
                ),
              ),
            ),
          )
          .onDisabled(
            RemixChipStyle(
              container: FlexBoxStyler(
                decoration: BoxDecorationMix(
                  color: _kWhite.withValues(alpha: 0.5),
                ),
              ),
              label: TextStyler(style: TextStyleMix(color: _kDisabled)),
              icon: IconStyler(color: _kDisabled),
            ),
          );

  /// Solid chip variant
  static RemixChipStyle get solid => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusXl),
            color: _kBlack,
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: _kSpaceXs,
            horizontal: _kSpaceMd,
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: _kWhite,
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: _kWhite, size: _kIconSizeMd),
      );

  /// Outline chip variant
  static RemixChipStyle get outline => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 1)),
            borderRadius: BorderRadiusMix.circular(_kRadiusXl),
            color: _kWhite,
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: _kSpaceXs,
            horizontal: _kSpaceMd,
          ),
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: _kBlack,
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: _kBlack, size: _kIconSizeMd),
      );

  /// Compact chip variant (size-only utility)
  static RemixChipStyle get compact => RemixChipStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusLg),
            color: _kWhite,
          ),
          padding: EdgeInsetsMix.symmetric(
            vertical: _kSpaceXs * 0.5,
            horizontal: _kSpaceSm,
          ),
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: _kSpaceXs * 0.5,
        ),
        label: TextStyler(
          style: TextStyleMix(
            color: _kBlack,
            fontSize: _kFontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: _kBlack, size: _kIconSizeSm),
      );
}

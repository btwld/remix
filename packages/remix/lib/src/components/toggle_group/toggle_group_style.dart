part of 'toggle_group.dart';

/// Style configuration for a [RemixToggleGroup] container and its items.
@MixableStyler()
class RemixToggleGroupStyler extends Style<RemixToggleGroupSpec>
    with
        VariantStyleMixin<RemixToggleGroupStyler, RemixToggleGroupSpec>,
        WidgetModifierStyleMixin<RemixToggleGroupStyler, RemixToggleGroupSpec>,
        AnimationStyleMixin<RemixToggleGroupStyler, RemixToggleGroupSpec>,
        BorderStyleMixin<RemixToggleGroupStyler>,
        BorderRadiusStyleMixin<RemixToggleGroupStyler>,
        ShadowStyleMixin<RemixToggleGroupStyler>,
        DecorationStyleMixin<RemixToggleGroupStyler>,
        SpacingStyleMixin<RemixToggleGroupStyler>,
        TransformStyleMixin<RemixToggleGroupStyler>,
        ConstraintStyleMixin<RemixToggleGroupStyler>,
        FlexStyleMixin<RemixToggleGroupStyler>,
        Diagnosticable,
        _$RemixToggleGroupStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;

  @MixableField(setterType: RemixToggleGroupItemStyler)
  final Prop<StyleSpec<RemixToggleGroupItemSpec>>? $item;

  const RemixToggleGroupStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<RemixToggleGroupItemSpec>>? item,
    List<VariantStyle<RemixToggleGroupSpec>>? variants,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
  }) : $container = container,
       $item = item,
       super(variants: variants, animation: animation, modifier: modifier);

  RemixToggleGroupStyler({
    FlexBoxStyler? container,
    RemixToggleGroupItemStyler? item,
    AnimationConfig? animation,
    List<VariantStyle<RemixToggleGroupSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         item: Prop.maybeMix(item),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets the group background color.
  RemixToggleGroupStyler backgroundColor(Color value) => color(value);

  /// Creates a [RemixToggleGroup] with this style applied.
  RemixToggleGroup<T> call<T>({
    Key? key,
    required List<RemixToggleGroupItem<T>> items,
    required T? selectedValue,
    ValueChanged<T?>? onChanged,
    bool enabled = true,
    Axis orientation = .horizontal,
    bool loop = true,
    String? semanticLabel,
    bool excludeSemantics = false,
  }) {
    return RemixToggleGroup(
      key: key,
      items: items,
      selectedValue: selectedValue,
      onChanged: onChanged,
      enabled: enabled,
      orientation: orientation,
      loop: loop,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
      style: this,
    );
  }

  RemixToggleGroupStyler alignment(Alignment value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  @override
  RemixToggleGroupStyler padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixToggleGroupStyler color(Color value) {
    return merge(
      RemixToggleGroupStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixToggleGroupStyler size(double width, double height) {
    return merge(
      RemixToggleGroupStyler(
        container: FlexBoxStyler(
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

  @override
  RemixToggleGroupStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixToggleGroupStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixToggleGroupStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixToggleGroupStyler decoration(DecorationMix value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixToggleGroupStyler margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixToggleGroupStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixToggleGroupStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixToggleGroupStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixToggleGroupStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixToggleGroupStyler flex(FlexStyler value) {
    return merge(
      RemixToggleGroupStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}

/// Style configuration for an option in a [RemixToggleGroup].
@MixableStyler()
class RemixToggleGroupItemStyler
    extends
        RemixFlexContainerStyler<
          RemixToggleGroupItemSpec,
          RemixToggleGroupItemStyler
        >
    with
        LabelStyleMixin<RemixToggleGroupItemStyler>,
        IconStyleMixin<RemixToggleGroupItemStyler>,
        SelectedWidgetStateVariantMixin<
          RemixToggleGroupItemSpec,
          RemixToggleGroupItemStyler
        >,
        Diagnosticable,
        _$RemixToggleGroupItemStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;

  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;

  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixToggleGroupItemStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixToggleGroupItemStyler({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixToggleGroupItemSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets the item background color.
  RemixToggleGroupItemStyler backgroundColor(Color value) {
    return merge(
      RemixToggleGroupItemStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the item foreground color for both label and icon.
  RemixToggleGroupItemStyler foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets spacing between the optional icon and label.
  RemixToggleGroupItemStyler spacing(double value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler(spacing: value)),
    );
  }

  @override
  RemixToggleGroupItemStyler alignment(Alignment value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler(alignment: value)),
    );
  }

  @override
  RemixToggleGroupItemStyler padding(EdgeInsetsGeometryMix value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler(padding: value)),
    );
  }

  @override
  RemixToggleGroupItemStyler color(Color value) => backgroundColor(value);

  @override
  RemixToggleGroupItemStyler size(double width, double height) {
    return merge(
      RemixToggleGroupItemStyler(
        container: FlexBoxStyler(
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

  @override
  RemixToggleGroupItemStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixToggleGroupItemStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixToggleGroupItemStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixToggleGroupItemStyler decoration(DecorationMix value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixToggleGroupItemStyler margin(EdgeInsetsGeometryMix value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler(margin: value)),
    );
  }

  @override
  RemixToggleGroupItemStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixToggleGroupItemStyler(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixToggleGroupItemStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixToggleGroupItemStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixToggleGroupItemStyler flex(FlexStyler value) {
    return merge(
      RemixToggleGroupItemStyler(container: FlexBoxStyler().flex(value)),
    );
  }
}

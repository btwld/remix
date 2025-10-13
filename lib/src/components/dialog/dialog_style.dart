part of 'dialog.dart';

class RemixDialogStyle
    extends RemixContainerStyle<RemixDialogSpec, RemixDialogStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<TextSpec>>? $description;
  final Prop<StyleSpec<FlexBoxSpec>>? $actions;
  final Prop<StyleSpec<BoxSpec>>? $overlay;

  const RemixDialogStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<TextSpec>>? description,
    Prop<StyleSpec<FlexBoxSpec>>? actions,
    Prop<StyleSpec<BoxSpec>>? overlay,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $title = title,
       $description = description,
       $actions = actions,
       $overlay = overlay;

  RemixDialogStyle({
    BoxStyler? container,
    TextStyler? title,
    TextStyler? description,
    FlexBoxStyler? actions,
    BoxStyler? overlay,
    AnimationConfig? animation,
    List<VariantStyle<RemixDialogSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         title: Prop.maybeMix(title),
         description: Prop.maybeMix(description),
         actions: Prop.maybeMix(actions),
         overlay: Prop.maybeMix(overlay),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  RemixDialogStyle title(TextStyler value) {
    return merge(RemixDialogStyle(title: value));
  }

  RemixDialogStyle description(TextStyler value) {
    return merge(RemixDialogStyle(description: value));
  }

  RemixDialogStyle actions(FlexBoxStyler value) {
    return merge(RemixDialogStyle(actions: value));
  }

  RemixDialogStyle overlay(BoxStyler value) {
    return merge(RemixDialogStyle(overlay: value));
  }

  /// Sets container alignment
  RemixDialogStyle alignment(Alignment value) {
    return merge(RemixDialogStyle(container: BoxStyler(alignment: value)));
  }

  // RemixContainerStyle mixin implementations
  @override
  RemixDialogStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixDialogStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixDialogStyle textColor(Color value) {
    return merge(
      RemixDialogStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixDialogStyle size(double width, double height) {
    return merge(
      RemixDialogStyle(
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

  @override
  RemixDialogStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixDialogStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixDialogStyle constraints(BoxConstraintsMix value) {
    return merge(RemixDialogStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixDialogStyle decoration(DecorationMix value) {
    return merge(RemixDialogStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixDialogStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixDialogStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixDialogStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixDialogStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixDialogStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixDialogStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  StyleSpec<RemixDialogSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixDialogSpec(
        container: MixOps.resolve(context, $container),
        title: MixOps.resolve(context, $title),
        description: MixOps.resolve(context, $description),
        actions: MixOps.resolve(context, $actions),
        overlay: MixOps.resolve(context, $overlay),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixDialogStyle merge(RemixDialogStyle? other) {
    if (other == null) return this;

    return RemixDialogStyle.create(
      container: MixOps.merge($container, other.$container),
      title: MixOps.merge($title, other.$title),
      description: MixOps.merge($description, other.$description),
      actions: MixOps.merge($actions, other.$actions),
      overlay: MixOps.merge($overlay, other.$overlay),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixDialogStyle variants(List<VariantStyle<RemixDialogSpec>> value) {
    return merge(RemixDialogStyle(variants: value));
  }

  @override
  RemixDialogStyle animate(AnimationConfig animation) {
    return merge(RemixDialogStyle(animation: animation));
  }

  @override
  RemixDialogStyle wrap(WidgetModifierConfig value) {
    return merge(RemixDialogStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
    $container,
    $title,
    $description,
    $actions,
    $overlay,
    $variants,
    $animation,
    $modifier,
  ];
}

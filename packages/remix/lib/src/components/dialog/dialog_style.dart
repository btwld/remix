part of 'dialog.dart';

@MixableStyler()
class RemixDialogStyle
    extends RemixContainerStyle<RemixDialogSpec, RemixDialogStyle>
    with Diagnosticable, _$RemixDialogStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $title;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $description;
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $actions;
  @MixableField(setterType: BoxStyler)
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
  RemixDialogStyle color(Color value) {
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
}

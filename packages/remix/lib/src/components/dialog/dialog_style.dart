part of 'dialog.dart';

/// Style configuration for [RemixDialog] container, title, description, and actions.
@MixableStyler()
class RemixDialogStyler
    extends RemixContainerStyler<RemixDialogSpec, RemixDialogStyler>
    with Diagnosticable, _$RemixDialogStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $title;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $description;
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $actions;
  const RemixDialogStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<TextSpec>>? description,
    Prop<StyleSpec<FlexBoxSpec>>? actions,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $title = title,
       $description = description,
       $actions = actions;

  RemixDialogStyler({
    BoxStyler? container,
    TextStyler? title,
    TextStyler? description,
    FlexBoxStyler? actions,
    AnimationConfig? animation,
    List<VariantStyle<RemixDialogSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         title: Prop.maybeMix(title),
         description: Prop.maybeMix(description),
         actions: Prop.maybeMix(actions),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment
  RemixDialogStyler alignment(Alignment value) {
    return merge(RemixDialogStyler(container: BoxStyler(alignment: value)));
  }

  /// Sets the background color of the dialog.
  RemixDialogStyler backgroundColor(Color value) {
    return merge(
      RemixDialogStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the shape of the dialog.
  RemixDialogStyler shape(ShapeBorderMix value) {
    return merge(
      RemixDialogStyler(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Creates a [RemixDialog] widget with this style applied.
  RemixDialog call({
    Key? key,
    Widget? child,
    String? title,
    String? description,
    List<Widget>? actions,
    bool modal = true,
    String? semanticLabel,
    bool wrapInNakedDialog = true,
  }) {
    return RemixDialog(
      key: key,
      title: title,
      description: description,
      actions: actions,
      modal: modal,
      semanticLabel: semanticLabel,
      wrapInNakedDialog: wrapInNakedDialog,
      style: this,
      child: child,
    );
  }

  // RemixContainerStyler mixin implementations
  @override
  RemixDialogStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixDialogStyler(container: BoxStyler(padding: value)));
  }

  /// Delegates to [backgroundColor].
  @override
  RemixDialogStyler color(Color value) => backgroundColor(value);

  @override
  RemixDialogStyler size(double width, double height) {
    return merge(
      RemixDialogStyler(
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
  RemixDialogStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixDialogStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixDialogStyler constraints(BoxConstraintsMix value) {
    return merge(RemixDialogStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixDialogStyler decoration(DecorationMix value) {
    return merge(RemixDialogStyler(container: BoxStyler(decoration: value)));
  }

  @override
  RemixDialogStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixDialogStyler(container: BoxStyler(margin: value)));
  }

  @override
  RemixDialogStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixDialogStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixDialogStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixDialogStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  /// Sets the shadow/elevation of the dialog.
  @override
  RemixDialogStyler shadow(BoxShadowMix value) {
    return merge(
      RemixDialogStyler(
        container: BoxStyler(decoration: BoxDecorationMix(boxShadow: [value])),
      ),
    );
  }
}

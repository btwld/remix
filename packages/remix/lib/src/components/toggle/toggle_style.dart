part of 'toggle.dart';

@MixableStyler()
class RemixToggleStyle
    extends RemixContainerStyle<RemixToggleSpec, RemixToggleStyle>
    with
        LabelStyleMixin<RemixToggleStyle>,
        IconStyleMixin<RemixToggleStyle>,
        SelectedWidgetStateVariantMixin<RemixToggleSpec, RemixToggleStyle>,
        Diagnosticable,
        _$RemixToggleStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixToggleStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixToggleStyle({
    BoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixToggleSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment.
  @override
  RemixToggleStyle alignment(Alignment value) {
    return merge(RemixToggleStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets the background color.
  RemixToggleStyle backgroundColor(Color value) {
    return merge(
      RemixToggleStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (label and icon).
  RemixToggleStyle foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets the shape of the toggle.
  RemixToggleStyle shape(ShapeBorderMix value) {
    return merge(
      RemixToggleStyle(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  @override
  RemixToggleStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixToggleStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixToggleStyle decoration(DecorationMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixToggleStyle constraints(BoxConstraintsMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixToggleStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixToggleStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixToggleStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixToggleStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  /// Creates a [RemixToggle] widget with this style applied.
  RemixToggle call({
    required bool selected,
    required ValueChanged<bool> onChanged,
    String? label,
    IconData? icon,
    bool enabled = true,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixToggle(
      selected: selected,
      onChanged: onChanged,
      label: label,
      icon: icon,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      mouseCursor: mouseCursor,
      style: this,
    );
  }
}

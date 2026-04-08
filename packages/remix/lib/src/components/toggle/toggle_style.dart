part of 'toggle.dart';

@MixableStyler()
class RemixToggleStyle
    extends RemixFlexContainerStyle<RemixToggleSpec, RemixToggleStyle>
    with
        LabelStyleMixin<RemixToggleStyle>,
        IconStyleMixin<RemixToggleStyle>,
        SelectedWidgetStateVariantMixin<RemixToggleSpec, RemixToggleStyle>,
        Diagnosticable,
        _$RemixToggleStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixToggleStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixToggleStyle({
    FlexBoxStyler? container,
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
    return merge(RemixToggleStyle(container: FlexBoxStyler(alignment: value)));
  }

  /// Sets the background color.
  RemixToggleStyle backgroundColor(Color value) {
    return merge(
      RemixToggleStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
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
        container: FlexBoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Sets item spacing between icon and label.
  RemixToggleStyle spacing(double value) {
    return merge(RemixToggleStyle(container: FlexBoxStyler(spacing: value)));
  }

  @override
  RemixToggleStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixToggleStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixToggleStyle decoration(DecorationMix value) {
    return merge(RemixToggleStyle(container: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixToggleStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixToggleStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixToggleStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixToggleStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixToggleStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixToggleStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixToggleStyle flex(FlexStyler value) {
    return merge(RemixToggleStyle(container: FlexBoxStyler().flex(value)));
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

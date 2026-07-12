part of 'toggle.dart';

/// Style configuration for [RemixToggle] container, label, icon, and states.
@MixableStyler()
class RemixToggleStyler
    extends RemixFlexContainerStyler<RemixToggleSpec, RemixToggleStyler>
    with
        LabelStyleMixin<RemixToggleStyler>,
        IconStyleMixin<RemixToggleStyler>,
        SelectedWidgetStateVariantMixin<RemixToggleSpec, RemixToggleStyler>,
        Diagnosticable,
        _$RemixToggleStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixToggleStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixToggleStyler({
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

  /// Sets the background color.
  RemixToggleStyler backgroundColor(Color value) {
    return merge(
      RemixToggleStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (label and icon).
  RemixToggleStyler foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets the shape of the toggle.
  RemixToggleStyler shape(ShapeBorderMix value) {
    return merge(
      RemixToggleStyler(
        container: FlexBoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Sets item spacing between icon and label.
  RemixToggleStyler spacing(double value) {
    return merge(RemixToggleStyler(container: FlexBoxStyler(spacing: value)));
  }

  /// Creates a [RemixToggle] widget with this style applied.
  RemixToggle call({
    Key? key,
    required bool selected,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
    String? label,
    IconData? icon,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixToggle(
      key: key,
      selected: selected,
      onChanged: onChanged,
      enabled: enabled,
      label: label,
      icon: icon,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      mouseCursor: mouseCursor,
      style: this,
    );
  }

  /// Sets container alignment.
  @override
  RemixToggleStyler alignment(Alignment value) {
    return merge(RemixToggleStyler(container: FlexBoxStyler(alignment: value)));
  }

  @override
  RemixToggleStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyler(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixToggleStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyler(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixToggleStyler decoration(DecorationMix value) {
    return merge(
      RemixToggleStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixToggleStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixToggleStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixToggleStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixToggleStyler(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixToggleStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixToggleStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixToggleStyler flex(FlexStyler value) {
    return merge(RemixToggleStyler(container: FlexBoxStyler().flex(value)));
  }
}

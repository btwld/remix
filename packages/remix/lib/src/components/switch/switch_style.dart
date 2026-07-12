part of 'switch.dart';

/// Style builder for [RemixSwitch].
///
/// Use this class to style the switch track and thumb, including selected,
/// focused, disabled, hovered, and pressed state variants.
@MixableStyler()
class RemixSwitchStyler
    extends RemixContainerStyler<RemixSwitchSpec, RemixSwitchStyler>
    with
        SelectedWidgetStateVariantMixin<RemixSwitchSpec, RemixSwitchStyler>,
        Diagnosticable,
        _$RemixSwitchStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $thumb;

  const RemixSwitchStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? thumb,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $thumb = thumb;

  RemixSwitchStyler({
    BoxStyler? container,
    BoxStyler? thumb,
    AnimationConfig? animation,
    List<VariantStyle<RemixSwitchSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         thumb: Prop.maybeMix(thumb),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets thumb color
  RemixSwitchStyler thumbColor(Color value) {
    return merge(
      RemixSwitchStyler(
        thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the track/rail background color.
  RemixSwitchStyler trackColor(Color value) {
    return color(value);
  }

  /// Sets container alignment
  RemixSwitchStyler alignment(Alignment value) {
    return merge(RemixSwitchStyler(container: BoxStyler(alignment: value)));
  }

  /// Creates a [RemixSwitch] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final toggle = RemixSwitchStyler()
  ///   .thumbColor(Colors.white)
  ///   .trackColor(Colors.blue);
  ///
  /// // Use it like a function
  /// toggle(
  ///   selected: _isEnabled,
  ///   onChanged: (value) => setState(() => _isEnabled = value),
  /// )
  /// ```
  RemixSwitch call({
    Key? key,
    required bool selected,
    ValueChanged<bool>? onChanged,
    bool enabled = true,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixSwitch(
      key: key,
      selected: selected,
      onChanged: onChanged,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      mouseCursor: mouseCursor,
      style: this,
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixSwitchStyler constraints(BoxConstraintsMix value) {
    return merge(RemixSwitchStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixSwitchStyler decoration(DecorationMix value) {
    return merge(RemixSwitchStyler(container: BoxStyler(decoration: value)));
  }

  @override
  RemixSwitchStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixSwitchStyler(container: BoxStyler(margin: value)));
  }

  @override
  RemixSwitchStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSwitchStyler(container: BoxStyler(padding: value)));
  }

  @override
  RemixSwitchStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSwitchStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixSwitchStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSwitchStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}

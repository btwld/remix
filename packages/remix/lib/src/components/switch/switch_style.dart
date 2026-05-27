part of 'switch.dart';

@MixableStyler()
class RemixSwitchStyle
    extends RemixContainerStyle<RemixSwitchSpec, RemixSwitchStyle>
    with
        SelectedWidgetStateVariantMixin<RemixSwitchSpec, RemixSwitchStyle>,
        Diagnosticable,
        _$RemixSwitchStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $thumb;

  const RemixSwitchStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? thumb,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $thumb = thumb;

  RemixSwitchStyle({
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
  RemixSwitchStyle thumbColor(Color value) {
    return merge(
      RemixSwitchStyle(
        thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the track/rail background color.
  RemixSwitchStyle trackColor(Color value) {
    return color(value);
  }

  /// Sets container alignment
  RemixSwitchStyle alignment(Alignment value) {
    return merge(RemixSwitchStyle(container: BoxStyler(alignment: value)));
  }

  // Abstract method implementations for mixins

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
    return merge(
      RemixSwitchStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  /// Creates a [RemixSwitch] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final toggle = RemixSwitchStyle()
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
    required bool selected,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixSwitch(
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
}

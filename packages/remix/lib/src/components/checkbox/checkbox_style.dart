part of 'checkbox.dart';

/// Style configuration for [RemixCheckbox] container and indicator icon.
@MixableStyler()
class RemixCheckboxStyler
    extends RemixContainerStyler<RemixCheckboxSpec, RemixCheckboxStyler>
    with
        IconStyleMixin<RemixCheckboxStyler>,
        SelectedWidgetStateVariantMixin<RemixCheckboxSpec, RemixCheckboxStyler>,
        Diagnosticable,
        _$RemixCheckboxStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $indicator;

  const RemixCheckboxStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? indicator,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $indicator = indicator;

  RemixCheckboxStyler({
    BoxStyler? container,
    IconStyler? indicator,
    AnimationConfig? animation,
    List<VariantStyle<RemixCheckboxSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         indicator: Prop.maybeMix(indicator),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets the shape of the checkbox.
  RemixCheckboxStyler shape(ShapeBorderMix value) {
    return merge(
      RemixCheckboxStyler(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  /// Sets checkbox border on the container.
  RemixCheckboxStyler border(BoxBorderMix value) {
    return merge(
      RemixCheckboxStyler(
        container: BoxStyler(decoration: BoxDecorationMix(border: value)),
      ),
    );
  }

  /// Sets indicator color.
  RemixCheckboxStyler indicatorColor(Color value) {
    return merge(RemixCheckboxStyler(indicator: IconStyler(color: value)));
  }

  /// Sets container alignment.
  RemixCheckboxStyler alignment(Alignment value) {
    return merge(RemixCheckboxStyler(container: BoxStyler(alignment: value)));
  }

  RemixCheckboxStyler onIndeterminate(RemixCheckboxStyler value) {
    return variant(
      ContextVariant(
        'on_indeterminate',
        (context) => NakedCheckboxState.maybeOf(context)?.isChecked == null,
      ),
      value,
    );
  }

  /// Sets checkbox fill color on the container.
  RemixCheckboxStyler fillColor(Color value) {
    return merge(
      RemixCheckboxStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Creates a [RemixCheckbox] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final checkbox = RemixCheckboxStyler()
  ///   .fillColor(Colors.blue)
  ///   .size(24, 24);
  ///
  /// // Use it like a function
  /// checkbox(
  ///   selected: isChecked,
  ///   onChanged: (value) => setState(() => isChecked = value),
  /// )
  /// ```
  RemixCheckbox call({
    Key? key,
    required bool? selected,
    ValueChanged<bool?>? onChanged,
    bool enabled = true,
    bool tristate = false,
    IconData checkedIcon = Icons.check_rounded,
    IconData? uncheckedIcon,
    IconData indeterminateIcon = Icons.horizontal_rule,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enableFeedback = true,
    String? semanticLabel,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixCheckbox(
      key: key,
      selected: selected,
      onChanged: onChanged,
      enabled: enabled,
      tristate: tristate,
      checkedIcon: checkedIcon,
      uncheckedIcon: uncheckedIcon,
      indeterminateIcon: indeterminateIcon,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      semanticLabel: semanticLabel,
      mouseCursor: mouseCursor,
      style: this,
    );
  }

  @override
  RemixCheckboxStyler icon(IconStyler value) {
    return merge(RemixCheckboxStyler(indicator: value));
  }

  /// Sets container padding.
  @override
  RemixCheckboxStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckboxStyler(container: BoxStyler(padding: value)));
  }

  /// Sets checkbox size with separate width and height.
  @override
  RemixCheckboxStyler size(double width, double height) {
    return merge(
      RemixCheckboxStyler(
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

  /// Sets border radius on the outer container.
  @override
  RemixCheckboxStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixCheckboxStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixCheckboxStyler constraints(BoxConstraintsMix value) {
    return merge(RemixCheckboxStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCheckboxStyler decoration(DecorationMix value) {
    return merge(RemixCheckboxStyler(container: BoxStyler(decoration: value)));
  }

  @override
  RemixCheckboxStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckboxStyler(container: BoxStyler(margin: value)));
  }

  @override
  RemixCheckboxStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCheckboxStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCheckboxStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixCheckboxStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}

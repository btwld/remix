part of 'button.dart';

class ButtonStyle extends Style<ButtonSpec>
    with
        StyleModifierMixin<ButtonStyle, ButtonSpec>,
        StyleVariantMixin<ButtonStyle, ButtonSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<LabelSpec>? $label;

  const ButtonStyle.create({
    Prop<BoxSpec>? container,
    Prop<LabelSpec>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $label = label;

  ButtonStyle({
    BoxMix? container,
    LabelStyle? label,
    AnimationConfig? animation,
    List<VariantStyle<ButtonSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          label: label != null ? Prop.mix(label) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory ButtonStyle.value(ButtonSpec spec) => ButtonStyle(
        container: BoxMix.maybeValue(spec.container),
        label: LabelStyle.value(spec.label),
      );

  // Factory constructors for common patterns
  factory ButtonStyle.label(LabelStyle value) {
    return ButtonStyle(label: value);
  }

  /// Factory for background color
  factory ButtonStyle.color(Color value) {
    return ButtonStyle(container: BoxMix(decoration: BoxDecorationMix(color: value)));
  }
  
  /// Factory for padding
  factory ButtonStyle.padding(double value) {
    return ButtonStyle(container: BoxMix(padding: EdgeInsetsMix.all(value)));
  }
  
  /// Factory for border radius
  factory ButtonStyle.borderRadius(double radius) {
    return ButtonStyle(container: BoxMix(decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(radius))));
  }
  
  /// Factory for width
  factory ButtonStyle.width(double value) {
    return ButtonStyle(container: BoxMix(constraints: BoxConstraintsMix(minWidth: value, maxWidth: value)));
  }
  
  /// Factory for height
  factory ButtonStyle.height(double value) {
    return ButtonStyle(container: BoxMix(constraints: BoxConstraintsMix(minHeight: value, maxHeight: value)));
  }
  
  /// Factory for size (width and height)
  factory ButtonStyle.size(double width, double height) {
    return ButtonStyle(container: BoxMix(constraints: BoxConstraintsMix(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height)));
  }
  
  /// Factory for border
  factory ButtonStyle.border(BoxBorderMix value) {
    return ButtonStyle(container: BoxMix(decoration: BoxDecorationMix(border: value)));
  }

  // Instance methods for fluent API (return new instances)
  ButtonStyle label(LabelStyle value) {
    return merge(ButtonStyle.label(value));
  }

  // Instance methods (chainable)
  
  /// Sets background color
  ButtonStyle color(Color value) {
    return merge(ButtonStyle.color(value));
  }
  
  /// Sets padding
  ButtonStyle padding(double value) {
    return merge(ButtonStyle.padding(value));
  }
  
  /// Sets border radius
  ButtonStyle borderRadius(double radius) {
    return merge(ButtonStyle.borderRadius(radius));
  }
  
  /// Sets width
  ButtonStyle width(double value) {
    return merge(ButtonStyle.width(value));
  }
  
  /// Sets height
  ButtonStyle height(double value) {
    return merge(ButtonStyle.height(value));
  }
  
  /// Sets size (width and height)
  ButtonStyle size(double width, double height) {
    return merge(ButtonStyle.size(width, height));
  }
  
  /// Sets border
  ButtonStyle border(BoxBorderMix value) {
    return merge(ButtonStyle.border(value));
  }

  // Animate support
  ButtonStyle animate(AnimationConfig animation) {
    return merge(ButtonStyle(animation: animation));
  }

  // Variant support
  @override
  ButtonStyle variant(Variant variant, ButtonStyle style) {
    return merge(ButtonStyle(variants: [VariantStyle(variant, style)]));
  }
  
  @override
  ButtonStyle variants(List<VariantStyle<ButtonSpec>> value) {
    return merge(ButtonStyle(variants: value));
  }
  
  // Modifier support
  @override
  ButtonStyle wrap(ModifierConfig value) {
    return merge(ButtonStyle(modifier: value));
  }

  RemixButton call({
    required String label,
    IconData? icon,
    bool enabled = true,
    bool loading = false,
    WidgetBuilder? spinnerBuilder,
    bool enableHapticFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
    List<Variant> variants = const [],
  }) {
    return RemixButton(
      label: label,
      icon: icon,
      enabled: enabled,
      loading: loading,
      spinnerBuilder: spinnerBuilder,
      enableHapticFeedback: enableHapticFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      variants: variants,
      style: this,
    );
  }

  @override
  ButtonSpec resolve(BuildContext context) {
    return ButtonSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
    );
  }

  @override
  ButtonStyle merge(ButtonStyle? other) {
    if (other == null) return this;

    return ButtonStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $label,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultButtonStyle = ButtonStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.all(10),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: Colors.black,
    ),
  ),
  label: LabelStyle(
    spacing: 8,
    label: TextMix.color(Colors.white),
    icon: IconMix.color(Colors.white).size(18),
  ),
);

// COMMENTED OUT FOR REVIEW - ORIGINAL FROM MAIN BRANCH
// This file was fetched from main branch and commented out for review
// Uncomment and modify as needed for Mix 2.0 migration

/*
part of 'button.dart';

class RemixButtonStyle extends ButtonSpecUtility<ButtonSpecAttribute> {
  RemixButtonStyle() : super((v) => v);

  factory RemixButtonStyle._default() {
    final style = RemixButtonStyle()
      ..container.color.black()
      ..container.padding(10)
      ..container.borderRadius(8)
      ..icon.color.white()
      ..icon.size(18);

    return style;
  }

  @override
  RemixButtonStyle merge(RemixButtonStyle other) {
    return super.merge(other) as RemixButtonStyle;
  }
}
*/

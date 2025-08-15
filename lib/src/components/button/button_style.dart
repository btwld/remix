part of 'button.dart';

class RemixButtonStyle extends Style<ButtonSpec>
    with
        StyleModifierMixin<RemixButtonStyle, ButtonSpec>,
        StyleVariantMixin<RemixButtonStyle, ButtonSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<LabelSpec>? $label;
  final Prop<SpinnerSpec>? $spinner;

  const RemixButtonStyle.create({
    Prop<BoxSpec>? container,
    Prop<LabelSpec>? label,
    Prop<SpinnerSpec>? spinner,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $label = label,
        $spinner = spinner;

  RemixButtonStyle({
    BoxMix? container,
    RemixLabelStyle? label,
    RemixSpinnerStyle? spinner,
    AnimationConfig? animation,
    List<VariantStyle<ButtonSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          label: label != null ? Prop.mix(label) : null,
          spinner: spinner != null ? Prop.mix(spinner) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixButtonStyle.value(ButtonSpec spec) => RemixButtonStyle(
        container: BoxMix.maybeValue(spec.container),
        label: RemixLabelStyle.value(spec.label),
        spinner: RemixSpinnerStyle.value(spec.spinner),
      );

  // Factory constructors for common patterns
  factory RemixButtonStyle.label(RemixLabelStyle value) {
    return RemixButtonStyle(label: value);
  }

  factory RemixButtonStyle.spinner(RemixSpinnerStyle value) {
    return RemixButtonStyle(spinner: value);
  }

  /// Factory for background color
  factory RemixButtonStyle.color(Color value) {
    return RemixButtonStyle(
      container: BoxMix(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for padding
  factory RemixButtonStyle.padding(double value) {
    return RemixButtonStyle(container: BoxMix(padding: EdgeInsetsMix.all(value)));
  }

  /// Factory for border radius
  factory RemixButtonStyle.borderRadius(double radius) {
    return RemixButtonStyle(
      container: BoxMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for width
  factory RemixButtonStyle.width(double value) {
    return RemixButtonStyle(
      container: BoxMix(
        constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
      ),
    );
  }

  /// Factory for height
  factory RemixButtonStyle.height(double value) {
    return RemixButtonStyle(
      container: BoxMix(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    );
  }

  /// Factory for size (width and height)
  factory RemixButtonStyle.size(double width, double height) {
    return RemixButtonStyle(
      container: BoxMix(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    );
  }

  /// Factory for border
  factory RemixButtonStyle.border(BoxBorderMix value) {
    return RemixButtonStyle(
      container: BoxMix(decoration: BoxDecorationMix(border: value)),
    );
  }

  // Instance methods for fluent API (return new instances)
  RemixButtonStyle label(RemixLabelStyle value) {
    return merge(RemixButtonStyle.label(value));
  }

  RemixButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixButtonStyle.spinner(value));
  }

  // Instance methods (chainable)

  /// Sets background color
  RemixButtonStyle color(Color value) {
    return merge(RemixButtonStyle.color(value));
  }

  /// Sets padding
  RemixButtonStyle padding(double value) {
    return merge(RemixButtonStyle.padding(value));
  }

  /// Sets border radius
  RemixButtonStyle borderRadius(double radius) {
    return merge(RemixButtonStyle.borderRadius(radius));
  }

  /// Sets width
  RemixButtonStyle width(double value) {
    return merge(RemixButtonStyle.width(value));
  }

  /// Sets height
  RemixButtonStyle height(double value) {
    return merge(RemixButtonStyle.height(value));
  }

  /// Sets size (width and height)
  RemixButtonStyle size(double width, double height) {
    return merge(RemixButtonStyle.size(width, height));
  }

  /// Sets border
  RemixButtonStyle border(BoxBorderMix value) {
    return merge(RemixButtonStyle.border(value));
  }

  // Animate support
  RemixButtonStyle animate(AnimationConfig animation) {
    return merge(RemixButtonStyle(animation: animation));
  }

  RemixButton call({
    required String label,
    IconData? icon,
    bool enabled = true,
    bool loading = false,
    bool enableHapticFeedback = true,
    required VoidCallback? onPressed,
    FocusNode? focusNode,
  }) {
    return RemixButton(
      label: label,
      icon: icon,
      enabled: enabled,
      loading: loading,
      enableHapticFeedback: enableHapticFeedback,
      onPressed: onPressed,
      focusNode: focusNode,
      style: this,
    );
  }

  // Variant support
  @override
  RemixButtonStyle variant(Variant variant, RemixButtonStyle style) {
    return merge(RemixButtonStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixButtonStyle variants(List<VariantStyle<ButtonSpec>> value) {
    return merge(RemixButtonStyle(variants: value));
  }

  // Modifier support
  @override
  RemixButtonStyle wrap(ModifierConfig value) {
    return merge(RemixButtonStyle(modifier: value));
  }

  @override
  ButtonSpec resolve(BuildContext context) {
    return ButtonSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      spinner: MixOps.resolve(context, $spinner),
    );
  }

  @override
  RemixButtonStyle merge(RemixButtonStyle? other) {
    if (other == null) return this;

    return RemixButtonStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      spinner: MixOps.merge($spinner, other.$spinner),
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
        $spinner,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixButtonStyle = RemixButtonStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.all(10),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: Colors.black,
    ),
  ),
  label: RemixLabelStyle(
    spacing: 8,
    label: TextMix.color(Colors.white),
    icon: IconMix.color(Colors.white).size(18),
  ),
  spinner: RemixSpinnerStyle(
    size: 16,
    strokeWidth: 1.5,
    color: Colors.white,
    duration: const Duration(milliseconds: 1000),
    style: SpinnerStyleType.solid,
  ),
);

extension ButtonVariants on RemixButtonStyle {
  /// Primary button variant with blue background
  static RemixButtonStyle get primary => RemixButtonStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.blue[500],
          ),
        ),
        label: RemixLabelStyle(
          spacing: 8,
          label: TextMix.color(Colors.white),
          icon: IconMix.color(Colors.white).size(18),
        ),
      );

  /// Secondary button variant with grey background
  static RemixButtonStyle get secondary => RemixButtonStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.grey[600],
          ),
        ),
        label: RemixLabelStyle(
          spacing: 8,
          label: TextMix.color(Colors.white),
          icon: IconMix.color(Colors.white).size(18),
        ),
      );

  /// Success button variant with green background
  static RemixButtonStyle get success => RemixButtonStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.green[500],
          ),
        ),
        label: RemixLabelStyle(
          spacing: 8,
          label: TextMix.color(Colors.white),
          icon: IconMix.color(Colors.white).size(18),
        ),
      );

  /// Danger button variant with red background
  static RemixButtonStyle get danger => RemixButtonStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.red[500],
          ),
        ),
        label: RemixLabelStyle(
          spacing: 8,
          label: TextMix.color(Colors.white),
          icon: IconMix.color(Colors.white).size(18),
        ),
      );

  /// Ghost button variant with transparent background
  static RemixButtonStyle get ghost => RemixButtonStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.transparent,
          ),
        ),
        label: RemixLabelStyle(
          spacing: 8,
          label: TextMix.color(Colors.black),
          icon: IconMix.color(Colors.black).size(18),
        ),
      );

  /// Outline button variant with border
  static RemixButtonStyle get outline => RemixButtonStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.grey[400]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.transparent,
          ),
        ),
        label: RemixLabelStyle(
          spacing: 8,
          label: TextMix.color(Colors.black),
          icon: IconMix.color(Colors.black).size(18),
        ),
      );
}

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

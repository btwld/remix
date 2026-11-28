part of 'checkbox.dart';

/// Builds a [RemixCheckbox] indicator from the checkbox's value.
///
/// `value` is `true` when checked, `false` when unchecked, and `null` when a
/// tristate checkbox is indeterminate. `indicator` is the resolved indicator
/// style for the current state.
typedef RemixCheckboxIndicatorBuilder =
    Widget Function(
      BuildContext context,
      bool? value,
      StyleSpec<IconSpec> indicator,
    );

/// Resolved visual properties for a [RemixCheckbox].
@MixableSpec(
  target: RemixCheckbox.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin],
)
class CheckboxSpec with _$CheckboxSpec {
  /// Styling specification for the checkbox box container.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Styling specification for the checkbox indicator icon.
  @override
  final StyleSpec<IconSpec> indicator;

  /// Styling specification for the optional visible checkbox label.
  @override
  final StyleSpec<TextSpec> label;

  /// Gap between the checkbox box and its optional visible label.
  @override
  final double labelSpacing;

  /// Builds the indicator inside the box in every state, unchecked included.
  ///
  /// Because the builder's widget stays mounted when the value changes, it can
  /// animate its own mark in and out, or morph between the check and the dash.
  /// When set, it replaces the checkbox's `checkedIcon`, `uncheckedIcon` and
  /// `indeterminateIcon`. `null`, the default, shows the check or dash glyph
  /// while checked or indeterminate and nothing while unchecked.
  ///
  /// Pass a top-level or static function so that resolved specs compare equal
  /// across rebuilds.
  @override
  final RemixCheckboxIndicatorBuilder? indicatorBuilder;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  const CheckboxSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<TextSpec>? label,
    double? labelSpacing,
    this.containerEffects,
    this.indicatorBuilder,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       indicator = indicator ?? const StyleSpec(spec: IconSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       labelSpacing = labelSpacing ?? 8;

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  CheckboxSpec lerp(CheckboxSpec? other, double t) {
    if (other == null) return this;
    final generated = super.lerp(other, t);
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [CheckboxSpec].
///
/// The generated style API is based on [CheckboxSpec], so resolved values use
/// `CheckboxSpec` as their runtime type.
typedef RemixCheckboxSpec = CheckboxSpec;

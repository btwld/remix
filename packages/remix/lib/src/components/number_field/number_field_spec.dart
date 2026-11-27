part of 'number_field.dart';

/// Resolved values for a [RemixNumberField].
///
/// The field stacks [label], the [container] shell, and [helperText] in
/// [layout]. The shell is a row: the [decrement] control, the [field] editor,
/// and the [increment] control, [spacing] apart. [field] styles a
/// [RemixTextField] and is resolved under the shell's states, so it usually
/// carries text, cursor and alignment values and no frame of its own.
@MixableSpec(
  target: RemixNumberField.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin],
)
class NumberFieldSpec with _$NumberFieldSpec {
  /// The shell around the step controls and the editor.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Shadows and blends painted with [container].
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// The gap between the step controls and the editor.
  @override
  final double? spacing;

  /// The column that holds [label], the shell, and [helperText].
  @override
  final StyleSpec<FlexBoxSpec> layout;

  /// The editor inside the shell.
  @override
  final StyleSpec<TextFieldSpec> field;

  /// The control before the editor. It resolves under its own pressed,
  /// hovered and disabled states.
  @override
  final StyleSpec<NumberFieldStepSpec> decrement;

  /// The control after the editor. It resolves under its own pressed,
  /// hovered and disabled states.
  @override
  final StyleSpec<NumberFieldStepSpec> increment;

  /// The visible label above the shell.
  @override
  final StyleSpec<TextSpec> label;

  /// The helper text below the shell.
  @override
  final StyleSpec<TextSpec> helperText;

  const NumberFieldSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    this.spacing,
    StyleSpec<FlexBoxSpec>? layout,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<NumberFieldStepSpec>? decrement,
    StyleSpec<NumberFieldStepSpec>? increment,
    StyleSpec<TextSpec>? label,
    StyleSpec<TextSpec>? helperText,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       layout = layout ?? const StyleSpec(spec: FlexBoxSpec()),
       field = field ?? const StyleSpec(spec: TextFieldSpec()),
       decrement = decrement ?? const StyleSpec(spec: NumberFieldStepSpec()),
       increment = increment ?? const StyleSpec(spec: NumberFieldStepSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       helperText = helperText ?? const StyleSpec(spec: TextSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  NumberFieldSpec lerp(NumberFieldSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

typedef RemixNumberFieldSpec = NumberFieldSpec;

/// Resolved values for one step control of a [RemixNumberField].
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class NumberFieldStepSpec with _$NumberFieldStepSpec {
  /// The control's box.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Shadows and blends painted with [container].
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// The glyph. Its icon is used when the field names none; without either,
  /// the control draws a plus or minus sign as text in the icon's color and
  /// size.
  @override
  final StyleSpec<IconSpec> icon;

  /// Scales the glyph alone, inside a box that keeps its size.
  @override
  final double? iconScale;

  const NumberFieldStepSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    StyleSpec<IconSpec>? icon,
    this.iconScale,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  NumberFieldStepSpec lerp(NumberFieldStepSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

typedef RemixNumberFieldStepSpec = NumberFieldStepSpec;

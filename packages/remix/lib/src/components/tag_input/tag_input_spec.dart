part of 'tag_input.dart';

/// Resolved visual values for a [RemixTagInput].
///
/// [tag] holds an *unresolved* style. Each tag resolves it in its own state:
/// `selected` while the keyboard or a tap has picked it, and `disabled`. The
/// tag's [TagInputTagSpec.removeButton] is unresolved too, so the remove
/// button resolves against its own hover and press.
@MixableSpec(
  target: RemixTagInput.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin],
)
class TagInputSpec with _$TagInputSpec {
  /// The shell around the tags and the editor: background, border, radius,
  /// and padding.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// Horizontal gap between tags and the editor.
  @override
  final double? spacing;

  /// Vertical gap between wrapped rows.
  @override
  final double? runSpacing;

  /// The narrowest the editor gets before it wraps to its own row.
  @override
  final double? editorMinWidth;

  /// Typed text.
  @override
  final StyleSpec<TextSpec> text;

  /// Hint shown while there are no tags and no draft.
  @override
  final StyleSpec<TextSpec> hintText;

  @override
  final Color? cursorColor;

  @override
  final double? cursorWidth;

  @override
  final double? cursorHeight;

  /// Column around the label, the shell, and the helper text.
  @override
  final StyleSpec<FlexBoxSpec> layout;

  @override
  final StyleSpec<TextSpec> label;

  @override
  final StyleSpec<TextSpec> helperText;

  /// Unresolved style each tag resolves in its own state.
  @override
  final Style<TagInputTagSpec>? tag;

  const TagInputSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    this.spacing,
    this.runSpacing,
    this.editorMinWidth,
    StyleSpec<TextSpec>? text,
    StyleSpec<TextSpec>? hintText,
    this.cursorColor,
    this.cursorWidth,
    this.cursorHeight,
    StyleSpec<FlexBoxSpec>? layout,
    StyleSpec<TextSpec>? label,
    StyleSpec<TextSpec>? helperText,
    this.tag,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       hintText = hintText ?? const StyleSpec(spec: TextSpec()),
       layout = layout ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       helperText = helperText ?? const StyleSpec(spec: TextSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  TagInputSpec lerp(TagInputSpec? other, double t) {
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

/// Resolved visual values for one tag of a [RemixTagInput].
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin])
class TagInputTagSpec with _$TagInputTagSpec {
  /// The tag row holding the label and the remove button.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  @override
  final StyleSpec<TextSpec> label;

  /// Unresolved style the remove button resolves in its own state. Its icon
  /// slot styles the cross glyph.
  @override
  final Style<IconButtonSpec>? removeButton;

  const TagInputTagSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    this.removeButton,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());
}

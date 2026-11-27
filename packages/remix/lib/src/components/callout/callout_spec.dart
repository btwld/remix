part of 'callout.dart';

/// Resolved visual values for a [RemixCallout].
///
/// [closeButton] holds an *unresolved* style, which the callout hands to its
/// composed [RemixIconButton] through Mix's `StyleProvider` inheritance, so
/// the button resolves it against its own hover, focus, and press states.
@MixableSpec(
  target: RemixCallout.new,
  extraStylerMixins: [RemixBoxStylerMixin, IconStyleMixin],
)
class CalloutSpec with _$CalloutSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  /// The message, or the description under [title].
  @override
  final StyleSpec<TextSpec> text;
  @override
  final StyleSpec<IconSpec> icon;

  /// The heading above [text], shown when [RemixCallout.title] is set.
  @override
  final StyleSpec<TextSpec> title;

  /// The column holding [title] and [text] when the callout has a title.
  @override
  final StyleSpec<FlexBoxSpec> content;

  /// Unresolved style inherited by the composed dismiss button.
  @override
  final Style<IconButtonSpec>? closeButton;
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  const CalloutSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
    this.containerEffects,
    StyleSpec<TextSpec>? title,
    StyleSpec<FlexBoxSpec>? content,
    this.closeButton,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       text = text ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       content = content ?? const StyleSpec(spec: FlexBoxSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  CalloutSpec lerp(CalloutSpec? other, double t) {
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

/// Backward-compatible name for [CalloutSpec].
///
/// The generated style API is based on [CalloutSpec], so resolved values use
/// `CalloutSpec` as their runtime type.
typedef RemixCalloutSpec = CalloutSpec;
